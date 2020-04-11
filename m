Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F871A59B1
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgDKXiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbgDKXIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3BEE216FD;
        Sat, 11 Apr 2020 23:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646482;
        bh=rokA8e5ZKXZ+zUwH5JqfHUBB/2ZSp+Z4VP/vlGPSx6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8ws/nKHjXpsLG4m37ePs8QKuYBfUEQ9j4RezT0W7gGOz8VYhue7y+tWM5NmyeBtD
         MzIOzy8IXBZsEWOM4eeL0N0aqapmmDxIUrPkW7tu6skkMH2g5vOf7FAwDLHPTyCb2G
         aHIbw+h0oYgPO38b5a+cMDpNIzmMAEKCZzqVW0xw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 047/121] ice: Fix implicit queue mapping mode in ice_vsi_get_qs
Date:   Sat, 11 Apr 2020 19:05:52 -0400
Message-Id: <20200411230706.23855-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit 39066dc549cf8a688f6e105a4e9f2a8abefbcebe ]

Currently in ice_vsi_get_qs() we set the mapping_mode for Tx and Rx to
vsi->[tx|rx]_mapping_mode, but the problem is vsi->[tx|rx]_mapping_mode
have not been set yet. This was working because ICE_VSI_MAP_CONTIG is
defined to 0. Fix this by being explicit with our mapping mode by
initializing the Tx and Rx structure's mapping_mode to
ICE_VSI_MAP_CONTIG and then setting the vsi->[tx|rx]_mapping_mode to the
[tx|rx]_qs_cfg.mapping_mode values.

Also, only assign the vsi->[tx|rx]_mapping_mode when the queues are
successfully mapped to the VSI. With this change there was no longer a
need to initialize the ret variable to 0 so remove that.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b43bb51f6067a..04ced528d88a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -433,7 +433,7 @@ static int ice_vsi_get_qs(struct ice_vsi *vsi)
 		.scatter_count = ICE_MAX_SCATTER_TXQS,
 		.vsi_map = vsi->txq_map,
 		.vsi_map_offset = 0,
-		.mapping_mode = vsi->tx_mapping_mode
+		.mapping_mode = ICE_VSI_MAP_CONTIG
 	};
 	struct ice_qs_cfg rx_qs_cfg = {
 		.qs_mutex = &pf->avail_q_mutex,
@@ -443,18 +443,21 @@ static int ice_vsi_get_qs(struct ice_vsi *vsi)
 		.scatter_count = ICE_MAX_SCATTER_RXQS,
 		.vsi_map = vsi->rxq_map,
 		.vsi_map_offset = 0,
-		.mapping_mode = vsi->rx_mapping_mode
+		.mapping_mode = ICE_VSI_MAP_CONTIG
 	};
-	int ret = 0;
-
-	vsi->tx_mapping_mode = ICE_VSI_MAP_CONTIG;
-	vsi->rx_mapping_mode = ICE_VSI_MAP_CONTIG;
+	int ret;
 
 	ret = __ice_vsi_get_qs(&tx_qs_cfg);
-	if (!ret)
-		ret = __ice_vsi_get_qs(&rx_qs_cfg);
+	if (ret)
+		return ret;
+	vsi->tx_mapping_mode = tx_qs_cfg.mapping_mode;
 
-	return ret;
+	ret = __ice_vsi_get_qs(&rx_qs_cfg);
+	if (ret)
+		return ret;
+	vsi->rx_mapping_mode = rx_qs_cfg.mapping_mode;
+
+	return 0;
 }
 
 /**
-- 
2.20.1

