Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837D3F4AE4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391916AbfKHMML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:12:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732886AbfKHLiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CB721D6C;
        Fri,  8 Nov 2019 11:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213131;
        bh=SCOsppBGLQaVZeUlajuqmFaM0qbiYHtbb7n/++vr5wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ed0pkacBLcVvJUdRjBWkJgbeez2EqYOlpZlzhpWcxoMmeUNpc8YkqwJK/1gqTa7xS
         bQ7XkZb/DoDUji+KILjoqUVACk4qI6cVvseCPIYkbQy17H+jvP6pBSqYP7byMliw3T
         3FFE+bx74KTSFEIWpQwANZHgTObVkl8unzmYfxog=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Sokolowski <jan.sokolowski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 049/205] i40e: Check and correct speed values for link on open
Date:   Fri,  8 Nov 2019 06:35:16 -0500
Message-Id: <20191108113752.12502-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski@intel.com>

[ Upstream commit e78d9a39fd06109022d11c8ca444cfcec2abb290 ]

If our card has been put in an unstable state due to
other drivers interacting with it, speed settings
might be incorrect. If incorrect, forcefully reset them
on open to known default values.

Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 27 ++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 055562c930fb0..1577dbaab7425 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6587,6 +6587,24 @@ static i40e_status i40e_force_link_state(struct i40e_pf *pf, bool is_up)
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status err;
 	u64 mask;
+	u8 speed;
+
+	/* Card might've been put in an unstable state by other drivers
+	 * and applications, which causes incorrect speed values being
+	 * set on startup. In order to clear speed registers, we call
+	 * get_phy_capabilities twice, once to get initial state of
+	 * available speeds, and once to get current PHY config.
+	 */
+	err = i40e_aq_get_phy_capabilities(hw, false, true, &abilities,
+					   NULL);
+	if (err) {
+		dev_err(&pf->pdev->dev,
+			"failed to get phy cap., ret =  %s last_status =  %s\n",
+			i40e_stat_str(hw, err),
+			i40e_aq_str(hw, hw->aq.asq_last_status));
+		return err;
+	}
+	speed = abilities.link_speed;
 
 	/* Get the current phy config */
 	err = i40e_aq_get_phy_capabilities(hw, false, false, &abilities,
@@ -6600,9 +6618,9 @@ static i40e_status i40e_force_link_state(struct i40e_pf *pf, bool is_up)
 	}
 
 	/* If link needs to go up, but was not forced to go down,
-	 * no need for a flap
+	 * and its speed values are OK, no need for a flap
 	 */
-	if (is_up && abilities.phy_type != 0)
+	if (is_up && abilities.phy_type != 0 && abilities.link_speed != 0)
 		return I40E_SUCCESS;
 
 	/* To force link we need to set bits for all supported PHY types,
@@ -6614,7 +6632,10 @@ static i40e_status i40e_force_link_state(struct i40e_pf *pf, bool is_up)
 	config.phy_type_ext = is_up ? (u8)((mask >> 32) & 0xff) : 0;
 	/* Copy the old settings, except of phy_type */
 	config.abilities = abilities.abilities;
-	config.link_speed = abilities.link_speed;
+	if (abilities.link_speed != 0)
+		config.link_speed = abilities.link_speed;
+	else
+		config.link_speed = speed;
 	config.eee_capability = abilities.eee_capability;
 	config.eeer = abilities.eeer_val;
 	config.low_power_ctrl = abilities.d3_lpan;
-- 
2.20.1

