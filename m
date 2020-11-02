Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B942A3460
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgKBTjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:39:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726255AbgKBTjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 14:39:45 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2Jb03O065542;
        Mon, 2 Nov 2020 14:39:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=znCsibijSyN6xwhcPdz9dziV+vdgXDEUZzxf+0JE6qA=;
 b=qJPRbVEKFXOv2n2VV5hcSQhWqlrWQx4/t3LWomCsUbMMOP0OFufzbgdo4IFFoj5ilEhG
 XA0/kJJfSUCxg84TcbIgy398M5c1O21UDR3o2YipgX7osc01tPnpfNXkCyVrHvoA+6TG
 cnKHLeurYU0T2vXTLyAEKKghvQPE0r7eAm8MMDmdNRqxHHKYRqEwTCrAxO2mSeJ4YuLY
 2O2Q5doz+zQiUr0ejRk6UvWHAflfj4F/fQ0nTO51wUE+awykRGot5CmKoylGppMWd9CZ
 0iDhXlmp0ka/mQK3DOIUi3P8EzuQxP+rh6WTBMB1wSh09wdxMcI9d+lNH7AINTVbGH+R Lg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34hn6ge7xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 14:39:40 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JXHYV023501;
        Mon, 2 Nov 2020 19:34:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 34j6j40fbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 19:34:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2JYShm61473076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Nov 2020 19:34:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7554C4C040;
        Mon,  2 Nov 2020 19:34:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4390D4C046;
        Mon,  2 Nov 2020 19:34:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 19:34:28 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next 11/15] net/smc: Add SMC-D Linkgroup diagnostic support
Date:   Mon,  2 Nov 2020 20:34:05 +0100
Message-Id: <20201102193409.70901-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201102193409.70901-1-kgraul@linux.ibm.com>
References: <20201102193409.70901-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_13:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 clxscore=1015
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020145
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
 net/smc/smc_diag.c            | 108 ++++++++++++++++++++++++++++++++++
 net/smc/smc_ism.c             |   2 +
 3 files changed, 117 insertions(+)

diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 16b8ea9da3d5..ee9668917aa7 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -80,6 +80,7 @@ enum {
 enum {
 	SMC_DIAG_LGR_INFO_SMCR = 1,
 	SMC_DIAG_LGR_INFO_SMCR_LINK,
+	SMC_DIAG_LGR_INFO_SMCD,
 };
 
 #define SMC_DIAG_MAX (__SMC_DIAG_MAX - 1)
@@ -154,6 +155,12 @@ struct smcd_diag_dmbinfo {		/* SMC-D Socket internals */
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
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 6885814b6e4f..fcff07a9ea47 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -21,6 +21,7 @@
 
 #include "smc.h"
 #include "smc_ib.h"
+#include "smc_ism.h"
 #include "smc_core.h"
 
 struct smc_diag_dump_ctx {
@@ -252,6 +253,53 @@ static int smc_diag_fill_lgr_link(struct smc_link_group *lgr,
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
+	smcd_lgr.chid = smc_ism_get_chid(lgr->smcd);
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
@@ -343,6 +391,63 @@ static int smc_diag_fill_lgr_list(struct smc_lgr_list *smc_lgr,
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
+		if (lgr->is_smcd) {
+			if (num < snum)
+				goto next;
+			rc = smc_diag_fill_smcd_lgr(lgr, skb, cb, req);
+			if (rc < 0)
+				goto errout;
+next:
+			num++;
+		}
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
+		if (!list_empty(&smcd_dev->lgr_list)) {
+			if (num < snum)
+				goto next;
+			rc = smc_diag_handle_smcd_lgr(smcd_dev, skb,
+						      cb, req);
+			if (rc < 0)
+				goto errout;
+next:
+			num++;
+		}
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
@@ -441,6 +546,9 @@ static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
 		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCR - 1))))
 			smc_diag_fill_lgr_list(&smc_lgr_list, skb, cb,
 					       req);
+		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCD - 1))))
+			smc_diag_fill_smcd_dev(&smcd_dev_list, skb, cb,
+					       req);
 	}
 
 	return skb->len;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 6abbdd09a580..5bb2c7fb4ea8 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -20,6 +20,7 @@ struct smcd_dev_list smcd_dev_list = {
 	.list = LIST_HEAD_INIT(smcd_dev_list.list),
 	.mutex = __MUTEX_INITIALIZER(smcd_dev_list.mutex)
 };
+EXPORT_SYMBOL_GPL(smcd_dev_list);
 
 bool smc_ism_v2_capable;
 
@@ -50,6 +51,7 @@ u16 smc_ism_get_chid(struct smcd_dev *smcd)
 {
 	return smcd->ops->get_chid(smcd);
 }
+EXPORT_SYMBOL_GPL(smc_ism_get_chid);
 
 /* Set a connection using this DMBE. */
 void smc_ism_set_conn(struct smc_connection *conn)
-- 
2.17.1

