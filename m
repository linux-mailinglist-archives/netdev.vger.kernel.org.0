Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFBA64AC3E
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 01:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiLMAV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 19:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiLMAVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 19:21:38 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2061.outbound.protection.outlook.com [40.107.241.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737EB1DDD4;
        Mon, 12 Dec 2022 16:20:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcGyVHpoqhYcPg15gh66CuLvEvnF1TrdoZg5Us/pK5WjVHyVqTZkdyZsHHte5wcgnvXRCCd8qrW1lj24Y4Xhdbq+bojYFFIk0XengYe7edrnPDtfHmy/N7vckEbfPgu2smidq4CjvqlAX6S+Pn1OCCD1iqZ1+5aLtfpIKGfrKdHZ4z3BTeXMffPzXfyVdTWoJAtaQ/ZC1Vx4uHiZ552VcZXraw7GKDolo5cY9OfE+0jEQkg1/FBx96OUpFW+AMtyH2TkfQblpnldj/iNBh6kWLSicHNsg6Qsi4MqhRAcCpHB9ZklzfY6oQzAV1bBWNH2GZYnxuObQjVXnkPbxMymUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxaS71je4sYuxW0KmcMADjd1L0nF1JzCzuhsYSJCgi0=;
 b=UBRVwfO3k8VaHJuC1dlIGMYTj53QlFvfPrn2UEv6eYh8r5AeEUiw4SzUO3ddWxyYzY+HaB9fWCP5h+B3Zl9Zrt+wRya575GFaGU4eBdmZn3qUXhhS2HJH36Xjx2El1VxjXREKnWF7rCAh15i0klGHhF1Rkh1I9BPDdzgSanWL9w/VZmmjvTfMtdBM89Y53CIoP51vDrefRY84gLflN5LSnJvTQhDpLCyLJp943OM8PsOQkhZX/QySA1gIPBavTVYFFwBSq236wrWjtI76Wa2sYzxcOnaBIlF8nSOFKRH+JqLXGWRss0p5pWIiXe5cfWAH7dWzkO+LtyIHMb4iSyEMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxaS71je4sYuxW0KmcMADjd1L0nF1JzCzuhsYSJCgi0=;
 b=XWbyhL7Svj2td+f5l1w3OhRyAHF5HqiP6iIaN6pRqOfNo73/GAgmtK7wKTgrCFiuT6DLA0aVKydHEmx0kO0tcJE0puLViz47a0wS+kjWnTlp5ddugsHc0qktANUriW9BB1Hom/8LNLQe5IgrdYXagJx4jXeoMGJUHrB2R9ekZVA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB7091.eurprd04.prod.outlook.com (2603:10a6:208:197::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 00:19:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 00:19:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH net] net: enetc: avoid buffer leaks on xdp_do_redirect() failure
Date:   Tue, 13 Dec 2022 02:19:08 +0200
Message-Id: <20221213001908.2347046-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM0PR04MB7091:EE_
X-MS-Office365-Filtering-Correlation-Id: f7e1efb6-6a8e-4783-3ea7-08dadc9faefe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0QbkapjsKtZ844qu3L5w9Ug7817CG/kZJrrjq9GWXXvRpQEOBrdOqga+2T7EgPojtETf2OTWeNMOrbX2PFravWB8xnira0zDdRV7DQJer7b4t+B/NvmE24rPYB+EtP/SP1DTDmeoK5ebhgNaPkGaw1L7VTwL4vi7hIwGutH1wlOPyocnUa2kaDP4i8NwwWnr+67Okun/hYV6FSllo/ErweXPELllfbd5cFyc4BXoymWu4I+H7Ih6ARqYDty11T+QVNxFa6VUhMXPjx2oRayqIpvb198e4EXVwQJo5m2XIHskrRr1jwTaSLETPZDN9pXcGpzfskDpd3CDJBstgtPmoYKvuvEVj8I2sE0dsMCmCvmytRjb2X0pEVqqaqmQRgbTFe/19l/p/Rn7NSLYXVr9LuzSL0nTwzPiWnpJ1QGy7bqmvWnviLx8Egmr07ZJx7KtqU0NVYFvYuveMcF9EzBIQIiXs/EUtC7MygMBwAa+R/eQMsQo2sANWSHEjv7JEfDo2Lq0+PhYj5OMM0OT84wLTJo/jj4IrOL/91N6TXgW/T6g2TCAHcL+9VtKTLun53s/Zso1WNkKrQARNwpqGoj2+M5gdVs4u96yI5PUx2ZrV/1rPOKrCdbs7ohkNxOelftB0hvsdJtSAkdpIS8NC1S9FF/5pXN5PzMsab4YOjU60NJ4Z711tbHuCbU5a36g7IIj+iBVeNHfgEDJWgQIakR3+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199015)(38350700002)(38100700002)(83380400001)(66899015)(86362001)(1076003)(36756003)(2906002)(6512007)(186003)(6506007)(6666004)(26005)(5660300002)(8936002)(41300700001)(44832011)(2616005)(8676002)(4326008)(66476007)(52116002)(54906003)(6916009)(316002)(66946007)(478600001)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SGffCefRQ9LZzrlqV21PVdYDkomAdKoy16Q+zu/zoNR8ImkUMIbtefN0D8XP?=
 =?us-ascii?Q?u9vKozFlhIcfsosyniG7y/rSLolwR+h/4iijUj/YGT35vNmgLWiTM3ESyoWq?=
 =?us-ascii?Q?TJlNfYn+vyh5yfBLVTHWgBe+YV4upifHETWno5vjO0US0oSqj/40NLS8s8vM?=
 =?us-ascii?Q?oD6XdTtU7W7qmcKhYiv4/EiEnPinghFZX6DH4pa+nipDMuwZdqbYNfxzVFUs?=
 =?us-ascii?Q?RFAbLWgZ5j83P4CuivlSwYd5j8v95YY90YXa3gh+vx+jPmftAoFBO8VVDqvy?=
 =?us-ascii?Q?/riTdX4QEBHoy4ZFrPyPEc3t9gdSRc8BtoSZosyg2OT3x/cOt7pGI7vuuaF3?=
 =?us-ascii?Q?aottSHkBSWIa4xbWEYFQ6hhoqD3hx0haF2nqmhntkCzkYT5LxGZ2C6+5RP89?=
 =?us-ascii?Q?DFxElRl4CIoHt0VmJr0P0zsacWh8sZpTsw8O75qlQdcSspXASKooEMHxSBgq?=
 =?us-ascii?Q?7NPcYRnSQ4o15T6DXqqUHwfjgRzi1p4isZ0WZ/kteBuH9mMGVIKC+HgDogPc?=
 =?us-ascii?Q?CGJ5Y9KHJKMjpiycGDFBZPG4Auglsi9gbBlkzKYYZDhZmcHKX0Gl2VdUMLox?=
 =?us-ascii?Q?7NG27sCmwV319xfTnhGt7YpbM1y3S5zEHp6Ql3J14lDtYXnjahMavQgwMZPq?=
 =?us-ascii?Q?gBPQRGHL4dCFAzVgfsjeXZID2TVNGioTKtwM8TaPuAxuDO5GvG7WfEgvfIhe?=
 =?us-ascii?Q?EsrhlwEMWhh1zWABM3iEjg6ST7nzBLRFX8sUn/EECQB1slLuRCLm+H5idRA6?=
 =?us-ascii?Q?i7lFvx19QTi8/A5bPo7pAKKfzNHXU+LIg3UcQX6jg0FOnquS9Hfe+Jzk4Ma6?=
 =?us-ascii?Q?K7nXL8+GZ0P4vGN+1YEwGLE56MqGlBePI7yPFhobOpihXV3UH+yTI6dyxAIe?=
 =?us-ascii?Q?9nMS2uEGAE70LjwPqwfXT69KE22gaIH89cmKdmXbbe2HTDFlf+pIN5dwrli3?=
 =?us-ascii?Q?82+9YAiblCTkAmIPVPIabBR4sw9ihB1uwSxuAiZMp7NGpseNq9M7bDWn7D7Z?=
 =?us-ascii?Q?BIvLObymaOCXFs/AamBX3ZYY7mycMlbOVFiSADrE3U0JuFWjzwVvY5lO4LjH?=
 =?us-ascii?Q?4ALxXK4Ir/vGENIX2znb6BEJqYiAv7hDYPBDrl6gRF9XJuWnNGUPZnxBpoBV?=
 =?us-ascii?Q?miHrb+9Vamg8HhA0r/xxcGTSW9HpORo+Bzp3n+uo6LHSjWKZ1c9GW2FjHbmA?=
 =?us-ascii?Q?SLaT2yFpjedreXjTeIYdZBSUxj6a1BIi2ptC2+9uzJprU2JT2A9/GGv+Mkck?=
 =?us-ascii?Q?uqC+aZebPgAecohV7iFnY0MqkRKZ1pwMsJsAaDXEptUdwukWX/CTu7yGvURJ?=
 =?us-ascii?Q?uJdjXyB+UbyEyq/l7DOPm59eDQmteGb1ODuX5FgDCTv899UgfaXT19RgM88R?=
 =?us-ascii?Q?yBK8WKH38kLYpCGUKwzPQaRXrx+a1ztidkA5lQLSOyeHCzRklp+3/Oto56yQ?=
 =?us-ascii?Q?vpshs2vYJ/LzSN0/aTpeVGC9vFIys0FIqcB29c025u1Wz3NDm7h4m4d5BK++?=
 =?us-ascii?Q?YD6moy03kQXti0/FQF7MshE/Axe2kyzoypf1dM3ptojW/ynFt37BynXIJ2lE?=
 =?us-ascii?Q?GFRlvA7fu5jl/u4gWfWzDmhI+2g84iPUcMByaIeC3S8zdL5QnyilF+GlUhG2?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e1efb6-6a8e-4783-3ea7-08dadc9faefe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 00:19:22.1873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SGoA3M8L1bW3Nhm/67evjotttf4OSOshOt6+sT7F5VvAEaMS1nfz3YSRFHMTwqKrrrzCf//aHmtN2T09Tt1ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7091
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before enetc_clean_rx_ring_xdp() calls xdp_do_redirect(), each software
BD in the RX ring between index orig_i and i can have one of 2 refcount
values on its page.

