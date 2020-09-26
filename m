Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2227988B
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgIZKp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7476 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727499AbgIZKo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:56 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAX2i0027065;
        Sat, 26 Sep 2020 06:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=LyWybE96pyLnqmn8ooX8wgIQ+Ws43iTQQ0MAk6Qy20Q=;
 b=pxuAmDflshgp2RDDWRtdSRG9X3eCFGdKPerSjQCQxwciZPVngTTBtPvxQr3Wv+rRobpB
 HrSMpWvPPHgX/Nr3AiHK4Qc8CiAD9mmyE+he4omRb0gqeWVsL5w4DIMIEERIMOitqth0
 yK0ocaHdzSwqu8Yw1eo4Ek10BXM/B4OIyGi26pOMDdch44U3a5jHIfxyBV2AM6VR4ZWv
 7ZwrTachRXWObqPvnwQJSDcyC9yHKqES6yhTTXK6BIgsqpKU/upaEBRcUOcIx64O02t9
 XbF5MOVs6TEXXzBLYg2gAlgrIHqxuHxqmZyh577g9gMVMwF+1YSpY3ol+ey/Dp/Y9Qlc IQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t3yg862j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:52 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgwkQ025689;
        Sat, 26 Sep 2020 10:44:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 33sw9884p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAil4w15663436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C02ECA405B;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8182DA405F;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 10/14] net/smc: build and send V2 CLC proposal
Date:   Sat, 26 Sep 2020 12:44:28 +0200
Message-Id: <20200926104432.74293-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009260096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

