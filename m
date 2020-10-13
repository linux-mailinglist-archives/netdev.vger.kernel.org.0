Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CBE28CF76
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbgJMNtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:20 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:35766
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387848AbgJMNtQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZ5MYlcOWTVVoDko/HFLCfIBxr8hbZQaEzc3zv6WB+o5vFVr6NzUzD4aqQdOpsxexZTZg+8JiPGLu77L68sryP8+0dvTeMn2ZfzGdB/3ERaRx4T7AIlZg3ViIL3WA9lBnaCn8qY2763kEcB8Ut8oxIb54SxsOkTLtgKcOrDUXtIY5cMT6T1hdB8SirrEjZSVumGUoLaQk7OXjkeaFfmT0zodJG/RwbZ/rEVWXr8hKU9ni/vxnQiojppbJm1AXDNY6QIGTU8nwXjVTI9fSW08gGnI/KrS6CvFa7/zSs2DOEaEugBgOYSLJ7n1R032qNVjtQ9rPyBHbtRtTpZkSwlBrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOO54jQzxi8VL9PH8PoJY3MCvTxW+1UWIs3COycn6dY=;
 b=KLdyRvmov7DH4qw7rLReHlcu1ay8wRW8k1ILZ1V62la+kxYLAme/RlSH6Dfvm5rJTBaYrgTBhQ2v4pOkHH3XX/7/XZ2uP8l0fKU6KP1ckhFkEKiU27UCFTCvDR+KCAwQTSDSWQzpU2hlDcLePpnHYKmP7HLY0lPaPrPe4Hi1JyIsjkJyw1NWH1q6VnFgsh4iHOrxRLbVWceEJFP/d8pWsrL7i88h5r6fPJNwgcjdaKG+OQ/Uu5ihiCF6IQQC6RNx9YczMFH3ZIegl8qQHzGx4P/7b9uSw/8BIaSGs2a0P6GTD5BmFMMJekY7y5TfPo350GZvOvwlwZTWJjI4xUD7jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOO54jQzxi8VL9PH8PoJY3MCvTxW+1UWIs3COycn6dY=;
 b=GvW7WCbxH0h2eF0hhFbIxMtuY8Ff8k//jfeGjme08OzJhjWEJXt1egKa4wTLa+n9wrtQSYo+7GybJ+HPbWIT0LMwBF6BXXXyY6KMsvSvayV1+lBosbX0PffRGPo3DFkj018tfP4sQxkPk5CK0JIzHV/uAv03UfCzBE/wW54fbSo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Tue, 13 Oct
 2020 13:49:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 03/10] net: dsa: add ops for devlink-sb
Date:   Tue, 13 Oct 2020 16:48:42 +0300
Message-Id: <20201013134849.395986-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 86d6ea6a-a374-42ab-b036-08d86f7ec42e
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104A59FCA168B8F42D2310AE0040@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VRX2vACzAR0qulXwwqX3FklOh3GMMiE9ELBOyfsg6lbdTus5IoL3q8Mi31ZfJrsAfEfe9+0xi4qDnhjgBSoGmIMoZXm6EKY5g67jN1U1d/ovDSmqsMVPjSaTXHCHYR6vKSa4avwKypa1ra/kY9aW9miJISZBclEDSD15eXuSoRx6SrwfQPX5UGxuic12vZDeS+Xk6BWyjVtVLgAVpmJ723yEo7PkXPqRekxNrvSqM/+QEhphYGdiNkQTjRr7X/EsAcAwbZErMhgLXK1Hy9vEESJ7lnvrvOvbcRHITWEPdyIbSdS736VnzMtRMfcUcSJo1BzTdTnjksHTwcqqrI7vVlJhwJXPbeJoQufPA1aYgjG89ioyyP4XrJmiBTxWoqVA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(376002)(396003)(478600001)(83380400001)(6506007)(8936002)(69590400008)(6486002)(66556008)(66476007)(6666004)(66946007)(5660300002)(1076003)(316002)(4326008)(36756003)(956004)(8676002)(86362001)(2616005)(186003)(6916009)(16526019)(26005)(52116002)(44832011)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 63FEfuzgIg+ol77YO2pec/r7Vcg15fh5LTPfL44sm6M1gOiLW5iVPh3hp1AsW9klm5nhmg+zrBgddBw5Ty+o3n6WGUbWYpuas5zU6O8Qivw5SicRHVW4E9TeknOAaDGHMZhhTMiJNaCWEweNmwfjaUp4rdzSp2H6aJY5uN+u57Sq/Tk43JTgyjG0iI0DrkbKE60dBGqIVygqI0Rw4HWOot42rD0GZODViaExzpI+Fpsg/kRUlMm4flIajHz1TzdiVISFHs1UiDSqIouCfeeqzMKHitx2NCPMfula4Qvgkba6YNF2YQjIksjHegFdIR+Fb3tcCmHX35GoEiFBfn3BOmRf+8oYB4Sj8iJQHECvi9SHoUDU+4JXBn+5/htSuqpIKUy9z5ILiRnpYDm+Pri6yBxTch9BBpPO6Ujl87Rb5lLqPwFscsnDhroSmzS9Dgjo7B7oLuWDS32jbRMvQ+djY20gmJUROZ90PZLUlN6cTYewNQc0lCOMrf7b5BYg1I3zHzzMzf3tzoVC0BcdgFn1icmrhghLwHBNVDg9AuvBJrzcGsXjpzFYaqKDfCk6x9MJwkGFlKrB+sQas+gB7Pz9G9YyAlqnBhdimDeAjTnRPLOvBCtfJL+K/q8VJJ4PtatZHd27C0O5y1HpRaxINr2YCQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d6ea6a-a374-42ab-b036-08d86f7ec42e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:12.3660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrLYIcM2gIF3zl2/QjvKjUnuSFB4wvhv3XcDzLazhmgMLLBen9c/1Cm9dPQNzvZA3jkGSjEBCguG1ta/AFkTVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switches that care about QoS might have hardware support for reserving
buffer pools for individual ports or traffic classes, and configuring
their sizes and thresholds. Through devlink-sb (shared buffers), this is
all configurable, as well as their occupancy being viewable.

