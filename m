Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792AE6D3DAA
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 09:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjDCG7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjDCG7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:59:39 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1CF2D4E;
        Sun,  2 Apr 2023 23:59:38 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3336inTD023885;
        Mon, 3 Apr 2023 06:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : subject
 : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=3GDQJ/ZROzBuIwYu+EN78kMi1ZXmlZTyRpJ+QDJIxSo=;
 b=nkIIBWZSesFGzPkw0j1ehDdYs8a2Y9bNpgt990Pd8q/StUSgqSTdzV2D+0SGhRgFBHKO
 dOXW/KMRm/gnefarqqdtoPf8dJykSbsbcNbeqU/xX9ZcbxNEWT0hZdfjgQFI7nDEFENj
 RYDsra0CjE0ZqgMxyEU3T0fA6BTolHaeteF9lc3PFwEk/GIk4JH5II0AgZygEh56/16p
 kR3Or8H/6L6vYAJLQwrMaOrkP2yfbzbBkwMQfGWUZYdb/axLsx7/GOtedjLruFLfDxVO
 UOuR8hPbZ9z1Yo75dXXVSmS0eFTr8b/TS/ur9EUYmB9um4NPitO9zwBLazh2SKPn4GlF 9A== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ppcubkmmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 06:59:31 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3336xUmM006226
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Apr 2023 06:59:30 GMT
Received: from srichara-linux.qualcomm.com (10.80.80.8) by
 nalasex01c.na.qualcomm.com (10.47.97.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Sun, 2 Apr 2023 23:59:10 -0700
From:   Sricharan Ramabadhran <quic_srichara@quicinc.com>
To:     <mani@kernel.org>, <manivannan.sadhasivam@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V3] net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT
Date:   Mon, 3 Apr 2023 12:28:51 +0530
Message-ID: <1680505131-11645-1-git-send-email-quic_srichara@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: JkQt9VfVVSq8hxsG_EnCUUoSAJfpw-ZJ
X-Proofpoint-GUID: JkQt9VfVVSq8hxsG_EnCUUoSAJfpw-ZJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_04,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=882 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030053
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the remote side, when QRTR socket is removed, af_qrtr will call
qrtr_port_remove() which broadcasts the DEL_CLIENT packet to all neighbours
including local NS. NS upon receiving the DEL_CLIENT packet, will remove
the lookups associated with the node:port and broadcasts the DEL_SERVER
packet.

But on the host side, due to the arrival of the DEL_CLIENT packet, the NS
would've already deleted the server belonging to that port. So when the
remote's NS again broadcasts the DEL_SERVER for that port, it throws below
error message on the host:

"failed while handling packet from 2:-2"

So fix this error by not broadcasting the DEL_SERVER packet when the
DEL_CLIENT packet gets processed."

Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Ram Kumar Dharuman <quic_ramd@quicinc.com>
Signed-off-by: Sricharan Ramabadhran <quic_srichara@quicinc.com>
---
[v3] Ordered signed off tags and added Mani's reviewed-by
Note: Functionally tested on 5.4 and compile tested on 6.3 TOT

 net/qrtr/ns.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 722936f..0f25a38 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -274,7 +274,7 @@ static struct qrtr_server *server_add(unsigned int service,
 	return NULL;
 }
 
-static int server_del(struct qrtr_node *node, unsigned int port)
+static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 {
 	struct qrtr_lookup *lookup;
 	struct qrtr_server *srv;
@@ -287,7 +287,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
 	radix_tree_delete(&node->servers, port);
 
 	/* Broadcast the removal of local servers */
-	if (srv->node == qrtr_ns.local_node)
+	if (srv->node == qrtr_ns.local_node && bcast)
 		service_announce_del(&qrtr_ns.bcast_sq, srv);
 
 	/* Announce the service's disappearance to observers */
@@ -373,7 +373,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 		}
 		slot = radix_tree_iter_resume(slot, &iter);
 		rcu_read_unlock();
-		server_del(node, srv->port);
+		server_del(node, srv->port, true);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -459,10 +459,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		kfree(lookup);
 	}
 
-	/* Remove the server belonging to this port */
+	/* Remove the server belonging to this port but don't broadcast
+	 * DEL_SERVER. Neighbours would've already removed the server belonging
+	 * to this port due to the DEL_CLIENT broadcast from qrtr_port_remove().
+	 */
 	node = node_get(node_id);
 	if (node)
-		server_del(node, port);
+		server_del(node, port, false);
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
@@ -567,7 +570,7 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 	if (!node)
 		return -ENOENT;
 
-	return server_del(node, port);
+	return server_del(node, port, true);
 }
 
 static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
-- 
2.7.4

