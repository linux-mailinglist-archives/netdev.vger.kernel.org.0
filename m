Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1769943AC6F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 08:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhJZGxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 02:53:47 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:48288
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232362AbhJZGxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 02:53:46 -0400
Received: from HP-EliteBook-840-G7.. (1-171-100-18.dynamic-ip.hinet.net [1.171.100.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id CA4063F194;
        Tue, 26 Oct 2021 06:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635231081;
        bh=vGic+H/NifUc+D6vVvdBrQarGqiIlpJuvbTZC/BzH2Q=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=SdQgsmA7Zy5Sd5A13HUOVfKbW5XmlSj0f1RWHE6XnwFbmpCoTe18+L/J98ThiU371
         qnfOBWPKoi/5QSnCREi1/2nZ8rfCxW5ExIGeiX1TT/b+bXj/TCMjyY46eU/gRmbeED
         5ZIRXRH6mNTU9UJmRi8JpgPro7b9unHRbNIPsWO5hnqdYnJyjZ8lXJiD87uTwet75R
         FXVmCuV1AUYcNScGk6L8nEhzezsLPp6NLhwFdiwseosBapzXj0mgE9kv1e8lZw25VE
         GTM0yFAvBRwtP3+5bZtjycQKHRP4c0Q5h7SJCabFA6BodGyjVNdINT9lkZjFo4iMmY
         gj7CvAJDefOfw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     sasha.neftin@intel.com, acelan.kao@canonical.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] e1000e: Add a delay to let ME unconfigure s0ix when DPG_EXIT_DONE is already flagged
Date:   Tue, 26 Oct 2021 14:51:12 +0800
Message-Id: <20211026065112.1366205-1-kai.heng.feng@canonical.com>
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

Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 Add missing "Fixes:" tag

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

