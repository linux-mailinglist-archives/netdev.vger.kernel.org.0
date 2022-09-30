Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82885F12CD
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiI3TiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiI3TiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:38:18 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89A5139BF6;
        Fri, 30 Sep 2022 12:38:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7ch11hlCUItG5wv1DbLI8yFYqQJxowTzo5YLjpuAyqstLgziFWECnzSWYLR9MjU6HihP/TsXmNeChluKtxethbiJr3jmm+s2q262aYtxGMLTrWQARvNzD0LINLp03TnL7EZ+jQGqIZDEOdy+FyoUH8DufY+byou84ShbNDvoqhEdiE53qM3U4KGD1dop4GVM8oYtxfnLAZq6qqsmgJr2TDLc6bxZQrbqigGqkku0pl8EdhNgCgY6NY5miFgB1caAVlf/OkgdNmFicAnW+I0DX1fHwMECev+bGxHMYqaQq6ms+dUFfdYDEHg5Ic1/QOGiuly3+eHTnQ5obuhqsKHAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frREI8N7nDaabQetHTk8L8o90ZlFHecJUW3bPYA/9Aw=;
 b=AJfV67zp7Bk2GhpcG8SmEzBW4QtMF1s10WR3Sdprc3V/+h4U63Sca/d+Dc3yVYBTcVJQx51Ci5dMixwAQR9dt3Hjrm8pMZJtm9es4bWTqJhNW25yT3lQH/d/zimClQRW97eZ6Nmjqyyx/mLUaMprVYG+oQQS5mh0OeVy36Law+y5vJKrAkLL/qNpDx16yu1oeqctHmPL+MpLLkde7gPSwH2dAAVizKMcXTOqXZmPe1QzT7pn1CM0NmTSgq9To4xV5wlS+Z2Ujc3KS1V4DqSrTBl9gq6vahh+luOZ3n+XFqM6JuyvJOYwZlCDQ04Hxl75eSgXlQoAbcY36H5a5OVrxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frREI8N7nDaabQetHTk8L8o90ZlFHecJUW3bPYA/9Aw=;
 b=iPedQZw27t33UI8CTEcjefeNQ+wAgmy9pL3ClEE+x7oJDqlZdVoiKS6+4/vjt3o2rdn2KjeAFTLDBlht6LjSCrwNtf0yCTFjGGHoDTtq93/9B9hApgb3jR+uApT88Xt5OzChMgHgb1rjAnFGQGzWbNGc3KVM7pnbRAhMSQcM51A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB9PR04MB8236.eurprd04.prod.outlook.com (2603:10a6:10:245::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 19:38:11 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 19:38:11 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 1/1] net: fec: using page pool to manage RX buffers
Date:   Fri, 30 Sep 2022 14:37:51 -0500
Message-Id: <20220930193751.1249054-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0063.namprd11.prod.outlook.com
 (2603:10b6:a03:80::40) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DB9PR04MB8236:EE_
