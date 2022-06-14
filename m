Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D2254A387
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 03:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348692AbiFNBR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 21:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347989AbiFNBRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 21:17:39 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Jun 2022 18:17:14 PDT
Received: from qq.com (smtpbg480.qq.com [59.36.132.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C7633365;
        Mon, 13 Jun 2022 18:17:14 -0700 (PDT)
X-QQ-mid: bizesmtp90t1655169347tmx1hhqk
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 14 Jun 2022 09:15:44 +0800 (CST)
X-QQ-SSF: 01400000000000G0Q000000A0000000
X-QQ-FEAT: xoS364mEyr2ZQyZa9egGpWkiXbaENEOHC3w6ZHbbovTwW4KRqizNrvRiUb/mB
        69Yd9l9taMDvEMrVM5AgAC/i5zaipdqpScM8ywGwZ2hhW8E3xghQVFEQINXfzopsxWONLdg
        WIOO9qp6FSUReuFEnVB4rbmZEROYLoN9NmnA8FVyQavgUuwcWdMHrXpPAfCenYwLH2IgqzA
        OQ4rSdMZZqQce+d2BsGuoT5JqKDAHwx5zpDyQqCFpDWJsz7eFTKKSYxUhS2jdqI5mdWa8N0
        h08leJFyDr9lYRsouGEB4D887k+LNhkS/AJY8XdWCMS4M/i2ZGVJZz7s0me5Tw+MSD/8VUl
        t0aBzFKJKLfjL7UdEkTV0peLti+meuYttoH/QROAB/gtfSWDnE=
X-QQ-GoodBg: 1
From:   Meng Tang <tangmeng@uniontech.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Meng Tang <tangmeng@uniontech.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 2/2] commit 1b5d73fb8624 ("igc: Enable PCIe PTM")
Date:   Tue, 14 Jun 2022 09:15:28 +0800
Message-Id: <20220614011528.32118-2-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220614011528.32118-1-tangmeng@uniontech.com>
References: <20220614011528.32118-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        PP_MIME_FAKE_ASCII_TEXT,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the 5.10 kernel version, even to the latest confirmed version,
the following error will still be reported when I225-V network card
is used.

kernel: [    1.031581] igc: probe of 0000:01:00.0 failed with error -2
kernel: [    1.066574] igc: probe of 0000:02:00.0 failed with error -2
kernel: [    1.096152] igc: probe of 0000:03:00.0 failed with error -2
kernel: [    1.127251] igc: probe of 0000:04:00.0 failed with error -2

Even though I confirmed that 7c496de538eebd8212dc2a3c9a468386b2640d4
and 47bca7de6a4fb8dcb564c7ca4d885c91ed19e03 have been merged into the
kernel 5.10, but bug still occurred, and this patch can fixes it.

Enables PCIe PTM (Precision Time Measurement) support in the igc
driver. Notifies the PCI devices that PCIe PTM should be enabled.

PCIe PTM is similar protocol to PTP (Precision Time Protocol) running
in the PCIe fabric, it allows devices to report time measurements from
their internal clocks and the correlation with the PCIe root clock.

The i225 NIC exposes some registers that expose those time
measurements, those registers will be used, in later patches, to
implement the PTP_SYS_OFFSET_PRECISE ioctl().

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index fd9257c7059a..298e968629db 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -10,6 +10,7 @@
 #include <linux/ip.h>
 #include <linux/pm_runtime.h>
 #include <net/pkt_sched.h>
+#include <linux/pci.h>
 
 #include <net/ipv6.h>
 
@@ -5041,6 +5042,10 @@ static int igc_probe(struct pci_dev *pdev,
 
 	pci_enable_pcie_error_reporting(pdev);
 
+	err = pci_enable_ptm(pdev, NULL);
+	if (err < 0)
+		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
+
 	pci_set_master(pdev);
 
 	err = -ENOMEM;
-- 
2.20.1


e=10Ù
