Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E554C2C5D1D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 21:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391251AbgKZUji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 15:39:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65446 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391039AbgKZUjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 15:39:36 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKVlsF099297;
        Thu, 26 Nov 2020 15:39:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ovdwpY9NAMphPYveSCGkaTzXjSHjVf1WtoD2I9ez7/s=;
 b=KrHrPwSpYi8WNh9VahUMCbN480KMiA4mK1wHh6YXwXfOfVyr97R4/fPjtCJl4l0jGqKM
 wiL00u0lGObiv40Ozxtm0GVnFWguUB0gyb6u6dg5X2Ov5Fmme2a1efjbG89hEiX1TyGw
 /gSqFEMc6vMIMjKc+xXtBfSW1x4EFNaZ9pQpkQ1GKl9HvaOADUXsaGPQkzx+k9TummfG
 z4hW1NUJEEEY3RTARky4RQ4xjt1zLAo1FMhGs4JmuI9lblt0FyBmpgX7u09q8RXr0kNi
 rgm93nIYW5T8CfD8ZHx8fB4fwS8VyNoWIoF/LyUk6u0G5CMHT8BkMWAlZpQjaC7/36fv aQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352e4pqx1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 15:39:31 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKXu6p005253;
        Thu, 26 Nov 2020 20:39:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 352drkg5r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 20:39:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQKdQD78848064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 20:39:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68C3BA4040;
        Thu, 26 Nov 2020 20:39:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E396A404D;
        Thu, 26 Nov 2020 20:39:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 20:39:26 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v6 14/14] net/smc: Add support for obtaining SMCR device list
