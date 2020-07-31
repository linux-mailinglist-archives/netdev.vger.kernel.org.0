Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3765234AFF
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387881AbgGaS2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:28:14 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:12686 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387854AbgGaS2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 14:28:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596220092; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=vjQiGVYzJ12zA+igqujOYlOj1OL8iIPU8CB8EiC7eQw=; b=BMJk6ZwOLpO1RAP5evBoJoGtW39x1ZQiBSIdAoGop0yrvOrJHxWbPejDAMhyzmP9XYTbq4m9
 YiPZ9dug1guh/sYYmQozymiYUf6qhb3A5jfocpGkIVngw2i3PfSaLwyZ79Qa5HOJXpVoDe+4
 WBSlmYzvX1mm3tMmUWermciypn8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f2462a2eb556d49a65354bd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 31 Jul 2020 18:27:46
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DC2F0C433A0; Fri, 31 Jul 2020 18:27:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 875B1C433A1;
        Fri, 31 Jul 2020 18:27:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 875B1C433A1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 3/3] ath10k: Add debugfs support to enable event history
Date:   Fri, 31 Jul 2020 23:57:22 +0530
Message-Id: <1596220042-2778-4-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
References: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support to enable/disable the recording of
debug events history.

The enable/disable of the history from debugfs will
not make any affect if its not enabled via module
parameter.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 56 +++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 5d08652..6785fae 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -610,6 +610,59 @@ static const struct file_operations fops_simulate_fw_crash = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_history_enable(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	const char buf[] =
+		"To enable recording of certain event history, write to this file with the enable mask\n"
+		"BIT(0): Enable Reg Access history\n"
+		"	- Register write events\n"
+		"	- Register read events\n"
+		"BIT(1): Enable CE events history\n"
+		"	- ATH10K_IRQ_TRIGGER event\n"
+		"	- ATH10K_NAPI_POLL event\n"
+		"	- ATH10K_CE_SERVICE event\n"
+		"	- ATH10K_NAPI_COMPLETE event\n"
+		"	- ATH10K_NAPI_RESCHED event\n"
+		"	- ATH10K_IRQ_SUMMARY event\n"
+		"BIT(2): Enable WMI CMD history\n"
+		"	- WMI CMD event\n"
+		"	- WMI CMD TX completion event\n"
+		"BIT(3): Enable WMI events history\n"
+		"	- WMI Events event\n";
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t ath10k_write_history_enable(struct file *file,
+					   const char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	u32 history_enable_mask;
+	int i, ret;
+
+	ret = kstrtou32_from_user(user_buf, count, 0, &history_enable_mask);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ATH10K_HISTORY_MAX; i++)
+		if (history_enable_mask & BIT(i))
+			set_bit(i, &ath10k_history_enable_mask);
+		else
+			clear_bit(i, &ath10k_history_enable_mask);
+
+	return count;
+}
+
+static const struct file_operations fops_history_enable = {
+	.read = ath10k_read_history_enable,
+	.write = ath10k_write_history_enable,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t ath10k_read_chip_id(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -2658,6 +2711,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("reset_htt_stats", 0200, ar->debug.debugfs_phy, ar,
 			    &fops_reset_htt_stats);
 
+	debugfs_create_file("history_enable", 0644, ar->debug.debugfs_phy, ar,
+			    &fops_history_enable);
+
 	return 0;
 }
 
-- 
2.7.4

