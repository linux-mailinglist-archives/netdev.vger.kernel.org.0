Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C5942A1DB
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbhJLKUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:20:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235881AbhJLKUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:20:32 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CA5UvA025429;
        Tue, 12 Oct 2021 06:18:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2fm21ng6YUIsZbIKrHKyZuYMZM8Glw0Jdl+34st5ft0=;
 b=q/V4q5wrMJmNiHAla5aAl66tTCWrKOR2fG1Bbgwk98Ubim5YMYs7GpzsfUj6TR+3ltoP
 iNuGTvWx9+Zo3XuU3Q7Zjlb8UzNgSSKariVrGWJh2vAWpjjxqkIqeCo4zPa4V8Y9ECTs
 O9hjHubCmwrUp+5EllAGfp8Nja4edwRRZ0NKI5VNEQJQz7ybRPqnUjIo/TEhUhy6pmqI
 QOp1zenY+/yEGDa6MbTv9oGwawO84rRWDmCBT0iybX8VmIwcvhFpMbBnT2aOwXOA/fF8
 OhrfVpuVv2zV1kwCkYHLugyG0bwZIeyFf7Hxn4dTXfJiO68ppJ65ULJzIOQm0/gkqEsb 3A== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn5rtus0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 06:18:30 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CABNvp018618;
        Tue, 12 Oct 2021 10:18:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3bk2q9dckk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 10:18:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CAClww46203330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 10:12:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BC0AAE051;
        Tue, 12 Oct 2021 10:18:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 590BAAE063;
        Tue, 12 Oct 2021 10:18:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 10:18:20 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH net-next 10/11] net/smc: add netlink support for SMC-Rv2
Date:   Tue, 12 Oct 2021 12:17:42 +0200
Message-Id: <20211012101743.2282031-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012101743.2282031-1-kgraul@linux.ibm.com>
References: <20211012101743.2282031-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1d1zgeQTtInztdWtbsCpQYgX38sNloSU
X-Proofpoint-ORIG-GUID: 1d1zgeQTtInztdWtbsCpQYgX38sNloSU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_02,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 spamscore=0 suspectscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the netlink support for SMC-Rv2 related attributes that are
provided to user space.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h | 17 ++++++-
 net/smc/smc_core.c       | 98 ++++++++++++++++++++++++++++++----------
 2 files changed, 88 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index b175bd0165a1..20f33b27787f 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -84,17 +84,28 @@ enum {
 	SMC_NLA_SYS_IS_ISM_V2,		/* u8 */
 	SMC_NLA_SYS_LOCAL_HOST,		/* string */
 	SMC_NLA_SYS_SEID,		/* string */
+	SMC_NLA_SYS_IS_SMCR_V2,		/* u8 */
 	__SMC_NLA_SYS_MAX,
 	SMC_NLA_SYS_MAX = __SMC_NLA_SYS_MAX - 1
 };
 
-/* SMC_NLA_LGR_V2 nested attributes */
+/* SMC_NLA_LGR_D_V2_COMMON and SMC_NLA_LGR_R_V2_COMMON nested attributes */
 enum {
 	SMC_NLA_LGR_V2_VER,		/* u8 */
 	SMC_NLA_LGR_V2_REL,		/* u8 */
 	SMC_NLA_LGR_V2_OS,		/* u8 */
 	SMC_NLA_LGR_V2_NEG_EID,		/* string */
 	SMC_NLA_LGR_V2_PEER_HOST,	/* string */
+	__SMC_NLA_LGR_V2_MAX,
+	SMC_NLA_LGR_V2_MAX = __SMC_NLA_LGR_V2_MAX - 1
+};
+
+/* SMC_NLA_LGR_R_V2 nested attributes */
+enum {
+	SMC_NLA_LGR_R_V2_UNSPEC,
+	SMC_NLA_LGR_R_V2_DIRECT,	/* u8 */
+	__SMC_NLA_LGR_R_V2_MAX,
+	SMC_NLA_LGR_R_V2_MAX = __SMC_NLA_LGR_R_V2_MAX - 1
 };
 
 /* SMC_GEN_LGR_SMCR attributes */
