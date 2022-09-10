Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD385B4500
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 09:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiIJHyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 03:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiIJHyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 03:54:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164B41F2E2;
        Sat, 10 Sep 2022 00:54:43 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28A7scA8032127;
        Sat, 10 Sep 2022 00:54:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+BixbfkLRoEVSlMXKnuj4O4Z7KmNTMJZZpE1nhzCvQ0=;
 b=fNURsP9Bymuxacc1M8vTSYGxdSWjSS+UPSmI3QRjE/P9w7aBUro6pR+yBVh+d8TdAFPY
 V22wwAKDG3HJqhzTIb8qES2leBjsk+Gwvt0pyczuNKut7eyVIUbbIDDsWMJFn3thCpEt
 x0LhxkDhBaL6tI+korm58lvpKjD/R/rQeqCYHBVeFvDKJLHKCxj7phR5r3VT63+3Gtcy
 4q8GZd52srmiFIQA8l4Fb/txqJHOE5RyNoxh8RUdrrNVP54AhZyNYxnIBBT+gCw4CRz0
 K28AidfymOg8kvWQsufU+2tHOmZXBy+dEUlbnwV4TnQP9tM/ShcKYeleOx8P5dsVmwmx /w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3jgjwm8h0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 10 Sep 2022 00:54:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 10 Sep
 2022 00:54:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sat, 10 Sep 2022 00:54:36 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 84C6E3F7055;
        Sat, 10 Sep 2022 00:54:33 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <hkelam@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 4/4] octeontx2-af: Initialize PTP_SEC_ROLLOVER register properly
Date:   Sat, 10 Sep 2022 13:24:16 +0530
Message-ID: <20220910075416.22887-5-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20220910075416.22887-1-naveenm@marvell.com>
References: <20220910075416.22887-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: SxrOZAVU8E-BqXeLgUyONRg-sQ6eZf1c
X-Proofpoint-ORIG-GUID: SxrOZAVU8E-BqXeLgUyONRg-sQ6eZf1c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-10_04,2022-09-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the reset value of PTP_SEC_ROLLOVER is incorrect on
CNF10KB silicon, the ptp timestamps are inaccurate. This
patch initializes the PTP_SEC_ROLLOVER register properly
for the CNF10KB silicon.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 01f7dbad6b92..3411e2e47d46 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -52,12 +52,18 @@
 #define PTP_CLOCK_COMP				0xF18ULL
 #define PTP_TIMESTAMP				0xF20ULL
 #define PTP_CLOCK_SEC				0xFD0ULL
+#define PTP_SEC_ROLLOVER			0xFD8ULL
 
 #define CYCLE_MULT				1000
 
 static struct ptp *first_ptp_block;
 static const struct pci_device_id ptp_id_table[];
 
+static bool is_ptp_dev_cnf10kb(struct ptp *ptp)
+{
+	return (ptp->pdev->subsystem_device == PCI_SUBSYS_DEVID_CNF10K_B_PTP) ? true : false;
+}
+
 static bool is_ptp_dev_cn10k(struct ptp *ptp)
 {
 	return (ptp->pdev->device == PCI_DEVID_CN10K_PTP) ? true : false;
@@ -290,6 +296,10 @@ void ptp_start(struct ptp *ptp, u64 sclk, u32 ext_clk_freq, u32 extts)
 	/* sclk is in MHz */
 	ptp->clock_rate = sclk * 1000000;
 
+	/* Program the seconds rollover value to 1 second */
+	if (is_ptp_dev_cnf10kb(ptp))
+		writeq(0x3b9aca00, ptp->reg_base + PTP_SEC_ROLLOVER);
+
 	/* Enable PTP clock */
 	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
 
-- 
2.16.5

