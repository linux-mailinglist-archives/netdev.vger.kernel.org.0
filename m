Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F9E173A45
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgB1OuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:50:21 -0500
Received: from relay.sw.ru ([185.231.240.75]:56372 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgB1OuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 09:50:21 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1j7gy1-00067d-UF; Fri, 28 Feb 2020 17:50:18 +0300
Subject: Re: [PATCH net-next v2 2/2] net: datagram: drop 'destructor' argument
 from several helpers
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1582897428.git.pabeni@redhat.com>
 <0f2bbdfbcd497e5f22d32049ebb34e168ed8fecc.1582897428.git.pabeni@redhat.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <f4494fd4-323e-cc1a-cc53-284a0de03eb2@virtuozzo.com>
Date:   Fri, 28 Feb 2020 17:50:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0f2bbdfbcd497e5f22d32049ebb34e168ed8fecc.1582897428.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.02.2020 16:45, Paolo Abeni wrote:
> The only users for such argument are the UDP protocol and the UNIX
> socket family. We can safely reclaim the accounted memory directly
> from the UDP code and, after the previous patch, we can do scm
> stats accounting outside the datagram helpers.
> 
> Overall this cleans up a bit some datagram-related helpers, and
> avoids an indirect call per packet in the UDP receive path.
> 
> v1 -> v2:
>  - call scm_stat_del() only when not peeking - Kirill
>  - fix build issue with CONFIG_INET_ESPINTCP
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>

> ---
>  include/linux/skbuff.h | 12 ++----------
>  net/core/datagram.c    | 25 +++++++------------------
>  net/ipv4/udp.c         | 14 ++++++++------
>  net/unix/af_unix.c     |  7 +++++--
>  net/xfrm/espintcp.c    |  2 +-
>  5 files changed, 23 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 5b50278c4bc8..21749b2cdc9b 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3514,23 +3514,15 @@ int __skb_wait_for_more_packets(struct sock *sk, struct sk_buff_head *queue,
>  struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
>  					  struct sk_buff_head *queue,
>  					  unsigned int flags,
> -					  void (*destructor)(struct sock *sk,
> -							   struct sk_buff *skb),
>  					  int *off, int *err,
>  					  struct sk_buff **last);
>  struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
>  					struct sk_buff_head *queue,
> -					unsigned int flags,
> -					void (*destructor)(struct sock *sk,
> -							   struct sk_buff *skb),
> -					int *off, int *err,
> +					unsigned int flags, int *off, int *err,
>  					struct sk_buff **last);
>  struct sk_buff *__skb_recv_datagram(struct sock *sk,
>  				    struct sk_buff_head *sk_queue,
> -				    unsigned int flags,
> -				    void (*destructor)(struct sock *sk,
> -						       struct sk_buff *skb),
> -				    int *off, int *err);
> +				    unsigned int flags, int *off, int *err);
>  struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned flags, int noblock,
>  				  int *err);
>  __poll_t datagram_poll(struct file *file, struct socket *sock,
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index a78e7f864c1e..4213081c6ed3 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -166,8 +166,6 @@ static struct sk_buff *skb_set_peeked(struct sk_buff *skb)
>  struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
>  					  struct sk_buff_head *queue,
>  					  unsigned int flags,
> -					  void (*destructor)(struct sock *sk,
> -							   struct sk_buff *skb),
>  					  int *off, int *err,
>  					  struct sk_buff **last)
>  {
> @@ -198,8 +196,6 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
>  			refcount_inc(&skb->users);
>  		} else {
>  			__skb_unlink(skb, queue);
> -			if (destructor)
> -				destructor(sk, skb);
>  		}
>  		*off = _off;
>  		return skb;
> @@ -212,7 +208,6 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
>   *	@sk: socket
>   *	@queue: socket queue from which to receive
>   *	@flags: MSG\_ flags
> - *	@destructor: invoked under the receive lock on successful dequeue
>   *	@off: an offset in bytes to peek skb from. Returns an offset
>   *	      within an skb where data actually starts
>   *	@err: error code returned
> @@ -245,10 +240,7 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
>   */
>  struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
>  					struct sk_buff_head *queue,
> -					unsigned int flags,
> -					void (*destructor)(struct sock *sk,
> -							   struct sk_buff *skb),
> -					int *off, int *err,
> +					unsigned int flags, int *off, int *err,
>  					struct sk_buff **last)
>  {
>  	struct sk_buff *skb;
> @@ -269,8 +261,8 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
>  		 * However, this function was correct in any case. 8)
>  		 */
>  		spin_lock_irqsave(&queue->lock, cpu_flags);
> -		skb = __skb_try_recv_from_queue(sk, queue, flags, destructor,
> -						off, &error, last);
> +		skb = __skb_try_recv_from_queue(sk, queue, flags, off, &error,
> +						last);
>  		spin_unlock_irqrestore(&queue->lock, cpu_flags);
>  		if (error)
>  			goto no_packet;
> @@ -293,10 +285,7 @@ EXPORT_SYMBOL(__skb_try_recv_datagram);
>  
>  struct sk_buff *__skb_recv_datagram(struct sock *sk,
>  				    struct sk_buff_head *sk_queue,
> -				    unsigned int flags,
> -				    void (*destructor)(struct sock *sk,
> -						       struct sk_buff *skb),
> -				    int *off, int *err)
> +				    unsigned int flags, int *off, int *err)
>  {
>  	struct sk_buff *skb, *last;
>  	long timeo;
> @@ -304,8 +293,8 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk,
>  	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>  
>  	do {
> -		skb = __skb_try_recv_datagram(sk, sk_queue, flags, destructor,
> -					      off, err, &last);
> +		skb = __skb_try_recv_datagram(sk, sk_queue, flags, off, err,
> +					      &last);
>  		if (skb)
>  			return skb;
>  
> @@ -326,7 +315,7 @@ struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags,
>  
>  	return __skb_recv_datagram(sk, &sk->sk_receive_queue,
>  				   flags | (noblock ? MSG_DONTWAIT : 0),
> -				   NULL, &off, err);
> +				   &off, err);
>  }
>  EXPORT_SYMBOL(skb_recv_datagram);
>  
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 08a41f1e1cd2..a68e2ac37f26 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1671,10 +1671,11 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
>  		error = -EAGAIN;
>  		do {
>  			spin_lock_bh(&queue->lock);
> -			skb = __skb_try_recv_from_queue(sk, queue, flags,
> -							udp_skb_destructor,
> -							off, err, &last);
> +			skb = __skb_try_recv_from_queue(sk, queue, flags, off,
> +							err, &last);
>  			if (skb) {
> +				if (!(flags & MSG_PEEK))
> +					udp_skb_destructor(sk, skb);
>  				spin_unlock_bh(&queue->lock);
>  				return skb;
>  			}
> @@ -1692,9 +1693,10 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
>  			spin_lock(&sk_queue->lock);
>  			skb_queue_splice_tail_init(sk_queue, queue);
>  
> -			skb = __skb_try_recv_from_queue(sk, queue, flags,
> -							udp_skb_dtor_locked,
> -							off, err, &last);
> +			skb = __skb_try_recv_from_queue(sk, queue, flags, off,
> +							err, &last);
> +			if (skb && !(flags & MSG_PEEK))
> +				udp_skb_dtor_locked(sk, skb);
>  			spin_unlock(&sk_queue->lock);
>  			spin_unlock_bh(&queue->lock);
>  			if (skb)
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 145a3965341e..103bf94d2ab5 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2102,9 +2102,12 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  
>  		skip = sk_peek_offset(sk, flags);
>  		skb = __skb_try_recv_datagram(sk, &sk->sk_receive_queue, flags,
> -					      scm_stat_del, &skip, &err, &last);
> -		if (skb)
> +					      &skip, &err, &last);
> +		if (skb) {
> +			if (!(flags & MSG_PEEK))
> +				scm_stat_del(sk, skb);
>  			break;
> +		}
>  
>  		mutex_unlock(&u->iolock);
>  
> diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
> index f15d6a564b0e..037ea156d2f9 100644
> --- a/net/xfrm/espintcp.c
> +++ b/net/xfrm/espintcp.c
> @@ -100,7 +100,7 @@ static int espintcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  
>  	flags |= nonblock ? MSG_DONTWAIT : 0;
>  
> -	skb = __skb_recv_datagram(sk, &ctx->ike_queue, flags, NULL, &off, &err);
> +	skb = __skb_recv_datagram(sk, &ctx->ike_queue, flags, &off, &err);
>  	if (!skb)
>  		return err;
>  
> 

