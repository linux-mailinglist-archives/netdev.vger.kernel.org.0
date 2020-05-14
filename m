Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2611D3B69
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgENTBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbgENSzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:55:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B99420727;
        Thu, 14 May 2020 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482523;
        bh=WCnPS7QiF7nGaLWKAw6gNpGkTwoK5y0//6jMq9R7/fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gkq6Vzb5T1/Q1IyC1iRtCr6bmN4IiLBNnslcTYyMXIypSidcci/wB0GbekBZ1FwfI
         UUxBpNvMyTiV16gxmyYpXwTh8yaPD+JzRZgUgw4JdjOnDGPzvuaqZp//wUi3jyGdg9
         CnOTQCO0VPYCsXXHT+xztffHLO4A6vLz+C+eoTVk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/39] bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().
Date:   Thu, 14 May 2020 14:54:35 -0400
Message-Id: <20200514185456.21060-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit c72cb303aa6c2ae7e4184f0081c6d11bf03fb96b ]

The current logic in bnxt_fix_features() will inadvertently turn on both
CTAG and STAG VLAN offload if the user tries to disable both.  Fix it
by checking that the user is trying to enable CTAG or STAG before
enabling both.  The logic is supposed to enable or disable both CTAG and
STAG together.

Fixes: 5a9f6b238e59 ("bnxt_en: Enable and disable RX CTAG and RX STAG VLAN acceleration together.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5163da01e54f8..5c954488072ec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6827,6 +6827,7 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 					   netdev_features_t features)
 {
 	struct bnxt *bp = netdev_priv(dev);
+	netdev_features_t vlan_features;
 
 	if ((features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
 		features &= ~NETIF_F_NTUPLE;
@@ -6834,12 +6835,14 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	if ((features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX)) !=
-	    (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX)) {
+	vlan_features = features & (NETIF_F_HW_VLAN_CTAG_RX |
+				    NETIF_F_HW_VLAN_STAG_RX);
+	if (vlan_features != (NETIF_F_HW_VLAN_CTAG_RX |
+			      NETIF_F_HW_VLAN_STAG_RX)) {
 		if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
 			features &= ~(NETIF_F_HW_VLAN_CTAG_RX |
 				      NETIF_F_HW_VLAN_STAG_RX);
-		else
+		else if (vlan_features)
 			features |= NETIF_F_HW_VLAN_CTAG_RX |
 				    NETIF_F_HW_VLAN_STAG_RX;
 	}
-- 
2.20.1

