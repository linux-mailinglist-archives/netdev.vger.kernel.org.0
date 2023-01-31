Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2215568261D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjAaIEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjAaIDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:03:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2132.outbound.protection.outlook.com [40.107.244.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8AE42DD0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:03:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmyKmMqkBVKMRnM0ejnEVdtS4oxUeOS9OSvDdrnaUgqWbjZ6btWncjrASS+SqADkNOfWmJl9NnlQqhgxoMBjbJbYw/EtbzqbJw8AcVb+kGY/MDgROpWEKLvik0UFRZ7Av9tfSTwrpy1T3hle239FgDU9iJFduUhGnojcsOSARb+HLaXZlKv3/iXz333U1VNvmbDObbhwTAnlyiq8sEYgNnEqTVRvx84uhZQ3K7nf9aiRVvAh4fXGsfUGKaW+CX1V374bsFt1QE9AzsRzJaBYkfAKNn+CJpOhvYBRCtZpUaiE/l7SprqDswtyitoIh/fTy/TODNMcjldgOr9T1P5VfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OE9gw/hX/77w0DOgqgbGUAxXwCPm/kPPPVArnjxsTg=;
 b=hDQ73JfHR/yfb3M4Kl26FaB2PMU9SzE76Ihb7SAkAAYo5FFGxau8FXo/KZBwctgV6fVnBzt0S5dLzM/jUpEOBdgbUdt3FxvH2Kh3ZgHEalMO7G+it20r4M7TQpp7gxZgmH70lbWL7y83tgrjjlaNXwyLVMgCJqPoJUof+9MRFCqAx2cX4j7wzKxZDy6nWTbWpp/lCMzrASGmkOTVrbyGVj9LZLnJRlEfBSuRjep/14uHEmm+iXCm5G/wFeLp6hDAuXuhj9KLMwhlxPbb/yCvwfCGu4UV2AdRP+f5EWxmCtWc43ncmCln7HF5ZRuVlM4GZ0Ipe2ExJL5+kZ8/PaNzog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OE9gw/hX/77w0DOgqgbGUAxXwCPm/kPPPVArnjxsTg=;
 b=MDmNB73Bv8e9ri66Jzp76wJDXsgon85RjKS5HoF+ZuGAUBTKH87rMNFNIbxQgJitsKcLRLQoxhJvp3Jsvnn73WnFLWAGDDVpMhzMMmCBqCnZt6QWQ7q8NZ6uoPfl33nUf+o2z3OsE65lLzIVsT5s8e3H12CB+gdQ2gdZlybiu1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6297.namprd13.prod.outlook.com (2603:10b6:806:2f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 08:03:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 08:03:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yanguo Li <yanguo.li@corigine.com>,
        Dan Carpenter <error27@gmail.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: flower: avoid taking mutex in atomic context
Date:   Tue, 31 Jan 2023 09:03:13 +0100
Message-Id: <20230131080313.2076060-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0003.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6297:EE_
X-MS-Office365-Filtering-Correlation-Id: 945d3471-c5e0-4df0-ba69-08db0361a29e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vgJTAEGKtdbDAf4jRfYMud6DQteDpK0h4F//N8GvlbpwwmUrskjqds+jGFBiaNsQEB2FYVFa7bCZUH4zesPicvxji5OIrcpJURYEg8TY2jSmH/nUxyb0EsGo2Ic5g33/UaTWlf6Sgkr1kp5tuCNJMqA++fLo6COuNOp5szgWaVbBb16jtS6V+ZRBLS8wws0MScE8QX4KUvSEQ9CIoEKhZLW54Pv5X7d4Bmd7jgJ0NiW3C//Rdf0ZQjpU0HTWlurnr+ZN0rXFfiT0itJ7ZYhwOCGk2nHU4SpCKKsS5VTqyEWWw/Q+ZteF7vehj6m1APZatvcwcKh3e/WnlHksnXqrijC7tGZukVQjse2u++TulF1EBeCCeA8ltKXYZvk4lC6coujm7i9BxNNtuHA06D2RSvlfm0+7kBxH66O1dVlA+gvE//kwBcVifX+dWYaLURHU/M2F6RrQ+WtxLfhr7vwT/G8WaGMBhHHz7fudSYLkNCr/ZBvUKh7Mvb1iQursUXvnZqo544Hg4veC/vhbYwtWjNdZUS3WheEE0nm3vBxjKo2lpU2QqtOyniBGfdeEb3aWN++FD+WV+e43326CJ2fcx9JfTDQ30Gmr72NoKulgetDeKZj+9F4qoKEuZMnWhOV3dZ4jn2wgkHefF4CGUWUBfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(366004)(39840400004)(451199018)(38100700002)(86362001)(36756003)(52116002)(316002)(54906003)(6506007)(2616005)(1076003)(6512007)(107886003)(6666004)(186003)(6486002)(478600001)(110136005)(41300700001)(44832011)(8676002)(5660300002)(66946007)(66476007)(4326008)(66556008)(83380400001)(2906002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/8fqyOxXSYepjar/95xktYAV9HwlrqZAKwwxqddUqeVtjvCMdaCUk4ZCuUMS?=
 =?us-ascii?Q?63+5ub4GO5hICbOOdYzGl58DtH6P+yP49wI0piQy4zL9OFulgAwXbgaa5+Xv?=
 =?us-ascii?Q?IAUe1/LWiaAJqHnv97Zkyx1+iTKb9mYBX2o4XJyQ7deXMbEfILLDOHIc6+Le?=
 =?us-ascii?Q?DWRmtBw8Yr/+4orKzwPBPJvbB16+twLYkxpRrkGZOK48on7xL64aEXft/8ie?=
 =?us-ascii?Q?CKolJ8p1IFgYs9Zg1tjZW7eerbJ+h6lCHTDWROUqWCoWgxKTTLYLsC99gLIb?=
 =?us-ascii?Q?ZG8JPpM81psQHN87yYpGXSgvER40BBG6R+Ir8tCmsrabEjMkBaMlE61NR64y?=
 =?us-ascii?Q?+xaLNpOqKSHjm+waqSyLdZH92XYp/YouyKDr/Ollav91qmOLt31YP9xxKoLt?=
 =?us-ascii?Q?0Jx5J1zvO+LlIw+MilHcy5aQGe8lysb/SeAuGQMS0XN4q5cg7G/mVHPGdx9m?=
 =?us-ascii?Q?pdhXs9tJw8ttVfn+g43Otv1TFcd2pp2LWLNbJMa1UFnYZxD+gLK1P1XJhJnW?=
 =?us-ascii?Q?Zy/5weHBbDHn42DqXqmHj/vDocy1Zg8Hk9TeVUjUTT++OWa0rrfbHmYmNts7?=
 =?us-ascii?Q?Tzj6NqmhWTwW5T4Ce89iC8+QHV280fi+Ow0q4CT/CdDj5WzUeRX6Rthz82+M?=
 =?us-ascii?Q?qx/1tA2mdohY/tKnFvug0RHPPdSQq5f+8bUQjTxuAfozbWLxfO/IAcHImHBG?=
 =?us-ascii?Q?oHFGrZRAm42giA5SVEPVe8A8KdbJ37yWrswK2RFVZNPHpKjeFDhKRxcxg7nj?=
 =?us-ascii?Q?nIn/O30IXYtrN7OwCtj1juPeN1mESFzcLkS2GgIqn1RkvGGuFbo6/e9AXTR2?=
 =?us-ascii?Q?dMHgb6vpj2UY0V9Y1ZwYn84TRPDYrqoomiYKBr472fLuuBlECyMNepkvbr05?=
 =?us-ascii?Q?3Tun3/9G1Tmc+mrHY7cqCtsoCTklcFKQ1r5YBO90lT0w4wERpzqWla/O70fI?=
 =?us-ascii?Q?VGhhMmvXFpH3r/wQ6VqWO0pnyfxb5w19y+D2zTQJx+JmMkyPcF1VHl1KFgly?=
 =?us-ascii?Q?K32X/dqTvAxRsthIJV2U1LtCNngvFExTns3ps0L71ntNzxghWlMz5nsxwMf/?=
 =?us-ascii?Q?/zKbSphWGbbUQEXqttkOXy9CuHELnmqUMgcC6mWhfo8rE2lUM2U5EyO1REhW?=
 =?us-ascii?Q?Z4noumynai3s4gs1THLz/b4rhDiWa7njTErL7VpKGI1QwwRr20Neq16bFmzG?=
 =?us-ascii?Q?+Kx1Lf7PmgiAUZLZaLLNkS2oSIiNgNbdrUERMSHwJZKiE/4j8LkF6dskd0CB?=
 =?us-ascii?Q?fU6MEWvdiUaXzoY3PvFG+CBUfS9YdD4ZateVQQ8776ZALOqxrYKPWH0y+55D?=
 =?us-ascii?Q?R0liHvWQapYLSAFUo40z04oDkjsVetI1c+yFt6hj5HiK7XIX6x4oTLcBaDlp?=
 =?us-ascii?Q?+Fg4ioqtu2eeGjhGzW8N+gKaoYzMwICFAYgp4/AkSacnuaxxDAoum8eMNzDb?=
 =?us-ascii?Q?tDQcW1gTxGyVQ3OomDLF4wtwmcXaJxlmZXIU9lTiV/08ebRWNMTaI6cDEfKk?=
 =?us-ascii?Q?ODhJsp8TJiIzCZeB5h+IW4wsL2F9UYkbWxO65ED7aIe47K3DrA60R1p4GClZ?=
 =?us-ascii?Q?UzXT85G8ClG6gBAX+ZyufCNX7pOyKv9yVYnOP6wksJ9QmzdYU/504uOvoomJ?=
 =?us-ascii?Q?Voi+Kx0sdoBjE/xEbrKsWCRY6ufJCtiLcwbnjvpeCeFbSv9ipvQYrTbNYBsc?=
 =?us-ascii?Q?xSLP8Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 945d3471-c5e0-4df0-ba69-08db0361a29e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 08:03:27.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6I/BGDAqC+ZXDoshCzQdkhoxCNSqzN3MU4fF1PkZ2UpDs7HKglVj3X+ya+1ge6D8slwA+G36h7Dv5CJVL/gVor9N346NBoscURw0Ux5Vh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6297
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yanguo Li <yanguo.li@corigine.com>

A mutex may sleep, which is not permitted in atomic context.
Avoid a case where this may arise by moving the to
nfp_flower_lag_get_info_from_netdev() in nfp_tun_write_neigh() spinlock.

Fixes: abc210952af7 ("nfp: flower: tunnel neigh support bond offload")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Yanguo Li <yanguo.li@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index a8678d5612ee..060a77f2265d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -460,6 +460,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 			    sizeof(struct nfp_tun_neigh_v4);
 	unsigned long cookie = (unsigned long)neigh;
 	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_tun_neigh_lag lag_info;
 	struct nfp_neigh_entry *nn_entry;
 	u32 port_id;
 	u8 mtype;
@@ -468,6 +469,11 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 	if (!port_id)
 		return;
 
+	if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT) {
+		memset(&lag_info, 0, sizeof(struct nfp_tun_neigh_lag));
+		nfp_flower_lag_get_info_from_netdev(app, netdev, &lag_info);
+	}
+
 	spin_lock_bh(&priv->predt_lock);
 	nn_entry = rhashtable_lookup_fast(&priv->neigh_table, &cookie,
 					  neigh_table_params);
@@ -515,7 +521,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 		neigh_ha_snapshot(common->dst_addr, neigh, netdev);
 
 		if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT)
-			nfp_flower_lag_get_info_from_netdev(app, netdev, lag);
+			memcpy(lag, &lag_info, sizeof(struct nfp_tun_neigh_lag));
 		common->port_id = cpu_to_be32(port_id);
 
 		if (rhashtable_insert_fast(&priv->neigh_table,
-- 
2.30.2

