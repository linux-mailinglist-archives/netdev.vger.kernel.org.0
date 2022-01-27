Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7F949D81A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbiA0Cej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:34:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50830 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbiA0Cej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:34:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0CAA611B5;
        Thu, 27 Jan 2022 02:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC57C340E9;
        Thu, 27 Jan 2022 02:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643250878;
        bh=nBFR2KGBtdN545VFqzbmwbS9CsNlhehTCJbDm0jsjsM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oMhBjV5P/LoBEf6KnKmjvwIypsbknPvT2oll3FELCjE+6UE92FEUqYLyfEWAxDdom
         s2cteejOWOk3V3qz9Sks+XQ/+HC0zoQ8Xh26OlHRCp79GEDkoM1zcH6FvB26dlmD7M
         6rCqMRgkrfF/qWk1AEyFP9uvwj1SSw7H8pbyoLRIwX0+DGJ7x9Aht1JYpll+7qQkYz
         kptbgUIp/SXiX20M2+LRhO5+qYhJdboVUMMFECXdTYDo8LMDqPovTrdiiDUuXtsdKE
         VWcGkjQQaSh37kmyOZ+O9M3l5J4XitKGS3Qfq5wxz5GaUHp7xDKyYkJRqb3MI571W1
         ySmhZyFV/EFDQ==
Date:   Wed, 26 Jan 2022 18:34:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 net-next 2/2] net: mscc: ocelot: use bulk reads for
 stats
Message-ID: <20220126183436.063b467c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125071531.1181948-3-colin.foster@in-advantage.com>
References: <20220125071531.1181948-1-colin.foster@in-advantage.com>
        <20220125071531.1181948-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 23:15:31 -0800 Colin Foster wrote:
> Create and utilize bulk regmap reads instead of single access for gathering
> stats. The background reading of statistics happens frequently, and over
> a few contiguous memory regions.
> 
> High speed PCIe buses and MMIO access will probably see negligible
> performance increase. Lower speed buses like SPI and I2C could see
> significant performance increase, since the bus configuration and register
> access times account for a large percentage of data transfer time.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

> +static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
> +{
> +	struct ocelot_stats_region *region = NULL;
> +	unsigned int last;
> +	int i;
> +
> +	INIT_LIST_HEAD(&ocelot->stats_regions);
> +
> +	for (i = 0; i < ocelot->num_stats; i++) {
> +		if (region && ocelot->stats_layout[i].offset == last + 1) {
> +			region->count++;
> +		} else {
> +			region = devm_kzalloc(ocelot->dev, sizeof(*region),
> +					      GFP_KERNEL);
> +			if (!region)
> +				return -ENOMEM;
> +
> +			region->offset = ocelot->stats_layout[i].offset;
> +			region->count = 1;
> +			list_add_tail(&region->node, &ocelot->stats_regions);
> +		}
> +
> +		last = ocelot->stats_layout[i].offset;
> +	}
> +
> +	list_for_each_entry(region, &ocelot->stats_regions, node) {
> +		region->buf = devm_kzalloc(ocelot->dev,
> +					   region->count * sizeof(*region->buf),
> +					   GFP_KERNEL);

devm_kcalloc()

> +

unnecessary new line

> +		if (!region->buf)
> +			return -ENOMEM;
