Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C80A68B993
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjBFKKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjBFKJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:28 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8C716AF8;
        Mon,  6 Feb 2023 02:09:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H77ff68r96oC7ivfWN8wosaul5ojAdeBHpbmTiKJMuiCge5U83f+u5qoqAvI51XPwMpfeSeNmkuZ3zqd+M+hFXWCDCEs/qf1rjKAv9xAGIFZHJXp0LhAfNJDre6ILP++hLNXIHBsEw6AZXjAyGPaJ7bNlbFLbh3hC3t7YgU0O+HTQ4M93rnTVrQQOshqBLY5+79OU2v2nEQ02iDz0I9wb6Ln042XJU619Pxe7mnigHwS6p8XVK/fHmVnm8pI4LaZ+kUSUQ0qBCEbX/1ySDHnrw5Bk94TogtbWDbNC2yhbiIJ3Fpw7ETcxLCyDYikv/UKOtaKAOGnLksFi0mbSvy3lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1VObVU7XtxZAbGlqMoizJddwCxMLHnrb49AzScRiWs=;
 b=AinfPQh363cz7aIKZFa0fcSBsLHb/j1z4v+oZFaXwLMUPM1hjNVGDJtNEmrqrVX0/wAqtK0jvmst2iAKNrAf3opkA9dhBN2thDL7ANvoWzxjjixknGoFBoZxQqQ5ByxietYpgsu1bhkkM71GznZKXqSihqBheQ7OdNWq8xFw4byWEhghzclnkOYrG8EFA3dJMx3s079/OMk+0vZfAikI8YBfrlcMmABqHzHQhE+ilxroDqLWY9VL5iGgVLTIoF5RxiYoYxahn3qUwWesZsNBhPmbEsMasDnDGEvlWMWcVaHBw3uB7NIOTiyqq9wnpWsMucI034BehiQUWoTAZ/TSgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1VObVU7XtxZAbGlqMoizJddwCxMLHnrb49AzScRiWs=;
 b=LC9PjKbFKm3O/H2nA4BNHLAotlnfvBz8ajrhG2o3/g1iICw0OAoajyrjbcgIxrgFYMmykMcwImxXYzcSEzZzX5q7Cbp30/iVEtjJxwUH4RC/oKjU+oCF7f1c2Gi3vKRBjGL0I4UvZqk+t7Y4RF/CkaUZp0cgeG/SD38pb/SFr9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7735.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 09/11] net: enetc: move setting of ENETC_TXBD_FLAGS_F flag to enetc_xdp_map_tx_buff()
