Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302A948EB5E
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbiANOPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:15:31 -0500
Received: from mga14.intel.com ([192.55.52.115]:47408 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230191AbiANOPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 09:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642169730; x=1673705730;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=u59qt8xQ+yz+WAmgavkxnGMHsGSChgwMcLsLgVap1GE=;
  b=ABPp8Hz4udxLbhoGuCKl2SK1EMkCrXZEaBw7USHAkQ8Iiuj/jXxhrovf
   fTHaiu6HXj0cYXUIqphxLqoJmDEGKZV8kce8Map1xVecFEiszOnC1e14+
   yAp+/J4IP/wIhS5Qb8paEYTVALivM4lTc8pB6n2Xw10zmeJgfK6agOGcg
   A8HSiFUjxlt7otRlNFAHC4Rr51fe7snKok0NcWdXu8wFkrluIQhhNfSFj
   lJ3z6NY8i/ItqddYD6ACJLsNv/pXbz7VHHSlZJKBFyAKBcSymOeSZUOmt
   mpuB29H7ElXRzyIckhlUjxRDXLQgK8JFS0hUUT7aL8rCQyFkG9cv9GVWW
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244452830"
X-IronPort-AV: E=Sophos;i="5.88,288,1635231600"; 
   d="scan'208";a="244452830"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 06:15:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,288,1635231600"; 
   d="scan'208";a="614349262"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 06:15:25 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n8NKz-00AdeA-R7;
        Fri, 14 Jan 2022 16:13:53 +0200
Date:   Fri, 14 Jan 2022 16:13:29 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA
 interface
Message-ID: <YeGFCYTaQ0GNLhyx@smile.fi.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 06:06:16PM -0700, Ricardo Martinez wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
> path of Host-Modem data transfers. CLDMA HIF layer provides a common
> interface to the Port Layer.
> 
> CLDMA manages 8 independent RX/TX physical channels with data flow
> control in HW queues. CLDMA uses ring buffers of General Packet
> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
> data buffers (DB).
> 
> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
> interrupts, and initializes CLDMA HW registers.
> 
> CLDMA TX flow:
> 1. Port Layer write
> 2. Get DB address
> 3. Configure GPD
> 4. Triggering processing via HW register write
> 
> CLDMA RX flow:
> 1. CLDMA HW sends a RX "done" to host
> 2. Driver starts thread to safely read GPD
> 3. DB is sent to Port layer
> 4. Create a new buffer for GPD ring

...

> + * Copyright (c) 2021, Intel Corporation.

2021-2022 (in all files)?

...

> +#include <linux/dev_printk.h>
> +#include <linux/device.h>

I believe the former is guaranteed to be included in the latter.
The rest of the headers in this file looks good to me.

...

> +	if (dma_mapping_error(md_ctrl->dev, req->mapped_buff)) {

> +		dev_err(md_ctrl->dev, "DMA mapping failed\n");

Can we first free resources and then print messages?

Printing messages is a slow path and freeing resources first is a good
(micro-)optimization.

> +		dev_kfree_skb_any(req->skb);
> +		req->skb = NULL;
> +		req->mapped_buff = 0;
> +		return -ENOMEM;
> +	}

...

> +static int t7xx_cldma_rx_ring_init(struct cldma_ctrl *md_ctrl, struct cldma_ring *ring)
> +{
> +	struct cldma_request *req, *first_req = NULL;
> +	struct cldma_rgpd *prev_gpd, *gpd = NULL;
> +	int i;
> +
> +	for (i = 0; i < ring->length; i++) {
> +		req = t7xx_alloc_rx_request(md_ctrl, ring->pkt_size);
> +		if (!req) {
> +			t7xx_cldma_ring_free(md_ctrl, ring, DMA_FROM_DEVICE);
> +			return -ENOMEM;
> +		}
> +
> +		gpd = req->gpd;
> +		t7xx_cldma_rgpd_set_data_ptr(gpd, req->mapped_buff);
> +		gpd->data_allow_len = cpu_to_le16(ring->pkt_size);
> +		gpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
> +
> +		if (i)
> +			t7xx_cldma_rgpd_set_next_ptr(prev_gpd, req->gpd_addr);
> +		else
> +			first_req = req;
> +
> +		INIT_LIST_HEAD(&req->entry);
> +		list_add_tail(&req->entry, &ring->gpd_ring);
> +		prev_gpd = gpd;
> +	}

> +	if (first_req)

At which circumstances it is not defined? Only when ring->length == 0, right?

> +		t7xx_cldma_rgpd_set_next_ptr(gpd, first_req->gpd_addr);

Looking into this, perhaps it makes sense to refactor this way:

1. Define list head pointer on the stack
2. Iterate over the ring->length and add elements to that list
3. Iterate over the list and set the DMA links
   (t7xx_cldma_rgpd_set_next_ptr() calls)
4. Add this list to the main one.

> +	return 0;
> +}

...

> +static int t7xx_cldma_tx_ring_init(struct cldma_ctrl *md_ctrl, struct cldma_ring *ring)
> +{
> +	struct cldma_request *req, *first_req = NULL;
> +	struct cldma_tgpd *tgpd, *prev_gpd;
> +	int i;
> +
> +	for (i = 0; i < ring->length; i++) {
> +		req = t7xx_alloc_tx_request(md_ctrl);
> +		if (!req) {
> +			t7xx_cldma_ring_free(md_ctrl, ring, DMA_TO_DEVICE);
> +			return -ENOMEM;
> +		}
> +
> +		tgpd = req->gpd;
> +		tgpd->gpd_flags = GPD_FLAGS_IOC;
> +
> +		if (!first_req)
> +			first_req = req;
> +		else
> +			t7xx_cldma_tgpd_set_next_ptr(prev_gpd, req->gpd_addr);
> +
> +		INIT_LIST_HEAD(&req->entry);
> +		list_add_tail(&req->entry, &ring->gpd_ring);
> +		prev_gpd = tgpd;
> +	}
> +
> +	if (first_req)
> +		t7xx_cldma_tgpd_set_next_ptr(tgpd, first_req->gpd_addr);
> +
> +	return 0;

Ditto.

> +}


-- 
With Best Regards,
Andy Shevchenko


