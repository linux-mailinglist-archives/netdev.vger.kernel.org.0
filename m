Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED971A59BD
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbgDKXih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgDKXH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D3B2217D8;
        Sat, 11 Apr 2020 23:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646476;
        bh=eh/ou1/U945hSJW2laNb5oYQ4EspKnZ3Qontij5MsmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Po4o9w3l9XvR3tMOC3WdHbfbM0ml2Ok7WTUalOqgdTHkENe5gex43fD5qIAd4Q/uW
         7eQzn8sRk7JYWNDlwI6He3tz0THc2paJkofakNqBFOr2mCGq3aDoFf8pRr+LkILCcT
         qUpqcslQ41mB8LB1SxrqQ3phnh1S5SoiKMow38CA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 042/121] net: intel: e1000e: fix possible sleep-in-atomic-context bugs in e1000e_get_hw_semaphore()
Date:   Sat, 11 Apr 2020 19:05:47 -0400
Message-Id: <20200411230706.23855-42-sashal@kernel.org>
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

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 2e05f756c7099c8991142382648a37b0d4c85943 ]

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/net/ethernet/intel/e1000e/mac.c, 1366:
	usleep_range in e1000e_get_hw_semaphore
drivers/net/ethernet/intel/e1000e/80003es2lan.c, 322:
	e1000e_get_hw_semaphore in e1000_release_swfw_sync_80003es2lan
drivers/net/ethernet/intel/e1000e/80003es2lan.c, 197:
	e1000_release_swfw_sync_80003es2lan in e1000_release_phy_80003es2lan
drivers/net/ethernet/intel/e1000e/netdev.c, 4883:
	(FUNC_PTR) e1000_release_phy_80003es2lan in e1000e_update_phy_stats
drivers/net/ethernet/intel/e1000e/netdev.c, 4917:
	e1000e_update_phy_stats in e1000e_update_stats
drivers/net/ethernet/intel/e1000e/netdev.c, 5945:
	e1000e_update_stats in e1000e_get_stats64
drivers/net/ethernet/intel/e1000e/netdev.c, 5944:
	spin_lock in e1000e_get_stats64

drivers/net/ethernet/intel/e1000e/mac.c, 1384:
	usleep_range in e1000e_get_hw_semaphore
drivers/net/ethernet/intel/e1000e/80003es2lan.c, 322:
	e1000e_get_hw_semaphore in e1000_release_swfw_sync_80003es2lan
drivers/net/ethernet/intel/e1000e/80003es2lan.c, 197:
	e1000_release_swfw_sync_80003es2lan in e1000_release_phy_80003es2lan
drivers/net/ethernet/intel/e1000e/netdev.c, 4883:
	(FUNC_PTR) e1000_release_phy_80003es2lan in e1000e_update_phy_stats
drivers/net/ethernet/intel/e1000e/netdev.c, 4917:
	e1000e_update_phy_stats in e1000e_update_stats
drivers/net/ethernet/intel/e1000e/netdev.c, 5945:
	e1000e_update_stats in e1000e_get_stats64
drivers/net/ethernet/intel/e1000e/netdev.c, 5944:
	spin_lock in e1000e_get_stats64

(FUNC_PTR) means a function pointer is called.

To fix these bugs, usleep_range() is replaced with udelay().

These bugs are found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/mac.c b/drivers/net/ethernet/intel/e1000e/mac.c
index e531976f8a677..51512a73fdd07 100644
--- a/drivers/net/ethernet/intel/e1000e/mac.c
+++ b/drivers/net/ethernet/intel/e1000e/mac.c
@@ -1363,7 +1363,7 @@ s32 e1000e_get_hw_semaphore(struct e1000_hw *hw)
 		if (!(swsm & E1000_SWSM_SMBI))
 			break;
 
-		usleep_range(50, 100);
+		udelay(100);
 		i++;
 	}
 
@@ -1381,7 +1381,7 @@ s32 e1000e_get_hw_semaphore(struct e1000_hw *hw)
 		if (er32(SWSM) & E1000_SWSM_SWESMBI)
 			break;
 
-		usleep_range(50, 100);
+		udelay(100);
 	}
 
 	if (i == timeout) {
-- 
2.20.1