We are the owner of the current buffer that is being processed, so the
refcount will be at least 1.

If the current owner of the buffer at the diametrically opposed index
in the RX ring (i.o.w, the other half of this page) has not yet called
kfree(), this page's refcount could even be 2.

enetc_page_reusable() in enetc_flip_rx_buff() tests for the page
refcount against 1, and [ if it's 2 ] does not attempt to reuse it.

But if enetc_flip_rx_buff() is put after the xdp_do_redirect() call,
the page refcount can have one of 3 values. It can also be 0, if there
is no owner of the other page half, and xdp_do_redirect() for this
buffer ran so far that it triggered a flush of the devmap/cpumap bulk
queue, and the consumers of those bulk queues also freed the buffer,
all by the time xdp_do_redirect() returns the execution back to enetc.

This is the reason why enetc_flip_rx_buff() is called before
xdp_do_redirect(), but there is a big flaw with that reasoning:
enetc_flip_rx_buff() will set rx_swbd->page = NULL on both sides of the
enetc_page_reusable() branch, and if xdp_do_redirect() returns an error,
we call enetc_xdp_free(), which does not deal gracefully with that.

In fact, what happens is quite special. The page refcounts start as 1.
enetc_flip_rx_buff() figures they're reusable, transfers these
rx_swbd->page pointers to a different rx_swbd in enetc_reuse_page(), and
bumps the refcount to 2. When xdp_do_redirect() later returns an error,
we call the no-op enetc_xdp_free(), but we still haven't lost the
reference to that page. A copy of it is still at rx_ring->next_to_alloc,
but that has refcount 2 (and there are no concurrent owners of it in
flight, to drop the refcount). What really kills the system is when
we'll flip the rx_swbd->page the second time around. With an updated
refcount of 2, the page will not be reusable and we'll really leak it.
Then enetc_new_page() will have to allocate more pages, which will then
eventually leak again on further errors from xdp_do_redirect().

The problem, summarized, is that we zeroize rx_swbd->page before we're
completely done with it, and this makes it impossible for the error path
to do something with it.

Since the packet is potentially multi-buffer and therefore the
rx_swbd->page is potentially an array, manual passing of the old
pointers between enetc_flip_rx_buff() and enetc_xdp_free() is a bit
difficult.

For the sake of going with a simple solution, we accept the possibility
of racing with xdp_do_redirect(), and we move the flip procedure to
execute only on the redirect success path. By racing, I mean that the
page may be deemed as not reusable by enetc (having a refcount of 0),
but there will be no leak in that case, either.

Once we accept that, we have something better to do with buffers on
XDP_REDIRECT failure. Since we haven't performed half-page flipping yet,
we won't, either (and this way, we can avoid enetc_xdp_free()
completely, which gives the entire page to the slab allocator).
Instead, we'll call enetc_xdp_drop(), which will recycle this half of
the buffer back to the RX ring.

Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
Suggested-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 35 +++++---------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 8671591cb750..3a79ead5219a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1489,23 +1489,6 @@ static void enetc_xdp_drop(struct enetc_bdr *rx_ring, int rx_ring_first,
 	rx_ring->stats.xdp_drops++;
 }
 
