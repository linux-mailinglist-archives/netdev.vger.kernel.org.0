Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46EB2A5AD9
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 01:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgKDABk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 19:01:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgKDABj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 19:01:39 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 411DA20735;
        Wed,  4 Nov 2020 00:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604448099;
        bh=rNsRX9qw/7MQXiB05tFOfeqYO7iNiqFy9zeKQ9JUp4c=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=Wz+zIIAlXXDQWkc2kPljTjcpQxQdcjeLuK6YZZA2MdJQE5NBr1fjKgJthd5eA/Xbc
         LUOgejCVgV/COh1MWGsg2J3OfZxEU8M/ZdsRdHZJ57zgru83nPkAYHNV8UsPMUvdmg
         Z0IbVwwCO2bGubHmMz+t6XgPZlQPrM1A2/6xGrNw=
Message-ID: <02019e49d43ba71d86f9caed761dbfe64a77331b.camel@kernel.org>
Subject: Re: [PATCH 3/4] gve: Rx Buffer Recycling
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Awogbemila <awogbemila@google.com>, netdev@vger.kernel.org
Date:   Tue, 03 Nov 2020 16:01:38 -0800
In-Reply-To: <20201103174651.590586-4-awogbemila@google.com>
References: <20201103174651.590586-1-awogbemila@google.com>
         <20201103174651.590586-4-awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-03 at 09:46 -0800, David Awogbemila wrote:
> This patch lets the driver reuse buffers that have been freed by the
> networking stack.
> 
> In the raw addressing case, this allows the driver avoid allocating
> new
> buffers.
> In the qpl case, the driver can avoid copies.
> 
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h    |  10 +-
>  drivers/net/ethernet/google/gve/gve_rx.c | 194 +++++++++++++++----
> ----

> +	if (len <= priv->rx_copybreak) {
> +		/* Just copy small packets */
> +		skb = gve_rx_copy(dev, napi, page_info, len);
> +		u64_stats_update_begin(&rx->statss);
> +		rx->rx_copied_pkt++;
> +		rx->rx_copybreak_pkt++;
> +		u64_stats_update_end(&rx->statss);
> +	} else {
> +		bool can_flip = gve_rx_can_flip_buffers(dev);
> +		int recycle = 0;
> +
> +		if (can_flip) {
> +			recycle = gve_rx_can_recycle_buffer(page_info-
> >page);
> +			if (recycle < 0) {
> +				gve_schedule_reset(priv);

How would a reset solve anything if your driver is handling pages with
"bad" refcount, i don't agree here that reset is the best course of
action, all you can do here is warn and leak the page ...
this is a critical driver bug and not something that user should
expect. 

> +	
> +		} else {
> +			/* It is possible that the networking stack has
> already
> +			 * finished processing all outstanding packets
> in the buffer
> +			 * and it can be reused.
> +			 * Flipping is unnecessary here - if the
> networking stack still
> +			 * owns half the page it is impossible to tell
> which half. Either
> +			 * the whole page is free or it needs to be
> replaced.
> +			 */
> +			int recycle =
> gve_rx_can_recycle_buffer(page_info->page);
> +
> +			if (recycle < 0) {
> +				gve_schedule_reset(priv);
> +				return false;

Same.


