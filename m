Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE03EA9D9
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 20:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbhHLSAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 14:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231547AbhHLSAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 14:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E47E960EFE;
        Thu, 12 Aug 2021 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628791189;
        bh=5NlNRK7GbGfOxlxibHmrBh/2i8xLoUExwx+XWk8jif4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b4gFh/vNbIpYfa+B9kFQ5iwm47A44iZiC5sZJGmAHZBp5Vm0/Zf+IcoOcw5IKKJnH
         Gv6sOPCzAmERu+D5U05I2GR9KhYtZfB+HvlvYFochnj2PHEMGH/IGmxhdp1ZX01lpa
         0q85A+07Q3Ffa29iVp7tAUB8warzmSt8AZdygnSUhMXbyCkTAXISx6yhNhPduYSC9q
         Q4n50MG2dSN+iN9LvW104M/FJHYON3S+G24gH072Sx/i+ZwT8TfjnR/eRtKUl4kzww
         GqOvocImKM4nOOadr16eodPgbye4Q/809dsMkCnYpuHJ+ueJ5eoIYZfxzbnbOqPegq
         dDUGn0AtYvxsQ==
Date:   Thu, 12 Aug 2021 10:59:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Longpeng(Mike)" <longpeng2@huawei.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        arei.gonglei@huawei.com, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH resend] vsock/virtio: avoid potential deadlock when
 vsock device remove
Message-ID: <20210812105948.013eb67e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812080332.o4vxw72gn5uuqtik@steredhat>
References: <20210812053056.1699-1-longpeng2@huawei.com>
        <20210812080332.o4vxw72gn5uuqtik@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 10:03:32 +0200 Stefano Garzarella wrote:
> On Thu, Aug 12, 2021 at 01:30:56PM +0800, Longpeng(Mike) wrote:
> >There's a potential deadlock case when remove the vsock device or
> >process the RESET event:
> >
> >  vsock_for_each_connected_socket:
> >      spin_lock_bh(&vsock_table_lock) ----------- (1)
> >      ...
> >          virtio_vsock_reset_sock:
> >              lock_sock(sk) --------------------- (2)
> >      ...
> >      spin_unlock_bh(&vsock_table_lock)
> >
> >lock_sock() may do initiative schedule when the 'sk' is owned by
> >other thread at the same time, we would receivce a warning message
> >that "scheduling while atomic".
> >
> >Even worse, if the next task (selected by the scheduler) try to
> >release a 'sk', it need to request vsock_table_lock and the deadlock
> >occur, cause the system into softlockup state.
> >  Call trace:
> >   queued_spin_lock_slowpath
> >   vsock_remove_bound
> >   vsock_remove_sock
> >   virtio_transport_release
> >   __vsock_release
> >   vsock_release
> >   __sock_release
> >   sock_close
> >   __fput
> >   ____fput
> >
> >So we should not require sk_lock in this case, just like the behavior
> >in vhost_vsock or vmci.  
>
> We should add:
> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")

Added.

> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

And applied, thanks!
