Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640E027A9AD
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgI1IhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:37:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47780 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1IhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 04:37:18 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kMoei-0006rf-AQ; Mon, 28 Sep 2020 08:37:08 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jeffrey.t.kirsher@intel.com
Cc:     andrew@lunn.ch, Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4] e1000e: Increase polling timeout on MDIC ready bit
Date:   Mon, 28 Sep 2020 16:36:58 +0800
Message-Id: <20200928083658.8567-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200924164542.19906-1-kai.heng.feng@canonical.com>
References: <20200924164542.19906-1-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are seeing the following error after S3 resume:
[  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
[  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
[  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
[  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
[  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
[  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
[  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
...
[  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error

As Andrew Lunn pointed out, MDIO has nothing to do with phy, and indeed
increase polling iteration can resolve the issue.

This patch only papers over the symptom, as we don't really know the
root cause of the issue. The most possible culprit is Intel ME, which
may do its own things that conflict with software.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v4:
 - States that this patch just papers over the symptom.

v3:
 - Moving delay to end of loop doesn't save anytime, move it back.
 - Point out this is quitely likely caused by Intel ME.

v2:
 - Increase polling iteration instead of powering down the phy.

 drivers/net/ethernet/intel/e1000e/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index e11c877595fb..e6d4acd90937 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -203,7 +203,7 @@ s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
 	 * Increasing the time out as testing showed failures with
 	 * the lower time out
 	 */
-	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
+	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 10); i++) {
 		udelay(50);
 		mdic = er32(MDIC);
 		if (mdic & E1000_MDIC_READY)
-- 
2.17.1

