Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55DD204E70
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732197AbgFWJue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731996AbgFWJud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 05:50:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ED7C061573;
        Tue, 23 Jun 2020 02:50:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d4so9641498pgk.4;
        Tue, 23 Jun 2020 02:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jl0lu1/umPSlDnwGccZKV/GaH2q8rWZ4EaouhX1DScY=;
        b=iuBEuDbB1DHqwmV1vge/NENE3R99S9vwOVvQQ3fOdzTYmtKfD5Q9oGKhsbhtoHm2Jn
         hN3HwwaJB9XvOJS6bQlY0IuAPiYK5IjWIYNoxAOpEvHhvxTuTGMacfHdpng2EutbJYDa
         Ow3KeOimDcMBFKiZrxn4BfyXftS9n7Vozd+/z//XYW+IYDm16MDYopweSRVPfdKo8unx
         7hceDHtMxqtxPip7Mmb/Kq6ZPhP+iDNWUPiAyBn1e2cnpFOgYABHaSfcBV6piAY35s/v
         LmHAaRP1z2LULYrczM4+QafxEuRVoSLJFXryYfpaUKWw9WslIlzixR68iunjla7BQA2G
         aoyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jl0lu1/umPSlDnwGccZKV/GaH2q8rWZ4EaouhX1DScY=;
        b=fyQHCsIrnO45tc/v8MQMeo/FmYlwNfTudqQT5Vy05GB2ijlhumU3dGs+ENDcr9c2Zv
         cwT7F3E6tN57ljgL4Vbbq7J5l47l23N5JTti0K2JyBZollanMi9aWjxwXESmy9TTmSdw
         EH/qdQ9ycdx0Eg05M2/5W46Jsraika+V6e0o5h9Y1tCa4ttHNuVF1MiflTq76Caswtns
         VNomhcAn1ur5kk4Tn6ZKsbe3OSvFAc7pOWeh8v6DOgPnKkBNmYwQMsDpwuA34rmZpNLt
         y7Dh81UNu+uUkLVhg2r4MZOSRo37lcRA3f0kxhZ0e7NepqDitpo7boFe8QibCHkJJdnR
         uIBQ==
X-Gm-Message-State: AOAM532HGkfdcgbGmCPSa7BDTl0VIjPeiQBsdSR6HZ6KOrZTrU/06SMJ
        yjNFWvk8dVpfucAn/UwxNMg=
X-Google-Smtp-Source: ABdhPJzBdJYLuEq00Wou+a0GFVR6oS+94o32Fgj/lybeWbqQ8xQ+4sRLmQ4/0OHOgy/QoYkiZsv4GQ==
X-Received: by 2002:a65:51c1:: with SMTP id i1mr16378293pgq.272.1592905831788;
        Tue, 23 Jun 2020 02:50:31 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id x17sm1949293pjr.29.2020.06.23.02.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 02:50:31 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        skhan@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH v1] rtl818x_pci: use generic power management
Date:   Tue, 23 Jun 2020 15:14:55 +0530
Message-Id: <20200623094454.12427-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Earlier, drivers had to manage the device's power states, and related
operations, themselves. With the generic approach, these are done by PCI
core.

The only driver-specific jobs, .suspend() and .resume() doing were invoking
PCI helper functions pci_save/restore_state() and
pci_set_power_state(). This is not recommeneded as PCI core takes care of
that. Hence they became empty-body functions, thus define them NULL.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../wireless/realtek/rtl818x/rtl8180/dev.c    | 23 ++++---------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index d5f65372356b..ba3286f732cc 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -1966,32 +1966,17 @@ static void rtl8180_remove(struct pci_dev *pdev)
 	ieee80211_free_hw(dev);
 }
 
-#ifdef CONFIG_PM
-static int rtl8180_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	return 0;
-}
-
-static int rtl8180_resume(struct pci_dev *pdev)
-{
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	return 0;
-}
+#define rtl8180_suspend NULL
+#define rtl8180_resume NULL
 
-#endif /* CONFIG_PM */
+static SIMPLE_DEV_PM_OPS(rtl8180_pm_ops, rtl8180_suspend, rtl8180_resume);
 
 static struct pci_driver rtl8180_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= rtl8180_table,
 	.probe		= rtl8180_probe,
 	.remove		= rtl8180_remove,
-#ifdef CONFIG_PM
-	.suspend	= rtl8180_suspend,
-	.resume		= rtl8180_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &rtl8180_pm_ops,
 };
 
 module_pci_driver(rtl8180_driver);
-- 
2.27.0

