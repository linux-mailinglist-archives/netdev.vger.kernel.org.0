Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1509035C648
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbhDLMc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:32:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239061AbhDLMc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 08:32:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVvjU-00GGID-7f; Mon, 12 Apr 2021 14:32:00 +0200
Date:   Mon, 12 Apr 2021 14:32:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org, leon@kernel.org,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YHQ9wBFbjpRIj45k@lunn.ch>
References: <20210412023455.45594-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412023455.45594-1-decui@microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mana_gd_deregiser_irq(struct gdma_queue *queue)
> +{
> +	struct gdma_dev *gd = queue->gdma_dev;
> +	struct gdma_irq_context *gic;
> +	struct gdma_context *gc;
> +	struct gdma_resource *r;
> +	unsigned int msix_index;
> +	unsigned long flags;
> +
> +	/* At most num_online_cpus() + 1 interrupts are used. */
> +	msix_index = queue->eq.msix_index;
> +	if (WARN_ON(msix_index > num_online_cpus()))
> +		return;

Do you handle hot{un}plug of CPUs?

> +static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
> +					struct gdma_event *event)
> +{
> +	struct hw_channel_context *hwc = ctx;
> +	struct gdma_dev *gd = hwc->gdma_dev;
> +	union hwc_init_type_data type_data;
> +	union hwc_init_eq_id_db eq_db;
> +	u32 type, val;
> +
> +	switch (event->type) {
> +	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
> +		eq_db.as_uint32 = event->details[0];
> +		hwc->cq->gdma_eq->id = eq_db.eq_id;
> +		gd->doorbell = eq_db.doorbell;
> +		break;
> +
> +	case GDMA_EQE_HWC_INIT_DATA:
> +
> +		type_data.as_uint32 = event->details[0];
> +
> +	case GDMA_EQE_HWC_INIT_DONE:
> +		complete(&hwc->hwc_init_eqe_comp);
> +		break;

...

> +	default:
> +		WARN_ON(1);
> +		break;
> +	}

Are these events from the firmware? If you have newer firmware with an
older driver, are you going to spam the kernel log with WARN_ON dumps?

> +static int mana_move_wq_tail(struct gdma_queue *wq, u32 num_units)
> +{
> +	u32 used_space_old;
> +	u32 used_space_new;
> +
> +	used_space_old = wq->head - wq->tail;
> +	used_space_new = wq->head - (wq->tail + num_units);
> +
> +	if (used_space_new > used_space_old) {
> +		WARN_ON(1);
> +		return -ERANGE;
> +	}

You could replace the 1 by the condition. There are a couple of these.

    Andrew
