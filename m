Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06B61C8DB
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 14:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfENMes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 08:34:48 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35405 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfENMes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 08:34:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id h1so8581691pgs.2;
        Tue, 14 May 2019 05:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aGu1f+RrnUPQT+gHJR7zuBRu3GeHB/WJgEjaROthtGg=;
        b=Z7pnFkGAH2BlUDH3+FhIH0sOO38syFyZBNQ8mewx3bzSMfHIZauAYn7CRsxJ1BYS49
         CcQHC7TjzP84vvbTkkmKHpbuPh7s5PrGgSZ9OAeY1R+helnNcLmQgRix200T8eD7tYi+
         0k2Vrgkb/yz4TyEoRv1oF+YJyeh4Z0pI2EKVe448kCeuyq/uFpR74wy6rPfMX8/Rcy9l
         rYLw+AZTi+CduC7I9ErJv6pZENbrXAPFHyVnkyF2PDSiKOI7F+/v5tHd+BNmkKAi0s3T
         ur4hi/kKaBRYzw2rBEnFiUkF+JDg2ECWXSHrNJ49YhM1bqFB7F9jkmgPYS0tKqxDKg5W
         vg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aGu1f+RrnUPQT+gHJR7zuBRu3GeHB/WJgEjaROthtGg=;
        b=OA8jpmaoTVLj3dn0NRpqWlQedB2+8pHeP3h7pEpXR+CV2BJU44zjmbLLtNETTZdYyV
         iZBNPLE+YV1HraB81hyhDfYUiD0zuYWzWMAEpdBdcUkG8CAK9T9XL2yi+BHaz81QwhIP
         QljahR9PuKqKAiz+pMDIREr50zdlprA/t9AFERAM8wcQfWOz7nJghGoJJQH2KTBjkk7U
         JLls3wwf9OZZahPOyInIxVFZGgE4EDI39PPl6KlxgwkAYDcuva4ZkTykYSwlF4nNTO1h
         fCv1t964DfMhyCupdXSASltoo8/xwU207AtGAJYACQsIfN1T4CUWUNEKVBWLOseHCM30
         lasQ==
X-Gm-Message-State: APjAAAUD9MvFDYeF5Wmlge9C7EENamNq+9YthYu0S+sA9PSMNtVd5Bq/
        sU3A9Mri+ting7yBZOZU1bYnw/XH
X-Google-Smtp-Source: APXvYqzxHQFvg7B1IoR9HrYpc+EV3zMUO+76rqpp/XVWBMUrpldAgOKUQpKy1Q8NRcFwZME2iPGndQ==
X-Received: by 2002:a62:3501:: with SMTP id c1mr41146426pfa.184.1557837287163;
        Tue, 14 May 2019 05:34:47 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id g17sm20699149pfk.55.2019.05.14.05.34.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 05:34:46 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] rtlwifi: Fix null-pointer dereferences in error handling code of rtl_pci_probe()
Date:   Tue, 14 May 2019 20:34:39 +0800
Message-Id: <20190514123439.10524-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*BUG 1:
In rtl_pci_probe(), when rtlpriv->cfg->ops->init_sw_vars() fails,
rtl_deinit_core() in the error handling code is executed.
rtl_deinit_core() calls rtl_free_entries_from_scan_list(), which uses
rtlpriv->scan_list.list in list_for_each_entry_safe(), but it has been
initialized. Thus a null-pointer dereference occurs.
The reason is that rtlpriv->scan_list.list is initialized by
INIT_LIST_HEAD() in rtl_init_core(), which has not been called.

To fix this bug, rtl_deinit_core() should not be called when
rtlpriv->cfg->ops->init_sw_vars() fails.

*BUG 2:
In rtl_pci_probe(), rtl_init_core() can fail when rtl_regd_init() in
this function fails, and rtlpriv->scan_list.list has not been
initialized by INIT_LIST_HEAD(). Then, rtl_deinit_core() in the error
handling code of rtl_pci_probe() is executed. Finally, a null-pointer
dereference occurs due to the same reason of the above bug.

To fix this bug, the initialization of lists in rtl_init_core() are
performed before the call to rtl_regd_init().

These bugs are found by a runtime fuzzing tool named FIZZER written by
us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 15 ++++++++-------
 drivers/net/wireless/realtek/rtlwifi/pci.c  |  4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 217d2a7a43c7..b3f341ec3710 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -526,8 +526,14 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	/* <2> rate control register */
 	hw->rate_control_algorithm = "rtl_rc";
 
+	/* <3> init list */
+	INIT_LIST_HEAD(&rtlpriv->entry_list);
+	INIT_LIST_HEAD(&rtlpriv->scan_list.list);
+	skb_queue_head_init(&rtlpriv->tx_report.queue);
+	skb_queue_head_init(&rtlpriv->c2hcmd_queue);
+
 	/*
-	 * <3> init CRDA must come after init
+	 * <4> init CRDA must come after init
 	 * mac80211 hw  in _rtl_init_mac80211.
 	 */
 	if (rtl_regd_init(hw, rtl_reg_notifier)) {
@@ -535,7 +541,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 		return 1;
 	}
 
-	/* <4> locks */
+	/* <5> locks */
 	mutex_init(&rtlpriv->locks.conf_mutex);
 	mutex_init(&rtlpriv->locks.ips_mutex);
 	mutex_init(&rtlpriv->locks.lps_mutex);
@@ -550,11 +556,6 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
 	spin_lock_init(&rtlpriv->locks.fw_ps_lock);
 	spin_lock_init(&rtlpriv->locks.iqk_lock);
-	/* <5> init list */
-	INIT_LIST_HEAD(&rtlpriv->entry_list);
-	INIT_LIST_HEAD(&rtlpriv->scan_list.list);
-	skb_queue_head_init(&rtlpriv->tx_report.queue);
-	skb_queue_head_init(&rtlpriv->c2hcmd_queue);
 
 	rtlmac->link_state = MAC80211_NOLINK;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 48ca52102cef..864cb76230c4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2267,7 +2267,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
 		pr_err("Can't init_sw_vars\n");
 		err = -ENODEV;
-		goto fail3;
+		goto fail2;
 	}
 	rtlpriv->cfg->ops->init_sw_leds(hw);
-- 
2.17.0

