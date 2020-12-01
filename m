Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C092CABB4
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404272AbgLATVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29324 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727229AbgLATVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:49 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J1xsR020501;
        Tue, 1 Dec 2020 14:21:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=/89SxBV3e40iB7nFteWwA1cQdx7LzWXNG1hw9nPXzpw=;
 b=CPsTA1TgFvIZFOrZSdAhniwJCNwKf61dvF/Kkv7UPYuRXXWYJd0HkSYwWt8PIQ55KemO
 jgcOL9VqfVB6w5zdO+ajZu9Mj7jyNwvT5E0jwBk2tgaNykkXQmU7ZZxAR2HDp4u9rx0D
 uPJ0zS+gUKDEym7HKBUIZpAy+2QEFCyedSkE5RVzuAKQaBgcWPoJMU/jACTREgzrcQn/
 dsav5fydKtkY7rLc1gPcCJNw4gu/xk1AgJtggHCcsL3naZRxrQr4IKYd/kgHvdHJkxEA
 jhZSpddSczrrE5z/G0PffT7Oou6zjZdPBAhMoFxCHuDC7SkBw1wJqdEI7Gzu2y4CZY3l Rw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355k18r5t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:04 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JHY1p027648;
        Tue, 1 Dec 2020 19:21:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 353e689srt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:21:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKxSV5767806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5718CAE051;
        Tue,  1 Dec 2020 19:20:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 139E1AE04D;
        Tue,  1 Dec 2020 19:20:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:59 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 13/14] net/smc: Add support for obtaining SMCD device list
Date:   Tue,  1 Dec 2020 20:20:48 +0100
Message-Id: <20201201192049.53517-14-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Deliver SMCD device information via netlink based
diagnostic interface.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h | 28 +++++++++++++
 net/smc/smc_core.h       | 28 +++++++++++++
 net/smc/smc_ism.c        | 91 ++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_ism.h        |  1 +
 net/smc/smc_netlink.c    |  6 +++
 5 files changed, 154 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 707e8af4f0c8..3cb40ab049d9 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -37,12 +37,15 @@ enum {				/* SMC PNET Table commands */
 #define SMC_GENL_FAMILY_NAME		"SMC_GEN_NETLINK"
 #define SMC_GENL_FAMILY_VERSION		1
 
+#define SMC_PCI_ID_STR_LEN		16 /* Max length of pci id string */
+
 /* SMC_GENL_FAMILY commands */
 enum {
 	SMC_NETLINK_GET_SYS_INFO = 1,
 	SMC_NETLINK_GET_LGR_SMCR,
 	SMC_NETLINK_GET_LINK_SMCR,
 	SMC_NETLINK_GET_LGR_SMCD,
+	SMC_NETLINK_GET_DEV_SMCD,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -52,6 +55,7 @@ enum {
 	SMC_GEN_LGR_SMCR,		/* nest */
 	SMC_GEN_LINK_SMCR,		/* nest */
 	SMC_GEN_LGR_SMCD,		/* nest */
+	SMC_GEN_DEV_SMCD,		/* nest */
 	__SMC_GEN_MAX,
 	SMC_GEN_MAX = __SMC_GEN_MAX - 1
 };
@@ -122,4 +126,28 @@ enum {
 	__SMC_NLA_LGR_D_MAX,
 	SMC_NLA_LGR_D_MAX = __SMC_NLA_LGR_D_MAX - 1
 };
+
+/* SMC_NLA_DEV_PORT attributes */
+enum {
+	SMC_NLA_DEV_PORT_UNSPEC,
+	SMC_NLA_DEV_PORT_PNET_USR,	/* u8 */
+	SMC_NLA_DEV_PORT_PNETID,	/* string */
+	__SMC_NLA_DEV_PORT_MAX,
+	SMC_NLA_DEV_PORT_MAX = __SMC_NLA_DEV_PORT_MAX - 1
+};
+
+/* SMC_GEN_DEV_SMCD attributes */
+enum {
+	SMC_NLA_DEV_UNSPEC,
+	SMC_NLA_DEV_USE_CNT,		/* u32 */
+	SMC_NLA_DEV_IS_CRIT,		/* u8 */
+	SMC_NLA_DEV_PCI_FID,		/* u32 */
+	SMC_NLA_DEV_PCI_CHID,		/* u16 */
+	SMC_NLA_DEV_PCI_VENDOR,		/* u16 */
+	SMC_NLA_DEV_PCI_DEVICE,		/* u16 */
+	SMC_NLA_DEV_PCI_ID,		/* string */
+	SMC_NLA_DEV_PORT,		/* nest */
+	__SMC_NLA_DEV_MAX,
+	SMC_NLA_DEV_MAX = __SMC_NLA_DEV_MAX - 1
+};
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 0b6899a7f634..e8e448771f85 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -13,6 +13,8 @@
 #define _SMC_CORE_H
 
 #include <linux/atomic.h>
+#include <linux/smc.h>
+#include <linux/pci.h>
 #include <rdma/ib_verbs.h>
 #include <net/genetlink.h>
 
@@ -380,6 +382,32 @@ static inline void smc_gid_be16_convert(__u8 *buf, u8 *gid_raw)
 		be16_to_cpu(((__be16 *)gid_raw)[7]));
 }
 
