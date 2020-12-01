Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAA32CABB9
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404300AbgLATVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392326AbgLATVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:46 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J2fu3181442;
        Tue, 1 Dec 2020 14:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=bconCPV9RRrUItp/TZ3pnTOaYO1O6AxjjggOSI0n61o=;
 b=YihFPH8xVp3iuwhuNPiesaTwzy0EWIYD4aj5/kv3UqMNWdxAxtcnr3K9L2hXyD5o9UbO
 13QAzl9OOhVyx5wl9OzgWTLlO/jcbL6uzHeOy/9uQlq824GFzfdTVeZLgbzl0qKL4n8O
 6FpH8ge43xDqRqwBDj2ashQAWBYCEdB4Bju6vl6GSTqW810qqBXHjbWXKDIK5XFQz1k7
 lu8jbo+KSKytvbnshEsOKElq5U92bTbHmf6EfxaRaVUc/+XdZNpKZYvQROcB5CWBzE9y
 C5qnp91yN+yzNid+G1/RkAV71AMTQo7HOEUDX52FuMRaZF7oHcpM7WrOzHfKWcIxc4f4 lQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355gtby9ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:04 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JI9l0018316;
        Tue, 1 Dec 2020 19:21:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 353e683ety-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:21:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKxGQ24641820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0762DAE058;
        Tue,  1 Dec 2020 19:20:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1B84AE053;
        Tue,  1 Dec 2020 19:20:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:58 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 12/14] net/smc: Add SMC-D Linkgroup diagnostic support
