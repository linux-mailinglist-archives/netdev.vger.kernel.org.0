Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17CB2C5D21
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 21:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391161AbgKZUjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 15:39:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390965AbgKZUjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 15:39:32 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKWVkc122749;
        Thu, 26 Nov 2020 15:39:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=mTkf04wf8uU4Wk+OgqRPMggEFvKp7nZ7PnGY5mHwmmY=;
 b=tS0oQXeatLYbbrJS/N2Gcfsp/v3jAa9EzGUshqetCNqm6bdwMhnjmUljd0dIOH4QHikf
 kKkc5B6a6qceA0SeqUjns8GGjljolRjxrkn/9veTtJqY3RBi7bnPOxu+hzghY8RSlStG
 VJaHyuu1i/rUXtna7AYcrqWaB7LXPNY3VmQMtjebQMsfNUMR3vA16bU/4PDzvz60ml7M
 ay9Coy4jFR6CK8nCfykwNsaHz+r0XpjQ8g3bH6OQf5HY3C5cwAT66iz06x2SZgyfOdSz
 bcXFyQZc77gjXPaltBilTX1k+aS1W7Bp+BTx5DskEJsnW9jUs1h8hkTAeHzWJnVOp1Kn cg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352hnajarp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 15:39:30 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKX3Qk015048;
        Thu, 26 Nov 2020 20:39:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 352ata088d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 20:39:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQKdPRl66191842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 20:39:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07974A4040;
        Thu, 26 Nov 2020 20:39:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C648DA4057;
        Thu, 26 Nov 2020 20:39:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 20:39:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v6 09/14] net/smc: Add support for obtaining system information
Date:   Thu, 26 Nov 2020 21:39:11 +0100
Message-Id: <20201126203916.56071-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201126203916.56071-1-kgraul@linux.ibm.com>
References: <20201126203916.56071-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_09:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Add new netlink command to obtain system information
of the smc module.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h | 18 ++++++++++++
 net/smc/smc_clc.c        |  5 ++++
 net/smc/smc_clc.h        |  1 +
 net/smc/smc_core.c       | 60 ++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_core.h       |  2 ++
 net/smc/smc_netlink.c    |  5 ++++
 net/smc/smc_netlink.h    |  9 ++++++
 7 files changed, 100 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index b604d64542e8..1b8d4e770be9 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -37,11 +37,29 @@ enum {				/* SMC PNET Table commands */
 #define SMC_GENL_FAMILY_NAME		"SMC_GEN_NETLINK"
 #define SMC_GENL_FAMILY_VERSION		1
 
+/* SMC_GENL_FAMILY commands */
+enum {
+	SMC_NETLINK_GET_SYS_INFO = 1,
+};
+
 /* SMC_GENL_FAMILY top level attributes */
 enum {
 	SMC_GEN_UNSPEC,
+	SMC_GEN_SYS_INFO,		/* nest */
 	__SMC_GEN_MAX,
 	SMC_GEN_MAX = __SMC_GEN_MAX - 1
 };
 
+/* SMC_GEN_SYS_INFO attributes */
+enum {
+	SMC_NLA_SYS_UNSPEC,
+	SMC_NLA_SYS_VER,		/* u8 */
+	SMC_NLA_SYS_REL,		/* u8 */
+	SMC_NLA_SYS_IS_ISM_V2,		/* u8 */
+	SMC_NLA_SYS_LOCAL_HOST,		/* string */
+	SMC_NLA_SYS_SEID,		/* string */
+	__SMC_NLA_SYS_MAX,
+	SMC_NLA_SYS_MAX = __SMC_NLA_SYS_MAX - 1
+};
+
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 696d89c2dce4..e286dafd6e88 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -772,6 +772,11 @@ int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
 	return len > 0 ? 0 : len;
 }
 
+void smc_clc_get_hostname(u8 **host)
+{
+	*host = &smc_hostname[0];
+}
+
 void __init smc_clc_init(void)
 {
 	struct new_utsname *u;
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 49752c997c51..32d37f7b70f2 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -334,5 +334,6 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact,
 			u8 version);
 void smc_clc_init(void) __init;
+void smc_clc_get_hostname(u8 **host);
 
 #endif
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 0088511e30bf..0524d7bbab67 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -16,6 +16,8 @@
 #include <linux/wait.h>
 #include <linux/reboot.h>
 #include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/smc.h>
 #include <net/tcp.h>
 #include <net/sock.h>
 #include <rdma/ib_verbs.h>
