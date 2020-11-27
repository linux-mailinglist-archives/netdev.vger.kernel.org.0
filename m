Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AA12C6CE7
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgK0VbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:31:09 -0500
Received: from www62.your-server.de ([213.133.104.62]:36840 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgK0V37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 16:29:59 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kilJD-0003hM-2h; Fri, 27 Nov 2020 22:29:39 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kilJC-000JbS-Nu; Fri, 27 Nov 2020 22:29:38 +0100
Subject: Re: [PATCH bpf v2 2/2] xsk: change the tx writeable condition
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, magnus.karlsson@gmail.com
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP SOCKETS (AF_XDP)" <netdev@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
 <cover.1606285978.git.xuanzhuo@linux.alibaba.com>
 <4fd58d473f4548dc6e9e24ea9876c802d5d584b4.1606285978.git.xuanzhuo@linux.alibaba.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <15bae73e-e753-123a-7535-0ab5c1178b40@iogearbox.net>
Date:   Fri, 27 Nov 2020 22:29:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4fd58d473f4548dc6e9e24ea9876c802d5d584b4.1606285978.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26001/Fri Nov 27 14:45:56 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/20 7:48 AM, Xuan Zhuo wrote:
> Modify the tx writeable condition from the queue is not full to the
> number of present tx queues is less than the half of the total number
> of queues. Because the tx queue not full is a very short time, this will
> cause a large number of EPOLLOUT events, and cause a large number of
> process wake up.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

This one doesn't apply cleanly against bpf tree, please rebase. Small comment
inline while looking over the patch:

> ---
>   net/xdp/xsk.c       | 16 +++++++++++++---
>   net/xdp/xsk_queue.h |  6 ++++++
>   2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 0df8651..22e35e9 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -211,6 +211,14 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
>   	return 0;
>   }
>   
> +static bool xsk_tx_writeable(struct xdp_sock *xs)
> +{
> +	if (xskq_cons_present_entries(xs->tx) > xs->tx->nentries / 2)
> +		return false;
> +
> +	return true;
> +}
> +
>   static bool xsk_is_bound(struct xdp_sock *xs)
>   {
>   	if (READ_ONCE(xs->state) == XSK_BOUND) {
> @@ -296,7 +304,8 @@ void xsk_tx_release(struct xsk_buff_pool *pool)
>   	rcu_read_lock();
>   	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
>   		__xskq_cons_release(xs->tx);
> -		xs->sk.sk_write_space(&xs->sk);
> +		if (xsk_tx_writeable(xs))
> +			xs->sk.sk_write_space(&xs->sk);
>   	}
>   	rcu_read_unlock();
>   }
> @@ -499,7 +508,8 @@ static int xsk_generic_xmit(struct sock *sk)
>   
>   out:
>   	if (sent_frame)
> -		sk->sk_write_space(sk);
> +		if (xsk_tx_writeable(xs))
> +			sk->sk_write_space(sk);
>   
>   	mutex_unlock(&xs->mutex);
>   	return err;
> @@ -556,7 +566,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>   
>   	if (xs->rx && !xskq_prod_is_empty(xs->rx))
>   		mask |= EPOLLIN | EPOLLRDNORM;
> -	if (xs->tx && !xskq_cons_is_full(xs->tx))
> +	if (xs->tx && xsk_tx_writeable(xs))
>   		mask |= EPOLLOUT | EPOLLWRNORM;
>   
>   	return mask;
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index b936c46..b655004 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -307,6 +307,12 @@ static inline bool xskq_cons_is_full(struct xsk_queue *q)
>   		q->nentries;
>   }
>   
> +static inline __u64 xskq_cons_present_entries(struct xsk_queue *q)

Types prefixed with __ are mainly for user-space facing things like uapi headers,
so in-kernel should be u64. Is there a reason this is not done as u32 (and thus
same as producer and producer)?

> +{
> +	/* No barriers needed since data is not accessed */
> +	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer);
> +}
> +
>   /* Functions for producers */
>   
>   static inline u32 xskq_prod_nb_free(struct xsk_queue *q, u32 max)
> 

