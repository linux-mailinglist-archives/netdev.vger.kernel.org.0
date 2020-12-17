Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50D72DD4F4
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgLQQHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgLQQHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 11:07:48 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ABCC061794;
        Thu, 17 Dec 2020 08:07:08 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id b24so10290787otj.0;
        Thu, 17 Dec 2020 08:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eNrflhnat4e4hEDmIASVHKPqsG6rOPWoVu8ELuRKqGQ=;
        b=RmydDMEBR8naEK20jfZKFVCNmXaxHCFZH0z513cS/Y0n0zsnvzcV5pz2ovSEW+6xmk
         or/ol+0nA97ibk+WeOTGx67+B5bzmKdCyLINM0xMTwSC/C/p/XXxfBEeStMtNleTtxLo
         UDs3Il5kcrBpox4ze40rt/rN1/UXjf78XJ90FYLmjp8NqiJ/PFj4xjNlxsx2XJoZqmwi
         EYsGkbO0S5gR0NTXr+Q1fRBsknRALINLKyxR4ySXf+CanVEQiqsnvADaxva5p7LEWfqS
         wo3ueRYlb2CPDiNToACHpTNwfYpWlYSiQ9/pjuDqZM1UtPlzm5fmRWUPDvlCIRIiWcmw
         q4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNrflhnat4e4hEDmIASVHKPqsG6rOPWoVu8ELuRKqGQ=;
        b=GOZfzVjZdRpfF3mnPB5DH/zSnAzzxP+64bBVyXsgfeNnK1K05hNRdN3xROZ7feAqdq
         JHuZoKcCvIWUm8SQkRvf+STSIdjLLUvII02kTD4rKY/ltKn3GYzi1FRB7rKRkhiRnWMy
         wdwoYFYh7P0ii0/f6Wy5XuOwIxR8fK8UL5Wlq4wR9dsPh6X01F+QTpEbZbeVDI1BTSz3
         1UQn+MUXA2xQqkYrdUqw0lzArFGpMzq6JQPxNfOse434wt+KnPaR/4yucNQxB8NMtrR/
         JpfMlZPYgEneadGbinK3oevP/ct/3fD7dPXUrUJau1irDhdlORynYrxAygGi0TPUqGU+
         tcZw==
X-Gm-Message-State: AOAM530AjSRTODmyDtUmjib2QOn78ZQyfu/4Zt9XPKCeUBn0ATngueWa
        e3S1H5BDAOYdm/uBi6ZGE4A=
X-Google-Smtp-Source: ABdhPJyGDq/YcwxBRfXA54+QkGci3T5z0W8OASUMhi2SS29NnU+iXblZ3LBKTRjB9HOIPBXkVtMxng==
X-Received: by 2002:a05:6830:1398:: with SMTP id d24mr31178841otq.199.1608221227480;
        Thu, 17 Dec 2020 08:07:07 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:4cdf:c7b2:9c38:dc7d])
        by smtp.googlemail.com with ESMTPSA id l6sm1275815otf.34.2020.12.17.08.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 08:07:06 -0800 (PST)
Subject: Re: [PATCHv12 bpf-next 1/6] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
References: <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20201216143036.2296568-1-liuhangbin@gmail.com>
 <20201216143036.2296568-2-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <913a8e62-3f17-84ed-e4f5-099ba441508c@gmail.com>
