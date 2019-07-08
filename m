Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F3D628B2
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 20:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbfGHStc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 14:49:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35027 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfGHStc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 14:49:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id s27so8144615pgl.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 11:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uQOEFbB391HmTfhX7WBmCgtPpWZsPvkouP0K96CNUdQ=;
        b=Tcapq0oX6XWHw20PmVOMWi4wswmZZQuYNgFdsQA5/ckebHpLXdPC85SJDmhVwtM8uH
         sz0m/7mptleKJYcPRwDA4mEFIjvUjRwRhHxiiiWxXkglk6vNzajXvuKJRMD3KJpMzWq5
         NRXCjQeV/QaBac3gs0TuymOZzISHZ2PSIm1C8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uQOEFbB391HmTfhX7WBmCgtPpWZsPvkouP0K96CNUdQ=;
        b=Zwle4tjDnd9DUWWAaCcJhcn7SILF8dWpSyq6PG98WRLxfP3S1FgKRgaTNLuVa9spPo
         Sk2sY9gU+JOl3LRMXoQtoi7qoljhpbw4z2rhK9jMVNbMATE/t3kBrDh5ey60lbe6K+p3
         lxXTNG2EKc0H08NqNl642iXksOvzJGtRm7/XG/Y2QrvCsPUhx8iAV/QtPvDXqCjdUFTV
         StsQLW0zQ3HFT6GRKtiBymrsNN2ARoAtahGPb37HBn6+FSLuN3FOEg3VkbJpz2bikjEr
         0008lxH0Q/K/PMScODz1Zwkz3z7cHwRSQohsU20azVRyPz6VYNCgjo3XnQoqwsryi5s8
         //ow==
X-Gm-Message-State: APjAAAVQbrQoRfLJjsiAFSrKZ81cy87tWlyjVnCIOxwIpvTWZs/g27i+
        pjU+MgdrIzaZ++SwcA0Z9yeLHQ==
X-Google-Smtp-Source: APXvYqxezpLqA1Zm7gLraC3hwlEX0mC5iIyHJnfds4c6xl8838uMyZPNjLvtoXI3sci/oZfHYaH+fQ==
X-Received: by 2002:a63:221f:: with SMTP id i31mr26225675pgi.251.1562611771150;
        Mon, 08 Jul 2019 11:49:31 -0700 (PDT)
Received: from C02RW35GFVH8.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id n89sm783045pjc.0.2019.07.08.11.49.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 11:49:30 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Mon, 8 Jul 2019 14:49:25 -0400
To:     Michael Chan <michael.chan@broadcom.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, hawk@kernel.org,
        ast@kernel.org
Subject: Re: [PATCH net-next 4/4] bnxt_en: add page_pool support
Message-ID: <20190708184925.GH87269@C02RW35GFVH8.dhcp.broadcom.net>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
 <1562398578-26020-5-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562398578-26020-5-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 03:36:18AM -0400, Michael Chan wrote:
> From: Andy Gospodarek <gospo@broadcom.com>
> 
> This removes contention over page allocation for XDP_REDIRECT actions by
> adding page_pool support per queue for the driver.  The performance for
> XDP_REDIRECT actions scales linearly with the number of cores performing
> redirect actions when using the page pools instead of the standard page
> allocator.
> 
> Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/Kconfig         |  1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 40 +++++++++++++++++++++++----
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 ++
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  3 +-
>  4 files changed, 41 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index d8f0846..b6777e5 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
[...]
> @@ -2530,12 +2555,17 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
>  
>  		ring = &rxr->rx_ring_struct;
>  
> +		rc = bnxt_alloc_rx_page_pool(bp, rxr);
> +		if (rc)
> +			return rc;
> +
>  		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
>  		if (rc < 0)
>  			return rc;
>  
>  		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> -						MEM_TYPE_PAGE_SHARED, NULL);
> +						MEM_TYPE_PAGE_POOL,
> +						rxr->page_pool);
>  		if (rc) {
>  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
>  			return rc;

I think we want to amend and the chunk above to be:

@@ -2530,14 +2557,24 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 
                ring = &rxr->rx_ring_struct;
 
+               rc = bnxt_alloc_rx_page_pool(bp, rxr);
+               if (rc)
+                       return rc;
+
                rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
-               if (rc < 0)
+               if (rc < 0) {
+                       page_pool_free(rxr->page_pool);
+                       rxr->page_pool = NULL;
                        return rc;
+               }
 
                rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
-                                               MEM_TYPE_PAGE_SHARED, NULL);
+                                               MEM_TYPE_PAGE_POOL,
+                                               rxr->page_pool);
                if (rc) {
                        xdp_rxq_info_unreg(&rxr->xdp_rxq);
+                       page_pool_free(rxr->page_pool);
+                       rxr->page_pool = NULL;
                        return rc;
                }
 

That should take care of the freeing of the page_pool that is allocated
but there is a failure during xdp_rxq_info_reg() or
xdp_rxq_info_reg_mem_model().

I agree that we do not need to call page_pool_free in the normal
shutdown case.
