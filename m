Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D82F3A9E2E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhFPOzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:55:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234120AbhFPOzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:55:25 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GEf9FL035266;
        Wed, 16 Jun 2021 10:53:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kgm3VGzvhetdSNTxDoF2a/ph/L8tdXrhcwaonGMRb3U=;
 b=kilOKO+eotqTn05PAuhii3yLu6VZLiIL50Da7Rr7dA+EAxsH73Cnp3JjMILGYr+pUFQT
 PRaFvvahomPXDiAp6HtYutoQz3LFzOXdcwfJaC2z+CZuxk122eNXs4BtpYeyNrkAF6El
 57O+jkjh+I0vgHuqvJOEtUbS9huhODF/Spd71b8vHfzLoykUY5JySS79lrHs7Aa4HElZ
 ixx6nNgMo5Zkn1uu5EtIlXoT1pOcRN6mnPHziPBtVp7LNKewjMCitfvNm19TuC1nLDim
 kgIocpnll1oOEx8zSyq07DhVmUra+ybFi8RbJs9xvaY6nfs2Wor4Ar+DMTQhEl7DTgxF MA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 397jeq2ede-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 10:53:14 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15GEmK9h019880;
        Wed, 16 Jun 2021 14:53:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 394mj8t5ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 14:53:12 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15GEr9KI29491636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 14:53:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B19B42045;
        Wed, 16 Jun 2021 14:53:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 598CE42042;
        Wed, 16 Jun 2021 14:53:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Jun 2021 14:53:09 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, guvenc@linux.ibm.com
