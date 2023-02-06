Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4028C68B977
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBFKJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjBFKJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:05 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2073.outbound.protection.outlook.com [40.107.21.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9934512F3A;
        Mon,  6 Feb 2023 02:09:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxlk0SK/bhL4ti4enT5dxjzfx97LnPmjhag6zpfC9LwwDjWkWGxkDqHtCUfMPagWjKoyOfOIUf7AEK88PlKG7uVXdMwdFP1c970sJWZp1luDX1y8SSa4l7JeB/cdMDvRJBOglSoceXH7IITurVGHQl0NtS/HCKRuhTxltyynTR7Oy889JJxEeU0avGnZF5g7Fff/8QbKy+KSN4V4Wm4GD5dni/hyQNFOhaDGmKHPfaAUUa1sHx/+RBdYWPke66wgFHBoco6UKfgt7Ux/ZSAXWBwRgmtDNLAZOcwFCWGRcbCKosImnvGFQ0P1XwEitP6jzzxqwUmr6hOpm3PXXVflYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIBCodmMkWlrfFU+8j+8jCaLQuzjatIWWGgYjkYhOQE=;
 b=GeVHvuB6OrzsGnhnRg/KPYoaxQP19sc5aU7ZR5UsaRRm0htjHsOhh5F/IYxX6tq24/5gD8QQtdNhSNnTZ2OitJC3ukmkVTW4ItteHx0ooEZcdgva3iu2+nF0y2//wyTVjypUio2byFGUdmEZFysw7lhFurSSG5U5lh3zyjqAeO9NIGnAuI8aXQh/jgjHsRNWqIGUl52Y7oMrTy1oT7+Kd3vvLzD0nBP/tYYiJlzqJoopX2A0xPskeBPui4dE9Ia8JvP4ko2UBVMdL7lbL0tTx/egggXcgc0v3AbpQl/HTdpQRnkFnsl3PyKYXRmWVsSDqijwKdOWmitj8sL/5WqG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIBCodmMkWlrfFU+8j+8jCaLQuzjatIWWGgYjkYhOQE=;
 b=dB0eVoDkxiCqQ6JPKeiaaOvR7MG2cJ5sqgwJ8pCTFk0Xb4YfuLn+PSmnK92zAtyK8Pg1wGvvBv2Vk4E2m79bYkDX+OvshxQDAx/hMHYNRqSyVJIdgPo48LJoAk/yCXUoCsiDFpB7tgUQuzz/TH7AuqYwn4u99RqoOKmhKX3QLrU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8421.eurprd04.prod.outlook.com (2603:10a6:20b:3ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:00 +0000
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
Subject: [RFC PATCH net-next 02/11] net: enetc: perform XDP RX queue registration at enetc_setup_bpf() time
Date:   Mon,  6 Feb 2023 12:08:28 +0200
Message-Id: <20230206100837.451300-3-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8421:EE_
X-MS-Office365-Filtering-Correlation-Id: db04e085-d975-441d-d74a-08db082a2ad7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HR4rvPUqxT/y/g365hkrPWz5EbP4aXvLGIG6ccmZmAO4D/BX/8ve9lWchIvxsXGRNoMP6ppEyPvegGyiLrFyQfz9PYFDW9PC7c8gEQ1y5nxA7SA3GRjDFyyPLQ63Bz2wYjFYFgG6uoF0drm/Y3V/nKMXTIhgdURESDOFnnQ5OEew+nQAiMQBU85KtZcU9ISxOPpunP1Ho83eSmtHmw0neivAxlivVZUDN6wTngvBDc6bQdBjQGOkAkTqLxb4ZiXuat64qogC7ZOO5CEldEY95F9Q8Q6PQLW+lDvTbBTtiptiNKtUXihQ488kG87oypXY0EfcJ7i6X7eq/81WVF4Ng6/yM3yS1kqZfE3Kkx6Kac1ZVd9vvSb5SOzaYRjYwIJsgIDdPNmgRhzAUYANRlLzc8/+B9mlHwve5H1LDiOVHUqItUBbuCvJZW8aqvmIrlCDiQpwNLcEFgvzFhF9ipgzX4UUio43tUwicG4/JmQZqnVLAxQn1lD3Z0AYIrQkBHwQ1TVM8OCPtbyik82sfwgGjhvhfKmJsT0pfSnEwD/dUjKaASMAWzpI3kHW7UIMER9jHYLcZgGtZ6fmcjezB6qKV5QOMtiZlHN8Ia+cHbvkfeEENWey6ToNaVFpl5frLrK4P5GEQ77oqG4FEEJh95x5hcUpd27YQFpapoHzbTAxJZaG1IglQ2cv7231bNrggyKetG+n2vjZmRgGWCWE0+Msig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199018)(86362001)(2906002)(36756003)(8676002)(66556008)(83380400001)(52116002)(1076003)(6512007)(6506007)(186003)(26005)(6666004)(2616005)(5660300002)(6486002)(8936002)(38100700002)(7416002)(38350700002)(41300700001)(478600001)(44832011)(54906003)(6916009)(66476007)(66946007)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UAoFRN3nhFf/J446qaYdIFh3ihsRGReIh8Yd90SXShV1X5mGdUD8D0UxVcli?=
 =?us-ascii?Q?nuAXG3/YBPBpcUza/07Zf03TmTLH6CRM7ZeZ3UyLm/eX3xceDQUrlJ95BIMz?=
 =?us-ascii?Q?2QXnW4Xq3fqlXeY78Vg7ccQ6/dvl9BOZpdWDR7gnZul1DiNwU6Etz4wdwEcF?=
 =?us-ascii?Q?G/SyGUGu4PX0d36X88F58zC7/UlYeaRGBEvN7bihEa0VLA+gMGw/apGpzYU4?=
 =?us-ascii?Q?xHBu98a6GnHJYl89kKxgh2JMXvrN/8nIUNJpQ0Z4p569jFGUKZBgj2RPMrU3?=
 =?us-ascii?Q?PVRY129nlLZ4KKFneRzvzMAnNOyjt+pcpatYxaJsG68L60J6r12KB4pnp4pl?=
 =?us-ascii?Q?p+Xp6jm0KmJ1cPYWP7yV0pN+YRmHbMMbBtx07Y+HF1kvfeIh4rrzsxqGnDP1?=
 =?us-ascii?Q?xVfR6VAOv3GZzUtgGx576HVBSPA5z2oki9d1yt7WaNaYLq9Pk3/1+zyuUJ5H?=
 =?us-ascii?Q?yB2Lfb6atZGbawOjWAicoTMLAG4Eoj1HqtC/xo5Gz7irqhEBQ+D3hxBUGfvi?=
 =?us-ascii?Q?cwnFo6pIUltFEGDaVueEy9dKFCJqvlTGEbsfAI06Fdro6QcXai4y9GIKcRiP?=
 =?us-ascii?Q?KsdT8ktcfPlgkouHehu86mwyHZNBqQ/wkhCrAkKLdpuWvf6Mv7KUMUeOYhHC?=
 =?us-ascii?Q?wOyKNkj0oNiNMQCVBT/8S1Uga5++n9298eQ2gUXG4mgjCYQREqu4zf8cVwhP?=
 =?us-ascii?Q?SfIm8aR/Zlc4HzxXnezurDyFpm2K7+a3sCM3NAdESZSvEnFleAsOCryuKVXa?=
 =?us-ascii?Q?eB3fP39Xhs9/NHqJjy36v2ZWDntd9/i+llESq87CnQQ7bCvNS66vAcR8p4hb?=
 =?us-ascii?Q?ievOCsr1XSyGvxVO/9BE6wZu0Z+MqbGBfNqHmt4ZL5dfcMrkl2gPznBeDZj4?=
 =?us-ascii?Q?9Y0lJxXYw23/T8NbMpYksqZHxOnkvGvDKtdK/v2k5I0NrCE1hytocFEldUZs?=
 =?us-ascii?Q?Wp8IFBkqQhrKq/RDOBPVL+qfktQWaggdOrKoP4CEq3GShP1EFaLynTzNvmwk?=
 =?us-ascii?Q?TNSdlKFwshvx99b2xIl+O7facLDDsDlZIjktO7nwEu06iWivaf5iZ+i9L5qd?=
 =?us-ascii?Q?aKXR54BrzDyCKse3UmfUuBu/DPzMa9pm5ZQubBvMkAwr8tyHwX+1b6boP/TY?=
 =?us-ascii?Q?hkq6oqAJiQNfYmIc16wGSY1vV4qEiN6l6Lhl3pwYTvC8w7QcK1ckl8Ry27k9?=
 =?us-ascii?Q?tXk3/u2udIgNhrnQRyAx1XD4pTB2lU9QhBHEMzVR6BLEjB595Ihcv9I/n7YC?=
 =?us-ascii?Q?CWqtUixUkYxKLCoyrUVyVskImsxWErVvuNXxlbioGUzuOTmh/QQFHco/P9uE?=
 =?us-ascii?Q?5x4AWtKu6zYLb/ghR9R1XIIDvTH4RBbKyX8/cfJVjMizutJ0DvZnGEl9a0dP?=
 =?us-ascii?Q?GmY2IeGTQySskI8uuDQOdgDQjbfBTiu400rOP25iSO9AUzYvRUQdgBxhM6hd?=
 =?us-ascii?Q?+QHId8/acf6TDAav8KdRIAc/wP4jWFztThMGdccif+RkGqwtz/oT3NHnM2ZJ?=
 =?us-ascii?Q?htd/WuqgoKYLmrCXCqx400U6EjUKK95ezi2hDuzSnbkkOwuGA1ElNajUXBzm?=
 =?us-ascii?Q?ar6dM6q6VSpb/gwS+uOmfOcXF9Ym79xam2ZmSpqi8Uw68IwUVhKhkFKkZhMf?=
 =?us-ascii?Q?lA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db04e085-d975-441d-d74a-08db082a2ad7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:00.5212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KY0By/5aCx5TEc02zL4fd0e3ArWSGuMfJKW/C4N19N+gPdhJ7gPDY++WLRWKUsWMoCw9Au8O20iuXBPqLt8erA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8421
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a future patch, the XDP RX queues will have to switch between
exposing a shared page memory model or an XSK pool memory model.

If we keep the RXQ registration where it currently is (enetc_pf_probe()
-> enetc_alloc_msix()), we'll end up needing to unregister the existing
RXQs and register new ones. But surprise, registering them can fail, and
that can leave us in the unpleasant situation that we can't recover from
two consecutive errors.

Taking a quick look at net/core/xdp.c, I see that this information seems
to only be used for xdp_buff :: rxq (and :: mem) and xdp_frame :: mem,
essentially between xdp_init_buff() and xdp_release_frame(). While these
2 might not be under the same NAPI poll cycle, the enetc_reconfigure()
procedure does make sure that any XDP buffers in flight are returned to
the respective memory "allocator" prior to calling
enetc_reconfigure_xdp_cb().

So it seems that the most logical way to place this is no earlier than
when it is needed, and unregister no later than when it stops being
needed. This also saves us from the impossible condition of two
consecutive registration failures, because now there isn't anything to
rollback on failure, we can just propagate the error to user space and
we're in the same state as before. I don't really understand why don't
more drivers do this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 89 +++++++++++++++-----
 1 file changed, 68 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 1c0aeaa13cde..2d8f79ddb78f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2450,6 +2450,59 @@ void enetc_start(struct net_device *ndev)
 }
 EXPORT_SYMBOL_GPL(enetc_start);
 
