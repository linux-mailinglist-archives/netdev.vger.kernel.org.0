Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E16538D453
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 09:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhEVHwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 03:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhEVHwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 03:52:45 -0400
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [IPv6:2001:67c:2050:1::465:107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7D5C061574
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 00:51:20 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 4FnFz9316yzQk0y;
        Sat, 22 May 2021 09:51:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id 3Oz7-YulBcRF; Sat, 22 May 2021 09:51:14 +0200 (CEST)
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: Fix packet statistics
 support for MT7628/88
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        ilya.lipnitskiy@gmail.com, code@reto-schneider.ch,
        reto.schneider@husqvarnagroup.com
References: <20210521055715.1844707-1-sr@denx.de>
 <20210521.143719.557231591502681397.davem@davemloft.net>
From:   Stefan Roese <sr@denx.de>
Message-ID: <ee06c234-2781-28b7-23b5-e49f6c563f57@denx.de>
Date:   Sat, 22 May 2021 09:51:12 +0200
MIME-Version: 1.0
In-Reply-To: <20210521.143719.557231591502681397.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -8.62 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3FFFC1867
X-Rspamd-UID: 99d6ed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.05.21 23:37, David Miller wrote:
> From: Stefan Roese <sr@denx.de>
> Date: Fri, 21 May 2021 07:57:15 +0200
> 
>> The MT7628/88 SoC(s) have other (limited) packet counter registers than
>> currently supported in the mtk_eth_soc driver. This patch adds support
>> for reading these registers, so that the packet statistics are correctly
>> updated.
>>
>> Signed-off-by: Stefan Roese <sr@denx.de>
>> Fixes: 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
>> Cc: Felix Fietkau <nbd@nbd.name>
>> Cc: John Crispin <john@phrozen.org>
>> Cc: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
>> Cc: Reto Schneider <code@reto-schneider.ch>
>> Cc: Reto Schneider <reto.schneider@husqvarnagroup.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> ---
>>   drivers/net/ethernet/mediatek/mtk_eth_soc.c | 56 ++++++++++++---------
>>   drivers/net/ethernet/mediatek/mtk_eth_soc.h |  7 +++
>>   2 files changed, 40 insertions(+), 23 deletions(-)
>>
>> +		unsigned int base = MTK_GDM1_TX_GBCNT + hw_stats->reg_offset;
>> +		u64 stats;
>> +
>> +		hw_stats->rx_bytes += mtk_r32(mac->hw, base);
>> +		stats =  mtk_r32(mac->hw, base + 0x04);
>> +		if (stats)
>> +			hw_stats->rx_bytes += (stats << 32);
>> +		hw_stats->rx_packets += mtk_r32(mac->hw, base + 0x08);
>> +		hw_stats->rx_overflow += mtk_r32(mac->hw, base + 0x10);
>> +		hw_stats->rx_fcs_errors += mtk_r32(mac->hw, base + 0x14);
>> +		hw_stats->rx_short_errors += mtk_r32(mac->hw, base + 0x18);
>> +		hw_stats->rx_long_errors += mtk_r32(mac->hw, base + 0x1c);
>> +		hw_stats->rx_checksum_errors += mtk_r32(mac->hw, base + 0x20);
>> +		hw_stats->rx_flow_control_packets +=
>> +			mtk_r32(mac->hw, base + 0x24);
>> +		hw_stats->tx_skip += mtk_r32(mac->hw, base + 0x28);
>> +		hw_stats->tx_collisions += mtk_r32(mac->hw, base + 0x2c);
>> +		hw_stats->tx_bytes += mtk_r32(mac->hw, base + 0x30);
>> +		stats =  mtk_r32(mac->hw, base + 0x34);
>> +		if (stats)
>> +			hw_stats->tx_bytes += (stats << 32);
>> +		hw_stats->tx_packets += mtk_r32(mac->hw, base + 0x38);
>>   
>> +/* Counter / stat register */
>> +#define MT7628_SDM_TPCNT	(MT7628_SDM_OFFSET + 0x100)
>> +#define MT7628_SDM_TBCNT	(MT7628_SDM_OFFSET + 0x104)
>> +#define MT7628_SDM_RPCNT	(MT7628_SDM_OFFSET + 0x108)
>> +#define MT7628_SDM_RBCNT	(MT7628_SDM_OFFSET + 0x10c)
>> +#define MT7628_SDM_CS_ERR	(MT7628_SDM_OFFSET + 0x110)
>> +
> 
> The other stats/cpunter regs should be properly defined like this too.

Okay. Will send v2 with this change shortly.

Thanks,
Stefan