X-MS-Office365-Filtering-Correlation-Id: b4ffa2fe-2e84-4ca5-ef52-08daa31b4ed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/FrxUk4H96m92U2EfU4NldBLCt4aFycI8VV3mBoABmVC/kI/DlVDcd46AOz9lLRlbwJm2v6m+ENkkuFCl1jkb6jVwZDSHcHzaY6UxxnQbibV90EQMrqavLSD9JSK9KiGyGCr6MKqRYMhrdzB5vGOg9F3DKVJ33Wn0ZN39rWIyTXq63CKbJR8KlGnBFE61M2ktOEeg35+LrJZwma/tbfm3IUdsS1CkTHn0xA4+DgBq6Ej5AIN/P2tlu1i0kjhW0p+SZaKOKhvy4LOc8Uin9GPiwrgEme5yUK+VYyvTQVJ3/sf4/TSAT7hAPzUgQjMgEh/7dxz/xyIA2yhehTH5/JlK4UinALh/Lg5E7eiqWA+K3fRo4fsEj2m+zUF8PjkSVRm6cRBlFmY0hlmanPHtXIS4dsp+DZdaL6H9aGnB8MEkXGxpyK+kGKB2yPGi4o1tAItzz82BupXXWZiIpoJnenV0ABoaxSHk9dWCOVnqxpsTRD4NX8l8whvu8Y26STtCULvnFN7LE1OoXhmj2vKQAF1vcija+BAZgXwHhBEKdZK44zPaInWEiUtGH+19237Q1TcOl4yqfI/P+PLnpZxEjqETh3Hhh8F3bXyCjOdkSuFlaimMohqazcB5z7J+kyQvOQBFB6m0XVy+BSFWwfElXWPFkzLfqwOgC4hf5FQKgelguypHJArCjpxkXccZI1OR4GddBaBKRSnx7pcxDinfVFl4gcoX64UAx50WMuozrc2mrF65C/uwGXuETpPy4XXE0UiOghixsqvQS6YUX2CO1b0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199015)(44832011)(5660300002)(7416002)(8936002)(30864003)(36756003)(2906002)(38100700002)(110136005)(54906003)(66556008)(66476007)(4326008)(41300700001)(8676002)(316002)(66946007)(2616005)(186003)(1076003)(6512007)(26005)(55236004)(38350700002)(6666004)(86362001)(52116002)(478600001)(6486002)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BGIrz0R2sEAGk3ivVlAXtoi+8H1V8/svnlJYDDN6GSLoLZCqEiAU4Z7QG+r9?=
 =?us-ascii?Q?/C+dxNy3lD8JO9vjPod79Q8cKpN02Vja0Q6KjD+QM4xxveGxXtOYV+vJp7yp?=
 =?us-ascii?Q?HUGKO/eEK1FVcNB7VPZHTpMmmPBVyBb4nASlYZXrRehX3w4/qxCuf+T7SjQh?=
 =?us-ascii?Q?slcHD5EloM+6bGLmCHDNc8GQmy0/U6fZU3WyPFC3VYB+SSbg5P5pXPcdIbDO?=
 =?us-ascii?Q?P6fhYVZoHT38N+WJjNcB8AuOM0D+xTsRrgZO3id07j2qlNjbhKWFMwmoMKBy?=
 =?us-ascii?Q?5dVyi9d6d2Wn5IhsTP48qoRZbL1EZyntbRbZFGPMBa4XQvoPSOam1fHm47Rz?=
 =?us-ascii?Q?tYKzjFw6oPXILJKyi4qCqtqTkVIclHvzcctegyLVMmvzTs3BuFaFt6tqnU+C?=
 =?us-ascii?Q?C5oANwb20yWCf7Z8zwC0/uWKon23PXqwYoR7ui/QX/52q5jGXMhndwrF9aAn?=
 =?us-ascii?Q?dAG116GSNhsSXBBnFsjXlH7Yttef6u6lRCOWui0SHJqLFj49zCAAlPQVjMSk?=
 =?us-ascii?Q?XNswiWW8jerI4N53G+krCvkI66BgRs9qWfAP+JuZz9nrUTA+S+BBZ49s3tZs?=
 =?us-ascii?Q?plKpl1yKmwWGBq9SOfZQVGhvaiGlF8h16wqW0JRGpXO+nKo8G3JdQgAEEAQd?=
 =?us-ascii?Q?9rgDc90L6OfFpkJZkM/knMfk6ElD8pkUk86QiwsFetvZWEUUlw9HSSH8thHV?=
 =?us-ascii?Q?kvVIO7c9xGQxoFV0PYWynpU8DOAuNo8jh5WfYaNs2l4TesOVzSxHUE/S1tiM?=
 =?us-ascii?Q?eFGfQ06aVolvsa/+IsoB5nwvwkmhhOqjesj+XF1E1tTiR/AdNoHh0yXI8niT?=
 =?us-ascii?Q?gDXzDj0J9tAF4MiYrMBzrA8iFbffnp73ODEProcy3XtBDFFkKy4V5heOPHrq?=
 =?us-ascii?Q?95j8umqYz01HSdJXbDAKbrii0ajbaoBTy5yHSQC9lyDWlVrr5CH7oJZ4rfyK?=
 =?us-ascii?Q?sJ96vhgzczAxjRjqcHgdh5Bof6F8T6kJ6I29QXcx2ImH/xZIVWEh4l+2nZrE?=
 =?us-ascii?Q?SrSi9B/vAWHXXkir7jqmEjRhgokw8NCysWQsVw0aWs3kLOqp9RplNjFKOg12?=
 =?us-ascii?Q?kj7sXD2ie1cqI0Zgb8TuIV+sqRi1qIIX7NHT1deLLrHF77HDMfkM+18VvyT5?=
 =?us-ascii?Q?cTWBMmyqJk9bJcVwcOQVWxbbmysNwVtIr6LqPzMxMyDEbbQN72PHIT3Cqf2X?=
 =?us-ascii?Q?G3hgJpoFAEiKIRCJfu7mwhyl7C6SWKHYLwHJRsq+Nh1ia/lxLPsaXyZWmRmx?=
 =?us-ascii?Q?voGOuEZAeNLAJvGBj7rAGt8ZQdalCmN8PuQt7b+0468STSlw5GlFFoI/8Ckv?=
 =?us-ascii?Q?fTxjwQUGr9CkdPrvQ5EB4nYDn3gztWLbgrc07UV/jg9ApDXKWGidB4DBkxiv?=
 =?us-ascii?Q?dUbI0iH6hyxj/xsjpw6DiCKJQvPRg2NSWWjl1OwVHcZVOBYNWdkZdjqvWoZ1?=
 =?us-ascii?Q?4DRuFYLTTmueJ1FwP59M1yKXMcbkyw8v9K1b3NT2WOazHH7POG8aNYiGIESa?=
 =?us-ascii?Q?ArNZUI/kJHMB1EKep6rQd5H5v+8cPmEc0iehEz3zV5hTIE7PqOJMzhKLVqHr?=
 =?us-ascii?Q?KKSkdQDUTXZwq8KBxEXxtZKeStb1WcD6VifkmzSt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ffa2fe-2e84-4ca5-ef52-08daa31b4ed6
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 19:38:11.1780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XS/oOPjhNDPTHKe0BDUj9ISl3Y1X70rBHdGonZp1TNPM6k/a6W3FEprAU3E1J3bup9zMGSmNBlZj1D30XwQtdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8236
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch optimizes the RX buffer management by using the page
pool. The purpose for this change is to prepare for the following
XDP support. The current driver uses one frame per page for easy
management.