-static void enetc_xdp_free(struct enetc_bdr *rx_ring, int rx_ring_first,
-			   int rx_ring_last)
-{
-	while (rx_ring_first != rx_ring_last) {
-		struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[rx_ring_first];
-
-		if (rx_swbd->page) {
-			dma_unmap_page(rx_ring->dev, rx_swbd->dma, PAGE_SIZE,
-				       rx_swbd->dir);
-			__free_page(rx_swbd->page);
-			rx_swbd->page = NULL;
-		}
-		enetc_bdr_idx_inc(rx_ring, &rx_ring_first);
-	}
-	rx_ring->stats.xdp_redirect_failures++;
-}
-
 static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				   struct napi_struct *napi, int work_limit,
 				   struct bpf_prog *prog)
@@ -1527,8 +1510,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		int orig_i, orig_cleaned_cnt;
 		struct xdp_buff xdp_buff;
 		struct sk_buff *skb;
-		int tmp_orig_i, err;
 		u32 bd_status;
+		int err;
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
@@ -1615,18 +1598,16 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				break;
 			}
 
-			tmp_orig_i = orig_i;
-
-			while (orig_i != i) {
-				enetc_flip_rx_buff(rx_ring,
-						   &rx_ring->rx_swbd[orig_i]);
-				enetc_bdr_idx_inc(rx_ring, &orig_i);
-			}
-
 			err = xdp_do_redirect(rx_ring->ndev, &xdp_buff, prog);
 			if (unlikely(err)) {
-				enetc_xdp_free(rx_ring, tmp_orig_i, i);
+				enetc_xdp_drop(rx_ring, orig_i, i);
+				rx_ring->stats.xdp_redirect_failures++;
 			} else {
+				while (orig_i != i) {
+					enetc_flip_rx_buff(rx_ring,
+							   &rx_ring->rx_swbd[orig_i]);
+					enetc_bdr_idx_inc(rx_ring, &orig_i);
+				}
 				xdp_redirect_frm_cnt++;
 				rx_ring->stats.xdp_redirect++;
 			}
-- 
2.34.1

