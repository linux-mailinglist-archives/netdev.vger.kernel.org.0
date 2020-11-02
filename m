Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658042A36FD
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgKBXN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:13:26 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:54589 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725841AbgKBXNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:13:25 -0500
Received: from localhost.localdomain (ip5f5af1d0.dynamic.kabel-deutschland.de [95.90.241.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 571FE2064712B;
        Tue,  3 Nov 2020 00:13:23 +0100 (CET)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 2/2] ethernet: igb: e1000_phy: Check for ops.force_speed_duplex existence
Date:   Tue,  3 Nov 2020 00:13:07 +0100
Message-Id: <20201102231307.13021-3-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>

The ops field might no be defined, so add a check.

The patch is taken from Open Network Linux (ONL), and it was added there
as part of the patch

    packages/base/any/kernels/3.16+deb8/patches/driver-support-intel-igb-bcm5461X-phy.patch

in ONL commit f32316c63c (Support the BCM54616 and BCM5461S.) [1]. Part
of this commit was already upstreamed in Linux commit eeb0149660 (igb:
support BCM54616 PHY) in 2017.

I applied the forward-ported

    packages/base/any/kernels/5.4-lts/patches/0002-driver-support-intel-igb-bcm5461S-phy.patch

added in ONL commit 5ace6bcdb3 (Add 5.4 LTS kernel build.) [2].

[1]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/f32316c63ce3a64de125b7429115c6d45e942bd1
[2]: https://github.com/opencomputeproject/OpenNetworkLinux/commit/5ace6bcdb37cb8065dcd1d4404b3dcb6424f6331

Cc: Jeffrey Townsend <jeffrey.townsend@bigswitch.com>
Cc: John W Linville <linville@tuxdriver.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 drivers/net/ethernet/intel/igb/e1000_phy.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index 4e0b4ba09a00..4151e55a6d2a 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -1107,11 +1107,13 @@ s32 igb_setup_copper_link(struct e1000_hw *hw)
 		/* PHY will be set to 10H, 10F, 100H or 100F
 		 * depending on user settings.
 		 */
-		hw_dbg("Forcing Speed and Duplex\n");
-		ret_val = hw->phy.ops.force_speed_duplex(hw);
-		if (ret_val) {
-			hw_dbg("Error Forcing Speed and Duplex\n");
-			goto out;
+		if (hw->phy.ops.force_speed_duplex) {
+			hw_dbg("Forcing Speed and Duplex\n");
+			ret_val = hw->phy.ops.force_speed_duplex(hw);
+			if (ret_val) {
+				hw_dbg("Error Forcing Speed and Duplex\n");
+				goto out;
+			}
 		}
 	}
 
-- 
2.29.1