The following are the comparing result between page pool implementation
and the original implementation (non page pool).

 --- Page Pool implementation ----

shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 43204 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec   111 MBytes   933 Mbits/sec
[  1] 1.0000-2.0000 sec   111 MBytes   934 Mbits/sec
[  1] 2.0000-3.0000 sec   112 MBytes   935 Mbits/sec
[  1] 3.0000-4.0000 sec   111 MBytes   933 Mbits/sec
[  1] 4.0000-5.0000 sec   111 MBytes   934 Mbits/sec
[  1] 5.0000-6.0000 sec   111 MBytes   933 Mbits/sec
[  1] 6.0000-7.0000 sec   111 MBytes   931 Mbits/sec
[  1] 7.0000-8.0000 sec   112 MBytes   935 Mbits/sec
[  1] 8.0000-9.0000 sec   111 MBytes   933 Mbits/sec
[  1] 9.0000-10.0000 sec   112 MBytes   935 Mbits/sec
[  1] 0.0000-10.0077 sec  1.09 GBytes   933 Mbits/sec

 --- Non Page Pool implementation ----

shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 49154 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec   104 MBytes   868 Mbits/sec
[  1] 1.0000-2.0000 sec   105 MBytes   878 Mbits/sec
[  1] 2.0000-3.0000 sec   105 MBytes   881 Mbits/sec
[  1] 3.0000-4.0000 sec   105 MBytes   879 Mbits/sec
[  1] 4.0000-5.0000 sec   105 MBytes   878 Mbits/sec
[  1] 5.0000-6.0000 sec   105 MBytes   878 Mbits/sec
[  1] 6.0000-7.0000 sec   104 MBytes   875 Mbits/sec
[  1] 7.0000-8.0000 sec   104 MBytes   875 Mbits/sec
[  1] 8.0000-9.0000 sec   104 MBytes   873 Mbits/sec
[  1] 9.0000-10.0000 sec   104 MBytes   875 Mbits/sec
[  1] 0.0000-10.0073 sec  1.02 GBytes   875 Mbits/sec

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/Kconfig    |   1 +
 drivers/net/ethernet/freescale/fec.h      |  35 ++++-
 drivers/net/ethernet/freescale/fec_main.c | 155 ++++++++++++++--------
 3 files changed, 134 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index b7bf45cec29d..ce866ae3df03 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -28,6 +28,7 @@ config FEC
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select CRC32
 	select PHYLIB
