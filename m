Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC45129559
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 12:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfLWLfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 06:35:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36455 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfLWLfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 06:35:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so16297054wru.3;
        Mon, 23 Dec 2019 03:35:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HLf7UDzjHO46QZ+r4g/DQtLvnK9ZgG13FP1Rb0ijduQ=;
        b=qPRER4TqbjX+h4OFzgVXBSmWL2Bth5zX/084Jq9f8xbNHxRq/1L7+FlpFEqRhAHP9h
         wVGfgxzHihmkNi66DSmcWcdy4YJ8B9C4GCl6uVrPL84+05es37WrjcH0BXo2GK8D06nt
         1zkXHeaiKSsPTq58K6gsU3guU1GBFYrcaB0oBXUtEPeqBGGBFhsWpCLrAOUIJJ5UyHWG
         +v6WHXH25czYVKkEIWahWpcKrIWjq4x9GYoJ7Qq7NpOgcvLPT+e5Wtp8b5YEMcEoc8ja
         J5GkGqoZou+CODfC85Cp3kNd9g92AJ2laNbpLlYEyivhf1fZlMjyWfJ+EKJntENxP1QJ
         pHlA==
X-Gm-Message-State: APjAAAUBGnjW/C7AfBxFxUW5LQEhjvJUEtJzhFvj/u12dKYWg40mTBUR
        FDt5/fkuaZuCsph3rLjY1C8=
X-Google-Smtp-Source: APXvYqz93/AcG8Tzkn6CEiCbg3U9AEeAW5KZcv3jLL8eB1/yo9AokuwM9YpW25WmFlKY/8HxY5MEzA==
X-Received: by 2002:adf:fc0c:: with SMTP id i12mr31296335wrr.74.1577100948094;
        Mon, 23 Dec 2019 03:35:48 -0800 (PST)
Received: from debian (38.163.200.146.dyn.plus.net. [146.200.163.38])
        by smtp.gmail.com with ESMTPSA id c15sm20231097wrt.1.2019.12.23.03.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 03:35:47 -0800 (PST)
Date:   Mon, 23 Dec 2019 11:35:45 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] xen-netback: support dynamic unbind/bind
Message-ID: <20191223113545.nwugg7lsorttunuu@debian>
References: <20191223095923.2458-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223095923.2458-1-pdurrant@amazon.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 09:59:23AM +0000, Paul Durrant wrote:
[...] 
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
> index f15ba3de6195..0c8a02a1ead7 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -585,6 +585,7 @@ int xenvif_connect_ctrl(struct xenvif *vif, grant_ref_t ring_ref,
>  	struct net_device *dev = vif->dev;
>  	void *addr;
>  	struct xen_netif_ctrl_sring *shared;
> +	RING_IDX rsp_prod, req_prod;
>  	int err;
>  
>  	err = xenbus_map_ring_valloc(xenvif_to_xenbus_device(vif),
> @@ -593,7 +594,14 @@ int xenvif_connect_ctrl(struct xenvif *vif, grant_ref_t ring_ref,
>  		goto err;
>  
>  	shared = (struct xen_netif_ctrl_sring *)addr;
> -	BACK_RING_INIT(&vif->ctrl, shared, XEN_PAGE_SIZE);
> +	rsp_prod = READ_ONCE(shared->rsp_prod);
> +	req_prod = READ_ONCE(shared->req_prod);
> +
> +	BACK_RING_ATTACH(&vif->ctrl, shared, rsp_prod, XEN_PAGE_SIZE);
> +
> +	err = -EIO;
> +	if (req_prod - rsp_prod > RING_SIZE(&vif->ctrl))
> +		goto err_unmap;

I think it makes more sense to attach the ring after this check has been
done, but I can see you want to structure code like this to reuse the
unmap error path.

So:

Reviewed-by: Wei Liu <wei.liu@kernel.org>

Nice work btw.
