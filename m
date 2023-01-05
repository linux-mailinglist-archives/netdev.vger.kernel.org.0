Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB2A65E64F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjAEH56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjAEH5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:57:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67B51EC43
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 23:57:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQbdidu32uWISrLuSVuSvn+ML+KeZsYwBQYwsL83ujGJNlYUFdMg12snJPJcdnvwixrls5twqR0T0bkZsxkipLwoA3QDM5IyqCCrrJmI87QBHWrG5CVAcV9J8+KoN4GczdmyMtG8U2bsbG1VmsnEZ6ej4iGIbGvHS6sai6FgV9Wk+Woyi0ApFvP+jCZUImAJGDxgX0PTi3EyxJWgB2zhfdHaVtMeUzV94WzYQU3WTUl31RQ6n4ZBpiM5+/jMR90GApgFxCM7gKC+CxOKiBcIeE3ax3zdx0umNr6MoAtgJgyJcQjOHUz5cLDvC5eINE06Q4G75IbJn+s0LAv2vrECew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50BnEFyfDGepMIZJY3UAmnZMiARCAe8Wn0x+mzjPlxg=;
 b=EhgL/9mSSEYrKdFGjMz0MPQe/ce0nawg4YKvhdqtrBy8IsougqI/V40kFb9DwSLXtDFeY7w30SyZ9JXcnpY4BodSetNeHBCPjK/agt8a7xAkfnu24hNDjVH3BOr/PGCG5tin8d88hxMm30ihd8hu5actPrmtC0JVfDkwLm3dxmGRBid1kNFSObMlAvFeM25rO0F5Upwqep/EO6G6eziVq/rzRUjdnU5jRvgoynxifc4k8vQ53sakrBc28cyW0x5WUMKzS+Uc+uGm8lzGG6BKfJH+BsyX7IhN2WOfLWMw2kNSh7lUdaPBN7jr+clkc7Uf1mbhjAuRC+g/JHtPix9vmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50BnEFyfDGepMIZJY3UAmnZMiARCAe8Wn0x+mzjPlxg=;
 b=U1ZFO6p42E+lTx/k+0caOaxmcmKm/9wBzkXW9zbDdnxO6e5Ve2w8uxxVfnLAgWR35rE8ZneNZK1RvwPkIBoNSmf31sTRFPt2IJB4zMLjqh6S0GH2FSehU1+5OGhsif6xKfcEHFbG+eKBcO8B9dNOK8uQDxoIItSrEoaw+kpvvJ/+FcEupjaF7aJ4gSCFi9BSDwGqKcLedbdKedwAkM1LGVo+EwTvQFk0BqUx8xZTcVrRRGMycFCgA7z/q1jslwqzK8sWo2FXBErl/Q/QQwEbf5irqTep/Qciiv4h8KbXuJz2e1XhNtqrN26m49fK2D8JIKlUaM97bJk08r+e/Osc4Q==
Received: from BN9PR03CA0492.namprd03.prod.outlook.com (2603:10b6:408:130::17)
 by SJ0PR12MB5437.namprd12.prod.outlook.com (2603:10b6:a03:302::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 07:57:50 +0000
Received: from BN8NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::d6) by BN9PR03CA0492.outlook.office365.com
 (2603:10b6:408:130::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 07:57:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT104.mail.protection.outlook.com (10.13.177.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Thu, 5 Jan 2023 07:57:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 4 Jan 2023
 23:57:42 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 4 Jan 2023 23:57:42 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 4 Jan
 2023 23:57:39 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Thu, 5 Jan 2023 09:57:20 +0200
Message-ID: <20230105075721.17603-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230105075721.17603-1-ehakim@nvidia.com>
References: <20230105075721.17603-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT104:EE_|SJ0PR12MB5437:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d102c20-ad6f-43c6-5b36-08daeef28abf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcYbPyhtT8+amh0hLu1Wwd1yAet/0Mqc5elPsNDMYSebPf9b5/23klqndRCeDxHT2gdvKrCkT7MF+W60q0xjR+SSHoIGY8QchHdSvkC+FX33/wc2+Y5syfFfbF8TX0zC7Ottbq9ogtGkQq0k3mxeruyniytUApDLU5Ao3WXSyfwXSIoy9XDr+iwwVAGgzwobVBDKGgBCBb2z2C9yoLd0JO470XU64cY4UOcmTWpIUrAbHCM+vVUPH5r7m7Y7yN/9qg6U7jxLWlQMfbVlYGm8ijhFj+YYQR918ag2aDHqWHHp7XSGA50wRTO1VGRKFllGCufrHS9z5ABXr7XanmfOnjPd/MxALFC78wMPTe+lIB/4tWdczaSKZXIc98HUEnt1fnUGxZTmIlHO31YwGeu6WB4Un9AL0L6PFY1GAZqKg03wrtqZRr66rMh+04In2RmUBWpJQJzc59ldlMip+7a10RsA5FgNg1q8v3MhmutOR91buhRrFKczLLWXQln0w6Wr6icSMnH3a+LSbwfwAKEjnd+G1LJ10sGAzZoTOFTVXWkBRVcfeVsE5x8qaHGiBVbUFwiaLTD/9iJFg48AujGFjb1uPKFY1Ut+aqW1tj1xlmjFH6MwnUFGZ8B7TJoOpt13xINQfrogNh6OiwrEWA2lkwgsnJu5yxsR7yBQXHD8hKKx+EoOT3QaLFPEHUkBSeTIvhT//Y1LQhstT4YJEzk6mA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(2876002)(2616005)(1076003)(47076005)(83380400001)(36860700001)(426003)(86362001)(40480700001)(40460700003)(82310400005)(356005)(7636003)(82740400003)(36756003)(336012)(6916009)(316002)(54906003)(70206006)(41300700001)(4326008)(5660300002)(70586007)(8676002)(186003)(8936002)(6666004)(26005)(107886003)(2906002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 07:57:50.1608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d102c20-ad6f-43c6-5b36-08daeef28abf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5437
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Add support for changing Macsec offload selection through the
netlink layer by implementing the relevant changes in
macsec_changelink.

Since the handling in macsec_changelink is similar to macsec_upd_offload,
update macsec_upd_offload to use a common helper function to avoid
duplication.

Example for setting offload for a macsec device:
    ip link set macsec0 type macsec offload mac

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
v5 -> v6: - Locking issue got fixed in a separate patch so rebase
V4 -> V5: - Fail immediately if macsec ops does not exist
V3 -> V4: - Dont pass whole attributes data to macsec_update_offload, just pass relevant attribute.
                 - Fix code style.
                 - Remove macsec_changelink_upd_offload
V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
                        to be sent to "net" branch as a fix.
                  - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
                    to changelink
V1 -> V2: Add common helper to avoid duplicating code
 drivers/net/macsec.c | 116 +++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 59 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index bf8ac7a3ded7..1974c59977aa 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,95 +2583,87 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	return false;
 }
 
-static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
+static int macsec_update_offload(struct net_device *dev, enum macsec_offload offload)
 {
-	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
-	enum macsec_offload offload, prev_offload;
-	int (*func)(struct macsec_context *ctx);
-	struct nlattr **attrs = info->attrs;
-	struct net_device *dev;
+	enum macsec_offload prev_offload;
 	const struct macsec_ops *ops;
 	struct macsec_context ctx;
 	struct macsec_dev *macsec;
 	int ret = 0;
 
-	if (!attrs[MACSEC_ATTR_IFINDEX])
-		return -EINVAL;
-
-	if (!attrs[MACSEC_ATTR_OFFLOAD])
-		return -EINVAL;
-
-	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
-					attrs[MACSEC_ATTR_OFFLOAD],
-					macsec_genl_offload_policy, NULL))
-		return -EINVAL;
-
-	rtnl_lock();
-
-	dev = get_dev_from_nl(genl_info_net(info), attrs);
-	if (IS_ERR(dev)) {
-		ret = PTR_ERR(dev);
-		goto out;
-	}
 	macsec = macsec_priv(dev);
 
