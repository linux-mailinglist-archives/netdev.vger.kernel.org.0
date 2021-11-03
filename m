Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26E344496F
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhKCUUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:20:51 -0400
Received: from mout-p-202.mailbox.org ([80.241.56.172]:65402 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhKCUUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:20:50 -0400
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:105:465:1:3:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4Hkykr2kPSzQkF8;
        Wed,  3 Nov 2021 21:18:12 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH v4 1/3] mwifiex: Use a define for firmware version string length
Date:   Wed,  3 Nov 2021 21:17:58 +0100
Message-Id: <20211103201800.13531-2-verdre@v0yd.nl>
In-Reply-To: <20211103201800.13531-1-verdre@v0yd.nl>
References: <20211103201800.13531-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C78726A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the version string we get from the firmware is always 128
characters long, use a define for this size instead of having the number
128 copied all over the place.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/fw.h          | 4 +++-
 drivers/net/wireless/marvell/mwifiex/main.h        | 2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 5 +++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 2ff23ab259ab..63c25c69ed2b 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -2071,9 +2071,11 @@ struct mwifiex_ie_types_robust_coex {
 	__le32 mode;
 } __packed;
 
+#define MWIFIEX_VERSION_STR_LENGTH  128
+
 struct host_cmd_ds_version_ext {
 	u8 version_str_sel;
-	char version_str[128];
+	char version_str[MWIFIEX_VERSION_STR_LENGTH];
 } __packed;
 
 struct host_cmd_ds_mgmt_frame_reg {
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 90012cbcfd15..65609ea2327e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -646,7 +646,7 @@ struct mwifiex_private {
 	struct wireless_dev wdev;
 	struct mwifiex_chan_freq_power cfp;
 	u32 versionstrsel;
-	char version_str[128];
+	char version_str[MWIFIEX_VERSION_STR_LENGTH];
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dfs_dev_dir;
 #endif
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 6b5d35d9e69f..20b69a37f9e1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -711,8 +711,9 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 	if (version_ext) {
 		version_ext->version_str_sel = ver_ext->version_str_sel;
 		memcpy(version_ext->version_str, ver_ext->version_str,
-		       sizeof(char) * 128);
-		memcpy(priv->version_str, ver_ext->version_str, 128);
+		       MWIFIEX_VERSION_STR_LENGTH);
+		memcpy(priv->version_str, ver_ext->version_str,
+		       MWIFIEX_VERSION_STR_LENGTH);
 	}
 	return 0;
 }
-- 
2.33.1