+struct smc_pci_dev {
+	__u32		pci_fid;
+	__u16		pci_pchid;
+	__u16		pci_vendor;
+	__u16		pci_device;
+	__u8		pci_id[SMC_PCI_ID_STR_LEN];
+};
+
+static inline void smc_set_pci_values(struct pci_dev *pci_dev,
+				      struct smc_pci_dev *smc_dev)
+{
+	smc_dev->pci_vendor = pci_dev->vendor;
+	smc_dev->pci_device = pci_dev->device;
+	snprintf(smc_dev->pci_id, sizeof(smc_dev->pci_id), "%s",
+		 pci_name(pci_dev));
+#if IS_ENABLED(CONFIG_S390)
+	{ /* Set s390 specific PCI information */
+	struct zpci_dev *zdev;
+
+	zdev = to_zpci(pci_dev);
+	smc_dev->pci_fid = zdev->fid;
+	smc_dev->pci_pchid = zdev->pchid;
+	}
+#endif
+}
+
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 2456ee8228cd..524ef64a191a 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -15,6 +15,7 @@
 #include "smc_core.h"
 #include "smc_ism.h"
 #include "smc_pnet.h"
+#include "smc_netlink.h"
 
 struct smcd_dev_list smcd_dev_list = {
 	.list = LIST_HEAD_INIT(smcd_dev_list.list),
@@ -207,6 +208,96 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 	return rc;
 }
 
+static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
+				  struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	char smc_pnet[SMC_MAX_PNETID_LEN + 1];
+	struct smc_pci_dev smc_pci_dev;
+	struct nlattr *port_attrs;
+	struct nlattr *attrs;
+	int use_cnt = 0;
+	void *nlh;
+
+	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_GET_DEV_SMCD);
+	if (!nlh)
+		goto errmsg;
+	attrs = nla_nest_start(skb, SMC_GEN_DEV_SMCD);
+	if (!attrs)
+		goto errout;
+	use_cnt = atomic_read(&smcd->lgr_cnt);
+	if (nla_put_u32(skb, SMC_NLA_DEV_USE_CNT, use_cnt))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_DEV_IS_CRIT, use_cnt > 0))
+		goto errattr;
+	memset(&smc_pci_dev, 0, sizeof(smc_pci_dev));
+	smc_set_pci_values(to_pci_dev(smcd->dev.parent), &smc_pci_dev);
+	if (nla_put_u32(skb, SMC_NLA_DEV_PCI_FID, smc_pci_dev.pci_fid))
+		goto errattr;
+	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_CHID, smc_pci_dev.pci_pchid))
+		goto errattr;
+	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_VENDOR, smc_pci_dev.pci_vendor))
+		goto errattr;
+	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_DEVICE, smc_pci_dev.pci_device))
+		goto errattr;
+	if (nla_put_string(skb, SMC_NLA_DEV_PCI_ID, smc_pci_dev.pci_id))
+		goto errattr;
+
+	port_attrs = nla_nest_start(skb, SMC_NLA_DEV_PORT);
+	if (!port_attrs)
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_DEV_PORT_PNET_USR, smcd->pnetid_by_user))
+		goto errportattr;
+	snprintf(smc_pnet, sizeof(smc_pnet), "%s", smcd->pnetid);
+	if (nla_put_string(skb, SMC_NLA_DEV_PORT_PNETID, smc_pnet))
+		goto errportattr;
+
+	nla_nest_end(skb, port_attrs);
+	nla_nest_end(skb, attrs);
+	genlmsg_end(skb, nlh);
+	return 0;
+
+errportattr:
+	nla_nest_cancel(skb, port_attrs);
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	nlmsg_cancel(skb, nlh);
+errmsg:
+	return -EMSGSIZE;
+}
+
+static void smc_nl_prep_smcd_dev(struct smcd_dev_list *dev_list,
+				 struct sk_buff *skb,
+				 struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	int snum = cb_ctx->pos[0];
+	struct smcd_dev *smcd;
+	int num = 0;
+
+	mutex_lock(&dev_list->mutex);
+	list_for_each_entry(smcd, &dev_list->list, list) {
+		if (num < snum)
+			goto next;
+		if (smc_nl_handle_smcd_dev(smcd, skb, cb))
+			goto errout;
+next:
+		num++;
+	}
+errout:
+	mutex_unlock(&dev_list->mutex);
+	cb_ctx->pos[0] = num;
+}
+
+int smcd_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	smc_nl_prep_smcd_dev(&smcd_dev_list, skb, cb);
+	return skb->len;
+}
+
 struct smc_ism_event_work {
 	struct work_struct work;
 	struct smcd_dev *smcd;
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 481a4b7df30b..113efc7352ed 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -52,4 +52,5 @@ void smc_ism_get_system_eid(struct smcd_dev *dev, u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
 bool smc_ism_is_v2_capable(void);
 void smc_ism_init(void);
+int smcd_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb);
 #endif
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index 95bce936534f..debdeec53728 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -17,6 +17,7 @@
 #include <linux/smc.h>
 
 #include "smc_core.h"
+#include "smc_ism.h"
 #include "smc_netlink.h"
 
 #define SMC_CMD_MAX_ATTR 1
@@ -43,6 +44,11 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		/* can be retrieved by unprivileged users */
 		.dumpit = smcd_nl_get_lgr,
 	},
+	{
+		.cmd = SMC_NETLINK_GET_DEV_SMCD,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smcd_nl_get_device,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
-- 
2.17.1

