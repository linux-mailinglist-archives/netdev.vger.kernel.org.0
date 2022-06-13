Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8203F548F48
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352790AbiFMNL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 09:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359247AbiFMNJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 09:09:44 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA16D124
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:19:40 -0700 (PDT)
X-QQ-mid: bizesmtp79t1655119171tncpq0nk
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 13 Jun 2022 19:19:19 +0800 (CST)
X-QQ-SSF: 01400000002000G0Q000B00A0000000
X-QQ-FEAT: TskX/GkkryCDcmJVO5h9ev8uYG7SCnaHXyx1CcOQULQILG72duCIYEoi0yiGU
        eOgLxLcnS35Mho1tqsNnD0GEpf0qd1gDhv/txymjOX5m0t+NlZqIXlul/FwDwVLq7/2/nqx
        qqnZM5tbvjuTlke1A6X0R1jGpW8zb/yUDwloN22q5f2CdSrKeeDSnjFZZoRuqpdGto4Bqp3
        HXD4NEWngy5ZHFAyb2VMNdJjmt+l2YmHK+hG/z+ClAGxJW2rhLZcwjkZwZQb8QcJrkCLxzj
        TISphwzcNHy1W0RLLVJK24ytwYMkX/UxcWAbUvoWz1rgkloNOSwMt/ypyXd7H2Ptsi/ZlXe
        Glyev0WqjCBCXDRbJhd9a9mmjtAxH2jchdzZ3MeOB9wWZxJr88=
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, bhelgaas@google.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Meng Tang <tangmeng@uniontech.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH 5.10 2/2] commit 1b5d73fb8624 ("igc: Enable PCIe PTM")
Date:   Mon, 13 Jun 2022 19:19:07 +0800
Message-Id: <20220613111907.25490-2-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220613111907.25490-1-tangmeng@uniontech.com>
References: <20220613111907.25490-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign9
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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



