Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9559559A4D3
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349694AbiHSSDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349887AbiHSSCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:15 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2079.outbound.protection.outlook.com [40.107.21.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5E36CD2D
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSWDxQCb9o2bauUm94OXMRBxSAoFrqbPJ63kaemJzIvRrrKFJpLZ9t1OzGk746zLfYXT37ZZXWFspqVDDr0PE0V+g+H5vFiBk85pcXrYMbkpA1l5FS4eFkT6U+3tDv1GHthKHJ+SjTzh5eQQzqgBXRKrQ3mIf2PXoQU5vWHTHPoGF4xsTjDtvgBGySahjIdC1iuEVNOaLz8pF8ZCafyLYvb6hgWRPZocIF+me3HANGtx+64LKCsThYrwYUdYwy9CX/D89eUSK5+s6O7n5eDG6NWQWaIkpEN/L/JxSJLeAJ6aBZ3k4idSql4xJm/eyCRLfhlq+s8JI5GSXa+D5r/8nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OvO3wa6bR/AgHehVOsFXXBld4+fzXk1BBq1LF5kjGM=;
 b=cUqFmVj3SDpe0OkYQiDxJ+fvcnOjLj0CaptJlG9EaA2o/X+rulOIFVnMs1jKKbwcK1gfwjgpIXZMN4DNlj7GXR6dWx6sRkIGqXFK+s0AUDbM+SJDBodFs4TiJbiwdmQpo7b+3/1BOWXwQMHryp+5pgS06W3WASVOgnBmtDJ0P964u+Gkj/cbLkXEIAW/m2rYuEQ+0CBpVhFTYOdnd8ZVVpgpRoILB+TIezFyxeVdYo232fVH+hF10y99hRJT5DNjgDK5uTzcXcF+e9MavYfmZLo1b8rakSVk7Ij0fkcIBIwZCdhvjDj80WfK9MzkbCEd8OWUUWUmsGG1AY1v1Shcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OvO3wa6bR/AgHehVOsFXXBld4+fzXk1BBq1LF5kjGM=;
 b=UeNofxMNu5tdUxFExpRTicb0K2j4b9lRtOpeIL2M+wr/Bk4kfvhFnpDng6NhiLr69UiCbQrT0sgfdYpZxpWUE6hYwY7CWTEW3GpxsmKP44cZMIx7KHp1wUiV2aeqFDN2UBELGoJPyQhLhoz4YVtaA9uwCYx7nfMPY8OOp9BRjAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:48:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next 4/9] net: dsa: existing DSA masters cannot join upper interfaces
