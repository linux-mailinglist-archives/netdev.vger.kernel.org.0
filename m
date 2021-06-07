Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F9C39E66E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhFGSWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:22:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhFGSW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:22:29 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157I4jqF114593;
        Mon, 7 Jun 2021 14:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cw5F3182k7d4uDD5I11Mk/si9K6mSPF9F5g5jKFWBGk=;
 b=Gm19nBnHZsA7Zuaudzffrd0IB1K8jWhDNnO9qYasZUNBJANpn5/HHdgkaaNe6jSkq0x/
 gu3ZDIbpua3gZTvXStLwsl0DH/O/aqFFKUeh43+qMxjkMyBJEGK1xeWg/dzvdUMDLu8r
 C3q9cU/pbnSJKqjAv8TQi3ReYApBF881mMZgX51oUCcyH1vKQPjQXnTWU4t4Yf9pYyiY
 /zn4d6ziI5cxmjRDkKhfeDr3UcIqZGdC/PmelCe1PP84EdZBa0LtRqKiLunX4WS8rQ4d
 WEok+7lTXv4GP6WxkE61qO7FkrJwEpqWz5h4MFSA8BL2Fpio48IslRMvd1SOmiZBP1w1 qw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 391qvc9e73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Jun 2021 14:20:36 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 157IKYQ2032099;
        Mon, 7 Jun 2021 18:20:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3900hhgke7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Jun 2021 18:20:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 157IJiVc35717434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Jun 2021 18:19:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41BC6A4055;
        Mon,  7 Jun 2021 18:20:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08C60A405D;
        Mon,  7 Jun 2021 18:20:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Jun 2021 18:20:30 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 3/4] net/smc: Add netlink support for SMC fallback statistics
Date:   Mon,  7 Jun 2021 20:20:13 +0200
Message-Id: <20210607182014.3384922-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607182014.3384922-1-kgraul@linux.ibm.com>
References: <20210607182014.3384922-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EL6KhkUs9PH0b1NFTXDlUitTjkyoo3T7
X-Proofpoint-GUID: EL6KhkUs9PH0b1NFTXDlUitTjkyoo3T7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_14:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 adultscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Add support to collect more detailed SMC fallback reason statistics and
provide these statistics to user space on the netlink interface.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h | 14 ++++++
 net/smc/smc_netlink.c    |  5 +++
 net/smc/smc_netlink.h    |  2 +-
 net/smc/smc_stats.c      | 92 ++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_stats.h      |  1 +
 5 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index f32f11b30963..0f7f87c70baf 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -48,6 +48,7 @@ enum {
 	SMC_NETLINK_GET_DEV_SMCD,
 	SMC_NETLINK_GET_DEV_SMCR,
 	SMC_NETLINK_GET_STATS,
+	SMC_NETLINK_GET_FBACK_STATS,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -60,6 +61,7 @@ enum {
 	SMC_GEN_DEV_SMCD,		/* nest */
 	SMC_GEN_DEV_SMCR,		/* nest */
 	SMC_GEN_STATS,			/* nest */
+	SMC_GEN_FBACK_STATS,		/* nest */
 	__SMC_GEN_MAX,
 	SMC_GEN_MAX = __SMC_GEN_MAX - 1
 };
@@ -228,4 +230,16 @@ enum {
 	__SMC_NLA_STATS_MAX,
 	SMC_NLA_STATS_MAX = __SMC_NLA_STATS_MAX - 1
 };
+
+/* SMC_GEN_FBACK_STATS attributes */
+enum {
+	SMC_NLA_FBACK_STATS_PAD,
+	SMC_NLA_FBACK_STATS_TYPE,	/* u8 */
+	SMC_NLA_FBACK_STATS_SRV_CNT,	/* u64 */
+	SMC_NLA_FBACK_STATS_CLNT_CNT,	/* u64 */
+	SMC_NLA_FBACK_STATS_RSN_CODE,	/* u32 */
+	SMC_NLA_FBACK_STATS_RSN_CNT,	/* u16 */
+	__SMC_NLA_FBACK_STATS_MAX,
+	SMC_NLA_FBACK_STATS_MAX = __SMC_NLA_FBACK_STATS_MAX - 1
+};
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index 30e30b23370f..6fb6f96c1d17 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -61,6 +61,11 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		/* can be retrieved by unprivileged users */
 		.dumpit = smc_nl_get_stats,
 	},
