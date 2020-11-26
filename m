Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEB02C5D25
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 21:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391089AbgKZUje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 15:39:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391008AbgKZUjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 15:39:33 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKYEFl019601;
        Thu, 26 Nov 2020 15:39:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=vYvd6LpFpbDdkjlk4V8D7urx64PrEhifwnSsj60zvFY=;
 b=UX37RFQuNyCHgQtyv4JR7zKvvFNpbZxeBQJhfGwcZhS4+KjKu7/gIdzdCCOpK2Z59AY+
 ++bFw684O1X3LXdVL2jcjSalgcjZZjsXIEhRj22r4+kYoXNi1Q9UgHgmOT0iUX/YgAK9
 rrOTWCpiLveKGHVkpq3ymEnE6IB5FVAcdbGYyzABF6p+eWlr1TXpSZZYOhj2VDySn+xl
 Bh0MjYEZL7y5Zs9bAegM8KKliE9meeBazSs/PPhWi4hZFxVhSbK24PZ0Kpl1ALcbCebo
 rpfbHkT17X2dgNN+JbMkabOMiMfHucydzUKsefdL4e05Yn2SjNnA07HNqqSFBwbB6KNW cQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352jvm8u3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 15:39:30 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKYXhL029467;
        Thu, 26 Nov 2020 20:39:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 351pca0qk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 20:39:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQKdPS864750072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 20:39:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CE0BA4040;
        Thu, 26 Nov 2020 20:39:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5294DA4053;
        Thu, 26 Nov 2020 20:39:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 20:39:25 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v6 11/14] net/smc: Introduce SMCR get link command
