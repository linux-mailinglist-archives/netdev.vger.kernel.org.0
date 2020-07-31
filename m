Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77493234AF6
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbgGaS1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:27:45 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:49918 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387777AbgGaS1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:27:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596220063; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=o7f3Xk/EixElVTO6+Uz9inas4c+cBqV/P656fdel21Y=; b=iVABvhlLLEbngubZshWzssB6u/vAG3zJhrftUznIXqaNLENKgCuL6Sox/rYV3JwMYTTQ3Q3f
 5Pyj+tyFCHZ2rTtw00WTcDyQLgThozwdgysDjv3RVZwLCaQUicEoY4woBop0iwsUoB3fpqDS
 WOpCN8Uw+c239dTDfUt+5iL0s10=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5f24629d2dfc1b5cc2a50412 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 31 Jul 2020 18:27:41
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 50F4DC433A0; Fri, 31 Jul 2020 18:27:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BAE7DC433AD;
        Fri, 31 Jul 2020 18:27:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BAE7DC433AD
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 1/3] ath10k: Add history for tracking certain events
Date:   Fri, 31 Jul 2020 23:57:20 +0530
Message-Id: <1596220042-2778-2-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
References: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add history for tracking the below events
- register read
- register write
- IRQ trigger
- NAPI poll
- CE service
- WMI cmd
- WMI event
- WMI tx completion

This will help in debugging any crash or any
improper behaviour.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ce.c      |   1 +
 drivers/net/wireless/ath/ath10k/core.h    |  74 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.c   | 133 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h   |  74 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.c    |  15 +++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  10 +++
 7 files changed, 307 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 84ec80c..0f541de 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1299,6 +1299,7 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs->wm_regs;
 	u32 ctrl_addr = ce_state->ctrl_addr;
 
