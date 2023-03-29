Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEB46CDA18
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjC2NII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjC2NID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:08:03 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F14DD2;
        Wed, 29 Mar 2023 06:07:53 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TCf6lM030891;
        Wed, 29 Mar 2023 13:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : subject
 : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=ukV2puvT6Yb9ovva4Gb5MV+nAbKsW5aWmpTLdH48Cqs=;
 b=d9Toxc4oMkQthJt0ZHb4DdRIokLJyIOeloP8/zLa1eMM84Ae9GsZmRHMbFrQbJDPF8bI
 mnbceBeZ+F9nPa/H9bU/pguFOlLWwGMp0ojgticSwOYSShwRutH2pXe29p7de/nrFpkg
 2X6sTqcXQ2b8D1NYMcYe/QQXEHvXOPBDONQXMg7t8jkZDS2X0bpfYzB3Y5K/5o1EsbMv
 3mdOBu0uq14H/o6gtq1N8bgksUDW/2eOkjdgccMeTU8mhylW3hJJl8xWlGO4bWh8qhRs
 okFrKJhClz450Lrm6oehabpdw7+o4Kz6oG4Ssr+Usjn67R3laEtqoPSgY8nsmEYRlHew vw== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pkx4tbha9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:07:44 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32TD7hUN014868
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:07:43 GMT
Received: from srichara-linux.qualcomm.com (10.80.80.8) by
 nalasex01c.na.qualcomm.com (10.47.97.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Wed, 29 Mar 2023 06:07:39 -0700
From:   Sricharan R <quic_srichara@quicinc.com>
To:     <mani@kernel.org>, <manivannan.sadhasivam@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT
Date:   Wed, 29 Mar 2023 18:37:30 +0530
Message-ID: <1680095250-21032-1-git-send-email-quic_srichara@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ---nnJxp7NfEzLz4spvnc47KXR4gg8Zd
X-Proofpoint-ORIG-GUID: ---nnJxp7NfEzLz4spvnc47KXR4gg8Zd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_06,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290105
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the qrtr socket is released, qrtr_port_remove gets called, which
broadcasts a DEL_CLIENT. After this DEL_SERVER is also additionally
broadcasted, which becomes NOP, but triggers the below error msg.

"failed while handling packet from 2:-2", since remote node already
acted upon on receiving the DEL_CLIENT, once again when it receives
the DEL_SERVER, it returns -ENOENT.

Fixing it by not sending a 'DEL_SERVER' to remote when a 'DEL_CLIENT'
was sent for that port.

Signed-off-by: Ram Kumar D <quic_ramd@quicinc.com>
Signed-off-by: Sricharan R <quic_srichara@quicinc.com>
---
Note: Functionally tested on 5.4 kernel and compile tested on 6.3 TOT

 net/qrtr/ns.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 722936f..6fbb195 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -274,7 +274,7 @@ static struct qrtr_server *server_add(unsigned int service,
 	return NULL;
 }
 
-static int server_del(struct qrtr_node *node, unsigned int port)
+static int server_del(struct qrtr_node *node, unsigned int port, bool del_server)
 {
 	struct qrtr_lookup *lookup;
 	struct qrtr_server *srv;
@@ -287,7 +287,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
 	radix_tree_delete(&node->servers, port);
 
 	/* Broadcast the removal of local servers */
-	if (srv->node == qrtr_ns.local_node)
+	if (srv->node == qrtr_ns.local_node && del_server)
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
@@ -459,10 +459,14 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		kfree(lookup);
 	}
 
-	/* Remove the server belonging to this port */
+	/* Remove the server belonging to this port
+	 * Given that DEL_CLIENT is already broadcasted
+	 * by port_remove, no need to send DEL_SERVER for
+	 * the same port to remote
+	 */
 	node = node_get(node_id);
 	if (node)
-		server_del(node, port);
+		server_del(node, port, false);
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
@@ -567,7 +571,7 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 	if (!node)
 		return -ENOENT;
 
-	return server_del(node, port);
+	return server_del(node, port, true);
 }
 
 static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
-- 
2.7.4

