Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F6E430360
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 17:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbhJPPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 11:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbhJPPfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 11:35:16 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108E0C061765;
        Sat, 16 Oct 2021 08:33:08 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HWnGB0ZrgzQkBw;
        Sat, 16 Oct 2021 17:33:06 +0200 (CEST)
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
Subject: [PATCH v3 5/5] mwifiex: Deactive host sleep using HSCFG after it was activated manually
Date:   Sat, 16 Oct 2021 17:32:44 +0200
Message-Id: <20211016153244.24353-6-verdre@v0yd.nl>
In-Reply-To: <20211016153244.24353-1-verdre@v0yd.nl>
References: <20211016153244.24353-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C725268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When powersaving (so either wifi powersaving or deep sleep, depending on
which state the firmware is in) is disabled, the way the firmware goes
into host sleep is different: Usually the firmware implicitely enters
host sleep on the next SLEEP event we get when we configured host sleep
via HSCFG before. When powersaving is disabled though, there are no
SLEEP events, the way we enter host sleep in that case is different: The
firmware will send us a HS_ACT_REQ event and after that we "manually"
make the firmware enter host sleep by sending it another HSCFG command
with the action HS_ACTIVATE.

Now waking up from host sleep appears to be different depending on
whether powersaving is enabled again: When powersaving is enabled, the
firmware implicitely leaves host sleep as soon as it wakes up and sends
us an AWAKE event. When powersaving is disabled though, it apparently
doesn't implicitely leave host sleep, but instead we need to send it a
HSCFG command with the HS_CONFIGURE action and the HS_CFG_CANCEL
condition. We didn't do that so far, which is why waking up from host
sleep was broken when powersaving is disabled.

So add some additional state to mwifiex_adapter where we keep track of
whether host sleep was activated manually via HS_ACTIVATE, and if that
was the case, deactivate it manually again via HS_CFG_CANCEL.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 21 +++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.c   | 18 ++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h   |  1 +
 .../net/wireless/marvell/mwifiex/sta_cmd.c    |  4 ++++
 4 files changed, 44 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 171a25742600..d6a61f850c6f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -608,6 +608,11 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		return -1;
 	}
 
+	if (priv->adapter->hs_activated_manually &&
+	    cmd_no != HostCmd_CMD_802_11_HS_CFG_ENH) {
+		mwifiex_cancel_hs(priv, MWIFIEX_ASYNC_CMD);
+		priv->adapter->hs_activated_manually = false;
+	}
 
 	/* Get a new command node */
 	cmd_node = mwifiex_get_cmd_node(adapter);
@@ -714,6 +719,15 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 		}
 	}
 
+	/* Same with exit host sleep cmd, luckily that can't happen at the same time as EXIT_PS */
+	if (command == HostCmd_CMD_802_11_HS_CFG_ENH) {
+		struct host_cmd_ds_802_11_hs_cfg_enh *hs_cfg =
+			&host_cmd->params.opt_hs_cfg;
+
+		if (le16_to_cpu(hs_cfg->action) == HS_ACTIVATE)
+				add_tail = false;
+	}
+
 	spin_lock_bh(&adapter->cmd_pending_q_lock);
 	if (add_tail)
 		list_add_tail(&cmd_node->list, &adapter->cmd_pending_q);
@@ -1216,6 +1230,13 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 		    __func__);
 
 	adapter->if_ops.wakeup(adapter);
+
+	if (adapter->hs_activated_manually) {
+		mwifiex_cancel_hs(mwifiex_get_priv (adapter, MWIFIEX_BSS_ROLE_ANY),
+				  MWIFIEX_ASYNC_CMD);
+		adapter->hs_activated_manually = false;
+	}
+
 	adapter->hs_activated = false;
 	clear_bit(MWIFIEX_IS_HS_CONFIGURED, &adapter->work_flags);
 	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 7943fd3b3058..58d434f1285d 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -401,6 +401,12 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 		     !adapter->scan_processing) &&
 		    !adapter->data_sent &&
 		    !skb_queue_empty(&adapter->tx_data_q)) {
+			if (adapter->hs_activated_manually) {
+				mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY),
+						  MWIFIEX_ASYNC_CMD);
+				adapter->hs_activated_manually = false;
+			}
+
 			mwifiex_process_tx_queue(adapter);
 			if (adapter->hs_activated) {
 				clear_bit(MWIFIEX_IS_HS_CONFIGURED,
@@ -418,6 +424,12 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 		    !mwifiex_bypass_txlist_empty(adapter) &&
 		    !mwifiex_is_tdls_chan_switching
 			(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
+			if (adapter->hs_activated_manually) {
+				mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY),
+						  MWIFIEX_ASYNC_CMD);
+				adapter->hs_activated_manually = false;
+			}
+
 			mwifiex_process_bypass_tx(adapter);
 			if (adapter->hs_activated) {
 				clear_bit(MWIFIEX_IS_HS_CONFIGURED,
@@ -434,6 +446,12 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 		    !adapter->data_sent && !mwifiex_wmm_lists_empty(adapter) &&
 		    !mwifiex_is_tdls_chan_switching
 			(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
+			if (adapter->hs_activated_manually) {
+				mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY),
+						  MWIFIEX_ASYNC_CMD);
+				adapter->hs_activated_manually = false;
+			}
+
 			mwifiex_wmm_process_tx(adapter);
 			if (adapter->hs_activated) {
 				clear_bit(MWIFIEX_IS_HS_CONFIGURED,
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 5923c5c14c8d..90012cbcfd15 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -986,6 +986,7 @@ struct mwifiex_adapter {
 	struct timer_list wakeup_timer;
 	struct mwifiex_hs_config_param hs_cfg;
 	u8 hs_activated;
+	u8 hs_activated_manually;
 	u16 hs_activate_wait_q_woken;
 	wait_queue_head_t hs_activate_wait_q;
 	u8 event_body[MAX_EVENT_SIZE];
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 48ea00da1fc9..1e2798dce18f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -396,6 +396,10 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	if (hs_activate) {
 		hs_cfg->action = cpu_to_le16(HS_ACTIVATE);
 		hs_cfg->params.hs_activate.resp_ctrl = cpu_to_le16(RESP_NEEDED);
+
+		adapter->hs_activated_manually = true;
+		mwifiex_dbg(priv->adapter, CMD,
+			    "cmd: Activating host sleep manually\n");
 	} else {
 		hs_cfg->action = cpu_to_le16(HS_CONFIGURE);
 		hs_cfg->params.hs_config.conditions = hscfg_param->conditions;
-- 
2.31.1

