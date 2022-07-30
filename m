Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D344585A56
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 13:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbiG3L6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 07:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiG3L62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 07:58:28 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C533B286E9;
        Sat, 30 Jul 2022 04:58:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26UBrdkf006040;
        Sat, 30 Jul 2022 04:58:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+BixbfkLRoEVSlMXKnuj4O4Z7KmNTMJZZpE1nhzCvQ0=;
 b=AUTLNNEjZSYgITUa5bqKLl/iIceC/KESeIrPa6Ei2av2KXmPlFt+nuiyzjwqiSOhyijQ
 k1JlylFOFkis6H7/m0F9QJIyGTXION7IeRmeyscRkFOXIFGXxEMmCnrRGETCM00b1BZN
 jK3oHE0JvPb45awG3kMTSSEOTPSU37CYXUXw1b9f9YHSdIyNFzNuRx4+yI1GbgdEVN4J
 Djm4Aq6JRGbPdYwPxSQL2dkYYUHO7Ghf9AKiRWnHoLEzVggVVe315+lF+v+Vi9VfrX/H
 wVKny3i7aIdYiVsaTgL8XkLTyk6TX05M5+YD5c6zyTX/ACcVJh3gnxZKzkUMA7Qj9U+Z /g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hn45m0097-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jul 2022 04:58:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 30 Jul
 2022 04:58:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 30 Jul 2022 04:58:16 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 816973F706A;
        Sat, 30 Jul 2022 04:58:13 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH v2 4/4] octeontx2-af: Initialize PTP_SEC_ROLLOVER register properly
Date:   Sat, 30 Jul 2022 17:27:58 +0530
Message-ID: <20220730115758.16787-5-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20220730115758.16787-1-naveenm@marvell.com>
References: <20220730115758.16787-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: j523dGBIezD0JI-3wxNTrDQ4uJEhjdcR
X-Proofpoint-ORIG-GUID: j523dGBIezD0JI-3wxNTrDQ4uJEhjdcR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-30_07,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