+	select PAGE_POOL
 	imply NET_SELFTESTS
 	help
 	  Say Y here if you want to use the built-in 10/100 Fast ethernet
diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index b0100fe3c9e4..7be56cc1ddb4 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -17,6 +17,7 @@
 #include <linux/clocksource.h>
 #include <linux/net_tstamp.h>
 #include <linux/pm_qos.h>
+#include <linux/bpf.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <dt-bindings/firmware/imx/rsrc.h>
@@ -346,8 +347,11 @@ struct bufdesc_ex {
  * the skbuffer directly.
  */
 
+#define FEC_ENET_XDP_HEADROOM	(XDP_PACKET_HEADROOM)
+
 #define FEC_ENET_RX_PAGES	256
-#define FEC_ENET_RX_FRSIZE	2048
+#define FEC_ENET_RX_FRSIZE	(PAGE_SIZE - FEC_ENET_XDP_HEADROOM \
+		- SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 #define FEC_ENET_RX_FRPPG	(PAGE_SIZE / FEC_ENET_RX_FRSIZE)
 #define RX_RING_SIZE		(FEC_ENET_RX_FRPPG * FEC_ENET_RX_PAGES)
 #define FEC_ENET_TX_FRSIZE	2048
@@ -517,6 +521,22 @@ struct bufdesc_prop {
 	unsigned char dsize_log2;
 };
 
+struct fec_enet_priv_txrx_info {
+	int	offset;
+	struct	page *page;
+	struct  sk_buff *skb;
+};
+
+struct fec_enet_xdp_stats {
+	u64	xdp_pass;
+	u64	xdp_drop;
+	u64	xdp_xmit;
+	u64	xdp_redirect;
+	u64	xdp_xmit_err;
+	u64	xdp_tx;
+	u64	xdp_tx_err;
+};
+
 struct fec_enet_priv_tx_q {
 	struct bufdesc_prop bd;
 	unsigned char *tx_bounce[TX_RING_SIZE];
@@ -532,7 +552,15 @@ struct fec_enet_priv_tx_q {
 
 struct fec_enet_priv_rx_q {
 	struct bufdesc_prop bd;
-	struct  sk_buff *rx_skbuff[RX_RING_SIZE];
+	struct  fec_enet_priv_txrx_info rx_skb_info[RX_RING_SIZE];
+
+	/* page_pool */
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
+	struct fec_enet_xdp_stats stats;
+
+	/* rx queue number, in the range 0-7 */
+	u8 id;
 };
 
 struct fec_stop_mode_gpr {
@@ -644,6 +672,9 @@ struct fec_enet_private {
 
 	struct imx_sc_ipc *ipc_handle;
 
+	/* XDP BPF Program */
+	struct bpf_prog *xdp_prog;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 59921218a8a4..643b4f6627ab 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -66,6 +66,8 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <soc/imx/cpuidle.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
 
 #include <asm/cacheflush.h>
 
@@ -422,6 +424,49 @@ fec_enet_clear_csum(struct sk_buff *skb, struct net_device *ndev)
 	return 0;
 }
 
+static int
+fec_enet_create_page_pool(struct fec_enet_private *fep,
+			  struct fec_enet_priv_rx_q *rxq, int size)
+{
+	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = size,
+		.nid = dev_to_node(&fep->pdev->dev),
+		.dev = &fep->pdev->dev,
+		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
+		.offset = FEC_ENET_XDP_HEADROOM,
+		.max_len = FEC_ENET_RX_FRSIZE,
+	};
+	int err;
+
+	rxq->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rxq->page_pool)) {
+		err = PTR_ERR(rxq->page_pool);
+		rxq->page_pool = NULL;
+		return err;
+	}
+
+	err = xdp_rxq_info_reg(&rxq->xdp_rxq, fep->netdev, rxq->id, 0);
+	if (err < 0)
+		goto err_free_pp;
+
+	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					 rxq->page_pool);
+	if (err)
+		goto err_unregister_rxq;
+
+	return 0;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(&rxq->xdp_rxq);
+err_free_pp:
+	page_pool_destroy(rxq->page_pool);
+	rxq->page_pool = NULL;
+	return err;
+}
+
 static struct bufdesc *
 fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 			     struct sk_buff *skb,
