Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9296511985F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfLJVfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730168AbfLJVfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8192E205C9;
        Tue, 10 Dec 2019 21:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013703;
        bh=k2kvLvL/q8IzY9OsPdyemvu3EapMc47vGOijwnr/ku4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkFUef3exQl/TCgm4zqlGna9yw7uPpyf7GqQTrMS4NcknbNKwC6Sh6bSjnrIIbv5P
         vJwyIG2r8d4VYKASlX4Xd3upAo+yjLAV4R2quwO13JGoIznvWufmAsEjH22SWkWNpw
         uPS5dVK/BrcHe0IDPLltSbqgxs9x3iCby4b+4gCg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 132/177] ice: delay less
Date:   Tue, 10 Dec 2019 16:31:36 -0500
Message-Id: <20191210213221.11921-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 88bb432a55de8ae62106305083a8bfbb23b01ad2 ]

Shorten the delay for SQ responses, but increase the number of loops.
Max delay time is unchanged, but some operations complete much more
quickly.

In the process, add a new define to make the delay count and delay time
more explicit. Add comments to make things more explicit.

This fixes a problem with VF resets failing on with many VFs.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 89f18fe18fe36..921cc0c9a30d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -911,7 +911,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		if (ice_sq_done(hw, cq))
 			break;
 
-		mdelay(1);
+		udelay(ICE_CTL_Q_SQ_CMD_USEC);
 		total_delay++;
 	} while (total_delay < cq->sq_cmd_timeout);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index ea02b89243e2c..0f2cdb06e6efa 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -30,8 +30,9 @@ enum ice_ctl_q {
 	ICE_CTL_Q_ADMIN,
 };
 
-/* Control Queue default settings */
-#define ICE_CTL_Q_SQ_CMD_TIMEOUT	250  /* msecs */
+/* Control Queue timeout settings - max delay 250ms */
+#define ICE_CTL_Q_SQ_CMD_TIMEOUT	2500  /* Count 2500 times */
+#define ICE_CTL_Q_SQ_CMD_USEC		100   /* Check every 100usec */
 
 struct ice_ctl_q_ring {
 	void *dma_head;			/* Virtual address to dma head */
-- 
2.20.1

