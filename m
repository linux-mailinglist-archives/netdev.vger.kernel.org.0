Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527A91195A0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfLJVWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:22:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbfLJVLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD2A2246C5;
        Tue, 10 Dec 2019 21:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012294;
        bh=vKMXbFupfKEuOwGd555edLeVC3YaeU2X0p7cGoEt+6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lwjIgU+MWw6ft7HVxUF3BjBeuUBL6ZDcxndDrqWWSaZGnl78S10m1hLjlDJSylJB
         96F3mMho3EXMToC0AyTbr2CpfVceiDuevdUodYLepiqcoDzpQjZBp5/rrOdrmfteim
         ah9eSQKAE9xaVhcqirP6WOESg4xEBm5BIYgF7PD0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 233/350] ice: Check for null pointer dereference when setting rings
Date:   Tue, 10 Dec 2019 16:05:38 -0500
Message-Id: <20191210210735.9077-194-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

[ Upstream commit eb0ee8abfeb9ff4b98e8e40217b8667bfb08587a ]

Without this check rebuild vsi can lead to kernel panic.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 214cd6eca405d..2408f0de95fc2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3970,8 +3970,13 @@ int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
 	}
 
 	ice_for_each_txq(vsi, i) {
-		vsi->tx_rings[i]->netdev = vsi->netdev;
-		err = ice_setup_tx_ring(vsi->tx_rings[i]);
+		struct ice_ring *ring = vsi->tx_rings[i];
+
+		if (!ring)
+			return -EINVAL;
+
+		ring->netdev = vsi->netdev;
+		err = ice_setup_tx_ring(ring);
 		if (err)
 			break;
 	}
@@ -3996,8 +4001,13 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 	}
 
 	ice_for_each_rxq(vsi, i) {
-		vsi->rx_rings[i]->netdev = vsi->netdev;
-		err = ice_setup_rx_ring(vsi->rx_rings[i]);
+		struct ice_ring *ring = vsi->rx_rings[i];
+
+		if (!ring)
+			return -EINVAL;
+
+		ring->netdev = vsi->netdev;
+		err = ice_setup_rx_ring(ring);
 		if (err)
 			break;
 	}
-- 
2.20.1

