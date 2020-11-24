Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98C22C2F3E
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404119AbgKXRvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:51:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404100AbgKXRvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:51:16 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHWD9i017548;
        Tue, 24 Nov 2020 12:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=q9KtjIXusxppd4AWfAc/6FBH7lQiRA4vwXP4znNfc+g=;
 b=icukZ+3gBg+p87c7eTbfEnvDI1zbkK8UPVzxNptgKsyJ9yZjiyPIwaRt9WUaQTvC4nWD
 WpPQrzuCGnwXqy1iKdEvvvMNGpHkdLhlO+ntxakqO0vZRue9+1299+/mKyXt9kVJu1Oa
 bg0Rv7UJ0HfXMxykANAFu64Bv0IHEE8xZD8aZXKyP7lcc4raBmIv4SwTjuAKpQs7SopI
 Qs45qiWxFdSwhc5RXBUVCeUCmskHl6JMEh5ay0BBXfcgTGESSNi3+VhynDVWrtlIMoE/
 2SAKOZBa0cXeZMrbZAJis8gdGrpmABAAZru+fum6MF7dKHBT98ve5EakDMbyVxghlYwc Hw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 350rn9n4jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:51:11 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHiXun025744;
        Tue, 24 Nov 2020 17:51:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 34xth89yxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:51:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHp6aA30146990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:51:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAC79A4072;
        Tue, 24 Nov 2020 17:51:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73C7BA407C;
        Tue, 24 Nov 2020 17:51:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:51:06 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v5 12/14] net/smc: Add SMC-D Linkgroup diagnostic support
Date:   Tue, 24 Nov 2020 18:50:45 +0100
Message-Id: <20201124175047.56949-13-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201124175047.56949-1-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240104
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
 net/smc/smc_core.c       | 133 +++++++++++++++++++++++++++++++++++++++
 net/smc/smc_core.h       |   1 +
 net/smc/smc_netlink.c    |   8 +++
 4 files changed, 169 insertions(+)

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
index 1273fb29c365..3cb9514fa406 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -431,6 +431,133 @@ static void smc_nl_fill_lgr_list(struct smc_lgr_list *smc_lgr,
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
+		return -EMSGSIZE;
+
+	attrs = nla_nest_start_noflag(skb, SMC_GEN_LGR_SMCD);
+	if (!attrs)
+		goto errout;
+
+	if (nla_put_u32(skb, SMC_NLA_LGR_D_ID, *((u32 *)&lgr->id)) < 0)
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_D_GID, lgr->smcd->local_gid,
+			      SMC_NLA_LGR_D_PAD) < 0)
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_D_PEER_GID, lgr->peer_gid,
+			      SMC_NLA_LGR_D_PAD) < 0)
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_D_VLAN_ID, lgr->vlan_id) < 0)
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_LGR_D_CONNS_NUM, lgr->conns_num) < 0)
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_LGR_D_CHID,
+			smc_ism_get_chid(lgr->smcd)) < 0)
+		goto errattr;
+	memset(smc_pnet, 0, sizeof(smc_pnet));
+	snprintf(smc_pnet, sizeof(smc_pnet), "%s", lgr->smcd->pnetid);
+	if (nla_put_string(skb, SMC_NLA_LGR_D_PNETID, smc_pnet) < 0)
+		goto errattr;
+
+	v2_attrs = nla_nest_start_noflag(skb, SMC_NLA_LGR_V2);
+	if (!v2_attrs)
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_VER, lgr->smc_version) < 0)
+		goto errv2attr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_REL, lgr->peer_smc_release) < 0)
+		goto errv2attr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_OS, lgr->peer_os) < 0)
+		goto errv2attr;
+	memset(smc_host, 0, sizeof(smc_host));
+	snprintf(smc_host, sizeof(smc_host), "%s", lgr->peer_hostname);
+	if (nla_put_string(skb, SMC_NLA_LGR_V2_PEER_HOST, smc_host) < 0)
+		goto errv2attr;
+	memset(smc_eid, 0, sizeof(smc_eid));
+	snprintf(smc_eid, sizeof(smc_eid), "%s", lgr->negotiated_eid);
+	if (nla_put_string(skb, SMC_NLA_LGR_V2_NEG_EID, smc_eid) < 0)
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
 int smcr_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	bool list_links = false;
@@ -447,6 +574,12 @@ int smcr_nl_get_link(struct sk_buff *skb, struct netlink_callback *cb)
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
index 9000d6a3b625..ee817b6b5d12 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -24,6 +24,7 @@ static const struct nla_policy smc_gen_nl_policy[SMC_GEN_MAX + 1] = {
 	[SMC_GEN_SYS_INFO]	= { .type = NLA_NESTED, },
 	[SMC_GEN_LGR_SMCR]	= { .type = NLA_NESTED, },
 	[SMC_GEN_LINK_SMCR]	= { .type = NLA_NESTED, },
+	[SMC_GEN_LGR_SMCD]	= { .type = NLA_NESTED, },
 };
 
 static int smc_nl_start(struct netlink_callback *cb)
@@ -31,6 +32,7 @@ static int smc_nl_start(struct netlink_callback *cb)
 	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
 
 	cb_ctx->pos[0] = 0;
+	cb_ctx->pos[1] = 0;
 	return 0;
 }
 
@@ -54,6 +56,12 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		.dumpit = smcr_nl_get_link,
 		.start = smc_nl_start
 	},
+	{
+		.cmd = SMC_NETLINK_GET_LGR_SMCD,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smcd_nl_get_lgr,
+		.start = smc_nl_start
+	},
 };
 
 /* SMC_GENL family definition */
-- 
2.17.1

