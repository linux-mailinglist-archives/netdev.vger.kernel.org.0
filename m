Return-Path: <netdev+bounces-11830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6BB734B8A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 628CA1C2091C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 06:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A03823D9;
	Mon, 19 Jun 2023 06:07:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BBE23CA
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 06:07:00 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95559B1;
	Sun, 18 Jun 2023 23:06:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35J5vnjt030474;
	Sun, 18 Jun 2023 23:06:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=zOJ7wWMQldgXdwhlqtudOFETz8AB3AjI/touzpFQHCg=;
 b=Zdkk4zQj/ycBH00bOFuy+H4TFkeWpRdpoU1/remeGA/I2YVroajWgMQ32G25ZYJRwEyC
 mNsJTLy+7RBq6ZyZinCHQV2n5tHePHhBn1JVu43Hh/zr/727k83hmq8shT9zun0YiMPz
 sVyp5cbk/+tNXRrCvItir3on6wPA9QM1njORSy28vqsi9q+WyTz0A/ItFhTivIBfM160
 2iJQc+EDpJ+Q8wkPKEwM8AwWZy6evoAZ6aKuqShIPPvmtZPjBUZ6h0BM8LKZOgXqysWX
 6DbHnwww6NxbeL6Bw0z8s7boNYCGtncNDMzpOTq8jriXfCZoQ8GUaRZXSccvgVzszWjG Ig== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r9cbkbsj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sun, 18 Jun 2023 23:06:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 18 Jun
 2023 23:06:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 18 Jun 2023 23:06:43 -0700
Received: from marvell-OptiPlex-7090.marvell.com (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with ESMTP id 595205C68EC;
	Sun, 18 Jun 2023 23:06:40 -0700 (PDT)
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <sgoutham@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sbhatta@marvell.com>,
        <gakula@marvell.com>, <schalla@marvell.com>, <hkelam@marvell.com>,
        "Ratheesh
 Kannoth" <rkannoth@marvell.com>
Subject: [PATCH net-next] octeontx2-pf: TC flower offload support for rxqueue mapping
Date: Mon, 19 Jun 2023 11:36:38 +0530
Message-ID: <20230619060638.1032304-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: C1X34JIlqrMUAO_t0i2PedUSpeSYFFs9
X-Proofpoint-ORIG-GUID: C1X34JIlqrMUAO_t0i2PedUSpeSYFFs9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_04,2023-06-16_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

 TC rule support to offload rx queue mapping rules.

Eg:
   tc filter add dev eth2 ingress protocol ip flower \
      dst_ip 192.168.8.100  \
      action skbedit queue_mapping 4 skip_sw
      action mirred ingress redirect dev eth5

Packets destined to 192.168.8.100 will be forwarded to rx
queue 4 of eth5 interface.

   tc filter add dev eth2 ingress protocol ip flower \
      dst_ip 192.168.8.100  \
      action skbedit queue_mapping 9 skip_sw

Packets destined to 192.168.8.100 will be forwarded to rx
queue 4 of eth2 interface.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 231c3f0efb60..8a13df592af6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -396,8 +396,12 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 				return -EOPNOTSUPP;
 			}
 			req->vf = priv->pcifunc & RVU_PFVF_FUNC_MASK;
-			req->op = NIX_RX_ACTION_DEFAULT;
-			return 0;
+
+			/* if op is already set; avoid overwriting the same */
+			if (!req->op)
+				req->op = NIX_RX_ACTION_DEFAULT;
+			break;
+
 		case FLOW_ACTION_VLAN_POP:
 			req->vtag0_valid = true;
 			/* use RX_VTAG_TYPE7 which is initialized to strip vlan tag */
@@ -433,6 +437,12 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 		case FLOW_ACTION_MARK:
 			mark = act->mark;
 			break;
+
+		case FLOW_ACTION_RX_QUEUE_MAPPING:
+			req->op = NIX_RX_ACTIONOP_UCAST;
+			req->index = act->rx_queue;
+			break;
+
 		default:
 			return -EOPNOTSUPP;
 		}
-- 
2.25.1


