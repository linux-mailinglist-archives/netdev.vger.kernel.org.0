Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938922AA534
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgKGNBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:01:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728026AbgKGNAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:00:21 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CW50a099380;
        Sat, 7 Nov 2020 08:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=/i3i9v1aWaAjXZWOlSFqJh43M+8QXv3ystWotp7zvIc=;
 b=LRQFFla7jDOOSiiDyVA42hvxuqATLXRXOm9mRoeIFbQ9Qqvh2UEYVrC22jfewleLNGWB
 75UhTIp70E2KhGSkwUBc/lEY0eXh0VsxnfM2yh9rHEsm/xyIWdSKYvvXx9ER4EXY/DFB
 MS36fsExeiL8u9lEpxdVfjtyLko3XF+I9g47EcfRRbnKq/OLtyWiGAEY5180U/5d0Y00
 BoBirPgidzioxQWrjhnOczKwXeQcSqNAO3RKWuNrF/UM3ho3xlOJf/0bWK/Bwv8qU85f
 R1KFJ7do9agHkk1j1x3LDYzDr5s6DTcCkxGgbCT7ZgbsFRLs2z86KqSGXkgfvA8wKQMd OA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34nry9bqm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 08:00:20 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CvCCX016083;
        Sat, 7 Nov 2020 13:00:13 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 34nk788ag8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 13:00:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A7D0Aof24445380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 7 Nov 2020 13:00:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E65DA406E;
        Sat,  7 Nov 2020 13:00:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 280FCA4082;
        Sat,  7 Nov 2020 13:00:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  7 Nov 2020 13:00:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v3 10/15] net/smc: Introduce SMCR get link command
Date:   Sat,  7 Nov 2020 13:59:53 +0100
Message-Id: <20201107125958.16384-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107125958.16384-1-kgraul@linux.ibm.com>
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-07_07:2020-11-05,2020-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 suspectscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 mlxlogscore=-1000
 mlxscore=100 spamscore=100 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011070081
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

