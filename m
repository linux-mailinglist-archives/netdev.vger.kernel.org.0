Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BC956B13D
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiGHEHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGHEHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:07:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66872735A4;
        Thu,  7 Jul 2022 21:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D303B824E6;
        Fri,  8 Jul 2022 04:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A088C341C0;
        Fri,  8 Jul 2022 04:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657253215;
        bh=Ke4DwaCsuPbstd+T4rJltzStOJWw1pt+/FoZ/dvuvf8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uTQSe8CbTJSAvsiHj0s5aFZoj672efoG5O0ION/0Moqzx8wuia3758JOxDaJqvSdk
         pb9LUQX9aPKP3uPa9C8cnG7kzxNOhqzqGdAYMbWMInVyjdQjl0R4HQEIjQcWysKYXZ
         YwP5RHy++322JVqA6G5qMrn6tGu1g1Y8h9XPxa1urgp55o79hPaNN99P2tRTmgrpG/
         qQozbkODcWLhQnBgjHyTMSkPJRf0IV1BZcXYtoAw/dkMBB1jHsODD4mhux2eBvJ/nz
         p1JXBbvvPMzmck/6UocWaogbQVJP8pA4rPRMg10twSzp7L2CqHk6XnkMgTf8Z+W/qi
         egMwWIAxA5CzQ==
Message-ID: <62e1daba-fb20-bf20-5c4d-c31770e5420e@kernel.org>
Date:   Thu, 7 Jul 2022 22:06:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 11/27] tcp: support externally provided ubufs
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <7ee05f644e3b3626b693973738364bcb23cf905d.1657194434.git.asml.silence@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <7ee05f644e3b3626b693973738364bcb23cf905d.1657194434.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/22 5:49 AM, Pavel Begunkov wrote:
> Teach ipv4/udp how to use external ubuf_info provided in msghdr and

ipv4/tcp?

> also prepare it for managed frags by sprinkling
> skb_zcopy_downgrade_managed() when it could mix managed and not managed
> frags.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/ipv4/tcp.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 390eb3dc53bd..a81f694af5e9 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1223,17 +1223,23 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  
>  	flags = msg->msg_flags;
>  
> -	if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {
> +	if ((flags & MSG_ZEROCOPY) && size) {
>  		skb = tcp_write_queue_tail(sk);
> -		uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
> -		if (!uarg) {
> -			err = -ENOBUFS;
> -			goto out_err;
> -		}
>  
> -		zc = sk->sk_route_caps & NETIF_F_SG;
> -		if (!zc)
> -			uarg->zerocopy = 0;
> +		if (msg->msg_ubuf) {
> +			uarg = msg->msg_ubuf;
> +			net_zcopy_get(uarg);
> +			zc = sk->sk_route_caps & NETIF_F_SG;
> +		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
> +			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
> +			if (!uarg) {
> +				err = -ENOBUFS;
> +				goto out_err;
> +			}
> +			zc = sk->sk_route_caps & NETIF_F_SG;
> +			if (!zc)
> +				uarg->zerocopy = 0;
> +		}
>  	}
>  
>  	if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) &&
> @@ -1356,9 +1362,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  
>  			copy = min_t(int, copy, pfrag->size - pfrag->offset);
>  
> -			if (tcp_downgrade_zcopy_pure(sk, skb))
> -				goto wait_for_space;
> -
> +			if (unlikely(skb_zcopy_pure(skb) || skb_zcopy_managed(skb))) {
> +				if (tcp_downgrade_zcopy_pure(sk, skb))
> +					goto wait_for_space;
> +				skb_zcopy_downgrade_managed(skb);
> +			}
>  			copy = tcp_wmem_schedule(sk, copy);
>  			if (!copy)
>  				goto wait_for_space;

You dropped the msg->msg_ubuf checks on jump labels. Removing the one
you had at 'out_nopush' I agree with based on my tests (i.e, it is not
needed).

The one at 'out_err' seems like it is needed - but it has been a few
weeks since I debugged that case. I believe the error path I was hitting
was sk_stream_wait_memory with MSG_DONTWAIT flag set meaning timeout is
0 and it jumps there with EPIPE.


