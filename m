Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD36A6CD1
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 17:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbfICPWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 11:22:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:41284 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbfICPWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 11:22:34 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5AdJ-0003NJ-34; Tue, 03 Sep 2019 17:22:13 +0200
Received: from [178.197.249.19] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5AdI-0000YX-RJ; Tue, 03 Sep 2019 17:22:12 +0200
Subject: Re: [PATCH bpf-next v2 2/4] xsk: add proper barriers and {READ,
 WRITE}_ONCE-correctness for state
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
 <20190826061053.15996-3-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b580a3c0-c7c2-2191-997b-473ae65f977e@iogearbox.net>
Date:   Tue, 3 Sep 2019 17:22:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190826061053.15996-3-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25561/Tue Sep  3 10:24:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 8:10 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The state variable was read, and written outside the control mutex
> (struct xdp_sock, mutex), without proper barriers and {READ,
> WRITE}_ONCE correctness.
> 
> In this commit this issue is addressed, and the state member is now
> used a point of synchronization whether the socket is setup correctly
> or not.
> 
> This also fixes a race, found by syzcaller, in xsk_poll() where umem
> could be accessed when stale.
> 
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Sorry for the delay.

> ---
>   net/xdp/xsk.c | 57 ++++++++++++++++++++++++++++++++++++---------------
>   1 file changed, 40 insertions(+), 17 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index f3351013c2a5..8fafa3ce3ae6 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -162,10 +162,23 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
>   	return err;
>   }
>   
> +static bool xsk_is_bound(struct xdp_sock *xs)
> +{
> +	if (READ_ONCE(xs->state) == XSK_BOUND) {
> +		/* Matches smp_wmb() in bind(). */
> +		smp_rmb();
> +		return true;
> +	}
> +	return false;
> +}
> +
>   int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>   {
>   	u32 len;
>   
> +	if (!xsk_is_bound(xs))
> +		return -EINVAL;
> +
>   	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
>   		return -EINVAL;
>   
> @@ -362,7 +375,7 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>   	struct sock *sk = sock->sk;
>   	struct xdp_sock *xs = xdp_sk(sk);
>   
> -	if (unlikely(!xs->dev))
> +	if (unlikely(!xsk_is_bound(xs)))
>   		return -ENXIO;
>   	if (unlikely(!(xs->dev->flags & IFF_UP)))
>   		return -ENETDOWN;
> @@ -378,10 +391,15 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
>   			     struct poll_table_struct *wait)
>   {
>   	unsigned int mask = datagram_poll(file, sock, wait);
> -	struct sock *sk = sock->sk;
> -	struct xdp_sock *xs = xdp_sk(sk);
> -	struct net_device *dev = xs->dev;
> -	struct xdp_umem *umem = xs->umem;
> +	struct xdp_sock *xs = xdp_sk(sock->sk);
> +	struct net_device *dev;
> +	struct xdp_umem *umem;
> +
> +	if (unlikely(!xsk_is_bound(xs)))
> +		return mask;
> +
> +	dev = xs->dev;
> +	umem = xs->umem;
>   
>   	if (umem->need_wakeup)
>   		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> @@ -417,10 +435,9 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
>   {
>   	struct net_device *dev = xs->dev;
>   
> -	if (!dev || xs->state != XSK_BOUND)
> +	if (xs->state != XSK_BOUND)
>   		return;
> -
> -	xs->state = XSK_UNBOUND;
> +	WRITE_ONCE(xs->state, XSK_UNBOUND);
>   
>   	/* Wait for driver to stop using the xdp socket. */
>   	xdp_del_sk_umem(xs->umem, xs);
> @@ -495,7 +512,9 @@ static int xsk_release(struct socket *sock)
>   	local_bh_enable();
>   
>   	xsk_delete_from_maps(xs);
> +	mutex_lock(&xs->mutex);
>   	xsk_unbind_dev(xs);
> +	mutex_unlock(&xs->mutex);
>   
>   	xskq_destroy(xs->rx);
>   	xskq_destroy(xs->tx);
> @@ -589,19 +608,18 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   		}
>   
>   		umem_xs = xdp_sk(sock->sk);
> -		if (!umem_xs->umem) {
> -			/* No umem to inherit. */
> +		if (!xsk_is_bound(umem_xs)) {
>   			err = -EBADF;
>   			sockfd_put(sock);
>   			goto out_unlock;
> -		} else if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
> +		}
> +		if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
>   			err = -EINVAL;
>   			sockfd_put(sock);
>   			goto out_unlock;
>   		}
> -
>   		xdp_get_umem(umem_xs->umem);
> -		xs->umem = umem_xs->umem;
> +		WRITE_ONCE(xs->umem, umem_xs->umem);
>   		sockfd_put(sock);
>   	} else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
>   		err = -EINVAL;
> @@ -626,10 +644,15 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   	xdp_add_sk_umem(xs->umem, xs);
>   
>   out_unlock:
> -	if (err)
> +	if (err) {
>   		dev_put(dev);
> -	else
> -		xs->state = XSK_BOUND;
> +	} else {
> +		/* Matches smp_rmb() in bind() for shared umem
> +		 * sockets, and xsk_is_bound().
> +		 */
> +		smp_wmb();

You write with what this barrier matches/pairs, but would be useful for readers
to have an explanation against what it protects. I presume to have things like
xs->umem public as you seem to guard it behind xsk_is_bound() in xsk_poll() and
other cases? Would be great to have a detailed analysis of all this e.g. in the
commit message so one wouldn't need to guess; right now it feels this is doing
many things at once and w/o further explanation of why READ_ONCE() or others are
omitted sometimes. Would be great to get a lot more clarity into this, perhaps
splitting it up a bit might also help.

> +		WRITE_ONCE(xs->state, XSK_BOUND);
> +	}

Thanks,
Daniel
