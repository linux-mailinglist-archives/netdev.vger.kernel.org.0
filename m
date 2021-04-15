Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D72E3615B8
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbhDOWxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237561AbhDOWxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB7961132;
        Thu, 15 Apr 2021 22:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618527203;
        bh=2IxP4258Tf899maDiwPVmiwXEwAlgUgAPktO56+G6NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNzJRknwk8BnQnGS/sqcxYXkxQ83wUY/rPXSmZJj6wFKYQepqMTPJZwLqIllwgls4
         C2qvzCZsqNI90UqprBPbUg1T//cJi2ZUqVw0ntAg/aleMPExm9++z+ZbNHHKenopAd
         zlGijyYEFlBpMbpH9epTdahAbP4EJyso0r//5PzG0PoFL4ReMU2AwPQlVWw9j44n+B
         4SZdSFSUZ5nbF5131gpBOieu/ca4mQkg9RMElNkvTCIUHthNP2M/M5i1DDWwyoPeYU
         b82hnZO6YKDzaTjvE/r6+f0uN50XknIUBik6Vvhbk9EcUyq9t9jt66Ypqp8IMzTBVH
         TkvTzj4ZUYfnA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/6] bnxt: implement ethtool::get_fec_stats
Date:   Thu, 15 Apr 2021 15:53:16 -0700
Message-Id: <20210415225318.2726095-5-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
References: <20210415225318.2726095-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report corrected bits.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
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

