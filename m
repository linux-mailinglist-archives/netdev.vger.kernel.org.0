Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1DF430196
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 11:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbhJPJkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 05:40:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29096 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243955AbhJPJki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 05:40:38 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19G7i8ck013309;
        Sat, 16 Oct 2021 05:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=feRCSBy57lYmEWN9LvNoBsv7wKPhZaA5EFLRsz2ZWr0=;
 b=qctmidL+osokq7ILjjWLKGQl2o+DaN815JeBgwWuis0x2+AIZQRJpGhhx+z1Y94JcNY+
 0P7F60U7RZuaSZ7nd1PjU5kkWiG4XV2WF922h9i6cMwdEZZawTeou/BS6Tp5d2gP0vfb
 0q/Av2o5kXmB/gwFWPliz1+efNEBr+EKJjqQ+G8WNrlN++/mvP7Zjnm6InpXPKxwCLqz
 CfnreuKVMR5e9S31lCnyvu0R5FEKW9m93hTcD62czpB91QutWCR7JeVU9xl+2JMJmwvQ
 GCkfQAU83c8IskMTTDb8BxHcu1yt+ZpSgtxPztESRH44OTnRH7SogoCgRBTbCN0pBw+x TQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bqtkxsp2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 05:38:27 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19G9bspw011805;
        Sat, 16 Oct 2021 09:38:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpc9sae6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 09:38:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19G9cNH551839302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Oct 2021 09:38:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3D8B4C04A;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7747E4C044;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 02/10] net/smc: prepare for SMC-Rv2 connection
Date:   Sat, 16 Oct 2021 11:37:44 +0200
Message-Id: <20211016093752.3564615-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211016093752.3564615-1-kgraul@linux.ibm.com>
References: <20211016093752.3564615-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JDpcdvLbIpuvIpSoykStOJfXLWXnE6wa
X-Proofpoint-GUID: JDpcdvLbIpuvIpSoykStOJfXLWXnE6wa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-16_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110160058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare the connection establishment with SMC-Rv2. Detect eligible
RoCE cards and indicate all supported SMC modes for the connection.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 97 +++++++++++++++++++++++++++++-----------------
 net/smc/smc_clc.c  | 11 ++++++
 net/smc/smc_clc.h  | 12 ++++++
 net/smc/smc_core.h | 28 +++++++++++++
 4 files changed, 113 insertions(+), 35 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f69ef3f2019f..f21e74537f53 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -608,7 +608,9 @@ static int smc_find_rdma_device(struct smc_sock *smc, struct smc_init_info *ini)
 	 * used for the internal TCP socket
 	 */
 	smc_pnet_find_roce_resource(smc->clcsock->sk, ini);
-	if (!ini->ib_dev)
+	if (!ini->check_smcrv2 && !ini->ib_dev)
+		return SMC_CLC_DECL_NOSMCRDEV;
+	if (ini->check_smcrv2 && !ini->smcrv2.ib_dev_v2)
 		return SMC_CLC_DECL_NOSMCRDEV;
 	return 0;
 }
