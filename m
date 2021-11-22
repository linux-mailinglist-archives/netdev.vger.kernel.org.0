Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73F84592DC
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240080AbhKVQWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:22:49 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:42216
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232643AbhKVQWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:22:49 -0500
Received: from HP-EliteBook-840-G7.. (1-171-213-156.dynamic-ip.hinet.net [1.171.213.156])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 42C523F253;
        Mon, 22 Nov 2021 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637597979;
        bh=9DFzQ/hGOpPY2w9z421LKZyZIqGCdRtsLKMhNNyM3q4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=ktHlX7NdqNRgkSwTTi5sjdU1txHiKE5YJ0aNFTcs9BAaFCO7Q4IWZ+wh5rdpYTnw/
         8onYaPehsORGbk16wae1tXJWWrVjTLBsopf3EnncQYFX8UV8ZVHvFp0zZ1GR38O+2l
         kLnSDsDbk5eRbSpQqSppDygBAAd8on+ilvPnDRP2bnfclqlaXPGaqxJ7q3Jc6IKVuO
         dIf7ieaPXQ5STbOEIrwsvAWGRhe4wyEoMqfLVHqU6aNCirgkr460TdhtcjlGN3/NhR
         27t7suuzHst7RnzO9tzdXv45YZzLkcrI1YmIvGYF2yQs6Jo2bMZuC4Ac9adw9KqmNN
         gFzJOun79e3pg==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     sasha.neftin@intel.com, acelan.kao@canonical.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Revert "e1000e: Additional PHY power saving in S0ix"
Date:   Tue, 23 Nov 2021 00:19:25 +0800
Message-Id: <20211122161927.874291-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 3ad3e28cb203309fb29022dea41cd65df0583632.

The s0ix series makes e1000e on TGL and ADL fails to work after s2idle
resume.

There doesn't seem to be any solution soon, so revert the whole series.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 44e2dc8328a22..e16b7c0d98089 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6380,16 +6380,10 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 		ew32(CTRL_EXT, mac_data);
 
 		/* DFT control: PHY bit: page769_20[0] = 1
-		 * page769_20[7] - PHY PLL stop
-		 * page769_20[8] - PHY go to the electrical idle
-		 * page769_20[9] - PHY serdes disable
 		 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
 		 */
 		e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
 		phy_data |= BIT(0);
-		phy_data |= BIT(7);
-		phy_data |= BIT(8);
-		phy_data |= BIT(9);
 		e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
 
 		mac_data = er32(EXTCNF_CTRL);
-- 
2.32.0

