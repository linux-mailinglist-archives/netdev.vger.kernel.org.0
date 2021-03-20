Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ED4342F8E
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 21:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhCTUkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 16:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhCTUkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 16:40:16 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C1AC061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 13:40:15 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo7033290wmq.4
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 13:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=CSE0A3maM1250A6VN+ltcoiWT4Tpsq+JuLzbphp/sqQ=;
        b=CYL+aEejqcNQ6m6ok6orUj3RS6uMJxDcvWZpgZzuztfsZ32eUYIS98AmaFeTLo+FCq
         IITTXYQY/V3lqO3KyeFVuuIuxPeSazL2Kxzb45ivVt0Kc8oMfkSU8UCZy5JS5Z59jT2y
         Vx0WH1cuL8TEBeFahzm6Pw2fE9qsD9w6QSNE1cc7dbBFQimatMm7/qvGwaHn8BDlKk34
         PHl6rGFQ1n5auFbmMIKdgbKWjOi6gc2A9t+x3416df9odl5f18zk+LMLeyOkrGEQwtRk
         9xoQTByi6wpQjxNCyNqKhUeb4Zv+KN1JJnEOiEgogDXDcZBmYsI03INyXxz3ZnNnfiaT
         rmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=CSE0A3maM1250A6VN+ltcoiWT4Tpsq+JuLzbphp/sqQ=;
        b=C+Gk/cr61BdRf/YaRfVqoRILsz35suHKeSt0Rhah0nSyPdU4/12iGG27gXt+dnLdQL
         DZvGXB1SItjpncroLvtKMrSvKqf0M5Q7JQLT6c7/D+u7DdLvc3bLAF8y94DWQrMCbK7A
         LiKlS8kfa9Q+eWN0SlDFIzs5pKUBPgjnG7tK50v12whdCeuWtQQeuc8t4Eifl3jy1VbI
         FekVqSh3qivQLf3XqUdvVmf1LBeAD82OLKHsROC7BMuhBdH8jxGLUSiyhC+D81Qw+W8t
         MxJR2AiQ2et9AQyCWw9VPZfJhse/Vj5q77mzrZuEzD4+fmdTKDSf/emjOIlyAQc+b7po
         A89A==
X-Gm-Message-State: AOAM532Fo1U/eQCMe6hnAGWFHz52//wr6tzlF2b1tmA/oD8iIbtDOgpt
        HIGtVaKDvHoffl8NFUErPsYtOt2/5AECSw==
X-Google-Smtp-Source: ABdhPJzv8SQKzfQAocnA3o+R2yTXYFtLvbwqqBK0YFOjwmgGTmQg4WsSWaeXRKYo43DUc84NLbT0fA==
X-Received: by 2002:a7b:c931:: with SMTP id h17mr9278185wml.4.1616272814559;
        Sat, 20 Mar 2021 13:40:14 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:1195:d87b:55ef:276? (p200300ea8f1fbb001195d87b55ef0276.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:1195:d87b:55ef:276])
        by smtp.googlemail.com with ESMTPSA id p14sm11966616wmc.30.2021.03.20.13.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 13:40:14 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blazejowski <paulb@blazebox.homeip.net>
Subject: [PATCH net] r8169: fix DMA being used after buffer free if WoL is
 enabled
Message-ID: <ed72d614-d6a2-a837-8faa-eaaef08ef6d8@gmail.com>
Date:   Sat, 20 Mar 2021 21:40:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IOMMU errors have been reported if WoL is enabled and interface is
brought down. It turned out that the network chip triggers DMA
transfers after the DMA buffers have been freed. For WoL to work we
need to leave rx enabled, therefore simply stop the chip from being
a DMA busmaster.

Fixes: 567ca57faa62 ("r8169: add rtl8169_up")
Tested-by: Paul Blazejowski <paulb@blazebox.homeip.net>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8ea6ddc7d..0d7001303 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4644,6 +4644,9 @@ static void rtl8169_down(struct rtl8169_private *tp)
 
 	rtl8169_update_counters(tp);
 
+	pci_clear_master(tp->pci_dev);
+	rtl_pci_commit(tp);
+
 	rtl8169_cleanup(tp, true);
 
 	rtl_prepare_power_down(tp);
@@ -4651,6 +4654,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
 
 static void rtl8169_up(struct rtl8169_private *tp)
 {
+	pci_set_master(tp->pci_dev);
 	phy_resume(tp->phydev);
 	rtl8169_init_phy(tp);
 	napi_enable(&tp->napi);
@@ -5305,8 +5309,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rtl_hw_reset(tp);
 
-	pci_set_master(pdev);
-
 	rc = rtl_alloc_irq(tp);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Can't allocate interrupt\n");
-- 
2.31.0

