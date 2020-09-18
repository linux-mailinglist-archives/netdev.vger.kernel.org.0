Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491322703C2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgIRSLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIRSLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:11:21 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AC5C0613CE;
        Fri, 18 Sep 2020 11:11:21 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so6535125wrm.2;
        Fri, 18 Sep 2020 11:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=twRz23yZf6eaE9M3zNCtvW7DmmvSIjcDQenkIUopmbg=;
        b=S4Y6ud2ZBuiNBfodRimnKH85TE0+PFc5f3cog7e4FVcUntBRrs7tGEPJcdTFRI7Mbz
         +4eyv0HcDOcIjSmmJGv15O6t9+s0mZ1GNXWxk+BGmI7SYse809qyAtUMHXoBClkQjXk5
         Hdkme0ql1qKGWsgqBw6ueZflGMwuK0lzowEbwuLod0bZp0vpOA6ylZzVdcUmAyplYEhA
         F5ckIjFJJNqt8S5Lx38vbvm1AMCBgTRd8ne7SVdvM1ZQbI6Zq2SOQ3zla/Fv1sxcP3G6
         0r1qQ+L0Xr55XBFwCJOimd403Db14GfW5a3iDH/H4Hk1KEmKW1DzQBoZvpHkZ7g+1uuo
         wpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=twRz23yZf6eaE9M3zNCtvW7DmmvSIjcDQenkIUopmbg=;
        b=F2PvmlcK6E8dxZ/gLzQ75W4pJssFnZFJCv/P28maenfYueZHdgwoitj6RnjYOkZldn
         aPldqRYpeCY5eRgerzMAQKDeMvJMeH33LtFAYcCFqAdqtF8GF2angg7Mz+Y37WlvYw4f
         BmOrDbHpUP8MsBn7CWVsgK6E+ZXuRgdl4ODt4Mc1YxZX13XD8z8Lv2FPyil+FmoDaV7G
         HrvsKXU8ZAj/GwD3PQ/VjGPJcgTDs16r1DoZXi2fgsJC2b45KuqDs8ZsOQ8CMYwzU7yI
         14uUUFiFp70MzEAG5Vgo+hd+LAif6yXs6L4GQ2HQs0u34LJUdV9uWl/cmR4M9dOOZMyB
         634w==
X-Gm-Message-State: AOAM531vRb077YTmC3wiFHyV00/8SuSh4BeBm2EvSBLUX8zGTMsejp3l
        ZbFRwXbvZRrOyU/Ig8O+/pU=
X-Google-Smtp-Source: ABdhPJz5qboAe0D4h6LRiEVeOh2FCp/s/l8p0s+SXu1AFjTZGn2GAcz1R/ZFOtnUnFQVkFBj/Mbk4Q==
X-Received: by 2002:a5d:4a0e:: with SMTP id m14mr41490284wrq.313.1600452679871;
        Fri, 18 Sep 2020 11:11:19 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-95-248-206-89.retail.telecomitalia.it. [95.248.206.89])
        by smtp.googlemail.com with ESMTPSA id f23sm21461466wmc.3.2020.09.18.11.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 11:11:18 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: [PATCH v2 1/2] ath10k: Introduce download cal from mtd
Date:   Fri, 18 Sep 2020 20:11:02 +0200
Message-Id: <20200918181104.98-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of routers that have the ath10k wifi chip integrated in the Soc
have the pre-cal data stored in the art (or equivalent) mtd partition.
Introduce a new function to directly extract and use it based on what is
set in the dt if the system have mtd support.
Pre-cal file have still priority to everything else.

Tested-on: QCA9984 hw1.0 PCI 10.4

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
v2:
* Fix missing condition for cal_mode in transposing source to ath repo

 drivers/net/wireless/ath/ath10k/core.c | 80 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h |  3 +
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5f4e12196..d35abd16a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/pm_qos.h>
 #include <asm/byteorder.h>
+#include <linux/mtd/mtd.h>
 
 #include "core.h"
 #include "mac.h"
