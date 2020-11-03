Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B6A2A41C7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgKCK0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:26:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58984 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728150AbgKCKZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:25:58 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3A2KUr087860;
        Tue, 3 Nov 2020 05:25:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=L75i1qNMdPU2mrliZx1DOpC9zdggK4F0HarWMKqxUig=;
 b=foYJHeNbG70TV7MFtNGsbGceRGy9XNdJwX+MLU908d0pUx1ZtdExwBqe747ZICILx7mE
 7Ze8+o0SUmkVUSwmwHQS4qRGOmJsX64rUqRWe9UpnEmEVODELOqWh592aZOVDR2H25qW
 snm1UteOG4aovu9yOCaNZbYsYX4hcyxB+imUY80PNY5uLF5An0lrkUp8zR4KbWe0OZ/w
 2gNa/8UnCs46NrXKDpH/hApNHSLQwQ81B00oVCVQU5q6Fwi2TmifE/XNdIzpuwnli+o4
 Fri90ai9oMD4f4F25Z7tnt8mi7Ini/adr3d442DcfuoCIDXkScIcMj//X0bOhay9Yig+ qA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34k14u73e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 05:25:55 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3AN2Zj020287;
        Tue, 3 Nov 2020 10:25:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 34h01ub1f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 10:25:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3APosE8061654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 10:25:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B71B9A4054;
        Tue,  3 Nov 2020 10:25:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FEB7A405B;
        Tue,  3 Nov 2020 10:25:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 10:25:50 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v2 15/15] net/smc: Add support for obtaining system information
