Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02C3A8AEB
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfIDQBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732882AbfIDQBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3490F20820;
        Wed,  4 Sep 2019 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612864;
        bh=ETTKq18l3/TKxbOChzT+Z6247m0kFpImbJLPV9d70ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRaOBFFvSHOUBazOezk4BZE+vjJfPl/YAx0QdQe/XgtOILsHw6kjwHNms9nzJy1o9
         gJ/xXGyous1mAhWEO2rynFCXt/yjapJDlX6YUOTWUUdd295P+79UqNLnyQRgVhrCR3
         81pSn51043lLSLlS4KYbTwTX0/WE60syioKOtFR8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 41/52] ibmvnic: Do not process reset during or after device removal
Date:   Wed,  4 Sep 2019 11:59:53 -0400
Message-Id: <20190904160004.3671-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 36f1031c51a2538e5558fb44c6d6b88f98d3c0f2 ]

Currently, the ibmvnic driver will not schedule device resets
if the device is being removed, but does not check the device
state before the reset is actually processed. This leads to a race
where a reset is scheduled with a valid device state but is
processed after the driver has been removed, resulting in an oops.

Fix this by checking the device state before processing a queued
reset event.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0ae43d27cdcff..af1e8671515e0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1996,6 +1996,10 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
+		if (adapter->state == VNIC_REMOVING ||
+		    adapter->state == VNIC_REMOVED)
+			goto out;
+
 		if (adapter->force_reset_recovery) {
 			adapter->force_reset_recovery = false;
 			rc = do_hard_reset(adapter, rwi, reset_state);
@@ -2020,7 +2024,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 		netdev_dbg(adapter->netdev, "Reset failed\n");
 		free_all_rwi(adapter);
 	}
-
+out:
 	adapter->resetting = false;
 	if (we_lock_rtnl)
 		rtnl_unlock();
-- 
2.20.1