Date:   Mon,  6 Feb 2023 12:08:35 +0200
Message-Id: <20230206100837.451300-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206100837.451300-1-vladimir.oltean@nxp.com>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e4edd8-a7e7-48de-8cba-08db082a31c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z8ARWbwn25g6t0PiWmM8/2eqeYUrWBHDDhaSGlWbtHdiMQSF8RVqpbpwnziRXWs9YHOnFJC9YeqmVKBrUoF+5ChAc7Aitn+NKu3I2f5BQRnpQs5JmCYqsXCHO1bW/8h74e8RS76M8rhJrQ7mgCDTNkfAKnedAPAUOGXzh9m8pOwUpaKddYLkIRz7DUUId3wFDT66HogOmpvxJAD2gvIP9kTtgUoPwYjpM+PChebUV8FWRZV523dExFM3N0r1KeJpng1WGi0hmPX/NZEQg+oT6NA8m6LZ8lkXcN1Z46+4OVgveEoKbxURwyqeekhZ8JyLlNvBU6ReiTxb0w1yJGRafCKhP2PXOp2T97RwMgiNiN3Pqqvz9hYKRrOizqdeTS8q5V+QQahP8p8SasL79MTtpCY0/dk7i4dWxp3nw2ksWCLNufc/dRGM7qnNzX8ielB4SyKgqsuzZLtuMvLFmRoH5M0AEQw+o65DuO62y2a45AGeugB0PcsVXbdMVPv6aIV9gXofrZM8MbyZiIrkNFTNl7NbYvMgatDF4YtYTrauJG+XmhIPTi2QAeAk5Ubzz92l+vcoEy77gYrXHSzpniXJ3obosXNYjKJL19TRdxqKaXS621LNd8xwdqviJ4EQKQyphAYzs5upqXTKxj9MHqgso/DzWKda8LNASNLNbAi5kF1M0cbQWCi8D5NPeEXbXfLCmHOpO8jCVxkGNRGQ04x+vA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(66946007)(66556008)(4326008)(6916009)(41300700001)(8936002)(8676002)(7416002)(5660300002)(54906003)(66476007)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(186003)(52116002)(6512007)(26005)(316002)(6506007)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pxzn3+oYfllVWGtm9cynO9oj5nn/Acj1SlO67KIHwfYbrnUv8ALGXqmjczzc?=
 =?us-ascii?Q?o65l2P5LyFXjdtW6obbXgStsjUdIWv8ss7asaxuUDwqwAqL6Nc3KR90U8MLc?=
 =?us-ascii?Q?VWlyFXpTsyIXFNqjsOGZxngKH5CLrns5zsviE93MIOH8tZ6cXPsusCxS2atp?=
 =?us-ascii?Q?zcB0k41turKRMuTz29f9wLpqbbo/x5pAG97f7ddyMAqlEV7Jvf8pj8F8x4A8?=
 =?us-ascii?Q?BMqL+kULol8CUvaUzjAUAooOaaLSGufgwWdXL16SzjopcOLur92wHV2ZRt+5?=
 =?us-ascii?Q?eOiDZqMfp6JffcqCVFCXTtWZ7SUU7nZtRwXT+LiGJQSi8k3xpsQDb8Yc6zOA?=
 =?us-ascii?Q?isj4vcy5xDw16LEbNmSxwbRVmeaLqPVOEhY0yJtBUh9STwsdKK7lFBEpK1cw?=
 =?us-ascii?Q?3oxgzcDX11Y1PYbk4EHr5uSCM03pa53nSa/cswiV16z6uI1gxga8Du6OPs6p?=
 =?us-ascii?Q?GkT0sZU5+m69WdxnPB3/bnN9YGW9ASHGe8+GO4N7nlgEX9ETySOUzjB6w69k?=
 =?us-ascii?Q?6YMl3YMeKLaeIoRc2b1Zjhu7S064i0B38DVvofTFlUiR352K6LmDHThRr9BG?=
 =?us-ascii?Q?pmZ6JrD2pR1WUSTWX65zMDi62NqweqQ/DOjX8yrD6TPTcCQSo5+mYKXwJwGm?=
 =?us-ascii?Q?8Jm2v1psd913Z9pL/7kQXOPOx3sjGcL7Ga1hYdqrtV/JI2w2pqthQTKkYGtY?=
 =?us-ascii?Q?A9oMWTF0vbjjpklgM14jAdil0ZvY4lb/NtMpnwqXxrZnmPntYnEJ4YQxtUrR?=
 =?us-ascii?Q?Ru6JLhDdk8GwCLZX3xpYXId4YPbE6Z63Dlt/2xoGsdn4YLZGkYUrvUvx18h3?=
 =?us-ascii?Q?B/dzJ71aXDu0ra5xf9iQlLvj4QaryLhx1UvFbU9UlPHXK0q2PFP16z2oHNYj?=
 =?us-ascii?Q?/UTc3R1yo0a21l4yfRm5wB/cI8wa5Z3SAySYk19ksreN4NkJ0i27D9XIuVh7?=
 =?us-ascii?Q?hNEAmI+bgGtpFIZ6anBa/pk45e0Ykw8b5HXRwV69QzNoYFaFk77hTXBg4ieM?=
 =?us-ascii?Q?v+DB4UuaiHI8fbklyuv/SOu1rHjsYc/JBM8sQ6yXel1fNLxR5mxyrNRNhTHS?=
 =?us-ascii?Q?5lszzd/y5Viwxpji6aylFxx9kiHO3TdiiRxIlxgitYetfJpnwtRJ9NZoIJdQ?=
 =?us-ascii?Q?RMF3MfqpMLsSsAW6/u3bvZD7dw0fyyy+aOvfLu4LyFIGD35PPalf1s6vENnD?=
 =?us-ascii?Q?Okiv7n0Mk3Uq9UdCC7Tv2ksLiV2YV0ueSSvjWaYYm6k/KSXgiC07Jm2kpZ7b?=
 =?us-ascii?Q?/EgECq44F5wXlIQJ41W1udc6Eu6ZGPbflYt6up+7ENBuzHeRU5tF+jtwQpw6?=
 =?us-ascii?Q?IRvCk3jmnQEyAJMBsZP6aX0sCKTgDhnjT+tGaTuNSIu6fVSqUGj26ajorZN7?=
 =?us-ascii?Q?FT9Vf4QmDA5x+p1mOZxIY/UqKngrydUHAVVZh5N5y5NImpg0i90zMF18CjPb?=
 =?us-ascii?Q?zmWrx1YeOhLd1i9E0/D12oH1FeOgNZ/kpavrkadXxJTwPsmhp03tV4lyhqqU?=
 =?us-ascii?Q?survXGaHW2GPmShQdQVJI8aTWaFRoVAbg9ma5ZPbYLy65/yKtM5UgmHRMyuP?=
 =?us-ascii?Q?/JXXcdLzpCJkGxgtQnAj9ZkL3L1jFFdJGp273Uf4xMnOtUU5LSeDLezrLxED?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e4edd8-a7e7-48de-8cba-08db082a31c5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:12.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ze3xSJhzW5OWB7ni0eWP9IJwWAYADi2sWegZOUDfsJ6PB/lMLtbpq1huMty3E9vzEP4YUAToWWT7OmoJHMLXFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7735
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XSK transmission will reuse this procedure, and will also need the logic
for setting the "final" bit of a TX BD, based on tx_swbd->is_eof.
Not sure why this was left to be done by the caller of
enetc_xdp_map_tx_buff(), but move it inside.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e4552acf762c..dee432cacf85 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1263,6 +1263,10 @@ static void enetc_xdp_map_tx_buff(struct enetc_bdr *tx_ring, int i,
 	txbd->buf_len = cpu_to_le16(tx_swbd->len);
 	txbd->frm_len = cpu_to_le16(frm_len);
 
+	/* last BD needs 'F' bit set */
+	if (tx_swbd->is_eof)
+		txbd->flags = ENETC_TXBD_FLAGS_F;
+
 	memcpy(&tx_ring->tx_swbd[i], tx_swbd, sizeof(*tx_swbd));
 }
 
@@ -1286,17 +1290,7 @@ static bool enetc_xdp_tx(struct enetc_bdr *tx_ring,
 	i = tx_ring->next_to_use;
 
 	for (k = 0; k < num_tx_swbd; k++) {
-		struct enetc_tx_swbd *xdp_tx_swbd = &xdp_tx_arr[k];
-
-		enetc_xdp_map_tx_buff(tx_ring, i, xdp_tx_swbd, frm_len);
-
-		/* last BD needs 'F' bit set */
-		if (xdp_tx_swbd->is_eof) {
-			union enetc_tx_bd *txbd = ENETC_TXBD(*tx_ring, i);
-
-			txbd->flags = ENETC_TXBD_FLAGS_F;
-		}
-
+		enetc_xdp_map_tx_buff(tx_ring, i, &xdp_tx_arr[k], frm_len);
 		enetc_bdr_idx_inc(tx_ring, &i);
 	}
 
-- 
2.34.1

