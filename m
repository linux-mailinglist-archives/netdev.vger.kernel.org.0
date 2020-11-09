Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136642ABF97
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgKIPSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:18:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731839AbgKIPS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:18:28 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9FH6xN028801;
        Mon, 9 Nov 2020 10:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=/i3i9v1aWaAjXZWOlSFqJh43M+8QXv3ystWotp7zvIc=;
 b=P4WZODJPn/WFsQZ/8q1e2612Wc1bQh0rrX82a4X7c8y4PtFfBg+X1tudWrrgnuUyoL0L
 0rMrHoI+kaznfZksEOXNXYmO9RCvaHjZDtpMGKsvYpg8Gh7A7gA4rD4EYOaXswHNiJiR
 RsJU8Su/VQl3fNPr5uCp6cERA7maWPvhj9odqUqtKYoFA8ujVpj4TOHtX0+pUJ8ODuCs
 98fz5u5vfQzVA9t8WmzcVI2Pk+wDDR97VVgT4vQU/M51qQKmT/lzB86SCxYh8EC/dCgZ
 XB5feGCFZd1x8s14LlwpEOowLlOHGxomGDljV8EgY2y+CGVsDMPPRqgextWFQ5wa2H8f BQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34q592y0br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 10:18:25 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A9FCBJn013836;
        Mon, 9 Nov 2020 15:18:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 34nk77s3u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 15:18:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A9FIL6d8454862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 15:18:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 375BFA4065;
        Mon,  9 Nov 2020 15:18:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F339AA405B;
        Mon,  9 Nov 2020 15:18:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 15:18:20 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v4 10/15] net/smc: Introduce SMCR get link command
Date:   Mon,  9 Nov 2020 16:18:09 +0100
Message-Id: <20201109151814.15040-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201109151814.15040-1-kgraul@linux.ibm.com>
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_07:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 adultscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090102
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
 include/uapi/linux/smc_diag.h |  8 +++++
 net/smc/smc_diag.c            | 62 ++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 6ae028344b6d..a57df0296aa4 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/inet_diag.h>
+#include <linux/if.h>
 #include <linux/smc.h>
 #include <rdma/ib_user_verbs.h>
 
@@ -79,6 +80,7 @@ enum {
 /* SMC_DIAG_GET_LGR_INFO command extensions */
 enum {
 	SMC_DIAG_LGR_INFO_SMCR = 1,
+	SMC_DIAG_LGR_INFO_SMCR_LINK,
 };
 
 #define SMC_DIAG_MAX (__SMC_DIAG_MAX - 1)
@@ -129,6 +131,12 @@ struct smc_diag_linkinfo {
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
index c958b23843e6..9a41548d6263 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -20,6 +20,7 @@
 #include <net/smc.h>
 
 #include "smc.h"
+#include "smc_ib.h"
 #include "smc_core.h"
 
 static const struct smc_diag_ops *smc_diag_ops;
@@ -205,6 +206,54 @@ static bool smc_diag_fill_dmbinfo(struct sock *sk, struct sk_buff *skb)
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
@@ -240,7 +289,7 @@ static int smc_diag_handle_lgr(struct smc_link_group *lgr,
 			       struct smc_diag_req_v2 *req)
 {
 	struct nlmsghdr *nlh;
-	int rc = 0;
+	int i, rc = 0;
 
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, MAGIC_SEQ_V2_ACK,
 			cb->nlh->nlmsg_type, 0, NLM_F_MULTI);
@@ -252,6 +301,17 @@ static int smc_diag_handle_lgr(struct smc_link_group *lgr,
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