Date:   Tue,  3 Nov 2020 11:25:31 +0100
Message-Id: <20201103102531.91710-16-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103102531.91710-1-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_07:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=1 clxscore=1015 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Add new netlink command to obtain system information
of the smc module.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h      |  1 +
 include/uapi/linux/smc_diag.h | 18 ++++++++++
 net/smc/smc_clc.c             |  6 ++++
 net/smc/smc_clc.h             |  1 +
 net/smc/smc_diag.c            | 62 +++++++++++++++++++++++++++++++++++
 net/smc/smc_ism.c             |  1 +
 6 files changed, 89 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 736e8b98c8a5..04385a98037a 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -38,6 +38,7 @@ enum {				/* SMC PNET Table commands */
 #define SMC_LGR_ID_SIZE			4
 #define SMC_MAX_HOSTNAME_LEN		32 /* Max length of hostname */
 #define SMC_MAX_EID_LEN			32 /* Max length of eid */
+#define SMC_MAX_EID			8 /* Max number of eids */
 #define SMC_MAX_PORTS			2 /* Max # of ports per ib device */
 #define SMC_PCI_ID_STR_LEN		16 /* Max length of pci id string */
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 4c6332785533..7409e7a854df 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -75,6 +75,7 @@ enum {
 enum {
 	SMC_DIAG_GET_LGR_INFO = SMC_DIAG_EXTS_PER_CMD,
 	SMC_DIAG_GET_DEV_INFO,
+	SMC_DIAG_GET_SYS_INFO,
 	__SMC_DIAG_EXT_MAX,
 };
 
@@ -91,6 +92,11 @@ enum {
 	SMC_DIAG_DEV_INFO_SMCR,
 };
 
+/* SMC_DIAG_GET_SYS_INFO command extensions */
+enum {
+	SMC_DIAG_SYS_INFO = 1,
+};
+
 #define SMC_DIAG_MAX (__SMC_DIAG_MAX - 1)
 #define SMC_DIAG_EXT_MAX (__SMC_DIAG_EXT_MAX - 1)
 
@@ -131,6 +137,18 @@ struct smc_diag_v2_lgr_info {
 	__u8		peer_hostname[SMC_MAX_HOSTNAME_LEN]; /* Peer host */
 };
 
+
+struct smc_system_info {
+	__u8		smc_version;		/* SMC Version */
+	__u8		smc_release;		/* SMC Release */
+	__u8		ueid_count;		/* Number of UEIDs */
+	__u8		smc_ism_is_v2;		/* Is ISM SMC v2 capable */
+	__u32		reserved;		/* Reserved for future use */
+	__u8		local_hostname[SMC_MAX_HOSTNAME_LEN]; /* Hostnames */
+	__u8		seid[SMC_MAX_EID_LEN];	/* System EID */
+	__u8		ueid[SMC_MAX_EID][SMC_MAX_EID_LEN]; /* User EIDs */
+};
+
 /* SMC_DIAG_LINKINFO */
 
 struct smc_diag_linkinfo {
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 696d89c2dce4..ca887ee6b249 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -772,6 +772,12 @@ int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
 	return len > 0 ? 0 : len;
 }
 
+void smc_clc_get_hostname(u8 **host)
+{
+	*host = &smc_hostname[0];
+}
+EXPORT_SYMBOL_GPL(smc_clc_get_hostname);
+
 void __init smc_clc_init(void)
 {
 	struct new_utsname *u;
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index e7ab05683bc9..9ed9eb3abe46 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -334,5 +334,6 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact,
 			u8 version);
 void smc_clc_init(void) __init;
+void smc_clc_get_hostname(u8 **host);
 
 #endif
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 58bfbe0bef4d..a69a401329ab 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -23,6 +23,7 @@
 #include "smc_ib.h"
 #include "smc_ism.h"
 #include "smc_core.h"
+#include "smc_clc.h"
 
 struct smc_diag_dump_ctx {
 	int pos[2];
@@ -650,6 +651,63 @@ static int smc_diag_prep_smcr_dev(struct smc_ib_devices *dev_list,
 	return rc;
 }
 
+static int smc_diag_prep_sys_info(struct smcd_dev_list *dev_list,
+				  struct sk_buff *skb,
+				  struct netlink_callback *cb,
+				  struct smc_diag_req_v2 *req)
+{
+	struct smc_diag_dump_ctx *cb_ctx = smc_dump_context(cb);
+	struct smc_system_info smc_sys_info;
+	int dummy = 0, rc = 0, num = 0;
+	struct smcd_dev *smcd_dev;
+	int snum = cb_ctx->pos[0];
+	struct nlmsghdr *nlh;
+	u8 *seid = NULL;
+	u8 *host = NULL;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, MAGIC_SEQ_V2_ACK,
+			cb->nlh->nlmsg_type, 0, NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	if (snum > num)
+		goto errout;
+
+	memset(&smc_sys_info, 0, sizeof(smc_sys_info));
+	smc_sys_info.smc_ism_is_v2 = smc_ism_is_v2_capable();
+	smc_sys_info.smc_version = SMC_V2;
+	smc_sys_info.smc_release = SMC_RELEASE;
+	smc_clc_get_hostname(&host);
+
+	if (host)
+		memcpy(smc_sys_info.local_hostname, host,
+		       sizeof(smc_sys_info.local_hostname));
+	mutex_lock(&dev_list->mutex);
+	smcd_dev = list_first_entry_or_null(&dev_list->list, struct smcd_dev, list);
+	if (smcd_dev)
+		smc_ism_get_system_eid(smcd_dev, &seid);
+	mutex_unlock(&dev_list->mutex);
+
+	if (seid && smc_sys_info.smc_ism_is_v2)
+		memcpy(smc_sys_info.seid, seid, sizeof(smc_sys_info.seid));
+
+	/* Just a command place holder to signal back the command reply type */
+	if (nla_put(skb, SMC_DIAG_GET_SYS_INFO, sizeof(dummy), &dummy) < 0)
+		goto errout;
+
+	if (nla_put(skb, SMC_DIAG_SYS_INFO,
+		    sizeof(smc_sys_info), &smc_sys_info) < 0)
+		goto errout;
+	nlmsg_end(skb, nlh);
+	num++;
+	cb_ctx->pos[0] = num;
+	return rc;
+
+errout:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
 static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 			   struct netlink_callback *cb,
 			   const struct smc_diag_req *req)
@@ -758,6 +816,10 @@ static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
 		if ((req->cmd_ext & (1 << (SMC_DIAG_DEV_INFO_SMCR - 1))))
 			smc_diag_prep_smcr_dev(&smc_ib_devices, skb, cb,
 					       req);
+	} else if (req->cmd == SMC_DIAG_GET_SYS_INFO) {
+		if ((req->cmd_ext & (1 << (SMC_DIAG_SYS_INFO - 1))))
+			smc_diag_prep_sys_info(&smcd_dev_list, skb, cb,
+					       req);
 	}
 
 	return skb->len;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 2a2571637bc6..c3bcca3ca1aa 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -46,6 +46,7 @@ void smc_ism_get_system_eid(struct smcd_dev *smcd, u8 **eid)
 {
 	smcd->ops->get_system_eid(smcd, eid);
 }
+EXPORT_SYMBOL_GPL(smc_ism_get_system_eid);
 
 u16 smc_ism_get_chid(struct smcd_dev *smcd)
 {
-- 
2.17.1

