Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B6526FB9
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbfEVT62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731062AbfEVTX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:23:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 388B821850;
        Wed, 22 May 2019 19:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553037;
        bh=NnjnBCFSojtYw67bWA3o/Gh/vuEZod/eDSGe2vdg5E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6RXiiwZF37yolHvnzmlj6mm6bTn8ub0kQ6CGbQgufbRk3cFWr7W0TWbR7fefxAA6
         Tm2dNL225AsCCldkQQZRKHr7yOqrpNlvbc+MdMjx281tllOd9Z4j6g15aylZYbYt0U
         a5zEw2OTXNtik5UTKRfvqPrCAoM3nJCgKXO2irXE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 013/317] ice: Separate if conditions for ice_set_features()
Date:   Wed, 22 May 2019 15:18:34 -0400
Message-Id: <20190522192338.23715-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

[ Upstream commit 8f529ff912073f778e3cd74e87fb69a36499fc2f ]

Set features can have multiple features turned on|off in a single
call.  Grouping these all in an if/else means after one condition
is met, other conditions/features will not be evaluated.  Break
the if/else statements by feature to ensure all features will be
handled properly.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8725569d11f0a..d083979acc22c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2490,6 +2490,9 @@ static int ice_set_features(struct net_device *netdev,
 	struct ice_vsi *vsi = np->vsi;
 	int ret = 0;
 
+	/* Multiple features can be changed in one call so keep features in
+	 * separate if/else statements to guarantee each feature is checked
+	 */
 	if (features & NETIF_F_RXHASH && !(netdev->features & NETIF_F_RXHASH))
 		ret = ice_vsi_manage_rss_lut(vsi, true);
 	else if (!(features & NETIF_F_RXHASH) &&
@@ -2502,8 +2505,9 @@ static int ice_set_features(struct net_device *netdev,
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
 		ret = ice_vsi_manage_vlan_stripping(vsi, false);
-	else if ((features & NETIF_F_HW_VLAN_CTAG_TX) &&
-		 !(netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
+
+	if ((features & NETIF_F_HW_VLAN_CTAG_TX) &&
+	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
 		ret = ice_vsi_manage_vlan_insertion(vsi);
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_TX) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
-- 
2.20.1