Add the plumbing in DSA for these operations.

Individual drivers still need to call devlink_sb_register() with the
shared buffers they want to expose. A helper was not created in DSA for
this purpose (unlike, say, dsa_devlink_params_register), since in my
opinion it does not bring any benefit over plainly calling
devlink_sb_register() directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  34 +++++++++
 net/dsa/dsa2.c    | 174 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 207 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 35429a140dfa..7f2174535435 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -637,6 +637,40 @@ struct dsa_switch_ops {
 	int	(*devlink_info_get)(struct dsa_switch *ds,
 				    struct devlink_info_req *req,
 				    struct netlink_ext_ack *extack);
+	int	(*devlink_sb_pool_get)(struct dsa_switch *ds,
+				       unsigned int sb_index, u16 pool_index,
+				       struct devlink_sb_pool_info *pool_info);
+	int	(*devlink_sb_pool_set)(struct dsa_switch *ds, unsigned int sb_index,
+				       u16 pool_index, u32 size,
+				       enum devlink_sb_threshold_type threshold_type,
+				       struct netlink_ext_ack *extack);
+	int	(*devlink_sb_port_pool_get)(struct dsa_switch *ds, int port,
+					    unsigned int sb_index, u16 pool_index,
+					    u32 *p_threshold);
+	int	(*devlink_sb_port_pool_set)(struct dsa_switch *ds, int port,
+					    unsigned int sb_index, u16 pool_index,
+					    u32 threshold,
+					    struct netlink_ext_ack *extack);
+	int	(*devlink_sb_tc_pool_bind_get)(struct dsa_switch *ds, int port,
+					       unsigned int sb_index, u16 tc_index,
+					       enum devlink_sb_pool_type pool_type,
+					       u16 *p_pool_index, u32 *p_threshold);
+	int	(*devlink_sb_tc_pool_bind_set)(struct dsa_switch *ds, int port,
+					       unsigned int sb_index, u16 tc_index,
+					       enum devlink_sb_pool_type pool_type,
+					       u16 pool_index, u32 threshold,
+					       struct netlink_ext_ack *extack);
+	int	(*devlink_sb_occ_snapshot)(struct dsa_switch *ds,
+					   unsigned int sb_index);
+	int	(*devlink_sb_occ_max_clear)(struct dsa_switch *ds,
+					    unsigned int sb_index);
+	int	(*devlink_sb_occ_port_pool_get)(struct dsa_switch *ds, int port,
+						unsigned int sb_index, u16 pool_index,
+						u32 *p_cur, u32 *p_max);
+	int	(*devlink_sb_occ_tc_port_bind_get)(struct dsa_switch *ds, int port,
+						   unsigned int sb_index, u16 tc_index,
+						   enum devlink_sb_pool_type pool_type,
+						   u32 *p_cur, u32 *p_max);
 
 	/*
 	 * MTU change functionality. Switches can also adjust their MRU through
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 183003e45762..61f2cfb96da4 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -400,8 +400,180 @@ static int dsa_devlink_info_get(struct devlink *dl,
 	return -EOPNOTSUPP;
 }
 
+static struct dsa_port *devlink_to_dsa_port(struct devlink_port *dlp)
+{
+	return container_of(dlp, struct dsa_port, devlink_port);
+}
+
+static int dsa_devlink_sb_pool_get(struct devlink *dl,
+				   unsigned int sb_index, u16 pool_index,
+				   struct devlink_sb_pool_info *pool_info)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_pool_get(ds, sb_index, pool_index,
+					    pool_info);
+}
+
+static int dsa_devlink_sb_pool_set(struct devlink *dl, unsigned int sb_index,
+				   u16 pool_index, u32 size,
+				   enum devlink_sb_threshold_type threshold_type,
+				   struct netlink_ext_ack *extack)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_pool_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_pool_set(ds, sb_index, pool_index, size,
+					    threshold_type, extack);
+}
+
+static int dsa_devlink_sb_port_pool_get(struct devlink_port *dlp,
+					unsigned int sb_index, u16 pool_index,
+					u32 *p_threshold)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_port_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_port_pool_get(ds, dp->index, sb_index,
+						 pool_index, p_threshold);
+}
+
+static int dsa_devlink_sb_port_pool_set(struct devlink_port *dlp,
+					unsigned int sb_index, u16 pool_index,
+					u32 threshold,
+					struct netlink_ext_ack *extack)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_port_pool_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_port_pool_set(ds, dp->index, sb_index,
+						 pool_index, threshold, extack);
+}
+
+static int
+dsa_devlink_sb_tc_pool_bind_get(struct devlink_port *dlp,
+				unsigned int sb_index, u16 tc_index,
+				enum devlink_sb_pool_type pool_type,
+				u16 *p_pool_index, u32 *p_threshold)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_tc_pool_bind_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_tc_pool_bind_get(ds, dp->index, sb_index,
+						    tc_index, pool_type,
+						    p_pool_index, p_threshold);
+}
+
+static int
+dsa_devlink_sb_tc_pool_bind_set(struct devlink_port *dlp,
+				unsigned int sb_index, u16 tc_index,
+				enum devlink_sb_pool_type pool_type,
+				u16 pool_index, u32 threshold,
+				struct netlink_ext_ack *extack)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_tc_pool_bind_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_tc_pool_bind_set(ds, dp->index, sb_index,
+						    tc_index, pool_type,
+						    pool_index, threshold,
+						    extack);
+}
+
+static int dsa_devlink_sb_occ_snapshot(struct devlink *dl,
+				       unsigned int sb_index)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_occ_snapshot)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_snapshot(ds, sb_index);
+}
+
+static int dsa_devlink_sb_occ_max_clear(struct devlink *dl,
+					unsigned int sb_index)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_occ_max_clear)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_max_clear(ds, sb_index);
+}
+
+static int dsa_devlink_sb_occ_port_pool_get(struct devlink_port *dlp,
+					    unsigned int sb_index,
+					    u16 pool_index, u32 *p_cur,
+					    u32 *p_max)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_occ_port_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_port_pool_get(ds, dp->index, sb_index,
+						     pool_index, p_cur, p_max);
+}
+
+static int
+dsa_devlink_sb_occ_tc_port_bind_get(struct devlink_port *dlp,
+				    unsigned int sb_index, u16 tc_index,
+				    enum devlink_sb_pool_type pool_type,
+				    u32 *p_cur, u32 *p_max)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_occ_tc_port_bind_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_tc_port_bind_get(ds, dp->index,
+							sb_index, tc_index,
+							pool_type, p_cur,
+							p_max);
+}
+
 static const struct devlink_ops dsa_devlink_ops = {
-	.info_get = dsa_devlink_info_get,
+	.info_get			= dsa_devlink_info_get,
+	.sb_pool_get			= dsa_devlink_sb_pool_get,
+	.sb_pool_set			= dsa_devlink_sb_pool_set,
+	.sb_port_pool_get		= dsa_devlink_sb_port_pool_get,
+	.sb_port_pool_set		= dsa_devlink_sb_port_pool_set,
+	.sb_tc_pool_bind_get		= dsa_devlink_sb_tc_pool_bind_get,
+	.sb_tc_pool_bind_set		= dsa_devlink_sb_tc_pool_bind_set,
+	.sb_occ_snapshot		= dsa_devlink_sb_occ_snapshot,
+	.sb_occ_max_clear		= dsa_devlink_sb_occ_max_clear,
+	.sb_occ_port_pool_get		= dsa_devlink_sb_occ_port_pool_get,
+	.sb_occ_tc_port_bind_get	= dsa_devlink_sb_occ_tc_port_bind_get,
 };
 
 static int dsa_switch_setup(struct dsa_switch *ds)
-- 
2.25.1

