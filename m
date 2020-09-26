Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB53F279892
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgIZKpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727777AbgIZKoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:55 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAX09m072628;
        Sat, 26 Sep 2020 06:44:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=PSEYSUjTWnyjKHJWTUhMQf9nbv6OZQGIn6oRAC/Q/Jc=;
 b=auHsM1Ii/yzxdvacA3VrNe/sGXCDYnuHse2RSdJyiImRVnTUKvtiW+NEooBbTsFCT36B
 690wlPhGbfhfPaEqcJUGO3t6MCXpgrYIIKs/etk7SD9wuAJWWbtWMMS3xJjNjGFgb4Pc
 DMsBjL4/kmln5peNaGpQtVIiXXFFK2guhw6UaSvXWOUF5l2R6L7R4uQw5Q6y6hV6Cb5h
 NvGfxRf4UrA8f8T5pDmnV17j4bEcfGxAB8jf4E7TRcY9MbKgrVGxDDym6G3bFFq1lt2n
 2fy58vl7h3/eFnihToMON27siXzAHOY6of3bYtMzQmJpwXGkC3quvIaYWtyU9TQl3Z6k QQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t2cmhtj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:54 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAhog7003122;
        Sat, 26 Sep 2020 10:44:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw98097d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAimAM30802198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC496A4054;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 783C3A405B;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 13/14] net/smc: introduce CLC first contact extension
Date:   Sat, 26 Sep 2020 12:44:31 +0200
Message-Id: <20200926104432.74293-14-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_07:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=1 priorityscore=1501 mlxlogscore=999 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMC Version 2 defines a first contact extension for CLC accept
and CLC confirm. This patch covers sending and receiving of the
CLC first contact extension.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 29 +++++++++++++++++++++++++++++
 net/smc/smc.h      |  1 +
 net/smc/smc_clc.c  | 42 +++++++++++++++++++++++++++++++++++++-----
 net/smc/smc_clc.h  | 18 ++++++++++++++++++
 net/smc/smc_core.c |  1 +
 net/smc/smc_core.h |  5 +++++
 6 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index da282a860cfb..3007f9c36d2c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -26,6 +26,7 @@
 #include <linux/sched/signal.h>
 #include <linux/if_vlan.h>
 #include <linux/rcupdate_wait.h>