@@ -106,6 +117,8 @@ enum {
 	SMC_NLA_LGR_R_PNETID,		/* string */
 	SMC_NLA_LGR_R_VLAN_ID,		/* u8 */
 	SMC_NLA_LGR_R_CONNS_NUM,	/* u32 */
+	SMC_NLA_LGR_R_V2_COMMON,	/* nest */
+	SMC_NLA_LGR_R_V2,		/* nest */
 	__SMC_NLA_LGR_R_MAX,
 	SMC_NLA_LGR_R_MAX = __SMC_NLA_LGR_R_MAX - 1
 };
@@ -138,7 +151,7 @@ enum {
 	SMC_NLA_LGR_D_PNETID,		/* string */
 	SMC_NLA_LGR_D_CHID,		/* u16 */
 	SMC_NLA_LGR_D_PAD,		/* flag */
-	SMC_NLA_LGR_V2,			/* nest */
+	SMC_NLA_LGR_D_V2_COMMON,	/* nest */
 	__SMC_NLA_LGR_D_MAX,
 	SMC_NLA_LGR_D_MAX = __SMC_NLA_LGR_D_MAX - 1
 };
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 1ccab993683d..8e642f8f334f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -244,6 +244,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_SYS_IS_ISM_V2, smc_ism_is_v2_capable()))
 		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_SYS_IS_SMCR_V2, true))
