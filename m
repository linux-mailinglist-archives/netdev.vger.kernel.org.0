Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99F0FA53E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfKMBxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbfKMBxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82062222D3;
        Wed, 13 Nov 2019 01:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610023;
        bh=j1xtx9yjAgRktUtejvRwP+MnUo+B8NrgqFSuVJrAbdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+kOh8iElHlaNSAc/FSBbT4fvsRwcnb3WKbOk9UIEDL6BRFDr2KhYBMDsRaGT3ndh
         Bi2fiZcPKWnWQoBEBmVCa0qm7O4/ezsB64zFqCePCrYbl6ot/qKSGq/B1hsR6Rg78C
         /mZrpHVCaMD7d14s+3bqhxmOX891TWDHHIMg630Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 123/209] net: hns3: Fix for rx vlan id handle to support Rev 0x21 hardware
Date:   Tue, 12 Nov 2019 20:48:59 -0500
Message-Id: <20191113015025.9685-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 701a6d6ac78c76083ddb7c6581fdbedd95093e11 ]

In revision 0x20, we use vlan id != 0 to check whether a vlan tag
has been offloaded, so vlan id 0 is not supported.

In revision 0x21, rx buffer descriptor adds two bits to indicate
whether one or more vlan tags have been offloaded, so vlan id 0
is valid now.

This patch seperates the handle for vlan id 0, add vlan id 0 support
for revision 0x21.

Fixes: 5b5455a9ed5a ("net: hns3: Add STRP_TAGP field support for hardware revision 0x21")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 30 ++++++++-----------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 15030df574a8b..e11a7de20b8f4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2124,18 +2124,18 @@ static void hns3_rx_skb(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	napi_gro_receive(&ring->tqp_vector->napi, skb);
 }
 
-static u16 hns3_parse_vlan_tag(struct hns3_enet_ring *ring,
-			       struct hns3_desc *desc, u32 l234info)
+static bool hns3_parse_vlan_tag(struct hns3_enet_ring *ring,
+				struct hns3_desc *desc, u32 l234info,
+				u16 *vlan_tag)
 {
 	struct pci_dev *pdev = ring->tqp->handle->pdev;
-	u16 vlan_tag;
 
 	if (pdev->revision == 0x20) {
-		vlan_tag = le16_to_cpu(desc->rx.ot_vlan_tag);
-		if (!(vlan_tag & VLAN_VID_MASK))
-			vlan_tag = le16_to_cpu(desc->rx.vlan_tag);
+		*vlan_tag = le16_to_cpu(desc->rx.ot_vlan_tag);
+		if (!(*vlan_tag & VLAN_VID_MASK))
+			*vlan_tag = le16_to_cpu(desc->rx.vlan_tag);
 
-		return vlan_tag;
+		return (*vlan_tag != 0);
 	}
 
 #define HNS3_STRP_OUTER_VLAN	0x1
@@ -2144,17 +2144,14 @@ static u16 hns3_parse_vlan_tag(struct hns3_enet_ring *ring,
 	switch (hnae3_get_field(l234info, HNS3_RXD_STRP_TAGP_M,
 				HNS3_RXD_STRP_TAGP_S)) {
 	case HNS3_STRP_OUTER_VLAN:
-		vlan_tag = le16_to_cpu(desc->rx.ot_vlan_tag);
-		break;
+		*vlan_tag = le16_to_cpu(desc->rx.ot_vlan_tag);
+		return true;
 	case HNS3_STRP_INNER_VLAN:
-		vlan_tag = le16_to_cpu(desc->rx.vlan_tag);
-		break;
+		*vlan_tag = le16_to_cpu(desc->rx.vlan_tag);
+		return true;
 	default:
-		vlan_tag = 0;
-		break;
+		return false;
 	}
-
-	return vlan_tag;
 }
 
 static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
@@ -2256,8 +2253,7 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
 	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
 		u16 vlan_tag;
 
-		vlan_tag = hns3_parse_vlan_tag(ring, desc, l234info);
-		if (vlan_tag & VLAN_VID_MASK)
+		if (hns3_parse_vlan_tag(ring, desc, l234info, &vlan_tag))
 			__vlan_hwaccel_put_tag(skb,
 					       htons(ETH_P_8021Q),
 					       vlan_tag);
-- 
2.20.1

