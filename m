Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF34951F2A9
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 04:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiEICcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 22:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiEICbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 22:31:05 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0072C580D1
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 19:27:10 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n18so12567464plg.5
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 19:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UVV0zq0BI+Boi5FKN3bFP+EprP0KgXC18tq4wiIrcbg=;
        b=PO8GQx73Vg2JsGT0kyl3GqPW2ozaF5rDSl9B48i25inLdmg///T2YX/nbVqRLK3Du9
         gGQgBwRS14q2LXG70IFuxsLnEkng/7DK7qdLnXofp/vvDEtqhYuujElTUj7UeWjg3xNC
         P77Evszkbo9hTKh1FT2Jko1Nkelcl277S5Cac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UVV0zq0BI+Boi5FKN3bFP+EprP0KgXC18tq4wiIrcbg=;
        b=5cGgbOWwHvXUEa8FDXQ18rS4h5Q52r0cXvT8v71WySqPp/aj6B8SrXTcs9LxD7xpO0
         gOWbTS3I8dssqQSvjQogXvP1ADE6opcjeB1bUiYCPSWTmHuHKw8PH85q3vNKjGV6ZdzP
         jeiyE//GFjrNBJTyXF8/q+kcew3DMKcy4C4FJdJMWolCdF4tgJESMMDXWZsHFmM/3/4u
         AMPTFTfALqDrbdd2NObuKuWZw75vxdPRIXa5V8BShisoOi8zX6VgoS9DHjTdn1eOGbo2
         9AEiBRfOPnHCYe/e4flxbAD/bP1jDHlFXcmKG2xI64a6rlrPi5MBHZDh/6sBWggLksRc
         5qog==
X-Gm-Message-State: AOAM532KG8LYd3V1qbszSFfY7Ue4P7p4S5Ne4W/EP45mpC610XoTwVUx
        2EtwirqUEEIivEAZqzHMDSr8Nw==
X-Google-Smtp-Source: ABdhPJxC8BosOM+WPt9kdM4/G0Q0MjoRMTqdjhSzSHAo+4vQpubAXZjTzID6GZj9w7pUZ54NSYIzKQ==
X-Received: by 2002:a17:902:d4c2:b0:15e:abd0:926f with SMTP id o2-20020a170902d4c200b0015eabd0926fmr14334901plg.129.1652063230046;
        Sun, 08 May 2022 19:27:10 -0700 (PDT)
Received: from kuabhs-cdev.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 1-20020a170902c20100b0015ec44d25dasm5776327pll.235.2022.05.08.19.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 19:27:09 -0700 (PDT)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kvalo@kernel.org
Cc:     netdev@vger.kernel.org, dianders@chromium.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, kuabhs@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v3] ath10k: improve BDF search fallback strategy
Date:   Mon,  9 May 2022 02:26:36 +0000
Message-Id: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Board data files wrapped inside board-2.bin files are
identified based on a combination of bus architecture,
chip-id, board-id or variants. Here is one such example
of a BDF entry in board-2.bin file:
bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
It is possible for few platforms none of the combinations
of bus,qmi-board,chip-id or variants match, e.g. if
board-id is not programmed and thus reads board-id=0xff,
there won't be any matching BDF to be found. In such
situations, the wlan will fail to enumerate.

Currently, to search for BDF, there are two fallback
boardnames creates to search for BDFs in case the full BDF
is not found. It is still possible that even the fallback
boardnames do not match.

As an improvement, search for BDF with full BDF combination
and perform the fallback searches by stripping down the last
elements until a BDF entry is found or none is found for all
possible BDF combinations.e.g.
Search for initial BDF first then followed by reduced BDF
names as follows:
bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_XXXX
bus=snoc,qmi-board-id=67,qmi-chip-id=320
bus=snoc,qmi-board-id=67
bus=snoc
<No BDF found>

Tested-on: WCN3990/hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
---

Changes in v3:
- As discussed, instead of adding support for default BDF in DT, added
a method to drop the last elements from full BDF until a BDF is found.
- Previous patch was "ath10k: search for default BDF name provided in DT"

 drivers/net/wireless/ath/ath10k/core.c | 65 +++++++++++++-------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 688177453b07..ebb0d2a02c28 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1426,15 +1426,31 @@ static int ath10k_core_search_bd(struct ath10k *ar,
 	return ret;
 }
 
