Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EE933C62F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhCOSxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232701AbhCOSxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 14:53:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BC9D64E61;
        Mon, 15 Mar 2021 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615834414;
        bh=I/C5JsE0km0+j4siEIBkM6jWf4KUJ3smXtoWYnUceEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/yoqIYs8ult9ZaBc1vO0zCXU6+iWRWYWcqDLZihMz/21Hj4Wy/htWvM6CfAf4Qc6
         m8NwZBzJAwD/n8rB2rb2Rhl8jClNYKCYlgX4My0C4bELzXVSwo5YnCIysNN12Z4D2K
         jnVwYLtsSOLgoJ2n6F1TCLqPVm49t1aSE4NeeFE0lbUV3c6GcRRlN+XYIVNocCgucB
         hSKRFDMq7EoCMVHeUEvY31qVNEwfY/jYMTBmBomfjV4lPj8Yv4QND4d1xXOTGs3UBO
         9F45bp24HVlh1Gvqjz9VGEO5otHVsQl3gd9t+3blsPt4zTjk/pVcyMOWDJPdJLL3bw
         0UKi27M10rixw==
Date:   Mon, 15 Mar 2021 11:53:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>
Subject: Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
Message-ID: <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
        <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 11:10:18 +0800 Yunsheng Lin wrote:
> @@ -606,6 +623,11 @@ static const u8 prio2band[TC_PRIO_MAX + 1] = {
>   */
>  struct pfifo_fast_priv {
>  	struct skb_array q[PFIFO_FAST_BANDS];
> +
> +	/* protect against data race between enqueue/dequeue and
> +	 * qdisc->empty setting
> +	 */
> +	spinlock_t lock;
>  };
>  
>  static inline struct skb_array *band2list(struct pfifo_fast_priv *priv,
> @@ -623,7 +645,10 @@ static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
>  	unsigned int pkt_len = qdisc_pkt_len(skb);
>  	int err;
>  
> -	err = skb_array_produce(q, skb);
> +	spin_lock(&priv->lock);
> +	err = __ptr_ring_produce(&q->ring, skb);
> +	WRITE_ONCE(qdisc->empty, false);
> +	spin_unlock(&priv->lock);
>  
>  	if (unlikely(err)) {
>  		if (qdisc_is_percpu_stats(qdisc))
> @@ -642,6 +667,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>  	struct sk_buff *skb = NULL;
>  	int band;
>  
> +	spin_lock(&priv->lock);
>  	for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
>  		struct skb_array *q = band2list(priv, band);
>  
> @@ -655,6 +681,7 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>  	} else {
>  		WRITE_ONCE(qdisc->empty, true);
>  	}
> +	spin_unlock(&priv->lock);
>  
>  	return skb;
>  }

I thought pfifo was supposed to be "lockless" and this change
re-introduces a lock between producer and consumer, no?