-	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload == offload)
-		goto out;
+		return 0;
 
 	/* Check if the offloading mode is supported by the underlying layers */
 	if (offload != MACSEC_OFFLOAD_OFF &&
 	    !macsec_check_offload(offload, macsec)) {
-		ret = -EOPNOTSUPP;
-		goto out;
+		return -EOPNOTSUPP;
 	}
 
 	/* Check if the net device is busy. */
-	if (netif_running(dev)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	prev_offload = macsec->offload;
-	macsec->offload = offload;
+	if (netif_running(dev))
+		return -EBUSY;
 
 	/* Check if the device already has rules configured: we do not support
 	 * rules migration.
 	 */
-	if (macsec_is_configured(macsec)) {
-		ret = -EBUSY;
-		goto rollback;
-	}
+	if (macsec_is_configured(macsec))
+		return -EBUSY;
+
+	prev_offload = macsec->offload;
 
 	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
 			       macsec, &ctx);
-	if (!ops) {
-		ret = -EOPNOTSUPP;
-		goto rollback;
-	}
+	if (!ops)
+		return -EOPNOTSUPP;
 
-	if (prev_offload == MACSEC_OFFLOAD_OFF)
-		func = ops->mdo_add_secy;
-	else
-		func = ops->mdo_del_secy;
+	macsec->offload = offload;
 
 	ctx.secy = &macsec->secy;
-	ret = macsec_offload(func, &ctx);
+	ret = offload == MACSEC_OFFLOAD_OFF ? macsec_offload(ops->mdo_del_secy, &ctx)
+					    : macsec_offload(ops->mdo_add_secy, &ctx);
 	if (ret)
-		goto rollback;
+		macsec->offload = prev_offload;
 
-	rtnl_unlock();
-	return 0;
+	return ret;
+}
+
+static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
+	struct nlattr **attrs = info->attrs;
+	enum macsec_offload offload;
+	struct net_device *dev;
+	int ret;
+
+	if (!attrs[MACSEC_ATTR_IFINDEX])
+		return -EINVAL;
+
+	if (!attrs[MACSEC_ATTR_OFFLOAD])
+		return -EINVAL;
+
+	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
+					attrs[MACSEC_ATTR_OFFLOAD],
+					macsec_genl_offload_policy, NULL))
+		return -EINVAL;
+
+	dev = get_dev_from_nl(genl_info_net(info), attrs);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
+		return -EINVAL;
+
+	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
+
+	rtnl_lock();
+
+	ret = macsec_update_offload(dev, offload);
 
-rollback:
-	macsec->offload = prev_offload;
-out:
 	rtnl_unlock();
+
 	return ret;
 }
 
@@ -3840,6 +3832,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (ret)
 		goto cleanup;
 
+	if (data[IFLA_MACSEC_OFFLOAD]) {
+		ret = macsec_update_offload(dev, nla_get_u8(data[IFLA_MACSEC_OFFLOAD]));
+		if (ret)
+			goto cleanup;
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
-- 
2.21.3