+static bool ath10k_create_reduced_boardname(struct ath10k *ar, char *boardname)
+{
+	/* Find last BDF element */
+	char *last_field = strrchr(boardname, ',');
+
+	if (last_field) {
+		/* Drop the last BDF element */
+		last_field[0] = '\0';
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "boardname =%s\n", boardname);
+		return 0;
+	}
+	return -ENODATA;
+}
+
 static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 					      const char *boardname,
-					      const char *fallback_boardname1,
-					      const char *fallback_boardname2,
 					      const char *filename)
 {
-	size_t len, magic_len;
+	size_t len, magic_len, board_len;
 	const u8 *data;
 	int ret;
+	char temp_boardname[100];
+
+	board_len = 100 * sizeof(temp_boardname[0]);
 
 	/* Skip if already fetched during board data download */
 	if (!ar->normal_mode_fw.board)
@@ -1474,20 +1490,24 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 	data += magic_len;
 	len -= magic_len;
 
-	/* attempt to find boardname in the IE list */
-	ret = ath10k_core_search_bd(ar, boardname, data, len);
+	memcpy(temp_boardname, boardname, board_len);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boardname :%s\n", boardname);
 
-	/* if we didn't find it and have a fallback name, try that */
-	if (ret == -ENOENT && fallback_boardname1)
-		ret = ath10k_core_search_bd(ar, fallback_boardname1, data, len);
+retry_search:
+	/* attempt to find boardname in the IE list */
+	ret = ath10k_core_search_bd(ar, temp_boardname, data, len);
 
-	if (ret == -ENOENT && fallback_boardname2)
-		ret = ath10k_core_search_bd(ar, fallback_boardname2, data, len);
+	/* If the full BDF entry was not found then drop the last element and
+	 * recheck until a BDF is found or until all options are exhausted.
+	 */
+	if (ret == -ENOENT)
+		if (!ath10k_create_reduced_boardname(ar, temp_boardname))
+			goto retry_search;
 
 	if (ret == -ENOENT) {
 		ath10k_err(ar,
 			   "failed to fetch board data for %s from %s/%s\n",
-			   boardname, ar->hw_params.fw.dir, filename);
+			   temp_boardname, ar->hw_params.fw.dir, filename);
 		ret = -ENODATA;
 	}
 
@@ -1566,7 +1586,7 @@ static int ath10k_core_create_eboard_name(struct ath10k *ar, char *name,
 
 int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
 {
-	char boardname[100], fallback_boardname1[100], fallback_boardname2[100];
+	char boardname[100];
 	int ret;
 
 	if (bd_ie_type == ATH10K_BD_IE_BOARD) {
@@ -1579,25 +1599,6 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
 			return ret;
 		}
 
-		/* Without variant and only chip-id */
-		ret = ath10k_core_create_board_name(ar, fallback_boardname1,
-						    sizeof(boardname), false,
-						    true);
-		if (ret) {
-			ath10k_err(ar, "failed to create 1st fallback board name: %d",
-				   ret);
-			return ret;
-		}
-
-		/* Without variant and without chip-id */
-		ret = ath10k_core_create_board_name(ar, fallback_boardname2,
-						    sizeof(boardname), false,
-						    false);
-		if (ret) {
-			ath10k_err(ar, "failed to create 2nd fallback board name: %d",
-				   ret);
-			return ret;
-		}
 	} else if (bd_ie_type == ATH10K_BD_IE_BOARD_EXT) {
 		ret = ath10k_core_create_eboard_name(ar, boardname,
 						     sizeof(boardname));
@@ -1609,8 +1610,6 @@ int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
 
 	ar->bd_api = 2;
 	ret = ath10k_core_fetch_board_data_api_n(ar, boardname,
-						 fallback_boardname1,
-						 fallback_boardname2,
 						 ATH10K_BOARD_API2_FILE);
 	if (!ret)
 		goto success;
-- 
2.36.0.512.ge40c2bad7a-goog