+		goto errattr;
 	smc_clc_get_hostname(&host);
 	if (host) {
 		memcpy(hostname, host, SMC_MAX_HOSTNAME_LEN);
@@ -271,12 +273,65 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+/* Fill SMC_NLA_LGR_D_V2_COMMON/SMC_NLA_LGR_R_V2_COMMON nested attributes */
+static int smc_nl_fill_lgr_v2_common(struct smc_link_group *lgr,
+				     struct sk_buff *skb,
+				     struct netlink_callback *cb,
+				     struct nlattr *v2_attrs)
+{
+	char smc_host[SMC_MAX_HOSTNAME_LEN + 1];
+	char smc_eid[SMC_MAX_EID_LEN + 1];
+
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_VER, lgr->smc_version))
+		goto errv2attr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_REL, lgr->peer_smc_release))
+		goto errv2attr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_V2_OS, lgr->peer_os))
+		goto errv2attr;
+	memcpy(smc_host, lgr->peer_hostname, SMC_MAX_HOSTNAME_LEN);
+	smc_host[SMC_MAX_HOSTNAME_LEN] = 0;
+	if (nla_put_string(skb, SMC_NLA_LGR_V2_PEER_HOST, smc_host))
+		goto errv2attr;
+	memcpy(smc_eid, lgr->negotiated_eid, SMC_MAX_EID_LEN);
+	smc_eid[SMC_MAX_EID_LEN] = 0;
+	if (nla_put_string(skb, SMC_NLA_LGR_V2_NEG_EID, smc_eid))
+		goto errv2attr;
+
+	nla_nest_end(skb, v2_attrs);
+	return 0;
+
+errv2attr:
+	nla_nest_cancel(skb, v2_attrs);
+	return -EMSGSIZE;
+}
+
+static int smc_nl_fill_smcr_lgr_v2(struct smc_link_group *lgr,
+				   struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nlattr *v2_attrs;
+
+	v2_attrs = nla_nest_start(skb, SMC_NLA_LGR_R_V2);
+	if (!v2_attrs)
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_R_V2_DIRECT, !lgr->uses_gateway))
+		goto errv2attr;
+
+	nla_nest_end(skb, v2_attrs);
+	return 0;
+
+errv2attr:
+	nla_nest_cancel(skb, v2_attrs);
+errattr:
+	return -EMSGSIZE;
+}
+
 static int smc_nl_fill_lgr(struct smc_link_group *lgr,
 			   struct sk_buff *skb,
 			   struct netlink_callback *cb)
 {
 	char smc_target[SMC_MAX_PNETID_LEN + 1];
-	struct nlattr *attrs;
+	struct nlattr *attrs, *v2_attrs;
 
 	attrs = nla_nest_start(skb, SMC_GEN_LGR_SMCR);
 	if (!attrs)
@@ -296,6 +351,15 @@ static int smc_nl_fill_lgr(struct smc_link_group *lgr,
 	smc_target[SMC_MAX_PNETID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_LGR_R_PNETID, smc_target))
 		goto errattr;
+	if (lgr->smc_version > SMC_V1) {
+		v2_attrs = nla_nest_start(skb, SMC_NLA_LGR_R_V2_COMMON);
+		if (!v2_attrs)
+			goto errattr;
+		if (smc_nl_fill_lgr_v2_common(lgr, skb, cb, v2_attrs))
+			goto errattr;
+		if (smc_nl_fill_smcr_lgr_v2(lgr, skb, cb))
+			goto errattr;
+	}
 
 	nla_nest_end(skb, attrs);
 	return 0;
@@ -428,10 +492,7 @@ static int smc_nl_fill_smcd_lgr(struct smc_link_group *lgr,
 				struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
-	char smc_host[SMC_MAX_HOSTNAME_LEN + 1];
 	char smc_pnet[SMC_MAX_PNETID_LEN + 1];
-	char smc_eid[SMC_MAX_EID_LEN + 1];
-	struct nlattr *v2_attrs;
 	struct nlattr *attrs;
 	void *nlh;
 
@@ -463,32 +524,19 @@ static int smc_nl_fill_smcd_lgr(struct smc_link_group *lgr,
 	smc_pnet[SMC_MAX_PNETID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_LGR_D_PNETID, smc_pnet))
 		goto errattr;
+	if (lgr->smc_version > SMC_V1) {
+		struct nlattr *v2_attrs;
 
-	v2_attrs = nla_nest_start(skb, SMC_NLA_LGR_V2);
-	if (!v2_attrs)
-		goto errattr;
-	if (nla_put_u8(skb, SMC_NLA_LGR_V2_VER, lgr->smc_version))
-		goto errv2attr;
-	if (nla_put_u8(skb, SMC_NLA_LGR_V2_REL, lgr->peer_smc_release))
-		goto errv2attr;
-	if (nla_put_u8(skb, SMC_NLA_LGR_V2_OS, lgr->peer_os))
-		goto errv2attr;
-	memcpy(smc_host, lgr->peer_hostname, SMC_MAX_HOSTNAME_LEN);
-	smc_host[SMC_MAX_HOSTNAME_LEN] = 0;
-	if (nla_put_string(skb, SMC_NLA_LGR_V2_PEER_HOST, smc_host))
-		goto errv2attr;
-	memcpy(smc_eid, lgr->negotiated_eid, SMC_MAX_EID_LEN);
-	smc_eid[SMC_MAX_EID_LEN] = 0;
-	if (nla_put_string(skb, SMC_NLA_LGR_V2_NEG_EID, smc_eid))
-		goto errv2attr;
-
-	nla_nest_end(skb, v2_attrs);
+		v2_attrs = nla_nest_start(skb, SMC_NLA_LGR_D_V2_COMMON);
+		if (!v2_attrs)
+			goto errattr;
+		if (smc_nl_fill_lgr_v2_common(lgr, skb, cb, v2_attrs))
+			goto errattr;
+	}
 	nla_nest_end(skb, attrs);
 	genlmsg_end(skb, nlh);
 	return 0;
 
-errv2attr:
-	nla_nest_cancel(skb, v2_attrs);
 errattr:
 	nla_nest_cancel(skb, attrs);
 errout:
-- 
2.25.1

