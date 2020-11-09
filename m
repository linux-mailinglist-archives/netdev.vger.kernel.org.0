Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57402ABF9E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbgKIPSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:18:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31686 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731993AbgKIPSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:18:31 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9FB7FI128276;
        Mon, 9 Nov 2020 10:18:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=97cBD32hnJvqyXXx64MBQ2WBvIPG9h80XRQjtMAS/VQ=;
 b=rM+cbr0YTw7x5X+enfciLi+BAKUN5cWsxk1IOF6szd4EumV+DTRC1M/qngTxKq5eqKU4
 bzQjjtu/wZKw4ow3HpMAeg6+UIPRL/as8K3GIRRlnrXHp6mQ9BAXxx1Ev3mI+Vfoeqq3
 0pJ6DkiVxNCBvxsmyu4fhR5tf/6flP1mjUvEZFFPbRUz/Oaop0K6yJrXFoRmHNiBu5/t
 XUtwEGnqu6Xae3LkCHYfRSQAXexsMXpRA45qCDWuDKz+Td+/hX8YBPYP6wSDIzsCVIlE
 cY9TRONJR/rw0BWbMT822Puqzgof9JO7TqiMgbf7+Vc5Gj5Lq309GT63+RW9jyuae5oM bw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34q58y5vd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 10:18:28 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A9FE7Rf022266;
        Mon, 9 Nov 2020 15:18:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 34p26phk3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 15:18:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A9FILQv27460094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 15:18:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7240EA405C;
        Mon,  9 Nov 2020 15:18:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 442EEA4069;
        Mon,  9 Nov 2020 15:18:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 15:18:21 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v4 11/15] net/smc: Add SMC-D Linkgroup diagnostic support
Date:   Mon,  9 Nov 2020 16:18:10 +0100
Message-Id: <20201109151814.15040-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201109151814.15040-1-kgraul@linux.ibm.com>
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_08:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=1 malwarescore=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Deliver SMCD Linkgroup information via netlink based
diagnostic interface.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc_diag.h |   7 +++
 net/smc/smc_core.c            |   7 +++
 net/smc/smc_core.h            |   2 +
 net/smc/smc_diag.c            | 108 ++++++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+)

diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index a57df0296aa4..5a80172df757 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -81,6 +81,7 @@ enum {
 enum {
 	SMC_DIAG_LGR_INFO_SMCR = 1,
 	SMC_DIAG_LGR_INFO_SMCR_LINK,
+	SMC_DIAG_LGR_INFO_SMCD,
 };
 
 #define SMC_DIAG_MAX (__SMC_DIAG_MAX - 1)
@@ -155,6 +156,12 @@ struct smcd_diag_dmbinfo {		/* SMC-D Socket internals */
 	__aligned_u64	my_gid;		/* My GID */
 	__aligned_u64	token;		/* Token of DMB */
 	__aligned_u64	peer_token;	/* Token of remote DMBE */
+	/* Fields above used by legacy v1 code */
+	__u8		pnet_id[SMC_MAX_PNETID_LEN]; /* Pnet ID */
+	__u32		conns_num;	/* Number of connections */
+	__u16		chid;		/* Linkgroup CHID */
+	__u8		vlan_id;	/* Linkgroup vlan id */
+	struct smc_diag_v2_lgr_info v2_lgr_info; /* SMCv2 info */
 };
 
 struct smc_diag_lgr {
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2dcb1208f55e..37cc754485f0 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -214,6 +214,11 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
 	conn->lgr = NULL;
 }
 
+static struct smcd_dev_list *smc_get_smcd_dev_list(void)
+{
+	return &smcd_dev_list;
+}
+
 static struct smc_lgr_list *smc_get_lgr_list(void)
 {
 	return &smc_lgr_list;
@@ -221,6 +226,8 @@ static struct smc_lgr_list *smc_get_lgr_list(void)
 
 static const struct smc_diag_ops smc_diag_ops = {
 	.get_lgr_list		= smc_get_lgr_list,
+	.get_smcd_devices	= smc_get_smcd_dev_list,
+	.get_chid		= smc_ism_get_chid,
 };
 
 const struct smc_diag_ops *smc_get_diag_ops(void)
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 09ff2011dd78..fb1f63f5e681 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -23,6 +23,8 @@
 /* Functions which are needed for diagnostic purposes by smc_diag module */
 struct smc_diag_ops {
 	struct smc_lgr_list *(*get_lgr_list)(void);
+	struct smcd_dev_list *(*get_smcd_devices)(void);
+	u16 (*get_chid)(struct smcd_dev *smcd);
 };
 
 struct smc_lgr_list {			/* list of link group definition */
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 9a41548d6263..a644e2299dbc 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -21,6 +21,7 @@
 
 #include "smc.h"
 #include "smc_ib.h"
+#include "smc_ism.h"
 #include "smc_core.h"
 
 static const struct smc_diag_ops *smc_diag_ops;
@@ -254,6 +255,53 @@ static int smc_diag_fill_lgr_link(struct smc_link_group *lgr,
 	return -EMSGSIZE;
 }
 
+static int smc_diag_fill_smcd_lgr(struct smc_link_group *lgr,
+				  struct sk_buff *skb,
+				  struct netlink_callback *cb,
+				  struct smc_diag_req_v2 *req)
+{
+	struct smcd_diag_dmbinfo smcd_lgr;
+	struct nlmsghdr *nlh;
+	int dummy = 0;
+	int rc = 0;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, MAGIC_SEQ_V2_ACK,
+			cb->nlh->nlmsg_type, 0, NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	memset(&smcd_lgr, 0, sizeof(smcd_lgr));
+	memcpy(&smcd_lgr.linkid, lgr->id, sizeof(lgr->id));
+	smcd_lgr.conns_num = lgr->conns_num;
+	smcd_lgr.vlan_id = lgr->vlan_id;
+	smcd_lgr.peer_gid = lgr->peer_gid;
+	smcd_lgr.my_gid = lgr->smcd->local_gid;
+	smcd_lgr.chid = smc_diag_ops->get_chid(lgr->smcd);
+	memcpy(&smcd_lgr.v2_lgr_info.negotiated_eid, lgr->negotiated_eid,
+	       sizeof(smcd_lgr.v2_lgr_info.negotiated_eid));
+	memcpy(&smcd_lgr.v2_lgr_info.peer_hostname, lgr->peer_hostname,
+	       sizeof(smcd_lgr.v2_lgr_info.peer_hostname));
+	smcd_lgr.v2_lgr_info.peer_os = lgr->peer_os;
+	smcd_lgr.v2_lgr_info.peer_smc_release = lgr->peer_smc_release;
+	smcd_lgr.v2_lgr_info.smc_version = lgr->smc_version;
+	snprintf(smcd_lgr.pnet_id, sizeof(smcd_lgr.pnet_id), "%s",
+		 lgr->smcd->pnetid);
+
+	/* Just a command place holder to signal back the command reply type */
+	if (nla_put(skb, SMC_DIAG_GET_LGR_INFO, sizeof(dummy), &dummy) < 0)
+		goto errout;
+
+	if (nla_put(skb, SMC_DIAG_LGR_INFO_SMCD,
+		    sizeof(smcd_lgr), &smcd_lgr) < 0)
+		goto errout;
+
+	nlmsg_end(skb, nlh);
+	return rc;
+errout:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
 static int smc_diag_fill_lgr(struct smc_link_group *lgr,
 			     struct sk_buff *skb,
 			     struct netlink_callback *cb,
@@ -345,6 +393,63 @@ static int smc_diag_fill_lgr_list(struct smc_lgr_list *smc_lgr,
 	return rc;
 }
 
+static int smc_diag_handle_smcd_lgr(struct smcd_dev *dev,
+				    struct sk_buff *skb,
+				    struct netlink_callback *cb,
+				    struct smc_diag_req_v2 *req)
+{
+	struct smc_diag_dump_ctx *cb_ctx = smc_dump_context(cb);
+	struct smc_link_group *lgr;
+	int snum = cb_ctx->pos[1];
+	int rc = 0, num = 0;
+
+	spin_lock_bh(&dev->lgr_lock);
+	list_for_each_entry(lgr, &dev->lgr_list, list) {
+		if (!lgr->is_smcd)
+			continue;
+		if (num < snum)
+			goto next;
+		rc = smc_diag_fill_smcd_lgr(lgr, skb, cb, req);
+		if (rc < 0)
+			goto errout;
+next:
+		num++;
+	}
+errout:
+	spin_unlock_bh(&dev->lgr_lock);
+	cb_ctx->pos[1] = num;
+	return rc;
+}
+
+static int smc_diag_fill_smcd_dev(struct smcd_dev_list *dev_list,
+				  struct sk_buff *skb,
+				  struct netlink_callback *cb,
+				  struct smc_diag_req_v2 *req)
+{
+	struct smc_diag_dump_ctx *cb_ctx = smc_dump_context(cb);
+	struct smcd_dev *smcd_dev;
+	int snum = cb_ctx->pos[0];
+	int rc = 0, num = 0;
+
+	mutex_lock(&dev_list->mutex);
+	list_for_each_entry(smcd_dev, &dev_list->list, list) {
+		if (list_empty(&smcd_dev->lgr_list))
+			continue;
+		if (num < snum)
+			goto next;
+		rc = smc_diag_handle_smcd_lgr(smcd_dev, skb,
+					      cb, req);
+		if (rc < 0)
+			goto errout;
+next:
+		num++;
+	}
+errout:
+	mutex_unlock(&dev_list->mutex);
+	cb_ctx->pos[0] = num;
+	return rc;
+}
+
 static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 			   struct netlink_callback *cb,
 			   const struct smc_diag_req *req)
@@ -443,6 +548,9 @@ static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
 		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCR - 1))))
 			smc_diag_fill_lgr_list(smc_diag_ops->get_lgr_list(),
 					       skb, cb, req);
+		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCD - 1))))
+			smc_diag_fill_smcd_dev(smc_diag_ops->get_smcd_devices(),
+					       skb, cb, req);
 	}
 
 	return skb->len;
-- 
2.17.1

