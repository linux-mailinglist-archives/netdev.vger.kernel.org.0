Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CB8487D70
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiAGUFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiAGUFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:05:50 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC60C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 12:05:50 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 8so6301236pgc.10
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 12:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gbu1UV7Je4keqcQjWsILOs+1k4ApZXjllWNZvpUcAyY=;
        b=Ggu+M7GRA58WAOXFL5u2VgLxDJSFBy7yc7+mqNI3FY7rP/LYXpT5BfXZFroBP+Zx9c
         CQ6rTMNdT7youwhkgGq0RHKxHtXIYSYQmpPDBkC4BmkvtYFp8q7BxS8yX1KATD5rPEwa
         zDFN2L+lKdIU9PP2gowGE2NC1Kyr2jBCOcp/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gbu1UV7Je4keqcQjWsILOs+1k4ApZXjllWNZvpUcAyY=;
        b=PplDv0u6AstQVhO9SCkWJoZhQx7cxJXHDhv75Rwdy+tW9O9ui2a5TBbLPRm/1QwDJU
         liSCvT/TnGxjuhAMs6dPl4g0MxQpAt95u29WU6urY/ri9lO1Ffil2bOkzZ5FkIa2im/R
         CjJZsTnegdFwWRw0Knc5w42VYyJqOuTUzcY93pHl3FUReZj5QbX4nhDJuYp8D1Tf3qQ0
         xFlryKt3y5aflnwiTJXbaMMSSGD2IQhi2Yc71nf+/wOsfv6wP0SyS+oCe/lxj3sfeNXU
         8BSjhRAmndkXCoqEed33qp5gaKxAcS+85SZrwJCZtkREVeG+MFmITuI1Soh+BYXS0Hdx
         QAgQ==
X-Gm-Message-State: AOAM531KzlT4jSN1CQ7qJW9KAahytTAtxteqJzvOEZ05OnVioPNDgHu4
        u2ChQ69vF7OmgWTwJvOHaoB2ng==
X-Google-Smtp-Source: ABdhPJzh4NsZEYJ4W8U++BkJJcARgLs5oZM7+ClhAagD5qU4JTrllIyfj/ssE8KrIKjdLFswYSSuYQ==
X-Received: by 2002:a05:6a00:1a52:b0:4bb:3ab:88a6 with SMTP id h18-20020a056a001a5200b004bb03ab88a6mr66566958pfv.29.1641585949835;
        Fri, 07 Jan 2022 12:05:49 -0800 (PST)
Received: from kuabhs-cdev.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id y18sm5929492pfn.202.2022.01.07.12.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 12:05:49 -0800 (PST)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kvalo@codeaurora.org, dianders@chromium.org
Cc:     pillair@codeaurora.org, kuabhs@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] ath10k: search for default BDF name provided in DT
Date:   Fri,  7 Jan 2022 20:04:30 +0000
Message-Id: <20220107200417.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There can be cases where the board-2.bin does not contain
any BDF matching the chip-id+board-id+variant combination.
This causes the wlan probe to fail and renders wifi unusable.
For e.g. if the board-2.bin has default BDF as:
bus=snoc,qmi-board-id=67 but for some reason the board-id
on the wlan chip is not programmed and read 0xff as the
default value. In such cases there won't be any matching BDF
because the board-2.bin will be searched with following:
bus=snoc,qmi-board-id=ff
To address these scenarios, there can be an option to provide
fallback default BDF name in the device tree. If none of the
BDF names match then the board-2.bin file can be searched with
default BDF names assigned in the device tree.

The default BDF name can be set as:
wifi@a000000 {
	status = "okay";
	qcom,ath10k-default-bdf = "bus=snoc,qmi-board-id=67";
};

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
---

 drivers/net/wireless/ath/ath10k/core.c | 30 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |  5 +++++
 drivers/net/wireless/ath/ath10k/qmi.c  |  4 ++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 8f5b8eb368fa..a7008c853f0f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1081,6 +1081,32 @@ int ath10k_core_check_dt(struct ath10k *ar)
 }
 EXPORT_SYMBOL(ath10k_core_check_dt);
 
+int ath10k_core_parse_default_bdf_dt(struct ath10k *ar)
+{
+	struct device_node *node;
+	const char *board_name = NULL;
+
+	ar->id.default_bdf[0] = '\0';
+
+	node = ar->dev->of_node;
+	if (!node)
+		return -ENOENT;
+
+	of_property_read_string(node, "qcom,ath10k-default-bdf",
+				&board_name);
+	if (!board_name)
+		return -ENODATA;
+
+	if (strscpy(ar->id.default_bdf,
+		    board_name, sizeof(ar->id.default_bdf)) < 0)
+		ath10k_warn(ar,
+			    "default board name is longer than allocated buffer, board_name: %s; allocated size: %d\n",
+			    board_name, sizeof(ar->id.default_bdf));
+
+	return 0;
+}
+EXPORT_SYMBOL(ath10k_core_parse_default_bdf_dt);
+
 static int ath10k_download_fw(struct ath10k *ar)
 {
 	u32 address, data_len;
@@ -1441,6 +1467,10 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 	if (ret == -ENOENT && fallback_boardname2)
 		ret = ath10k_core_search_bd(ar, fallback_boardname2, data, len);
 
+	/* check default BDF name if provided in device tree */
+	if (ret == -ENOENT && ar->id.default_bdf[0] != '\0')
+		ret = ath10k_core_search_bd(ar, ar->id.default_bdf, data, len);
+
 	if (ret == -ENOENT) {
 		ath10k_err(ar,
 			   "failed to fetch board data for %s from %s/%s\n",
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9f6680b3be0a..1201bb7bb8ab 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -79,6 +79,9 @@
 /* The magic used by QCA spec */
 #define ATH10K_SMBIOS_BDF_EXT_MAGIC "BDF_"
 
+/* Default BDF board name buffer size */
+#define ATH10K_DEFAULT_BDF_BUFFER_SIZE 0x40
+
 /* Default Airtime weight multipler (Tuned for multiclient performance) */
 #define ATH10K_AIRTIME_WEIGHT_MULTIPLIER  4
 
@@ -1102,6 +1105,7 @@ struct ath10k {
 		bool ext_bid_supported;
 
 		char bdf_ext[ATH10K_SMBIOS_BDF_EXT_STR_LENGTH];
+		char default_bdf[ATH10K_DEFAULT_BDF_BUFFER_SIZE];
 	} id;
 
 	int fw_api;
@@ -1342,6 +1346,7 @@ int ath10k_core_register(struct ath10k *ar,
 void ath10k_core_unregister(struct ath10k *ar);
 int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type);
 int ath10k_core_check_dt(struct ath10k *ar);
+int ath10k_core_parse_default_bdf_dt(struct ath10k *ar);
 void ath10k_core_free_board_files(struct ath10k *ar);
 
 #endif /* _CORE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 80fcb917fe4e..a57675308014 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -831,6 +831,10 @@ static int ath10k_qmi_fetch_board_file(struct ath10k_qmi *qmi)
 	if (ret)
 		ath10k_dbg(ar, ATH10K_DBG_QMI, "DT bdf variant name not set.\n");
 
+	ret = ath10k_core_parse_default_bdf_dt(ar);
+	if (ret)
+		ath10k_dbg(ar, ATH10K_DBG_QMI, "Default BDF name not set in device tree.\n");
+
 	return ath10k_core_fetch_board_file(qmi->ar, ATH10K_BD_IE_BOARD);
 }
 
-- 
2.34.1.575.g55b058a8bb-goog