@@ -918,7 +919,8 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 	}
 
 	if (ar->cal_mode == ATH10K_PRE_CAL_MODE_DT ||
-	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE)
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE ||
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_MTD)
 		bmi_board_id_param = BMI_PARAM_GET_FLASH_BOARD_ID;
 	else
 		bmi_board_id_param = BMI_PARAM_GET_EEPROM_BOARD_ID;
@@ -1680,7 +1682,8 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 
 	/* As of now pre-cal is valid for 10_4 variants */
 	if (ar->cal_mode == ATH10K_PRE_CAL_MODE_DT ||
-	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE)
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE ||
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_MTD)
 		bmi_otp_exe_param = BMI_PARAM_FLASH_SECTION_ALL;
 
 	ret = ath10k_bmi_execute(ar, address, bmi_otp_exe_param, &result);
@@ -1701,6 +1704,69 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_download_cal_mtd(struct ath10k *ar)
+{
+#ifdef CONFIG_MTD
+	struct device_node *node, *mtd_node = NULL;
+	struct mtd_info *mtd;
+	const __be32 *list;
+	u32 offset, size;
+	const char *part;
+	phandle phandle;
+	size_t retlen;
+	char *file;
+	int ret;
+
+	node = ar->dev->of_node;
+	if (!node)
+		return -ENOENT;
+
+	list = of_get_property(node, "qcom,ath10k-pre-calibration-data-mtd", &size);
+	if (!list || (size != (3 * sizeof(*list))))
+		return -EINVAL;
+
+	phandle = be32_to_cpup(list++);
+	if (phandle)
+		mtd_node = of_find_node_by_phandle(phandle);
+
+	if (!mtd_node)
+		return -ENODEV;
+
+	part = of_get_property(mtd_node, "label", NULL);
+	if (!part)
+		part = mtd_node->name;
+
+	mtd = get_mtd_device_nm(part);
+	if (IS_ERR(mtd))
+		return -ENODEV;
+
+	offset = be32_to_cpup(list++);
+	size = be32_to_cpup(list);
+
+	file = kzalloc(size, GFP_KERNEL);
+	if (!file)
+		return -ENOMEM;
+
+	ret = mtd_read(mtd, offset, size, &retlen, file);
+	put_mtd_device(mtd);
+
+	ret = ath10k_download_board_data(ar, file, size);
+	if (ret) {
+		ath10k_err(ar, "failed to download cal_file data: %d\n", ret);
+		goto err;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cal file downloaded\n");
+
+	return 0;
+
+err:
+	kfree(file);
+	return ret;
+#endif
+	return -EOPNOTSUPP;
+}
+
 static int ath10k_download_cal_file(struct ath10k *ar,
 				    const struct firmware *file)
 {
@@ -2047,6 +2113,16 @@ static int ath10k_core_pre_cal_download(struct ath10k *ar)
 		goto success;
 	}
 
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot did not find a pre calibration file, try MTD next: %d\n",
+		   ret);
+
+	ret = ath10k_download_cal_mtd(ar);
+	if (ret == 0) {
+		ar->cal_mode = ATH10K_PRE_CAL_MODE_MTD;
+		goto success;
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "boot did not find a pre calibration file, try DT next: %d\n",
 		   ret);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4cf5bd489..3ca158605 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -864,6 +864,7 @@ enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_OTP,
 	ATH10K_CAL_MODE_DT,
 	ATH10K_PRE_CAL_MODE_FILE,
+	ATH10K_PRE_CAL_MODE_MTD,
 	ATH10K_PRE_CAL_MODE_DT,
 	ATH10K_CAL_MODE_EEPROM,
 };
@@ -886,6 +887,8 @@ static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 		return "dt";
 	case ATH10K_PRE_CAL_MODE_FILE:
 		return "pre-cal-file";
+	case ATH10K_PRE_CAL_MODE_MTD:
+		return "pre-cal-mtd";
 	case ATH10K_PRE_CAL_MODE_DT:
 		return "pre-cal-dt";
 	case ATH10K_CAL_MODE_EEPROM:
-- 
2.27.0