Date:   Tue,  1 Dec 2020 20:20:47 +0100
Message-Id: <20201201192049.53517-13-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Deliver SMCD Linkgroup information via netlink based
diagnostic interface.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h |  27 ++++++++
 net/smc/smc_core.c       | 130 +++++++++++++++++++++++++++++++++++++++
 net/smc/smc_core.h       |   1 +
 net/smc/smc_netlink.c    |   5 ++
 4 files changed, 163 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index ed638dbfff08..707e8af4f0c8 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -42,6 +42,7 @@ enum {
 	SMC_NETLINK_GET_SYS_INFO = 1,
 	SMC_NETLINK_GET_LGR_SMCR,
 	SMC_NETLINK_GET_LINK_SMCR,
+	SMC_NETLINK_GET_LGR_SMCD,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -50,6 +51,7 @@ enum {
 	SMC_GEN_SYS_INFO,		/* nest */
 	SMC_GEN_LGR_SMCR,		/* nest */
 	SMC_GEN_LINK_SMCR,		/* nest */
+	SMC_GEN_LGR_SMCD,		/* nest */
 	__SMC_GEN_MAX,
 	SMC_GEN_MAX = __SMC_GEN_MAX - 1
 };
@@ -66,6 +68,15 @@ enum {
 	SMC_NLA_SYS_MAX = __SMC_NLA_SYS_MAX - 1
 };
 
+/* SMC_NLA_LGR_V2 nested attributes */
+enum {
+	SMC_NLA_LGR_V2_VER,		/* u8 */
+	SMC_NLA_LGR_V2_REL,		/* u8 */
+	SMC_NLA_LGR_V2_OS,		/* u8 */
+	SMC_NLA_LGR_V2_NEG_EID,		/* string */
+	SMC_NLA_LGR_V2_PEER_HOST,	/* string */
+};
+
 /* SMC_GEN_LGR_SMCR attributes */
 enum {
 	SMC_NLA_LGR_R_UNSPEC,
@@ -95,4 +106,20 @@ enum {
 	__SMC_NLA_LINK_MAX,
 	SMC_NLA_LINK_MAX = __SMC_NLA_LINK_MAX - 1
 };
+
+/* SMC_GEN_LGR_SMCD attributes */
+enum {
+	SMC_NLA_LGR_D_UNSPEC,
+	SMC_NLA_LGR_D_ID,		/* u32 */
+	SMC_NLA_LGR_D_GID,		/* u64 */
+	SMC_NLA_LGR_D_PEER_GID,		/* u64 */
+	SMC_NLA_LGR_D_VLAN_ID,		/* u8 */
+	SMC_NLA_LGR_D_CONNS_NUM,	/* u32 */
+	SMC_NLA_LGR_D_PNETID,		/* string */
+	SMC_NLA_LGR_D_CHID,		/* u16 */
+	SMC_NLA_LGR_D_PAD,		/* flag */
+	SMC_NLA_LGR_V2,			/* nest */
+	__SMC_NLA_LGR_D_MAX,
+	SMC_NLA_LGR_D_MAX = __SMC_NLA_LGR_D_MAX - 1
+};
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 5ad4b742dcc1..ac2cc593f25f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -426,6 +426,130 @@ static void smc_nl_fill_lgr_list(struct smc_lgr_list *smc_lgr,
 	cb_ctx->pos[0] = num;
 }
 
+static int smc_nl_fill_smcd_lgr(struct smc_link_group *lgr,
+				struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	char smc_host[SMC_MAX_HOSTNAME_LEN + 1];
+	char smc_pnet[SMC_MAX_PNETID_LEN + 1];
+	char smc_eid[SMC_MAX_EID_LEN + 1];
+	struct nlattr *v2_attrs;
+	struct nlattr *attrs;
+	void *nlh;
+
+	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_GET_LGR_SMCD);
+	if (!nlh)
+		goto errmsg;
+
+	attrs = nla_nest_start(skb, SMC_GEN_LGR_SMCD);
+	if (!attrs)
+		goto errout;
+
+	if (nla_put_u32(skb, SMC_NLA_LGR_D_ID, *((u32 *)&lgr->id)))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_D_GID, lgr->smcd->local_gid,
+			      SMC_NLA_LGR_D_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_D_PEER_GID, lgr->peer_gid,
+			      SMC_NLA_LGR_D_PAD))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_D_VLAN_ID, lgr->vlan_id))
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_LGR_D_CONNS_NUM, lgr->conns_num))
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_LGR_D_CHID, smc_ism_get_chid(lgr->smcd)))
+		goto errattr;
+	snprintf(smc_pnet, sizeof(smc_pnet), "%s", lgr->smcd->pnetid);
+	if (nla_put_string(skb, SMC_NLA_LGR_D_PNETID, smc_pnet))
+		goto errattr;
+
+	v2_attrs = nla_nest_start(skb, SMC_NLA_LGR_V2);
+	if (!v2_attrs)
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_VER, lgr->smc_version))
+		goto errv2attr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_REL, lgr->peer_smc_release))
+		goto errv2attr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_OS, lgr->peer_os))
+		goto errv2attr;
+	snprintf(smc_host, sizeof(smc_host), "%s", lgr->peer_hostname);
+	if (nla_put_string(skb, SMC_NLA_LGR_V2_PEER_HOST, smc_host))
+		goto errv2attr;
+	snprintf(smc_eid, sizeof(smc_eid), "%s", lgr->negotiated_eid);
+	if (nla_put_string(skb, SMC_NLA_LGR_V2_NEG_EID, smc_eid))
+		goto errv2attr;
+
+	nla_nest_end(skb, v2_attrs);
+	nla_nest_end(skb, attrs);
+	genlmsg_end(skb, nlh);
+	return 0;
+
+errv2attr:
+	nla_nest_cancel(skb, v2_attrs);
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	genlmsg_cancel(skb, nlh);
+errmsg:
+	return -EMSGSIZE;
+}
+
+static int smc_nl_handle_smcd_lgr(struct smcd_dev *dev,
+				  struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
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
+		rc = smc_nl_fill_smcd_lgr(lgr, skb, cb);
+		if (rc)
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
+static int smc_nl_fill_smcd_dev(struct smcd_dev_list *dev_list,
+				struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
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
+		rc = smc_nl_handle_smcd_lgr(smcd_dev, skb, cb);
+		if (rc)
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
 int smcr_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	bool list_links = false;
@@ -442,6 +566,12 @@ int smcr_nl_get_link(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+int smcd_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	smc_nl_fill_smcd_dev(&smcd_dev_list, skb, cb);
+	return skb->len;
+}
+
 void smc_lgr_cleanup_early(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr = conn->lgr;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 7995621f318d..0b6899a7f634 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -430,6 +430,7 @@ void smcr_link_down_cond_sched(struct smc_link *lnk);
 int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb);
 int smcr_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb);
 int smcr_nl_get_link(struct sk_buff *skb, struct netlink_callback *cb);
+int smcd_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb);
 
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index a41f78f488a2..95bce936534f 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -38,6 +38,11 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		/* can be retrieved by unprivileged users */
 		.dumpit = smcr_nl_get_link,
 	},
+	{
+		.cmd = SMC_NETLINK_GET_LGR_SMCD,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smcd_nl_get_lgr,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
-- 
2.17.1

