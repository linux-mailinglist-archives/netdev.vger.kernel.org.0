Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B9C2A342B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgKBTem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:34:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726736AbgKBTef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 14:34:35 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JY50B078406;
        Mon, 2 Nov 2020 14:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=+9D/2dbfz+K+IyquYBm1urUabxb9Fx3BHi98vul+dNo=;
 b=pQCkaJenr8CuN9zbmzXymsHHHrRPaKkR2MgFl6T4xlwmouuuHRZbJDzJU4J/N7LE/DSt
 UOxB7Pqw0dto4uFt/auIyfY12GzBPIOERQ1p5sGagHW552sFQj4lIMlwrLdx9XP4T0UQ
 +PKJkxAflNFHOErHOhtSUiFMJzllYy42GoLtbtvJ4tKz2NPR8KSP5CIjbnKcKheGOBs7
 EpNdbGRgOfVFwsr++/PVG8rnyf2RZwLC4Tw49i2RiQzYDR7FjBLXrDWUQa6gucu4hnsE
 CS8YnlyqOv9KXBw/nX23/67eC3BDb3eM6qWt3HPAtX3dQfAWMwdQgdHunCaji+8r3fK9 jg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34jpkq35a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 14:34:32 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JXvOc021058;
        Mon, 2 Nov 2020 19:34:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 34h01qs8cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 19:34:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2JYSNG58458490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Nov 2020 19:34:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFA4C4C040;
        Mon,  2 Nov 2020 19:34:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B94464C046;
        Mon,  2 Nov 2020 19:34:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 19:34:27 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next 09/15] net/smc: Introduce SMCR get linkgroup command
Date:   Mon,  2 Nov 2020 20:34:03 +0100
Message-Id: <20201102193409.70901-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201102193409.70901-1-kgraul@linux.ibm.com>
References: <20201102193409.70901-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_13:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 suspectscore=3 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Introduce get linkgroup command which loops through
all available SMCR linkgroups. It uses the SMC-R linkgroup
list as entry point, not the socket list, which makes
linkgroup diagnosis possible, in case linkgroup does not
contain active connections anymore.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/net/smc.h             |  2 +-
 include/uapi/linux/smc.h      |  5 ++
 include/uapi/linux/smc_diag.h | 43 +++++++++++++++++
 net/smc/smc.h                 |  5 +-
 net/smc/smc_core.c            |  3 +-
 net/smc/smc_core.h            |  1 -
 net/smc/smc_diag.c            | 88 +++++++++++++++++++++++++++++++++++
 7 files changed, 141 insertions(+), 6 deletions(-)

diff --git a/include/net/smc.h b/include/net/smc.h
index e441aa97ad61..59d25dcb8e92 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -10,8 +10,8 @@
  */
 #ifndef _SMC_H
 #define _SMC_H
+#include <linux/smc.h>
 
