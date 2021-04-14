Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D74235EB8A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347091AbhDNDpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346963AbhDNDpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 23:45:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E44C3613C4;
        Wed, 14 Apr 2021 03:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618371904;
        bh=Tpta5X+xuSC6ObVpocfefy1XFdyBOdjLqcRTiOU08X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QewgppHXrb1s4D+JH3eXF62JKWUOAV6BFZZfoBpHDs15i73vdDcPofbNfzJBknVjT
         1sBtPPnHdv4KvjOwgEKPIDHFKc6fhCZXv3CqV9woDV3jXqqNSPyfmvmUzDFXPZKR+5
         YmAGxteYeTTFUcanAIDlTV0ufCb6F+sltW51E33YMPmXfeGHNEO75VY7Rec6P3xDrA
         tWFgqzmEbBGNVXDjqWvEEkD8k36PzjyDw9t5kyT1e5ckpKUvn40s5pGJEegzqIGJ9P
         e8BU3fCYgiI1avI9boEbvJZEdPxKqlpfpDbIMbprIbb3wL2iXDNZhavEw/GTI90WsP
         uhExcCrebAQWQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/6] bnxt: implement ethtool::get_fec_stats
Date:   Tue, 13 Apr 2021 20:44:52 -0700
Message-Id: <20210414034454.1970967-5-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414034454.1970967-1-kuba@kernel.org>
References: <20210414034454.1970967-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report corrected bits.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 2f8b193a772d..7b90357daba1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1930,6 +1930,20 @@ static int bnxt_get_fecparam(struct net_device *dev,
 	return 0;
 }
 
+static void bnxt_get_fec_stats(struct net_device *dev,
+			       struct ethtool_fec_stats *fec_stats)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u64 *rx;
+
+	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS_EXT))
+		return;
+
+	rx = bp->rx_port_stats_ext.sw_stats;
+	fec_stats->corrected_bits.total =
+		*(rx + BNXT_RX_STATS_EXT_OFFSET(rx_corrected_bits));
+}
+
 static u32 bnxt_ethtool_forced_fec_to_fw(struct bnxt_link_info *link_info,
 					 u32 fec)
 {
@@ -3991,6 +4005,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_link_ksettings	= bnxt_get_link_ksettings,
 	.set_link_ksettings	= bnxt_set_link_ksettings,
+	.get_fec_stats		= bnxt_get_fec_stats,
 	.get_fecparam		= bnxt_get_fecparam,
 	.set_fecparam		= bnxt_set_fecparam,
 	.get_pause_stats	= bnxt_get_pause_stats,
-- 
2.30.2

