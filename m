Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB4B27021F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgIRQ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgIRQ3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:29:37 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCE1C0613CE;
        Fri, 18 Sep 2020 09:29:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so6252249wrx.7;
        Fri, 18 Sep 2020 09:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S49aIuYLpT+2JYfKysryYvgN235gurfGFJHDPWL3QzE=;
        b=fNH63PJdbtii5p28SJargFVtP29JBMqu4VRxmdKvPFyOkSjLgc4EnArJAxzT7iRYRG
         6Z6DqQADU16LveutJ0fL10Alcjr96VTtQwK/5vz6eJHBxPPV4w4Da8RX6d2u2WizDjf/
         D6rn2lvsQS5KrnMTUmqEf8WzyZnN4YEugFrrJSISst5VrZ3ixIC9+pWWevaRoM9+lOKH
         477U0HNJdiqVxsbEG2VhnAwlOvYfZpCCum3IvjAleQInirKCIwSs1Gh4/i1I2TLgO2qE
         7dMIfXM+hCyB1ttA/11ZAyUTU9POcCLOFV8edA1GL4PxPcIoxX0zXUye314LTwKgy5A3
         9ZFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S49aIuYLpT+2JYfKysryYvgN235gurfGFJHDPWL3QzE=;
        b=lqwPepsc4mBIXVJSBZXixkpmdfYp8OsU49Dpjam6zDU2hafq0xzsWDZW5Tnuba5OjQ
         Qx6y0KW63tFSA9GfSq2VbuqHQ37f4OR+r7rULmOzk9CMwxxWTd4431vK2lJV09fa4+1l
         4oPJdR2nZuhmdJnw/UHseOa1nc9m3lzcLaOdLiAqnysNqHqDZEk3pQjPDPpHBErMmtmh
         RdObs2SRjVB91air6vJzuo8Zs4XpWnpLsu83nDPFwTsWK9gSZ6YN6aqf5ujNk/WEKv4+
         v8Nc8ftaqmx0l5yDKnrYLolkavKHvOZ13vbh6MgiEHdVR9Lre/480lzJUnYjUfgmAfEZ
         qvjg==
X-Gm-Message-State: AOAM530e8Qjprj/QV/8PevaN0jSmUt5/nJQNA2zUYuyiXU2REG6xwLtZ
        rQLMOy9/ay9gEESpx33v5jr+f62I5ng=
X-Google-Smtp-Source: ABdhPJw4wGg1+Wn7ryPfoWJp2mkPbx+vkCKrpZOZh7g3Lg8TmO6D2tc0OYSc0+e2jdBwIiC1DuF/XQ==
X-Received: by 2002:adf:c3cc:: with SMTP id d12mr39463130wrg.399.1600446574306;
        Fri, 18 Sep 2020 09:29:34 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id b11sm6028921wrt.38.2020.09.18.09.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 09:29:33 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: [PATCH] ath10k: Introduce download cal from mtd
Date:   Fri, 18 Sep 2020 18:29:27 +0200
Message-Id: <20200918162928.14335-1-ansuelsmth@gmail.com>
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
 drivers/net/wireless/ath/ath10k/core.c | 74 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |  3 ++
 2 files changed, 77 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5f4e12196..eef00d657 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/pm_qos.h>
 #include <asm/byteorder.h>
+#include <linux/mtd/mtd.h>
 
 #include "core.h"
 #include "mac.h"
@@ -1701,6 +1702,69 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
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
@@ -2047,6 +2111,16 @@ static int ath10k_core_pre_cal_download(struct ath10k *ar)
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