@@ -30,6 +32,7 @@
 #include "smc_cdc.h"
 #include "smc_close.h"
 #include "smc_ism.h"
+#include "smc_netlink.h"
 
 #define SMC_LGR_NUM_INCR		256
 #define SMC_LGR_FREE_DELAY_SERV		(600 * HZ)
@@ -214,6 +217,63 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
 	conn->lgr = NULL;
 }
 
+int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	char hostname[SMC_MAX_HOSTNAME_LEN + 1];
+	char smc_seid[SMC_MAX_EID_LEN + 1];
+	struct smcd_dev *smcd_dev;
+	struct nlattr *attrs;
+	u8 *seid = NULL;
+	u8 *host = NULL;
+	void *nlh;
+
+	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_GET_SYS_INFO);
+	if (!nlh)
+		goto errmsg;
+	if (cb_ctx->pos[0])
+		goto errout;
+	attrs = nla_nest_start_noflag(skb, SMC_GEN_SYS_INFO);
+	if (!attrs)
+		goto errout;
+	if (nla_put_u8(skb, SMC_NLA_SYS_VER, SMC_V2))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_SYS_REL, SMC_RELEASE))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_SYS_IS_ISM_V2, smc_ism_is_v2_capable()))
+		goto errattr;
+	smc_clc_get_hostname(&host);
+	if (host) {
+		snprintf(hostname, sizeof(hostname), "%s", host);
+		if (nla_put_string(skb, SMC_NLA_SYS_LOCAL_HOST, hostname))
+			goto errattr;
+	}
+	mutex_lock(&smcd_dev_list.mutex);
+	smcd_dev = list_first_entry_or_null(&smcd_dev_list.list,
+					    struct smcd_dev, list);
+	if (smcd_dev)
+		smc_ism_get_system_eid(smcd_dev, &seid);
+	mutex_unlock(&smcd_dev_list.mutex);
+	if (seid && smc_ism_is_v2_capable()) {
+		snprintf(smc_seid, sizeof(smc_seid), "%s", seid);
+		if (nla_put_string(skb, SMC_NLA_SYS_SEID, smc_seid))
+			goto errattr;
+	}
+	nla_nest_end(skb, attrs);
+	genlmsg_end(skb, nlh);
+	cb_ctx->pos[0] = 1;
+	return skb->len;
+
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	genlmsg_cancel(skb, nlh);
+errmsg:
+	return skb->len;
+}
+
 void smc_lgr_cleanup_early(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr = conn->lgr;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 3a1bb8e4b81f..eaed25d4e76b 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -14,6 +14,7 @@
 
 #include <linux/atomic.h>
 #include <rdma/ib_verbs.h>
+#include <net/genetlink.h>
 
 #include "smc.h"
 #include "smc_ib.h"
@@ -413,6 +414,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 				  struct smc_link *from_lnk, bool is_dev_err);
 void smcr_link_down_cond(struct smc_link *lnk);
 void smcr_link_down_cond_sched(struct smc_link *lnk);
+int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb);
 
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index e9a56148e71b..b1de58a6a1c4 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -21,6 +21,11 @@
 
 /* SMC_GENL generic netlink operation definition */
 static const struct genl_ops smc_gen_nl_ops[] = {
+	{
+		.cmd = SMC_NETLINK_GET_SYS_INFO,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smc_nl_get_sys_info,
+	},
 };
 
 /* SMC_GENL family definition */
diff --git a/net/smc/smc_netlink.h b/net/smc/smc_netlink.h
index 0c757232c0d0..3477265cba6c 100644
--- a/net/smc/smc_netlink.h
+++ b/net/smc/smc_netlink.h
@@ -17,6 +17,15 @@
 
 extern struct genl_family smc_gen_nl_family;
 
+struct smc_nl_dmp_ctx {
+	int pos[2];
+};
+
+static inline struct smc_nl_dmp_ctx *smc_nl_dmp_ctx(struct netlink_callback *c)
+{
+	return (struct smc_nl_dmp_ctx *)c->ctx;
+}
+
 int smc_nl_init(void) __init;
 void smc_nl_exit(void);
 
-- 
2.17.1

