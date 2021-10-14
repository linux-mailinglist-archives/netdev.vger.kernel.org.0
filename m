Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F7A42DFA6
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhJNQvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:51:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233309AbhJNQuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:50:52 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EGaWuU001277;
        Thu, 14 Oct 2021 12:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2fm21ng6YUIsZbIKrHKyZuYMZM8Glw0Jdl+34st5ft0=;
 b=Un0zDETsA0j1mgtRHOW3twHFrZpQZaFTqCkUq++yE0t/rp3UDHq2eMXOQrKl/6Zo1C7A
 3lo0sAf/O4TrfXw53lLDntAlC3vjbQijqf8SCn505Akf5BLSRNlNVVzoeza0qtMIBij8
 NZL75rj/vwOeGlJ4FjbUyFj5uFylPdYSl4gPzz8I9ilJ71TkYiVi+Aerg1+LR+fJq+g6
 2QC2Zs3hib/S17NABQqyZH0rnfTsozprTsdskwQbMc3t2kyZufsOCBEdVblZIQy/ox9E
 lawLfiRj9A3BK/4wpbLU4qu83ZNagNyuAAWy12kAIohWBtfvtK4z1Mwlt03Gd/Gc1CLP jg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnrndw3q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 12:48:44 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EGbp19019010;
        Thu, 14 Oct 2021 16:48:42 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3bk2qacevp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 16:48:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EGgxVL47776092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 16:42:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E41F3A405B;
        Thu, 14 Oct 2021 16:48:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACB6CA4065;
        Thu, 14 Oct 2021 16:48:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 16:48:39 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2 10/11] net/smc: add netlink support for SMC-Rv2
Date:   Thu, 14 Oct 2021 18:47:51 +0200
Message-Id: <20211014164752.3647027-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211014164752.3647027-1-kgraul@linux.ibm.com>
References: <20211014164752.3647027-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lYyCUiX85R72_ToqbvcU-tNYtmK2me3M
X-Proofpoint-ORIG-GUID: lYyCUiX85R72_ToqbvcU-tNYtmK2me3M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140095
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

