Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5AB43AC53
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 08:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhJZGi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 02:38:59 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:47176
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229635AbhJZGi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 02:38:58 -0400
Received: from HP-EliteBook-840-G7.. (1-171-100-18.dynamic-ip.hinet.net [1.171.100.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C40213F195;
        Tue, 26 Oct 2021 06:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635230194;
        bh=tyVL8Khx35GxSh5USxkpTSJMjE0JwY000+fItJfnrxU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=cthBGarBDvxiRC3IU3RzEebge3PrWBOT5VJPaD/SVvRp6JoTMB2lOYAQ/IxnC7fT4
         ayw9MMHWziINlQOWF9xptV2DL/5FQHlMbycfoJZylFVQowOu3+R+o7DwH8KekejRpc
         jn0NSJaQFtig3AhH9dJ1vH1b1O9sdWkW2N8UktZeaR//emRsvl1TLt81zhtVZAQ8UL
         ACgdnCONNAvl/6gp6t7GlUESuCq5NmHNTA2SfO34xjc2VbyuT0Jgab4cVbLuay2nWp
         SW+ynA8bitA8h+CbzGFIbfIAQSMdh6qjcRKH9VKCwjvEy9ayUqL4vq+mqzIyuoN8tw
         e9/jE2TtdfjzQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     sasha.neftin@intel.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] e1000e: Add a delay to let ME unconfigure s0ix when DPG_EXIT_DONE is already flagged
Date:   Tue, 26 Oct 2021 14:36:23 +0800
Message-Id: <20211026063623.1363652-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some ADL platforms, DPG_EXIT_DONE is always flagged so e1000e resume
polling logic doesn't wait until ME really unconfigures s0ix.

So check DPG_EXIT_DONE before issuing EXIT_DPG, and if it's already
flagged, wait for 1 second to let ME unconfigure s0ix.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 44e2dc8328a22..cd81ba00a6bc9 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6493,14 +6493,21 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	u32 mac_data;
 	u16 phy_data;
 	u32 i = 0;
+	bool dpg_exit_done;
 
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+		dpg_exit_done = er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE;
 		/* Request ME unconfigure the device from S0ix */
 		mac_data = er32(H2ME);
 		mac_data &= ~E1000_H2ME_START_DPG;
 		mac_data |= E1000_H2ME_EXIT_DPG;
 		ew32(H2ME, mac_data);
 
+		if (dpg_exit_done) {
+			e_warn("DPG_EXIT_DONE is already flagged. This is a firmware bug\n");
+			msleep(1000);
+		}
+
 		/* Poll up to 2.5 seconds for ME to unconfigure DPG.
 		 * If this takes more than 1 second, show a warning indicating a
 		 * firmware bug
-- 
2.32.0

