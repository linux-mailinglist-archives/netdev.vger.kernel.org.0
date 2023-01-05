Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0965E66D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjAEIFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjAEIFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:05:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9F617597
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 00:05:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiV8DomLjx3HV3Cxnme2wEUnqTtTECTUCDPuuvS3a+6jwOeMcaxeL9FYdZyoZDRntXq37RYXium1MS7IzAn3dHdw5Dc9ZOObRdw49X0PJqKtgmf4V9J4S90J/fJ0iR9ZOYyfPWqzc1XW7H/QM1chehI1lkav5QZyNfPft0IAjbRJrxUcLe4RiLr60bxk05S2IeiUXhSs9BU5VKZCbMRGiUsDlkH6Y9l+EiQbGpk1GGxVubBcY8d3a6BGfuxmPy0BeGdUFQDn6YfNRG7qOpSvCxN56kFya/LXHN31WkN2bG8vt8YmUWmZgzHyqSMixU/tqi6Li/4mv+RF5dNg8ftZQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50BnEFyfDGepMIZJY3UAmnZMiARCAe8Wn0x+mzjPlxg=;
 b=WZcDnUBPzvsP3Ys1KrPNul32hYsR94XtHEdSuGJb++Q5sAmuJwpctRIxRZ/6uBCbb2LiOOHrd96Ex1cnD4Jw0XIrSjENkoVxIcH+9L0s0pREFY6Ez+R4ZWpyP8musq++LinBRGMHYfqFuwWomT/5K69DYjHq7Fq3FzuX1czKrrkkxhP+zqLX3LbFVmN2sfbkW57QJ623h+HpvJO7QqRlfCo8M6FpH3evfWaQ2LzensGWaHtYLtz4dmTgqwrrQlZWhafLUa0HfLx9VcLYCo/Vxy2eZOs5SvMPY43l8B8XhpiK/7hzdIpL0lJjvSVXbFd8m4CExWGl7bH6HzeT1vTHdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50BnEFyfDGepMIZJY3UAmnZMiARCAe8Wn0x+mzjPlxg=;
 b=ieh2pYddi6iVZ9N9GioFdsIaauyDTNVYi7WkKNYMbWohcdiGxv2XD+N0JoQ3HGy4uZavJOUWvCAL1azZSTyzCgsY9DzFfLpv00NmPtrPlE70Gp0eTdjp3M39vwttBjxRUHG6XhoJ1QnY1niTpvIw7/S9RfARd+5OjFQKmWwGqRUbPuEIw3KxpJTQwyzWHb/5xUbfu9jpFBFdlanDTskUOCXdCX0aV7b1LW63axxeINU2KxXnHQS8IHLe4fdHnLeGi14q3LC0ddTDI5e9j1JoMmySEgvXI47qptFihrcvMNkFqtEbUGwj06FVDxiRnxjuCGzjzzhVs+WCm48nvrvUYA==
Received: from DM6PR17CA0033.namprd17.prod.outlook.com (2603:10b6:5:1b3::46)
 by PH7PR12MB6719.namprd12.prod.outlook.com (2603:10b6:510:1b2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 08:05:00 +0000
Received: from DS1PEPF0000E62E.namprd02.prod.outlook.com
 (2603:10b6:5:1b3:cafe::8) by DM6PR17CA0033.outlook.office365.com
 (2603:10b6:5:1b3::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Thu, 5 Jan 2023 08:05:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF0000E62E.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.8 via Frontend Transport; Thu, 5 Jan 2023 08:05:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 00:04:52 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 5 Jan 2023 00:04:51 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 5 Jan
 2023 00:04:49 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Thu, 5 Jan 2023 10:04:41 +0200
Message-ID: <20230105080442.17873-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230105080442.17873-1-ehakim@nvidia.com>
References: <20230105080442.17873-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62E:EE_|PH7PR12MB6719:EE_
X-MS-Office365-Filtering-Correlation-Id: 617705d6-db21-466b-7ec4-08daeef38aeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGsBGH5pJVX8UXhGC67OIlPtpnLKXzZgXgQK9Rz5xDYvIVCYJLa6LxmfxdSbKFDPdRYZokhCoP2Rc7noD6rmkOuQ+YvTJvx1dzwhiIrF+nAtwu5hMQCVEon/zdFORFi88/5ZvRkp3bhQ/mX+t5TimH29LFzfrlIjY1963bUBYdjU+vH+atmdkMtj5RAHTi58AF8KN1gLfV3920yA+SBf5fslOFdLs1hyq5yxKMWF/aNEVlk4tF7gx2xopSnXdG7H30SMPHrneYpdgF11An/OKuzqQa5vvEiDfxNqV9hDOAL92oX8CV6/I+GQleNwK6Pz/qn8ErHignHKQZY1kKXKNoyA2dc4kEpCybnx6AxUyBNSXFu81ugsl4yUm/2dR/cqNa44vziasMluOBWoJFPhc7qegw0Dr7yZkKXR2G9H9mnq3Eb6m+/WaiiQ6pxdGeqFkIfl75cpf2yROjjHQd+heN40jba36xAqFbDOoRQLYZ94JjEMrBZPYrR7PN2U241Nz4fOaPxLuXxS/VLBvYnAnjPJ6o0MRyoD0+DdOeIK72Y2nDwUsY0KWghufBvjR0RVsxHBqMuyVwQKw2l0U50pLUKaFAzWLHq5QVKwAOnXCjkmhI8ZjKw/K6XGZIgNLDGiXF0oWSQjkY7FeOyJ+aXLFw1H2aF4AZCpcmi1RtaPz41bMTTmSOLC6nWEqeQIHKn395xQ/WOfPwFAhgaYnZCfdA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(7636003)(6666004)(26005)(2906002)(478600001)(7696005)(186003)(107886003)(6916009)(70206006)(70586007)(4326008)(2616005)(336012)(8676002)(47076005)(40460700003)(41300700001)(426003)(316002)(40480700001)(5660300002)(83380400001)(82740400003)(36756003)(2876002)(8936002)(54906003)(1076003)(86362001)(36860700001)(82310400005)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 08:05:00.0092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 617705d6-db21-466b-7ec4-08daeef38aeb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6719
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

