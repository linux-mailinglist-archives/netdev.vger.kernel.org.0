Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA861ABF
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 08:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfGHGh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 02:37:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35708 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728525AbfGHGh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 02:37:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so7136687pgl.2;
        Sun, 07 Jul 2019 23:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=yEeJ0/+qhOXMvZlC71qdNTbuwGZpqThMJW5wphAArgY=;
        b=puPUinBZbbxSifsinP7NIei+rmd3EpEBHFRAnKoqwkoM6vdeKOwt+SbBzkwyGQdUeS
         Lq7jq/YQzuYjUop+1iRf7DAHsFpRoLWsflvx0UcxJFB87mlA+CojH2EmpjbrB5WXvlJS
         6zj542gwZ9eViQYThRVxdkLa2pP6Mi5RkciCiqV2lmgskmTsxrEP3s0hV0ZWqwpvHeVs
         96izHoZZpglXTLG1ibgywjatF5ayaFaBm5aP9ZoaLjopd9EfYLkT0K4lynabwAhyRCP1
         lEWAS9AsUDyY84Y3kxcqi8fKtrtmaQeqsYmwJQW3GWi1ZfC0g5ZpRbHerA48yKzY4I4U
         SnGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=yEeJ0/+qhOXMvZlC71qdNTbuwGZpqThMJW5wphAArgY=;
        b=n2lXpUndHOQAwBcO/0PHz6ocFjjw/c7pXLED6jROvNu/PyqCEnpnDQqF2Z+rMUlfRC
         3iD4sHa2ffhwLp7QQGKpNEAtoaHcALjpRRqqao3+gaRKwHR2XGnVY53C/E7CFn/PJO3J
         cmM2kFk32K4uEt1ft+URRq59Zmbcnk1gmOXgBsi6eolIZHkSOgj2l/ADBIgOOwDI1oqS
         xljh9SnVMJp66jYcAsFSrbuqNlKaa6LQUU/DmoXoKXZSl+cKSwyEIyS+zVEbr+LN0W80
         MzzRIlXsHKQIz9LxlNGBkLTwYMvP4iWW7sGBjLckblm3t5d77p6Dm9RCQ711XynwKH4l
         mIVQ==
X-Gm-Message-State: APjAAAVVKhExz6CevHB5L0StSfBguYYYeO2PctPffAWy9H+PoVkUQbEi
        eL6tWbS41in/0Me2KyKJvmE=
X-Google-Smtp-Source: APXvYqyNlhSSjHOzwA17kQ5Em+gCAOgkxUQ/u2unNcCC9Q2UJGj3PHTwFSQAQFbVIu5NXgMASck/zw==
X-Received: by 2002:a17:90a:db08:: with SMTP id g8mr22384413pjv.39.1562567875035;
        Sun, 07 Jul 2019 23:37:55 -0700 (PDT)
Received: from localhost (114-32-69-186.HINET-IP.hinet.net. [114.32.69.186])
        by smtp.gmail.com with ESMTPSA id l25sm6602761pff.143.2019.07.07.23.37.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 07 Jul 2019 23:37:54 -0700 (PDT)
From:   AceLan Kao <acelan.kao@canonical.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] r8169: add enable_aspm parameter
Date:   Mon,  8 Jul 2019 14:37:51 +0800
Message-Id: <20190708063751.16234-1-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have many commits in the driver which enable and then disable ASPM
function over and over again.
   commit b75bb8a5b755 ("r8169: disable ASPM again")
   commit 0866cd15029b ("r8169: enable ASPM on RTL8106E")
   commit 94235460f9ea ("r8169: Align ASPM/CLKREQ setting function with vendor driver")
   commit aa1e7d2c31ef ("r8169: enable ASPM on RTL8168E-VL")
   commit f37658da21aa ("r8169: align ASPM entry latency setting with vendor driver")
   commit a99790bf5c7f ("r8169: Reinstate ASPM Support")
   commit 671646c151d4 ("r8169: Don't disable ASPM in the driver")
   commit 4521e1a94279 ("Revert "r8169: enable internal ASPM and clock request settings".")
   commit d64ec841517a ("r8169: enable internal ASPM and clock request settings")

This function is very important for production, and if we can't come out
a solution to make both happy, I'd suggest we add a parameter in the
driver to toggle it.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index d06a61f00e78..f557cb36e2c6 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -702,10 +702,13 @@ struct rtl8169_private {
 
 typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
 
+static int enable_aspm;
 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
 MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
 module_param_named(debug, debug.msg_enable, int, 0);
 MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 16=all)");
+module_param(enable_aspm, int, 0);
+MODULE_PARM_DESC(enable_aspm, "Enable ASPM support (0 = disable, 1 = enable");
 MODULE_SOFTDEP("pre: realtek");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FIRMWARE_8168D_1);
@@ -7163,10 +7166,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* Disable ASPM completely as that cause random device stop working
-	 * problems as well as full system hangs for some PCIe devices users.
-	 */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+	if (!enable_aspm) {
+		/* Disable ASPM completely as that cause random device stop working
+		 * problems as well as full system hangs for some PCIe devices users.
+		 */
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+	}
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
-- 
2.17.1