Date:   Fri, 19 Aug 2022 20:48:15 +0300
Message-Id: <20220819174820.3585002-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
References: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 477ec443-d616-4beb-ead0-08da820b0a81
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJdaZKbwe/w3lAtboKmfqZackkSnigcOYiEkSSDja85TBfMHN2rvY8oqEqpsOc9JYk5NXl488aAAkpdoAAILbCSwgFCBeq6ZDP0G+b9+Zbu9hFj/TXeiTFeAeT7PLGKlVG1f3e22KgzY90PGn7H2AgBZqPpLoajbNsfWWK/gq4wvp7g/mDAmKAsXIKA084HtiMpRirdlZwVuWn9PlZzsXyCeixlgPr/ZFl4/4pRqJIwoTTsICoQgDbqdrQppmPbm8Jr6HxVA70IKGTq7TtLgqyvTTQi0jn5jyATS0PK0bLnlsxXsUAcKnOQY6G3tO+YG7OhUg3x7VpEXwjCQwhZmG1N0xVZmdWGnRaXc+7jhn5qy47RUx1fXIrWIrSxREBMSy7U2mjFCPBRjQnvDsfFJ5yuLoG+m2arPqDBRq5MFQJiuyRYisMQs5SlJoFodwCeSUYK9okVEFvhq5g/5mTj2fSVsjFaPF3zMTCGR/KP2/p7uSJvr2cdO7AzSl+UFOlOWqPr7WApcwT+OYyhmrPaI+EvdBsOJUalrQf9lW7mxc3uB6mGtNYWO/QEwIM9dc6jgwP7tA6CtOgu3GjUe2wMYlIfhHr9NESfCQxJtQfdCeIfPxL0Mo+oXFMHU8dvOmeGS0kEQMgd5bhZH5+12YV17Wda4IFUldq6hCplCBN+zBrdu8GQIdHk2K9me8jRD0WnbfMtaGafaJFmKjE8jyfJzutKnO1qqB+eiKGWKfCp9eoIaYCJNPLp09vZv2DT9Jw4CChnBrJoEXB4Zic6+2Dj1KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(66556008)(8676002)(4326008)(7416002)(44832011)(66946007)(66476007)(316002)(6916009)(54906003)(5660300002)(36756003)(8936002)(2906002)(478600001)(6486002)(41300700001)(6506007)(6666004)(26005)(52116002)(6512007)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ovaORIFrS8I7PHtZ1xNIs6MiJaqjmJwjKXXnfMUcrmcstjI6gmUP+mf2UvKp?=
 =?us-ascii?Q?lmkaL5j69X4wB5ztBKJbL9+UsdexL++OqYpDs6LCtb43iUMWKma0Z1JIbnJe?=
 =?us-ascii?Q?IHSkW+ZIfaHPynYaHRCjmQBUDvrvdCpzhaOHJeBzCXwm39uYtFOKKz4hSI9n?=
 =?us-ascii?Q?R5TsdR0+2DffNTgRp4K6UPpdAYxlvKUig6YUqHmCnbzlK9kgwMBaVks18FCg?=
 =?us-ascii?Q?wN5H1Y6CWtWWWCSyFLGNsM6YjBs2wCDIZg/UObrroBZWUklRF0aNPIB5dtYG?=
 =?us-ascii?Q?zIg6oxhF1PywUjWjvhSY1gUk8+ZBqX7KmXepxOlAX219nr/FGRrFpuJIRHKz?=
 =?us-ascii?Q?NCAx4tfoeKayX6aKnIox2bXzllcl8oqQVs7/48dMgFVZnFVH300huy9DXYzi?=
 =?us-ascii?Q?7PNtJwRdgGOgzdjsH/2u7RMzrx6RyIT54qN/ZHvjTraMSa8L2UIt3MWJP/Y1?=
 =?us-ascii?Q?cqzyePo6TvPstkoRy9B721FD83ub1Cg3Tq+/k1wuZX648L3MvEz24rmEYVIA?=
 =?us-ascii?Q?+E29F1LsOXYDRB2PDk5IXTUDGUUka5Bx3M0RCZ+nO5zzb9/mCuoJYNfJaFMO?=
 =?us-ascii?Q?V3a280de42AZJk4TECfgse/x6FFU31yVSx7F2CC58xiy6svexl/RNJWKFPYm?=
 =?us-ascii?Q?Zgahl2s5zJPx9MQGm0uKGZaDOdhKRDRWTxlxIos5/tN3yCvUGDeJVorjRUtr?=
 =?us-ascii?Q?ogF35spTC36CBANCtSKWvx1ci0xGyjKy9r1pNXEM/lPtf26Uy5DBIo8jHmSP?=
 =?us-ascii?Q?O5ggCOxjJRKFbVgWv3Nsa9mUMUipSNRfftt5NdUr/b0MlFEsuCxMO8MaZpVy?=
 =?us-ascii?Q?UCo+6X+nCy4xyboPWtwZ0S/n86dDSnhLBYkPUpkmfed8+kFTYuBDOf0gT2mL?=
 =?us-ascii?Q?24K+LOyBfXPWOHRqS6OsjyLdQ12nC10iLkFZE+MfUXnvBosVzR5lyKoFzmE2?=
 =?us-ascii?Q?DHPxPRy1xLUvyKyjBGFKmsPDFOj0STQQhi4BDbd413yfAmOzYwFg5hp/Sbil?=
 =?us-ascii?Q?Djb/JBQSWwaWlCutwQnrGSjGjd4sb60erVKT7k+klEZ1vpFwhh7/48BFSPTY?=
 =?us-ascii?Q?kFpoVUGFOCbVJbwYDanojmCOHvwsFLtj/YtJK2uaCAylGG8DRtjD4f0tBWGV?=
 =?us-ascii?Q?uT3LvAG0CsMxFbzLZXW78bP7LKtEC605AdvVuAgX9RiAOTbJscfmTMeQ+GrF?=
 =?us-ascii?Q?lnMSCahLCBeb1/xxpP4D82CwoN+rV2Hg91YCDcsfU7cZUJgb5rrlP32tIJIH?=
 =?us-ascii?Q?sDcUuKkGcSSixV2kZL5JWOIlGBxvKil18TLkji3bqg/NxYvqVOfsffIQahjb?=
 =?us-ascii?Q?b/D7C/jhJTP2xeM59lSmNPaH3fO2DisvLsKcFlFwOMm0Wsjr2rYtGS1cAUwB?=
 =?us-ascii?Q?arCd6QF+N9QY7uXuqgnSBPqBYYPEPfzzfhfKKvnmy/ida7q1dVHixQ/Mnuly?=
 =?us-ascii?Q?zwtuFYoMUr9BgkB2byyb2+GaK/MoWhPGHymUbVMZ/uC/eT7Fr6zPKoTpjz7L?=
 =?us-ascii?Q?PXLFhOHVUArh18u0TKBWPAJHDnAbc4p1yCGsvvLUrba2pHvGF0NXbYqcbV0R?=
 =?us-ascii?Q?UocIC/hzcKoFpw9ibcPe0HZWY7hAxL8m+X13Fy5d2QFQ7XTYmGJoUpt/I/ua?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 477ec443-d616-4beb-ead0-08da820b0a81
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:36.0602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGtp+lMNiGJkEdt1tcLN8l0m51oXeb9i6x3bJpzDxZxoojB2yXRlROK5n6/yFrlbSMRaZGsy4lQ0SdCSkVN7Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the traffic to/from a DSA master is supposed to be distributed among
its DSA switch upper interfaces, so we should not allow other upper
device kinds.