-#define SMC_MAX_PNETID_LEN	16	/* Max. length of PNET id */
 
 struct smc_hashinfo {
 	rwlock_t lock;
diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 0e11ca421ca4..635e2c2aeac5 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -3,6 +3,7 @@
  *  Shared Memory Communications over RDMA (SMC-R) and RoCE
  *
  *  Definitions for generic netlink based configuration of an SMC-R PNET table
+ *  Definitions for SMC Linkgroup and Devices.
  *
  *  Copyright IBM Corp. 2016
  *
@@ -33,4 +34,8 @@ enum {				/* SMC PNET Table commands */
 #define SMCR_GENL_FAMILY_NAME		"SMC_PNETID"
 #define SMCR_GENL_FAMILY_VERSION	1
 
+#define SMC_MAX_PNETID_LEN		16 /* Max. length of PNET id */
+#define SMC_LGR_ID_SIZE			4
+#define SMC_MAX_HOSTNAME_LEN		32 /* Max length of hostname */
+#define SMC_MAX_EID_LEN			32 /* Max length of eid */
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 236c1c52d562..6ae028344b6d 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -4,8 +4,10 @@
 
 #include <linux/types.h>
 #include <linux/inet_diag.h>
+#include <linux/smc.h>
 #include <rdma/ib_user_verbs.h>
 
+#define SMC_DIAG_EXTS_PER_CMD 16
 /* Sequence numbers */
 enum {
 	MAGIC_SEQ = 123456,
@@ -21,6 +23,17 @@ struct smc_diag_req {
 	struct inet_diag_sockid	id;
 };
 
+/* Request structure v2 */
+struct smc_diag_req_v2 {
+	__u8	diag_family;
+	__u8	pad[2];
+	__u8	diag_ext;		/* Query extended information */
+	struct inet_diag_sockid	id;
+	__u32	cmd;
+	__u32	cmd_ext;
+	__u8	cmd_val[8];
+};
+
 /* Base info structure. It contains socket identity (addrs/ports/cookie) based
  * on the internal clcsock, and more SMC-related socket data
  */
@@ -57,7 +70,19 @@ enum {
 	__SMC_DIAG_MAX,
 };
 
+/* V2 Commands */
+enum {
+	SMC_DIAG_GET_LGR_INFO = SMC_DIAG_EXTS_PER_CMD,
+	__SMC_DIAG_EXT_MAX,
+};
+
+/* SMC_DIAG_GET_LGR_INFO command extensions */
+enum {
+	SMC_DIAG_LGR_INFO_SMCR = 1,
+};
+
 #define SMC_DIAG_MAX (__SMC_DIAG_MAX - 1)
+#define SMC_DIAG_EXT_MAX (__SMC_DIAG_EXT_MAX - 1)
 
 /* SMC_DIAG_CONNINFO */
 
@@ -88,6 +113,14 @@ struct smc_diag_conninfo {
 	struct smc_diag_cursor	tx_fin;		/* confirmed sent cursor */
 };
 
+struct smc_diag_v2_lgr_info {
+	__u8		smc_version;		/* SMC Version */
+	__u8		peer_smc_release;	/* Peer SMC Version */
+	__u8		peer_os;		/* Peer operating system */
+	__u8		negotiated_eid[SMC_MAX_EID_LEN]; /* Negotiated EID */
+	__u8		peer_hostname[SMC_MAX_HOSTNAME_LEN]; /* Peer host */
+};
+
 /* SMC_DIAG_LINKINFO */
 
 struct smc_diag_linkinfo {
@@ -116,4 +149,14 @@ struct smcd_diag_dmbinfo {		/* SMC-D Socket internals */
 	__aligned_u64	peer_token;	/* Token of remote DMBE */
 };
 
+struct smc_diag_lgr {
+	__u8		lgr_id[SMC_LGR_ID_SIZE]; /* Linkgroup identifier */
+	__u8		lgr_role;		/* Linkgroup role */
+	__u8		lgr_type;		/* Linkgroup type */
+	__u8		pnet_id[SMC_MAX_PNETID_LEN]; /* Linkgroup pnet id */
+	__u8		vlan_id;		/* Linkgroup vland id */
+	__u32		conns_num;		/* Number of connections */
+	__u8		reserved;		/* Reserved for future use */
+	struct smc_diag_v2_lgr_info v2_lgr_info; /* SMCv2 info */
+};
 #endif /* _UAPI_SMC_DIAG_H_ */
diff --git a/net/smc/smc.h b/net/smc/smc.h
index d65e15f0c944..447cf9be979d 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -14,6 +14,7 @@
 #include <linux/socket.h>
 #include <linux/types.h>
 #include <linux/compiler.h> /* __aligned */
+#include <uapi/linux/smc.h>
 #include <net/sock.h>
 
 #include "smc_ib.h"
@@ -29,11 +30,9 @@
 					 * devices
 					 */
 
-#define SMC_MAX_HOSTNAME_LEN	32
-#define SMC_MAX_EID_LEN		32
-
 extern struct proto smc_proto;
 extern struct proto smc_proto6;
+extern struct smc_lgr_list smc_lgr_list;
 
 #ifdef ATOMIC64_INIT
 #define KERNEL_HAS_ATOMIC64
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 28fc583d9033..56d97f6c866c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -35,11 +35,12 @@
 #define SMC_LGR_FREE_DELAY_SERV		(600 * HZ)
 #define SMC_LGR_FREE_DELAY_CLNT		(SMC_LGR_FREE_DELAY_SERV + 10 * HZ)
 
-static struct smc_lgr_list smc_lgr_list = {	/* established link groups */
+struct smc_lgr_list smc_lgr_list = {	/* established link groups */
 	.lock = __SPIN_LOCK_UNLOCKED(smc_lgr_list.lock),
 	.list = LIST_HEAD_INIT(smc_lgr_list.list),
 	.num = 0,
 };
+EXPORT_SYMBOL_GPL(smc_lgr_list);
 
 static atomic_t lgr_cnt = ATOMIC_INIT(0); /* number of existing link groups */
 static DECLARE_WAIT_QUEUE_HEAD(lgrs_deleted);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index bd16d63c5222..639c7565b302 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -70,7 +70,6 @@ struct smc_rdma_wr {				/* work requests per message
 	struct ib_rdma_wr	wr_tx_rdma[SMC_MAX_RDMA_WRITES];
 };
 
-#define SMC_LGR_ID_SIZE		4
 
 struct smc_link {
 	struct smc_ib_device	*smcibdev;	/* ib-device */
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index bc2b616524ff..c53904b3f350 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -203,6 +203,86 @@ static bool smc_diag_fill_dmbinfo(struct sock *sk, struct sk_buff *skb)
 	return true;
 }
 
+static int smc_diag_fill_lgr(struct smc_link_group *lgr,
+			     struct sk_buff *skb,
+			     struct netlink_callback *cb,
+			     struct smc_diag_req_v2 *req)
+{
+	struct smc_diag_lgr lgr_link;
+	int dummy = 0;
+	int rc = 0;
+
+	memset(&lgr_link, 0, sizeof(lgr_link));
+	memcpy(&lgr_link.lgr_id, lgr->id, sizeof(lgr->id));
+	lgr_link.lgr_role = lgr->role;
+	lgr_link.lgr_type = lgr->type;
+	lgr_link.conns_num = lgr->conns_num;
+	lgr_link.vlan_id = lgr->vlan_id;
+	memcpy(lgr_link.pnet_id, lgr->pnet_id, sizeof(lgr_link.pnet_id));
+
+	/* Just a command place holder to signal back the command reply type */
+	if (nla_put(skb, SMC_DIAG_GET_LGR_INFO, sizeof(dummy), &dummy) < 0)
+		goto errout;
+	if (nla_put(skb, SMC_DIAG_LGR_INFO_SMCR,
+		    sizeof(lgr_link), &lgr_link) < 0)
+		goto errout;
+
+	return rc;
+errout:
+	return -EMSGSIZE;
+}
+
+static int smc_diag_handle_lgr(struct smc_link_group *lgr,
+			       struct sk_buff *skb,
+			       struct netlink_callback *cb,
+			       struct smc_diag_req_v2 *req)
+{
+	struct nlmsghdr *nlh;
+	int rc = 0;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, MAGIC_SEQ_V2_ACK,
+			cb->nlh->nlmsg_type, 0, NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	rc = smc_diag_fill_lgr(lgr, skb, cb, req);
+	if (rc < 0)
+		goto errout;
+
+	nlmsg_end(skb, nlh);
+	return rc;
+
+errout:
+	nlmsg_cancel(skb, nlh);
+	return rc;
+}
+
+static int smc_diag_fill_lgr_list(struct smc_lgr_list *smc_lgr,
+				  struct sk_buff *skb,
+				  struct netlink_callback *cb,
+				  struct smc_diag_req_v2 *req)
+{
+	struct smc_diag_dump_ctx *cb_ctx = smc_dump_context(cb);
+	struct smc_link_group *lgr;
+	int snum = cb_ctx->pos[0];
+	int rc = 0, num = 0;
+
+	spin_lock_bh(&smc_lgr->lock);
+	list_for_each_entry(lgr, &smc_lgr->list, list) {
+		if (num < snum)
+			goto next;
+		rc = smc_diag_handle_lgr(lgr, skb, cb, req);
+		if (rc < 0)
+			goto errout;
+next:
+		num++;
+	}
+errout:
+	spin_unlock_bh(&smc_lgr->lock);
+	cb_ctx->pos[0] = num;
+	return rc;
+}
+
 static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 			   struct netlink_callback *cb,
 			   const struct smc_diag_req *req)
@@ -295,6 +375,14 @@ static int smc_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct smc_diag_req_v2 *req = nlmsg_data(cb->nlh);
+
+	if (req->cmd == SMC_DIAG_GET_LGR_INFO) {
+		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCR - 1))))
+			smc_diag_fill_lgr_list(&smc_lgr_list, skb, cb,
+					       req);
+	}
+
 	return skb->len;
 }
 
-- 
2.17.1

