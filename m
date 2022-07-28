Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9C7583E7B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 14:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbiG1MRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 08:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiG1MRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 08:17:04 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAB265814;
        Thu, 28 Jul 2022 05:17:02 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SA1AWc017488;
        Thu, 28 Jul 2022 05:16:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rP7tjxV/ufN9hoaG96rpc9HjV9WDz8g2SRhjwxSQF04=;
 b=hnY3LKMaKufV2fk3BMtQIhabo6820lo1rwVo6J4YCWEROAQFQZ8iIMxrVToHpsTYYb7G
 4ho6In3SEFm5eRD2Y1l4h5nO999fLJt9UksEHikcoO0jzYBx/bcPMnLUNUAmD1JUjwGh
 N6rZM0mTu6uVsEdoMLTp/fipt+AeE0PNBFiixyCRxF/Z1PUb09JbkmbhazgtegsdWKoG
 kag0z73k8V719G8F0Nbo7No6QrcdTaau/HBnSpk57jFNvuF1+5tveo4cAoE3C2N1O33g
 mpTH91YpB4rYvh/U8YT9MA64cjVir2ezELYHS134+JXSSmYGhV3hBk7pnKv/5ie+AKBh ZQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hk2fyd5nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 05:16:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jul
 2022 05:16:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 Jul 2022 05:16:49 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 78E5F3F703F;
        Thu, 28 Jul 2022 05:16:47 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 1/4] octeontx2-af: return correct ptp timestamp for CN10K silicon
Date:   Thu, 28 Jul 2022 17:46:35 +0530
Message-ID: <20220728121638.17989-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20220728121638.17989-1-naveenm@marvell.com>
References: <20220728121638.17989-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oOslbgswgbLNOoGLroErlR9e_yhHZXKw
X-Proofpoint-GUID: oOslbgswgbLNOoGLroErlR9e_yhHZXKw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_05,2022-07-28_02,2022-06-22_01
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

