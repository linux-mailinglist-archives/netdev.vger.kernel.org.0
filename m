Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0075D1E52CA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgE1BRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:17:55 -0400
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:6231
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbgE1BRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:17:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWC8apIRX9ajFg0W4cNs53k2wCn4s0NxWLyJtMGWOCr6uX4BmiOLjGDFwgW4djPLHWo/hMDPIFB+t1VcjqDDzes0AovKG34y1IdEvW6CZQlmrglRY4ZhnbBECcwaanibqOvTLGtE5NhU6jYGOsOViDlVcE3YjViQq1xzpTahR9byLekfcNOLvtffeUyoNf+9lbM/f+SMEyFFjHZQQcr0QT0Ou9vUuoPLTnEKnG/7yWwkAp/6K07JCADtQH15WO6GjsxAC3FpacJ+fLr90zJhHuU+xjn5WGGZ2aR8mNjnvaJMbzyh8FGwQv8nYtGU6SVP4yBTRbtgBWgdm66FPAeKiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XU7XoKyq0Pjs46fgv/84EcYBVRr/v56avPc2XRjUn8=;
 b=Etgg5aDAOaMkBPOJSfzVz4PivYzfJ6OzyWgehaV6xluRFp8bvshqRrl4/REep4CVE8uSbCO3aEPFpRzLi0MpzF9sSQms9qNEjz5h65z0C9tS9d11UtXHLG6lO89Q6BDlVglBOaMGa6TkozDdbzxwR8xwM49MrzEKxWDAACjjiOl10ven/LV2EoEY22L6IHxoGIgkbjQOCns0vwqt4+8fzH/QVeVSOYszrBIJyB6DF6hAIWyM6a+MjoGvAwRVVonQYzn1ZjszA4J4A1ebZOZ16TfzvI5of7xZVVW5TvaQq46nBbSw91HZyftvCtPCH8JQiC16B9WFweaJ5Thz279S4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XU7XoKyq0Pjs46fgv/84EcYBVRr/v56avPc2XRjUn8=;
 b=gW35zCXZOugi1d+PBtHXQow6AHh8FaPscR0OqrS/78ChjNf6uTp4CJIIrQ0is6bVq48Rvpjy01bTHLkhfwcnxn4cRpEx0w29BbQo4adVnBQiYyUX79pHmDOGt203MokeiyTaIqhuzTn6C4Bl2z8CBCJvKqdIKRwOj5fw52YK/Wo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 05/15] net/mlx5e: Support tc block sharing for representors
