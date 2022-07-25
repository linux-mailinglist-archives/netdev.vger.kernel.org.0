Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B39058007A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbiGYOKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiGYOKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:10:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C6364E0;
        Mon, 25 Jul 2022 07:10:20 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PDnL6m029014;
        Mon, 25 Jul 2022 14:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=52kS6t2GmIrYYJHMDgLcrtwCBrJABA7Y6MEXnlv+i1k=;
 b=lVT2zv+3r7jk4xF7AoDUrQp2Rc58Blt/dRSSQpEk2vFFyN3m0x+jrlOXvCTE4cHFuKVJ
 jMX98V9DNIwgEe5Yjii+cejmXZxF4m1yCrZGCRJXfLovX/Vwwiozfa/qnPPd9HhRKK0a
 9V3daaPmfRY3P4ZQ/WezfYbdzQyf21SFerI6uKmg+pQDHrmWdjFw9SEDNhU5umXsMOEz
 olRCLN7lqSyicMAcQVk6Ug5UJyMGa8mulknNH8N8eiBLEuWzXfT7EN12Ha3iBcDTwIXU
 lnkNMVY8k6sHMCiUdMu+MGsnlVvfh2v4jWZsTGO0r48jZCoLc0y2Rt5h513AXw8L9O1L nA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhvd7gqh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 14:10:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PE5d3h021629;
        Mon, 25 Jul 2022 14:10:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3hg96wjj4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 14:10:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PEAO8a27591120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 14:10:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F05242045;
        Mon, 25 Jul 2022 14:10:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 388F74203F;
        Mon, 25 Jul 2022 14:10:08 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.136.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jul 2022 14:10:07 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 1/4] net/smc: Eliminate struct smc_ism_position
Date:   Mon, 25 Jul 2022 16:09:57 +0200
Message-Id: <20220725141000.70347-2-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220725141000.70347-1-wenjia@linux.ibm.com>
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V6ijlOz_cam8K7md_x-YRSD4S3k4iV5-
X-Proofpoint-GUID: V6ijlOz_cam8K7md_x-YRSD4S3k4iV5-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_09,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=788
 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207250059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

This struct is used in a single place only, and its usage generates
inefficient code. Time to clean up!

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-and-tested-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Wenjia Zhang < wenjia@linux.ibm.com>
---
 net/smc/smc_ism.c | 11 -----------
 net/smc/smc_ism.h | 20 +++++++++++---------
 net/smc/smc_tx.c  | 10 +++-------
 3 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index a2084ecdb97e..c656ef25ee4b 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -33,17 +33,6 @@ int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *smcd)
 					   vlan_id);
 }
 
-int smc_ism_write(struct smcd_dev *smcd, const struct smc_ism_position *pos,
-		  void *data, size_t len)
-{
-	int rc;
-
-	rc = smcd->ops->move_data(smcd, pos->token, pos->index, pos->signal,
-				  pos->offset, data, len);
-
-	return rc < 0 ? rc : 0;
-}
-
 void smc_ism_get_system_eid(u8 **eid)
 {
 	if (!smc_ism_v2_capable)
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 004b22a13ffa..d6b2db604fe8 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -28,13 +28,6 @@ struct smc_ism_vlanid {			/* VLAN id set on ISM device */
 	refcount_t refcnt;		/* Reference count */
 };
 
-struct smc_ism_position {	/* ISM device position to write to */
-	u64 token;		/* Token of DMB */
-	u32 offset;		/* Offset into DMBE */
-	u8 index;		/* Index of DMBE */
-	u8 signal;		/* Generate interrupt on owner side */
-};
-
 struct smcd_dev;
 
 int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *dev);
@@ -45,12 +38,21 @@ int smc_ism_put_vlan(struct smcd_dev *dev, unsigned short vlan_id);
 int smc_ism_register_dmb(struct smc_link_group *lgr, int buf_size,
 			 struct smc_buf_desc *dmb_desc);
 int smc_ism_unregister_dmb(struct smcd_dev *dev, struct smc_buf_desc *dmb_desc);
-int smc_ism_write(struct smcd_dev *dev, const struct smc_ism_position *pos,
-		  void *data, size_t len);
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
 void smc_ism_get_system_eid(u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
 bool smc_ism_is_v2_capable(void);
 void smc_ism_init(void);
 int smcd_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb);
+
+static inline int smc_ism_write(struct smcd_dev *smcd, u64 dmb_tok,
+				unsigned int idx, bool sf, unsigned int offset,
+				void *data, size_t len)
+{
+	int rc;
+
+	rc = smcd->ops->move_data(smcd, dmb_tok, idx, sf, offset, data, len);
+	return rc < 0 ? rc : 0;
+}
+
 #endif
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 4e8377657a62..64dedffe9d26 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -320,15 +320,11 @@ int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
 int smcd_tx_ism_write(struct smc_connection *conn, void *data, size_t len,
 		      u32 offset, int signal)
 {
-	struct smc_ism_position pos;
 	int rc;
 
-	memset(&pos, 0, sizeof(pos));
-	pos.token = conn->peer_token;
-	pos.index = conn->peer_rmbe_idx;
-	pos.offset = conn->tx_off + offset;
-	pos.signal = signal;
-	rc = smc_ism_write(conn->lgr->smcd, &pos, data, len);
+	rc = smc_ism_write(conn->lgr->smcd, conn->peer_token,
+			   conn->peer_rmbe_idx, signal, conn->tx_off + offset,
+			   data, len);
 	if (rc)
 		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
 	return rc;
-- 
2.35.2

