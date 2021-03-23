Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E0B3457D2
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 07:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCWGcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 02:32:25 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3377 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCWGb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 02:31:57 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4F4M0N19v3z5gRJ;
        Tue, 23 Mar 2021 14:29:24 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 23 Mar 2021 14:31:53 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 23 Mar
 2021 14:31:53 +0800
Subject: Re: [Patch bpf-next v6 08/12] udp: implement ->read_sock() for
 sockmap
To:     Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <duanxiongchun@bytedance.com>,
        <wangdongdong.6@bytedance.com>, <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
 <20210323003808.16074-9-xiyou.wangcong@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b510f1da-1442-5297-db95-e21ac8b71042@huawei.com>
Date:   Tue, 23 Mar 2021 14:31:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210323003808.16074-9-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/23 8:38, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This is similar to tcp_read_sock(), except we do not need
> to worry about connections, we just need to retrieve skb
> from UDP receive queue.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/net/udp.h   |  2 ++
>  net/ipv4/af_inet.c  |  1 +
>  net/ipv4/udp.c      | 35 +++++++++++++++++++++++++++++++++++
>  net/ipv6/af_inet6.c |  1 +
>  4 files changed, 39 insertions(+)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index df7cc1edc200..347b62a753c3 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -329,6 +329,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
>  			       struct sk_buff *skb);
>  struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
>  				 __be16 sport, __be16 dport);
> +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		  sk_read_actor_t recv_actor);
>  
>  /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
>   * possibly multiple cache miss on dequeue()
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 1355e6c0d567..f17870ee558b 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1070,6 +1070,7 @@ const struct proto_ops inet_dgram_ops = {
>  	.setsockopt	   = sock_common_setsockopt,
>  	.getsockopt	   = sock_common_getsockopt,
>  	.sendmsg	   = inet_sendmsg,
> +	.read_sock	   = udp_read_sock,
>  	.recvmsg	   = inet_recvmsg,
>  	.mmap		   = sock_no_mmap,
>  	.sendpage	   = inet_sendpage,
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 38952aaee3a1..a0adee3b1af4 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1782,6 +1782,41 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
>  }
>  EXPORT_SYMBOL(__skb_recv_udp);
>  
> +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		  sk_read_actor_t recv_actor)
> +{
> +	int copied = 0;
> +
> +	while (1) {
> +		int offset = 0, err;
> +		struct sk_buff *skb;
> +
> +		skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
> +		if (!skb)
> +			break;

Does above error handling need the below additional handling?
It seems __skb_recv_udp() will return the error by parameter "err",
if "copied == 0", does it need to return the error?

if (!skb) {
	if (!copied)
		copied = err;

	break;
}

> +		if (offset < skb->len) {
> +			int used;
> +			size_t len;
> +
> +			len = skb->len - offset;
> +			used = recv_actor(desc, skb, offset, len);
> +			if (used <= 0) {
> +				if (!copied)
> +					copied = used;
> +				break;

As here it seems handling the "copied == 0" error case.

> +			} else if (used <= len) {
> +				copied += used;
> +				offset += used;
> +			}
> +		}
> +		if (!desc->count)
> +			break;
> +	}
> +
> +	return copied;
> +}
> +EXPORT_SYMBOL(udp_read_sock);
> +
>  /*
>   * 	This should be easy, if there is something there we
>   * 	return it, otherwise we block.
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index 802f5111805a..71de739b4a9e 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -714,6 +714,7 @@ const struct proto_ops inet6_dgram_ops = {
>  	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
>  	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
>  	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
> +	.read_sock	   = udp_read_sock,
>  	.mmap		   = sock_no_mmap,
>  	.sendpage	   = sock_no_sendpage,
>  	.set_peek_off	   = sk_set_peek_off,
> 

