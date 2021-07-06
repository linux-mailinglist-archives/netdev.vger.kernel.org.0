Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2749C3BCEF0
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhGFL1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234949AbhGFLZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E381B61C6A;
        Tue,  6 Jul 2021 11:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570356;
        bh=skqswtmKqrqAPY5m7IrXU75ApWqmW8CDHzvsnzp79pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiWBxB0CJ9Kwy0LE+Ng7xgevLnfwo0uYa8FA3XWXXUgW5msH72HA+YLHnH1U7czGV
         sQ7FQQk79beNNjSnZxRm7MtEE6DH5FACM3R8md8SvA23IClzLJYfno19XKN0sQYlwS
         YuW3+2zKn/DIlirz/DuZd/PfOaahJ18xL4QOsjW7IIPrY/hBJXs9Prqx5MUJFlj8Nz
         ywijC/BW/qmhUQINDYuI5TiElenNut8j/3w9fCZ++cIWURPFelV5nfz764FRaVV1x7
         C726QlpApJb7dgxddufRp+SVOYoEWUnUt45IqSJ9ICtdwUOWT0pPqyD/I1ncpSH8Cu
         bIM69cMZ2ffFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 037/160] igb: handle vlan types with checker enabled
Date:   Tue,  6 Jul 2021 07:16:23 -0400
Message-Id: <20210706111827.2060499-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit c7cbfb028b95360403d579c47aaaeef1ff140964 ]

The sparse build (C=2) finds some issues with how the driver
dealt with the (very difficult) hardware that in some generations
uses little-endian, and in others uses big endian, for the VLAN
field. The code as written picks __le16 as a type and for some
hardware revisions we override it to __be16 as done in this
patch. This impacted the VF driver as well so fix it there too.

Also change the vlan_tci assignment to override the sparse
warning without changing functionality.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 5 +++--
 drivers/net/ethernet/intel/igbvf/netdev.c | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index caa8929289ae..894b9b87dba1 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2643,7 +2643,8 @@ static int igb_parse_cls_flower(struct igb_adapter *adapter,
 			}
 
 			input->filter.match_flags |= IGB_FILTER_FLAG_VLAN_TCI;
-			input->filter.vlan_tci = match.key->vlan_priority;
+			input->filter.vlan_tci =
+				(__force __be16)match.key->vlan_priority;
 		}
 	}
 
@@ -8593,7 +8594,7 @@ static void igb_process_skb_fields(struct igb_ring *rx_ring,
 
 		if (igb_test_staterr(rx_desc, E1000_RXDEXT_STATERR_LB) &&
 		    test_bit(IGB_RING_FLAG_RX_LB_VLAN_BSWAP, &rx_ring->flags))
-			vid = be16_to_cpu(rx_desc->wb.upper.vlan);
+			vid = be16_to_cpu((__force __be16)rx_desc->wb.upper.vlan);
 		else
 			vid = le16_to_cpu(rx_desc->wb.upper.vlan);
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index fb3fbcb13331..630c1155f196 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -83,14 +83,14 @@ static int igbvf_desc_unused(struct igbvf_ring *ring)
 static void igbvf_receive_skb(struct igbvf_adapter *adapter,
 			      struct net_device *netdev,
 			      struct sk_buff *skb,
-			      u32 status, u16 vlan)
+			      u32 status, __le16 vlan)
 {
 	u16 vid;
 
 	if (status & E1000_RXD_STAT_VP) {
 		if ((adapter->flags & IGBVF_FLAG_RX_LB_VLAN_BSWAP) &&
 		    (status & E1000_RXDEXT_STATERR_LB))
-			vid = be16_to_cpu(vlan) & E1000_RXD_SPC_VLAN_MASK;
+			vid = be16_to_cpu((__force __be16)vlan) & E1000_RXD_SPC_VLAN_MASK;
 		else
 			vid = le16_to_cpu(vlan) & E1000_RXD_SPC_VLAN_MASK;
 		if (test_bit(vid, adapter->active_vlans))
-- 
2.30.2

