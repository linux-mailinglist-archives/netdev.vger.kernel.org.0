Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38865135011
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbgAHXn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:43:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16148 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgAHXn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:43:56 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008Ndbkm014072
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 15:43:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=zkItAPuRvdWqFuaSnwRuHhLzPQYy7zZHZf8Q96gL7lk=;
 b=fXO/fr2Fk6lJdW063UYHcS2fk0Sucm5g8imiw4RfqRGqFV3+wntp/Okulh6Q1Ff0Hp83
 Z1pup1Om5n0dLKoCeJtVzjXh7SgL92iWgsMgdAJkeCWCEc0poWNmBouHtlw01jt6upFP
 p6TE0UwW3o114qxaE5T+hDTGutyZX+kERUg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xcy1vqxng-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 15:43:55 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 8 Jan 2020 15:43:53 -0800
Received: by devvm4117.prn2.facebook.com (Postfix, from userid 167582)
        id 4AC391985925A; Wed,  8 Jan 2020 15:43:52 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Vijay Khemka <vijaykhemka@fb.com>
Smtp-Origin-Hostname: devvm4117.prn2.facebook.com
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <vijaykhemka@fb.com>, <joel@jms.id.au>, <openbmc@lists.ozlabs.org>,
        <sdasari@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [net-next PATCH] net/ncsi: Support for multi host mellanox card
Date:   Wed, 8 Jan 2020 15:43:40 -0800
Message-ID: <20200108234341.2590674-1-vijaykhemka@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multi host Mellanox cards require MAC affinity to be set
before receiving any config commands. All config commands
should also have unicast address for source address in
command header.

Adding GMA and SMAF(Set Mac Affinity) for Mellanox card
and call these in channel probe state machine if it is
defined in device tree.

Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>
---
 net/ncsi/internal.h    | 20 ++++++++++++
 net/ncsi/ncsi-manage.c | 69 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index ad3fd7f1da75..e37102546be6 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -64,6 +64,17 @@ enum {
 	NCSI_MODE_MAX
 };
 
+/* Supported media status bits for Mellanox Mac affinity command.
+ * Bit (0-2) for different protocol support; Bit 1 for RBT support,
+ * bit 1 for SMBUS support and bit 2 for PCIE support. Bit (3-5)
+ * for different protocol availability. Bit 4 for RBT, bit 4 for
+ * SMBUS and bit 5 for PCIE.
+ */
+enum {
+	MLX_MC_RBT_SUPPORT  = 0x01, /* MC supports RBT         */
+	MLX_MC_RBT_AVL      = 0x08, /* RBT medium is available */
+};
+
 /* OEM Vendor Manufacture ID */
 #define NCSI_OEM_MFR_MLX_ID             0x8119
 #define NCSI_OEM_MFR_BCM_ID             0x113d
