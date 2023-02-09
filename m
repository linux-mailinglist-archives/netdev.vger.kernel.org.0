Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C4F690E3A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBIQTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjBIQT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:19:26 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B4B51C72;
        Thu,  9 Feb 2023 08:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675959565; x=1707495565;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cES7VibJypSD2FgfCCkYJ+cLH4/wP6Ku2mh8oWTrJmk=;
  b=GpdHHnu3089UgXpSZE5dNwaPGa2aWlvTTD0qoYRhm2mwIFebjBfiYgiZ
   pfTWmb9qBrDqJHDIqnRGN8z3FGOxEtVuppgqhWpTw8FcCEhInQ3lkxpr8
   GjSnamINN6UWCPxQY94b9FsGfX3DrdojvYMrR6xtmtReQgE15H28TFTWR
   tZQK0F3mwD2FMZcSjBjIyE5v84NVVw/GykbB6g324dH59dmkJXiryiQpN
   KXtDclcoMMjfr1Jmakh8uHFXhvrGmLcl3pRXUlh1KEYzEtpBG73HSFm3l
   rz65+uXeW+qjaU4ldxKWMtcEHwq7KV5jICtF/3KmK4TIJxY7rUyGLTKlt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="318171166"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="318171166"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 08:19:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776538054"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="776538054"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga002.fm.intel.com with ESMTP; 09 Feb 2023 08:19:16 -0800
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 373D937E3F;
        Thu,  9 Feb 2023 16:19:15 +0000 (GMT)
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Larysa Zaremba <larysa.zaremba@intel.com>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net] ice: xsk: Fix cleaning of XDP_TX frames
Date:   Thu,  9 Feb 2023 17:01:30 +0100
Message-Id: <20230209160130.1779890-1-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Incrementation of xsk_frames inside the for-loop produces
infinite loop, if we have both normal AF_XDP-TX and XDP_TXed
buffers to complete.

Split xsk_frames into 2 variables (xsk_frames and completed_frames)
to eliminate this bug.

Fixes: 29322791bc8b ("ice: xsk: change batched Tx descriptor cleaning")
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
To Tony: this is urgent and should go directly via net. It's tested and acked.
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 7105de6fb344..374b7f10b549 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -800,6 +800,7 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 	struct ice_tx_desc *tx_desc;
 	u16 cnt = xdp_ring->count;
 	struct ice_tx_buf *tx_buf;
+	u16 completed_frames = 0;
 	u16 xsk_frames = 0;
 	u16 last_rs;
 	int i;
@@ -809,19 +810,21 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 	if ((tx_desc->cmd_type_offset_bsz &
 	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE))) {
 		if (last_rs >= ntc)
-			xsk_frames = last_rs - ntc + 1;
+			completed_frames = last_rs - ntc + 1;
 		else
-			xsk_frames = last_rs + cnt - ntc + 1;
+			completed_frames = last_rs + cnt - ntc + 1;
 	}
 
-	if (!xsk_frames)
+	if (!completed_frames)
 		return;
 
-	if (likely(!xdp_ring->xdp_tx_active))
+	if (likely(!xdp_ring->xdp_tx_active)) {
+		xsk_frames = completed_frames;
 		goto skip;
+	}
 
 	ntc = xdp_ring->next_to_clean;
-	for (i = 0; i < xsk_frames; i++) {
+	for (i = 0; i < completed_frames; i++) {
 		tx_buf = &xdp_ring->tx_buf[ntc];
 
 		if (tx_buf->raw_buf) {
@@ -837,7 +840,7 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 	}
 skip:
 	tx_desc->cmd_type_offset_bsz = 0;
-	xdp_ring->next_to_clean += xsk_frames;
+	xdp_ring->next_to_clean += completed_frames;
 	if (xdp_ring->next_to_clean >= cnt)
 		xdp_ring->next_to_clean -= cnt;
 	if (xsk_frames)
-- 
2.35.3

