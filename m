Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20B52D8891
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392633AbgLLRQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgLLRQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 12:16:50 -0500
Date:   Sat, 12 Dec 2020 09:16:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607793369;
        bh=XrZ3SkdZkwNPnvdfbGpcsT1lUiu+dUH3jlsfn2RS6LM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=THusHGsj1esasoCiQQ0uX2J7YLMa6Xwj3OCo9DektnVnAZgN+KuissSwcD+TSmrj7
         GdB+PVHxn6M8RBKU1fJJK6xcBEn1S5aCE99+5OJfr/rHtNlNgGgqtzZMiCx8qOQlqR
         vheEcRpgdIUuCroMzmdLZTPzxy2IYKWUAUQL7a7IRz8UC17s+yCsNi5LPawhMvkC5s
         5JnCF/sYUMhKHHA0f17jEcCM3rPJPnjXNc2BTx0m7nRvj1TdrLqHlI7GycuZTmpRE0
         jzSXKPZlfQO5be8LAF7JVEnNyMLqc4fFS5B46ZNjY5fgfNGfhaumb1iRwaIwzqGHDE
         mahh7PVw6GqxA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Andra Paraschiv <andraprs@amazon.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v3 0/4] vsock: Add flags field in the vsock
 address
Message-ID: <20201212091608.4ffd1154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211152413.iezrw6qswzhpfa3j@steredhat>
References: <20201211103241.17751-1-andraprs@amazon.com>
        <20201211152413.iezrw6qswzhpfa3j@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 16:24:13 +0100 Stefano Garzarella wrote:
> On Fri, Dec 11, 2020 at 12:32:37PM +0200, Andra Paraschiv wrote:
> >vsock enables communication between virtual machines and the host they are
> >running on. Nested VMs can be setup to use vsock channels, as the multi
> >transport support has been available in the mainline since the v5.5 Linux kernel
> >has been released.
> >
> >Implicitly, if no host->guest vsock transport is loaded, all the vsock packets
> >are forwarded to the host. This behavior can be used to setup communication
> >channels between sibling VMs that are running on the same host. One example can
> >be the vsock channels that can be established within AWS Nitro Enclaves
> >(see Documentation/virt/ne_overview.rst).
> >
> >To be able to explicitly mark a connection as being used for a certain use case,
> >add a flags field in the vsock address data structure. The value of the flags
> >field is taken into consideration when the vsock transport is assigned. This way
> >can distinguish between different use cases, such as nested VMs / local
> >communication and sibling VMs.
> >
> >The flags field can be set in the user space application connect logic. On the
> >listen path, the field can be set in the kernel space logic.
> >  
> 
> I reviewed all the patches and they are in a good shape!
> 
> Maybe the last thing to add is a flags check in the 
> vsock_addr_validate(), to avoid that flags that we don't know how to 
> handle are specified.
> For example if in the future we add new flags that this version of the 
> kernel is not able to satisfy, we should return an error to the 
> application.
> 
> I mean something like this:
> 
>      diff --git a/net/vmw_vsock/vsock_addr.c b/net/vmw_vsock/vsock_addr.c
>      index 909de26cb0e7..73bb1d2fa526 100644
>      --- a/net/vmw_vsock/vsock_addr.c
>      +++ b/net/vmw_vsock/vsock_addr.c
>      @@ -22,6 +22,8 @@ EXPORT_SYMBOL_GPL(vsock_addr_init);
>       
>       int vsock_addr_validate(const struct sockaddr_vm *addr)
>       {
>      +       unsigned short svm_valid_flags = VMADDR_FLAG_TO_HOST;
>      +
>              if (!addr)
>                      return -EFAULT;
>       
>      @@ -31,6 +33,9 @@ int vsock_addr_validate(const struct sockaddr_vm *addr)
>              if (addr->svm_zero[0] != 0)
>                      return -EINVAL;

Strictly speaking this check should be superseded by the check below
(AKA removed). We used to check svm_zero[0], with the new field added
this now checks svm_zero[2]. Old applications may have not initialized
svm_zero[2] (we're talking about binary compatibility here, apps built
with old headers).

>      +       if (addr->svm_flags & ~svm_valid_flags)
>      +               return -EINVAL;

The flags should also probably be one byte (we can define a "more
flags" flag to unlock further bytes) - otherwise on big endian the 
new flag will fall into svm_zero[1] so the v3 improvements are moot 
for big endian, right?

>              return 0;
>       }
>       EXPORT_SYMBOL_GPL(vsock_addr_validate);
