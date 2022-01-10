Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4053448A379
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 00:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345672AbiAJXPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 18:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345449AbiAJXPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 18:15:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDE7C061751
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 15:15:02 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o3so4111549pjs.1
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 15:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tXD6ds/wJNNNR6+gsUz5E9zXmo4UgZdSVHvbR14gs+Y=;
        b=YPI2hPSopRnZCPT/iL0sax0Wp52cZrLsqy1lEM2vxAmASicbqppqQjMXU58P3odr1A
         rMKoe01Qp3ZoNKOytAZat0ly1xG5QHrYZj6s6tOJJaORR/N+EHIu/IVltY9Em74QRhjD
         mh2sY2UOo/q85QYIHEHzeVDNpTzSJwcLoxkO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tXD6ds/wJNNNR6+gsUz5E9zXmo4UgZdSVHvbR14gs+Y=;
        b=tQUaKeACsrauK+EXUcFVCtY5st9s8jY/V8myTFnpHGUSRSTf9KYJgqYHijt2/jgkhC
         aIt70Trm+L8ZZdAc3CqJa34/9Xrr4Py+8foJuJxu5tpLWKW6p8KOJSG4JsBi3kSfBTUc
         NoEwc+55rIija2NpoI4GDaMvzdc02hpXyrszbKOVoAhLnQXCxxE1GMTBCe1yBcKfww+n
         3H/DCv/q/UWbB8/eyU2N5CVZgR163PuPdGKU3GChTuM9KwjFwF1Dm6ijzunGpsgiYlrm
         tFw0iBCY5nVTZYmGIlIpPVhtVdMIB3GaXou0w/unJa6k2U8Hl77G1HFvn0jvykzkm1av
         8uIQ==
X-Gm-Message-State: AOAM530BHC39a+utFi2lV5djd9YMEDVYkDyysAWbn5x3aN9CJABufrxJ
        Z/6m8uh07F1py5yql66OF6nkCXwR2ylUdA==
X-Google-Smtp-Source: ABdhPJyHLbP73irp3jUBms2zRagRvjxwRqg6bBuffJjq2JpKWCStbbVpNXQWTOgbjb+4N8+j+rRqDQ==
X-Received: by 2002:a17:90a:948c:: with SMTP id s12mr109699pjo.106.1641856501976;
        Mon, 10 Jan 2022 15:15:01 -0800 (PST)
Received: from kuabhs-cdev.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z12sm6123924pga.28.2022.01.10.15.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:15:01 -0800 (PST)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kvalo@codeaurora.org, ath10k@lists.infradead.org
Cc:     pillair@codeaurora.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2 1/2] ath10k: search for default BDF name provided in DT
Date:   Mon, 10 Jan 2022 23:14:14 +0000
Message-Id: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
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

Changes in v2: Fix printf formatting issue.

 drivers/net/wireless/ath/ath10k/core.c | 30 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |  5 +++++
 drivers/net/wireless/ath/ath10k/qmi.c  |  4 ++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 8f5b8eb368fa..756856a8eed3 100644
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
+			    "default board name is longer than allocated buffer, board_name: %s; allocated size: %ld\n",
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

