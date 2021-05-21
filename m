Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB6138CFF8
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhEUViq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhEUVip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:38:45 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F412C061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 14:37:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 49FD64F6A735C;
        Fri, 21 May 2021 14:37:20 -0700 (PDT)
Date:   Fri, 21 May 2021 14:37:19 -0700 (PDT)
Message-Id: <20210521.143719.557231591502681397.davem@davemloft.net>
To:     sr@denx.de
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        ilya.lipnitskiy@gmail.com, code@reto-schneider.ch,
        reto.schneider@husqvarnagroup.com
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: Fix packet statistics
 support for MT7628/88
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210521055715.1844707-1-sr@denx.de>
References: <20210521055715.1844707-1-sr@denx.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 21 May 2021 14:37:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Roese <sr@denx.de>
Date: Fri, 21 May 2021 07:57:15 +0200

> The MT7628/88 SoC(s) have other (limited) packet counter registers than
> currently supported in the mtk_eth_soc driver. This patch adds support
> for reading these registers, so that the packet statistics are correctly
> updated.
> 
> Signed-off-by: Stefan Roese <sr@denx.de>
> Fixes: 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: John Crispin <john@phrozen.org>
> Cc: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> Cc: Reto Schneider <code@reto-schneider.ch>
> Cc: Reto Schneider <reto.schneider@husqvarnagroup.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 56 ++++++++++++---------
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  7 +++
>  2 files changed, 40 insertions(+), 23 deletions(-)
> 
> +		unsigned int base = MTK_GDM1_TX_GBCNT + hw_stats->reg_offset;
> +		u64 stats;
> +
> +		hw_stats->rx_bytes += mtk_r32(mac->hw, base);
> +		stats =  mtk_r32(mac->hw, base + 0x04);
> +		if (stats)
> +			hw_stats->rx_bytes += (stats << 32);
> +		hw_stats->rx_packets += mtk_r32(mac->hw, base + 0x08);
> +		hw_stats->rx_overflow += mtk_r32(mac->hw, base + 0x10);
> +		hw_stats->rx_fcs_errors += mtk_r32(mac->hw, base + 0x14);
> +		hw_stats->rx_short_errors += mtk_r32(mac->hw, base + 0x18);
> +		hw_stats->rx_long_errors += mtk_r32(mac->hw, base + 0x1c);
> +		hw_stats->rx_checksum_errors += mtk_r32(mac->hw, base + 0x20);
> +		hw_stats->rx_flow_control_packets +=
> +			mtk_r32(mac->hw, base + 0x24);
> +		hw_stats->tx_skip += mtk_r32(mac->hw, base + 0x28);
> +		hw_stats->tx_collisions += mtk_r32(mac->hw, base + 0x2c);
> +		hw_stats->tx_bytes += mtk_r32(mac->hw, base + 0x30);
> +		stats =  mtk_r32(mac->hw, base + 0x34);
> +		if (stats)
> +			hw_stats->tx_bytes += (stats << 32);
> +		hw_stats->tx_packets += mtk_r32(mac->hw, base + 0x38);
>  
> +/* Counter / stat register */
> +#define MT7628_SDM_TPCNT	(MT7628_SDM_OFFSET + 0x100)
> +#define MT7628_SDM_TBCNT	(MT7628_SDM_OFFSET + 0x104)
> +#define MT7628_SDM_RPCNT	(MT7628_SDM_OFFSET + 0x108)
> +#define MT7628_SDM_RBCNT	(MT7628_SDM_OFFSET + 0x10c)
> +#define MT7628_SDM_CS_ERR	(MT7628_SDM_OFFSET + 0x110)
> +

The other stats/cpunter regs should be properly defined like this too.

Thank you.
