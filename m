Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA86257901F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiGSByT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGSByS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:54:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DACBBF;
        Mon, 18 Jul 2022 18:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A338B816F8;
        Tue, 19 Jul 2022 01:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EC8C341C0;
        Tue, 19 Jul 2022 01:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658195654;
        bh=VH1DJCOtG1ThKB2ErFVdW1lYff4nEUEBBrcKbOBgThY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lFysAK4aT/3fpJnKtGvM5QvheEAlgj7BC3uuGZJHw8f57GQPn1p0k6KAAQYi67gnd
         u4DqFmGX36mTQfRDh1g0SyWfw1StV+34MlBuh24wnc95yoNdtI287egvKzMglCv0IK
         0/dJ9wvTAh0NQz7+vee6QfgMxvrMAQKiCE3Ku2oR2rHtWYI1DdGts72ZeGTERbUKLl
         lp/GKOD1tPHeLOJ8zjUTtduXKlRUnchuUrg6zodT6EkV0Uo+u6RAuBno5Sr3UXu9WE
         j8tcmky/HiqNiIrTj99ncQnEv6XLYMIrXonsNlRmRu7rqFfa+b676WcV2WKm3UBXEw
         NIAWths5wTGcg==
Date:   Mon, 18 Jul 2022 18:54:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v5 01/27] ipv4: avoid partial copy for zc
Message-ID: <20220718185413.0f393c91@kernel.org>
In-Reply-To: <0eb1cb5746e9ac938a7ba7848b33ccf680d30030.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
        <0eb1cb5746e9ac938a7ba7848b33ccf680d30030.1657643355.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 21:52:25 +0100 Pavel Begunkov wrote:
> Even when zerocopy transmission is requested and possible,
> __ip_append_data() will still copy a small chunk of data just because it
> allocated some extra linear space (e.g. 148 bytes). It wastes CPU cycles
> on copy and iter manipulations and also misalignes potentially aligned
> data. Avoid such coies. And as a bonus we can allocate smaller skb.

s/coies/copies/ can fix when applying

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/ipv4/ip_output.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 00b4bf26fd93..581d1e233260 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -969,7 +969,6 @@ static int __ip_append_data(struct sock *sk,
>  	struct inet_sock *inet = inet_sk(sk);
>  	struct ubuf_info *uarg = NULL;
>  	struct sk_buff *skb;
> -
>  	struct ip_options *opt = cork->opt;
>  	int hh_len;
>  	int exthdrlen;
> @@ -977,6 +976,7 @@ static int __ip_append_data(struct sock *sk,
>  	int copy;
>  	int err;
>  	int offset = 0;
> +	bool zc = false;
>  	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
>  	int csummode = CHECKSUM_NONE;
>  	struct rtable *rt = (struct rtable *)cork->dst;
> @@ -1025,6 +1025,7 @@ static int __ip_append_data(struct sock *sk,
>  		if (rt->dst.dev->features & NETIF_F_SG &&
>  		    csummode == CHECKSUM_PARTIAL) {
>  			paged = true;
> +			zc = true;
>  		} else {
>  			uarg->zerocopy = 0;
>  			skb_zcopy_set(skb, uarg, &extra_uref);
> @@ -1091,9 +1092,12 @@ static int __ip_append_data(struct sock *sk,
>  				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
>  				  !(rt->dst.dev->features & NETIF_F_SG)))
>  				alloclen = fraglen;
> -			else {
> +			else if (!zc) {
>  				alloclen = min_t(int, fraglen, MAX_HEADER);

Willem, I think this came in with your GSO work, is there a reason we
use MAX_HEADER here? I thought MAX_HEADER is for headers (i.e. more or
less to be reserved) not for the min amount of data to be included.

I wanna make sure we're not missing something about GSO here.

Otherwise I don't think we need the extra branch but that can 
be a follow up.

>  				pagedlen = fraglen - alloclen;
> +			} else {
> +				alloclen = fragheaderlen + transhdrlen;
> +				pagedlen = datalen - transhdrlen;
>  			}
>  
>  			alloclen += alloc_extra;

