Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376C6234AF7
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387851AbgGaS1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:27:48 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:58238 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387766AbgGaS1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:27:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596220065; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=030JoecpEIrEnydLpDjXJle+pUmDUIp7YgIR7pKOOMQ=; b=WhNNM+HBR3GljggYw5nQlTOybeTqiM4ICKJlkZzV26jqNtqFx0N7dNfrRQUs2JnB6mFUB9ge
 NUR/8mYpK00OQLWiORxRbaWfg6Av6PAAjjklEm8Q9uqRtXpc+rH0J5XXSY9fVi7WmGXnmnKD
 04lhVoqfRLB+sO1vXxYZJnlLMyQ=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n19.prod.us-west-2.postgun.com with SMTP id
 5f24629fba6d142d1ccbe797 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 31 Jul 2020 18:27:43
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E8C19C433AF; Fri, 31 Jul 2020 18:27:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 407EFC43395;
        Fri, 31 Jul 2020 18:27:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 407EFC43395
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 2/3] ath10k: Add module param to enable history
Date:   Fri, 31 Jul 2020 23:57:21 +0530
Message-Id: <1596220042-2778-3-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
References: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a module param to enable recording history
of certain debug events. This module parameter
is a mask of the different history recording to
be enabled.

The memory for recording the history will not be
allocated if its not enabled via module parameter.
This is to avoid unnecessary memory allocation when
recording the history is not needed.

To enable all the history recording, the driver
should be loaded as below
"insmod ath10k_core.ko history_enable_mask=0xf"

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c  |  3 +++
 drivers/net/wireless/ath/ath10k/core.h  |  8 ++++++++
 drivers/net/wireless/ath/ath10k/debug.c | 26 ++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/debug.h |  1 +
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9104496..f91a9d0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -29,6 +29,7 @@
 unsigned int ath10k_debug_mask;
 EXPORT_SYMBOL(ath10k_debug_mask);
 
+unsigned long ath10k_history_enable_mask;
 static unsigned int ath10k_cryptmode_param;
 static bool uart_print;
 static bool skip_otp;
@@ -46,6 +47,7 @@ module_param(skip_otp, bool, 0644);
 module_param(rawmode, bool, 0644);
 module_param(fw_diag_log, bool, 0644);
 module_param_named(coredump_mask, ath10k_coredump_mask, ulong, 0444);
+module_param_named(history_enable_mask, ath10k_history_enable_mask, ulong, 0444);
 
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
@@ -54,6 +56,7 @@ MODULE_PARM_DESC(cryptmode, "Crypto mode: 0-hardware, 1-software");
 MODULE_PARM_DESC(rawmode, "Use raw 802.11 frame datapath");
 MODULE_PARM_DESC(coredump_mask, "Bitfield of what to include in firmware crash file");
 MODULE_PARM_DESC(fw_diag_log, "Diag based fw log debugging");
