Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071FA2A343D
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgKBTfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:35:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725806AbgKBTee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 14:34:34 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JXDHG145431;
        Mon, 2 Nov 2020 14:34:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=sMQNOIZtCtGN5tCOTTEV7U3ypuN59R33hyWHpQRjaWM=;
 b=EvIr0JmzOLqK46MZVo3/8pU0YbD4Ai9N8rvVAOzD8pUVTkQnUMgjVvjQHXMf942Gc/rz
 0pD0Ep50GPa79qRfXs6mjulcdf3/axp8t406BoXk6DoAWwGxpuLUlj2vhXflGBMZAaia
 KD3srWjvF20M8LXuSf3/9kVHHs3lR/+cS60NmlKwPJQ22p/1rGabIfS710tmIjxRh4vv
 khiNVzaG+KhGLid0FvvCBL+khDGddlB0/oBI4DU6zcpBdIuGYwnou94yYTXv9/saXuOp
 5cmdqnqgf33TUo3Hg3ZHruVF5TBXDDE3D7myA3M1+xhrwFZWwjCPEXnPzpcmo4n1cdJx 7Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34jphb350m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 14:34:33 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JXB97027872;
        Mon, 2 Nov 2020 19:34:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 34h0fcte9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 19:34:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2JYShs4391432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Nov 2020 19:34:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 380EF4C040;
        Mon,  2 Nov 2020 19:34:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06C874C04A;
        Mon,  2 Nov 2020 19:34:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 19:34:27 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next 10/15] net/smc: Introduce SMCR get link command
Date:   Mon,  2 Nov 2020 20:34:04 +0100
Message-Id: <20201102193409.70901-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201102193409.70901-1-kgraul@linux.ibm.com>
References: <20201102193409.70901-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_13:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 bulkscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Introduce get link command which loops through
all available links of all available link groups. It
uses the SMC-R linkgroup list as entry point, not
the socket list, which makes linkgroup diagnosis
possible, in case linkgroup does not contain active
connections anymore.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc_diag.h |  7 ++++
 net/smc/smc_diag.c            | 62 ++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 6ae028344b6d..16b8ea9da3d5 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -79,6 +79,7 @@ enum {
 /* SMC_DIAG_GET_LGR_INFO command extensions */
 enum {
 	SMC_DIAG_LGR_INFO_SMCR = 1,
+	SMC_DIAG_LGR_INFO_SMCR_LINK,
 };
 
 #define SMC_DIAG_MAX (__SMC_DIAG_MAX - 1)
@@ -129,6 +130,12 @@ struct smc_diag_linkinfo {
 	__u8 ibport;			/* RDMA device port number */
 	__u8 gid[40];			/* local GID */
 	__u8 peer_gid[40];		/* peer GID */
+	/* Fields above used by legacy v1 code */
+	__u32 conn_cnt;
+	__u8 netdev[IFNAMSIZ];		/* ethernet device name */
+	__u8 link_uid[4];		/* unique link id */
+	__u8 peer_link_uid[4];		/* unique peer link id */
+	__u32 link_state;		/* link state */
 };
 
 struct smc_diag_lgrinfo {
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index c53904b3f350..6885814b6e4f 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -20,6 +20,7 @@
 #include <net/smc.h>
 
 #include "smc.h"
+#include "smc_ib.h"
 #include "smc_core.h"
 
 struct smc_diag_dump_ctx {
@@ -203,6 +204,54 @@ static bool smc_diag_fill_dmbinfo(struct sock *sk, struct sk_buff *skb)
 	return true;
 }
 
+static int smc_diag_fill_lgr_link(struct smc_link_group *lgr,
+				  struct smc_link *link,
+				  struct sk_buff *skb,
+				  struct netlink_callback *cb,
+				  struct smc_diag_req_v2 *req)
+{
+	struct smc_diag_linkinfo link_info;
+	int dummy = 0, rc = 0;
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, MAGIC_SEQ_V2_ACK,
+			cb->nlh->nlmsg_type, 0, NLM_F_MULTI);
+
+	memset(&link_info, 0, sizeof(link_info));
+	link_info.link_state = link->state;
+	link_info.link_id = link->link_id;
+	link_info.conn_cnt = atomic_read(&link->conn_cnt);
+	link_info.ibport = link->ibport;
+
+	memcpy(link_info.link_uid, link->link_uid,
+	       sizeof(link_info.link_uid));
+	snprintf(link_info.ibname, sizeof(link_info.ibname), "%s",
+		 link->ibname);
+	snprintf(link_info.netdev, sizeof(link_info.netdev), "%s",
+		 link->ndevname);
+	memcpy(link_info.peer_link_uid, link->peer_link_uid,
+	       sizeof(link_info.peer_link_uid));
+
+	smc_gid_be16_convert(link_info.gid,
+			     link->gid);
+	smc_gid_be16_convert(link_info.peer_gid,
+			     link->peer_gid);
+
+	/* Just a command place holder to signal back the command reply type */
+	if (nla_put(skb, SMC_DIAG_GET_LGR_INFO, sizeof(dummy), &dummy) < 0)
+		goto errout;
+	if (nla_put(skb, SMC_DIAG_LGR_INFO_SMCR_LINK,
+		    sizeof(link_info), &link_info) < 0)
+		goto errout;
+
+	nlmsg_end(skb, nlh);
+	return rc;
+
+errout:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
 static int smc_diag_fill_lgr(struct smc_link_group *lgr,
 			     struct sk_buff *skb,
 			     struct netlink_callback *cb,
@@ -238,7 +287,7 @@ static int smc_diag_handle_lgr(struct smc_link_group *lgr,
 			       struct smc_diag_req_v2 *req)
 {
 	struct nlmsghdr *nlh;
-	int rc = 0;
+	int i, rc = 0;
 
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, MAGIC_SEQ_V2_ACK,
 			cb->nlh->nlmsg_type, 0, NLM_F_MULTI);
@@ -250,6 +299,17 @@ static int smc_diag_handle_lgr(struct smc_link_group *lgr,
 		goto errout;
 
 	nlmsg_end(skb, nlh);
+
+	if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCR_LINK - 1)))) {
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			if (!smc_link_usable(&lgr->lnk[i]))
+				continue;
+			rc = smc_diag_fill_lgr_link(lgr, &lgr->lnk[i], skb,
+						    cb, req);
+			if (rc < 0)
+				goto errout;
+		}
+	}
 	return rc;
 
 errout:
-- 
2.17.1

