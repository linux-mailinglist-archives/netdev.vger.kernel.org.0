Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F7A57F3F7
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiGXIVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiGXIVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:21:34 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695A117ABC
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:21:33 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26O4wlw6031813;
        Sun, 24 Jul 2022 01:21:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4+SOHzXJnPl1WfyAObO2hAsmqqDM94O0KWM/e3iQRZw=;
 b=cdP7X5Zy/Wcub3XIqxTbHIAdRAVJKWssI9b3+tD0rXDHPi2bNLTDHLMSMtiUoIre99fC
 yez+fPzc+jiEYnFZU/+irq1lwNCAL8i7AfR0ch77qCXHEst1e0CDfTplMLIXDW141Cav
 dSuvC5QUMHBX2b48iH4BlbYmi7cNGcAZ1mdxYgQmGmJQeB+Srt2hs8aMbnlCHs1rtOXQ
 oCi9Xv3LJjqa/+0ASQrA1Ai5nih+za2rD1CuqFmtndz6xI2/QWA470U78A9mO87XrvCY
 JqYjuA3XR3Yj1FG5nVEA+YNmibv1LcmxF4720JX2qLOJeN8Pmdt6cWbvUG7cdRh9vegd Jw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hgebq2cgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 01:21:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Jul
 2022 01:21:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jul 2022 01:21:24 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id C78343F70C5;
        Sun, 24 Jul 2022 01:21:22 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 2/2] octeontx2-pf: Fix UDP/TCP src and dst port tc filters
Date:   Sun, 24 Jul 2022 13:51:14 +0530
Message-ID: <1658650874-16459-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658650874-16459-1-git-send-email-sbhatta@marvell.com>
References: <1658650874-16459-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: PdFTOw-OR8s_xA-dH2oXBsn4575uMJPn
X-Proofpoint-ORIG-GUID: PdFTOw-OR8s_xA-dH2oXBsn4575uMJPn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-23_02,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check the mask for non-zero value before installing tc filters
for L4 source and destination ports. Otherwise installing a
filter for source port installs destination port too and
vice-versa.

Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on ingress traffic")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 30 +++++++++++++---------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index fa83cf2..e64318c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -648,21 +648,27 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 
 		flow_spec->dport = match.key->dst;
 		flow_mask->dport = match.mask->dst;
-		if (ip_proto == IPPROTO_UDP)
-			req->features |= BIT_ULL(NPC_DPORT_UDP);
-		else if (ip_proto == IPPROTO_TCP)
-			req->features |= BIT_ULL(NPC_DPORT_TCP);
-		else if (ip_proto == IPPROTO_SCTP)
-			req->features |= BIT_ULL(NPC_DPORT_SCTP);
+
+		if (flow_mask->dport) {
+			if (ip_proto == IPPROTO_UDP)
+				req->features |= BIT_ULL(NPC_DPORT_UDP);
+			else if (ip_proto == IPPROTO_TCP)
+				req->features |= BIT_ULL(NPC_DPORT_TCP);
+			else if (ip_proto == IPPROTO_SCTP)
+				req->features |= BIT_ULL(NPC_DPORT_SCTP);
+		}
 
 		flow_spec->sport = match.key->src;
 		flow_mask->sport = match.mask->src;
-		if (ip_proto == IPPROTO_UDP)
-			req->features |= BIT_ULL(NPC_SPORT_UDP);
-		else if (ip_proto == IPPROTO_TCP)
-			req->features |= BIT_ULL(NPC_SPORT_TCP);
-		else if (ip_proto == IPPROTO_SCTP)
-			req->features |= BIT_ULL(NPC_SPORT_SCTP);
+
+		if (flow_mask->sport) {
+			if (ip_proto == IPPROTO_UDP)
+				req->features |= BIT_ULL(NPC_SPORT_UDP);
+			else if (ip_proto == IPPROTO_TCP)
+				req->features |= BIT_ULL(NPC_SPORT_TCP);
+			else if (ip_proto == IPPROTO_SCTP)
+				req->features |= BIT_ULL(NPC_SPORT_SCTP);
+		}
 	}
 
 	return otx2_tc_parse_actions(nic, &rule->action, req, f, node);
-- 
2.7.4