+#include <linux/ctype.h>
 
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -448,6 +449,16 @@ static void smcr_conn_save_peer_info(struct smc_sock *smc,
 	smc->conn.tx_off = bufsize * (smc->conn.peer_rmbe_idx - 1);
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
 static void smcd_conn_save_peer_info(struct smc_sock *smc,
 				     struct smc_clc_msg_accept_confirm *clc)
 {
@@ -459,6 +470,22 @@ static void smcd_conn_save_peer_info(struct smc_sock *smc,
 	smc->conn.peer_rmbe_size = bufsize - sizeof(struct smcd_cdc_msg);
 	atomic_set(&smc->conn.peer_rmbe_space, smc->conn.peer_rmbe_size);
 	smc->conn.tx_off = bufsize * smc->conn.peer_rmbe_idx;
+	if (clc->hdr.version > SMC_V1 &&
+	    (clc->hdr.typev2 & SMC_FIRST_CONTACT_MASK)) {
+		struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
+			(struct smc_clc_msg_accept_confirm_v2 *)clc;
+		struct smc_clc_first_contact_ext *fce =
+			(struct smc_clc_first_contact_ext *)
+				(((u8 *)clc_v2) + sizeof(*clc_v2));
+
+		memcpy(smc->conn.lgr->negotiated_eid, clc_v2->eid,
+		       SMC_MAX_EID_LEN);
+		smc->conn.lgr->peer_os = fce->os_type;
+		smc->conn.lgr->peer_smc_release = fce->release;
+		if (smc_isascii(fce->hostname))
+			memcpy(smc->conn.lgr->peer_hostname, fce->hostname,
+			       SMC_MAX_HOSTNAME_LEN);
+	}
 }
 
 static void smc_conn_save_peer_info(struct smc_sock *smc,
@@ -662,6 +689,7 @@ static int smc_connect_ism_vlan_cleanup(struct smc_sock *smc,
 
 #define SMC_CLC_MAX_ACCEPT_LEN \
 	(sizeof(struct smc_clc_msg_accept_confirm_v2) + \
+	 sizeof(struct smc_clc_first_contact_ext) + \
 	 sizeof(struct smc_clc_msg_trail))
 
 /* CLC handshake during connect */
@@ -2422,6 +2450,7 @@ static int __init smc_init(void)
 		return rc;
 
 	smc_ism_init();
+	smc_clc_init();
 
 	rc = smc_pnet_init();
 	if (rc)
diff --git a/net/smc/smc.h b/net/smc/smc.h
index a1e480a3ec43..d65e15f0c944 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -29,6 +29,7 @@
 					 * devices
 					 */
 
+#define SMC_MAX_HOSTNAME_LEN	32
 #define SMC_MAX_EID_LEN		32
 
 extern struct proto smc_proto;
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index a2eb59dbcdb0..6762291b3940 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -14,6 +14,8 @@
 #include <linux/inetdevice.h>
 #include <linux/if_ether.h>
 #include <linux/sched/signal.h>
+#include <linux/utsname.h>
+#include <linux/ctype.h>
 
 #include <net/addrconf.h>
 #include <net/sock.h>
@@ -35,6 +37,8 @@ static const char SMC_EYECATCHER[4] = {'\xe2', '\xd4', '\xc3', '\xd9'};
 /* eye catcher "SMCD" EBCDIC for CLC messages */
 static const char SMCD_EYECATCHER[4] = {'\xe2', '\xd4', '\xc3', '\xc4'};
 
+static u8 smc_hostname[SMC_MAX_HOSTNAME_LEN];
+
 /* check arriving CLC proposal */
 static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 {
@@ -92,12 +96,23 @@ smc_clc_msg_acc_conf_valid(struct smc_clc_msg_accept_confirm_v2 *clc_v2)
 			return false;
 	} else {
 		if (hdr->typev1 == SMC_TYPE_D &&
-		    ntohs(hdr->length) != SMCD_CLC_ACCEPT_CONFIRM_LEN_V2)
+		    ntohs(hdr->length) != SMCD_CLC_ACCEPT_CONFIRM_LEN_V2 &&
+		    (ntohs(hdr->length) != SMCD_CLC_ACCEPT_CONFIRM_LEN_V2 +
+				sizeof(struct smc_clc_first_contact_ext)))
 			return false;
 	}
 	return true;
 }
 
+static void smc_clc_fill_fce(struct smc_clc_first_contact_ext *fce, int *len)
+{
+	memset(fce, 0, sizeof(*fce));
+	fce->os_type = SMC_CLC_OS_LINUX;
+	fce->release = SMC_RELEASE;
+	memcpy(fce->hostname, smc_hostname, sizeof(smc_hostname));
+	(*len) += sizeof(*fce);
+}
+
 /* check if received message has a correct header length and contains valid
  * heading and trailing eyecatchers
  */
@@ -623,10 +638,11 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 {
 	struct smc_connection *conn = &smc->conn;
 	struct smc_clc_msg_accept_confirm *clc;
+	struct smc_clc_first_contact_ext fce;
 	struct smc_clc_msg_trail trl;
-	struct kvec vec[2];
+	struct kvec vec[3];
 	struct msghdr msg;
-	int i;
+	int i, len;
 
 	/* send SMC Confirm CLC msg */
 	clc = (struct smc_clc_msg_accept_confirm *)clc_v2;
@@ -652,8 +668,10 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 			smc_ism_get_system_eid(conn->lgr->smcd, &eid);
 			if (eid)
 				memcpy(clc_v2->eid, eid, SMC_MAX_EID_LEN);
-			clc_v2->hdr.length =
-					htons(SMCD_CLC_ACCEPT_CONFIRM_LEN_V2);
+			len = SMCD_CLC_ACCEPT_CONFIRM_LEN_V2;
+			if (first_contact)
+				smc_clc_fill_fce(&fce, &len);
+			clc_v2->hdr.length = htons(len);
 		}
 		memcpy(trl.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
@@ -701,6 +719,10 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 						SMCD_CLC_ACCEPT_CONFIRM_LEN :
 						SMCR_CLC_ACCEPT_CONFIRM_LEN) -
 				   sizeof(trl);
+	if (version > SMC_V1 && first_contact) {
+		vec[i].iov_base = &fce;
+		vec[i++].iov_len = sizeof(fce);
+	}
 	vec[i].iov_base = &trl;
 	vec[i++].iov_len = sizeof(trl);
 	return kernel_sendmsg(smc->clcsock, &msg, vec, 1,
@@ -748,3 +770,13 @@ int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
 
 	return len > 0 ? 0 : len;
 }
+
+void __init smc_clc_init(void)
+{
+	struct new_utsname *u;
+
+	memset(smc_hostname, _S, sizeof(smc_hostname)); /* ASCII blanks */
+	u = utsname();
+	memcpy(smc_hostname, u->nodename,
+	       min_t(size_t, strlen(u->nodename), sizeof(smc_hostname)));
+}
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 926b86cce68f..92179d955f59 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -199,6 +199,23 @@ struct smcd_clc_msg_accept_confirm_common {	/* SMCD accept/confirm */
 	__be32 linkid;		/* Link identifier */
 } __packed;
 
+#define SMC_CLC_OS_ZOS		1
+#define SMC_CLC_OS_LINUX	2
+#define SMC_CLC_OS_AIX		3
+
+struct smc_clc_first_contact_ext {
+	u8 reserved1;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8 os_type : 4,
+	   release : 4;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8 release : 4,
+	   os_type : 4;
+#endif
+	u8 reserved2[2];
+	u8 hostname[SMC_MAX_HOSTNAME_LEN];
+};
+
 struct smc_clc_msg_accept_confirm {	/* clc accept / confirm message */
 	struct smc_clc_msg_hdr hdr;
 	union {
@@ -304,5 +321,6 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 			 u8 version);
 int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact,
 			u8 version);
+void smc_clc_init(void) __init;
 
 #endif
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c52acb6fe6c9..f1dbb5025c0b 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -418,6 +418,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lgr->smcd = ini->ism_dev[ini->ism_selected];
 		lgr_list = &ini->ism_dev[ini->ism_selected]->lgr_list;
 		lgr_lock = &lgr->smcd->lgr_lock;
+		lgr->smc_version = ini->smcd_version;
 		lgr->peer_shutdown = 0;
 		atomic_inc(&ini->ism_dev[ini->ism_selected]->lgr_cnt);
 	} else {
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 35e38dd26cbf..f1e867ce2e63 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -231,6 +231,11 @@ struct smc_link_group {
 	u8			freeing : 1;	/* lgr is being freed */
 
 	bool			is_smcd;	/* SMC-R or SMC-D */
+	u8			smc_version;
+	u8			negotiated_eid[SMC_MAX_EID_LEN];
+	u8			peer_os;	/* peer operating system */
+	u8			peer_smc_release;
+	u8			peer_hostname[SMC_MAX_HOSTNAME_LEN];
 	union {
 		struct { /* SMC-R */
 			enum smc_lgr_role	role;
-- 
2.17.1

