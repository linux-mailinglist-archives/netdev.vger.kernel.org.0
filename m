Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94017FA573
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbfKMCWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:22:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbfKMBxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F726204EC;
        Wed, 13 Nov 2019 01:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609993;
        bh=9tlsXAq1wvbQ7vXhH0WzC2FHYWWLkSRWNraPNNPO6MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udlHMhAnBxFv2gumk0Es+3SIqfgQJD1se1tBYEaIbpH7dOdbszjDW8ClYcxcyDh3A
         PrHgIRLfnAAuu6ZrANgKr+ZVXtkJBJFClKbGMiV3xSThLufLMZIbrZkbUqQeYnlWOK
         JzTSl9SPrscbJcj3cAqW5J/PTqdpu+hUlwf/B9ws=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 104/209] qtnfmac: inform wireless core about supported extended capabilities
Date:   Tue, 12 Nov 2019 20:48:40 -0500
Message-Id: <20191113015025.9685-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit ab1c64a1d349cc7f1090a60ce85a53298e3d371d ]

Driver retrieves information about supported extended capabilities
from wireless card. However this information is not propagated
further to Linux wireless core. Fix this by setting extended
capabilities fields of wiphy structure.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/quantenna/qtnfmac/cfg80211.c    |  9 +++++++++
 .../net/wireless/quantenna/qtnfmac/commands.c    |  3 +--
 drivers/net/wireless/quantenna/qtnfmac/core.c    | 16 ++++++++++++++--
 drivers/net/wireless/quantenna/qtnfmac/core.h    |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 1519d986b74a4..05b93f301ca08 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1126,6 +1126,15 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 		wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
 	}
 
+	if (mac->macinfo.extended_capabilities_len) {
+		wiphy->extended_capabilities =
+			mac->macinfo.extended_capabilities;
+		wiphy->extended_capabilities_mask =
+			mac->macinfo.extended_capabilities_mask;
+		wiphy->extended_capabilities_len =
+			mac->macinfo.extended_capabilities_len;
+	}
+
 	strlcpy(wiphy->fw_version, hw_info->fw_version,
 		sizeof(wiphy->fw_version));
 	wiphy->hw_version = hw_info->hw_version;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 7fe22bb53bfc4..734844b34c266 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1356,8 +1356,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 		ext_capa_mask = NULL;
 	}
 
-	kfree(mac->macinfo.extended_capabilities);
-	kfree(mac->macinfo.extended_capabilities_mask);
+	qtnf_mac_ext_caps_free(mac);
 	mac->macinfo.extended_capabilities = ext_capa;
 	mac->macinfo.extended_capabilities_mask = ext_capa_mask;
 	mac->macinfo.extended_capabilities_len = ext_capa_len;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 19abbc4e23e06..08928d5e252d7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -304,6 +304,19 @@ void qtnf_mac_iface_comb_free(struct qtnf_wmac *mac)
 	}
 }
 
+void qtnf_mac_ext_caps_free(struct qtnf_wmac *mac)
+{
+	if (mac->macinfo.extended_capabilities_len) {
+		kfree(mac->macinfo.extended_capabilities);
+		mac->macinfo.extended_capabilities = NULL;
+
+		kfree(mac->macinfo.extended_capabilities_mask);
+		mac->macinfo.extended_capabilities_mask = NULL;
+
+		mac->macinfo.extended_capabilities_len = 0;
+	}
+}
+
 static void qtnf_vif_reset_handler(struct work_struct *work)
 {
 	struct qtnf_vif *vif = container_of(work, struct qtnf_vif, reset_work);
@@ -493,8 +506,7 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
 	}
 
 	qtnf_mac_iface_comb_free(mac);
-	kfree(mac->macinfo.extended_capabilities);
-	kfree(mac->macinfo.extended_capabilities_mask);
+	qtnf_mac_ext_caps_free(mac);
 	kfree(mac->macinfo.wowlan);
 	wiphy_free(wiphy);
 	bus->mac[macid] = NULL;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index a1e338a1f055a..ecb5c41c8ed76 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -151,6 +151,7 @@ struct qtnf_hw_info {
 struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac);
 struct qtnf_vif *qtnf_mac_get_base_vif(struct qtnf_wmac *mac);
 void qtnf_mac_iface_comb_free(struct qtnf_wmac *mac);
+void qtnf_mac_ext_caps_free(struct qtnf_wmac *mac);
 struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus);
 int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *priv,
 			 const char *name, unsigned char name_assign_type);
-- 
2.20.1

