Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7155476785
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 02:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhLPBsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 20:48:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35312 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhLPBsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 20:48:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DCC861B65;
        Thu, 16 Dec 2021 01:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9940C36AE1;
        Thu, 16 Dec 2021 01:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639619300;
        bh=9nSl+p6c7ECaJOl+DQXpI//VnRBSFhMh+RaPVD0BS58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sAwc/VuBezb6B3udkJsdyOxTnFNsqTZ6ziwFi6SYftmKTrNeQwgmz5ZGm8x1jCLk2
         j2vvgXTqEvycD+w2fyxhLtzGp81COyHRDPsONsYTmg/z5xHv7gbeR8/EIfggS5DKVE
         EE/uibNZ+FiRXjCw9cKuKvJCBjzxv/mbY1ueex3dSxr1qvsbsimjNfniIJGq5OHWUN
         VOhKg+Hydj4fnzVO4NpsWMK/gSMs3Ts5t6i6Kp2SG3sr1/0Eqy74LCOEgy+vDZBwYB
         D6bowAfr6K2/B76xoumzdcau0uMj7e/+lHOULnDVIHr9UbyCvcsWVwgLwid/qJqUde
         G+n934l6cHJ4Q==
Date:   Wed, 15 Dec 2021 17:48:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible
 UAF
Message-ID: <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211214215732.1507504-2-lee.jones@linaro.org>
References: <20211214215732.1507504-1-lee.jones@linaro.org>
        <20211214215732.1507504-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> The cause of the resultant dump_stack() reported below is a
> dereference of a freed pointer to 'struct sctp_endpoint' in
> sctp_sock_dump().
> 
> This race condition occurs when a transport is cached into its
> associated hash table followed by an endpoint/sock migration to a new
> association in sctp_assoc_migrate() prior to their subsequent use in
> sctp_diag_dump() which uses sctp_for_each_transport() to walk the hash
> table calling into sctp_sock_dump() where the dereference occurs.
> 
>   BUG: KASAN: use-after-free in sctp_sock_dump+0xa8/0x438 [sctp_diag]
>   Call trace:
>    dump_backtrace+0x0/0x2dc
>    show_stack+0x20/0x2c
>    dump_stack+0x120/0x144
>    print_address_description+0x80/0x2f4
>    __kasan_report+0x174/0x194
>    kasan_report+0x10/0x18
>    __asan_load8+0x84/0x8c
>    sctp_sock_dump+0xa8/0x438 [sctp_diag]
>    sctp_for_each_transport+0x1e0/0x26c [sctp]
>    sctp_diag_dump+0x180/0x1f0 [sctp_diag]
>    inet_diag_dump+0x12c/0x168
>    netlink_dump+0x24c/0x5b8
>    __netlink_dump_start+0x274/0x2a8
>    inet_diag_handler_cmd+0x224/0x274
>    sock_diag_rcv_msg+0x21c/0x230
>    netlink_rcv_skb+0xe0/0x1bc
>    sock_diag_rcv+0x34/0x48
>    netlink_unicast+0x3b4/0x430
>    netlink_sendmsg+0x4f0/0x574
>    sock_write_iter+0x18c/0x1f0
>    do_iter_readv_writev+0x230/0x2a8
>    do_iter_write+0xc8/0x2b4
>    vfs_writev+0xf8/0x184
>    do_writev+0xb0/0x1a8
>    __arm64_sys_writev+0x4c/0x5c
>    el0_svc_common+0x118/0x250
>    el0_svc_handler+0x3c/0x9c
>    el0_svc+0x8/0xc
> 
> To prevent this from happening we need to take a references to the
> to-be-used/dereferenced 'struct sock' and 'struct sctp_endpoint's
> until such a time when we know it can be safely released.
> 
> When KASAN is not enabled, a similar, but slightly different NULL
> pointer derefernce crash occurs later along the thread of execution in
> inet_sctp_diag_fill() this time.

Are you able to identify where the bug was introduced? Fixes tag would
be good to have here. 

You should squash the two patches together.

> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index 760b367644c12..2029b240b6f24 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -301,6 +301,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
>  	struct sctp_association *assoc;
>  	int err = 0;
>  
> +	sctp_endpoint_hold(ep);
> +	sock_hold(sk);
>  	lock_sock(sk);
>  	list_for_each_entry(assoc, &ep->asocs, asocs) {
>  		if (cb->args[4] < cb->args[1])
> @@ -341,6 +343,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
>  	cb->args[4] = 0;
>  release:
>  	release_sock(sk);
> +	sock_put(sk);
> +	sctp_endpoint_put(ep);
>  	return err;
>  }
>  