Date:   Thu, 26 Nov 2020 21:39:16 +0100
Message-Id: <20201126203916.56071-15-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201126203916.56071-1-kgraul@linux.ibm.com>
References: <20201126203916.56071-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_09:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 malwarescore=0 suspectscore=2 bulkscore=0 phishscore=0 adultscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Deliver SMCR device information via netlink based
diagnostic interface.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h |  13 +++-
 net/smc/smc_core.c       |   2 +-
 net/smc/smc_ib.c         | 156 +++++++++++++++++++++++++++++++++++++++
 net/smc/smc_ib.h         |   2 +
 net/smc/smc_netlink.c    |   6 ++
 5 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 3cb40ab049d9..3e68da07fba2 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -46,6 +46,7 @@ enum {
 	SMC_NETLINK_GET_LINK_SMCR,
 	SMC_NETLINK_GET_LGR_SMCD,
 	SMC_NETLINK_GET_DEV_SMCD,
+	SMC_NETLINK_GET_DEV_SMCR,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -56,6 +57,7 @@ enum {
 	SMC_GEN_LINK_SMCR,		/* nest */
 	SMC_GEN_LGR_SMCD,		/* nest */
 	SMC_GEN_DEV_SMCD,		/* nest */
+	SMC_GEN_DEV_SMCR,		/* nest */
 	__SMC_GEN_MAX,
 	SMC_GEN_MAX = __SMC_GEN_MAX - 1
 };
@@ -127,16 +129,20 @@ enum {
 	SMC_NLA_LGR_D_MAX = __SMC_NLA_LGR_D_MAX - 1
 };
 
-/* SMC_NLA_DEV_PORT attributes */
+/* SMC_NLA_DEV_PORT nested attributes */
 enum {
 	SMC_NLA_DEV_PORT_UNSPEC,
 	SMC_NLA_DEV_PORT_PNET_USR,	/* u8 */
 	SMC_NLA_DEV_PORT_PNETID,	/* string */
+	SMC_NLA_DEV_PORT_NETDEV,	/* u32 */
+	SMC_NLA_DEV_PORT_STATE,		/* u8 */
+	SMC_NLA_DEV_PORT_VALID,		/* u8 */
+	SMC_NLA_DEV_PORT_LNK_CNT,	/* u32 */
 	__SMC_NLA_DEV_PORT_MAX,
 	SMC_NLA_DEV_PORT_MAX = __SMC_NLA_DEV_PORT_MAX - 1
 };
 
-/* SMC_GEN_DEV_SMCD attributes */
+/* SMC_GEN_DEV_SMCD and SMC_GEN_DEV_SMCR attributes */
 enum {
 	SMC_NLA_DEV_UNSPEC,
 	SMC_NLA_DEV_USE_CNT,		/* u32 */
@@ -147,7 +153,10 @@ enum {
 	SMC_NLA_DEV_PCI_DEVICE,		/* u16 */
 	SMC_NLA_DEV_PCI_ID,		/* string */
 	SMC_NLA_DEV_PORT,		/* nest */
+	SMC_NLA_DEV_PORT2,		/* nest */
+	SMC_NLA_DEV_IB_NAME,		/* string */
 	__SMC_NLA_DEV_MAX,
 	SMC_NLA_DEV_MAX = __SMC_NLA_DEV_MAX - 1
 };
+
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 501c0aefec7f..a9f5ed16729e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -38,7 +38,7 @@
 #define SMC_LGR_FREE_DELAY_SERV		(600 * HZ)
 #define SMC_LGR_FREE_DELAY_CLNT		(SMC_LGR_FREE_DELAY_SERV + 10 * HZ)
 
-static struct smc_lgr_list smc_lgr_list = {	/* established link groups */
+struct smc_lgr_list smc_lgr_list = {	/* established link groups */
 	.lock = __SPIN_LOCK_UNLOCKED(smc_lgr_list.lock),
 	.list = LIST_HEAD_INIT(smc_lgr_list.list),
 	.num = 0,
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 61b025c912a9..e0ba3c22107c 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -25,6 +25,7 @@
 #include "smc_core.h"
 #include "smc_wr.h"
 #include "smc.h"
+#include "smc_netlink.h"
 
 #define SMC_MAX_CQE 32766	/* max. # of completion queue elements */
 
@@ -326,6 +327,161 @@ int smc_ib_create_protection_domain(struct smc_link *lnk)
 	return rc;
 }
 
+static bool smcr_diag_is_dev_critical(struct smc_lgr_list *smc_lgr,
+				      struct smc_ib_device *smcibdev)
+{
+	struct smc_link_group *lgr;
+	bool rc = false;
+	int i;
+
+	spin_lock_bh(&smc_lgr->lock);
+	list_for_each_entry(lgr, &smc_lgr->list, list) {
+		if (lgr->is_smcd)
+			continue;
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			if (lgr->lnk[i].state == SMC_LNK_UNUSED ||
+			    lgr->lnk[i].smcibdev != smcibdev)
+				continue;
+			if (lgr->type == SMC_LGR_SINGLE ||
+			    lgr->type == SMC_LGR_ASYMMETRIC_LOCAL) {
+				rc = true;
+				goto out;
+			}
+		}
+	}
+out:
+	spin_unlock_bh(&smc_lgr->lock);
+	return rc;
+}
+
+static int smc_nl_handle_dev_port(struct sk_buff *skb,
+				  struct ib_device *ibdev,
+				  struct smc_ib_device *smcibdev,
+				  int port)
+{
+	char smc_pnet[SMC_MAX_PNETID_LEN + 1];
+	struct nlattr *port_attrs;
+	unsigned char port_state;
+	int lnk_count = 0;
+
+	port_attrs = nla_nest_start_noflag(skb, SMC_NLA_DEV_PORT + port);
+	if (!port_attrs)
+		goto errout;
+
+	if (nla_put_u8(skb, SMC_NLA_DEV_PORT_PNET_USR,
+		       smcibdev->pnetid_by_user[port]))
+		goto errattr;
+	snprintf(smc_pnet, sizeof(smc_pnet), "%s",
+		 (char *)&smcibdev->pnetid[port]);
+	if (nla_put_string(skb, SMC_NLA_DEV_PORT_PNETID, smc_pnet))
+		goto errattr;
+	if (nla_put_u32(skb, SMC_NLA_DEV_PORT_NETDEV,
+			smcibdev->ndev_ifidx[port]))
+		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_DEV_PORT_VALID, 1))
+		goto errattr;
+	port_state = smc_ib_port_active(smcibdev, port + 1);
+	if (nla_put_u8(skb, SMC_NLA_DEV_PORT_STATE, port_state))
+		goto errattr;
+	lnk_count = atomic_read(&smcibdev->lnk_cnt_by_port[port]);
+	if (nla_put_u32(skb, SMC_NLA_DEV_PORT_LNK_CNT, lnk_count))
+		goto errattr;
+	nla_nest_end(skb, port_attrs);
+	return 0;
+errattr:
+	nla_nest_cancel(skb, port_attrs);
+errout:
+	return -EMSGSIZE;
+}
+
+static int smc_nl_handle_smcr_dev(struct smc_ib_device *smcibdev,
+				  struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	char smc_ibname[IB_DEVICE_NAME_MAX + 1];
+	struct smc_pci_dev smc_pci_dev;
+	struct pci_dev *pci_dev;
+	unsigned char is_crit;
+	struct nlattr *attrs;
+	void *nlh;
+	int i;
+
+	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_GET_DEV_SMCR);
+	if (!nlh)
+		goto errmsg;
+	attrs = nla_nest_start_noflag(skb, SMC_GEN_DEV_SMCR);
+	if (!attrs)
+		goto errout;
+	is_crit = smcr_diag_is_dev_critical(&smc_lgr_list, smcibdev);
+	if (nla_put_u8(skb, SMC_NLA_DEV_IS_CRIT, is_crit))
+		goto errattr;
+	memset(&smc_pci_dev, 0, sizeof(smc_pci_dev));
+	pci_dev = to_pci_dev(smcibdev->ibdev->dev.parent);
+	smc_set_pci_values(pci_dev, &smc_pci_dev);
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
+	snprintf(smc_ibname, sizeof(smc_ibname), "%s", smcibdev->ibdev->name);
+	if (nla_put_string(skb, SMC_NLA_DEV_IB_NAME, smc_ibname))
+		goto errattr;
+	for (i = 1; i <= SMC_MAX_PORTS; i++) {
+		if (!rdma_is_port_valid(smcibdev->ibdev, i))
+			continue;
+		if (smc_nl_handle_dev_port(skb, smcibdev->ibdev,
+					   smcibdev, i - 1))
+			goto errattr;
+	}
+
+	nla_nest_end(skb, attrs);
+	genlmsg_end(skb, nlh);
+	return 0;
+
+errattr:
+	nla_nest_cancel(skb, attrs);
+errout:
+	genlmsg_cancel(skb, nlh);
+errmsg:
+	return -EMSGSIZE;
+}
+
+static void smc_nl_prep_smcr_dev(struct smc_ib_devices *dev_list,
+				 struct sk_buff *skb,
+				 struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	struct smc_ib_device *smcibdev;
+	int snum = cb_ctx->pos[0];
+	int num = 0;
+
+	mutex_lock(&dev_list->mutex);
+	list_for_each_entry(smcibdev, &dev_list->list, list) {
+		if (num < snum)
+			goto next;
+		if (smc_nl_handle_smcr_dev(smcibdev, skb, cb))
+			goto errout;
+next:
+		num++;
+	}
+errout:
+	mutex_unlock(&dev_list->mutex);
+	cb_ctx->pos[0] = num;
+}
+
+int smcr_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	smc_nl_prep_smcr_dev(&smc_ib_devices, skb, cb);
+	return skb->len;
+}
+
 static void smc_ib_qp_event_handler(struct ib_event *ibevent, void *priv)
 {
 	struct smc_link *lnk = (struct smc_link *)priv;
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index ab37da341fa8..3085f5180da7 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -30,6 +30,7 @@ struct smc_ib_devices {			/* list of smc ib devices definition */
 };
 
 extern struct smc_ib_devices	smc_ib_devices; /* list of smc ib devices */
+extern struct smc_lgr_list smc_lgr_list; /* list of linkgroups */
 
 struct smc_ib_device {				/* ib-device infos for smc */
 	struct list_head	list;
@@ -91,4 +92,5 @@ void smc_ib_sync_sg_for_device(struct smc_link *lnk,
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 			 unsigned short vlan_id, u8 gid[], u8 *sgid_index);
 bool smc_ib_is_valid_local_systemid(void);
+int smcr_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb);
 #endif
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index bf114e10d332..f5a1e48a258c 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -18,6 +18,7 @@
 
 #include "smc_core.h"
 #include "smc_ism.h"
+#include "smc_ib.h"
 #include "smc_netlink.h"
 
 /* SMC_GENL generic netlink operation definition */
@@ -47,6 +48,11 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		/* can be retrieved by unprivileged users */
 		.dumpit = smcd_nl_get_device,
 	},
+	{
+		.cmd = SMC_NETLINK_GET_DEV_SMCR,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smcr_nl_get_device,
+	},
 };
 
 /* SMC_GENL family definition */
-- 
2.17.1

