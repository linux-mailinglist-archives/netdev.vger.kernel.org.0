Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2334585A4D
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 13:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiG3L6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 07:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiG3L6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 07:58:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8989C25C7F;
        Sat, 30 Jul 2022 04:58:15 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26UBrdke006040;
        Sat, 30 Jul 2022 04:58:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rP7tjxV/ufN9hoaG96rpc9HjV9WDz8g2SRhjwxSQF04=;
 b=RBq4nvkNV9kJBqE7BFjyO/YsD4N59V+x6tFv7KXCTZ7nrwR3aUekGvqXVu9TZmLMan25
 09dQ67b9aZkw0tXprZEPVnmwheMbOewoBWqY/WMy9bEpSX+yvZGEvGwQLicapOgaEDlE
 H0IJRdMrDzVoqM7btb1jqJf9TP0Dbo/NUSJc4zARYovzcGT4C9wOuZoOKwOlyNpPNLcf
 zo3Sc56iOjOqI+c31j0i6dbBK70O3c+g9YyVIhCtyyO4uj/BeNQA7hJqTXRVFXX/wxQA
 fJUguCHhdAS6cILm6gnJAu86fYvb0MkB7n3fiU+o6XaFDJDXypT0y5LTarAUZQa1buax 9Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hn45m008t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jul 2022 04:58:08 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jul
 2022 04:58:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sat, 30 Jul 2022 04:58:06 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 7455B3F7052;
        Sat, 30 Jul 2022 04:58:03 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH v2 1/4] octeontx2-af: return correct ptp timestamp for CN10K silicon
Date:   Sat, 30 Jul 2022 17:27:55 +0530
Message-ID: <20220730115758.16787-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20220730115758.16787-1-naveenm@marvell.com>
References: <20220730115758.16787-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: zcWQXpxBmYZTKbhKlTPKej62dxJ1RXq5
X-Proofpoint-ORIG-GUID: zcWQXpxBmYZTKbhKlTPKej62dxJ1RXq5
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

The MIO_PTP_TIMESTAMP format has been changed in CN10K silicon
family. The upper 32-bits represents seconds and lower 32-bits
represents nanoseconds. This patch returns nanosecond timestamp
to NIX PF driver.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 67a6821d2dff..b2c3527fe665 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -56,6 +56,11 @@
 static struct ptp *first_ptp_block;
 static const struct pci_device_id ptp_id_table[];
 
+static bool is_ptp_dev_cn10k(struct ptp *ptp)
+{
+	return (ptp->pdev->device == PCI_DEVID_CN10K_PTP) ? true : false;
+}
+
 static bool cn10k_ptp_errata(struct ptp *ptp)
 {
 	if (ptp->pdev->subsystem_device == PCI_SUBSYS_DEVID_CN10K_A_PTP ||
@@ -282,7 +287,14 @@ void ptp_start(struct ptp *ptp, u64 sclk, u32 ext_clk_freq, u32 extts)
 
 static int ptp_get_tstmp(struct ptp *ptp, u64 *clk)
 {
-	*clk = readq(ptp->reg_base + PTP_TIMESTAMP);
+	u64 timestamp;
+
+	if (is_ptp_dev_cn10k(ptp)) {
+		timestamp = readq(ptp->reg_base + PTP_TIMESTAMP);
+		*clk = (timestamp >> 32) * NSEC_PER_SEC + (timestamp & 0xFFFFFFFF);
+	} else {
+		*clk = readq(ptp->reg_base + PTP_TIMESTAMP);
+	}
 
 	return 0;
 }
-- 
2.16.5

