Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2953F476F8A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhLPLJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:09:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:17482 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233682AbhLPLJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 06:09:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="238202711"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="238202711"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 03:09:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="519205080"
Received: from jetten-mobl.ger.corp.intel.com ([10.252.36.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 03:09:07 -0800
Date:   Thu, 16 Dec 2021 13:08:55 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com
Subject: Re: [PATCH net-next v3 01/12] net: wwan: t7xx: Add control DMA
 interface
In-Reply-To: <20211207024711.2765-2-ricardo.martinez@linux.intel.com>
Message-ID: <a6325ef-e06e-c236-9d23-42fdb8b62747@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-2-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021, Ricardo Martinez wrote:

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
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>


> +static struct cldma_request *t7xx_cldma_ring_step_forward(struct cldma_ring *ring,
> +							  struct cldma_request *req)
> +{
> +	if (req->entry.next == &ring->gpd_ring)
> +		return list_first_entry(&ring->gpd_ring, struct cldma_request, entry);
> +
> +	return list_next_entry(req, entry);
> +}
> +
> +static struct cldma_request *t7xx_cldma_ring_step_backward(struct cldma_ring *ring,
> +							   struct cldma_request *req)
> +{
> +	if (req->entry.prev == &ring->gpd_ring)
> +		return list_last_entry(&ring->gpd_ring, struct cldma_request, entry);
> +
> +	return list_prev_entry(req, entry);
> +}

Wouldn't these two seems generic enough to warrant adding something like 
list_next/prev_entry_circular(...) to list.h?

> +static int t7xx_cldma_alloc_and_map_skb(struct cldma_ctrl *md_ctrl, struct cldma_request *req,
> +					size_t size)
> +{
> +	req->skb = __dev_alloc_skb(size, GFP_KERNEL);
> +	if (!req->skb)
> +		return -ENOMEM;
> +
> +	req->mapped_buff = dma_map_single(md_ctrl->dev, req->skb->data,
> +					  t7xx_skb_data_size(req->skb), DMA_FROM_DEVICE);

t7xx_skb_data_size() is not defined by this patch but only in a later 
patch in the series.

Also, I'd prefer its name to be changed to e.g. t7xx_skb_data_area_size() 
given what it calculates. IHMO, "data size" refers to actual 
frame/packet/payload and does not include the reserves/*rooms around it
so the name is bit misleading as is.


-- 
 i.

