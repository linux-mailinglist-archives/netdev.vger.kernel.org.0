Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2B32FEE10
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732522AbhAUPHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:07:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732439AbhAUPHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:07:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611241552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cmx/O8mPJQ46C3uZ857mvmc6+oujjExflLWVgvW1Tto=;
        b=Ptb/Z+t33TYLDb+tnMX4fGMhYvuBxt6iS34/fgtiB3i7DbbXWwsCjTMaYC1cFP7IO4J7dM
        dBF6X8tzFK6/9LwK285yXL/HJl4VHJByxHLSFdFZyP74J27Rm8fUTdW4ira3CnU4Kk/pXQ
        RG84Z++vg8QGk2ohcsMLa0VlVdhPkTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-boQdJq4IMsK92oMNWP5vXQ-1; Thu, 21 Jan 2021 10:05:49 -0500
X-MC-Unique: boQdJq4IMsK92oMNWP5vXQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25DB0814701;
        Thu, 21 Jan 2021 15:05:48 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 046385F9C8;
        Thu, 21 Jan 2021 15:05:39 +0000 (UTC)
Date:   Thu, 21 Jan 2021 16:05:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv9 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20210121160538.192ca297@carbon>
In-Reply-To: <20210121130642.2943811-1-liuhangbin@gmail.com>
References: <20210119031207.2813215-1-liuhangbin@gmail.com>
        <20210121130642.2943811-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 21:06:42 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> This patch add a xdp program on egress to show that we can modify
> the packet on egress. In this sample we will set the pkt's src
> mac to egress's mac address. The xdp_prog will be attached when
> -X option supplied.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> ---
> v9:
> roll back to just set src mac to egress interface mac on 2nd xdp prog,
> this could avoid packet reorder introduce in patch v6.

I like this V9 much better.

One (hopefully) last nitpick below.

> diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
> index 6489352ab7a4..35ce5e26bbe5 100644
> --- a/samples/bpf/xdp_redirect_map_kern.c
> +++ b/samples/bpf/xdp_redirect_map_kern.c
> -SEC("xdp_redirect_map")
> -int xdp_redirect_map_prog(struct xdp_md *ctx)
> +static int xdp_redirect_map(struct xdp_md *ctx, void *redirect_map)

Can you make this function always inline?

>  {
>  	void *data_end = (void *)(long)ctx->data_end;
>  	void *data = (void *)(long)ctx->data;
>  	struct ethhdr *eth = data;
>  	int rc = XDP_DROP;
> -	int vport, port = 0, m = 0;
>  	long *value;
>  	u32 key = 0;
>  	u64 nh_off;
> +	int vport;
>  
>  	nh_off = sizeof(*eth);
>  	if (data + nh_off > data_end)
> @@ -79,7 +96,40 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
>  	swap_src_dst_mac(data);
>  
>  	/* send packet out physical port */
> -	return bpf_redirect_map(&tx_port, vport, 0);
> +	return bpf_redirect_map(redirect_map, vport, 0);
> +}
> +
> +SEC("xdp_redirect_general")
> +int xdp_redirect_map_general(struct xdp_md *ctx)
> +{
> +	return xdp_redirect_map(ctx, &tx_port_general);
> +}
> +
> +SEC("xdp_redirect_native")
> +int xdp_redirect_map_native(struct xdp_md *ctx)
> +{
> +	return xdp_redirect_map(ctx, &tx_port_native);
> +}

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