+	ath10k_record_ce_event(ar, ATH10K_CE_SERVICE, ce_id);
 	/*
 	 * Clear before handling
 	 *
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 5c18f6c..46bd5aa 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -970,6 +970,75 @@ struct ath10k_bus_params {
 	bool hl_msdu_ids;
 };
 
+#define ATH10K_REG_ACCESS_HISTORY_MAX	512
+#define ATH10K_CE_EVENT_HISTORY_MAX	1024
+#define ATH10K_WMI_EVENT_HISTORY_MAX	512
+#define ATH10K_WMI_CMD_HISTORY_MAX	256
+
+#define ATH10K_WMI_DATA_LEN	16
+
+enum ath10k_ce_event {
+	ATH10K_IRQ_TRIGGER,
+	ATH10K_NAPI_POLL,
+	ATH10K_CE_SERVICE,
+	ATH10K_NAPI_COMPLETE,
+	ATH10K_NAPI_RESCHED,
+	ATH10K_IRQ_SUMMARY,
+};
+
+enum ath10k_wmi_type {
+	ATH10K_WMI_EVENT,
+	ATH10K_WMI_CMD,
+	ATH10K_WMI_TX_COMPL,
+};
+
+struct ath10k_reg_access_entry {
+	u32 cpu_id;
+	bool write;
+	u32 offset;
+	u32 val;
+	u64 timestamp;
+};
+
+struct ath10k_wmi_event_entry {
+	u32 cpu_id;
+	enum ath10k_wmi_type type;
+	u32 id;
+	u64 timestamp;
+	unsigned char data[ATH10K_WMI_DATA_LEN];
+};
+
+struct ath10k_ce_event_entry {
+	u32 cpu_id;
+	enum ath10k_ce_event event_type;
+	u32 ce_id;
+	u64 timestamp;
+};
+
+struct ath10k_wmi_event_history {
+	struct ath10k_wmi_event_entry *record;
+	u32 max_entries;
+	atomic_t index;
+	/* lock for accessing wmi event history */
+	spinlock_t hist_lock;
+};
+
+struct ath10k_ce_event_history {
+	struct ath10k_ce_event_entry *record;
+	u32 max_entries;
+	atomic_t index;
+	/* lock for accessing ce event history */
+	spinlock_t hist_lock;
+};
+
+struct ath10k_reg_access_history {
+	struct ath10k_reg_access_entry *record;
+	u32 max_entries;
+	atomic_t index;
+	/* lock for accessing register access history */
+	spinlock_t hist_lock;
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -1261,6 +1330,11 @@ struct ath10k {
 	bool coex_support;
 	int coex_gpio_pin;
 
+	struct ath10k_reg_access_history reg_access_history;
+	struct ath10k_ce_event_history ce_event_history;
+	struct ath10k_wmi_event_history wmi_event_history;
+	struct ath10k_wmi_event_history wmi_cmd_history;
+
 	/* must be last */
 	u8 drv_priv[] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index e8250a6..9105b0b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2722,4 +2722,137 @@ void ath10k_dbg_dump(struct ath10k *ar,
 }
 EXPORT_SYMBOL(ath10k_dbg_dump);
 
+int ath10k_core_reg_access_history_init(struct ath10k *ar, u32 max_entries)
+{
+	ar->reg_access_history.record = vzalloc(max_entries *
+						sizeof(struct ath10k_reg_access_entry));
+	if (!ar->reg_access_history.record)
+		return -ENOMEM;
+
+	ar->reg_access_history.max_entries = max_entries;
+	atomic_set(&ar->reg_access_history.index, 0);
+	spin_lock_init(&ar->reg_access_history.hist_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_reg_access_history_init);
+
+int ath10k_core_wmi_cmd_history_init(struct ath10k *ar, u32 max_entries)
+{
+	ar->wmi_cmd_history.record = vzalloc(max_entries *
+					     sizeof(struct ath10k_wmi_event_entry));
+	if (!ar->wmi_cmd_history.record)
+		return -ENOMEM;
+
+	ar->wmi_cmd_history.max_entries = max_entries;
+	atomic_set(&ar->wmi_cmd_history.index, 0);
+	spin_lock_init(&ar->wmi_cmd_history.hist_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_wmi_cmd_history_init);
+
+int ath10k_core_wmi_event_history_init(struct ath10k *ar, u32 max_entries)
+{
+	ar->wmi_event_history.record = vzalloc(max_entries *
+					       sizeof(struct ath10k_wmi_event_entry));
+	if (!ar->wmi_event_history.record)
+		return -ENOMEM;
+
+	ar->wmi_event_history.max_entries = max_entries;
+	atomic_set(&ar->wmi_event_history.index, 0);
+	spin_lock_init(&ar->wmi_event_history.hist_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_wmi_event_history_init);
+
+int ath10k_core_ce_event_history_init(struct ath10k *ar, u32 max_entries)
+{
+	ar->ce_event_history.record = vzalloc(max_entries *
+					      sizeof(struct ath10k_ce_event_entry));
+	if (!ar->ce_event_history.record)
+		return -ENOMEM;
+
+	ar->ce_event_history.max_entries = max_entries;
+	atomic_set(&ar->ce_event_history.index, 0);
+	spin_lock_init(&ar->ce_event_history.hist_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_ce_event_history_init);
+
+void ath10k_record_reg_access(struct ath10k *ar, u32 offset, u32 val, bool write)
+{
+	struct ath10k_reg_access_entry *entry;
+	u32 idx;
+
+	if (!ar->reg_access_history.record)
+		return;
+
+	idx = ath10k_core_get_next_idx(&ar->reg_access_history.index,
+				       ar->reg_access_history.max_entries);
+	entry = &ar->reg_access_history.record[idx];
+
+	entry->timestamp = ath10k_core_get_timestamp();
+	entry->write = write;
+	entry->offset = offset;
+	entry->val = val;
+}
+EXPORT_SYMBOL(ath10k_record_reg_access);
+
+void ath10k_record_wmi_event(struct ath10k *ar, enum ath10k_wmi_type type,
+			     u32 id, unsigned char *data)
+{
+	struct ath10k_wmi_event_entry *entry;
+	u32 idx;
+
+	if (type == ATH10K_WMI_EVENT) {
+		if (!ar->wmi_event_history.record)
+			return;
+
+		spin_lock_bh(&ar->wmi_event_history.hist_lock);
+		idx = ath10k_core_get_next_idx(&ar->reg_access_history.index,
+					       ar->wmi_event_history.max_entries);
+		spin_unlock_bh(&ar->wmi_event_history.hist_lock);
+		entry = &ar->wmi_event_history.record[idx];
+	} else {
+		if (!ar->wmi_cmd_history.record)
+			return;
+
+		spin_lock_bh(&ar->wmi_cmd_history.hist_lock);
+		idx = ath10k_core_get_next_idx(&ar->reg_access_history.index,
+					       ar->wmi_cmd_history.max_entries);
+		spin_unlock_bh(&ar->wmi_cmd_history.hist_lock);
+		entry = &ar->wmi_cmd_history.record[idx];
+	}
+
+	entry->timestamp = ath10k_core_get_timestamp();
+	entry->cpu_id = smp_processor_id();
+	entry->type = type;
+	entry->id = id;
+	memcpy(&entry->data, data + 4, ATH10K_WMI_DATA_LEN);
+}
+EXPORT_SYMBOL(ath10k_record_wmi_event);
+
+void ath10k_record_ce_event(struct ath10k *ar, enum ath10k_ce_event event_type,
+			    int ce_id)
+{
+	struct ath10k_ce_event_entry *entry;
+	u32 idx;
+
+	if (!ar->ce_event_history.record)
+		return;
+
+	idx = ath10k_core_get_next_idx(&ar->ce_event_history.index,
+				       ar->ce_event_history.max_entries);
+	entry = &ar->ce_event_history.record[idx];
+
+	entry->timestamp = ath10k_core_get_timestamp();
+	entry->cpu_id = smp_processor_id();
+	entry->event_type = event_type;
+	entry->ce_id = ce_id;
+}
+EXPORT_SYMBOL(ath10k_record_ce_event);
+
 #endif /* CONFIG_ATH10K_DEBUG */
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 997c1c8..c28aeb1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -258,6 +258,38 @@ void ath10k_dbg_dump(struct ath10k *ar,
 		     enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);
+
+/* ========== History init APIs =========== */
+int ath10k_core_reg_access_history_init(struct ath10k *ar, u32 max_entries);
+int ath10k_core_wmi_cmd_history_init(struct ath10k *ar, u32 max_entries);
+int ath10k_core_wmi_event_history_init(struct ath10k *ar, u32 max_entries);
+int ath10k_core_ce_event_history_init(struct ath10k *ar, u32 max_entries);
+
+/* ========== History record APIs =========== */
+void ath10k_record_reg_access(struct ath10k *ar, u32 offset, u32 val,
+			      bool write);
+void ath10k_record_wmi_event(struct ath10k *ar, enum ath10k_wmi_type type,
+			     u32 id, unsigned char *data);
+void ath10k_record_ce_event(struct ath10k *ar,
+			    enum ath10k_ce_event event_type,
+			    int ce_id);
+
+static inline u64 ath10k_core_get_timestamp(void)
+{
+	struct timespec64 ts;
+
+	ktime_get_real_ts64(&ts);
+	return ((u64)ts.tv_sec * 1000000) + (ts.tv_nsec / 1000);
+}
+
+static inline int ath10k_core_get_next_idx(atomic_t *index, u32 max_entries)
+{
+	u32 curr_idx;
+
+	curr_idx = atomic_fetch_inc(index);
+	return (curr_idx & (max_entries - 1));
+}
+
 #else /* CONFIG_ATH10K_DEBUG */
 
 static inline int __ath10k_dbg(struct ath10k *ar,
@@ -273,6 +305,48 @@ static inline void ath10k_dbg_dump(struct ath10k *ar,
 				   const void *buf, size_t len)
 {
 }
+
+static inline int ath10k_core_reg_access_history_init(struct ath10k *ar,
+						      u32 max_entries)
+{
+	return 0;
+}
+
+static inline int ath10k_core_wmi_cmd_history_init(struct ath10k *ar,
+						   u32 max_entries)
+{
+	return 0;
+}
+
+static inline int ath10k_core_wmi_event_history_init(struct ath10k *ar,
+						     u32 max_entries)
+{
+	return 0;
+}
+
+static inline int ath10k_core_ce_event_history_init(struct ath10k *ar,
+						    u32 max_entries)
+{
+	return 0;
+}
+
+static inline void ath10k_record_reg_access(struct ath10k *ar, u32 offset,
+					    u32 val, bool write)
+{
+}
+
+static inline void ath10k_record_wmi_event(struct ath10k *ar,
+					   enum ath10k_wmi_type type,
+					   u32 id, unsigned char *data)
+{
+}
+
+static inline void ath10k_record_ce_event(struct ath10k *ar,
+					  enum ath10k_ce_event event_type,
+					  int ce_id)
+{
+}
+
 #endif /* CONFIG_ATH10K_DEBUG */
 
 /* Avoid calling __ath10k_dbg() if debug_mask is not set and tracing
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 1ef5fdb..aa7ee32 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -473,6 +473,7 @@ static void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 
+	ath10k_record_reg_access(ar, offset, value, true);
 	iowrite32(value, ar_snoc->mem + offset);
 }
 
@@ -482,6 +483,7 @@ static u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset)
 	u32 val;
 
 	val = ioread32(ar_snoc->mem + offset);
+	ath10k_record_reg_access(ar, offset, val, false);
 
 	return val;
 }
@@ -1159,6 +1161,7 @@ static irqreturn_t ath10k_snoc_per_engine_handler(int irq, void *arg)
 			    ce_id);
 		return IRQ_HANDLED;
 	}
+	ath10k_record_ce_event(ar, ATH10K_IRQ_TRIGGER, ce_id);
 
 	ath10k_ce_disable_interrupt(ar, ce_id);
 	set_bit(ce_id, ar_snoc->pending_ce_irqs);
@@ -1175,6 +1178,7 @@ static int ath10k_snoc_napi_poll(struct napi_struct *ctx, int budget)
 	int done = 0;
 	int ce_id;
 
+	ath10k_record_ce_event(ar, ATH10K_NAPI_POLL, 0);
 	if (test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags)) {
 		napi_complete(ctx);
 		return done;
@@ -1188,8 +1192,12 @@ static int ath10k_snoc_napi_poll(struct napi_struct *ctx, int budget)
 
 	done = ath10k_htt_txrx_compl_task(ar, budget);
 
-	if (done < budget)
+	if (done < budget) {
 		napi_complete(ctx);
+		ath10k_record_ce_event(ar, ATH10K_NAPI_COMPLETE, 0);
+	} else {
+		ath10k_record_ce_event(ar, ATH10K_NAPI_RESCHED, 0);
+	}
 
 	return done;
 }
@@ -1660,6 +1668,11 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	ar->ce_priv = &ar_snoc->ce;
 	msa_size = drv_data->msa_size;
 
+	ath10k_core_reg_access_history_init(ar, ATH10K_REG_ACCESS_HISTORY_MAX);
+	ath10k_core_wmi_event_history_init(ar, ATH10K_WMI_EVENT_HISTORY_MAX);
+	ath10k_core_wmi_cmd_history_init(ar, ATH10K_WMI_CMD_HISTORY_MAX);
+	ath10k_core_ce_event_history_init(ar, ATH10K_CE_EVENT_HISTORY_MAX);
+
 	ath10k_snoc_quirks_init(ar);
 
 	ret = ath10k_snoc_resource_init(ar);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 932266d..9df5748 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -627,6 +627,7 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
 		goto out;
 
+	ath10k_record_wmi_event(ar, ATH10K_WMI_EVENT, id, skb->data);
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
 	consumed = ath10k_tm_event_wmi(ar, id, skb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a81a1ab..8ebd05c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1802,6 +1802,15 @@ struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len)
 
 static void ath10k_wmi_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 {
+	struct wmi_cmd_hdr *cmd_hdr;
+	enum wmi_tlv_event_id id;
+
+	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
+	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
+
+	ath10k_record_wmi_event(ar, ATH10K_WMI_TX_COMPL, id,
+				skb->data + sizeof(struct wmi_cmd_hdr));
+
 	dev_kfree_skb(skb);
 }
 
@@ -1912,6 +1921,7 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 
 	might_sleep();
 
+	ath10k_record_wmi_event(ar, ATH10K_WMI_CMD, cmd_id, skb->data);
 	if (cmd_id == WMI_CMD_UNSUPPORTED) {
 		ath10k_warn(ar, "wmi command %d is not supported by firmware\n",
 			    cmd_id);
-- 
2.7.4

