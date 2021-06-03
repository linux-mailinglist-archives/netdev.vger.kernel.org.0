Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E35B399843
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 04:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFCC4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 22:56:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49583 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhFCC4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 22:56:03 -0400
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <koba.ko@canonical.com>)
        id 1lodUw-0004Ur-K1
        for netdev@vger.kernel.org; Thu, 03 Jun 2021 02:54:18 +0000
Received: by mail-pg1-f197.google.com with SMTP id 30-20020a630a1e0000b029021a63d9d4cdso3068631pgk.11
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 19:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mw+siqoTUjrd2Ed54WevdVgzIPvaVKMKX23ULyv1JWs=;
        b=YF8GRC92dbCGQ5vGZxihseadtY/AkEdlCK15bdXCU4AtJ6LPFa+NEbXMngkCUYv8yO
         XN2SgH+Jn+nSf+rW/at/UQNpsijvH+bNl3kKHvi0gPEzvmNhW6kUoYwbYKZgoVuMWb3m
         uFg8vVnAiQgSfMncYbsoJC6WJIBX1lvPccL4a3afRgVG8yfuQDPrJUgknuWUrgQ7P48w
         urhR/O8UMPG4BJl+1VHwQs1G2pjFJTqO95XKTpM4d8uJCjCXWe+c3vFh4hKSi0shjnvV
         tzxS4t8AWKvZHaWBq5OF0euSfh5K81pinpckxM9an5jogETEmr/Qhfte8i9rmOzccjXH
         DF+A==
X-Gm-Message-State: AOAM531nTwdIDYfTK6UAz+Sd/eGE6wh8QjmAXq+SnmW6D+p+TF2Xgoh8
        nN5JkbgV6DAZv2xT2aeUmuagkVooim/8vBnr9x5dM56QSNIqzj5dugIYdeFHZeYPx76edq+YEeK
        J9zy1w0Z6D7VK9W2h1PbcjzkL5V7i4ND/TA==
X-Received: by 2002:a17:90b:3587:: with SMTP id mm7mr32577905pjb.71.1622688856954;
        Wed, 02 Jun 2021 19:54:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNx3bzFrgiDyC9RROwaF6Ib2BOfmglttAokA/csgymay2MwlGh+eY8SgBNf9we4FSp+GR9pw==
X-Received: by 2002:a17:90b:3587:: with SMTP id mm7mr32577880pjb.71.1622688856593;
        Wed, 02 Jun 2021 19:54:16 -0700 (PDT)
Received: from canonical.com (61-220-137-34.HINET-IP.hinet.net. [61.220.137.34])
        by smtp.gmail.com with ESMTPSA id o24sm942570pgl.55.2021.06.02.19.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 19:54:16 -0700 (PDT)
From:   Koba Ko <koba.ko@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] r8169: introduce polling method for link change
Date:   Thu,  3 Jun 2021 10:54:14 +0800
Message-Id: <20210603025414.226526-1-koba.ko@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For RTL8106E, it's a Fast-ethernet chip.
If ASPM is enabled, the link chang interrupt wouldn't be triggered
immediately and must wait a very long time to get link change interrupt.
Even the link change interrupt isn't triggered, the phy link is already
established.

Introduce a polling method to watch the status of phy link and disable
the link change interrupt.
Also add a quirk for those realtek devices have the same issue.

Signed-off-by: Koba Ko <koba.ko@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.h      |   2 +
 drivers/net/ethernet/realtek/r8169_main.c | 112 ++++++++++++++++++----
 2 files changed, 98 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 2728df46ec41..a8c71adb1b57 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -11,6 +11,8 @@
 #include <linux/types.h>
 #include <linux/phy.h>
 
+#define RTL8169_LINK_TIMEOUT (1 * HZ)
+
 enum mac_version {
 	/* support for ancient RTL_GIGA_MAC_VER_01 has been removed */
 	RTL_GIGA_MAC_VER_02,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2c89cde7da1e..70aacc83d641 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -178,6 +178,11 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, rtl8169_pci_tbl);
 
