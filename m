Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11B52D1C24
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgLGV3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgLGV3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 16:29:51 -0500
Date:   Mon, 7 Dec 2020 13:29:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607376550;
        bh=sUEJVq7kGmrNoN5PGneCN8DKT2e5866wP7ixRZpE5fc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=SGjduZ0Cf0GVXkup+jtmQoMdEXn2nIiccClY+UVSLogIuX0Buwqqa5etqcJpPraLe
         cVGPsuEqZWZSvznA7z7gA4OYPh3Gj25hiDRMHFE8w1HO0pgMFjLYw9JU6/JqInNbg3
         Ld9KEgzpUAYeNWouunzdAtoxUIswhAzdroCMfCTjALWS7pTlOuaePIVO5wdHPjXNGA
         ot0aUXzr1obRA15n1FrKBHE0s8kS/4AUhRlxOcoTD8VXYLWOGwdmZZBxswKOvv71yC
         4fSQdarvdIqRHSDO2I510xIJe0/mQPPchK5yd4fZBnnfRUy5QM1Pe/rps/PE9mUt5y
         IxOvUvOpHUScw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
 vsock address data structure
Message-ID: <20201207132908.130a5f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204170235.84387-2-andraprs@amazon.com>
References: <20201204170235.84387-1-andraprs@amazon.com>
        <20201204170235.84387-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 19:02:32 +0200 Andra Paraschiv wrote:
> diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
> index fd0ed7221645d..46735376a57a8 100644
> --- a/include/uapi/linux/vm_sockets.h
> +++ b/include/uapi/linux/vm_sockets.h
> @@ -145,7 +145,7 @@
>  
>  struct sockaddr_vm {
>  	__kernel_sa_family_t svm_family;
> -	unsigned short svm_reserved1;
> +	unsigned short svm_flags;
>  	unsigned int svm_port;
>  	unsigned int svm_cid;
>  	unsigned char svm_zero[sizeof(struct sockaddr) -

Since this is a uAPI header I gotta ask - are you 100% sure that it's
okay to rename this field?

I didn't grasp from just reading the patches whether this is a uAPI or
just internal kernel flag, seems like the former from the reading of
the comment in patch 2. In which case what guarantees that existing
users don't pass in garbage since the kernel doesn't check it was 0?
