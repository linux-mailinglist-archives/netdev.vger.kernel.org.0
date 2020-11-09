Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4F92ABFA1
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732060AbgKIPSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:18:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731978AbgKIPS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:18:29 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9F2lVU031215;
        Mon, 9 Nov 2020 10:18:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=JPX5YwarCBpTjYs4DskcnPOX9VxwgLLIzXiITYjxVPs=;
 b=GxoQqVdDlpLRuEqYRvd/rvvO2uAPryOXzLT/qn+9hAAOq1aMAP0hIIocl4EsnlTI5BLF
 C44pi+9qBJyNt+GDMqk4x9MM+QSkP39SQEuPMLwFKkhDGOC9A5x7Orh8IQhOi+Yzt3rR
 uRl77M3lcdp2zEF/Tks22d3rFZt6EDsfoRYCE4yVXmnGbvfFkI9B27aiGuj2u0qDcu0v
 hi7NdKB03se4Fa9DvSIuy0Mzr3p4o/IVn+YTs7RgkpnlLvzo3+FL5vg7vu9AzSDgn5OK
 8eAIbzf0XtFAEcZWicMzZof/qAOBfeCJwzRn7iI/uAdjBBT3S7VBFiXgTsK6TxWo/Tmy yw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34q4arqvpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 10:18:28 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A9FBin4025115;
        Mon, 9 Nov 2020 15:18:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 34njuh25ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 15:18:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A9FIN7q16253264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 15:18:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C73DA405B;
        Mon,  9 Nov 2020 15:18:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E56BA4054;
        Mon,  9 Nov 2020 15:18:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 15:18:22 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v4 15/15] net/smc: Add support for obtaining system information
Date:   Mon,  9 Nov 2020 16:18:14 +0100
Message-Id: <20201109151814.15040-16-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201109151814.15040-1-kgraul@linux.ibm.com>
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_07:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=1
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090102
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
 include/uapi/linux/smc_diag.h | 17 ++++++++++
 net/smc/smc_clc.c             |  5 +++
 net/smc/smc_clc.h             |  1 +
 net/smc/smc_core.c            |  3 ++
 net/smc/smc_core.h            |  3 ++
 net/smc/smc_diag.c            | 62 +++++++++++++++++++++++++++++++++++
 7 files changed, 92 insertions(+)

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
index 4c6332785533..d63b08c0b7e8 100644
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
 
@@ -131,6 +137,17 @@ struct smc_diag_v2_lgr_info {
 	__u8		peer_hostname[SMC_MAX_HOSTNAME_LEN]; /* Peer host */
 };
 
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
index f23f8f1d10d8..b79daa3cf0b0 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -235,6 +235,9 @@ static const struct smc_diag_ops smc_diag_ops = {
 	.get_chid		= smc_ism_get_chid,
 	.get_ib_devices		= smc_get_smc_ib_devices,
 	.is_ib_port_active	= smc_ib_port_active,
+	.get_system_eid		= smc_ism_get_system_eid,
+	.get_hostname		= smc_clc_get_hostname,
+	.is_v2_capable		= smc_ism_is_v2_capable,
 };
 
 const struct smc_diag_ops *smc_get_diag_ops(void)
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 6bf89bfe34bd..3536fa3e45af 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -27,6 +27,9 @@ struct smc_diag_ops {
 	u16 (*get_chid)(struct smcd_dev *smcd);
 	struct smc_ib_devices *(*get_ib_devices)(void);
 	bool (*is_ib_port_active)(struct smc_ib_device *smcibdev, u8 ibport);
+	void (*get_system_eid)(struct smcd_dev *smcd, u8 **eid);
+	void (*get_hostname)(u8 **host);
+	bool (*is_v2_capable)(void);
 };
 
 struct smc_lgr_list {			/* list of link group definition */
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 3d5151919326..baa6c66aa320 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -671,6 +671,64 @@ static int smc_diag_prep_smcr_dev(struct smc_ib_devices *dev_list,
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
+	smc_sys_info.smc_ism_is_v2 = smc_diag_ops->is_v2_capable();
+	smc_sys_info.smc_version = SMC_V2;
+	smc_sys_info.smc_release = SMC_RELEASE;
+	smc_diag_ops->get_hostname(&host);
+
+	if (host)
+		memcpy(smc_sys_info.local_hostname, host,
+		       sizeof(smc_sys_info.local_hostname));
+	mutex_lock(&dev_list->mutex);
+	smcd_dev = list_first_entry_or_null(&dev_list->list,
+					    struct smcd_dev, list);
+	if (smcd_dev)
+		smc_diag_ops->get_system_eid(smcd_dev, &seid);
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
@@ -779,6 +837,10 @@ static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
 		if ((req->cmd_ext & (1 << (SMC_DIAG_DEV_INFO_SMCR - 1))))
 			smc_diag_prep_smcr_dev(smc_diag_ops->get_ib_devices(),
 					       skb, cb, req);
+	} else if (req->cmd == SMC_DIAG_GET_SYS_INFO) {
+		if ((req->cmd_ext & (1 << (SMC_DIAG_SYS_INFO - 1))))
+			smc_diag_prep_sys_info(smc_diag_ops->get_smcd_devices(),
+					       skb, cb, req);
 	}
 
 	return skb->len;
-- 
2.17.1

