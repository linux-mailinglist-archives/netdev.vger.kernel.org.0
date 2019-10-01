Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2599EC43B3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbfJAWT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:19:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:38786 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbfJAWT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:19:57 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFQUm-0005we-UW; Wed, 02 Oct 2019 00:19:49 +0200
Date:   Wed, 2 Oct 2019 00:19:48 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf] xsk: fix crash in poll when device does not support
 ndo_xsk_wakeup
Message-ID: <20191001221948.GA10044@pc-63.home>
References: <1569850212-4035-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569850212-4035-1-git-send-email-magnus.karlsson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25589/Tue Oct  1 10:30:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 03:30:12PM +0200, Magnus Karlsson wrote:
> Fixes a crash in poll() when an AF_XDP socket is opened in copy mode
> with the XDP_USE_NEED_WAKEUP flag set and the bound device does not
> have ndo_xsk_wakeup defined. Avoid trying to call the non-existing ndo
> and instead call the internal xsk sendmsg functionality to send
> packets in the same way (from the application's point of view) as
> calling sendmsg() in any mode or poll() in zero-copy mode would have
> done. The application should behave in the same way independent on if
> zero-copy mode or copy-mode is used.
> 
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
> Reported-by: syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Overall looks good, two very small nits:

> ---
>  net/xdp/xsk.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index c2f1af3..a478d8ec 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -327,8 +327,7 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>  	sock_wfree(skb);
>  }
>  
> -static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
> -			    size_t total_len)
> +static int xsk_generic_xmit(struct sock *sk)
>  {
>  	u32 max_batch = TX_BATCH_SIZE;
>  	struct xdp_sock *xs = xdp_sk(sk);
> @@ -394,22 +393,31 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
>  	return err;
>  }
>  
> -static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> +static int __xsk_sendmsg(struct socket *sock)
>  {
> -	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
>  	struct sock *sk = sock->sk;
>  	struct xdp_sock *xs = xdp_sk(sk);

Can't we just only pass xs as an argument to __xsk_sendmsg()? From
below xsk_sendmsg() we eventually fetch xs anyway same as for the
xsk_poll(), yet in __xsk_sendmsg() we pass sock (which is otherwise
unused) and then we need to refetch sk and xs once again.

> -	if (unlikely(!xsk_is_bound(xs)))
> -		return -ENXIO;
>  	if (unlikely(!(xs->dev->flags & IFF_UP)))
>  		return -ENETDOWN;
>  	if (unlikely(!xs->tx))
>  		return -ENOBUFS;
> +
> +	return xs->zc ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk);
> +}
> +
> +static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> +{
> +	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
> +	struct sock *sk = sock->sk;
> +	struct xdp_sock *xs = xdp_sk(sk);
> +
> +	if (unlikely(!xsk_is_bound(xs)))
> +		return -ENXIO;
>  	if (need_wait)

Not directly related but since you touch this code, need_wait should
be marked unlikely() as well.

>  		return -EOPNOTSUPP;
>  
> -	return (xs->zc) ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk, m, total_len);
> +	return __xsk_sendmsg(sock);
>  }
>  
>  static unsigned int xsk_poll(struct file *file, struct socket *sock,
> @@ -426,9 +434,14 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
>  	dev = xs->dev;
>  	umem = xs->umem;
>  
> -	if (umem->need_wakeup)
> -		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> -						umem->need_wakeup);
> +	if (umem->need_wakeup) {
> +		if (dev->netdev_ops->ndo_xsk_wakeup)
> +			dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> +							umem->need_wakeup);
> +		else
> +			/* Poll needs to drive Tx also in copy mode */
> +			__xsk_sendmsg(sock);
> +	}
>  
>  	if (xs->rx && !xskq_empty_desc(xs->rx))
>  		mask |= POLLIN | POLLRDNORM;
> -- 
> 2.7.4
> 