Date:   Thu, 26 Nov 2020 21:39:13 +0100
Message-Id: <20201126203916.56071-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201126203916.56071-1-kgraul@linux.ibm.com>
References: <20201126203916.56071-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_09:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260128
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
 include/uapi/linux/smc.h | 18 ++++++++
 net/smc/smc_core.c       | 91 ++++++++++++++++++++++++++++++++++++++--
 net/smc/smc_core.h       | 14 +++++++
 net/smc/smc_diag.c       | 13 ------
 net/smc/smc_netlink.c    |  5 +++
 5 files changed, 124 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 3ae8ca4e5256..ed638dbfff08 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -41,6 +41,7 @@ enum {				/* SMC PNET Table commands */
 enum {
 	SMC_NETLINK_GET_SYS_INFO = 1,
 	SMC_NETLINK_GET_LGR_SMCR,
+	SMC_NETLINK_GET_LINK_SMCR,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -48,6 +49,7 @@ enum {
 	SMC_GEN_UNSPEC,
 	SMC_GEN_SYS_INFO,		/* nest */
 	SMC_GEN_LGR_SMCR,		/* nest */
+	SMC_GEN_LINK_SMCR,		/* nest */
 	__SMC_GEN_MAX,
 	SMC_GEN_MAX = __SMC_GEN_MAX - 1
 };
@@ -77,4 +79,20 @@ enum {
 	SMC_NLA_LGR_R_MAX = __SMC_NLA_LGR_R_MAX - 1
 };
 
+/* SMC_GEN_LINK_SMCR attributes */
+enum {
+	SMC_NLA_LINK_UNSPEC,
+	SMC_NLA_LINK_ID,		/* u8 */
+	SMC_NLA_LINK_IB_DEV,		/* string */
+	SMC_NLA_LINK_IB_PORT,		/* u8 */
+	SMC_NLA_LINK_GID,		/* string */
+	SMC_NLA_LINK_PEER_GID,		/* string */
+	SMC_NLA_LINK_CONN_CNT,		/* u32 */
+	SMC_NLA_LINK_NET_DEV,		/* u32 */
+	SMC_NLA_LINK_UID,		/* u32 */
+	SMC_NLA_LINK_PEER_UID,		/* u32 */
+	SMC_NLA_LINK_STATE,		/* u32 */
+	__SMC_NLA_LINK_MAX,
+	SMC_NLA_LINK_MAX = __SMC_NLA_LINK_MAX - 1
+};
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 008ec6e778fa..960c3853ba15 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -307,11 +307,74 @@ static int smc_nl_fill_lgr(struct smc_link_group *lgr,
 	return -EMSGSIZE;
 }
 
+static int smc_nl_fill_lgr_link(struct smc_link_group *lgr,
+				struct smc_link *link,
+				struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	char smc_ibname[IB_DEVICE_NAME_MAX + 1];
+	u8 smc_gid_target[41];
+	struct nlattr *attrs;
+	u32 link_uid = 0;
+	void *nlh;
+
+	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_GET_LINK_SMCR);
+	if (!nlh)
+		goto errmsg;
+
+	attrs = nla_nest_start_noflag(skb, SMC_GEN_LINK_SMCR);
+	if (!attrs)
+		goto errout;
+
+	if (nla_put_u8(skb, SMC_NLA_LINK_ID, link->link_id))
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_LINK_STATE, link->state))
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_LINK_CONN_CNT,
+			atomic_read(&link->conn_cnt)))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LINK_IB_PORT, link->ibport))
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_LINK_NET_DEV, link->ndev_ifidx))
+		goto errattr;
+	snprintf(smc_ibname, sizeof(smc_ibname), "%s", link->ibname);
+	if (nla_put_string(skb, SMC_NLA_LINK_IB_DEV, smc_ibname))
+		goto errattr;
+	memcpy(&link_uid, link->link_uid, sizeof(link_uid));
+	if (nla_put_u32(skb, SMC_NLA_LINK_UID, link_uid))
+		goto errattr;
+	memcpy(&link_uid, link->peer_link_uid, sizeof(link_uid));
+	if (nla_put_u32(skb, SMC_NLA_LINK_PEER_UID, link_uid))
+		goto errattr;
+	memset(smc_gid_target, 0, sizeof(smc_gid_target));
+	smc_gid_be16_convert(smc_gid_target, link->gid);
+	if (nla_put_string(skb, SMC_NLA_LINK_GID, smc_gid_target))
+		goto errattr;
+	memset(smc_gid_target, 0, sizeof(smc_gid_target));
+	smc_gid_be16_convert(smc_gid_target, link->peer_gid);
+	if (nla_put_string(skb, SMC_NLA_LINK_PEER_GID, smc_gid_target))
+		goto errattr;
+
+	nla_nest_end(skb, attrs);
+	genlmsg_end(skb, nlh);
+	return 0;
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	genlmsg_cancel(skb, nlh);
+errmsg:
+	return -EMSGSIZE;
+}
+
 static int smc_nl_handle_lgr(struct smc_link_group *lgr,
 			     struct sk_buff *skb,
-			     struct netlink_callback *cb)
+			     struct netlink_callback *cb,
+			     bool list_links)
 {
 	void *nlh;
+	int i;
 
 	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			  &smc_gen_nl_family, NLM_F_MULTI,
@@ -322,6 +385,15 @@ static int smc_nl_handle_lgr(struct smc_link_group *lgr,
 		goto errout;
 
 	genlmsg_end(skb, nlh);
+	if (!list_links)
+		goto out;
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (!smc_link_usable(&lgr->lnk[i]))
+			continue;
+		if (smc_nl_fill_lgr_link(lgr, &lgr->lnk[i], skb, cb))
+			goto errout;
+	}
+out:
 	return 0;
 
 errout:
@@ -332,7 +404,8 @@ static int smc_nl_handle_lgr(struct smc_link_group *lgr,
 
 static void smc_nl_fill_lgr_list(struct smc_lgr_list *smc_lgr,
 				 struct sk_buff *skb,
-				 struct netlink_callback *cb)
+				 struct netlink_callback *cb,
+				 bool list_links)
 {
 	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
 	struct smc_link_group *lgr;
@@ -343,7 +416,7 @@ static void smc_nl_fill_lgr_list(struct smc_lgr_list *smc_lgr,
 	list_for_each_entry(lgr, &smc_lgr->list, list) {
 		if (num < snum)
 			goto next;
-		if (smc_nl_handle_lgr(lgr, skb, cb))
+		if (smc_nl_handle_lgr(lgr, skb, cb, list_links))
 			goto errout;
 next:
 		num++;
@@ -355,7 +428,17 @@ static void smc_nl_fill_lgr_list(struct smc_lgr_list *smc_lgr,
 
 int smcr_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	smc_nl_fill_lgr_list(&smc_lgr_list, skb, cb);
+	bool list_links = false;
+
+	smc_nl_fill_lgr_list(&smc_lgr_list, skb, cb, list_links);
+	return skb->len;
+}
+
+int smcr_nl_get_link(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	bool list_links = true;
+
+	smc_nl_fill_lgr_list(&smc_lgr_list, skb, cb, list_links);
 	return skb->len;
 }
 
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 662315beb605..7995621f318d 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -367,6 +367,19 @@ static inline bool smc_link_active(struct smc_link *lnk)
 	return lnk->state == SMC_LNK_ACTIVE;
 }
 
+static inline void smc_gid_be16_convert(__u8 *buf, u8 *gid_raw)
+{
+	sprintf(buf, "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x",
+		be16_to_cpu(((__be16 *)gid_raw)[0]),
+		be16_to_cpu(((__be16 *)gid_raw)[1]),
+		be16_to_cpu(((__be16 *)gid_raw)[2]),
+		be16_to_cpu(((__be16 *)gid_raw)[3]),
+		be16_to_cpu(((__be16 *)gid_raw)[4]),
+		be16_to_cpu(((__be16 *)gid_raw)[5]),
+		be16_to_cpu(((__be16 *)gid_raw)[6]),
+		be16_to_cpu(((__be16 *)gid_raw)[7]));
+}
+
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
@@ -416,6 +429,7 @@ void smcr_link_down_cond(struct smc_link *lnk);
 void smcr_link_down_cond_sched(struct smc_link *lnk);
 int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb);
 int smcr_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb);
+int smcr_nl_get_link(struct sk_buff *skb, struct netlink_callback *cb);
 
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index c2225231f679..c952986a6aca 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -31,19 +31,6 @@ static struct smc_diag_dump_ctx *smc_dump_context(struct netlink_callback *cb)
 	return (struct smc_diag_dump_ctx *)cb->ctx;
 }
 
-static void smc_gid_be16_convert(__u8 *buf, u8 *gid_raw)
-{
-	sprintf(buf, "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x",
-		be16_to_cpu(((__be16 *)gid_raw)[0]),
-		be16_to_cpu(((__be16 *)gid_raw)[1]),
-		be16_to_cpu(((__be16 *)gid_raw)[2]),
-		be16_to_cpu(((__be16 *)gid_raw)[3]),
-		be16_to_cpu(((__be16 *)gid_raw)[4]),
-		be16_to_cpu(((__be16 *)gid_raw)[5]),
-		be16_to_cpu(((__be16 *)gid_raw)[6]),
-		be16_to_cpu(((__be16 *)gid_raw)[7]));
-}
-
 static void smc_diag_msg_common_fill(struct smc_diag_msg *r, struct sock *sk)
 {
 	struct smc_sock *smc = smc_sk(sk);
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index 074b57877fcf..4212408cc091 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -31,6 +31,11 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		/* can be retrieved by unprivileged users */
 		.dumpit = smcr_nl_get_lgr,
 	},
+	{
+		.cmd = SMC_NETLINK_GET_LINK_SMCR,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smcr_nl_get_link,
+	},
 };
 
 /* SMC_GENL family definition */
-- 
2.17.1