+static int enetc_xdp_rxq_mem_model_register(struct enetc_ndev_priv *priv,
+					    int rxq)
+{
+	struct enetc_bdr *rx_ring = priv->rx_ring[rxq];
+	int err;
+
+	err = xdp_rxq_info_reg(&rx_ring->xdp.rxq, priv->ndev, rxq, 0);
+	if (err)
+		return err;
+
+	err = xdp_rxq_info_reg_mem_model(&rx_ring->xdp.rxq,
+					 MEM_TYPE_PAGE_SHARED, NULL);
+	if (err)
+		xdp_rxq_info_unreg(&rx_ring->xdp.rxq);
+
+	return err;
+}
+
+static void enetc_xdp_rxq_mem_model_unregister(struct enetc_ndev_priv *priv,
+					       int rxq)
+{
+	struct enetc_bdr *rx_ring = priv->rx_ring[rxq];
+
+	xdp_rxq_info_unreg_mem_model(&rx_ring->xdp.rxq);
+	xdp_rxq_info_unreg(&rx_ring->xdp.rxq);
+}
+
+static int enetc_xdp_mem_model_register(struct enetc_ndev_priv *priv)
+{
+	int i, err;
+
+	for (i = 0; i < priv->num_rx_rings; i++) {
+		err = enetc_xdp_rxq_mem_model_register(priv, i);
+		if (err)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	for (; i >= 0; i--)
+		enetc_xdp_rxq_mem_model_unregister(priv, i);
+	return err;
+}
+
+static void enetc_xdp_mem_model_unregister(struct enetc_ndev_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_rx_rings; i++)
+		enetc_xdp_rxq_mem_model_unregister(priv, i);
+}
+
 int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -2675,13 +2728,19 @@ static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 	int num_stack_tx_queues;
 	int err, i;
 