The new format of an SMCD V2 CLC proposal is introduced, and
building and checking of SMCD V2 CLC proposals is adapted
accordingly.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c  |   2 +-
 net/smc/smc.h     |   6 ++
 net/smc/smc_clc.c | 171 ++++++++++++++++++++++++++++++++++++----------
 net/smc/smc_clc.h |  73 ++++++++++++++++++--
 4 files changed, 210 insertions(+), 42 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 1d01a01c7fd5..10374673f75f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1301,7 +1301,7 @@ static void smc_find_ism_device_serv(struct smc_sock *new_smc,
 	if (!smcd_indicated(pclc->hdr.typev1))
 		goto not_found;
 	ini->is_smcd = true; /* prepare ISM check */
-	ini->ism_peer_gid[0] = pclc_smcd->gid;
+	ini->ism_peer_gid[0] = ntohll(pclc_smcd->ism.gid);
 	if (smc_find_ism_device(new_smc, ini))
 		goto not_found;
 	if (!smc_listen_ism_init(new_smc, ini))
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 0b9c904e2282..a1e480a3ec43 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -20,6 +20,7 @@
 
 #define SMC_V1		1		/* SMC version V1 */
 #define SMC_V2		2		/* SMC version V2 */
+#define SMC_RELEASE	0
 
 #define SMCPROTO_SMC		0	/* SMC protocol, IPv4 */
 #define SMCPROTO_SMC6		1	/* SMC protocol, IPv6 */
@@ -28,6 +29,8 @@
 					 * devices
 					 */
 
+#define SMC_MAX_EID_LEN		32
+
 extern struct proto smc_proto;
 extern struct proto smc_proto6;
 
@@ -251,6 +254,9 @@ extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
 extern u8	local_systemid[SMC_SYSTEMID_LEN]; /* unique system identifier */
 
+#define ntohll(x) be64_to_cpu(x)
+#define htonll(x) cpu_to_be64(x)
+
 /* convert an u32 value into network byte order, store it into a 3 byte field */
 static inline void hton24(u8 *net, u32 host)
 {
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 26f1cdd35cb1..037c92a0c2b9 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -34,12 +34,52 @@ static const char SMC_EYECATCHER[4] = {'\xe2', '\xd4', '\xc3', '\xd9'};
 /* eye catcher "SMCD" EBCDIC for CLC messages */
 static const char SMCD_EYECATCHER[4] = {'\xe2', '\xd4', '\xc3', '\xc4'};
 
+/* check arriving CLC proposal */
+static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
+{
+	struct smc_clc_msg_proposal_prefix *pclc_prfx;
+	struct smc_clc_smcd_v2_extension *smcd_v2_ext;
+	struct smc_clc_msg_hdr *hdr = &pclc->hdr;
+	struct smc_clc_v2_extension *v2_ext;
+
+	v2_ext = smc_get_clc_v2_ext(pclc);
+	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
+	if (hdr->version == SMC_V1) {
+		if (hdr->typev1 == SMC_TYPE_N)
+			return false;
+		if (ntohs(hdr->length) !=
+			sizeof(*pclc) + ntohs(pclc->iparea_offset) +
+			sizeof(*pclc_prfx) +
+			pclc_prfx->ipv6_prefixes_cnt *
+				sizeof(struct smc_clc_ipv6_prefix) +
+			sizeof(struct smc_clc_msg_trail))
+			return false;
+	} else {
+		if (ntohs(hdr->length) !=
+			sizeof(*pclc) +
+			sizeof(struct smc_clc_msg_smcd) +
+			(hdr->typev1 != SMC_TYPE_N ?
+				sizeof(*pclc_prfx) +
+				pclc_prfx->ipv6_prefixes_cnt *
+				sizeof(struct smc_clc_ipv6_prefix) : 0) +
+			(hdr->typev2 != SMC_TYPE_N ?
+				sizeof(*v2_ext) +
+				v2_ext->hdr.eid_cnt * SMC_MAX_EID_LEN : 0) +
+			(smcd_indicated(hdr->typev2) ?
+				sizeof(*smcd_v2_ext) + v2_ext->hdr.ism_gid_cnt *
+					sizeof(struct smc_clc_smcd_gid_chid) :
+				0) +
+			sizeof(struct smc_clc_msg_trail))
+			return false;
+	}
+	return true;
+}
+
 /* check if received message has a correct header length and contains valid
  * heading and trailing eyecatchers
  */
 static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
 {
-	struct smc_clc_msg_proposal_prefix *pclc_prfx;
 	struct smc_clc_msg_accept_confirm *clc;
 	struct smc_clc_msg_proposal *pclc;
 	struct smc_clc_msg_decline *dclc;
@@ -51,13 +91,7 @@ static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
 	switch (clcm->type) {
 	case SMC_CLC_PROPOSAL:
 		pclc = (struct smc_clc_msg_proposal *)clcm;
-		pclc_prfx = smc_clc_proposal_get_prefix(pclc);
-		if (ntohs(pclc->hdr.length) <
-			sizeof(*pclc) + ntohs(pclc->iparea_offset) +
-			sizeof(*pclc_prfx) +
-			pclc_prfx->ipv6_prefixes_cnt *
-				sizeof(struct smc_clc_ipv6_prefix) +
-			sizeof(*trl))
+		if (!smc_clc_msg_prop_valid(pclc))
 			return false;
 		trl = (struct smc_clc_msg_trail *)
 			((u8 *)pclc + ntohs(pclc->hdr.length) - sizeof(*trl));
@@ -327,9 +361,6 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		goto out;
 	}
 
-	if (clcm->type == SMC_CLC_PROPOSAL && clcm->typev1 == SMC_TYPE_N)
-		reason_code = SMC_CLC_DECL_VERSMISMAT; /* just V2 offered */
-
 	/* receive the complete CLC message */
 	memset(&msg, 0, sizeof(struct msghdr));
 	if (datlen > buflen) {
@@ -412,15 +443,18 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 /* send CLC PROPOSAL message across internal TCP socket */
 int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 {
+	struct smc_clc_smcd_v2_extension *smcd_v2_ext;
 	struct smc_clc_msg_proposal_prefix *pclc_prfx;
 	struct smc_clc_msg_proposal *pclc_base;
+	struct smc_clc_smcd_gid_chid *gidchids;
 	struct smc_clc_msg_proposal_area *pclc;
 	struct smc_clc_ipv6_prefix *ipv6_prfx;
+	struct smc_clc_v2_extension *v2_ext;
 	struct smc_clc_msg_smcd *pclc_smcd;
 	struct smc_clc_msg_trail *trl;
 	int len, i, plen, rc;
 	int reason_code = 0;
-	struct kvec vec[5];
+	struct kvec vec[8];
 	struct msghdr msg;
 
 	pclc = kzalloc(sizeof(*pclc), GFP_KERNEL);
@@ -431,24 +465,37 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 	pclc_smcd = &pclc->pclc_smcd;
 	pclc_prfx = &pclc->pclc_prfx;
 	ipv6_prfx = pclc->pclc_prfx_ipv6;
+	v2_ext = &pclc->pclc_v2_ext;
+	smcd_v2_ext = &pclc->pclc_smcd_v2_ext;
+	gidchids = pclc->pclc_gidchids;
 	trl = &pclc->pclc_trl;
 
+	pclc_base->hdr.version = SMC_V2;
+	pclc_base->hdr.typev1 = ini->smc_type_v1;
+	pclc_base->hdr.typev2 = ini->smc_type_v2;
+	plen = sizeof(*pclc_base) + sizeof(*pclc_smcd) + sizeof(*trl);
+
 	/* retrieve ip prefixes for CLC proposal msg */
-	rc = smc_clc_prfx_set(smc->clcsock, pclc_prfx, ipv6_prfx);
-	if (rc) {
-		kfree(pclc);
-		return SMC_CLC_DECL_CNFERR; /* configuration error */
+	if (ini->smc_type_v1 != SMC_TYPE_N) {
+		rc = smc_clc_prfx_set(smc->clcsock, pclc_prfx, ipv6_prfx);
+		if (rc) {
+			if (ini->smc_type_v2 == SMC_TYPE_N) {
+				kfree(pclc);
+				return SMC_CLC_DECL_CNFERR;
+			}
+			pclc_base->hdr.typev1 = SMC_TYPE_N;
+		} else {
+			pclc_base->iparea_offset = htons(sizeof(*pclc_smcd));
+			plen += sizeof(*pclc_prfx) +
+					pclc_prfx->ipv6_prefixes_cnt *
+					sizeof(ipv6_prfx[0]);
+		}
 	}
 
-	/* send SMC Proposal CLC message */
-	plen = sizeof(*pclc_base) + sizeof(*pclc_prfx) +
-	       (pclc_prfx->ipv6_prefixes_cnt * sizeof(ipv6_prfx[0])) +
-	       sizeof(*trl);
+	/* build SMC Proposal CLC message */
 	memcpy(pclc_base->hdr.eyecatcher, SMC_EYECATCHER,
 	       sizeof(SMC_EYECATCHER));
 	pclc_base->hdr.type = SMC_CLC_PROPOSAL;
-	pclc_base->hdr.version = SMC_V1;		/* SMC version */
-	pclc_base->hdr.typev1 = ini->smc_type_v1;
 	if (smcr_indicated(ini->smc_type_v1)) {
 		/* add SMC-R specifics */
 		memcpy(pclc_base->lcl.id_for_peer, local_systemid,
@@ -456,31 +503,83 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 		memcpy(pclc_base->lcl.gid, ini->ib_gid, SMC_GID_SIZE);
 		memcpy(pclc_base->lcl.mac, &ini->ib_dev->mac[ini->ib_port - 1],
 		       ETH_ALEN);
-		pclc_base->iparea_offset = htons(0);
 	}
 	if (smcd_indicated(ini->smc_type_v1)) {
 		/* add SMC-D specifics */
-		plen += sizeof(*pclc_smcd);
-		pclc_base->iparea_offset = htons(sizeof(*pclc_smcd));
-		pclc_smcd->gid = ini->ism_dev[0]->local_gid;
+		if (ini->ism_dev[0]) {
+			pclc_smcd->ism.gid = htonll(ini->ism_dev[0]->local_gid);
+			pclc_smcd->ism.chid =
+				htons(smc_ism_get_chid(ini->ism_dev[0]));
+		}
+	}
+	if (ini->smc_type_v2 == SMC_TYPE_N) {
+		pclc_smcd->v2_ext_offset = 0;
+	} else {
+		u16 v2_ext_offset;
+		u8 *eid = NULL;
+
+		v2_ext_offset = sizeof(*pclc_smcd) -
+			offsetofend(struct smc_clc_msg_smcd, v2_ext_offset);
+		if (ini->smc_type_v1 != SMC_TYPE_N)
+			v2_ext_offset += sizeof(*pclc_prfx) +
+						pclc_prfx->ipv6_prefixes_cnt *
+						sizeof(ipv6_prfx[0]);
+		pclc_smcd->v2_ext_offset = htons(v2_ext_offset);
+		v2_ext->hdr.eid_cnt = 0;
+		v2_ext->hdr.ism_gid_cnt = ini->ism_offered_cnt;
+		v2_ext->hdr.flag.release = SMC_RELEASE;
+		v2_ext->hdr.flag.seid = 1;
+		v2_ext->hdr.smcd_v2_ext_offset = htons(sizeof(*v2_ext) -
+				offsetofend(struct smc_clnt_opts_area_hdr,
+					    smcd_v2_ext_offset) +
+				v2_ext->hdr.eid_cnt * SMC_MAX_EID_LEN);
+		if (ini->ism_dev[0])
+			smc_ism_get_system_eid(ini->ism_dev[0], &eid);
+		else
+			smc_ism_get_system_eid(ini->ism_dev[1], &eid);
+		if (eid)
+			memcpy(smcd_v2_ext->system_eid, eid, SMC_MAX_EID_LEN);
+		plen += sizeof(*v2_ext) + sizeof(*smcd_v2_ext);
+		if (ini->ism_offered_cnt) {
+			for (i = 1; i <= ini->ism_offered_cnt; i++) {
+				gidchids[i - 1].gid =
+					htonll(ini->ism_dev[i]->local_gid);
+				gidchids[i - 1].chid =
+					htons(smc_ism_get_chid(ini->ism_dev[i]));
+			}
+			plen += ini->ism_offered_cnt *
+				sizeof(struct smc_clc_smcd_gid_chid);
+		}
 	}
 	pclc_base->hdr.length = htons(plen);
-
 	memcpy(trl->eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
+
+	/* send SMC Proposal CLC message */
 	memset(&msg, 0, sizeof(msg));
 	i = 0;
 	vec[i].iov_base = pclc_base;
 	vec[i++].iov_len = sizeof(*pclc_base);
-	if (smcd_indicated(ini->smc_type_v1)) {
-		vec[i].iov_base = pclc_smcd;
-		vec[i++].iov_len = sizeof(*pclc_smcd);
+	vec[i].iov_base = pclc_smcd;
+	vec[i++].iov_len = sizeof(*pclc_smcd);
+	if (ini->smc_type_v1 != SMC_TYPE_N) {
+		vec[i].iov_base = pclc_prfx;
+		vec[i++].iov_len = sizeof(*pclc_prfx);
+		if (pclc_prfx->ipv6_prefixes_cnt > 0) {
+			vec[i].iov_base = ipv6_prfx;
+			vec[i++].iov_len = pclc_prfx->ipv6_prefixes_cnt *
+					   sizeof(ipv6_prfx[0]);
+		}
 	}
-	vec[i].iov_base = pclc_prfx;
-	vec[i++].iov_len = sizeof(*pclc_prfx);
-	if (pclc_prfx->ipv6_prefixes_cnt > 0) {
-		vec[i].iov_base = ipv6_prfx;
-		vec[i++].iov_len = pclc_prfx->ipv6_prefixes_cnt *
-				   sizeof(ipv6_prfx[0]);
+	if (ini->smc_type_v2 != SMC_TYPE_N) {
+		vec[i].iov_base = v2_ext;
+		vec[i++].iov_len = sizeof(*v2_ext);
+		vec[i].iov_base = smcd_v2_ext;
+		vec[i++].iov_len = sizeof(*smcd_v2_ext);
+		if (ini->ism_offered_cnt) {
+			vec[i].iov_base = gidchids;
+			vec[i++].iov_len = ini->ism_offered_cnt *
+					sizeof(struct smc_clc_smcd_gid_chid);
+		}
 	}
 	vec[i].iov_base = trl;
 	vec[i++].iov_len = sizeof(*trl);
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index a3aa90bf4ad7..0157cffce62c 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -81,8 +81,6 @@ struct smc_clc_msg_local {	/* header2 of clc messages */
 	u8 mac[6];		/* mac of ib_device port */
 };
 
-#define SMC_CLC_MAX_V6_PREFIX	8
-
 /* Struct would be 4 byte aligned, but it is used in an array that is sent
  * to peers and must conform to RFC7609, hence we need to use packed here.
  */
@@ -91,6 +89,44 @@ struct smc_clc_ipv6_prefix {
 	u8 prefix_len;
 } __packed;			/* format defined in RFC7609 */
 
+#if defined(__BIG_ENDIAN_BITFIELD)
+struct smc_clc_v2_flag {
+	u8 release : 4,
+	   rsvd    : 3,
+	   seid    : 1;
+};
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+struct smc_clc_v2_flag {
+	u8 seid   : 1,
+	rsvd      : 3,
+	release   : 4;
+};
+#endif
+
+struct smc_clnt_opts_area_hdr {
+	u8 eid_cnt;		/* number of user defined EIDs */
+	u8 ism_gid_cnt;		/* number of ISMv2 GIDs */
+	u8 reserved1;
+	struct smc_clc_v2_flag flag;
+	u8 reserved2[2];
+	__be16 smcd_v2_ext_offset; /* SMC-Dv2 Extension Offset */
+};
+
+struct smc_clc_smcd_gid_chid {
+	__be64 gid;		/* ISM GID */
+	__be16 chid;		/* ISMv2 CHID */
+} __packed;		/* format defined in
+			 * IBM Shared Memory Communications Version 2
+			 * (https://www.ibm.com/support/pages/node/6326337)
+			 */
+
+struct smc_clc_v2_extension {
+	struct smc_clnt_opts_area_hdr hdr;
+	u8 roce[16];		/* RoCEv2 GID */
+	u8 reserved[16];
+	u8 user_eids[0][SMC_MAX_EID_LEN];
+};
+
 struct smc_clc_msg_proposal_prefix {	/* prefix part of clc proposal message*/
 	__be32 outgoing_subnet;	/* subnet mask */
 	u8 prefix_len;		/* number of significant bits in mask */
@@ -99,8 +135,15 @@ struct smc_clc_msg_proposal_prefix {	/* prefix part of clc proposal message*/
 } __aligned(4);
 
 struct smc_clc_msg_smcd {	/* SMC-D GID information */
-	u64 gid;		/* ISM GID of requestor */
-	u8 res[32];
+	struct smc_clc_smcd_gid_chid ism; /* ISM native GID+CHID of requestor */
+	__be16 v2_ext_offset;	/* SMC Version 2 Extension Offset */
+	u8 reserved[28];
+};
+
+struct smc_clc_smcd_v2_extension {
+	u8 system_eid[SMC_MAX_EID_LEN];
+	u8 reserved[16];
+	struct smc_clc_smcd_gid_chid gidchid[0];
 };
 
 struct smc_clc_msg_proposal {	/* clc proposal message sent by Linux */
@@ -109,11 +152,16 @@ struct smc_clc_msg_proposal {	/* clc proposal message sent by Linux */
 	__be16 iparea_offset;	/* offset to IP address information area */
 } __aligned(4);
 
+#define SMC_CLC_MAX_V6_PREFIX		8
+
 struct smc_clc_msg_proposal_area {
 	struct smc_clc_msg_proposal		pclc_base;
 	struct smc_clc_msg_smcd			pclc_smcd;
 	struct smc_clc_msg_proposal_prefix	pclc_prfx;
 	struct smc_clc_ipv6_prefix	pclc_prfx_ipv6[SMC_CLC_MAX_V6_PREFIX];
+	struct smc_clc_v2_extension		pclc_v2_ext;
+	struct smc_clc_smcd_v2_extension	pclc_smcd_v2_ext;
+	struct smc_clc_smcd_gid_chid		pclc_gidchids[SMC_MAX_ISM_DEVS];
 	struct smc_clc_msg_trail		pclc_trl;
 };
 
@@ -190,13 +238,28 @@ static inline bool smcd_indicated(int smc_type)
 static inline struct smc_clc_msg_smcd *
 smc_get_clc_msg_smcd(struct smc_clc_msg_proposal *prop)
 {
-	if (smcd_indicated(prop->hdr.type) &&
+	if (smcd_indicated(prop->hdr.typev1) &&
 	    ntohs(prop->iparea_offset) != sizeof(struct smc_clc_msg_smcd))
 		return NULL;
 
 	return (struct smc_clc_msg_smcd *)(prop + 1);
 }
 
+static inline struct smc_clc_v2_extension *
+smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
+{
+	struct smc_clc_msg_smcd *prop_smcd = smc_get_clc_msg_smcd(prop);
+
+	if (!prop_smcd || !ntohs(prop_smcd->v2_ext_offset))
+		return NULL;
+
+	return (struct smc_clc_v2_extension *)
+	       ((u8 *)prop_smcd +
+	       offsetof(struct smc_clc_msg_smcd, v2_ext_offset) +
+	       sizeof(prop_smcd->v2_ext_offset) +
+	       ntohs(prop_smcd->v2_ext_offset));
+}
+
 struct smcd_dev;
 struct smc_init_info;
 
-- 
2.17.1

