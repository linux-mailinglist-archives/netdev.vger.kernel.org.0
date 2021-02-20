Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCE8320772
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 22:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhBTVox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 16:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBTVov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 16:44:51 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C88C061574
        for <netdev@vger.kernel.org>; Sat, 20 Feb 2021 13:44:11 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A33A64D2D7D88;
        Sat, 20 Feb 2021 13:44:09 -0800 (PST)
Date:   Sat, 20 Feb 2021 13:44:02 -0800 (PST)
Message-Id: <20210220.134402.2070871604757928182.davem@davemloft.net>
To:     redsky110@gmail.com
Cc:     edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: avoid unnecessary loop if even ports are used up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210220110356.84399-1-redsky110@gmail.com>
References: <20210220110356.84399-1-redsky110@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sat, 20 Feb 2021 13:44:09 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Honglei Wang <redsky110@gmail.com>
Date: Sat, 20 Feb 2021 19:03:56 +0800

> We are getting port for connect() from even ports firstly now. This
> makes bind() users have more available slots at odd part. But there is a
> problem here when the even ports are used up. This happens when there
> is a flood of short life cycle connections. In this scenario, it starts
> getting ports from the odd part, but each requirement has to walk all of
> the even port and the related hash buckets (it probably gets nothing
> before the workload pressure's gone) before go to the odd part. This
> makes the code path __inet_hash_connect()->__inet_check_established()
> and the locks there hot.
> 
> This patch tries to improve the strategy so we can go faster when the
> even part is used up. It'll record the last gotten port was odd or even,
> if it's an odd one, it means there is no available even port for us and
> we probably can't get an even port this time, neither. So we just walk
> 1/16 of the whole even ports. If we can get one in this way, it probably
> means there are more available even part, we'll go back to the old
> strategy and walk all of them when next connect() comes. If still can't
> get even port in the 1/16 part, we just go to the odd part directly and
> avoid doing unnecessary loop.
> 
> Signed-off-by: Honglei Wang <redsky110@gmail.com>
> ---
>  net/ipv4/inet_hashtables.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 45fb450b4522..c95bf5cf9323 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -721,9 +721,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  	struct net *net = sock_net(sk);
>  	struct inet_bind_bucket *tb;
>  	u32 remaining, offset;
> -	int ret, i, low, high;
> +	int ret, i, low, high, span;
>  	static u32 hint;
>  	int l3mdev;
> +	static bool last_port_is_odd;
>  
>  	if (port) {
>  		head = &hinfo->bhash[inet_bhashfn(net, port,
> @@ -756,8 +757,19 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  	 */
>  	offset &= ~1U;
>  other_parity_scan:
> +	/* If the last available port is odd, it means
> +	 * we walked all of the even ports, but got
> +	 * nothing last time. It's telling us the even
> +	 * part is busy to get available port. In this
> +	 * case, we can go a bit faster.
> +	 */
> +	if (last_port_is_odd && !(offset & 1) && remaining > 32)

The first time this executes, won't last_port_is_odd be uninitialized?