@@ -72,9 +83,15 @@ enum {
 /* Mellanox specific OEM Command */
 #define NCSI_OEM_MLX_CMD_GMA            0x00   /* CMD ID for Get MAC */
 #define NCSI_OEM_MLX_CMD_GMA_PARAM      0x1b   /* Parameter for GMA  */
+#define NCSI_OEM_MLX_CMD_SMAF           0x01   /* CMD ID for Set MC Affinity */
+#define NCSI_OEM_MLX_CMD_SMAF_PARAM     0x07   /* Parameter for SMAF         */
 /* OEM Command payload lengths*/
 #define NCSI_OEM_BCM_CMD_GMA_LEN        12
 #define NCSI_OEM_MLX_CMD_GMA_LEN        8
+#define NCSI_OEM_MLX_CMD_SMAF_LEN        60
+/* Offset in OEM request */
+#define MLX_SMAF_MAC_ADDR_OFFSET         8     /* Offset for MAC in SMAF    */
+#define MLX_SMAF_MED_SUPPORT_OFFSET      14    /* Offset for medium in SMAF */
 /* Mac address offset in OEM response */
 #define BCM_MAC_ADDR_OFFSET             28
 #define MLX_MAC_ADDR_OFFSET             8
@@ -251,6 +268,8 @@ enum {
 	ncsi_dev_state_probe_deselect	= 0x0201,
 	ncsi_dev_state_probe_package,
 	ncsi_dev_state_probe_channel,
+	ncsi_dev_state_probe_mlx_gma,
+	ncsi_dev_state_probe_mlx_smaf,
 	ncsi_dev_state_probe_cis,
 	ncsi_dev_state_probe_gvi,
 	ncsi_dev_state_probe_gc,
@@ -311,6 +330,7 @@ struct ncsi_dev_priv {
 	struct list_head    vlan_vids;       /* List of active VLAN IDs */
 
 	bool                multi_package;   /* Enable multiple packages   */
+	bool                mlx_multi_host;  /* Enable multi host Mellanox */
 	u32                 package_whitelist; /* Packages to configure    */
 };
 
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index e20b81514029..1f387be7827b 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -8,6 +8,8 @@
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 
 #include <net/ncsi.h>
 #include <net/net_namespace.h>
@@ -730,6 +732,34 @@ static int ncsi_oem_gma_handler_mlx(struct ncsi_cmd_arg *nca)
 	return ret;
 }
 
+static int ncsi_oem_smaf_mlx(struct ncsi_cmd_arg *nca)
+{
+	union {
+		u8 data_u8[NCSI_OEM_MLX_CMD_SMAF_LEN];
+		u32 data_u32[NCSI_OEM_MLX_CMD_SMAF_LEN / sizeof(u32)];
+	} u;
+	int ret = 0;
+
+	memset(&u, 0, sizeof(u));
+	u.data_u32[0] = ntohl(NCSI_OEM_MFR_MLX_ID);
+	u.data_u8[5] = NCSI_OEM_MLX_CMD_SMAF;
+	u.data_u8[6] = NCSI_OEM_MLX_CMD_SMAF_PARAM;
+	memcpy(&u.data_u8[MLX_SMAF_MAC_ADDR_OFFSET],
+	       nca->ndp->ndev.dev->dev_addr,	ETH_ALEN);
+	u.data_u8[MLX_SMAF_MED_SUPPORT_OFFSET] =
+		(MLX_MC_RBT_AVL | MLX_MC_RBT_SUPPORT);
+
+	nca->payload = NCSI_OEM_MLX_CMD_SMAF_LEN;
+	nca->data = u.data_u8;
+
+	ret = ncsi_xmit_cmd(nca);
+	if (ret)
+		netdev_err(nca->ndp->ndev.dev,
+			   "NCSI: Failed to transmit cmd 0x%x during probe\n",
+			   nca->type);
+	return ret;
+}
+
 /* OEM Command handlers initialization */
 static struct ncsi_oem_gma_handler {
 	unsigned int	mfr_id;
@@ -1310,8 +1340,38 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 			break;
 		}
 		nd->state = ncsi_dev_state_probe_cis;
+		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC) &&
+		    ndp->mlx_multi_host)
+			nd->state = ncsi_dev_state_probe_mlx_gma;
+
 		schedule_work(&ndp->work);
 		break;
+#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
+	case ncsi_dev_state_probe_mlx_gma:
+		ndp->pending_req_num = 1;
+
+		nca.type = NCSI_PKT_CMD_OEM;
+		nca.package = ndp->active_package->id;
+		nca.channel = 0;
+		ret = ncsi_oem_gma_handler_mlx(&nca);
+		if (ret)
+			goto error;
+
+		nd->state = ncsi_dev_state_probe_mlx_smaf;
+		break;
+	case ncsi_dev_state_probe_mlx_smaf:
+		ndp->pending_req_num = 1;
+
+		nca.type = NCSI_PKT_CMD_OEM;
+		nca.package = ndp->active_package->id;
+		nca.channel = 0;
+		ret = ncsi_oem_smaf_mlx(&nca);
+		if (ret)
+			goto error;
+
+		nd->state = ncsi_dev_state_probe_cis;
+		break;
+#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
 	case ncsi_dev_state_probe_cis:
 		ndp->pending_req_num = NCSI_RESERVED_CHANNEL;
 
@@ -1621,6 +1681,8 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 {
 	struct ncsi_dev_priv *ndp;
 	struct ncsi_dev *nd;
+	struct platform_device *pdev;
+	struct device_node *np;
 	unsigned long flags;
 	int i;
 
@@ -1667,6 +1729,13 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 	/* Set up generic netlink interface */
 	ncsi_init_netlink(dev);
 
+	pdev = to_platform_device(dev->dev.parent);
+	if (pdev) {
+		np = pdev->dev.of_node;
+		if (np && of_get_property(np, "mlx,multi-host", NULL))
+			ndp->mlx_multi_host = true;
+	}
+
 	return nd;
 }
 EXPORT_SYMBOL_GPL(ncsi_register_dev);
-- 
2.17.1

