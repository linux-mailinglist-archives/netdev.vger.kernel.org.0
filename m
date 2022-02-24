Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C1C4C2D35
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiBXNfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbiBXNfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:44 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C80F1786AD
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:35:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hB/3Rkvzhf9fs6GChh7R78uVN5gzjWKs+6aMLbbsNBuG2gVbmhlgdgOLe2tVKWlr8UE9QJmruhseFOVMKwTsvDP4tVx1I62qdizpVxQkLc+WRMwO9XYvOyknOlTUQ+3Tnltsf/9A/xoYWgL6J/H/E0cNjSVm4s2JE4B2Em3XZAQmOVJvRamyIfQ9W/H3FyecbMJ9jKmNGlSsxqy+eCk2Z+eUbbnD/Oq/7RTX8hx0iyzMkSMPuvDq8sacWdSgau7n519//xTE62Q1eHp/iKRmiREP2FsPMr4q00eew2YCMtFL8ZgJYUJnSjBubIGLs8tECaEkH5FKo6NGopu8GePsJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ba52Y8UsqBq5t6xftkEOKhp3rZxCpaTjAN9biOb6TuI=;
 b=V+teabDxnzqh4aD9iJre2tfRiUXWVUnJw775DjYQ1k96Ob9Gb5pQe+k3ffyBt9c40maDZLtpPew39/6d9HEK2OB/K/uuCSGZcZO6WIdrti8+dn6EuOTf52BprCwCVYRjKRJUGKtRxW7NKpGWV61mJTfcIZWW5VUGoi86ckMwENLwPlPD8ru+4BkvNQP5Z0IK+G0YijrnCcnYn9NrSOf7dG1CbQBI5rrsoqCo9AWRxRg2B/y5AwT2Zb7/r3n6f1hQnRxFhdy1GTsreJua37eEB3ELxlndYTP1Rh0gM9ljffsAudyzW4bRX6nEeqPHWZrTOo/omOR/c305stTr4+zmmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ba52Y8UsqBq5t6xftkEOKhp3rZxCpaTjAN9biOb6TuI=;
 b=BlG1P7q8ceeMSTwLHg89pKL5Kv8iYmdcdC8ZWrdtv2vrHIOr0bNymrtieA6TZn4ZQHFlxtx7XxW4dNbPf1jg1P4CITjnT05JWFfrhATSWw2CS3fIMqdt5s1lnWmlO3MghscwGoMj7weZQl9oJxcAs9nmjj0Uoz0EM/Kg3pGbyaSh4QlqpzWL9EinAMQ4mlEjCH7RflEFdTxrDWsRDEUIXRbbyNALPQWIYfXMlLDKQ17G/jiSwvdYoukUQixVXh+VNlCNJr2JO48KviWfo5jmpddWaw1kpm3rYadfnlj+qhW8nPEAOsSUn71FSyLZI+kGRr7HTzr+vghqMqJRgQV+bQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:35:13 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:35:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/14] mlxsw: Extract classification of router-related events to a helper