+	if (prog) {
+		err = enetc_xdp_mem_model_register(priv);
+		if (err)
+			return err;
+	}
+
 	old_prog = xchg(&priv->xdp_prog, prog);
 
 	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
 	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
 	if (err) {
 		xchg(&priv->xdp_prog, old_prog);
-		return err;
+		goto err_xdp_mem_model_unreg;
 	}
 
 	if (old_prog)
@@ -2698,7 +2757,15 @@ static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 			rx_ring->buffer_offset = ENETC_RXB_PAD;
 	}
 
+	if (!prog)
+		enetc_xdp_mem_model_unregister(priv);
+
 	return 0;
+
+err_xdp_mem_model_unreg:
+	if (prog)
+		enetc_xdp_mem_model_unregister(priv);
+	return err;
 }
 
 static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
@@ -2954,20 +3021,6 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 		bdr->buffer_offset = ENETC_RXB_PAD;
 		priv->rx_ring[i] = bdr;
 
-		err = xdp_rxq_info_reg(&bdr->xdp.rxq, priv->ndev, i, 0);
-		if (err) {
-			kfree(v);
-			goto fail;
-		}
-
-		err = xdp_rxq_info_reg_mem_model(&bdr->xdp.rxq,
-						 MEM_TYPE_PAGE_SHARED, NULL);
-		if (err) {
-			xdp_rxq_info_unreg(&bdr->xdp.rxq);
-			kfree(v);
-			goto fail;
-		}
-
 		/* init defaults for adaptive IC */
 		if (priv->ic_mode & ENETC_IC_RX_ADAPTIVE) {
 			v->rx_ictt = 0x1;
@@ -3011,10 +3064,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 fail:
 	while (i--) {
 		struct enetc_int_vector *v = priv->int_vector[i];
-		struct enetc_bdr *rx_ring = &v->rx_ring;
 
-		xdp_rxq_info_unreg_mem_model(&rx_ring->xdp.rxq);
-		xdp_rxq_info_unreg(&rx_ring->xdp.rxq);
 		netif_napi_del(&v->napi);
 		cancel_work_sync(&v->rx_dim.work);
 		kfree(v);
@@ -3032,10 +3082,7 @@ void enetc_free_msix(struct enetc_ndev_priv *priv)
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		struct enetc_int_vector *v = priv->int_vector[i];
-		struct enetc_bdr *rx_ring = &v->rx_ring;
 
-		xdp_rxq_info_unreg_mem_model(&rx_ring->xdp.rxq);
-		xdp_rxq_info_unreg(&rx_ring->xdp.rxq);
 		netif_napi_del(&v->napi);
 		cancel_work_sync(&v->rx_dim.work);
 	}
-- 
2.34.1