@@ -1450,7 +1495,7 @@ static void fec_enet_tx(struct net_device *ndev)
 		fec_enet_tx_queue(ndev, i);
 }
 
-static int
+static int __maybe_unused
 fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff *skb)
 {
 	struct  fec_enet_private *fep = netdev_priv(ndev);
@@ -1470,8 +1515,9 @@ fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff
 	return 0;
 }
 
-static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
-			       struct bufdesc *bdp, u32 length, bool swap)
+static bool __maybe_unused
+fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
+		   struct bufdesc *bdp, u32 length, bool swap)
 {
 	struct  fec_enet_private *fep = netdev_priv(ndev);
 	struct sk_buff *new_skb;
@@ -1496,6 +1542,21 @@ static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
 	return true;
 }
 
+static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
+				struct bufdesc *bdp, int index)
+{
+	struct page *new_page;
+	dma_addr_t phys_addr;
+
+	new_page = page_pool_dev_alloc_pages(rxq->page_pool);
+	WARN_ON(!new_page);
+	rxq->rx_skb_info[index].page = new_page;
+
+	rxq->rx_skb_info[index].offset = FEC_ENET_XDP_HEADROOM;
+	phys_addr = page_pool_get_dma_addr(new_page) + FEC_ENET_XDP_HEADROOM;
+	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
+}
+
 /* During a receive, the bd_rx.cur points to the current incoming buffer.
  * When we update through the ring, if the next incoming buffer has
  * not been given to the system, we just set the empty indicator,
@@ -1508,7 +1569,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	struct fec_enet_priv_rx_q *rxq;
 	struct bufdesc *bdp;
 	unsigned short status;
-	struct  sk_buff *skb_new = NULL;
 	struct  sk_buff *skb;
 	ushort	pkt_len;
 	__u8 *data;
@@ -1517,8 +1577,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	bool	vlan_packet_rcvd = false;
 	u16	vlan_tag;
 	int	index = 0;
-	bool	is_copybreak;
 	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
+	struct page *page;
 
 #ifdef CONFIG_M532x
 	flush_cache_all();
@@ -1570,31 +1630,25 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_bytes += pkt_len;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
-		skb = rxq->rx_skbuff[index];
+		page = rxq->rx_skb_info[index].page;
+		dma_sync_single_for_cpu(&fep->pdev->dev,
+					fec32_to_cpu(bdp->cbd_bufaddr),
+					pkt_len,
+					DMA_FROM_DEVICE);
+		prefetch(page_address(page));
+		fec_enet_update_cbd(rxq, bdp, index);
 
 		/* The packet length includes FCS, but we don't want to
 		 * include that when passing upstream as it messes up
 		 * bridging applications.
 		 */
-		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, pkt_len - 4,
-						  need_swap);
-		if (!is_copybreak) {
-			skb_new = netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE);
-			if (unlikely(!skb_new)) {
-				ndev->stats.rx_dropped++;
-				goto rx_processing_done;
-			}
-			dma_unmap_single(&fep->pdev->dev,
-					 fec32_to_cpu(bdp->cbd_bufaddr),
-					 FEC_ENET_RX_FRSIZE - fep->rx_align,
-					 DMA_FROM_DEVICE);
-		}
-
-		prefetch(skb->data - NET_IP_ALIGN);
+		skb = build_skb(page_address(page), PAGE_SIZE);
+		skb_reserve(skb, FEC_ENET_XDP_HEADROOM);
 		skb_put(skb, pkt_len - 4);