Date:   Thu, 24 Feb 2022 15:33:33 +0200
Message-Id: <20220224133335.599529-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0079.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::23) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f35113b8-2cc9-4725-652f-08d9f79a7c44
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6008FA4819EFFDA01E5F130DB23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AOtaZDMM6uWCXUpPtx0A7e5coz+mU7Rnu8YlTPLcI6SbaFs62PfUX22kvhEiyyxgzibULR0ckYsAetzo0Qs3XLv4eN2/NHKl1hdySAuh7mASN/hdOT39tZACbCfT9Ce7LhkSCkclqZVJaO0u8hxxtP1DCfevBQEFLzEO2dVpjiFFk1z3Jg/iNPYlwfvOsAH0L0f1VVtFOK0lS9CUsxBQEXwyp7epuN4+3Z43pFXNdR9GhCnCySQQBXTkMw3pcVQzv2vStSRt4WzBYSiM4gxu/vg85l7ZGs8PKC5e2j0pgyP/Mj1WjJiRNPfi+/0C315BF6wyN0pUzaU55lYa/P71+CLGgYK0/DC+hYaFHZ5p2MT2TK4pwggFJidtS6KsvS/hKAjM+FjcbSlAFyk2b87tK/4UMUJvw/5RV7Mm4RyLRkci133ksWQjtziKGWAPhSNFxmTMCvChsofc+L17H/p8gcRMjfv3+1xS+z1O+qipohrTlK6KODlf8W8k1szHC+Ja8aIKh9x0LIuLwJmAgZ7oryc/Zl96sEZpzgy7egI5xBAmr3+pejWPc8mWluDPi775M1XhTdirN6djRvIP/sJmIxVNAoFFeFRP4jlFMD8lActi3MzsxBHC7OH2icDLGlRJrdpdy/L3DYd1Bfp+aWBz9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(66574015)(6666004)(2906002)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yuYEa5bBN9ocC/WFsR39pX9b/e+fyTopZZJI0Pq5yhfSO7exX3Ys7P+QFV3B?=
 =?us-ascii?Q?iEN0yQLndtI52EixKnYP0bwotgKFjyEPhqONP89EyouKidrCKYopw065iY5u?=
 =?us-ascii?Q?VK5I6NDSnHHl0wDi8/8qFA3I7BAKdRiAJGX+4ue+4Cuc8bZApab5MdJxmA9M?=
 =?us-ascii?Q?eEGUmu5sLjWahkvVeOZqH4la3bYUYfZY7/cMx/x6932fXxiIAPD1A+iEs6k9?=
 =?us-ascii?Q?tDedNdMjmdBfvJDFi11jpnbmmzzSxs3zRg39O/b8tE+XECpqLYA3MypeU9GV?=
 =?us-ascii?Q?HPHtnz4VUnLxo3x8ReJn58YX9tPjYZ9foxGtQGVldtF/0pQ5cga9R9/rbuv4?=
 =?us-ascii?Q?nyznIEBosFpfQV/PnmAocApqlQcpyUlp1Zz5WS35zVpvYvATF63xT2eKGJkt?=
 =?us-ascii?Q?T5tolPahY5Ulscp/qzLVfzIzAdu7mHllL2F8luW/JcXWVjVQOHPXl5MGKSg4?=
 =?us-ascii?Q?65orcGLaoDuohhlWKT+BarRMT8q+BLV8QvGUgijzXLgNFvGkN9G1dVr85Usu?=
 =?us-ascii?Q?hh31KYAgGuT1WLqeko7ej5WA0qEv5pvR0yk/SE+Z5r1cgqJHkUT4C9Ts8SbP?=
 =?us-ascii?Q?Ydh2jILBHLjkOKrQ91fPKskmco/efYqUjIFvKKfN6/uapH9DyNZufmNhFJn/?=
 =?us-ascii?Q?Ew4Uiw7N/fS6AxLf0U/dVyDJCX8yu4rITIjtIIHTTLB4A/skWAyfnAcaa50l?=
 =?us-ascii?Q?I+ylKEOEkN4PmktobcGXYOgaUFWtinb3Fb38llV1YifsTVjIkyFyYr8fGJAm?=
 =?us-ascii?Q?SpJ8dDjTqL1rZ7175h339N671UiRAo5fgSbkNvPu/ZoXLtH1D+vLuvG9bCPl?=
 =?us-ascii?Q?CWVz2LXhjtXLH6S62NgoJ2Y6fL0yVUk0cXNf8zpPabrMis8YacrXOUJgNzNW?=
 =?us-ascii?Q?g02r4Ij+i8u+2Rr+7t6kWERh+W7mpaWG8reqDZIO4ft/piKIDPHUfG+KnQb8?=
 =?us-ascii?Q?N23i8z6G2kKgohrMw4u0zhPznZFS6L9u4pxIkasnlo/18b5GvjzPpuckwx9Z?=
 =?us-ascii?Q?pv53OPUisHyVEje13fxOKKfWvGzRswgSPN7sqQr5nFwHUmOrjRNfhvJleI6u?=
 =?us-ascii?Q?13EVh06Olpp1dXyIoDevuH3upYzNpWH0rekAxWnxJg7MfO/rhBYDdHmkRwFM?=
 =?us-ascii?Q?MvzwJfIML8/dInCkuJe2ZApWIX55hBgGB3CMu8w3JYlwu/BzGw+pzPrZDJ9R?=
 =?us-ascii?Q?91HbSX6WO+V8J+vxgcwAJtrmgtzyphC4Y+A+s6N6d+uFW18vML6NkJJepxAM?=
 =?us-ascii?Q?Rd6sMqkzkofALtjDRm8t2qPEG5B1tlj+ugPX653e4ZCQw7hXjlmA8A8qh9zl?=
 =?us-ascii?Q?mJjQWlaT0KJth2FykuMXzMfoB3WerieU4QNWeFGAl1gygbbw9ScH6y9MeGQm?=
 =?us-ascii?Q?E+XfL8AiFLENlFnYo1b4FeMa8jnRYu9bUahhizPqIv6y0Xe1+R3s+ufmBizm?=
 =?us-ascii?Q?TIz6X0qqkgjNRr8snM3VJgOSg0406urIdZZTy0oawtskFqjNxzMB6+H6b9AO?=
 =?us-ascii?Q?C1IxhHYmLT+bcfzQAMIDA1m2wlEU6A6QTUaaqA0ifTfj/zfffiCeORsG+o7R?=
 =?us-ascii?Q?D5N0UbTVIJySJokc1yGHhcfOXQ1Kltrj5eFmUwpPNTVNtCNUHHcXXUngFYg0?=
 =?us-ascii?Q?2wnBNaiOtuUj5jHOqVkLpds=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f35113b8-2cc9-4725-652f-08d9f79a7c44
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:35:13.2454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILYwdWsGXwyBEofCI5CigX0PymhxG33oY+JtrHStu4GEPhDfZJ9ufqKP4ZheTw36rPkaGniHq20cl1/iospftQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Several more events are coming in the following patches, and extending the
if statement is getting awkward. Instead, convert it to a switch.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4880521b11a7..10f32deea158 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4823,6 +4823,18 @@ static int mlxsw_sp_netdevice_vxlan_event(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static bool mlxsw_sp_netdevice_event_is_router(unsigned long event)
+{
+	switch (event) {
+	case NETDEV_PRE_CHANGEADDR:
+	case NETDEV_CHANGEADDR:
+	case NETDEV_CHANGEMTU:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 				    unsigned long event, void *ptr)
 {
@@ -4847,9 +4859,7 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 	else if (mlxsw_sp_netdev_is_ipip_ul(mlxsw_sp, dev))
 		err = mlxsw_sp_netdevice_ipip_ul_event(mlxsw_sp, dev,
 						       event, ptr);
-	else if (event == NETDEV_PRE_CHANGEADDR ||
-		 event == NETDEV_CHANGEADDR ||
-		 event == NETDEV_CHANGEMTU)
+	else if (mlxsw_sp_netdevice_event_is_router(event))
 		err = mlxsw_sp_netdevice_router_port_event(dev, event, ptr);
 	else if (mlxsw_sp_is_vrf_event(event, ptr))
 		err = mlxsw_sp_netdevice_vrf_event(dev, event, ptr);
-- 
2.33.1

