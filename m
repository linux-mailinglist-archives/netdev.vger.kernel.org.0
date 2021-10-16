Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D074843018C
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 11:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243973AbhJPJkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 05:40:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243957AbhJPJki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 05:40:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19G7xSxu025586;
        Sat, 16 Oct 2021 05:38:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w3vIkXuUD5ku44xTRMHMXKQzAd8EBjrSgBgmA4u1nok=;
 b=dMM7/TqG1sgBClwnK4Cs+8cPjGwaGL+mssu8VRrnSOfJx9z+JZb/WN/9DemXYnzoqngi
 hoSRhjbniM05JfsLecIN0dxbuGUbobX0HLTN6Q6eVq2rSGfeRSHIYHCcIwYQqsfEIiUK
 oAUJNcm9+qhx7wrAt/M1vqN2TIN/ddrt2sNoKoQ166x/EZzEGCqqVlTCI8WOpRHaLB44
 OquVig2c0DhQUlvgFRggL8gJj45kLIPWOfdmUhS+KR+aY7V2XtzcEDVmUS/ZQgtU4h3/
 I7hGTNOZ6gWlsXGix4pEUR5MCMR09EAj2/Cp+ggY78gesT6azm16bbNm+VO6WEGWgRpJ bQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bqttyhcet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 05:38:28 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19G9cJLd004875;
        Sat, 16 Oct 2021 09:38:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0j1bsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 09:38:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19G9Wdka64028984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Oct 2021 09:32:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EAE84C044;
        Sat, 16 Oct 2021 09:38:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE6CC4C050;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 03/10] net/smc: add SMC-Rv2 connection establishment
Date:   Sat, 16 Oct 2021 11:37:45 +0200
Message-Id: <20211016093752.3564615-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211016093752.3564615-1-kgraul@linux.ibm.com>
References: <20211016093752.3564615-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WysgT1KG8gNUy-J9V7n1xbBakg8LCy28
X-Proofpoint-ORIG-GUID: WysgT1KG8gNUy-J9V7n1xbBakg8LCy28
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-16_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110160060
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send a CLC proposal message, and the remote side process this type of
message and determine the target GID. Check for a valid route to this
GID, and complete the connection establishment.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 169 +++++++++++++++++++++++++++++++++++----------
 net/smc/smc_clc.c  |  89 +++++++++++++++++++-----
 net/smc/smc_clc.h  |  24 +++++--
 net/smc/smc_core.h |   6 ++
 net/smc/smc_ib.c   |  27 ++++++++
 net/smc/smc_ib.h   |  13 ++++
 6 files changed, 267 insertions(+), 61 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f21e74537f53..d4280262b829 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -439,6 +439,47 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 	return 0;
 }
 
