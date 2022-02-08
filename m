Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406614AD6BE
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358188AbiBHL3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349575AbiBHKPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 05:15:25 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2120.outbound.protection.outlook.com [40.107.94.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED83C03FEC0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 02:15:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SigUBWDP5NalDXQpagd3VAWRIJOvRLroH12mljh7sG6y0+yOzyDXuyiFcXXlk73q+fynv821ZwFPJKwFMYmUMBf6IgkQp3aC1E/dlm4URSyCCOMInsocUdRlDKJjb+CCa1vQWyRnu6MlrnJ3bqU9ZzdY6mpx8B+0kBR2baD4l7ek5Rwh4/5R+BXIkk8YB2hzTz2zS/qyi6kLwv/3Ys1e2GLKn1DPg/8Xb4vqZQy/vpxZMTSyxbEUwDHXlguSzKnbbmeyI1uH8ZZhnUYHy1HDhsZB0TpdIIj78sWtxwLNxaP+5VqFAy7OkdcdWbzfjnstgIz+P1mvvyC+9QTJSbLLOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tr4U43SXVdeAfzjTE4Fz3Aml686YJVqCH2a/k2/EH4=;
 b=eCHV172u9Vjpvh9vRZTQdh8i46+rBdgHCaEYJz8BYztGbzHtVtk+2RJnJUka6DUp//wUcVicc97WGcgKWjRJoev+yUWhY9y3GJXqmKWPzTncRon0+a/K+wSCV61SbyjXdxiQ1H3MPTtRxYEZcnjsX7rZO/TjdnzVegjg0b9A9C3znwQzhrZ1BQsZOGq5/m0bdLr0d5sgnE9CKvmbrzNeNMGv7+sCZPgCIN33ryDgbyU6d1mLTwOZK9J8wXb73ks8pp10O0UhtHAYce7UvCAt8eMatPgZ5Z/G6SDs1uxFK4q6y0EE30lgJiLd4BkSRqLeYzfOT0Cc5BIp7rDndfFnhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tr4U43SXVdeAfzjTE4Fz3Aml686YJVqCH2a/k2/EH4=;
 b=CjuoThw0yDvHkjro3Pnwc779bctFsVRAgy4+i/vaJD6ape/qYvNV9W2pY/OgZdgIyhFDfx5nISofWshXqC0Qz5A2TuFsvgGEz1nDJdHOBSCYFBPCeKNPj1vTaFkn2f8nq/eRUj/fZSYcYTdkUTeBS9quUtZ00el+gjlO3VL8sEs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4815.namprd13.prod.outlook.com (2603:10b6:806:1ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.9; Tue, 8 Feb
 2022 10:15:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 10:15:20 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: flower: fix ida_idx not being released
Date:   Tue,  8 Feb 2022 11:14:53 +0100
Message-Id: <20220208101453.321949-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P195CA0020.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 065c8a41-ae5a-4562-69d7-08d9eaebe92e
X-MS-TrafficTypeDiagnostic: SA1PR13MB4815:EE_
X-Microsoft-Antispam-PRVS: <SA1PR13MB4815935DBC3F1428D632EB80E82D9@SA1PR13MB4815.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0maAF6K3bowSIwqeRdQ4A9uAEKLl4r3jjfwk46lEroxqLQOFq40oKQqV9T7xIcq0jl5cENg80WvkM0Ho5USzeqGzo8A2tl4pQyU3Dfv2VtyHheoxks/bZPtk1cVVq/GOHHQetp3HfFZVhAzZ1SJdzpDpAcn6dVXpd8FTKo4VTfadI52weALFNwwbSVuyzFRG3kWGv37AVCuhtum9F/s0qbKN6kgCGafPUYdj9hY5TTlLd2zrX67XsBvJA1NlYzyU852KatpiafMYf+S1zRVrSxiTTLJE7MUPrjk0lZnh7vKt5RWyPKIzEglJH5OyKwzsesS1XCSc6w0PZRZkRmv96f6+nebq87X8pJdn9l9lkl8i8A8ZMxaTj5HNLgwXzbYpliV6pcKmSNxV70J/gMRj7mff61MwxAx/Ed48PNuTXYafu8BwBELoff3g374s4VyrLn/Gx4IEtQe5qvwCM1Oo+HtwKrYQwbsHvKyugSeAdX4x51tNmeZXHIThe9r6YMiAp2h7lJCNLxLspFMrUh176KUBDfyrQyGdCLTUj+NV/7rWk7qy0yB7FGJ+cSm17awoUQ/t70iRL8NyyYrIt0XgMI7CwWgFfhRqfO1IMsjeXZaYgXgrnLuI4s3XVx3WxP9BmH1KOZdjkMR0JauwWB30Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(136003)(376002)(396003)(39830400003)(107886003)(1076003)(66556008)(2906002)(38100700002)(4326008)(186003)(54906003)(66946007)(8676002)(36756003)(66476007)(110136005)(2616005)(316002)(83380400001)(86362001)(6512007)(6666004)(6506007)(52116002)(508600001)(44832011)(5660300002)(6486002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uvjPdB/Ykh9bO4j/89fVZUVuzxxYHXQqCisTXGWK65W6pETjE6IsT78/xKlA?=
 =?us-ascii?Q?iusgyN+zx4ScDKKAjGvLsDHhOVZz4yDHycESSK4y6z9ce2+FLjZraR9m0JA7?=
 =?us-ascii?Q?HVBSf3Y2u3ImThJ8PwD6ezHq/slbSl5K0hLT1zO4v9wbQt+cK9No1wauEPb8?=
 =?us-ascii?Q?n9pQKt5x1uJ9grO0Y9RgwQMWaSRV6zg403MfFc7L2nKKmR26dffi42ydfUZb?=
 =?us-ascii?Q?W9evjetf7YvTitzckxm1R/KRLvWqPfVFv8A4tR/QjnMBLjyimsBUFUh7ZMp2?=
 =?us-ascii?Q?xqmR5ZelcCYvneauAt6BHMnaOEbun+6v7hLyjBlNQzSB5aHhDF/TuBDei21G?=
 =?us-ascii?Q?HSrBC8quvoW9Nc+8KlKapCs2HbSVip0LbUjxEzxOqL9B1oE6uM1QdQQb3qIa?=
 =?us-ascii?Q?wIiQ3ovGkMOyxNCoWsWuO2XHGIHQKvFoS9oTho+v9D3Lg/ZFIXhCMBQjB4KQ?=
 =?us-ascii?Q?Uj0ZFojW2yJb2tRmXqETf9ali6I0FZIejyzSuxo0rZ8JnoTGr2wM0+gAeC7a?=
 =?us-ascii?Q?GHMgsl8WCWj4ZqWq0tYz0Huhcir+WNFz6tj4HCdnLWRnhrRU4DnF7cAMidGK?=
 =?us-ascii?Q?zjbqC0lpdtmphTtEcOpnesLMnJNAeFTNowdtsYPfIfMfLqsIx9K3iiIFVBV7?=
 =?us-ascii?Q?os/bWOfofRpKwK0OxIwQYQUiptowno3fifKDlcMpLGvNky0Z6c/Nvuy2/qMR?=
 =?us-ascii?Q?xtiSoUwt6XGLKKM+WhGUig+fZ7XZkVDQDuYSoQ26ggaZAS/FsIwM8s4vn4Q9?=
 =?us-ascii?Q?gfKysbrdQjzKEONAeMuX7uTZqf/AY7wlCfSqyOqNGAmU6dWZ2RbqYBiE23T0?=
 =?us-ascii?Q?GDodooAZsOS6aQ80yFZR1+XuRGW3nZ7/QyPpwGO2vAWiKYbfI2F+/ggo/NQs?=
 =?us-ascii?Q?O67DWS69IgvXjswD21R9JFu65Zj4/f//rDu0l1q++PeyILvgcLoiTkXm8CPy?=
 =?us-ascii?Q?AQDYtxkXzC46lEeRAk8tOufltSOJdP/CrHew54rOabaoXPqHcdYGZIf3Ctev?=
 =?us-ascii?Q?KuXbsLhIFq8Heu2oTzQdLT+SfxA1O+P7RuzZYKb5Mv9d4MKXYE/Edf9SltHd?=
 =?us-ascii?Q?3FeXK2yQS4Q/vX33YR9OTpFaz3jgz5jkwt013GflEMZwarmyB3ioX6e2cYUx?=
 =?us-ascii?Q?GEPcZc37saBiDRV63AOucf1H1F6PAOmPYXiX1Th8uS56JfdxtfmKi1YArxtv?=
 =?us-ascii?Q?hNFWW4P+Z9dpC8qREav3OmNh0MXNtqmXq90ByahuRyuJFeWpzGCmYgHj49Qc?=
 =?us-ascii?Q?M9aIwrEuZQhfbRDKh8E8Tz28EePXDVhelWO9GUMGk7QuxVEz31LO8VZ15bW/?=
 =?us-ascii?Q?ZaPZWLXiq44IlJffMofjQ2fGuQMZKKkykQ9fsAdSNJ9BYPZKSNj9q9FD57eu?=
 =?us-ascii?Q?v2mKGvddahws9CJfQubh7p3eaWmBf04TAInp/gE1tprBk4399zwermmU6iUn?=
 =?us-ascii?Q?MEGKiAtnflYJGWKqD9y33hCrLANJ3eD8ecAtXddI9E5gNhcc8VO/tfqq4EYY?=
 =?us-ascii?Q?iuBFuEwQE2gpV8ZxHCNpv94UdD62PX8ZG8zkNtn0nU5WP7BrxDM/u+vdAKAM?=
 =?us-ascii?Q?QcKQ5c1m8gxCThRBC9yvUVpZxDGZ7L/oZFwFPtmIGAksTiiTHbchsu64o3ve?=
 =?us-ascii?Q?+qenrKP0U+ItwskT1k/tIEZ0RMjIo+OIFchqNo2utEgXTZTt5tUUJl6RDjHz?=
 =?us-ascii?Q?R+HkNHfTiP6ZKQOqNOeymh6odymhepzQBl8WqNC7d/Ehwj0gCR2jAeuKX4vu?=
 =?us-ascii?Q?MVycc1C8UDjj9lEBjQzmIdgDsjHxTuY=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065c8a41-ae5a-4562-69d7-08d9eaebe92e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 10:15:20.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRU+Ot43m+Hv2LtLjG6M6p91uvXtjydAspthGr0pqDmA1mJ0kxNRwPxGw9Bwal//5xqCWQyDcwB6zaPSnh8hjBvdKUDf9gndmwh00Hk7fuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4815
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

When looking for a global mac index the extra NFP_TUN_PRE_TUN_IDX_BIT
that gets set if nfp_flower_is_supported_bridge is true is not taken
into account. Consequently the path that should release the ida_index
in cleanup is never triggered, causing messages like:

    nfp 0000:02:00.0: nfp: Failed to offload MAC on br-ex.
    nfp 0000:02:00.0: nfp: Failed to offload MAC on br-ex.
    nfp 0000:02:00.0: nfp: Failed to offload MAC on br-ex.

after NFP_MAX_MAC_INDEX number of reconfigs. Ultimately this lead to
new tunnel flows not being offloaded.

Fix this by unsetting the NFP_TUN_PRE_TUN_IDX_BIT before checking if
the port is of type OTHER.

Fixes: 2e0bc7f3cb55 ("nfp: flower: encode mac indexes with pre-tunnel rule check")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/tunnel_conf.c  | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index dfb4468fe287..0a326e04e692 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -1011,6 +1011,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_flower_repr_priv *repr_priv;
 	struct nfp_tun_offloaded_mac *entry;
 	struct nfp_repr *repr;
+	u16 nfp_mac_idx;
 	int ida_idx;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, mac);
@@ -1029,8 +1030,6 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 		entry->bridge_count--;
 
 		if (!entry->bridge_count && entry->ref_count) {
-			u16 nfp_mac_idx;
-
 			nfp_mac_idx = entry->index & ~NFP_TUN_PRE_TUN_IDX_BIT;
 			if (__nfp_tunnel_offload_mac(app, mac, nfp_mac_idx,
 						     false)) {
@@ -1046,7 +1045,6 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 
 	/* If MAC is now used by 1 repr set the offloaded MAC index to port. */
 	if (entry->ref_count == 1 && list_is_singular(&entry->repr_list)) {
-		u16 nfp_mac_idx;
 		int port, err;
 
 		repr_priv = list_first_entry(&entry->repr_list,
@@ -1074,8 +1072,14 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	WARN_ON_ONCE(rhashtable_remove_fast(&priv->tun.offloaded_macs,
 					    &entry->ht_node,
 					    offloaded_macs_params));
+
+	if (nfp_flower_is_supported_bridge(netdev))
+		nfp_mac_idx = entry->index & ~NFP_TUN_PRE_TUN_IDX_BIT;
+	else
+		nfp_mac_idx = entry->index;
+
 	/* If MAC has global ID then extract and free the ida entry. */
-	if (nfp_tunnel_is_mac_idx_global(entry->index)) {
+	if (nfp_tunnel_is_mac_idx_global(nfp_mac_idx)) {
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
 		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
 	}
-- 
2.30.2