+MODULE_PARM_DESC(history_enable_mask, "Enable events history recording");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 46bd5aa..ce429df 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -977,6 +977,14 @@ struct ath10k_bus_params {
 
 #define ATH10K_WMI_DATA_LEN	16
 
+enum ath10k_history {
+	ATH10K_REG_ACCESS_HISTORY,
+	ATH10K_CE_EVENTS_HISTORY,
+	ATH10K_WMI_CMD_HISTORY,
+	ATH10K_WMI_EVENTS_HISTORY,
+	ATH10K_HISTORY_MAX,
+};
+
 enum ath10k_ce_event {
 	ATH10K_IRQ_TRIGGER,
 	ATH10K_NAPI_POLL,
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 9105b0b..5d08652 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2724,6 +2724,9 @@ EXPORT_SYMBOL(ath10k_dbg_dump);
 
 int ath10k_core_reg_access_history_init(struct ath10k *ar, u32 max_entries)
 {
+	if (!test_bit(ATH10K_REG_ACCESS_HISTORY, &ath10k_history_enable_mask))
+		return 0;
+
 	ar->reg_access_history.record = vzalloc(max_entries *
 						sizeof(struct ath10k_reg_access_entry));
 	if (!ar->reg_access_history.record)
@@ -2739,6 +2742,9 @@ EXPORT_SYMBOL(ath10k_core_reg_access_history_init);
 
 int ath10k_core_wmi_cmd_history_init(struct ath10k *ar, u32 max_entries)
 {
+	if (!test_bit(ATH10K_WMI_CMD_HISTORY, &ath10k_history_enable_mask))
+		return 0;
+
 	ar->wmi_cmd_history.record = vzalloc(max_entries *
 					     sizeof(struct ath10k_wmi_event_entry));
 	if (!ar->wmi_cmd_history.record)
@@ -2754,6 +2760,9 @@ EXPORT_SYMBOL(ath10k_core_wmi_cmd_history_init);
 
 int ath10k_core_wmi_event_history_init(struct ath10k *ar, u32 max_entries)
 {
+	if (!test_bit(ATH10K_WMI_EVENTS_HISTORY, &ath10k_history_enable_mask))
+		return 0;
+
 	ar->wmi_event_history.record = vzalloc(max_entries *
 					       sizeof(struct ath10k_wmi_event_entry));
 	if (!ar->wmi_event_history.record)
@@ -2769,6 +2778,9 @@ EXPORT_SYMBOL(ath10k_core_wmi_event_history_init);
 
 int ath10k_core_ce_event_history_init(struct ath10k *ar, u32 max_entries)
 {
+	if (!test_bit(ATH10K_CE_EVENTS_HISTORY, &ath10k_history_enable_mask))
+		return 0;
+
 	ar->ce_event_history.record = vzalloc(max_entries *
 					      sizeof(struct ath10k_ce_event_entry));
 	if (!ar->ce_event_history.record)
@@ -2787,7 +2799,8 @@ void ath10k_record_reg_access(struct ath10k *ar, u32 offset, u32 val, bool write
 	struct ath10k_reg_access_entry *entry;
 	u32 idx;
 
-	if (!ar->reg_access_history.record)
+	if (!test_bit(ATH10K_REG_ACCESS_HISTORY, &ath10k_history_enable_mask) ||
+	    !ar->reg_access_history.record)
 		return;
 
 	idx = ath10k_core_get_next_idx(&ar->reg_access_history.index,
@@ -2808,7 +2821,9 @@ void ath10k_record_wmi_event(struct ath10k *ar, enum ath10k_wmi_type type,
 	u32 idx;
 
 	if (type == ATH10K_WMI_EVENT) {
-		if (!ar->wmi_event_history.record)
+		if (!test_bit(ATH10K_WMI_EVENTS_HISTORY,
+			      &ath10k_history_enable_mask) ||
+		    !ar->wmi_event_history.record)
 			return;
 
 		spin_lock_bh(&ar->wmi_event_history.hist_lock);
@@ -2817,7 +2832,9 @@ void ath10k_record_wmi_event(struct ath10k *ar, enum ath10k_wmi_type type,
 		spin_unlock_bh(&ar->wmi_event_history.hist_lock);
 		entry = &ar->wmi_event_history.record[idx];
 	} else {
-		if (!ar->wmi_cmd_history.record)
+		if (!test_bit(ATH10K_WMI_CMD_HISTORY,
+			      &ath10k_history_enable_mask) ||
+		    !ar->wmi_event_history.record)
 			return;
 
 		spin_lock_bh(&ar->wmi_cmd_history.hist_lock);
@@ -2841,7 +2858,8 @@ void ath10k_record_ce_event(struct ath10k *ar, enum ath10k_ce_event event_type,
 	struct ath10k_ce_event_entry *entry;
 	u32 idx;
 
-	if (!ar->ce_event_history.record)
+	if (!test_bit(ATH10K_CE_EVENTS_HISTORY, &ath10k_history_enable_mask) ||
+	    !ar->ce_event_history.record)
 		return;
 
 	idx = ath10k_core_get_next_idx(&ar->ce_event_history.index,
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index c28aeb1..7799b89 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -75,6 +75,7 @@ struct ath10k_pktlog_hdr {
 #define ATH10K_TX_POWER_MIN_VAL 0
 
 extern unsigned int ath10k_debug_mask;
+extern unsigned long ath10k_history_enable_mask;
 
 __printf(2, 3) void ath10k_info(struct ath10k *ar, const char *fmt, ...);
 __printf(2, 3) void ath10k_err(struct ath10k *ar, const char *fmt, ...);
-- 
2.7.4

