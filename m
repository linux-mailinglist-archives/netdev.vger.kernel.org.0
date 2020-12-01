Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DBE2CABBB
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404317AbgLATV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731278AbgLATVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:46 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J2UAf171335;
        Tue, 1 Dec 2020 14:21:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=NG3sz9jSy9aU/Oya67l2LwGRfk14Q17r7PeQTFBC6EI=;
 b=JcV2faU1HaIEtcqwobKKesFSFVT4e+ulGc9HWF6LM3GD6CKO3HlEch6wPgi8IPX1nah1
 QLftPiy/Z/lpUWYYe7uSGNRfrDk4WpBxXrmdNxQ5xJsZvuJZhdsvZtYwicexQic0zWsW
 V3ftJTDqybrBbOEczdc6xTkbT4Z/K7sPa0xU8GzhHxu18XnhGEmMov9cblCN4U9DusQi
 1oNzA4nBCAVzICgT7tjoomiHILVdFM3wI/HXM7eEopPncqvc3G/N2kKQ8hTgZfifNsj3
 9lvTGIStdLd99TyIlyjV5PHs+sj1nkbQSd0Ai0QUBMgnqP4ICbcACMEGCJ9BWOXL1QCG wg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355a7a7qvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:03 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JHc37008878;
        Tue, 1 Dec 2020 19:21:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 353dth9ssg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:21:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKw4b35193088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B321AE053;
        Tue,  1 Dec 2020 19:20:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3115FAE04D;
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
Subject: [PATCH net-next v7 10/14] net/smc: Introduce SMCR get linkgroup command
Date:   Tue,  1 Dec 2020 20:20:45 +0100
Message-Id: <20201201192049.53517-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010112
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
 include/uapi/linux/smc.h | 15 +++++++
 net/smc/smc_core.c       | 85 ++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_core.h       |  1 +
 net/smc/smc_netlink.c    |  5 +++
 4 files changed, 106 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 1b8d4e770be9..3ae8ca4e5256 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -40,12 +40,14 @@ enum {				/* SMC PNET Table commands */
 /* SMC_GENL_FAMILY commands */
 enum {
 	SMC_NETLINK_GET_SYS_INFO = 1,
+	SMC_NETLINK_GET_LGR_SMCR,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
 enum {
 	SMC_GEN_UNSPEC,
 	SMC_GEN_SYS_INFO,		/* nest */
+	SMC_GEN_LGR_SMCR,		/* nest */
 	__SMC_GEN_MAX,
 	SMC_GEN_MAX = __SMC_GEN_MAX - 1
 };
@@ -62,4 +64,17 @@ enum {
 	SMC_NLA_SYS_MAX = __SMC_NLA_SYS_MAX - 1
 };
 
+/* SMC_GEN_LGR_SMCR attributes */
+enum {
+	SMC_NLA_LGR_R_UNSPEC,
+	SMC_NLA_LGR_R_ID,		/* u32 */
+	SMC_NLA_LGR_R_ROLE,		/* u8 */
+	SMC_NLA_LGR_R_TYPE,		/* u8 */
+	SMC_NLA_LGR_R_PNETID,		/* string */
+	SMC_NLA_LGR_R_VLAN_ID,		/* u8 */
+	SMC_NLA_LGR_R_CONNS_NUM,	/* u32 */
+	__SMC_NLA_LGR_R_MAX,
+	SMC_NLA_LGR_R_MAX = __SMC_NLA_LGR_R_MAX - 1
+};
+
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c7b1c62c2f2e..e21d068191ad 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -274,6 +274,91 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int smc_nl_fill_lgr(struct smc_link_group *lgr,
+			   struct sk_buff *skb,
+			   struct netlink_callback *cb)
+{
+	char smc_target[SMC_MAX_PNETID_LEN + 1];
+	struct nlattr *attrs;
+
+	attrs = nla_nest_start(skb, SMC_GEN_LGR_SMCR);
+	if (!attrs)
+		goto errout;
+
+	if (nla_put_u32(skb, SMC_NLA_LGR_R_ID, *((u32 *)&lgr->id)))
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_LGR_R_CONNS_NUM, lgr->conns_num))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_R_ROLE, lgr->role))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_R_TYPE, lgr->type))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_R_VLAN_ID, lgr->vlan_id))
+		goto errattr;
+	snprintf(smc_target, sizeof(smc_target), "%s", lgr->pnet_id);
+	if (nla_put_string(skb, SMC_NLA_LGR_R_PNETID, smc_target))
+		goto errattr;
+
+	nla_nest_end(skb, attrs);
+	return 0;
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	return -EMSGSIZE;
+}
+
+static int smc_nl_handle_lgr(struct smc_link_group *lgr,
+			     struct sk_buff *skb,
+			     struct netlink_callback *cb)
+{
+	void *nlh;
+
+	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_GET_LGR_SMCR);
+	if (!nlh)
+		goto errmsg;
+	if (smc_nl_fill_lgr(lgr, skb, cb))
+		goto errout;
+
+	genlmsg_end(skb, nlh);
+	return 0;
+
+errout:
+	genlmsg_cancel(skb, nlh);
+errmsg:
+	return -EMSGSIZE;
+}
+
+static void smc_nl_fill_lgr_list(struct smc_lgr_list *smc_lgr,
+				 struct sk_buff *skb,
+				 struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	struct smc_link_group *lgr;
+	int snum = cb_ctx->pos[0];
+	int num = 0;
+
+	spin_lock_bh(&smc_lgr->lock);
+	list_for_each_entry(lgr, &smc_lgr->list, list) {
+		if (num < snum)
+			goto next;
+		if (smc_nl_handle_lgr(lgr, skb, cb))
+			goto errout;
+next:
+		num++;
+	}
+errout:
+	spin_unlock_bh(&smc_lgr->lock);
+	cb_ctx->pos[0] = num;
+}
+
+int smcr_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	smc_nl_fill_lgr_list(&smc_lgr_list, skb, cb);
+	return skb->len;
+}
+
 void smc_lgr_cleanup_early(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr = conn->lgr;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index eaed25d4e76b..662315beb605 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -415,6 +415,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 void smcr_link_down_cond(struct smc_link *lnk);
 void smcr_link_down_cond_sched(struct smc_link *lnk);
 int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb);
+int smcr_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb);
 
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index ce06d269a54b..490da56c8d3c 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -28,6 +28,11 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		/* can be retrieved by unprivileged users */
 		.dumpit = smc_nl_get_sys_info,
 	},
+	{
+		.cmd = SMC_NETLINK_GET_LGR_SMCR,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smcr_nl_get_lgr,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
-- 
2.17.1

