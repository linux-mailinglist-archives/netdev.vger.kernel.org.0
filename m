Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C4C20553D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732974AbgFWO4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:56:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56391 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732738AbgFWO4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 10:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592924190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4x36CQUXIMToJKCvalRs5Coou2YfinEEHarYD3PsOY=;
        b=bhpaFYUQNU5kmaD5iFGSWXsjtQ9t3uoJAFaiw9/BP1iyZOY8+MLcN8v2UHIx5rUv6tqaeD
        IXeW9AAfu9g3zv8VxEhLVZxlebVPHUjVzl6X9Jy1zA1ux1atfxKPDOZv9TNsKb0ppHVlaj
        Abb94i1r452GXPjobjh1zhaq63NQkyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-lQJaP5hSNTybAh4DOx7xVg-1; Tue, 23 Jun 2020 10:56:27 -0400
X-MC-Unique: lQJaP5hSNTybAh4DOx7xVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33306193F560;
        Tue, 23 Jun 2020 14:56:26 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90F2D10016E8;
        Tue, 23 Jun 2020 14:56:14 +0000 (UTC)
Date:   Tue, 23 Jun 2020 16:56:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 4/8] bpf: cpumap: add the possibility to
 attach an eBPF program to cpumap
Message-ID: <20200623165612.2596954b@carbon>
In-Reply-To: <734113565894cb8447d1526e6a93eaf6ae994c2d.1592606391.git.lorenzo@kernel.org>
References: <cover.1592606391.git.lorenzo@kernel.org>
        <734113565894cb8447d1526e6a93eaf6ae994c2d.1592606391.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 00:57:20 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> @@ -273,16 +336,20 @@ static int cpu_map_kthread_run(void *data)
>  			prefetchw(page);
>  		}
>  
> -		m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, n, skbs);
> +		/* Support running another XDP prog on this CPU */
> +		nframes = cpu_map_bpf_prog_run_xdp(rcpu, xdp_frames, n, &stats);
> +

If all frames are dropped my XDP program, then we will call
kmem_cache_alloc_bulk() to allocate zero elements.  I found this during
my testing[1], and I think we should squash my proposed change in[1].

> +		m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp,
> +					  nframes, skbs);
>  		if (unlikely(m == 0)) {
> -			for (i = 0; i < n; i++)
> +			for (i = 0; i < nframes; i++)
>  				skbs[i] = NULL; /* effect: xdp_return_frame */
> -			drops = n;
> +			drops += nframes;
>  		}
>  
>  		local_bh_disable();
> -		for (i = 0; i < n; i++) {
> -			struct xdp_frame *xdpf = frames[i];
> +		for (i = 0; i < nframes; i++) {
> +			struct xdp_frame *xdpf = xdp_frames[i];
>  			struct sk_buff *skb = skbs[i];
>  			int ret;

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpumap04-map-xdp-prog.org#observations
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

