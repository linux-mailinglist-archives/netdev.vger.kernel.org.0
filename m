Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80282A41C4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgKCK0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:26:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51670 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728120AbgKCKZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:25:56 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3A2hOg146362;
        Tue, 3 Nov 2020 05:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=p1H1TMjKKzp5qWi9gSGlik3FYXXb8bP6QdnCiF4nxto=;
 b=HEtjmXZrOBpt+QPUBtWUnLQYPqI0OG3iQQUg4KCmLN2FpXBAgnF5NzvRyPEWgSxATNvN
 A7OqO9GJwvs2i6uVmnpzM94Ae7Z2ZyWItDP8MudkF/rW7WgjxTdGAi/U1RGPTZS+KvYY
 IVtBNZfgf1NNdw36c/gzyDLU6M5K4lm50178S9I5ygt+4B2xJDaa7SLXN/kGMqdUB8dC
 d9j59lPM6Set+jECmNm2008OtaI0kZZvsK7mhrUxT3SmlMa1MQ4yBaVSYoWoTk5AQMGS
 1WCUCf+9fhASryKPdJZ31MbLA+MAMveYDiq9duLYRHOjuUPdQGvNb7LxJjJiTMDAdKFB Zw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34k28jdy41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 05:25:54 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3ANLSM003723;
        Tue, 3 Nov 2020 10:25:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 34jbytrpx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 10:25:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3APn7Z62390596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 10:25:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 581A1A405C;
        Tue,  3 Nov 2020 10:25:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21361A405B;
        Tue,  3 Nov 2020 10:25:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 10:25:49 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v2 10/15] net/smc: Introduce SMCR get link command
Date:   Tue,  3 Nov 2020 11:25:26 +0100
Message-Id: <20201103102531.91710-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103102531.91710-1-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_07:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011030065
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