Subject: [PATCH net-next v2 2/4] net/smc: Add netlink support for SMC statistics
Date:   Wed, 16 Jun 2021 16:52:56 +0200
Message-Id: <20210616145258.2381446-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616145258.2381446-1-kgraul@linux.ibm.com>
References: <20210616145258.2381446-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jyt9XaXumU7PCCKpJEipprdXqbE-HNwV
X-Proofpoint-ORIG-GUID: Jyt9XaXumU7PCCKpJEipprdXqbE-HNwV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-16_07:2021-06-15,2021-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Add the netlink function which collects the statistics information and
delivers it to the userspace.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h |  69 ++++++++++
 net/smc/smc_netlink.c    |   6 +
 net/smc/smc_stats.c      | 279 +++++++++++++++++++++++++++++++++++++++
 net/smc/smc_stats.h      |   1 +
 4 files changed, 355 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 3e68da07fba2..f32f11b30963 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -47,6 +47,7 @@ enum {
 	SMC_NETLINK_GET_LGR_SMCD,
 	SMC_NETLINK_GET_DEV_SMCD,
 	SMC_NETLINK_GET_DEV_SMCR,
+	SMC_NETLINK_GET_STATS,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -58,6 +59,7 @@ enum {
 	SMC_GEN_LGR_SMCD,		/* nest */
 	SMC_GEN_DEV_SMCD,		/* nest */
 	SMC_GEN_DEV_SMCR,		/* nest */
+	SMC_GEN_STATS,			/* nest */
 	__SMC_GEN_MAX,
 	SMC_GEN_MAX = __SMC_GEN_MAX - 1
 };
@@ -159,4 +161,71 @@ enum {
 	SMC_NLA_DEV_MAX = __SMC_NLA_DEV_MAX - 1
 };
 
+/* SMC_NLA_STATS_T_TX(RX)_RMB_SIZE nested attributes */
+/* SMC_NLA_STATS_TX(RX)PLOAD_SIZE nested attributes */
+enum {
+	SMC_NLA_STATS_PLOAD_PAD,
+	SMC_NLA_STATS_PLOAD_8K,		/* u64 */
+	SMC_NLA_STATS_PLOAD_16K,	/* u64 */
+	SMC_NLA_STATS_PLOAD_32K,	/* u64 */
+	SMC_NLA_STATS_PLOAD_64K,	/* u64 */
+	SMC_NLA_STATS_PLOAD_128K,	/* u64 */
+	SMC_NLA_STATS_PLOAD_256K,	/* u64 */
+	SMC_NLA_STATS_PLOAD_512K,	/* u64 */
+	SMC_NLA_STATS_PLOAD_1024K,	/* u64 */
+	SMC_NLA_STATS_PLOAD_G_1024K,	/* u64 */
+	__SMC_NLA_STATS_PLOAD_MAX,
+	SMC_NLA_STATS_PLOAD_MAX = __SMC_NLA_STATS_PLOAD_MAX - 1
+};
+
+/* SMC_NLA_STATS_T_TX(RX)_RMB_STATS nested attributes */
+enum {
+	SMC_NLA_STATS_RMB_PAD,
+	SMC_NLA_STATS_RMB_SIZE_SM_PEER_CNT,	/* u64 */
+	SMC_NLA_STATS_RMB_SIZE_SM_CNT,		/* u64 */
+	SMC_NLA_STATS_RMB_FULL_PEER_CNT,	/* u64 */
+	SMC_NLA_STATS_RMB_FULL_CNT,		/* u64 */
+	SMC_NLA_STATS_RMB_REUSE_CNT,		/* u64 */
+	SMC_NLA_STATS_RMB_ALLOC_CNT,		/* u64 */
+	SMC_NLA_STATS_RMB_DGRADE_CNT,		/* u64 */
+	__SMC_NLA_STATS_RMB_MAX,
+	SMC_NLA_STATS_RMB_MAX = __SMC_NLA_STATS_RMB_MAX - 1
+};
+
+/* SMC_NLA_STATS_SMCD_TECH and _SMCR_TECH nested attributes */
+enum {
+	SMC_NLA_STATS_T_PAD,
+	SMC_NLA_STATS_T_TX_RMB_SIZE,	/* nest */
+	SMC_NLA_STATS_T_RX_RMB_SIZE,	/* nest */
+	SMC_NLA_STATS_T_TXPLOAD_SIZE,	/* nest */
+	SMC_NLA_STATS_T_RXPLOAD_SIZE,	/* nest */
+	SMC_NLA_STATS_T_TX_RMB_STATS,	/* nest */
+	SMC_NLA_STATS_T_RX_RMB_STATS,	/* nest */
+	SMC_NLA_STATS_T_CLNT_V1_SUCC,	/* u64 */
+	SMC_NLA_STATS_T_CLNT_V2_SUCC,	/* u64 */
+	SMC_NLA_STATS_T_SRV_V1_SUCC,	/* u64 */
+	SMC_NLA_STATS_T_SRV_V2_SUCC,	/* u64 */
+	SMC_NLA_STATS_T_SENDPAGE_CNT,	/* u64 */
+	SMC_NLA_STATS_T_SPLICE_CNT,	/* u64 */
+	SMC_NLA_STATS_T_CORK_CNT,	/* u64 */
+	SMC_NLA_STATS_T_NDLY_CNT,	/* u64 */
+	SMC_NLA_STATS_T_URG_DATA_CNT,	/* u64 */
+	SMC_NLA_STATS_T_RX_BYTES,	/* u64 */
+	SMC_NLA_STATS_T_TX_BYTES,	/* u64 */
+	SMC_NLA_STATS_T_RX_CNT,		/* u64 */
+	SMC_NLA_STATS_T_TX_CNT,		/* u64 */
+	__SMC_NLA_STATS_T_MAX,
+	SMC_NLA_STATS_T_MAX = __SMC_NLA_STATS_T_MAX - 1
+};
+
+/* SMC_GEN_STATS attributes */
+enum {
+	SMC_NLA_STATS_PAD,
+	SMC_NLA_STATS_SMCD_TECH,	/* nest */
+	SMC_NLA_STATS_SMCR_TECH,	/* nest */
+	SMC_NLA_STATS_CLNT_HS_ERR_CNT,	/* u64 */
+	SMC_NLA_STATS_SRV_HS_ERR_CNT,	/* u64 */
+	__SMC_NLA_STATS_MAX,
+	SMC_NLA_STATS_MAX = __SMC_NLA_STATS_MAX - 1
+};
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index 140419a19dbf..30e30b23370f 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -19,6 +19,7 @@
 #include "smc_core.h"
 #include "smc_ism.h"
 #include "smc_ib.h"
+#include "smc_stats.h"
 #include "smc_netlink.h"
 
 #define SMC_CMD_MAX_ATTR 1
@@ -55,6 +56,11 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		/* can be retrieved by unprivileged users */
 		.dumpit = smcr_nl_get_device,
 	},
