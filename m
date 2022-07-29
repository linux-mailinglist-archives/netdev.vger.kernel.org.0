Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A42584A07
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 05:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbiG2DBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 23:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiG2DBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 23:01:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E1F68DD8;
        Thu, 28 Jul 2022 20:01:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B849BB82654;
        Fri, 29 Jul 2022 03:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF18C433C1;
        Fri, 29 Jul 2022 03:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659063700;
        bh=K9tSEvBx+Ax+pmKxs7VgEeb1Jgj1kHaH3v9iA8cO8RE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CJom+OLYBCyBvYOCfegifO3qIzV4jzkcq+ltNrljOz0V8viWKDPdo1tO/DoFaw97b
         Vka7xYX9f8ZxWeu3ZBsb6aQH2bx8Do/jz+XV4OnCw0VZ76jVT2OuRh5+55yd9z+iuM
         YXz2JiQ8g/hO5XVDkiM6aSJp+o+Dv9Z4nzwHFJJCe/yI12Y8cRwQAZ47Nbnzk35PNX
         DGGu++wPnLDeQiu50pXDT6esOfuYxkAC4Z/pv1YiSfZ52xpAXViTLsft0DUYqj0PBX
         gachM9QO+1xDZrDIQnk+v+8utXjRQGH14RTcFuV+mTGTd6uvGQsxr6VlNDx1pVc6op
         LECXvg4GV1jww==
Date:   Thu, 28 Jul 2022 20:01:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.co.jp, richard_siegfried@systemli.org,
        joannelkoong@gmail.com, socketcan@hartkopp.net,
        gerrit@erg.abdn.ac.uk, tomasz@grobelny.oswiecenia.net,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push()
 in the same lock
Message-ID: <20220728200139.1e7d9bc6@kernel.org>
In-Reply-To: <20220727080609.26532-1-hbh25y@gmail.com>
References: <20220727080609.26532-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 16:06:09 +0800 Hangyu Hua wrote:
> In the case of sk->dccps_qpolicy == DCCPQ_POLICY_PRIO, dccp_qpolicy_full
> will drop a skb when qpolicy is full. And the lock in dccp_sendmsg is
> released before sock_alloc_send_skb and then relocked after
> sock_alloc_send_skb. The following conditions may lead dccp_qpolicy_push
> to add skb to an already full sk_write_queue:
> 
> thread1--->lock
> thread1--->dccp_qpolicy_full: queue is full. drop a skb

This linie should say "not full"?

> thread1--->unlock
> thread2--->lock
> thread2--->dccp_qpolicy_full: queue is not full. no need to drop.
> thread2--->unlock
> thread1--->lock
> thread1--->dccp_qpolicy_push: add a skb. queue is full.
> thread1--->unlock
> thread2--->lock
> thread2--->dccp_qpolicy_push: add a skb!
> thread2--->unlock
> 
> Fix this by moving dccp_qpolicy_full.
> 
> Fixes: 871a2c16c21b ("dccp: Policy-based packet dequeueing infrastructure")

This code was added in b1308dc015eb0, AFAICT. Please double check.

> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/dccp/proto.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index eb8e128e43e8..1a0193823c82 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -736,11 +736,6 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  
>  	lock_sock(sk);
>  
> -	if (dccp_qpolicy_full(sk)) {
> -		rc = -EAGAIN;
> -		goto out_release;
> -	}
> -
>  	timeo = sock_sndtimeo(sk, noblock);
>  
>  	/*
> @@ -773,6 +768,11 @@ int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  	if (rc != 0)
>  		goto out_discard;
>  
> +	if (dccp_qpolicy_full(sk)) {
> +		rc = -EAGAIN;
> +		goto out_discard;
> +	}

Shouldn't this be earlier, right after relocking? Why copy the data etc.
if we know the queue is full?

>  	dccp_qpolicy_push(sk, skb);
>  	/*
>  	 * The xmit_timer is set if the TX CCID is rate-based and will expire

