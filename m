Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAC2430219
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 12:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbhJPKjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 06:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244193AbhJPKjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 06:39:22 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF76C061570;
        Sat, 16 Oct 2021 03:37:14 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [80.241.60.245])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HWfhn1TWJzQkF8;
        Sat, 16 Oct 2021 12:37:13 +0200 (CEST)
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
Subject: [PATCH v2 2/5] mwifiex: Log an error on command failure during key-material upload
Date:   Sat, 16 Oct 2021 12:36:53 +0200
Message-Id: <20211016103656.16791-3-verdre@v0yd.nl>
In-Reply-To: <20211016103656.16791-1-verdre@v0yd.nl>
References: <20211016103656.16791-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43937269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes the KEY_MATERIAL command can fail with the 88W8897 firmware
(when this happens exactly seems pretty random). This appears to prevent
the access point from starting, so it seems like a good idea to log an
error in that case.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 987558c4fc79..6f23ec34e2e2 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -519,8 +519,14 @@ mwifiex_cfg80211_set_default_mgmt_key(struct wiphy *wiphy,
 	encrypt_key.is_igtk_def_key = true;
 	eth_broadcast_addr(encrypt_key.mac_addr);
 
-	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
-				HostCmd_ACT_GEN_SET, true, &encrypt_key, true);
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+			     HostCmd_ACT_GEN_SET, true, &encrypt_key, true)) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Sending KEY_MATERIAL command failed\n");
+		return -1;
+	}
+
+	return 0;
 }
 
 /*
-- 
2.31.1

