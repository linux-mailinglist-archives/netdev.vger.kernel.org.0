Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C2575620
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403996AbfGYRsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 13:48:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35366 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403892AbfGYRsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 13:48:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so23140468pfn.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 10:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QrMxyVc1zDSi0vs7OhTYgzu3OEGoWgT+T+Dw+YVkahA=;
        b=FBtNJFdb5Upz2AH4s+VB92FH7J1QWb00rt7yEE+fpBZ5N7S4k8ZAyVn2nUAtgftsP3
         BDTdblo7Lrm47RqKVfYOKatWqxVG9lgObs4AZRT5IZKOBP3WnkxxfZuMR1cSliGx++JP
         vk8V4AOXvhCqOgeUEGQfRVB/u2YZy4IV2JG3tRfoVG0rpklZL1pKH9yB+T8WKZTBHTQj
         E7mMKW9Y/te4c1uNmW4in2k6DpiZtNrlLa/ybrFJqgMPcPI971iImshozI993OinDJE5
         KgzG7OhMfRRBsFnMOCEXVKVe/4CevH/soHHAhxzhlpQh/rpZOVjWqsIiPebdVkwkWjmt
         GAZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QrMxyVc1zDSi0vs7OhTYgzu3OEGoWgT+T+Dw+YVkahA=;
        b=cDXMmQRxgu+jrtxmXaV4MycEmqkOnG3oDasqBdCCOvXIFrf9lhvY0C2FTUfdZ0FKSR
         tbl/pIwenGY2bo8FHD3csM05SmmS7Aup8WGgsM0WPAfasWXMtWGPj+3QRQ8xcQc8t/HX
         kryOVSa9ElZnHHp61amm601OuIKpb2jPv8kKO9eFH7+mUIdlhV6Np1Vv+c0uVwgVijht
         2F0HRYMyjaGgoKHuLuPAucEq0625HKCsQxBQsEPLAwP+wQ3svzN+jJLMm1hBMDw+9xb+
         LEtDj+baQsmbwhYofp3VMK20r0NNrtCbZUsOp6PU8ZNGouL7yDjWQxJZtlpDQVpQ2FwW
         qndg==
X-Gm-Message-State: APjAAAVefwWNWJLhWtl2SFzolJTpmVEG3Cwl+XqdGtwU5t9tfAe+P2FX
        p/ZWaRFB7v7x+xWWrTafKFR7/A==
X-Google-Smtp-Source: APXvYqwekoX7JDpQsI3IDTHrGT7s/jfkXzjLB1wd9p4/mqvLcf0bxF1vgF++94o8TYuNevIcvnFKAw==
X-Received: by 2002:a65:5a44:: with SMTP id z4mr87590926pgs.41.1564076880400;
        Thu, 25 Jul 2019 10:48:00 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id r2sm68103389pfl.67.2019.07.25.10.47.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 10:47:59 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/3] ath10k: snoc: skip regulator operations
Date:   Thu, 25 Jul 2019 10:47:53 -0700
Message-Id: <20190725174755.23432-2-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190725174755.23432-1-bjorn.andersson@linaro.org>
References: <20190725174755.23432-1-bjorn.andersson@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The regulator operations is trying to set a voltage to a fixed value, by
giving some wiggle room. But some board designs specifies regulator
voltages outside this limited range. One such example is the Lenovo Yoga
C630, with vdd-3.3-ch0 in particular specified at 3.1V.

But consumers with fixed voltage requirements should just rely on the
board configuration to provide the power at the required level, so this
code should be removed.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

This patch is required for Lenovo Yoga C630 to succeed in power on ath10k, it
can be merged independently of the two following cleanup patches.

 drivers/net/wireless/ath/ath10k/snoc.c | 27 ++++++--------------------
 drivers/net/wireless/ath/ath10k/snoc.h |  2 --
 2 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index fc15a0037f0e..3d93ab09a298 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -37,10 +37,10 @@ static char *const ce_name[] = {
 };
 
 static struct ath10k_vreg_info vreg_cfg[] = {
-	{NULL, "vdd-0.8-cx-mx", 800000, 850000, 0, 0, false},
-	{NULL, "vdd-1.8-xo", 1800000, 1850000, 0, 0, false},
-	{NULL, "vdd-1.3-rfa", 1300000, 1350000, 0, 0, false},
-	{NULL, "vdd-3.3-ch0", 3300000, 3350000, 0, 0, false},
+	{NULL, "vdd-0.8-cx-mx", 0, 0, false},
+	{NULL, "vdd-1.8-xo", 0, 0, false},
+	{NULL, "vdd-1.3-rfa", 0, 0, false},
+	{NULL, "vdd-3.3-ch0", 0, 0, false},
 };
 
 static struct ath10k_clk_info clk_cfg[] = {
@@ -1377,9 +1377,8 @@ static int ath10k_get_vreg_info(struct ath10k *ar, struct device *dev,
 
 done:
 	ath10k_dbg(ar, ATH10K_DBG_SNOC,
-		   "snog vreg %s min_v %u max_v %u load_ua %u settle_delay %lu\n",
-		   vreg_info->name, vreg_info->min_v, vreg_info->max_v,
-		   vreg_info->load_ua, vreg_info->settle_delay);
+		   "snog vreg %s load_ua %u settle_delay %lu\n",
+		   vreg_info->name, vreg_info->load_ua, vreg_info->settle_delay);
 
 	return 0;
 }
@@ -1420,15 +1419,6 @@ static int __ath10k_snoc_vreg_on(struct ath10k *ar,
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc regulator %s being enabled\n",
 		   vreg_info->name);
 
-	ret = regulator_set_voltage(vreg_info->reg, vreg_info->min_v,
-				    vreg_info->max_v);
-	if (ret) {
-		ath10k_err(ar,
-			   "failed to set regulator %s voltage-min: %d voltage-max: %d\n",
-			   vreg_info->name, vreg_info->min_v, vreg_info->max_v);
-		return ret;
-	}
-
 	if (vreg_info->load_ua) {
 		ret = regulator_set_load(vreg_info->reg, vreg_info->load_ua);
 		if (ret < 0) {
@@ -1453,7 +1443,6 @@ static int __ath10k_snoc_vreg_on(struct ath10k *ar,
 err_enable:
 	regulator_set_load(vreg_info->reg, 0);
 err_set_load:
-	regulator_set_voltage(vreg_info->reg, 0, vreg_info->max_v);
 
 	return ret;
 }
@@ -1475,10 +1464,6 @@ static int __ath10k_snoc_vreg_off(struct ath10k *ar,
 	if (ret < 0)
 		ath10k_err(ar, "failed to set load %s\n", vreg_info->name);
 
-	ret = regulator_set_voltage(vreg_info->reg, 0, vreg_info->max_v);
-	if (ret)
-		ath10k_err(ar, "failed to set voltage %s\n", vreg_info->name);
-
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index 9db823e46314..1bf7bd4ef2a3 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -45,8 +45,6 @@ struct ath10k_snoc_ce_irq {
 struct ath10k_vreg_info {
 	struct regulator *reg;
 	const char *name;
-	u32 min_v;
-	u32 max_v;
 	u32 load_ua;
 	unsigned long settle_delay;
 	bool required;
-- 
2.18.0