+	{
+		.cmd = SMC_NETLINK_GET_FBACK_STATS,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smc_nl_get_fback_stats,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
diff --git a/net/smc/smc_netlink.h b/net/smc/smc_netlink.h
index 3477265cba6c..5ce2c0a89ccd 100644
--- a/net/smc/smc_netlink.h
+++ b/net/smc/smc_netlink.h
@@ -18,7 +18,7 @@
 extern struct genl_family smc_gen_nl_family;
 
 struct smc_nl_dmp_ctx {
-	int pos[2];
+	int pos[3];
 };
 
 static inline struct smc_nl_dmp_ctx *smc_nl_dmp_ctx(struct netlink_callback *c)
diff --git a/net/smc/smc_stats.c b/net/smc/smc_stats.c
index 72119d3d8558..b3d279d29c52 100644
--- a/net/smc/smc_stats.c
+++ b/net/smc/smc_stats.c
@@ -312,3 +312,95 @@ int smc_nl_get_stats(struct sk_buff *skb,
 errmsg:
 	return skb->len;
 }
+
+static int smc_nl_get_fback_details(struct sk_buff *skb,
+				    struct netlink_callback *cb, int pos,
+				    bool is_srv)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	int cnt_reported = cb_ctx->pos[2];
+	struct smc_stats_fback *trgt_arr;
+	struct nlattr *attrs;
+	int rc = 0;
+	void *nlh;
+
+	if (is_srv)
+		trgt_arr = &fback_rsn.srv[0];
+	else
+		trgt_arr = &fback_rsn.clnt[0];
+	if (!trgt_arr[pos].fback_code)
+		return -ENODATA;
+	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_GET_FBACK_STATS);
+	if (!nlh)
+		goto errmsg;
+	attrs = nla_nest_start(skb, SMC_GEN_FBACK_STATS);
+	if (!attrs)
+		goto errout;
+	if (nla_put_u8(skb, SMC_NLA_FBACK_STATS_TYPE, is_srv))
+		goto errattr;
+	if (!cnt_reported) {
+		if (nla_put_u64_64bit(skb, SMC_NLA_FBACK_STATS_SRV_CNT,
+				      fback_rsn.srv_fback_cnt,
+				      SMC_NLA_FBACK_STATS_PAD))
+			goto errattr;
+		if (nla_put_u64_64bit(skb, SMC_NLA_FBACK_STATS_CLNT_CNT,
+				      fback_rsn.clnt_fback_cnt,
+				      SMC_NLA_FBACK_STATS_PAD))
+			goto errattr;
+		cnt_reported = 1;
+	}
+
+	if (nla_put_u32(skb, SMC_NLA_FBACK_STATS_RSN_CODE,
+			trgt_arr[pos].fback_code))
+		goto errattr;
+	if (nla_put_u16(skb, SMC_NLA_FBACK_STATS_RSN_CNT,
+			trgt_arr[pos].count))
+		goto errattr;
+
+	cb_ctx->pos[2] = cnt_reported;
+	nla_nest_end(skb, attrs);
+	genlmsg_end(skb, nlh);
+	return rc;
+
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	genlmsg_cancel(skb, nlh);
+errmsg:
+	return -EMSGSIZE;
+}
+
+int smc_nl_get_fback_stats(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	int rc_srv = 0, rc_clnt = 0, k;
+	int skip_serv = cb_ctx->pos[1];
+	int snum = cb_ctx->pos[0];
+	bool is_srv = true;
+
+	mutex_lock(&smc_stat_fback_rsn);
+	for (k = 0; k < SMC_MAX_FBACK_RSN_CNT; k++) {
+		if (k < snum)
+			continue;
+		if (!skip_serv) {
+			rc_srv = smc_nl_get_fback_details(skb, cb, k, is_srv);
+			if (rc_srv && rc_srv != ENODATA)
+				break;
+		} else {
+			skip_serv = 0;
+		}
+		rc_clnt = smc_nl_get_fback_details(skb, cb, k, !is_srv);
+		if (rc_clnt && rc_clnt != ENODATA) {
+			skip_serv = 1;
+			break;
+		}
+		if (rc_clnt == ENODATA && rc_srv == ENODATA)
+			break;
+	}
+	mutex_unlock(&smc_stat_fback_rsn);
+	cb_ctx->pos[1] = skip_serv;
+	cb_ctx->pos[0] = k;
+	return skb->len;
+}
diff --git a/net/smc/smc_stats.h b/net/smc/smc_stats.h
index 84baaca59eaf..7c35b22d9e29 100644
--- a/net/smc/smc_stats.h
+++ b/net/smc/smc_stats.h
@@ -248,6 +248,7 @@ do { \
 while (0)
 
 int smc_nl_get_stats(struct sk_buff *skb, struct netlink_callback *cb);
+int smc_nl_get_fback_stats(struct sk_buff *skb, struct netlink_callback *cb);
 int smc_stats_init(void) __init;
 void smc_stats_exit(void);
 
-- 
2.25.1

