Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942975D94D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfGCAkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:40:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39187 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfGCAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:40:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id i34so688607qta.6
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4BtV39KjV7sDRMWmrXQvT/nf8DtHimxpqWMrsA8yZ8g=;
        b=CQdsRFF171jO5+/s1qAUI1rgCzyTzJDs9gZOQMPyPjnK2ayU+zBw/Y1zuHJcS3Aqaa
         DOee7yY43BfLZd8G3dM1yUpHgG+YIbD8ROTNtVfGY52fSj7ya5Ed3OQroTo8Cz47Xh/E
         dsaGad6apPp+ZEq3MUye/V3Lzt0F7FRJxgyu40Nim3+roBef6y/zVuOZO/ydtLb1/7AV
         V8+ae4mRJHOin7xdq2VTx5cmL15S+2G3Ry0hVPR8zpWJTpk/CBENGKyWw6bmiU1kCm0N
         0AxXt/FTvuMJ1c1JkMO+FwHTrYgADhhuWJSrhkbmeqEKELzouSnt6TgRV1MAj0P94Sef
         4LpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4BtV39KjV7sDRMWmrXQvT/nf8DtHimxpqWMrsA8yZ8g=;
        b=mJste5VMqp13A7R2lTj0FR/AP4XBAWJPCCpzIpdGru9k1dwcKnnDG+AuuixYZQbKjB
         nY5SlDtuXewnqZHDR42/R4tjvVDZe34o62FgVM4fa7pccHH82nZ6N0SQqwl3YZ9WreXt
         zPbMZ97eXCwz+AGUViBIoC1CAo5ZdEb/qIjY1DG/Alt06Yn0idrrG/SqIkymvzld4t9x
         eouwNsU1WCHL9HdWQtlljjqrOPRcF7WDUJ3HJIJcomI/eSyFIMypsJLJNtfO30R0nSDt
         o7hYaWikW6YbljGgUPuFS+MlVXdaUmBne6py22T+YCZtA6zMpm6ms9f1BOfcMyaxVe8Q
         lr+g==
X-Gm-Message-State: APjAAAW3tTtxMdn0QiICxCqaYBsst7QJm1wO1soxJPlzorLhN1DvrEdk
        iNlsLH2OOBynL/HqbiMWZMHXng==
X-Google-Smtp-Source: APXvYqxS8kYtvbzapj/eH76oDHlldzxbfNicv6tPtHys9nj2jiUMbU6r2kzPJt0X+uutHWhL+5s2Hg==
X-Received: by 2002:ac8:2b14:: with SMTP id 20mr28665349qtu.295.1562114419416;
        Tue, 02 Jul 2019 17:40:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c18sm220886qkm.78.2019.07.02.17.40.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 17:40:19 -0700 (PDT)
Date:   Tue, 2 Jul 2019 17:40:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] xdp: fix race on generic receive path
Message-ID: <20190702174014.005a3166@cakuba.netronome.com>
In-Reply-To: <20190702143634.19688-1-i.maximets@samsung.com>
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
        <20190702143634.19688-1-i.maximets@samsung.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jul 2019 17:36:34 +0300, Ilya Maximets wrote:
> Unlike driver mode, generic xdp receive could be triggered
> by different threads on different CPU cores at the same time
> leading to the fill and rx queue breakage. For example, this
> could happen while sending packets from two processes to the
> first interface of veth pair while the second part of it is
> open with AF_XDP socket.
> 
> Need to take a lock for each generic receive to avoid race.
> 
> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..19f41d2b670c 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>  {
>  	u32 metalen = xdp->data - xdp->data_meta;
>  	u32 len = xdp->data_end - xdp->data;
> +	unsigned long flags;
>  	void *buffer;
>  	u64 addr;
>  	int err;
>  
> -	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
> -		return -EINVAL;
> +	spin_lock_irqsave(&xs->rx_lock, flags);

Why _irqsave, rather than _bh?

> +	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
> +		err = -EINVAL;
> +		goto out_unlock;
> +	}
>  
>  	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>  	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
> -		xs->rx_dropped++;
> -		return -ENOSPC;
> +		err = -ENOSPC;
> +		goto out_drop;
>  	}
>  
>  	addr += xs->umem->headroom;

