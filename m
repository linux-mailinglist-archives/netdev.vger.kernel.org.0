Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AD543DC3B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJ1HkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:40:15 -0400
Received: from mout-p-102.mailbox.org ([80.241.56.152]:18652 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhJ1HkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:40:13 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4Hfy8820NFzQl1x;
        Thu, 28 Oct 2021 09:37:44 +0200 (CEST)
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
Subject: [PATCH] mwifiex: Add quirk to disable deep sleep with certain hardware revision
Date:   Thu, 28 Oct 2021 09:37:29 +0200
Message-Id: <20211028073729.24408-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6340818B8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 88W8897 PCIe+USB card in the hardware revision 20 apparently has a
hardware issue where the card wakes up from deep sleep randomly and very
often, somewhat depending on the card activity, maybe the hardware has a
floating wakeup pin or something.

Those continuous wakeups prevent the card from entering host sleep when
the computer suspends. And because the host won't answer to events from
the card anymore while it's suspended, the firmwares internal
powersaving state machine seems to get confused and the card can't sleep
anymore at all after that.

Since we can't work around that hardware bug in the firmware, let's
get the hardware revision string from the firmware and match it with
known bad revisions. Then disable auto deep sleep for those revisions,
which makes sure we no longer get those spurious wakeups.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/main.c      | 14 ++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h      |  1 +
 .../net/wireless/marvell/mwifiex/sta_cmdresp.c   | 16 ++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 19b996c6a260..5ab2ad4c7006 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -226,6 +226,19 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+static void maybe_quirk_fw_disable_ds(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private *priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+	struct mwifiex_ver_ext ver_ext;
+
+	set_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &adapter->work_flags);
+
+	memset(&ver_ext, 0, sizeof(ver_ext));
+	ver_ext.version_str_sel = 1;
+	mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
+			 HostCmd_ACT_GEN_GET, 0, &ver_ext, false);
+}
+
 /*
  * The main process.
  *
@@ -356,6 +369,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 			if (adapter->hw_status == MWIFIEX_HW_STATUS_INIT_DONE) {
 				adapter->hw_status = MWIFIEX_HW_STATUS_READY;
 				mwifiex_init_fw_complete(adapter);
+				maybe_quirk_fw_disable_ds(adapter);
 			}
 		}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 90012cbcfd15..1e829d84b1f6 100644
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
index 6b5d35d9e69f..8e49ebca1847 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -708,6 +708,22 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
 
+	if (test_and_clear_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &priv->adapter->work_flags)) {
+		if (strncmp(ver_ext->version_str, "ChipRev:20, BB:9b(10.00), RF:40(21)", 128) == 0) {
+			struct mwifiex_ds_auto_ds auto_ds = {
+				.auto_ds = DEEP_SLEEP_OFF,
+			};
+
+			mwifiex_dbg(priv->adapter, MSG,
+				    "Bad HW revision detected, disabling deep sleep\n");
+
+			mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+					 DIS_AUTO_PS, BITMAP_AUTO_DS, &auto_ds, false);
+		}
+
+		return 0;
+	}
+
 	if (version_ext) {
 		version_ext->version_str_sel = ver_ext->version_str_sel;
 		memcpy(version_ext->version_str, ver_ext->version_str,
-- 
2.31.1