An exception to this is DSA_TAG_PROTO_NONE (switches with no DSA tags),
and in that case it is actually expected to create e.g. VLAN interfaces
on the master. But for those, netdev_uses_dsa(master) returns false, so
the restriction doesn't apply.

The motivation for this change is to allow LAG interfaces of DSA masters
to be DSA masters themselves. We want to restrict the user's degrees of
freedom by 1: the LAG should already have all DSA masters as lowers, and
while lower ports of the LAG can be removed, none can be added after the
fact.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v3: none

 net/dsa/slave.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 09767f4b3b37..5b2e8f90ee2c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2699,6 +2699,35 @@ dsa_slave_prechangeupper_sanity_check(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+dsa_master_prechangeupper_sanity_check(struct net_device *master,
+				       struct netdev_notifier_changeupper_info *info)
+{
+	struct netlink_ext_ack *extack;
+
+	if (!netdev_uses_dsa(master))
+		return NOTIFY_DONE;
+
+	if (!info->linking)
+		return NOTIFY_DONE;
+
+	/* Allow DSA switch uppers */
+	if (dsa_slave_dev_check(info->upper_dev))
+		return NOTIFY_DONE;
+
+	/* Allow bridge uppers of DSA masters, subject to further
+	 * restrictions in dsa_bridge_prechangelower_sanity_check()
+	 */
+	if (netif_is_bridge_master(info->upper_dev))
+		return NOTIFY_DONE;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	NL_SET_ERR_MSG_MOD(extack,
+			   "DSA master cannot join unknown upper interfaces");
+	return notifier_from_errno(-EBUSY);
+}
+
 /* Don't allow bridging of DSA masters, since the bridge layer rx_handler
  * prevents the DSA fake ethertype handler to be invoked, so we don't get the
  * chance to strip off and parse the DSA switch tag protocol header (the bridge
@@ -2753,6 +2782,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_master_prechangeupper_sanity_check(dev, info);
+		if (notifier_to_errno(err))
+			return err;
+
 		err = dsa_bridge_prechangelower_sanity_check(dev, info);
 		if (notifier_to_errno(err))
 			return err;
-- 
2.34.1