+		skb_mark_for_recycle(skb);
 		data = skb->data;
 
-		if (!is_copybreak && need_swap)
+		if (need_swap)
 			swap_buffer(data, pkt_len);
 
 #if !defined(CONFIG_M5272)
@@ -1649,16 +1703,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		skb_record_rx_queue(skb, queue_id);
 		napi_gro_receive(&fep->napi, skb);
 
-		if (is_copybreak) {
-			dma_sync_single_for_device(&fep->pdev->dev,
-						   fec32_to_cpu(bdp->cbd_bufaddr),
-						   FEC_ENET_RX_FRSIZE - fep->rx_align,
-						   DMA_FROM_DEVICE);
-		} else {
-			rxq->rx_skbuff[index] = skb_new;
-			fec_enet_new_rxbdp(ndev, bdp, skb_new);
-		}
-
 rx_processing_done:
 		/* Clear the status flags for this buffer */
 		status &= ~BD_ENET_RX_STATS;
@@ -3002,26 +3046,19 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	unsigned int i;
 	struct sk_buff *skb;
-	struct bufdesc	*bdp;
 	struct fec_enet_priv_tx_q *txq;
 	struct fec_enet_priv_rx_q *rxq;
 	unsigned int q;
 
 	for (q = 0; q < fep->num_rx_queues; q++) {
 		rxq = fep->rx_queue[q];
-		bdp = rxq->bd.base;
-		for (i = 0; i < rxq->bd.ring_size; i++) {
-			skb = rxq->rx_skbuff[i];
-			rxq->rx_skbuff[i] = NULL;
-			if (skb) {
-				dma_unmap_single(&fep->pdev->dev,
-						 fec32_to_cpu(bdp->cbd_bufaddr),
-						 FEC_ENET_RX_FRSIZE - fep->rx_align,
-						 DMA_FROM_DEVICE);
-				dev_kfree_skb(skb);
-			}
-			bdp = fec_enet_get_nextdesc(bdp, &rxq->bd);
-		}
+		for (i = 0; i < rxq->bd.ring_size; i++)
+			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);
+
+		if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
+			xdp_rxq_info_unreg(&rxq->xdp_rxq);
+		page_pool_destroy(rxq->page_pool);
+		rxq->page_pool = NULL;
 	}
 
 	for (q = 0; q < fep->num_tx_queues; q++) {
@@ -3111,24 +3148,32 @@ static int
 fec_enet_alloc_rxq_buffers(struct net_device *ndev, unsigned int queue)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	unsigned int i;
-	struct sk_buff *skb;
+	int i, err;
 	struct bufdesc	*bdp;
 	struct fec_enet_priv_rx_q *rxq;
 
+	dma_addr_t phys_addr;
+	struct page *page;
+
 	rxq = fep->rx_queue[queue];
 	bdp = rxq->bd.base;
+
+	err = fec_enet_create_page_pool(fep, rxq, rxq->bd.ring_size);
+	if (err < 0) {
+		netdev_err(ndev, "%s failed queue %d (%d)\n", __func__, queue, err);
+		return err;
+	}
+
 	for (i = 0; i < rxq->bd.ring_size; i++) {
-		skb = __netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE, GFP_KERNEL);
-		if (!skb)
+		page = page_pool_dev_alloc_pages(rxq->page_pool);
+		if (!page)
 			goto err_alloc;
 
-		if (fec_enet_new_rxbdp(ndev, bdp, skb)) {
-			dev_kfree_skb(skb);
-			goto err_alloc;
-		}
+		phys_addr = page_pool_get_dma_addr(page) + FEC_ENET_XDP_HEADROOM;
+		bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
 
-		rxq->rx_skbuff[i] = skb;
+		rxq->rx_skb_info[i].page = page;
+		rxq->rx_skb_info[i].offset = FEC_ENET_XDP_HEADROOM;
 		bdp->cbd_sc = cpu_to_fec16(BD_ENET_RX_EMPTY);
 
 		if (fep->bufdesc_ex) {
-- 
2.34.1

