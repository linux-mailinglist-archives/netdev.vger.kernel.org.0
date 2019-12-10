Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD10119523
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfLJVTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729000AbfLJVMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC1020838;
        Tue, 10 Dec 2019 21:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012351;
        bh=gO0zIpFJKpquYQof+OSOD6WGuHnTuW3L0PQvOK9w3vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnInmXfCiiDXmzFRd0ixsXY+9G3P9hiMXncAhv8D8fBO2RavcAOTcm+GFIMGxUljs
         YxBFrdvuCECbvl2KhsXZKSg9YNwcEhVgzgt5rvhqsmkFnju6/wAwxvPkAOGntXGpke
         HekwjO4R+//l4lW/N0SMcazMnyxFe2SUb3ZgFt9c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 281/350] qtnfmac: fix debugfs support for multiple cards
Date:   Tue, 10 Dec 2019 16:06:26 -0500
Message-Id: <20191210210735.9077-242-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit dd4c2260dab04f5ae7bdb79b9470e7da56f48145 ]

Fix merge artifact for commit 0b68fe10b8e8 ("qtnfmac: modify debugfs
to support multiple cards") and finally add debugfs support
for multiple qtnfmac wireless cards.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
index 8ae318b5fe546..4824be0c6231e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
 
 int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
 {
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	char card_id[64];
 	int ret;
 
 	bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
@@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
 	if (ret) {
 		pr_err("failed to attach core\n");
 	} else {
-		qtnf_debugfs_init(bus, DRV_NAME);
+		snprintf(card_id, sizeof(card_id), "%s:%s",
+			 DRV_NAME, pci_name(priv->pdev));
+		qtnf_debugfs_init(bus, card_id);
 		qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
 		qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
 		qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
-- 
2.20.1