@@ -692,27 +694,42 @@ static int smc_find_proposal_devices(struct smc_sock *smc,
 	int rc = 0;
 
 	/* check if there is an ism device available */
-	if (ini->smcd_version & SMC_V1) {
-		if (smc_find_ism_device(smc, ini) ||
-		    smc_connect_ism_vlan_setup(smc, ini)) {
-			if (ini->smc_type_v1 == SMC_TYPE_B)
-				ini->smc_type_v1 = SMC_TYPE_R;
-			else
-				ini->smc_type_v1 = SMC_TYPE_N;
-		} /* else ISM V1 is supported for this connection */
-		if (smc_find_rdma_device(smc, ini)) {
-			if (ini->smc_type_v1 == SMC_TYPE_B)
-				ini->smc_type_v1 = SMC_TYPE_D;
-			else
-				ini->smc_type_v1 = SMC_TYPE_N;
-		} /* else RDMA is supported for this connection */
-	}
-	if (smc_ism_is_v2_capable() && smc_find_ism_v2_device_clnt(smc, ini))
-		ini->smc_type_v2 = SMC_TYPE_N;
+	if (!(ini->smcd_version & SMC_V1) ||
+	    smc_find_ism_device(smc, ini) ||
+	    smc_connect_ism_vlan_setup(smc, ini))
+		ini->smcd_version &= ~SMC_V1;
+	/* else ISM V1 is supported for this connection */
+
+	/* check if there is an rdma device available */
+	if (!(ini->smcr_version & SMC_V1) ||
+	    smc_find_rdma_device(smc, ini))
+		ini->smcr_version &= ~SMC_V1;
+	/* else RDMA is supported for this connection */
+
+	ini->smc_type_v1 = smc_indicated_type(ini->smcd_version & SMC_V1,
+					      ini->smcr_version & SMC_V1);
+
+	/* check if there is an ism v2 device available */
+	if (!(ini->smcd_version & SMC_V2) ||
+	    !smc_ism_is_v2_capable() ||
+	    smc_find_ism_v2_device_clnt(smc, ini))
+		ini->smcd_version &= ~SMC_V2;
+
+	/* check if there is an rdma v2 device available */
+	ini->check_smcrv2 = true;
+	ini->smcrv2.saddr = smc->clcsock->sk->sk_rcv_saddr;
+	if (!(ini->smcr_version & SMC_V2) ||
+	    smc->clcsock->sk->sk_family != AF_INET ||
+	    !smc_clc_ueid_count() ||
+	    smc_find_rdma_device(smc, ini))
+		ini->smcr_version &= ~SMC_V2;
+	ini->check_smcrv2 = false;
+
+	ini->smc_type_v2 = smc_indicated_type(ini->smcd_version & SMC_V2,
+					      ini->smcr_version & SMC_V2);
 
 	/* if neither ISM nor RDMA are supported, fallback */
-	if (!smcr_indicated(ini->smc_type_v1) &&
-	    ini->smc_type_v1 == SMC_TYPE_N && ini->smc_type_v2 == SMC_TYPE_N)
+	if (ini->smc_type_v1 == SMC_TYPE_N && ini->smc_type_v2 == SMC_TYPE_N)
 		rc = SMC_CLC_DECL_NOSMCDEV;
 
 	return rc;
@@ -950,17 +967,24 @@ static int smc_connect_ism(struct smc_sock *smc,
 static int smc_connect_check_aclc(struct smc_init_info *ini,
 				  struct smc_clc_msg_accept_confirm *aclc)
 {
-	if ((aclc->hdr.typev1 == SMC_TYPE_R &&
-	     !smcr_indicated(ini->smc_type_v1)) ||
-	    (aclc->hdr.typev1 == SMC_TYPE_D &&
-	     ((!smcd_indicated(ini->smc_type_v1) &&
-	       !smcd_indicated(ini->smc_type_v2)) ||
-	      (aclc->hdr.version == SMC_V1 &&
-	       !smcd_indicated(ini->smc_type_v1)) ||
-	      (aclc->hdr.version == SMC_V2 &&
-	       !smcd_indicated(ini->smc_type_v2)))))
+	if (aclc->hdr.typev1 != SMC_TYPE_R &&
+	    aclc->hdr.typev1 != SMC_TYPE_D)
 		return SMC_CLC_DECL_MODEUNSUPP;
 
+	if (aclc->hdr.version >= SMC_V2) {
+		if ((aclc->hdr.typev1 == SMC_TYPE_R &&
+		     !smcr_indicated(ini->smc_type_v2)) ||
+		    (aclc->hdr.typev1 == SMC_TYPE_D &&
+		     !smcd_indicated(ini->smc_type_v2)))
+			return SMC_CLC_DECL_MODEUNSUPP;
+	} else {
+		if ((aclc->hdr.typev1 == SMC_TYPE_R &&
+		     !smcr_indicated(ini->smc_type_v1)) ||
+		    (aclc->hdr.typev1 == SMC_TYPE_D &&
+		     !smcd_indicated(ini->smc_type_v1)))
+			return SMC_CLC_DECL_MODEUNSUPP;
+	}
+
 	return 0;
 }
 
@@ -991,14 +1015,15 @@ static int __smc_connect(struct smc_sock *smc)
 		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_MEM,
 						    version);
 
-	ini->smcd_version = SMC_V1;
-	ini->smcd_version |= smc_ism_is_v2_capable() ? SMC_V2 : 0;
+	ini->smcd_version = SMC_V1 | SMC_V2;
+	ini->smcr_version = SMC_V1 | SMC_V2;
 	ini->smc_type_v1 = SMC_TYPE_B;
-	ini->smc_type_v2 = smc_ism_is_v2_capable() ? SMC_TYPE_D : SMC_TYPE_N;
+	ini->smc_type_v2 = SMC_TYPE_B;
 
 	/* get vlan id from IP device */
 	if (smc_vlan_by_tcpsk(smc->clcsock, ini)) {
 		ini->smcd_version &= ~SMC_V1;
+		ini->smcr_version = 0;
 		ini->smc_type_v1 = SMC_TYPE_N;
 		if (!ini->smcd_version) {
 			rc = SMC_CLC_DECL_GETVLANERR;
@@ -1026,15 +1051,17 @@ static int __smc_connect(struct smc_sock *smc)
 	/* check if smc modes and versions of CLC proposal and accept match */
 	rc = smc_connect_check_aclc(ini, aclc);
 	version = aclc->hdr.version == SMC_V1 ? SMC_V1 : SMC_V2;
-	ini->smcd_version = version;
 	if (rc)
 		goto vlan_cleanup;
 
 	/* depending on previous steps, connect using rdma or ism */
-	if (aclc->hdr.typev1 == SMC_TYPE_R)
+	if (aclc->hdr.typev1 == SMC_TYPE_R) {
+		ini->smcr_version = version;
 		rc = smc_connect_rdma(smc, aclc, ini);
-	else if (aclc->hdr.typev1 == SMC_TYPE_D)
+	} else if (aclc->hdr.typev1 == SMC_TYPE_D) {
+		ini->smcd_version = version;
 		rc = smc_connect_ism(smc, aclc, ini);
+	}
 	if (rc)
 		goto vlan_cleanup;
 
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 1cc8a76b39f9..8d44f06cf401 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -114,6 +114,17 @@ static int smc_clc_ueid_add(char *ueid)
 	return rc;
 }
 
+int smc_clc_ueid_count(void)
+{
+	int count;
+
+	read_lock(&smc_clc_eid_table.lock);
+	count = smc_clc_eid_table.ueid_cnt;
+	read_unlock(&smc_clc_eid_table.lock);
+
+	return count;
+}
+
 int smc_nl_add_ueid(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *nla_ueid = info->attrs[SMC_NLA_EID_TABLE_ENTRY];
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 974d01d16bb5..37ce97f7fdb0 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -282,6 +282,17 @@ static inline bool smcd_indicated(int smc_type)
 	return smc_type == SMC_TYPE_D || smc_type == SMC_TYPE_B;
 }
 
+static inline u8 smc_indicated_type(int is_smcd, int is_smcr)
+{
+	if (is_smcd && is_smcr)
+		return SMC_TYPE_B;
+	if (is_smcd)
+		return SMC_TYPE_D;
+	if (is_smcr)
+		return SMC_TYPE_R;
+	return SMC_TYPE_N;
+}
+
 /* get SMC-D info from proposal message */
 static inline struct smc_clc_msg_smcd *
 smc_get_clc_msg_smcd(struct smc_clc_msg_proposal *prop)
@@ -343,6 +354,7 @@ void smc_clc_get_hostname(u8 **host);
 bool smc_clc_match_eid(u8 *negotiated_eid,
 		       struct smc_clc_v2_extension *smc_v2_ext,
 		       u8 *peer_eid, u8 *local_eid);
+int smc_clc_ueid_count(void);
 int smc_nl_dump_ueid(struct sk_buff *skb, struct netlink_callback *cb);
 int smc_nl_add_ueid(struct sk_buff *skb, struct genl_info *info);
 int smc_nl_remove_ueid(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 83d30b06016f..4a1778a7e3a5 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -302,6 +302,31 @@ struct smc_link_group {
 
 struct smc_clc_msg_local;
 
+#define GID_LIST_SIZE	2
+
+struct smc_gidlist {
+	u8			len;
+	u8			list[GID_LIST_SIZE][SMC_GID_SIZE];
+};
+
+struct smc_init_info_smcrv2 {
+	/* Input fields */
+	__be32			saddr;
+	struct sock		*clc_sk;
+	__be32			daddr;
+
+	/* Output fields when saddr is set */
+	struct smc_ib_device	*ib_dev_v2;
+	u8			ib_port_v2;
+	u8			ib_gid_v2[SMC_GID_SIZE];
+
+	/* Additional output fields when clc_sk and daddr is set as well */
+	u8			uses_gateway;
+	u8			nexthop_mac[ETH_ALEN];
+
+	struct smc_gidlist	gidlist;
+};
+
 struct smc_init_info {
 	u8			is_smcd;
 	u8			smc_type_v1;
@@ -313,10 +338,13 @@ struct smc_init_info {
 	u8			negotiated_eid[SMC_MAX_EID_LEN];
 	/* SMC-R */
 	struct smc_clc_msg_local *ib_lcl;
+	u8			smcr_version;
+	u8			check_smcrv2;
 	struct smc_ib_device	*ib_dev;
 	u8			ib_gid[SMC_GID_SIZE];
 	u8			ib_port;
 	u32			ib_clcqpn;
+	struct smc_init_info_smcrv2 smcrv2;
 	/* SMC-D */
 	u64			ism_peer_gid[SMC_MAX_ISM_DEVS + 1];
 	struct smcd_dev		*ism_dev[SMC_MAX_ISM_DEVS + 1];
-- 
2.25.1

