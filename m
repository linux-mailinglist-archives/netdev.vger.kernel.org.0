Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20F82D1E4C
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgLGXY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgLGXY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 18:24:28 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68193C061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 15:23:48 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c12so4854633pfo.10
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 15:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OlsYdTjJYBNa/5lQA8sp6yi7kT0DFqLKWOnDvSCcpeM=;
        b=Ffcr7rtvgmaZtAep7oe1nruEICdWMQX3Rt60Nb+en1n0E/TENKOsd4kG0qLG+mbX0Z
         g66dkYZyizXm8Fv4gAwJE1ZaRHmErjFKyJqIJhrGuOxOSUqPzvqGBrJfXWoq0cMwmDbA
         HdlK22kIXcUx5YYgymrtI/WBeLg2CNqZAl0OI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OlsYdTjJYBNa/5lQA8sp6yi7kT0DFqLKWOnDvSCcpeM=;
        b=NxO/ceIHFKcFFVtGqqaXz0cuBrF7wwfbICSywXdhV/BKfBK3whLRh4LDC8M/SEPJbr
         f+3rxqwfyaP5nJNE01Hzejp8kx9Y7LtpDl9gnXuaYea3iaPQ5yeAiDjxqrRII4+pjYAN
         cOzJgyPX9j/Utj0IqkGUIzBCKqfv3t2N9m8xMePMvMeqHTCLd05+T6riHocrWB1V3J+1
         kvaXL1i8FLcByxjV0Fc+j/R/qc0WLlvkhkJU9rzJBw7/nSJQuIFsnEZw1LzAKx0sHKVA
         oLlbtZwjqffEREkY+SrTx42Gma3qnOoSC98ZxBAkml7Kgowb/v35tn+MHlT81aQtuVd5
         fCJQ==
X-Gm-Message-State: AOAM532QflYVvXlkTfHNgSfbrfLMFju/PLaUJ3py9qkp0voo5H9McxZx
        D8hwih6gcPo20Iu49pDhArRzYw==
X-Google-Smtp-Source: ABdhPJx7CoEzBXyrzYXVQ2arl2PGTox5WK5z7MX7Wr405c5ksPU8aFNvsvetAsAthBebX5tT5ZqIuQ==
X-Received: by 2002:a63:805:: with SMTP id 5mr20520725pgi.160.1607383427982;
        Mon, 07 Dec 2020 15:23:47 -0800 (PST)
Received: from kuabhs-cdev.c.googlers.com.com (152.33.83.34.bc.googleusercontent.com. [34.83.33.152])
        by smtp.gmail.com with ESMTPSA id k2sm6342454pgi.47.2020.12.07.15.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:23:47 -0800 (PST)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        pillair@codeaurora.org, briannorris@chromium.org,
        dianders@chromium.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v3] ath10k: add option for chip-id based BDF selection
Date:   Mon,  7 Dec 2020 23:20:21 +0000
Message-Id: <20201207231824.v3.1.Ia6b95087ca566f77423f3802a78b946f7b593ff5@changeid>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some devices difference in chip-id should be enough to pick
the right BDF. Add another support for chip-id based BDF selection.
With this new option, ath10k supports 2 fallback options.

The board name with chip-id as option looks as follows
board name 'bus=snoc,qmi-board-id=ff,qmi-chip-id=320'

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
Tested-on: QCA6174 HW3.2 WLAN.RM.4.4.1-00157-QCARMSWPZ-1
Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
---

Changes in v3:
- Resurreted Patch V1 because as per discussion we do need two
fallback board names and refactored ath10k_core_create_board_name.

 drivers/net/wireless/ath/ath10k/core.c | 41 +++++++++++++++++++-------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index d73ad60b571c..09d0fdfa6693 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1349,7 +1349,8 @@ static int ath10k_core_search_bd(struct ath10k *ar,
 
 static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 					      const char *boardname,
-					      const char *fallback_boardname,
+					      const char *fallback_boardname1,
+					      const char *fallback_boardname2,
 					      const char *filename)
 {
 	size_t len, magic_len;
@@ -1398,8 +1399,11 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 	ret = ath10k_core_search_bd(ar, boardname, data, len);
 
 	/* if we didn't find it and have a fallback name, try that */
-	if (ret == -ENOENT && fallback_boardname)
-		ret = ath10k_core_search_bd(ar, fallback_boardname, data, len);
+	if (ret == -ENOENT && fallback_boardname1)
+		ret = ath10k_core_search_bd(ar, fallback_boardname1, data, len);
+
+	if (ret == -ENOENT && fallback_boardname2)
+		ret = ath10k_core_search_bd(ar, fallback_boardname2, data, len);
 
 	if (ret == -ENOENT) {
 		ath10k_err(ar,
@@ -1419,7 +1423,8 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 }
 
 static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
-					 size_t name_len, bool with_variant)
+					 size_t name_len, bool with_variant,
+					 bool with_chip_id)
 {
 	/* strlen(',variant=') + strlen(ar->id.bdf_ext) */
 	char variant[9 + ATH10K_SMBIOS_BDF_EXT_STR_LENGTH] = { 0 };
@@ -1438,7 +1443,7 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 	}
 
 	if (ar->id.qmi_ids_valid) {
-		if (with_variant && ar->id.bdf_ext[0] != '\0')
+		if (with_chip_id)
 			scnprintf(name, name_len,
 				  "bus=%s,qmi-board-id=%x,qmi-chip-id=%x%s",
 				  ath10k_bus_str(ar->hif.bus),
@@ -1482,21 +1487,34 @@ static int ath10k_core_create_eboard_name(struct ath10k *ar, char *name,
 
 int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
 {
-	char boardname[100], fallback_boardname[100];
+	char boardname[100], fallback_boardname1[100], fallback_boardname2[100];
 	int ret;
 
 	if (bd_ie_type == ATH10K_BD_IE_BOARD) {
+		/* With variant and chip id */
 		ret = ath10k_core_create_board_name(ar, boardname,
-						    sizeof(boardname), true);
+						    sizeof(boardname), true,
+						    true);
 		if (ret) {
 			ath10k_err(ar, "failed to create board name: %d", ret);
 			return ret;
 		}
 
-		ret = ath10k_core_create_board_name(ar, fallback_boardname,
-						    sizeof(boardname), false);
+		/* Without variant and only chip-id */
+		ret = ath10k_core_create_board_name(ar, fallback_boardname1,
+						    sizeof(boardname), false,
+						    true);
+		if (ret) {
+			ath10k_err(ar, "failed to create 1st fallback board name: %d", ret);
+			return ret;
+		}
+
+		/* Without variant and without chip-id */
+		ret = ath10k_core_create_board_name(ar, fallback_boardname2,
+						    sizeof(boardname), false,
+						    false);
 		if (ret) {
-			ath10k_err(ar, "failed to create fallback board name: %d", ret);
+			ath10k_err(ar, "failed to create 2nd fallback board name: %d", ret);
 			return ret;
 		}
 	} else if (bd_ie_type == ATH10K_BD_IE_BOARD_EXT) {
@@ -1510,7 +1528,8 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
 
 	ar->bd_api = 2;
 	ret = ath10k_core_fetch_board_data_api_n(ar, boardname,
-						 fallback_boardname,
+						 fallback_boardname1,
+						 fallback_boardname2,
 						 ATH10K_BOARD_API2_FILE);
 	if (!ret)
 		goto success;
-- 
2.29.2.576.ga3fc446d84-goog