+	{
+		.cmd = SMC_NETLINK_GET_STATS,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smc_nl_get_stats,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
diff --git a/net/smc/smc_stats.c b/net/smc/smc_stats.c
index 76e938388520..72119d3d8558 100644
--- a/net/smc/smc_stats.c
+++ b/net/smc/smc_stats.c
@@ -12,6 +12,10 @@
 #include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/ctype.h>
+#include <linux/smc.h>
+#include <net/genetlink.h>
+#include <net/sock.h>
+#include "smc_netlink.h"
 #include "smc_stats.h"
 
 /* serialize fallback reason statistic gathering */
@@ -33,3 +37,278 @@ void smc_stats_exit(void)
 {
 	free_percpu(smc_stats);
 }
+
+static int smc_nl_fill_stats_rmb_data(struct sk_buff *skb,
+				      struct smc_stats *stats, int tech,
+				      int type)
+{
+	struct smc_stats_rmbcnt *stats_rmb_cnt;
+	struct nlattr *attrs;
+
+	if (type == SMC_NLA_STATS_T_TX_RMB_STATS)
+		stats_rmb_cnt = &stats->smc[tech].rmb_tx;
+	else
+		stats_rmb_cnt = &stats->smc[tech].rmb_rx;
+
+	attrs = nla_nest_start(skb, type);
+	if (!attrs)
+		goto errout;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_RMB_REUSE_CNT,
+			      stats_rmb_cnt->reuse_cnt,
+			      SMC_NLA_STATS_RMB_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_RMB_SIZE_SM_PEER_CNT,
+			      stats_rmb_cnt->buf_size_small_peer_cnt,
+			      SMC_NLA_STATS_RMB_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_RMB_SIZE_SM_CNT,
+			      stats_rmb_cnt->buf_size_small_cnt,
+			      SMC_NLA_STATS_RMB_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_RMB_FULL_PEER_CNT,
+			      stats_rmb_cnt->buf_full_peer_cnt,
+			      SMC_NLA_STATS_RMB_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_RMB_FULL_CNT,
+			      stats_rmb_cnt->buf_full_cnt,
+			      SMC_NLA_STATS_RMB_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_RMB_ALLOC_CNT,
+			      stats_rmb_cnt->alloc_cnt,
+			      SMC_NLA_STATS_RMB_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_RMB_DGRADE_CNT,
+			      stats_rmb_cnt->dgrade_cnt,
+			      SMC_NLA_STATS_RMB_PAD))
+		goto errattr;
+
+	nla_nest_end(skb, attrs);
+	return 0;
+
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	return -EMSGSIZE;
+}
+
+static int smc_nl_fill_stats_bufsize_data(struct sk_buff *skb,
+					  struct smc_stats *stats, int tech,
+					  int type)
+{
+	struct smc_stats_memsize *stats_pload;
+	struct nlattr *attrs;
+
+	if (type == SMC_NLA_STATS_T_TXPLOAD_SIZE)
+		stats_pload = &stats->smc[tech].tx_pd;
+	else if (type == SMC_NLA_STATS_T_RXPLOAD_SIZE)
+		stats_pload = &stats->smc[tech].rx_pd;
+	else if (type == SMC_NLA_STATS_T_TX_RMB_SIZE)
+		stats_pload = &stats->smc[tech].tx_rmbsize;
+	else if (type == SMC_NLA_STATS_T_RX_RMB_SIZE)
+		stats_pload = &stats->smc[tech].rx_rmbsize;
+	else
+		goto errout;
+
+	attrs = nla_nest_start(skb, type);
+	if (!attrs)
+		goto errout;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_8K,
+			      stats_pload->buf[SMC_BUF_8K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_16K,
+			      stats_pload->buf[SMC_BUF_16K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_32K,
+			      stats_pload->buf[SMC_BUF_32K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_64K,
+			      stats_pload->buf[SMC_BUF_64K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_128K,
+			      stats_pload->buf[SMC_BUF_128K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_256K,
+			      stats_pload->buf[SMC_BUF_256K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_512K,
+			      stats_pload->buf[SMC_BUF_512K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_1024K,
+			      stats_pload->buf[SMC_BUF_1024K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_PLOAD_G_1024K,
+			      stats_pload->buf[SMC_BUF_G_1024K],
+			      SMC_NLA_STATS_PLOAD_PAD))
+		goto errattr;
+
+	nla_nest_end(skb, attrs);
+	return 0;
+
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	return -EMSGSIZE;
+}
+
+static int smc_nl_fill_stats_tech_data(struct sk_buff *skb,
+				       struct smc_stats *stats, int tech)
+{
+	struct smc_stats_tech *smc_tech;
+	struct nlattr *attrs;
+
+	smc_tech = &stats->smc[tech];
+	if (tech == SMC_TYPE_D)
+		attrs = nla_nest_start(skb, SMC_NLA_STATS_SMCD_TECH);
+	else
+		attrs = nla_nest_start(skb, SMC_NLA_STATS_SMCR_TECH);
+
+	if (!attrs)
+		goto errout;
+	if (smc_nl_fill_stats_rmb_data(skb, stats, tech,
+				       SMC_NLA_STATS_T_TX_RMB_STATS))
+		goto errattr;
+	if (smc_nl_fill_stats_rmb_data(skb, stats, tech,
+				       SMC_NLA_STATS_T_RX_RMB_STATS))
+		goto errattr;
+	if (smc_nl_fill_stats_bufsize_data(skb, stats, tech,
+					   SMC_NLA_STATS_T_TXPLOAD_SIZE))
+		goto errattr;
+	if (smc_nl_fill_stats_bufsize_data(skb, stats, tech,
+					   SMC_NLA_STATS_T_RXPLOAD_SIZE))
+		goto errattr;
+	if (smc_nl_fill_stats_bufsize_data(skb, stats, tech,
+					   SMC_NLA_STATS_T_TX_RMB_SIZE))
+		goto errattr;
+	if (smc_nl_fill_stats_bufsize_data(skb, stats, tech,
+					   SMC_NLA_STATS_T_RX_RMB_SIZE))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_CLNT_V1_SUCC,
+			      smc_tech->clnt_v1_succ_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_CLNT_V2_SUCC,
+			      smc_tech->clnt_v2_succ_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_SRV_V1_SUCC,
+			      smc_tech->srv_v1_succ_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_SRV_V2_SUCC,
+			      smc_tech->srv_v2_succ_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_RX_BYTES,
+			      smc_tech->rx_bytes,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_TX_BYTES,
+			      smc_tech->tx_bytes,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_RX_CNT,
+			      smc_tech->rx_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_TX_CNT,
+			      smc_tech->tx_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_SENDPAGE_CNT,
+			      smc_tech->sendpage_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_CORK_CNT,
+			      smc_tech->cork_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_NDLY_CNT,
+			      smc_tech->ndly_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_SPLICE_CNT,
+			      smc_tech->splice_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_URG_DATA_CNT,
+			      smc_tech->urg_data_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+
+	nla_nest_end(skb, attrs);
+	return 0;
+
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	return -EMSGSIZE;
+}
+
+int smc_nl_get_stats(struct sk_buff *skb,
+		     struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	struct smc_stats *stats;
+	struct nlattr *attrs;
+	int cpu, i, size;
+	void *nlh;
+	u64 *src;
+	u64 *sum;
+
+	if (cb_ctx->pos[0])
+		goto errmsg;
+	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_GET_STATS);
+	if (!nlh)
+		goto errmsg;
+
+	attrs = nla_nest_start(skb, SMC_GEN_STATS);
+	if (!attrs)
+		goto errnest;
+	stats = kzalloc(sizeof(*stats), GFP_KERNEL);
+	if (!stats)
+		goto erralloc;
+	size = sizeof(*stats) / sizeof(u64);
+	for_each_possible_cpu(cpu) {
+		src = (u64 *)per_cpu_ptr(smc_stats, cpu);
+		sum = (u64 *)stats;
+		for (i = 0; i < size; i++)
+			*(sum++) += *(src++);
+	}
+	if (smc_nl_fill_stats_tech_data(skb, stats, SMC_TYPE_D))
+		goto errattr;
+	if (smc_nl_fill_stats_tech_data(skb, stats, SMC_TYPE_R))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_CLNT_HS_ERR_CNT,
+			      stats->clnt_hshake_err_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_SRV_HS_ERR_CNT,
+			      stats->srv_hshake_err_cnt,
+			      SMC_NLA_STATS_PAD))
+		goto errattr;
+
+	nla_nest_end(skb, attrs);
+	genlmsg_end(skb, nlh);
+	cb_ctx->pos[0] = 1;
+	kfree(stats);
+	return skb->len;
+
+errattr:
+	kfree(stats);
+erralloc:
+	nla_nest_cancel(skb, attrs);
+errnest:
+	genlmsg_cancel(skb, nlh);
+errmsg:
+	return skb->len;
+}
diff --git a/net/smc/smc_stats.h b/net/smc/smc_stats.h
index 928372114cf1..84baaca59eaf 100644
--- a/net/smc/smc_stats.h
+++ b/net/smc/smc_stats.h
@@ -247,6 +247,7 @@ do { \
 } \
 while (0)
 
+int smc_nl_get_stats(struct sk_buff *skb, struct netlink_callback *cb);
 int smc_stats_init(void) __init;
 void smc_stats_exit(void);
 
-- 
2.25.1

