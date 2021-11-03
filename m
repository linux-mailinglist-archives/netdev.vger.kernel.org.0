Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161A74442E7
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhKCN6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbhKCN6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:58:46 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B4DC061714;
        Wed,  3 Nov 2021 06:56:10 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HkpG06w1KzQkLm;
        Wed,  3 Nov 2021 14:56:08 +0100 (CET)
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
Subject: [PATCH v2 2/2] mwifiex: Add quirk to disable deep sleep with certain hardware revision
Date:   Wed,  3 Nov 2021 14:55:29 +0100
Message-Id: <20211103135529.8537-3-verdre@v0yd.nl>
In-Reply-To: <20211103135529.8537-1-verdre@v0yd.nl>
References: <20211103135529.8537-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B2BE9130B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 88W8897 PCIe+USB card in the hardware revision 20 apparently has a
hardware issue where the card wakes up from deep sleep randomly and very
often, somewhat depending on the card activity, maybe the hardware has a
floating wakeup pin or something. This was found by comparing two MS
Surface Book 2 devices, where one devices wifi card experienced spurious
wakeups, while the other one didn't.

Those continuous wakeups prevent the card from entering host sleep when
the computer suspends. And because the host won't answer to events from
the card anymore while it's suspended, the firmwares internal power
saving state machine seems to get confused and the card can't sleep
anymore at all after that.

Since we can't work around that hardware bug in the firmware, let's
get the hardware revision string from the firmware and match it with
known bad revisions. Then disable auto deep sleep for those revisions,
which makes sure we no longer get those spurious wakeups.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/main.c   | 18 +++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h   |  1 +
 .../wireless/marvell/mwifiex/sta_cmdresp.c    | 20 +++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 19b996c6a260..ace7371c4773 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -226,6 +226,23 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+static void maybe_quirk_fw_disable_ds(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private *priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+	struct mwifiex_ver_ext ver_ext;
+
+	if (test_and_set_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &adapter->work_flags))
+		return;
+
+	memset(&ver_ext, 0, sizeof(ver_ext));
+	ver_ext.version_str_sel = 1;
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
+			     HostCmd_ACT_GEN_GET, 0, &ver_ext, false)) {
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Checking hardware revision failed.\n");
+	}
+}
+
 /*
  * The main process.
  *
@@ -356,6 +373,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 			if (adapter->hw_status == MWIFIEX_HW_STATUS_INIT_DONE) {
 				adapter->hw_status = MWIFIEX_HW_STATUS_READY;
 				mwifiex_init_fw_complete(adapter);
+				maybe_quirk_fw_disable_ds(adapter);
 			}
 		}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 65609ea2327e..eabd0e0a9f56 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -524,6 +524,7 @@ enum mwifiex_adapter_work_flags {
 	MWIFIEX_IS_SUSPENDED,
 	MWIFIEX_IS_HS_CONFIGURED,
 	MWIFIEX_IS_HS_ENABLING,
+	MWIFIEX_IS_REQUESTING_FW_VEREXT,
 };
 
 struct mwifiex_band_config {
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 1bc2a1f78f96..05c38fd90c3c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -708,6 +708,26 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
 
+	if (test_and_clear_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &priv->adapter->work_flags)) {
+		if (strncmp(ver_ext->version_str, "ChipRev:20, BB:9b(10.00), RF:40(21)",
+			    MWIFIEX_VERSION_STR_LENGTH) == 0) {
+			struct mwifiex_ds_auto_ds auto_ds = {
+				.auto_ds = DEEP_SLEEP_OFF,
+			};
+
+			mwifiex_dbg(priv->adapter, MSG,
+				    "Bad HW revision detected, disabling deep sleep\n");
+
+			if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+					     DIS_AUTO_PS, BITMAP_AUTO_DS, &auto_ds, false)) {
+				mwifiex_dbg(priv->adapter, MSG,
+					    "Disabling deep sleep failed.\n");
+			}
+		}
+
+		return 0;
+	}
+
 	if (version_ext) {
 		version_ext->version_str_sel = ver_ext->version_str_sel;
 		memcpy(version_ext->version_str, ver_ext->version_str,
-- 
2.33.1

