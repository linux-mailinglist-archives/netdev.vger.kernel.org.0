Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40A2368549
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbhDVQyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:54:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236459AbhDVQyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:54:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619110438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L67e35Y8xefipQs4qC6+RLpK6ouDIFBfNvy+uHX4DBo=;
        b=AHxGH+OZ18vjsdeG3HFyBJBA6IAl+ce3DpCS7TVbH7oUf4Mv66JQAoXm6XzUxZ14GCYFcw
        uvClTySAlha49xlgndV9uVtl9ze8QzjQME4kDVyX3dHUjfYYgP5+PC9jzzjjDgWD+lGgUC
        c4y8XPuUkecjnVY1mKMbbAXMPvqA8Gc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-sCyT0bQ0MnKfk83RlvTJmw-1; Thu, 22 Apr 2021 12:53:54 -0400
X-MC-Unique: sCyT0bQ0MnKfk83RlvTJmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D1E5A40C7;
        Thu, 22 Apr 2021 16:53:52 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F175B5C261;
        Thu, 22 Apr 2021 16:53:34 +0000 (UTC)
Date:   Thu, 22 Apr 2021 18:53:32 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCHv9 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210422185332.3199ca2e@carbon>
In-Reply-To: <20210422071454.2023282-3-liuhangbin@gmail.com>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
        <20210422071454.2023282-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 15:14:52 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> diff --git a/net/core/filter.c b/net/core/filter.c
> index cae56d08a670..afec192c3b21 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
[...]
>  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct bpf_prog *xdp_prog)
>  {
> @@ -3933,6 +3950,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  	enum bpf_map_type map_type = ri->map_type;
>  	void *fwd = ri->tgt_value;
>  	u32 map_id = ri->map_id;
> +	struct bpf_map *map;
>  	int err;
>  
>  	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
> @@ -3942,7 +3960,12 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  	case BPF_MAP_TYPE_DEVMAP:
>  		fallthrough;
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		err = dev_map_enqueue(fwd, xdp, dev);
> +		map = xchg(&ri->map, NULL);

Hmm, this looks dangerous for performance to have on this fast-path.
The xchg call can be expensive, AFAIK this is an atomic operation.


> +		if (map)
> +			err = dev_map_enqueue_multi(xdp, dev, map,
> +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> +		else
> +			err = dev_map_enqueue(fwd, xdp, dev);
>  		break;
>  	case BPF_MAP_TYPE_CPUMAP:
>  		err = cpu_map_enqueue(fwd, xdp, dev);
> @@ -3984,13 +4007,19 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
>  				       enum bpf_map_type map_type, u32 map_id)
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> +	struct bpf_map *map;
>  	int err;
>  
>  	switch (map_type) {
>  	case BPF_MAP_TYPE_DEVMAP:
>  		fallthrough;
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		err = dev_map_generic_redirect(fwd, skb, xdp_prog);
> +		map = xchg(&ri->map, NULL);

Same here!

> +		if (map)
> +			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
> +						     ri->flags & BPF_F_EXCLUDE_INGRESS);
> +		else
> +			err = dev_map_generic_redirect(fwd, skb, xdp_prog);
>  		if (unlikely(err))
>  			goto err;
>  		break;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