+static bool smc_isascii(char *hostname)
+{
+	int i;
+
+	for (i = 0; i < SMC_MAX_HOSTNAME_LEN; i++)
+		if (!isascii(hostname[i]))
+			return false;
+	return true;
+}
+
+static void smc_conn_save_peer_info_fce(struct smc_sock *smc,
+					struct smc_clc_msg_accept_confirm *clc)
+{
+	struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
+		(struct smc_clc_msg_accept_confirm_v2 *)clc;
+	struct smc_clc_first_contact_ext *fce;
+	int clc_v2_len;
+
+	if (clc->hdr.version == SMC_V1 ||
+	    !(clc->hdr.typev2 & SMC_FIRST_CONTACT_MASK))
+		return;
+
+	if (smc->conn.lgr->is_smcd) {
+		memcpy(smc->conn.lgr->negotiated_eid, clc_v2->d1.eid,
+		       SMC_MAX_EID_LEN);
+		clc_v2_len = offsetofend(struct smc_clc_msg_accept_confirm_v2,
+					 d1);
+	} else {
+		memcpy(smc->conn.lgr->negotiated_eid, clc_v2->r1.eid,
+		       SMC_MAX_EID_LEN);
+		clc_v2_len = offsetofend(struct smc_clc_msg_accept_confirm_v2,
+					 r1);
+	}
+	fce = (struct smc_clc_first_contact_ext *)(((u8 *)clc_v2) + clc_v2_len);
+	smc->conn.lgr->peer_os = fce->os_type;
+	smc->conn.lgr->peer_smc_release = fce->release;
+	if (smc_isascii(fce->hostname))
+		memcpy(smc->conn.lgr->peer_hostname, fce->hostname,
+		       SMC_MAX_HOSTNAME_LEN);
+}
+
 static void smcr_conn_save_peer_info(struct smc_sock *smc,
 				     struct smc_clc_msg_accept_confirm *clc)
 {
@@ -451,16 +492,6 @@ static void smcr_conn_save_peer_info(struct smc_sock *smc,
 	smc->conn.tx_off = bufsize * (smc->conn.peer_rmbe_idx - 1);
 }
 
-static bool smc_isascii(char *hostname)
-{
-	int i;
-
-	for (i = 0; i < SMC_MAX_HOSTNAME_LEN; i++)
-		if (!isascii(hostname[i]))
-			return false;
-	return true;
-}
-
 static void smcd_conn_save_peer_info(struct smc_sock *smc,
 				     struct smc_clc_msg_accept_confirm *clc)
 {
@@ -472,22 +503,6 @@ static void smcd_conn_save_peer_info(struct smc_sock *smc,
 	smc->conn.peer_rmbe_size = bufsize - sizeof(struct smcd_cdc_msg);
 	atomic_set(&smc->conn.peer_rmbe_space, smc->conn.peer_rmbe_size);
 	smc->conn.tx_off = bufsize * smc->conn.peer_rmbe_idx;
-	if (clc->hdr.version > SMC_V1 &&
-	    (clc->hdr.typev2 & SMC_FIRST_CONTACT_MASK)) {
-		struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
-			(struct smc_clc_msg_accept_confirm_v2 *)clc;
-		struct smc_clc_first_contact_ext *fce =
-			(struct smc_clc_first_contact_ext *)
-				(((u8 *)clc_v2) + sizeof(*clc_v2));
-
-		memcpy(smc->conn.lgr->negotiated_eid, clc_v2->eid,
-		       SMC_MAX_EID_LEN);
-		smc->conn.lgr->peer_os = fce->os_type;
-		smc->conn.lgr->peer_smc_release = fce->release;
-		if (smc_isascii(fce->hostname))
-			memcpy(smc->conn.lgr->peer_hostname, fce->hostname,
-			       SMC_MAX_HOSTNAME_LEN);
-	}
 }
 
 static void smc_conn_save_peer_info(struct smc_sock *smc,
@@ -497,14 +512,16 @@ static void smc_conn_save_peer_info(struct smc_sock *smc,
 		smcd_conn_save_peer_info(smc, clc);
 	else
 		smcr_conn_save_peer_info(smc, clc);
+	smc_conn_save_peer_info_fce(smc, clc);
 }
 
 static void smc_link_save_peer_info(struct smc_link *link,
-				    struct smc_clc_msg_accept_confirm *clc)
+				    struct smc_clc_msg_accept_confirm *clc,
+				    struct smc_init_info *ini)
 {
 	link->peer_qpn = ntoh24(clc->r0.qpn);
-	memcpy(link->peer_gid, clc->r0.lcl.gid, SMC_GID_SIZE);
-	memcpy(link->peer_mac, clc->r0.lcl.mac, sizeof(link->peer_mac));
+	memcpy(link->peer_gid, ini->peer_gid, SMC_GID_SIZE);
+	memcpy(link->peer_mac, ini->peer_mac, sizeof(link->peer_mac));
 	link->peer_psn = ntoh24(clc->r0.psn);
 	link->peer_mtu = clc->r0.qp_mtu;
 }
@@ -769,6 +786,64 @@ static int smc_connect_clc(struct smc_sock *smc,
 				SMC_CLC_ACCEPT, CLC_WAIT_TIME);
 }
 
+static void smc_fill_gid_list(struct smc_link_group *lgr,
+			      struct smc_gidlist *gidlist,
+			      struct smc_ib_device *known_dev, u8 *known_gid)
+{
+	struct smc_init_info *alt_ini = NULL;
+
+	memset(gidlist, 0, sizeof(*gidlist));
+	memcpy(gidlist->list[gidlist->len++], known_gid, SMC_GID_SIZE);
+
+	alt_ini = kzalloc(sizeof(*alt_ini), GFP_KERNEL);
+	if (!alt_ini)
+		goto out;
+
+	alt_ini->vlan_id = lgr->vlan_id;
+	alt_ini->check_smcrv2 = true;
+	alt_ini->smcrv2.saddr = lgr->saddr;
+	smc_pnet_find_alt_roce(lgr, alt_ini, known_dev);
+
+	if (!alt_ini->smcrv2.ib_dev_v2)
+		goto out;
+
+	memcpy(gidlist->list[gidlist->len++], alt_ini->smcrv2.ib_gid_v2,
+	       SMC_GID_SIZE);
+
+out:
+	kfree(alt_ini);
+}
+
+static int smc_connect_rdma_v2_prepare(struct smc_sock *smc,
+				       struct smc_clc_msg_accept_confirm *aclc,
+				       struct smc_init_info *ini)
+{
+	struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
+		(struct smc_clc_msg_accept_confirm_v2 *)aclc;
+	struct smc_clc_first_contact_ext *fce =
+		(struct smc_clc_first_contact_ext *)
+			(((u8 *)clc_v2) + sizeof(*clc_v2));
+
+	if (!ini->first_contact_peer || aclc->hdr.version == SMC_V1)
+		return 0;
+
+	if (fce->v2_direct) {
+		memcpy(ini->smcrv2.nexthop_mac, &aclc->r0.lcl.mac, ETH_ALEN);
+		ini->smcrv2.uses_gateway = false;
+	} else {
+		if (smc_ib_find_route(smc->clcsock->sk->sk_rcv_saddr,
+				      smc_ib_gid_to_ipv4(aclc->r0.lcl.gid),
+				      ini->smcrv2.nexthop_mac,
+				      &ini->smcrv2.uses_gateway))
+			return SMC_CLC_DECL_NOROUTE;
+		if (!ini->smcrv2.uses_gateway) {
+			/* mismatch: peer claims indirect, but its direct */
+			return SMC_CLC_DECL_NOINDIRECT;
+		}
+	}
+	return 0;
+}
+
 /* setup for RDMA connection of client */
 static int smc_connect_rdma(struct smc_sock *smc,
 			    struct smc_clc_msg_accept_confirm *aclc,
@@ -776,11 +851,18 @@ static int smc_connect_rdma(struct smc_sock *smc,
 {
 	int i, reason_code = 0;
 	struct smc_link *link;
+	u8 *eid = NULL;
 
 	ini->is_smcd = false;
-	ini->ib_lcl = &aclc->r0.lcl;
 	ini->ib_clcqpn = ntoh24(aclc->r0.qpn);
 	ini->first_contact_peer = aclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK;
+	memcpy(ini->peer_systemid, aclc->r0.lcl.id_for_peer, SMC_SYSTEMID_LEN);
+	memcpy(ini->peer_gid, aclc->r0.lcl.gid, SMC_GID_SIZE);
+	memcpy(ini->peer_mac, aclc->r0.lcl.mac, ETH_ALEN);
+
+	reason_code = smc_connect_rdma_v2_prepare(smc, aclc, ini);
+	if (reason_code)
+		return reason_code;
 
 	mutex_lock(&smc_client_lgr_pending);
 	reason_code = smc_conn_create(smc, ini);
@@ -802,8 +884,9 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			if (l->peer_qpn == ntoh24(aclc->r0.qpn) &&
 			    !memcmp(l->peer_gid, &aclc->r0.lcl.gid,
 				    SMC_GID_SIZE) &&
-			    !memcmp(l->peer_mac, &aclc->r0.lcl.mac,
-				    sizeof(l->peer_mac))) {
+			    (aclc->hdr.version > SMC_V1 ||
+			     !memcmp(l->peer_mac, &aclc->r0.lcl.mac,
+				     sizeof(l->peer_mac)))) {
 				link = l;
 				break;
 			}
@@ -822,7 +905,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	}
 
 	if (ini->first_contact_local)
-		smc_link_save_peer_info(link, aclc);
+		smc_link_save_peer_info(link, aclc, ini);
 
 	if (smc_rmb_rtoken_handling(&smc->conn, link, aclc)) {
 		reason_code = SMC_CLC_DECL_ERR_RTOK;
@@ -845,8 +928,18 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	}
 	smc_rmb_sync_sg_for_device(&smc->conn);
 
+	if (aclc->hdr.version > SMC_V1) {
+		struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
+			(struct smc_clc_msg_accept_confirm_v2 *)aclc;
+
+		eid = clc_v2->r1.eid;
+		if (ini->first_contact_local)
+			smc_fill_gid_list(link->lgr, &ini->smcrv2.gidlist,
+					  link->smcibdev, link->gid);
+	}
+
 	reason_code = smc_clc_send_confirm(smc, ini->first_contact_local,
-					   SMC_V1, NULL);
+					   aclc->hdr.version, eid, ini);
 	if (reason_code)
 		goto connect_abort;
 
@@ -886,7 +979,7 @@ smc_v2_determine_accepted_chid(struct smc_clc_msg_accept_confirm_v2 *aclc,
 	int i;
 
 	for (i = 0; i < ini->ism_offered_cnt + 1; i++) {
-		if (ini->ism_chid[i] == ntohs(aclc->chid)) {
+		if (ini->ism_chid[i] == ntohs(aclc->d1.chid)) {
 			ini->ism_selected = i;
 			return 0;
 		}
@@ -940,11 +1033,11 @@ static int smc_connect_ism(struct smc_sock *smc,
 		struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
 			(struct smc_clc_msg_accept_confirm_v2 *)aclc;
 
-		eid = clc_v2->eid;
+		eid = clc_v2->d1.eid;
 	}
 
 	rc = smc_clc_send_confirm(smc, ini->first_contact_local,
-				  aclc->hdr.version, eid);
+				  aclc->hdr.version, eid, NULL);
 	if (rc)
 		goto connect_abort;
 	mutex_unlock(&smc_server_lgr_pending);
@@ -1735,7 +1828,7 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 	int reason_code = 0;
 
 	if (local_first)
-		smc_link_save_peer_info(link, cclc);
+		smc_link_save_peer_info(link, cclc, NULL);
 
 	if (smc_rmb_rtoken_handling(&new_smc->conn, link, cclc))
 		return SMC_CLC_DECL_ERR_RTOK;
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 8d44f06cf401..5cc2e2dc7417 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -31,6 +31,7 @@
 #define SMCR_CLC_ACCEPT_CONFIRM_LEN 68
 #define SMCD_CLC_ACCEPT_CONFIRM_LEN 48
 #define SMCD_CLC_ACCEPT_CONFIRM_LEN_V2 78
+#define SMCR_CLC_ACCEPT_CONFIRM_LEN_V2 108
 #define SMC_CLC_RECV_BUF_LEN	100
 
 /* eye catcher "SMCR" EBCDIC for CLC messages */
@@ -309,7 +310,8 @@ bool smc_clc_match_eid(u8 *negotiated_eid,
 
 	negotiated_eid[0] = 0;
 	read_lock(&smc_clc_eid_table.lock);
-	if (smc_clc_eid_table.seid_enabled &&
+	if (peer_eid && local_eid &&
+	    smc_clc_eid_table.seid_enabled &&
 	    smc_v2_ext->hdr.flag.seid &&
 	    !memcmp(peer_eid, local_eid, SMC_MAX_EID_LEN)) {
 		memcpy(negotiated_eid, peer_eid, SMC_MAX_EID_LEN);
@@ -391,6 +393,9 @@ smc_clc_msg_acc_conf_valid(struct smc_clc_msg_accept_confirm_v2 *clc_v2)
 		    (ntohs(hdr->length) != SMCD_CLC_ACCEPT_CONFIRM_LEN_V2 +
 				sizeof(struct smc_clc_first_contact_ext)))
 			return false;
+		if (hdr->typev1 == SMC_TYPE_R &&
+		    ntohs(hdr->length) < SMCR_CLC_ACCEPT_CONFIRM_LEN_V2)
+			return false;
 	}
 	return true;
 }
@@ -844,8 +849,8 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 	} else {
 		struct smc_clc_eid_entry *ueident;
 		u16 v2_ext_offset;
-		u8 *eid = NULL;
 
+		v2_ext->hdr.flag.release = SMC_RELEASE;
 		v2_ext_offset = sizeof(*pclc_smcd) -
 			offsetofend(struct smc_clc_msg_smcd, v2_ext_offset);
 		if (ini->smc_type_v1 != SMC_TYPE_N)
@@ -853,6 +858,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 						pclc_prfx->ipv6_prefixes_cnt *
 						sizeof(ipv6_prfx[0]);
 		pclc_smcd->v2_ext_offset = htons(v2_ext_offset);
+		plen += sizeof(*v2_ext);
 
 		read_lock(&smc_clc_eid_table.lock);
 		v2_ext->hdr.eid_cnt = smc_clc_eid_table.ueid_cnt;
@@ -862,10 +868,13 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 			memcpy(v2_ext->user_eids[i++], ueident->eid,
 			       sizeof(ueident->eid));
 		}
-		v2_ext->hdr.flag.seid = smc_clc_eid_table.seid_enabled;
 		read_unlock(&smc_clc_eid_table.lock);
+	}
+	if (smcd_indicated(ini->smc_type_v2)) {
+		u8 *eid = NULL;
+
+		v2_ext->hdr.flag.seid = smc_clc_eid_table.seid_enabled;
 		v2_ext->hdr.ism_gid_cnt = ini->ism_offered_cnt;
-		v2_ext->hdr.flag.release = SMC_RELEASE;
 		v2_ext->hdr.smcd_v2_ext_offset = htons(sizeof(*v2_ext) -
 				offsetofend(struct smc_clnt_opts_area_hdr,
 					    smcd_v2_ext_offset) +
@@ -873,7 +882,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 		smc_ism_get_system_eid(&eid);
 		if (eid && v2_ext->hdr.flag.seid)
 			memcpy(smcd_v2_ext->system_eid, eid, SMC_MAX_EID_LEN);
-		plen += sizeof(*v2_ext) + sizeof(*smcd_v2_ext);
+		plen += sizeof(*smcd_v2_ext);
 		if (ini->ism_offered_cnt) {
 			for (i = 1; i <= ini->ism_offered_cnt; i++) {
 				gidchids[i - 1].gid =
@@ -885,6 +894,9 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 				sizeof(struct smc_clc_smcd_gid_chid);
 		}
 	}
+	if (smcr_indicated(ini->smc_type_v2))
+		memcpy(v2_ext->roce, ini->smcrv2.ib_gid_v2, SMC_GID_SIZE);
+
 	pclc_base->hdr.length = htons(plen);
 	memcpy(trl->eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 
@@ -908,12 +920,14 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 		vec[i].iov_base = v2_ext;
 		vec[i++].iov_len = sizeof(*v2_ext) +
 				   (v2_ext->hdr.eid_cnt * SMC_MAX_EID_LEN);
-		vec[i].iov_base = smcd_v2_ext;
-		vec[i++].iov_len = sizeof(*smcd_v2_ext);
-		if (ini->ism_offered_cnt) {
-			vec[i].iov_base = gidchids;
-			vec[i++].iov_len = ini->ism_offered_cnt *
+		if (smcd_indicated(ini->smc_type_v2)) {
+			vec[i].iov_base = smcd_v2_ext;
+			vec[i++].iov_len = sizeof(*smcd_v2_ext);
+			if (ini->ism_offered_cnt) {
+				vec[i].iov_base = gidchids;
+				vec[i++].iov_len = ini->ism_offered_cnt *
 					sizeof(struct smc_clc_smcd_gid_chid);
+			}
 		}
 	}
 	vec[i].iov_base = trl;
@@ -936,13 +950,14 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 				       struct smc_clc_msg_accept_confirm_v2 *clc_v2,
 				       int first_contact, u8 version,
-				       u8 *eid)
+				       u8 *eid, struct smc_init_info *ini)
 {
 	struct smc_connection *conn = &smc->conn;
 	struct smc_clc_msg_accept_confirm *clc;
 	struct smc_clc_first_contact_ext fce;
+	struct smc_clc_fce_gid_ext gle;
 	struct smc_clc_msg_trail trl;
-	struct kvec vec[3];
+	struct kvec vec[5];
 	struct msghdr msg;
 	int i, len;
 
@@ -964,9 +979,10 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		if (version == SMC_V1) {
 			clc->hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
 		} else {
-			clc_v2->chid = htons(smc_ism_get_chid(conn->lgr->smcd));
-			if (eid[0])
-				memcpy(clc_v2->eid, eid, SMC_MAX_EID_LEN);
+			clc_v2->d1.chid =
+				htons(smc_ism_get_chid(conn->lgr->smcd));
+			if (eid && eid[0])
+				memcpy(clc_v2->d1.eid, eid, SMC_MAX_EID_LEN);
 			len = SMCD_CLC_ACCEPT_CONFIRM_LEN_V2;
 			if (first_contact)
 				smc_clc_fill_fce(&fce, &len);
@@ -1005,6 +1021,26 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		clc->r0.rmb_dma_addr = cpu_to_be64((u64)sg_dma_address
 				(conn->rmb_desc->sgt[link->link_idx].sgl));
 		hton24(clc->r0.psn, link->psn_initial);
+		if (version == SMC_V1) {
+			clc->hdr.length = htons(SMCR_CLC_ACCEPT_CONFIRM_LEN);
+		} else {
+			if (eid && eid[0])
+				memcpy(clc_v2->r1.eid, eid, SMC_MAX_EID_LEN);
+			len = SMCR_CLC_ACCEPT_CONFIRM_LEN_V2;
+			if (first_contact) {
+				smc_clc_fill_fce(&fce, &len);
+				fce.v2_direct = !link->lgr->uses_gateway;
+				memset(&gle, 0, sizeof(gle));
+				if (ini && clc->hdr.type == SMC_CLC_CONFIRM) {
+					gle.gid_cnt = ini->smcrv2.gidlist.len;
+					len += sizeof(gle);
+					len += gle.gid_cnt * sizeof(gle.gid[0]);
+				} else {
+					len += sizeof(gle.reserved);
+				}
+			}
+			clc_v2->hdr.length = htons(len);
+		}
 		memcpy(trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 	}
 
@@ -1012,7 +1048,10 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 	i = 0;
 	vec[i].iov_base = clc_v2;
 	if (version > SMC_V1)
-		vec[i++].iov_len = SMCD_CLC_ACCEPT_CONFIRM_LEN_V2 - sizeof(trl);
+		vec[i++].iov_len = (clc->hdr.typev1 == SMC_TYPE_D ?
+					SMCD_CLC_ACCEPT_CONFIRM_LEN_V2 :
+					SMCR_CLC_ACCEPT_CONFIRM_LEN_V2) -
+				   sizeof(trl);
 	else
 		vec[i++].iov_len = (clc->hdr.typev1 == SMC_TYPE_D ?
 						SMCD_CLC_ACCEPT_CONFIRM_LEN :
@@ -1021,6 +1060,18 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 	if (version > SMC_V1 && first_contact) {
 		vec[i].iov_base = &fce;
 		vec[i++].iov_len = sizeof(fce);
+		if (!conn->lgr->is_smcd) {
+			if (clc->hdr.type == SMC_CLC_CONFIRM) {
+				vec[i].iov_base = &gle;
+				vec[i++].iov_len = sizeof(gle);
+				vec[i].iov_base = &ini->smcrv2.gidlist.list;
+				vec[i++].iov_len = gle.gid_cnt *
+						   sizeof(gle.gid[0]);
+			} else {
+				vec[i].iov_base = &gle.reserved;
+				vec[i++].iov_len = sizeof(gle.reserved);
+			}
+		}
 	}
 	vec[i].iov_base = &trl;
 	vec[i++].iov_len = sizeof(trl);
@@ -1030,7 +1081,7 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 
 /* send CLC CONFIRM message across internal TCP socket */
 int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
-			 u8 version, u8 *eid)
+			 u8 version, u8 *eid, struct smc_init_info *ini)
 {
 	struct smc_clc_msg_accept_confirm_v2 cclc_v2;
 	int reason_code = 0;
@@ -1040,7 +1091,7 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 	memset(&cclc_v2, 0, sizeof(cclc_v2));
 	cclc_v2.hdr.type = SMC_CLC_CONFIRM;
 	len = smc_clc_send_confirm_accept(smc, &cclc_v2, clnt_first_contact,
-					  version, eid);
+					  version, eid, ini);
 	if (len < ntohs(cclc_v2.hdr.length)) {
 		if (len >= 0) {
 			reason_code = -ENETUNREACH;
@@ -1063,7 +1114,7 @@ int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
 	memset(&aclc_v2, 0, sizeof(aclc_v2));
 	aclc_v2.hdr.type = SMC_CLC_ACCEPT;
 	len = smc_clc_send_confirm_accept(new_smc, &aclc_v2, srv_first_contact,
-					  version, negotiated_eid);
+					  version, negotiated_eid, NULL);
 	if (len < ntohs(aclc_v2.hdr.length))
 		len = len >= 0 ? -EPROTO : -new_smc->clcsock->sk->sk_err;
 
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 37ce97f7fdb0..4f2fe278f404 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -54,6 +54,8 @@
 #define SMC_CLC_DECL_NOSRVLINK	0x030b0000  /* SMC-R link from srv not found  */
 #define SMC_CLC_DECL_VERSMISMAT	0x030c0000  /* SMC version mismatch	      */
 #define SMC_CLC_DECL_MAX_DMB	0x030d0000  /* SMC-D DMB limit exceeded       */
+#define SMC_CLC_DECL_NOROUTE	0x030e0000  /* SMC-Rv2 conn. no route to peer */
+#define SMC_CLC_DECL_NOINDIRECT	0x030f0000  /* SMC-Rv2 conn. indirect mismatch*/
 #define SMC_CLC_DECL_SYNCERR	0x04000000  /* synchronization error          */
 #define SMC_CLC_DECL_PEERDECL	0x05000000  /* peer declined during handshake */
 #define SMC_CLC_DECL_INTERR	0x09990000  /* internal error		      */
@@ -213,11 +215,14 @@ struct smcd_clc_msg_accept_confirm_common {	/* SMCD accept/confirm */
 #define SMC_CLC_OS_AIX		3
 
 struct smc_clc_first_contact_ext {
-	u8 reserved1;
 #if defined(__BIG_ENDIAN_BITFIELD)
+	u8 v2_direct : 1,
+	   reserved  : 7;
 	u8 os_type : 4,
 	   release : 4;
 #elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8 reserved  : 7,
+	   v2_direct : 1;
 	u8 release : 4,
 	   os_type : 4;
 #endif
@@ -225,6 +230,13 @@ struct smc_clc_first_contact_ext {
 	u8 hostname[SMC_MAX_HOSTNAME_LEN];
 };
 
+struct smc_clc_fce_gid_ext {
+	u8 reserved[16];
+	u8 gid_cnt;
+	u8 reserved2[3];
+	u8 gid[][SMC_GID_SIZE];
+};
+
 struct smc_clc_msg_accept_confirm {	/* clc accept / confirm message */
 	struct smc_clc_msg_hdr hdr;
 	union {
@@ -239,13 +251,17 @@ struct smc_clc_msg_accept_confirm {	/* clc accept / confirm message */
 struct smc_clc_msg_accept_confirm_v2 {	/* clc accept / confirm message */
 	struct smc_clc_msg_hdr hdr;
 	union {
-		struct smcr_clc_msg_accept_confirm r0; /* SMC-R */
+		struct { /* SMC-R */
+			struct smcr_clc_msg_accept_confirm r0;
+			u8 eid[SMC_MAX_EID_LEN];
+			u8 reserved6[8];
+		} r1;
 		struct { /* SMC-D */
 			struct smcd_clc_msg_accept_confirm_common d0;
 			__be16 chid;
 			u8 eid[SMC_MAX_EID_LEN];
 			u8 reserved5[8];
-		};
+		} d1;
 	};
 };
 
@@ -345,7 +361,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info, u8 version);
 int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini);
 int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
-			 u8 version, u8 *eid);
+			 u8 version, u8 *eid, struct smc_init_info *ini);
 int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact,
 			u8 version, u8 *negotiated_eid);
 void smc_clc_init(void) __init;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4a1778a7e3a5..128474f33b8f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -288,6 +288,9 @@ struct smc_link_group {
 						/* link keep alive time */
 			u32			llc_termination_rsn;
 						/* rsn code for termination */
+			u8			nexthop_mac[ETH_ALEN];
+			u8			uses_gateway;
+			__be32			saddr;
 		};
 		struct { /* SMC-D */
 			u64			peer_gid;
@@ -340,6 +343,9 @@ struct smc_init_info {
 	struct smc_clc_msg_local *ib_lcl;
 	u8			smcr_version;
 	u8			check_smcrv2;
+	u8			peer_gid[SMC_GID_SIZE];
+	u8			peer_mac[ETH_ALEN];
+	u8			peer_systemid[SMC_SYSTEMID_LEN];
 	struct smc_ib_device	*ib_dev;
 	u8			ib_gid[SMC_GID_SIZE];
 	u8			ib_port;
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index a8845343d183..9f72910af1d0 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -183,6 +183,33 @@ bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport)
 	return smcibdev->pattr[ibport - 1].state == IB_PORT_ACTIVE;
 }
 
+int smc_ib_find_route(__be32 saddr, __be32 daddr,
+		      u8 nexthop_mac[], u8 *uses_gateway)
+{
+	struct neighbour *neigh = NULL;
+	struct rtable *rt = NULL;
+	struct flowi4 fl4 = {
+		.saddr = saddr,
+		.daddr = daddr
+	};
+
+	if (daddr == cpu_to_be32(INADDR_NONE))
+		goto out;
+	rt = ip_route_output_flow(&init_net, &fl4, NULL);
+	if (IS_ERR(rt))
+		goto out;
+	if (rt->rt_uses_gateway && rt->rt_gw_family != AF_INET)
+		goto out;
+	neigh = rt->dst.ops->neigh_lookup(&rt->dst, NULL, &fl4.daddr);
+	if (neigh) {
+		memcpy(nexthop_mac, neigh->ha, ETH_ALEN);
+		*uses_gateway = rt->rt_uses_gateway;
+		return 0;
+	}
+out:
+	return -ENOENT;
+}
+
 /* determine the gid for an ib-device port and vlan id */
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 			 unsigned short vlan_id, u8 gid[], u8 *sgid_index)
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 3085f5180da7..c55cbd7be67a 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -59,6 +59,17 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	int			ndev_ifidx[SMC_MAX_PORTS]; /* ndev if indexes */
 };
 
+static inline __be32 smc_ib_gid_to_ipv4(u8 gid[SMC_GID_SIZE])
+{
+	struct in6_addr *addr6 = (struct in6_addr *)gid;
+
+	if (ipv6_addr_v4mapped(addr6) ||
+	    !(addr6->s6_addr32[0] | addr6->s6_addr32[1] | addr6->s6_addr32[2]))
+		return addr6->s6_addr32[3];
+	return cpu_to_be32(INADDR_NONE);
+}
+
+struct smc_init_info_smcrv2;
 struct smc_buf_desc;
 struct smc_link;
 
@@ -91,6 +102,8 @@ void smc_ib_sync_sg_for_device(struct smc_link *lnk,
 			       enum dma_data_direction data_direction);
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 			 unsigned short vlan_id, u8 gid[], u8 *sgid_index);
+int smc_ib_find_route(__be32 saddr, __be32 daddr,
+		      u8 nexthop_mac[], u8 *uses_gateway);
 bool smc_ib_is_valid_local_systemid(void);
 int smcr_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb);
 #endif
-- 
2.25.1

