Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDD33C5D87
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbhGLNpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:45:19 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:54228
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234648AbhGLNpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:45:19 -0400
Received: from localhost (1.general.khfeng.us.vpn [10.172.68.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 0411140614;
        Mon, 12 Jul 2021 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626096911;
        bh=49WXuAcOzcp5cSXPqRiLBbw9uyRJ6eCwLsokni9lmRk=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=Tvc/UmPqt5CWG5jFhrvJSV+6zZ/Luh7HCdUbfSp5TZWLROM32Eg7YQ3AyKdRq8M2l
         wemflU+UdYRmGgC2LsvbpJvc/HYLa1ZBRXDzAiKlD9X9UjiH/eZHVfMot7mbY4phYC
         g/4bk4LN4UqLlKoJL+BuBdpMmtM1FQXNjrqSduQZYPhpYZ0qv7ZHY0/0zmqsCaDK32
         giXqcQboy2E4kzxJE04ryOF9o6ErjluwhFP10NL97ridQFGmkj6dS2pt8yWuyx6CM5
         ucS4Xvqqzr4KKL3fnEdut4ZbCZLFXkaMmcnU/4DJtxCRDeBceQmGXZXgo4deRetsNc
         8bWB4l21fqxew==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     acelan.kao@canonical.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] e1000e: Make mei_me active when e1000e is in use
Date:   Mon, 12 Jul 2021 21:34:58 +0800
Message-Id: <20210712133500.1126371-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many users report rather sluggish RX speed on TGP I219. Since
"intel_idle.max_cstate=1" doesn't help, so it's not caused by deeper
package C-state.

A workaround that always works is to make sure mei_me is runtime active
when e1000e is in use.

The root cause is still unknown, but since many users are affected by
the issue, implment the quirk in the driver as a temporary workaround.

Also adds mei_me as soft dependency to ensure the device link can be
created if e1000e is in initramfs.

BugLink: https://bugs.launchpad.net/bugs/1927925
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213377
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213651
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 5835d6cf2f51..e63445a8ce12 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7317,6 +7317,27 @@ static const struct net_device_ops e1000e_netdev_ops = {
 	.ndo_features_check	= passthru_features_check,
 };
 
+static void e1000e_create_device_links(struct pci_dev *pdev)
+{
+	struct pci_dev *tgp_mei_me;
+
+	/* Find TGP mei_me devices and make e1000e power depend on mei_me */
+	tgp_mei_me = pci_get_device(PCI_VENDOR_ID_INTEL, 0xa0e0, NULL);
+	if (!tgp_mei_me) {
+		tgp_mei_me = pci_get_device(PCI_VENDOR_ID_INTEL, 0x43e0, NULL);
+		if (!tgp_mei_me)
+			return;
+	}
+
+	if (device_link_add(&pdev->dev, &tgp_mei_me->dev,
+			    DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE |
+			    DL_FLAG_AUTOREMOVE_CONSUMER))
+		pci_info(pdev, "System and runtime PM depends on %s\n",
+			 pci_name(tgp_mei_me));
+
+	pci_dev_put(tgp_mei_me);
+}
+
 /**
  * e1000_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -7645,6 +7666,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_dev_run_wake(pdev) && hw->mac.type != e1000_pch_cnp)
 		pm_runtime_put_noidle(&pdev->dev);
 
+	if (hw->mac.type == e1000_pch_tgp)
+		e1000e_create_device_links(pdev);
+
 	return 0;
 
 err_register:
@@ -7917,6 +7941,8 @@ static void __exit e1000_exit_module(void)
 }
 module_exit(e1000_exit_module);
 
+/* Ensure device link can be created if e1000e is in the initramfs. */
+MODULE_SOFTDEP("pre: mei_me");
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) PRO/1000 Network Driver");
 MODULE_LICENSE("GPL v2");
-- 
2.31.1