Date:   Thu, 17 Dec 2020 09:07:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201216143036.2296568-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/20 7:30 AM, Hangbin Liu wrote:
> @@ -327,40 +328,92 @@ bool dev_map_can_have_prog(struct bpf_map *map)
>  	return false;
>  }
>  
> +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> +				struct xdp_frame **frames, int n,
> +				struct net_device *dev)
> +{
> +	struct xdp_txq_info txq = { .dev = dev };
> +	struct xdp_buff xdp;
> +	int i, nframes = 0;
> +
> +	for (i = 0; i < n; i++) {
> +		struct xdp_frame *xdpf = frames[i];
> +		u32 act;
> +		int err;
> +
> +		xdp_convert_frame_to_buff(xdpf, &xdp);
> +		xdp.txq = &txq;
> +
> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +		switch (act) {
> +		case XDP_PASS:
> +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> +			if (unlikely(err < 0))
> +				xdp_return_frame_rx_napi(xdpf);
> +			else
> +				frames[nframes++] = xdpf;
> +			break;
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			fallthrough;
> +		case XDP_ABORTED:
> +			trace_xdp_exception(dev, xdp_prog, act);
> +			fallthrough;
> +		case XDP_DROP:
> +			xdp_return_frame_rx_napi(xdpf);
> +			break;
> +		}
> +	}
> +	return n - nframes; /* dropped frames count */

just return nframes here, since ...

> +}
> +
>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  {
>  	struct net_device *dev = bq->dev;
>  	int sent = 0, drops = 0, err = 0;
> +	unsigned int cnt = bq->count;
> +	unsigned int xdp_drop;
>  	int i;
>  
> -	if (unlikely(!bq->count))
> +	if (unlikely(!cnt))
>  		return;
>  
> -	for (i = 0; i < bq->count; i++) {
> +	for (i = 0; i < cnt; i++) {
>  		struct xdp_frame *xdpf = bq->q[i];
>  
>  		prefetch(xdpf);
>  	}
>  
> -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> +	if (unlikely(bq->xdp_prog)) {
> +		xdp_drop = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> +		cnt -= xdp_drop;

... that is apparently what you really want.

> +		if (!cnt) {
> +			sent = 0;
> +			drops = xdp_drop;
> +			goto out;
> +		}
> +	}
> +
> +	sent = dev->netdev_ops->ndo_xdp_xmit(dev, cnt, bq->q, flags);
>  	if (sent < 0) {
>  		err = sent;
>  		sent = 0;
>  		goto error;
>  	}
> -	drops = bq->count - sent;
> +	drops = (cnt - sent) + xdp_drop;
>  out:
>  	bq->count = 0;
>  
>  	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
>  	bq->dev_rx = NULL;
> +	bq->xdp_prog = NULL;
>  	__list_del_clearprev(&bq->flush_node);
>  	return;
>  error:
>  	/* If ndo_xdp_xmit fails with an errno, no frames have been
>  	 * xmit'ed and it's our responsibility to them free all.
>  	 */
> -	for (i = 0; i < bq->count; i++) {
> +	for (i = 0; i < cnt; i++) {
>  		struct xdp_frame *xdpf = bq->q[i];
>  
>  		xdp_return_frame_rx_napi(xdpf);
> @@ -408,7 +461,8 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
>   * Thus, safe percpu variable access.
>   */
>  static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> -		       struct net_device *dev_rx)
> +		       struct net_device *dev_rx,
> +		       struct bpf_dtab_netdev *dst)
>  {
>  	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
>  	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
> @@ -423,6 +477,14 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
>  	if (!bq->dev_rx)
>  		bq->dev_rx = dev_rx;
>  
> +	/* Store (potential) xdp_prog that run before egress to dev as
> +	 * part of bulk_queue.  This will be same xdp_prog for all
> +	 * xdp_frame's in bulk_queue, because this per-CPU store must
> +	 * be flushed from net_device drivers NAPI func end.
> +	 */
> +	if (dst && dst->xdp_prog && !bq->xdp_prog)
> +		bq->xdp_prog = dst->xdp_prog;


if you pass in xdp_prog through __xdp_enqueue you can reduce that to just:

	if (!bq->xdp_prog)
		bq->xdp_prog = xdp_prog;


>  	bq->q[bq->count++] = xdpf;
>  
>  	if (!bq->flush_node.prev)
> @@ -430,7 +492,8 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
>  }
>  
>  static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
> -			       struct net_device *dev_rx)
> +				struct net_device *dev_rx,
> +				struct bpf_dtab_netdev *dst)
>  {
>  	struct xdp_frame *xdpf;
>  	int err;
> @@ -446,42 +509,14 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  	if (unlikely(!xdpf))
>  		return -EOVERFLOW;
>  
> -	bq_enqueue(dev, xdpf, dev_rx);
> +	bq_enqueue(dev, xdpf, dev_rx, dst);
>  	return 0;
>  }
>  
> -static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
> -					 struct xdp_buff *xdp,
> -					 struct bpf_prog *xdp_prog)
> -{
> -	struct xdp_txq_info txq = { .dev = dev };
> -	u32 act;
> -
> -	xdp_set_data_meta_invalid(xdp);
> -	xdp->txq = &txq;
> -
> -	act = bpf_prog_run_xdp(xdp_prog, xdp);
> -	switch (act) {
> -	case XDP_PASS:
> -		return xdp;
> -	case XDP_DROP:
> -		break;
> -	default:
> -		bpf_warn_invalid_xdp_action(act);
> -		fallthrough;
> -	case XDP_ABORTED:
> -		trace_xdp_exception(dev, xdp_prog, act);
> -		break;
> -	}
> -
> -	xdp_return_buff(xdp);
> -	return NULL;
> -}
> -
>  int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx)
>  {
> -	return __xdp_enqueue(dev, xdp, dev_rx);
> +	return __xdp_enqueue(dev, xdp, dev_rx, NULL);
>  }
>  
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
> @@ -489,12 +524,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  {
>  	struct net_device *dev = dst->dev;
>  
> -	if (dst->xdp_prog) {
> -		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
> -		if (!xdp)
> -			return 0;
> -	}
> -	return __xdp_enqueue(dev, xdp, dev_rx);
> +	return __xdp_enqueue(dev, xdp, dev_rx, dst);
>  }
>  
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
> 