+static const struct pci_device_id rtl8169_linkChg_polling_enabled[] = {
+	{ PCI_VDEVICE(REALTEK, 0x8136), RTL_CFG_NO_GBIT },
+	{ 0 }
+};
+
 enum rtl_registers {
 	MAC0		= 0,	/* Ethernet hardware address. */
 	MAC4		= 4,
@@ -618,6 +623,7 @@ struct rtl8169_private {
 	u16 cp_cmd;
 	u32 irq_mask;
 	struct clk *clk;
+	struct timer_list link_timer;
 
 	struct {
 		DECLARE_BITMAP(flags, RTL_FLAG_MAX);
@@ -1179,6 +1185,16 @@ static void rtl8168ep_stop_cmac(struct rtl8169_private *tp)
 	RTL_W8(tp, IBCR0, RTL_R8(tp, IBCR0) & ~0x01);
 }
 
+static int rtl_link_chng_polling_quirk(struct rtl8169_private *tp)
+{
+	struct pci_dev *pdev = tp->pci_dev;
+
+	if (pdev->vendor == 0x10ec && pdev->device == 0x8136 && !tp->supports_gmii)
+		return 1;
+
+	return 0;
+}
+
 static void rtl8168dp_driver_start(struct rtl8169_private *tp)
 {
 	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_START);
@@ -4608,6 +4624,75 @@ static void rtl_task(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void r8169_phylink_handler(struct net_device *ndev)
+{
+	struct rtl8169_private *tp = netdev_priv(ndev);
+
+	if (netif_carrier_ok(ndev)) {
+		rtl_link_chg_patch(tp);
+		pm_request_resume(&tp->pci_dev->dev);
+	} else {
+		pm_runtime_idle(&tp->pci_dev->dev);
+	}
+
+	if (net_ratelimit())
+		phy_print_status(tp->phydev);
+}
+
+static unsigned int
+rtl8169_xmii_link_ok(struct net_device *dev)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+	unsigned int retval;
+
+	retval = (RTL_R8(tp, PHYstatus) & LinkStatus) ? 1 : 0;
+
+	return retval;
+}
+
+static void
+rtl8169_check_link_status(struct net_device *dev)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+	int link_status_on;
+
+	link_status_on = rtl8169_xmii_link_ok(dev);
+
+	if (netif_carrier_ok(dev) == link_status_on)
+		return;
+
+	phy_mac_interrupt(tp->phydev);
+
+	r8169_phylink_handler (dev);
+}
+
+static void rtl8169_link_timer(struct timer_list *t)
+{
+	struct rtl8169_private *tp = from_timer(tp, t, link_timer);
+	struct net_device *dev = tp->dev;
+	struct timer_list *timer = t;
+	unsigned long flags;
+
+	rtl8169_check_link_status(dev);
+
+	if (timer_pending(&tp->link_timer))
+		return;
+
+	mod_timer(timer, jiffies + RTL8169_LINK_TIMEOUT);
+}
+
+static inline void rtl8169_delete_link_timer(struct net_device *dev, struct timer_list *timer)
+{
+	del_timer_sync(timer);
+}
+
+static inline void rtl8169_request_link_timer(struct net_device *dev)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	timer_setup(&tp->link_timer, rtl8169_link_timer, TIMER_INIT_FLAGS);
+}
+
 static int rtl8169_poll(struct napi_struct *napi, int budget)
 {
 	struct rtl8169_private *tp = container_of(napi, struct rtl8169_private, napi);
@@ -4624,21 +4709,6 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void r8169_phylink_handler(struct net_device *ndev)
-{
-	struct rtl8169_private *tp = netdev_priv(ndev);
-
-	if (netif_carrier_ok(ndev)) {
-		rtl_link_chg_patch(tp);
-		pm_request_resume(&tp->pci_dev->dev);
-	} else {
-		pm_runtime_idle(&tp->pci_dev->dev);
-	}
-
-	if (net_ratelimit())
-		phy_print_status(tp->phydev);
-}
-
 static int r8169_phy_connect(struct rtl8169_private *tp)
 {
 	struct phy_device *phydev = tp->phydev;
@@ -4769,6 +4839,10 @@ static int rtl_open(struct net_device *dev)
 		goto err_free_irq;
 
 	rtl8169_up(tp);
+
+	if (rtl_link_chng_polling_quirk(tp))
+		mod_timer(&tp->link_timer, jiffies + RTL8169_LINK_TIMEOUT);
+
 	rtl8169_init_counter_offsets(tp);
 	netif_start_queue(dev);
 out:
@@ -4991,7 +5065,10 @@ static const struct net_device_ops rtl_netdev_ops = {
 
 static void rtl_set_irq_mask(struct rtl8169_private *tp)
 {
-	tp->irq_mask = RxOK | RxErr | TxOK | TxErr | LinkChg;
+	tp->irq_mask = RxOK | RxErr | TxOK | TxErr;
+
+	if (!rtl_link_chng_polling_quirk(tp))
+		tp->irq_mask |= LinkChg;
 
 	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
 		tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
@@ -5436,6 +5513,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_dev_run_wake(pdev))
 		pm_runtime_put_sync(&pdev->dev);
 
+	if (rtl_link_chng_polling_quirk(tp))
+		rtl8169_request_link_timer(dev);
+
 	return 0;
 }
 
-- 
2.25.1

