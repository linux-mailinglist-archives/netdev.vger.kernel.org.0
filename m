Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E83D582A7D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 18:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiG0QRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 12:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiG0QRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 12:17:10 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39254B499
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:17:03 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h9so25230273wrm.0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Icy1itBuOJXPstLh7p436HInbNyv8F9IUq31oFPnQsU=;
        b=H/TLrFlbsbJ9lD+RstNCXJV/CCKbsOXFc/Yh8RuzRSJqpS1AqSUt1SGssOGgx2Bgw9
         U7qqW4LztdS96jje0uAwnvNQ91W9j9lvoQnvAkINasOMhRGnAKvjgXehcXhMhqA3crlz
         yepNMV/YU7YeYpCzpJXWAb5Zm7L5p7mdfDbVvPq2rqRi91EIHIZ+Hh2YFohb++cFx7Dl
         eypXGhmtyb1f1ehB2Skfz142QCQUoOMEmMAPqvVm6npvMxEHkn9PnRPZvXNe5SAjOu2w
         eSirbX6E+tBfeUu3O/rZ0fau+rraf8bAgeLDYOv78FO+5p9Pd7R8aK6L1QqMr4O0esXf
         5gwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Icy1itBuOJXPstLh7p436HInbNyv8F9IUq31oFPnQsU=;
        b=1Bt2Ozqm7OLGKPOekoT+ct0wf2pZfwZJ1n7/HT68dHqWMbLNAycVQMfkDiNPpTKYPz
         iNSe/RjcBG/ZbWAroJdAdHGrqOPkgykbDNjx0ikngRiPE4NoggC8qjn1B5Qdl62znd+u
         V/v+3s/v7W37t+HEF21Ewb0zWF5ARUUoWu1b5BF75hQeTKCRMe46PAecWLc0joulUFmx
         ZMuCjA4kskZkWKoAoQDotam1lkLWr9cKSfxvlc+Xi/i7BbLA4bWDXbf3C2u6ewiAXB/H
         ZBdeupzsBk+LVn/56SSFna2mkOlga6CpjFBpPSqyAT2fyihVloeP6/JWguPycKzvbvpD
         V3Xw==
X-Gm-Message-State: AJIora9PL4sGAewQinGtgj70D3yuwsER5eQLJ4lPrJ8lcS/55PWNtOi6
        yhWwjjRRk+dukSWiHqFTrJf8+Q==
X-Google-Smtp-Source: AGRyM1s7fzRmS3iTUCrcUn1INv3SC5qrLxw8s+lr9E2h2PnmVvOvHeXo1vP8RuEuCtFeTJgxsQPcCg==
X-Received: by 2002:a5d:5582:0:b0:21e:9c12:4d65 with SMTP id i2-20020a5d5582000000b0021e9c124d65mr6460870wrv.175.1658938622078;
        Wed, 27 Jul 2022 09:17:02 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id l4-20020a05600012c400b0021e4829d359sm17245474wrx.39.2022.07.27.09.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 09:17:01 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bryan.odonoghue@linaro.org
Subject: [PATCH v3 4/4] wcn36xx: Add debugfs entry to read firmware feature strings
Date:   Wed, 27 Jul 2022 17:16:55 +0100
Message-Id: <20220727161655.2286867-5-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727161655.2286867-1-bryan.odonoghue@linaro.org>
References: <20220727161655.2286867-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the ability to easily find the firmware feature bits reported in the
get feature exchange without having to compile-in debug prints.

root@linaro-alip:~# cat /sys/kernel/debug/ieee80211/phy0/wcn36xx/firmware_feat_caps
MCC
P2P
DOT11AC
SLM_SESSIONIZATION
DOT11AC_OPMODE
SAP32STA
TDLS
P2P_GO_NOA_DECOUPLE_INIT_SCAN
WLANACTIVE_OFFLOAD
BEACON_OFFLOAD
SCAN_OFFLOAD
BCN_MISS_OFFLOAD
STA_POWERSAVE
STA_ADVANCED_PWRSAVE
BCN_FILTER
RTT
RATECTRL
WOW
WLAN_ROAM_SCAN_OFFLOAD
SPECULATIVE_PS_POLL
IBSS_HEARTBEAT_OFFLOAD
WLAN_SCAN_OFFLOAD
WLAN_PERIODIC_TX_PTRN
ADVANCE_TDLS
BATCH_SCAN
FW_IN_TX_PATH
EXTENDED_NSOFFLOAD_SLOT
CH_SWITCH_V1
HT40_OBSS_SCAN
UPDATE_CHANNEL_LIST
WLAN_MCADDR_FLT
WLAN_CH144
TDLS_SCAN_COEXISTENCE
LINK_LAYER_STATS_MEAS
MU_MIMO
EXTENDED_SCAN
DYNAMIC_WMM_PS
MAC_SPOOFED_SCAN
FW_STATS
WPS_PRBRSP_TMPL
BCN_IE_FLT_DELTA

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/debug.c | 39 ++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/debug.h |  1 +
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
index 6af306ae41ad9..58b3c0501bfde 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.c
+++ b/drivers/net/wireless/ath/wcn36xx/debug.c
@@ -21,6 +21,7 @@
 #include "wcn36xx.h"
 #include "debug.h"
 #include "pmc.h"
+#include "firmware.h"
 
 #ifdef CONFIG_WCN36XX_DEBUGFS
 
@@ -136,6 +137,42 @@ static const struct file_operations fops_wcn36xx_dump = {
 	.write =       write_file_dump,
 };
 
+static ssize_t read_file_firmware_feature_caps(struct file *file,
+					       char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct wcn36xx *wcn = file->private_data;
+	size_t len = 0, buf_len = 2048;
+	char *buf;
+	int i;
+	int ret;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&wcn->hal_mutex);
+	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
+		if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i)) {
+			len += scnprintf(buf + len, buf_len - len, "%s\n",
+					 wcn36xx_firmware_get_cap_name(i));
+		}
+		if (len >= buf_len)
+			break;
+	}
+	mutex_unlock(&wcn->hal_mutex);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return ret;
+}
+
+static const struct file_operations fops_wcn36xx_firmware_feat_caps = {
+	.open = simple_open,
+	.read = read_file_firmware_feature_caps,
+};
+
 #define ADD_FILE(name, mode, fop, priv_data)		\
 	do {							\
 		struct dentry *d;				\
@@ -163,6 +200,8 @@ void wcn36xx_debugfs_init(struct wcn36xx *wcn)
 
 	ADD_FILE(bmps_switcher, 0600, &fops_wcn36xx_bmps, wcn);
 	ADD_FILE(dump, 0200, &fops_wcn36xx_dump, wcn);
+	ADD_FILE(firmware_feat_caps, 0200,
+		 &fops_wcn36xx_firmware_feat_caps, wcn);
 }
 
 void wcn36xx_debugfs_exit(struct wcn36xx *wcn)
diff --git a/drivers/net/wireless/ath/wcn36xx/debug.h b/drivers/net/wireless/ath/wcn36xx/debug.h
index 46307aa562d37..7116d96e0543d 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.h
+++ b/drivers/net/wireless/ath/wcn36xx/debug.h
@@ -31,6 +31,7 @@ struct wcn36xx_dfs_entry {
 	struct dentry *rootdir;
 	struct wcn36xx_dfs_file file_bmps_switcher;
 	struct wcn36xx_dfs_file file_dump;
+	struct wcn36xx_dfs_file file_firmware_feat_caps;
 };
 
 void wcn36xx_debugfs_init(struct wcn36xx *wcn);
-- 
2.36.1

