Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800C7FA5B8
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfKMBwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:52:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbfKMBv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D06F20679;
        Wed, 13 Nov 2019 01:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609917;
        bh=/5SV11ftb0X8yX48wLyDYS2i4vnc0xOfd1H3wpD0aY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3LeWONuNXccW+gAEJzTckFe19uznmD0GAxjS0hZY12vKgBOTtFjsnG+Yw+1vnZlC
         kf2WDYWZg/jTdKkxHnW8pPUTs1RzyBiUBOrTnVGjcLhqWjge/CdIopx3jXSnjZAsUV
         3xvo0NCaQ3tVeG0WeXPwAHc4TSxCLYEaMK5uKsUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 066/209] ice: Fix forward to queue group logic
Date:   Tue, 12 Nov 2019 20:48:02 -0500
Message-Id: <20191113015025.9685-66-sashal@kernel.org>
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

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit be8ff000bf83e658e63ab64cf4d2755abc5add5b ]

When adding a rule, queue region size needs to be provided as log base 2
of the number of queues in region. Fix that.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 6b7ec2ae5ad67..4012adbab0112 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -468,6 +468,7 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 	void *daddr = NULL;
 	u32 act = 0;
 	__be16 *off;
+	u8 q_rgn;
 
 	if (opc == ice_aqc_opc_remove_sw_rules) {
 		s_rule->pdata.lkup_tx_rx.act = 0;
@@ -503,14 +504,19 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 		act |= (f_info->fwd_id.q_id << ICE_SINGLE_ACT_Q_INDEX_S) &
 			ICE_SINGLE_ACT_Q_INDEX_M;
 		break;
+	case ICE_DROP_PACKET:
+		act |= ICE_SINGLE_ACT_VSI_FORWARDING | ICE_SINGLE_ACT_DROP |
+			ICE_SINGLE_ACT_VALID_BIT;
+		break;
 	case ICE_FWD_TO_QGRP:
+		q_rgn = f_info->qgrp_size > 0 ?
+			(u8)ilog2(f_info->qgrp_size) : 0;
 		act |= ICE_SINGLE_ACT_TO_Q;
-		act |= (f_info->qgrp_size << ICE_SINGLE_ACT_Q_REGION_S) &
+		act |= (f_info->fwd_id.q_id << ICE_SINGLE_ACT_Q_INDEX_S) &
+			ICE_SINGLE_ACT_Q_INDEX_M;
+		act |= (q_rgn << ICE_SINGLE_ACT_Q_REGION_S) &
 			ICE_SINGLE_ACT_Q_REGION_M;
 		break;
-	case ICE_DROP_PACKET:
-		act |= ICE_SINGLE_ACT_VSI_FORWARDING | ICE_SINGLE_ACT_DROP;
-		break;
 	default:
 		return;
 	}
-- 
2.20.1

