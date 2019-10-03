Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2728CA0D7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbfJCPBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:01:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:39862 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfJCPBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:01:01 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iG2b9-0001c2-3b; Thu, 03 Oct 2019 17:00:55 +0200
Date:   Thu, 3 Oct 2019 17:00:54 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2] xsk: fix crash in poll when device does not
 support ndo_xsk_wakeup
Message-ID: <20191003150054.GD9196@pc-66.home>
References: <1569997919-11541-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569997919-11541-1-git-send-email-magnus.karlsson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25591/Thu Oct  3 10:30:38 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 08:31:59AM +0200, Magnus Karlsson wrote:
> Fixes a crash in poll() when an AF_XDP socket is opened in copy mode
> and the bound device does not have ndo_xsk_wakeup defined. Avoid
> trying to call the non-existing ndo and instead call the internal xsk
> sendmsg function to send packets in the same way (from the
> application's point of view) as calling sendmsg() in any mode or
> poll() in zero-copy mode would have done. The application should
> behave in the same way independent on if zero-copy mode or copy mode
> is used.
> 
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
> Reported-by: syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied, thanks!

[...]
> +static int xsk_generic_xmit(struct sock *sk)
>  {
> -	u32 max_batch = TX_BATCH_SIZE;
>  	struct xdp_sock *xs = xdp_sk(sk);
> +	u32 max_batch = TX_BATCH_SIZE;
>  	bool sent_frame = false;
>  	struct xdp_desc desc;
>  	struct sk_buff *skb;
> @@ -394,6 +392,18 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
>  	return err;
>  }
>  
> +static int __xsk_sendmsg(struct sock *sk)

Bit unclear why you don't just pass xs directly in here from both call
sites ...

> +{
> +	struct xdp_sock *xs = xdp_sk(sk);
> +
> +	if (unlikely(!(xs->dev->flags & IFF_UP)))
> +		return -ENETDOWN;
> +	if (unlikely(!xs->tx))
> +		return -ENOBUFS;
> +
> +	return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);

... and for the xsk_generic_xmit() pass in &xs->sk. Presumably generated
code should be the same, but maybe small cleanup for next batch of AF_XDP
patches.

> +}
> +
>  static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  {
>  	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
> @@ -402,21 +412,18 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  
>  	if (unlikely(!xsk_is_bound(xs)))
>  		return -ENXIO;
> -	if (unlikely(!(xs->dev->flags & IFF_UP)))
> -		return -ENETDOWN;
> -	if (unlikely(!xs->tx))
> -		return -ENOBUFS;
> -	if (need_wait)
> +	if (unlikely(need_wait))
>  		return -EOPNOTSUPP;
>  
> -	return (xs->zc) ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk, m, total_len);
> +	return __xsk_sendmsg(sk);
>  }

Thanks,
Daniel
