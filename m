Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928555B4502
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 09:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIJHyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 03:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIJHyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 03:54:44 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8CC18E11;
        Sat, 10 Sep 2022 00:54:43 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28A6RUt1006086;
        Sat, 10 Sep 2022 00:54:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rP7tjxV/ufN9hoaG96rpc9HjV9WDz8g2SRhjwxSQF04=;
 b=c5RkxsAVdhx8PRQ8uhOgXGT8Aky1szm8GTe3oVRrfeu0yleVH7eKTnlOwqPGSku+xtGn
 WERv3dFt74ig+KkxbdFSiuueuDa+bHQVtjfV1A9G663yc0Ose3CLfKY1R/iUV9OpSwu7
 TXyO9Xjp/DRtIvmQmE4LCZGEhIqr/OfS1NBp9b+Kww0FgVCjsdLB5lIr2o5Z3gcLDw92
 hEDlWpzyKuK5i+mP+Uz0UgwZwHlg67T8MPmjGX/Cwv/7KI/2KYfcYN3mgTUSLhpdVekG
 roUGfKm9C28Ncl/cCtCkfoL2FLXq72V7WD389EYyJPDukA17w35XnEAtFe2zmGi2GXUa 3w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jgk1hrfn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 10 Sep 2022 00:54:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 10 Sep
 2022 00:54:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 10 Sep 2022 00:54:25 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 10D513F7055;
        Sat, 10 Sep 2022 00:54:22 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <hkelam@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 1/4] octeontx2-af: return correct ptp timestamp for CN10K silicon
Date:   Sat, 10 Sep 2022 13:24:13 +0530
Message-ID: <20220910075416.22887-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20220910075416.22887-1-naveenm@marvell.com>
References: <20220910075416.22887-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WZuFBb2TCx-2B0z2N_cTsu8BY5UCuUjw
X-Proofpoint-GUID: WZuFBb2TCx-2B0z2N_cTsu8BY5UCuUjw
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

