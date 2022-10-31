Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E686613B19
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiJaQWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJaQWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:22:34 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2079.outbound.protection.outlook.com [40.107.21.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176EBF022;
        Mon, 31 Oct 2022 09:22:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKiydg7gsFqFDq1YDhh42p2rYwCDZTH4F+Cp21Bp2xKaNXKFdtMLLY4Lzbnqa1iCHWmTD+kTpE8iYZqfnHOsmZ+BWNID5PeQFJSsdBm3eU0hMXSmkLpd7nSzwkxNXVe/TP94GlKvH3yW3XXgkWswftI+SvxUMG6RvIlxVbK01pURIAkqUA5/FFXppaDFBtZSXbDYihgG4KSNnd+81xXXkQRCreNgksgxzKL4weT1zk+Dm++CMqpGavapKV3WRh3z1yqMZT416lz5OoxyDWF6urQvI+Zr1jeTkLDuLHV/raDnjk3r9VMkY/O54rhCqisB5Ec1eHR3DUg6Ap38eQ206w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckzRBYTNpTgjcPb4TSgOL3GlzR/Hs+Gni4v6Wd7L2aw=;
 b=io5/BdNbAMvksRNuvbu0hHN6FxTF/hgLBPuEH1yZCW5MqKe1jRd/9xZZDw/vGNy7m0NGlB7KBUzTyAJwm/MZ6DlaQREv/OGgm3RpSndwkwrPo/Sw+9sWn1WjbL036zxpdP7rvOoiqD4P0tMW7u/SZIE71GjcPjhr0zhruxJF/+xLc4kjdJlohEXzSdsu5syVzBIOmPus7UiRygSrRXtkP8BiiQj3WqgCsOrbY4PppgSkR6BU8i0u18kJxFdPi/IjlpfYyv5ac01VOfnUUWju46l8yvhH7tMcXETs+DPYiE3yUaGbo9lwWcorEhOBIbW4fn+48/SrYHsuO3pYNA03yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckzRBYTNpTgjcPb4TSgOL3GlzR/Hs+Gni4v6Wd7L2aw=;
 b=ka95ebudSqlREQY5RTlW0DO2crMZqrMjd8F8GdwJgmQ6KS/l/Taaunir1fEhJTwAbjT3xQc9e6M4mjqkZsJmK8/jriKiLl85bllhNeUtKlBeDFTpn3BOPNpR+Hr8OIOSy0hgYFaRrCofYSYnrVMBZkUu1/D3P9OT7NuIe5n7VnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DU0PR04MB9225.eurprd04.prod.outlook.com (2603:10a6:10:350::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Mon, 31 Oct
 2022 16:22:27 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 16:22:27 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 1/1] net: fec: add initial XDP support
Date:   Mon, 31 Oct 2022 11:22:00 -0500
Message-Id: <20221031162200.1997788-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0191.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::16) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DU0PR04MB9225:EE_
X-MS-Office365-Filtering-Correlation-Id: b5322cd2-0c19-4e6c-502f-08dabb5c19a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pwjyFx1oLhk5B4DgG/Ou8Uz32jfdy6j1w+w/+fuwPwKqLlYRZRNVY916M9b7V7TVTwdT1goCOq1TfcFMKFu+9nNZTOGT8BzDKfOZv/dqwaKPOPH/687jW+xhrRIDhDm/Le5znJ9nbOzjsGUcdlCRH97Uqso36UPTwm4rruX0eXj6oX613MpD1ED8Ba4C5+kszSRchCywHxXpwLvj5pr4jkc2QJ9L0tt4wFteulgzKfBnef6gyvsFwXIlWSJhqAbbcG5PtVX1ajKLUl093Q7umNwhR8SvubgbkJhEiq9Lx93HUYQgB1z8kVC76i3i6OZkvnT95lZ97YgQoCCzVM2DYXZxBmtCgqST0fiwpFkNGWPepP9+s3i4fsKu8euT1PBXuTF4YDE9Z9cl8793M/VK7RIeRMNGBj5JqRYNlmjducEjW3lRju7dtPpsXPV5hZcrXqJRrmyDJcrqgkmX4LlgDNOgW1zTNsENMYMisU29hExDFH6qO49Mhe3qjM3bi2UBDZjNdn2uQBetK/v7pzbrGPpApxThcmTd3BKY47S19CZf3aFb44jkC9tk70LuBH1QDeyRsRb8vH6vwiam6e/5FJ+Gk7K66/KhBTLWg/VJ59kmqdLXxjy5FDVLWqiZEC0Hi730fz/y0rzSTBaC+0QTQHQJoGAJNb2pF22yynhj/EokHtzpo583XZdwnXtC5aDEZRAXLym5SrMinviyI6aKrJFh9NgHP69hR8c+Sl6qKmVvQVsB3eb49ezJtLsZ/DbT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199015)(66946007)(7416002)(1076003)(5660300002)(2616005)(86362001)(38100700002)(38350700002)(36756003)(478600001)(2906002)(316002)(6486002)(30864003)(44832011)(4326008)(66556008)(66476007)(83380400001)(186003)(26005)(6512007)(52116002)(6506007)(54906003)(6666004)(110136005)(8676002)(8936002)(55236004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?USH1uLU1ikK3zYeXncxUXcD6C4Cgm4NiHZFewKl0Qp3chqMqiaUm64vaB+ZU?=
 =?us-ascii?Q?op+TPv/yMdWUTGU7Q137NMa8i1e3UapLYyiBVky26PvOdZhGDpNfBQebqOiI?=
 =?us-ascii?Q?069c5MXhd3VjXzB+yKxWIbwlR/kIeh5cvAqvDZcVZJkICs6FNYUlLR7Ru7px?=
 =?us-ascii?Q?cE1AesMB3JVZ/UxHMpox4GKyd0k+d/6dU5bisqRm7Wg8Q3lQxR3+JcRQo8Oa?=
 =?us-ascii?Q?1su/EYEPHw6K0xVzh9jckc/T8P7zmnMksqyEspfB7016I2tbcTll1UlCP+7p?=
 =?us-ascii?Q?inV4JWPuUsRgUuoO9iDFZchO1zqU16NP1gYsnjZwqhZEdIWUIpOz5LFV4+c+?=
 =?us-ascii?Q?tkg7P7yznLyFGhg7XpAefC/+hKlkESLcdoosNsfVB43O0G9khHyyoe2BBfAP?=
 =?us-ascii?Q?f3sIqQ+cHGvL3wOG/JYnq9Zbk2mWbGNfjgyizDTEWcdYGzv9IkDznw35PaiR?=
 =?us-ascii?Q?qXkL5gzUBrzXBqhWtqK0/MBHHqTSMKnHxCTkNlZZopmYLiTQDb2m8oZgSIWh?=
 =?us-ascii?Q?ZF2QAn7Pm4witKaFzJnQo6xeRvjk9m38ZlsOEXtJ2DvdJOf3hIwyQKJhVpwJ?=
 =?us-ascii?Q?/nazdqecEgEgPgoCvg5ITerFFTSz6mAofVjAHixSP13GWJcQDOiCIExbK1ra?=
 =?us-ascii?Q?b4aNL4EcinkE2n0aRJGtexosjNILxJSK4q6qyNC8H8wnZ392M2V5jroeC6Nd?=
 =?us-ascii?Q?+h/J5Hoo6xzkB2GqpqX+bIZA7TtjAhvL9WxHc9MR7SXn4yUTzkoqmn0SJSEN?=
 =?us-ascii?Q?KDh+7OHNVUpgGlE4OZOe8frzwwooyv3eKT5gVuJPqGHL5Hn9V0H8LZfPExH4?=
 =?us-ascii?Q?I9Yio6s7T72EuiXhmg0Ojc4Wzye+TwkIts8C0SVIQgzil08s0BO5lr4GSteq?=
 =?us-ascii?Q?JQDT4039gZnooQtJiriZt3BmjMfWyd2L3fGNNDeWdq/rp5AO6D/olBtUt2ab?=
 =?us-ascii?Q?9ldAm5qJFQBFGJ7MvFGTnip+EetTAwKVDrJUszLHPHPeI0He8beD3EBPBX7i?=
 =?us-ascii?Q?2ey38E64Oa8A2euRcsT1TJaiXtyregPgvdl5c+WBAeXsZZxq2DvXUyJomTu5?=
 =?us-ascii?Q?Erf9cgvgaUvEwaSUV//6e9LsHM0D3lRhsWNSWf1xER9NKU0P/xwWsSVWck6q?=
 =?us-ascii?Q?PZSaciV2SJ5m+ILuR5yxQZaGhD4Yu4ws2n/F2ej809RJFfJa1Ho0ygP2KWWY?=
 =?us-ascii?Q?whtToYMsnUuIXMdLoxKjmvdNiDbdK0I8qL9SN5lWeUzApkJYx6P/zdvPF2S4?=
 =?us-ascii?Q?6J0oudyHrdF5ovVaCHicr/0DJVSw+GTpRswMWq4Ylhkh/IoLt5sMxbhN4Cdc?=
 =?us-ascii?Q?TEfEKlPC+FeADsHL4WbpFaOZnKHE5Lvvq95ZEDv+KEhpK9iPCnt7H4IqJ9nO?=
 =?us-ascii?Q?H1JjpP22hLoSjEISa8Kw5aPYWzIDzpS89L/Rqm1W+9swlaqZUxTvqztUZaP3?=
 =?us-ascii?Q?JqA8jjomW8EcTox9PQ2v1PzQrFlYiNtl/JhJeZRcrECoOkDkZEpOj+UBDF+/?=
 =?us-ascii?Q?QmInddUGA2S2adHeBjqL0wpk4QpFvsx9EUE+bPySCCHa7YjB6bwBBR3qFO+v?=
 =?us-ascii?Q?t5DpPnxaY3oPke8y7A6YBwJyb6hDeGTzLsINtLTs?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5322cd2-0c19-4e6c-502f-08dabb5c19a8
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 16:22:27.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5dwhlmfR820vW8CBp2gc347QE88/+gYXqev4cG9iEXLLVPfuztRsEIGGkzhvCNqXiBMVisrrNp0MoMFwnHKjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9225
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the initial XDP support to Freescale driver. It supports
XDP_PASS, XDP_DROP and XDP_REDIRECT actions. Upcoming patches will add
support for XDP_TX and Zero Copy features.

As the patch is rather large, the part of codes to collect the
statistics is separated and will prepare a dedicated patch for that
part.

The driver has a macro RX_RING_SIZE to configure the RX ring size. After
testing with the RX ring size, it turned out the small the rign size the
better the better performance for XDP mode. So the different ring size is
selected for XDP mode and normal mode in this patch.

I just tested with the application of xdpsock.
  -- Native here means running command of "xdpsock -i eth0"
  -- SKB-Mode means running command of "xdpsock -S -i eth0"

RX Ring Size       16       32        64       128
      Native      230K     227K      196K      160K
    SKB-Mode      207K     208K      203K      204K

Normal mode performance by iperf.

RX Ring Size         16         64       128
iperf              300Mbps    830Mbps   933Mbps

The following are the testing result relating to XDP mode:

root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
 sock0@eth0:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 384397         8048130
tx                 0              0

root@imx8qxpc0mek:~/bpf# ./xdpsock -S -i eth0
 sock0@eth0:0 rxdrop xdp-skb
                   pps            pkts           1.00
rx                 204151         204295
tx                 0              0

root@imx8qxpc0mek:~/bpf# ./xdp2 eth0
proto 0:     499359 pkt/s
proto 0:     508270 pkt/s
proto 0:     508160 pkt/s
proto 0:     508264 pkt/s

root@imx8qxpc0mek:~/bpf# ./xdp2 -S eth0
proto 0:          0 pkt/s
proto 17:     119155 pkt/s
proto 0:          1 pkt/s
proto 17:     119518 pkt/s
proto 17:     119363 pkt/s
proto 0:          0 pkt/s
proto 17:     119479 pkt/s
proto 17:     119484 pkt/s

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 changes in V2:
 - Get rid of the expensive fec_net_close/open function calls during
   XDP/Normal Mode switch.
 - Update the testing data on i.mx8qxp mek board.
 - fix the compile issue reported by kernel_test_robot

 drivers/net/ethernet/freescale/fec.h      |   4 +
 drivers/net/ethernet/freescale/fec_main.c | 245 +++++++++++++++++++++-
 2 files changed, 248 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 476e3863a310..07e85fc3d7ba 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -348,6 +348,7 @@ struct bufdesc_ex {
  */

 #define FEC_ENET_XDP_HEADROOM	(XDP_PACKET_HEADROOM)
+#define XDP_RX_RING_SIZE	16

 #define FEC_ENET_RX_PAGES	256
 #define FEC_ENET_RX_FRSIZE	(PAGE_SIZE - FEC_ENET_XDP_HEADROOM \
@@ -663,6 +664,9 @@ struct fec_enet_private {

 	struct imx_sc_ipc *ipc_handle;

+	/* XDP BPF Program */
+	struct bpf_prog *xdp_prog;
+
 	u64 ethtool_stats[];
 };

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6986b74fb8af..d05f0bb1a60c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -89,6 +89,11 @@ static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
 #define FEC_ENET_OPD_V	0xFFF0
 #define FEC_MDIO_PM_TIMEOUT  100 /* ms */

+#define FEC_ENET_XDP_PASS          0
+#define FEC_ENET_XDP_CONSUMED      BIT(0)
+#define FEC_ENET_XDP_TX            BIT(1)
+#define FEC_ENET_XDP_REDIR         BIT(2)
+
 struct fec_devinfo {
 	u32 quirks;
 };
@@ -418,13 +423,14 @@ static int
 fec_enet_create_page_pool(struct fec_enet_private *fep,
 			  struct fec_enet_priv_rx_q *rxq, int size)
 {
+	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
 	struct page_pool_params pp_params = {
 		.order = 0,
 		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
 		.pool_size = size,
 		.nid = dev_to_node(&fep->pdev->dev),
 		.dev = &fep->pdev->dev,
-		.dma_dir = DMA_FROM_DEVICE,
+		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
 		.offset = FEC_ENET_XDP_HEADROOM,
 		.max_len = FEC_ENET_RX_FRSIZE,
 	};
@@ -1499,6 +1505,59 @@ static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
 	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
 }

+static u32
+fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
+		 struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq, int index)
+{
+	unsigned int sync, len = xdp->data_end - xdp->data;
+	u32 ret = FEC_ENET_XDP_PASS;
+	struct page *page;
+	int err;
+	u32 act;
+
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
+	sync = xdp->data_end - xdp->data_hard_start - FEC_ENET_XDP_HEADROOM;
+	sync = max(sync, len);
+
+	switch (act) {
+	case XDP_PASS:
+		ret = FEC_ENET_XDP_PASS;
+		break;
+
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(fep->netdev, xdp, prog);
+		if (!err) {
+			ret = FEC_ENET_XDP_REDIR;
+		} else {
+			ret = FEC_ENET_XDP_CONSUMED;
+			page = virt_to_head_page(xdp->data);
+			page_pool_put_page(rxq->page_pool, page, sync, true);
+		}
+		break;
+
+	default:
+		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
+		fallthrough;
+
+	case XDP_TX:
+		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
+		fallthrough;
+
+	case XDP_ABORTED:
+		fallthrough;    /* handle aborts by dropping packet */
+
+	case XDP_DROP:
+		ret = FEC_ENET_XDP_CONSUMED;
+		page = virt_to_head_page(xdp->data);
+		page_pool_put_page(rxq->page_pool, page, sync, true);
+		break;
+	}
+
+	return ret;
+}
+
 /* During a receive, the bd_rx.cur points to the current incoming buffer.
  * When we update through the ring, if the next incoming buffer has
  * not been given to the system, we just set the empty indicator,
@@ -1520,6 +1579,9 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	u16	vlan_tag;
 	int	index = 0;
 	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
+	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
+	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
+	struct xdp_buff xdp;
 	struct page *page;

 #ifdef CONFIG_M532x
@@ -1531,6 +1593,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	 * These get messed up if we get called due to a busy condition.
 	 */
 	bdp = rxq->bd.cur;
+	xdp_init_buff(&xdp, PAGE_SIZE, &rxq->xdp_rxq);

 	while (!((status = fec16_to_cpu(bdp->cbd_sc)) & BD_ENET_RX_EMPTY)) {

@@ -1580,6 +1643,17 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		prefetch(page_address(page));
 		fec_enet_update_cbd(rxq, bdp, index);

+		if (xdp_prog) {
+			xdp_buff_clear_frags_flag(&xdp);
+			xdp_prepare_buff(&xdp, page_address(page),
+					 FEC_ENET_XDP_HEADROOM, pkt_len, false);
+
+			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
+			xdp_result |= ret;
+			if (ret != FEC_ENET_XDP_PASS)
+				goto rx_processing_done;
+		}
+
 		/* The packet length includes FCS, but we don't want to
 		 * include that when passing upstream as it messes up
 		 * bridging applications.
@@ -1675,6 +1749,10 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		writel(0, rxq->bd.reg_desc_active);
 	}
 	rxq->bd.cur = bdp;
+
+	if (xdp_result & FEC_ENET_XDP_REDIR)
+		xdp_do_flush_map();
+
 	return pkt_received;
 }

@@ -3476,6 +3554,169 @@ static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
 	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
 }

+static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
+{
+	struct fec_enet_private *fep = netdev_priv(dev);
+	bool is_run = netif_running(dev);
+	struct bpf_prog *old_prog;
+	unsigned int dsize;
+	int i;
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		if (is_run) {
+			napi_disable(&fep->napi);
+			netif_tx_disable(dev);
+		}
+
+		old_prog = xchg(&fep->xdp_prog, bpf->prog);
+
+		/* Update RX ring size */
+		dsize = fep->bufdesc_ex ? sizeof(struct bufdesc_ex) :
+			sizeof(struct bufdesc);
+		for (i = 0; i < fep->num_rx_queues; i++) {
+			struct fec_enet_priv_rx_q *rxq = fep->rx_queue[i];
+			struct bufdesc *cbd_base;
+			unsigned int size;
+
+			cbd_base = rxq->bd.base;
+			if (bpf->prog)
+				rxq->bd.ring_size = XDP_RX_RING_SIZE;
+			else
+				rxq->bd.ring_size = RX_RING_SIZE;
+			size = dsize * rxq->bd.ring_size;
+			cbd_base = (struct bufdesc *)(((void *)cbd_base) + size);
+			rxq->bd.last = (struct bufdesc *)(((void *)cbd_base) - dsize);
+		}
+
+		fec_restart(dev);
+
+		if (is_run) {
+			napi_enable(&fep->napi);
+			netif_tx_start_all_queues(dev);
+		}
+
+		if (old_prog)
+			bpf_prog_put(old_prog);
+
+		return 0;
+
+	case XDP_SETUP_XSK_POOL:
+		return -EOPNOTSUPP;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int
+fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int cpu)
+{
+	int index = cpu;
+
+	if (unlikely(index < 0))
+		index = 0;
+
+	while (index >= fep->num_tx_queues)
+		index -= fep->num_tx_queues;
+
+	return index;
+}
+
+static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
+				   struct fec_enet_priv_tx_q *txq,
+				   struct xdp_frame *frame)
+{
+	unsigned int index, status, estatus;
+	struct bufdesc *bdp, *last_bdp;
+	dma_addr_t dma_addr;
+	int entries_free;
+
+	entries_free = fec_enet_get_free_txdesc_num(txq);
+	if (entries_free < MAX_SKB_FRAGS + 1) {
+		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
+		return NETDEV_TX_OK;
+	}
+
+	/* Fill in a Tx ring entry */
+	bdp = txq->bd.cur;
+	last_bdp = bdp;
+	status = fec16_to_cpu(bdp->cbd_sc);
+	status &= ~BD_ENET_TX_STATS;
+
+	index = fec_enet_get_bd_index(bdp, &txq->bd);
+
+	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
+				  frame->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
+		return FEC_ENET_XDP_CONSUMED;
+
+	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
+	if (fep->bufdesc_ex)
+		estatus = BD_ENET_TX_INT;
+
+	bdp->cbd_bufaddr = cpu_to_fec32(dma_addr);
+	bdp->cbd_datlen = cpu_to_fec16(frame->len);
+
+	if (fep->bufdesc_ex) {
+		struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
+
+		if (fep->quirks & FEC_QUIRK_HAS_AVB)
+			estatus |= FEC_TX_BD_FTYPE(txq->bd.qid);
+
+		ebdp->cbd_bdu = 0;
+		ebdp->cbd_esc = cpu_to_fec32(estatus);
+	}
+
+	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
+	txq->tx_skbuff[index] = NULL;
+
+	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
+	 * it's the last BD of the frame, and to put the CRC on the end.
+	 */
+	status |= (BD_ENET_TX_READY | BD_ENET_TX_TC);
+	bdp->cbd_sc = cpu_to_fec16(status);
+
+	/* If this was the last BD in the ring, start at the beginning again. */
+	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
+
+	txq->bd.cur = bdp;
+
+	return 0;
+}
+
+static int fec_enet_xdp_xmit(struct net_device *dev,
+			     int num_frames,
+			     struct xdp_frame **frames,
+			     u32 flags)
+{
+	struct fec_enet_private *fep = netdev_priv(dev);
+	struct fec_enet_priv_tx_q *txq;
+	int cpu = smp_processor_id();
+	struct netdev_queue *nq;
+	unsigned int queue;
+	int i;
+
+	queue = fec_enet_xdp_get_tx_queue(fep, cpu);
+	txq = fep->tx_queue[queue];
+	nq = netdev_get_tx_queue(fep->netdev, queue);
+
+	__netif_tx_lock(nq, cpu);
+
+	for (i = 0; i < num_frames; i++)
+		fec_enet_txq_xmit_frame(fep, txq, frames[i]);
+
+	/* Make sure the update to bdp and tx_skbuff are performed. */
+	wmb();
+
+	/* Trigger transmission start */
+	writel(0, txq->bd.reg_desc_active);
+
+	__netif_tx_unlock(nq);
+
+	return num_frames;
+}
+
 static const struct net_device_ops fec_netdev_ops = {
 	.ndo_open		= fec_enet_open,
 	.ndo_stop		= fec_enet_close,
@@ -3490,6 +3731,8 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_poll_controller	= fec_poll_controller,
 #endif
 	.ndo_set_features	= fec_set_features,
+	.ndo_bpf		= fec_enet_bpf,
+	.ndo_xdp_xmit		= fec_enet_xdp_xmit,
 };

 static const unsigned short offset_des_active_rxq[] = {
--
2.34.1