Date:   Wed, 27 May 2020 18:16:46 -0700
Message-Id: <20200528011656.559914-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:34 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53960db5-d1ac-437f-c5f7-08d802a4e850
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43687E4C46FFC730F87CF2F9BE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EQH0A4muKVZ3WQn6PpY2EOfc0578BCkEaXjUfgP0oxSeyrUiJJb1+ZVsJ7DGSMwao+mWIImbTAygBSrqZ7A6VkkUf/2M4w/XB64CfGZq7Y3UBoU1wesyzgRKK1cCIpEvORJM2K1/Hdno4CechedY9MrqBrYSHuosCfYFpI2BLlhxh1OjH6k6Pno+KZ772MMbU4VvpQvi7UlDxw5sgncmjn56mhifBqvmYumhoBTpeaWlDJHHd7bxLZiaf5FGIylJLgo7dX3MqmbsqPEkW571vfnV97NdLb06fUo5zwONOd0TZ+TRJiQNGbXoX585uBNRygtRiVAol0LEp4trQjEzMJ+GTOALmsBShGZ4R0xD+y78pceT3CJPpEu/mbLro1k1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: n57IN2fSFYILK5XQnHSt12B/XWkrKPeIuTMpB5UjweO++siMmlMYjU9F4NRBzeBChaMroxOvU4oYk4nCtW2mDcI4OfrarttZlT9yk/mAOC2aIkD8Ujo60GqO9MMefKwdmrr5iEXnFCKlbndjOpbCiW8cSPt6TM3Osphv6Mt2lr8UHI68mQrGQloiCZwlwZO4mayWzPlWPwr3Ib18/TTpHRYFhyqaGo/LBcahBDWR4N6Tj2VVEInTXsHvlceluwqpBlhDvdDlfvR1M8GUF8dk9HRDcBJrfEfmENeWqDEw5w4XegcPyzpzwV6U3aXo3tTJRapdog+qqCPRuDqU+hEBg6lnBn9Z2+Epk9PAVQtMuWJv/FphIS6ghCtYDogZg5JM7RvIBCPJwcLHJScj6FiHreBBGpnGdtmWIH3iFiN4Zlam6BzX/Yvk7kRNPoqgXi6rZF9BdlQrE+dmNmUtVH6TE06wv20rQ6q7XZkF2qE4YGY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53960db5-d1ac-437f-c5f7-08d802a4e850
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:37.0593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHkb+VkgwJrdBrYLmGmn0HZzc0zZZ+FpTdRC2GI6vlLBY59bqTO/osy3k6FYA3FDCRy/MZ2pWCMzQ6GDBgmjOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Currently offloading a rule over a tc block shared by multiple
representors fails because an e-switch global hashtable to keep
the mapping from tc cookies to mlx5e flow instances is used, and
tc block sharing offloads the same rule/cookie multiple times,
each time for different representor sharing the tc block.

Changing the implementation and behavior by acknowledging and returning
success if the same rule/cookie is offloaded again to other slave
representor sharing the tc block by setting, checking and comparing
the netdev that added the rule first.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 571da14809fe..f3e65a15c950 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -145,6 +145,7 @@ struct mlx5e_tc_flow {
 	struct list_head	hairpin; /* flows sharing the same hairpin */
 	struct list_head	peer;    /* flows with peer flow */
 	struct list_head	unready; /* flows not ready to be offloaded (e.g due to missing route) */
+	struct net_device	*orig_dev; /* netdev adding flow first */
 	int			tmp_efi_index;
 	struct list_head	tmp_list; /* temporary flow list used by neigh update */
 	refcount_t		refcnt;
@@ -4624,11 +4625,21 @@ mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 	return err;
 }
 
+static bool is_flow_rule_duplicate_allowed(struct net_device *dev,
+					   struct mlx5e_rep_priv *rpriv)
+{
+	/* Offloaded flow rule is allowed to duplicate on non-uplink representor
+	 * sharing tc block with other slaves of a lag device.
+	 */
+	return netif_is_lag_port(dev) && rpriv->rep->vport != MLX5_VPORT_UPLINK;
+}
+
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 			   struct flow_cls_offload *f, unsigned long flags)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct rhashtable *tc_ht = get_tc_ht(priv, flags);
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5e_tc_flow *flow;
 	int err = 0;
 
@@ -4636,6 +4647,12 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
 	rcu_read_unlock();
 	if (flow) {
+		/* Same flow rule offloaded to non-uplink representor sharing tc block,
+		 * just return 0.
+		 */
+		if (is_flow_rule_duplicate_allowed(dev, rpriv) && flow->orig_dev != dev)
+			goto out;
+
 		NL_SET_ERR_MSG_MOD(extack,
 				   "flow cookie already exists, ignoring");
 		netdev_warn_once(priv->netdev,
@@ -4650,6 +4667,12 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	if (err)
 		goto out;
 
+	/* Flow rule offloaded to non-uplink representor sharing tc block,
+	 * set the flow's owner dev.
+	 */
+	if (is_flow_rule_duplicate_allowed(dev, rpriv))
+		flow->orig_dev = dev;
+
 	err = rhashtable_lookup_insert_fast(tc_ht, &flow->node, tc_ht_params);
 	if (err)
 		goto err_free;
-- 
2.26.2

