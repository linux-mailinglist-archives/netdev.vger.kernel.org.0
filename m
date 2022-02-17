Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F52C4BA7AF
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243985AbiBQSI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:08:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbiBQSIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:08:25 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8418615DB28;
        Thu, 17 Feb 2022 10:08:10 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21HFRgDa025670;
        Thu, 17 Feb 2022 10:08:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8jG0tqM0e9p6vsriO0mMsEIgAm5bCPAtrYKjjQkIC3k=;
 b=Zid9lCd/kOQrOmDpisLc+w2PFH2QeAv8Vd4SNUiNfo8fiFmwksSRmbB2aMntUf74RopT
 SEDsPihdy3HUhTN26iW60Ucgbc1nxj0jFCY9aUUtladXsz4E3Frgv2MNsovv8rhaQvFP
 2qdouLv2MruXJ5UrV5ePEJzq80hdYC0RYlatk+v6EMvTeTKiOYLlGB8YWeC9/8Td13it
 0vd/dQrlmV6RNE689ofz9ZribAosvjCRfDnYgtDqgaSenzUuFO1Lh3mi+0j/n3rED7bw
 0DIX3PXuAEWLpwpbCtr/wYWw+oNAmdcekKoM7kEl0l9lZdfMdAX0wJ0LIV+r+P55cOfm qg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e9kktt4f1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 10:08:05 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 10:08:03 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 17 Feb 2022 10:08:03 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 91E873F70F6;
        Thu, 17 Feb 2022 10:05:02 -0800 (PST)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Harman Kalra <hkalra@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>
Subject: [net-next PATCH 1/3] octeontx2-af: Sending tsc value to the userspace
Date:   Thu, 17 Feb 2022 23:34:48 +0530
Message-ID: <20220217180450.21721-2-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220217180450.21721-1-rsaladi2@marvell.com>
References: <20220217180450.21721-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7viX9QoLE_bdUrflCwdPygosvPotoUkO
X-Proofpoint-GUID: 7viX9QoLE_bdUrflCwdPygosvPotoUkO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_06,2022-02-17_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

This patch updates the existing PTP_OP_GET_CLOCK mbox message to
return timestamp counter value, tsc (cntvct_el0 or pmccntr_el0)
along with the PTP HI clock value.

In some debugging scenarios user might need to read the PTP HI
clock value in the fastpath, so as to know how many ticks have
been spent till point from the reception of the packet, as packet
reception tick value is already appended to the packet by CGX.
If directly PTP_OP_GET_CLOCK mbox message is sent every time user
wants to record PTP HI clock value, it will bring down the
performance to a great extent as mbox is a very expensive process.

To handle this PTP HI clock can be derived from timestamp counter
(tsc, which could be running at 100MHz or system freq) using two
parameters freq multiplier (ratio of frequencies of PTP HI clock
and tsc) and clock delta (by how much tsc is lagging from PTP HI
clock). During configuration stage these parameters are calculated
     freq_mult = (freq of PTP HI clock)/(freq of tsc counter)
     clk_delta = (PTP_HI clock value / freq_mult) - (tsc val)
   these PTP_HI val and tsc value are receieved by calling
   PTP_OP_GET_CLOCK. Purpose of returing tsc at the same time
   with PTP_HI value is to avoid mbox propagation delay.

Now whenever user wants to know PTP HI clock, it can be derived
from tsc counter and returned:
     PTP_HI val = (tsc value + clk_delta) * freq_mult

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  2 ++
 .../net/ethernet/marvell/octeontx2/af/ptp.c   | 25 ++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 550cb11197bf..2be11062ec33 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1451,12 +1451,14 @@ struct ptp_req {
 	struct mbox_msghdr hdr;
 	u8 op;
 	s64 scaled_ppm;
+	u8 is_pmu;
 	u64 thresh;
 };

 struct ptp_rsp {
 	struct mbox_msghdr hdr;
 	u64 clk;
+	u64 tsc;
 };

 struct set_vf_perm  {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index e682b7bfde64..211c375446f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -114,10 +114,28 @@ static int ptp_adjfine(struct ptp *ptp, long scaled_ppm)
 	return 0;
 }

-static int ptp_get_clock(struct ptp *ptp, u64 *clk)
+static inline u64 get_tsc(bool is_pmu)
+{
+#if defined(CONFIG_ARM64)
+	return is_pmu ? read_sysreg(pmccntr_el0) : read_sysreg(cntvct_el0);
+#else
+	return 0;
+#endif
+}
+
+static int ptp_get_clock(struct ptp *ptp, bool is_pmu, u64 *clk, u64 *tsc)
 {
 	/* Return the current PTP clock */
-	*clk = readq(ptp->reg_base + PTP_CLOCK_HI);
+	u64 end, start;
+	u8 retries = 0;
+
+	do {
+		start = get_tsc(0);
+		*tsc = get_tsc(is_pmu);
+		*clk = readq(ptp->reg_base + PTP_CLOCK_HI);
+		end = get_tsc(0);
+		retries++;
+	} while (((end - start) > 50) && retries < 5);

 	return 0;
 }
@@ -297,7 +315,8 @@ int rvu_mbox_handler_ptp_op(struct rvu *rvu, struct ptp_req *req,
 		err = ptp_adjfine(rvu->ptp, req->scaled_ppm);
 		break;
 	case PTP_OP_GET_CLOCK:
-		err = ptp_get_clock(rvu->ptp, &rsp->clk);
+		err = ptp_get_clock(rvu->ptp, req->is_pmu, &rsp->clk,
+				    &rsp->tsc);
 		break;
 	case PTP_OP_GET_TSTMP:
 		err = ptp_get_tstmp(rvu->ptp, &rsp->clk);
--
2.17.1
