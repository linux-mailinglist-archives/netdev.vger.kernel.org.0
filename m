Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9FB68B9D9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjBFKTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjBFKTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:19:33 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593CA212BF;
        Mon,  6 Feb 2023 02:19:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mb51efgU1E+V9sRNJ2e0r4oFC7uUeCy/MgSce+VG0mbmJ/zMXO7RSIfhKothHbq9p3xvmFL282MSUOtCr9sN1mVgERHHrUNMXLd3wIEvg/7YQConYPIhHWxeHTOroG1RjinF3LIFVAEk4BlYHg87vouSCrcoPy07R/DgditOKqrMnxIEuKohRweqKxRyCaj18WRTGnUAUNLY5+CTMBymJjEnypUE9ejS3FA4zVPmcNOdEXvtFvYdVpLfrIzkwSTqwr1TdU2/XwutsuZqwd6s08/vGIWR+xRJvfqSH4ntu/8EStdhvfDD8AFsG4Rh7alWP02p4YN/hZKnwiB9NU/YXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvpShjthyy2G5aO6ydcW5PVm7JYb0YWgzuO4SWeMJjw=;
 b=gKCxt34v8Vwptgy16S3R9ysPOgymBlBqBfMBgeJnKiviYJ9UFvPLu8UJPyfkHhzPgpVz/LBGIpUsC+r7EOmXjhd+YcQ/qWDdg58kHMJhuzm4ld0CVaQqcZ2dxVeV09oNC8Exa8KjuHHXQ4kgw2DSU8qQ/JVZg9cET6AwbhCSW2gjtQ9tXerR8D2A9pitTnAANtADfXnmFnxaI3tIweQ5A1BopPW5F0x9pauQvSxoKjwiRn0A00iXy+bPc5/Xp1r9dCHlR7VkVQdRNdqs/lrZkLPTc2k0Ly8BfmuHsifQPN021SCngc65oordANrAEntzAbdg9DfcMSMALrXI+g4KOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvpShjthyy2G5aO6ydcW5PVm7JYb0YWgzuO4SWeMJjw=;
 b=bB1xSt3iAx3h79arTb1Ao4YCl+VIYdmiS34UCbBsEzvQvjnrbsSSvAD7W1J8GYzZHEyvEMPSDSVR31y5bhrABHnBONCviLmiY0vQ7P5oSsjO45/ggCcQiqfpRYlvahwX4rvHYYOuAk4SqeanZhWbtA0mVzLYGZxQfbuw36VepTs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB7009.eurprd04.prod.outlook.com (2603:10a6:208:19b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:19:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:19:25 +0000
Date:   Mon, 6 Feb 2023 12:19:21 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 11/11] net: enetc: add TX support for
 zero-copy XDP sockets
Message-ID: <20230206101921.zmslsxfzdm6ovxf5@skbuf>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
 <20230206100837.451300-12-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206100837.451300-12-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR02CA0172.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM0PR04MB7009:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb6d31f-8236-45f1-f162-08db082b9f79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtMzfp3/hwc5jyvYEcpRI+84DOZklIxGNx4J6LNLftpV7256/G8w2wKCMXJYI5iC5UySQfglisBmWJsHuMK887i2jit4MXLMRHuoC7oWuTLhZ8dHvIL4ELBKIL8lQVKnViqaCyBgvVDljOFg/yyGeObO/UknnQKPSYQodhT7O99eqTboIWkAucLSKj99Q6HQvC8svHf5bfKV0joAXEyirSA93xz6aOvlUBD24TaM689MeqZ479BwY6jvAVqVeGc+25rAM9py20XB5yPQQ5lRVODoD6pEPwofh3gJsydki4yOTdYjPign4kWOer3g07FW8vRxcjfX1YsLx7qgZy5T/UbdnhUhODsbVEhi1giHZDIYwDbos+nudY08BmYPxOdi0jOnmQhLRs0HWdfMKqsAIvu5MBBea/4pPI79XvkyJafCQYbR9fBLYjSBEH/8hXO5jZ8No1/wN/Hi9x7dmFpH48uoPE4bwipL6YryCDuJE+JZZxZHdhCFmdxvrpG3wnfZIxkPutJQAUzAeIJC6/bzGRgUPBGpiluyQdkJr88IClQnXCeRsO5IcS0DlcqPM9lLQbM86QLoNOGPlngceLzaLzxYKeRHahxfW08S0PDt3v9CFhpFLKjtut1hZVwfvp/8DAJZ8RzYLVoVmPNiF6ZB7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199018)(5660300002)(7416002)(44832011)(8936002)(41300700001)(83380400001)(2906002)(33716001)(66556008)(316002)(66476007)(66946007)(26005)(9686003)(8676002)(6512007)(186003)(4326008)(38100700002)(86362001)(54906003)(6916009)(478600001)(6486002)(53546011)(6506007)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nbQOg3ezHarT/1MDrh3yH+9Exw/llVbL53y/RPBxpregb/gNM5564cEMgUiL?=
 =?us-ascii?Q?0bdqAPBo2Mc67Ok7rwjyRGGoP4XiuiyMfuTFYF0EUysN24zveQuJ89VYVZKM?=
 =?us-ascii?Q?JTNgwfxOX3oX8rkISlQilHH0ZONUeMn2d5MLAfajbMi70yaQQbah96R3HHqF?=
 =?us-ascii?Q?ZJofwW4Jmi5rtJoJJ0fOJCCuM5R2OWyjad90QvjVgLgeHBJY/e+WXzG1FG2F?=
 =?us-ascii?Q?45Wcgnqr4xgO2ZTTOFR82XP//SZhVlWuIQwXs4N5lMlEcXw/2KEk3syxf5OQ?=
 =?us-ascii?Q?yWyYBrql/l+btj+2vkkKwolgKXq0+Ywgd4jwFbX3Hsn8BssknyBMRaqiDe9x?=
 =?us-ascii?Q?G3FawJHR4c+RiFMGwG7DPrlvk1CL9vjCTowR1CZyp79lyn99KhW3xQABdOXH?=
 =?us-ascii?Q?trwwhKzf04JugZBTI+6YGRx08Jc7zsD384NjnmbTCethyMJjco1xnrxJGMTP?=
 =?us-ascii?Q?D8jdQUF7akiWqp28sDCsjGLyR4uehsXdHdjCROGSFoKwLpMOhil8J29lS58+?=
 =?us-ascii?Q?QSBQ6h7lnDu0AMVcRqqZnFAwhilhl9YaIg7QmtA2BdFjF1wSS210lf+CxIZn?=
 =?us-ascii?Q?pQESKHhhOaChgKdE/ifV0ChcUKlySj2PeTE9hJl0h9il1bHYv/MZohvEKXRs?=
 =?us-ascii?Q?ztv7uaXSBSGqzgH6F8sICdj5BGfbt6JNxJ7LQK1aavmRV1JWULEIqz2uM2RE?=
 =?us-ascii?Q?SEVJwfac6kRt2U5h1VCrCexLkUNqDyTZH1lSeN+ZwxGGFkoSgmZziN1FD/GB?=
 =?us-ascii?Q?og2XDecJbtnhjD+vdnEohDqJg98lGaSZXWnx2dnH9GWQIh1XyMSFy5U588Yh?=
 =?us-ascii?Q?s/7nlbTh0QwogAVQqTpRSQ6oE+xd+kW4N/hnNHber06ElvrK88ABGk6lz8gc?=
 =?us-ascii?Q?5oM0bAkFnmduiAEQXDkq5WzTGr14rU+7m7DRAS+NTcHcM4QNBa7oOcvxndgS?=
 =?us-ascii?Q?FNeVQ5WGZuWI19dOFJQfGv9pKWi6ysz5AhqBwQxPX7YQFEiz4XBErPKuAoyP?=
 =?us-ascii?Q?tUkt9D8pc5EUWR7NsLUOAg28r71P8d0v+ui0kNJ0bkXbUjIMm51AyDkCGa7F?=
 =?us-ascii?Q?rVtQphp18oDYAlAVv6vUENHIm94paXsM/aD3mL5tva87NyWqU8IFe+7BaTxq?=
 =?us-ascii?Q?BXjcyLj+BlmtvTuG0nxllafRaexHWs5b3jDbORFOLiWV1BjsXuQKJL6Lg4HY?=
 =?us-ascii?Q?mgIwrx19so2o0a5PD/asqO0pE9DyGgUDifZxjG/AkFM5cS0CG0/zo1/0U00e?=
 =?us-ascii?Q?4uzUI1CWB8vsUoxTLWcfZhA7JE0POn9nUmZh6S1IYmg+elAcXab2X84J8eQY?=
 =?us-ascii?Q?NS9fDQVs6m6l9i8FUwLbeuV8JKf3T/8luz/AWcBmFYac5fDkXYPXNMgLW8Ry?=
 =?us-ascii?Q?+pCNJ3fvdmc64PHctH8gZpo/vYcbM6hU2hJl09i5L5+zyYsfzWWGZwdxovI7?=
 =?us-ascii?Q?qdjgq18PaZOA3WVIqf2FSZ25Bf2V44cOa07FxA29ncnVTOokMG0ZMtLcfsQ2?=
 =?us-ascii?Q?9r5QxaNz9mM0LAvRk1XtrHy2PN1wG3WPM8ktZCfEKUM/Nudo4dPBr5lPlZ/S?=
 =?us-ascii?Q?eECLchIozoG4ojZ/iTl2xu7siAgBqQcsVhfm9AYh9G2NQtBuIqp1RUePocRB?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb6d31f-8236-45f1-f162-08db082b9f79
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:19:25.7116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JNqlw0gxApqn27+CXlotvtXeImlQUGUbfeJSRXFvoRNyy983kO9CAC25OFE/Mm7KWSrHw3Uzupp8WEmt09DiZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7009
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yikes, ran git format-patch one patch too soon. There's also a hidden,
bonus patch "12/11" below. Doesn't affect first 11 patches in any way,
though. Here it is.

From f7f10232622309d66a7a1ae1932d0c081936d546 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 25 Oct 2022 02:32:24 +0300
Subject: [RFC PATCH net-next 12/12] net: enetc: add support for XDP_TX
 with zero-copy XDP sockets

Add support for the case when the BPF program attached to a ring with an
XSK pool returns the XDP_TX verdict. The frame needs to go back on the
interface it came from.

No dma_map or dma_sync_for_device is necessary, just a small impedance
matching logic with the XDP_TX procedure we have in place for non-XSK,
since the data structures are different (xdp_buff vs xdp_frame; cannot
have multi-buffer with XSK).

In the TX confirmation routine, just release the RX buffer (as opposed
to non-XSK XDP_TX). Recycling might be possible, but I haven't
experimented with it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 35 ++++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h |  1 +
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index bc0db788afc7..06aaf0334dc3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -855,7 +855,9 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget,
 				tx_win_drop++;
 		}
 
-		if (tx_swbd->is_xsk)
+		if (tx_swbd->is_xsk && tx_swbd->is_xdp_tx)
+			xsk_buff_free(tx_swbd->xsk_buff);
+		else if (tx_swbd->is_xsk)
 			(*xsk_confirmed)++;
 		else if (tx_swbd->is_xdp_tx)
 			enetc_recycle_xdp_tx_buff(tx_ring, tx_swbd);
@@ -1661,6 +1663,21 @@ static int enetc_rx_swbd_to_xdp_tx_swbd(struct enetc_tx_swbd *xdp_tx_arr,
 	return n;
 }
 
+static bool enetc_xsk_xdp_tx(struct enetc_bdr *tx_ring,
+			     struct xdp_buff *xsk_buff)
+{
+	struct enetc_tx_swbd tx_swbd = {
+		.dma = xsk_buff_xdp_get_dma(xsk_buff),
+		.len = xdp_get_buff_len(xsk_buff),
+		.is_xdp_tx = true,
+		.is_xsk = true,
+		.is_eof = true,
+		.xsk_buff = xsk_buff,
+	};
+
+	return enetc_xdp_tx(tx_ring, &tx_swbd, 1);
+}
+
 static void enetc_xdp_drop(struct enetc_bdr *rx_ring, int rx_ring_first,
 			   int rx_ring_last)
 {
@@ -1839,10 +1856,12 @@ static int enetc_clean_rx_ring_xsk(struct enetc_bdr *rx_ring,
 				   struct bpf_prog *prog,
 				   struct xsk_buff_pool *pool)
 {
+	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
+	struct enetc_bdr *tx_ring = priv->xdp_tx_ring[rx_ring->index];
+	int xdp_redirect_frm_cnt = 0, xdp_tx_frm_cnt = 0;
 	struct net_device *ndev = rx_ring->ndev;
 	union enetc_rx_bd *rxbd, *orig_rxbd;
 	int rx_frm_cnt = 0, rx_byte_cnt = 0;
-	int xdp_redirect_frm_cnt = 0;
 	struct xdp_buff *xsk_buff;
 	int buffs_missing, err, i;
 	bool wakeup_xsk = false;
@@ -1895,6 +1914,15 @@ static int enetc_clean_rx_ring_xsk(struct enetc_bdr *rx_ring,
 			enetc_xsk_buff_to_skb(xsk_buff, rx_ring, orig_rxbd,
 					      napi);
 			break;
+		case XDP_TX:
+			if (enetc_xsk_xdp_tx(tx_ring, xsk_buff)) {
+				xdp_tx_frm_cnt++;
+				tx_ring->stats.xdp_tx++;
+			} else {
+				xsk_buff_free(xsk_buff);
+				tx_ring->stats.xdp_tx_drops++;
+			}
+			break;
 		case XDP_REDIRECT:
 			err = xdp_do_redirect(ndev, xsk_buff, prog);
 			if (unlikely(err)) {
@@ -1919,6 +1947,9 @@ static int enetc_clean_rx_ring_xsk(struct enetc_bdr *rx_ring,
 	if (xdp_redirect_frm_cnt)
 		xdp_do_flush_map();
 
+	if (xdp_tx_frm_cnt)
+		enetc_update_tx_ring_tail(tx_ring);
+
 	if (xsk_uses_need_wakeup(pool)) {
 		if (wakeup_xsk)
 			xsk_set_rx_need_wakeup(pool);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 403f40473b52..58df6c32cfb3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -24,6 +24,7 @@ struct enetc_tx_swbd {
 	union {
 		struct sk_buff *skb;
 		struct xdp_frame *xdp_frame;
+		struct xdp_buff *xsk_buff;
 	};
 	dma_addr_t dma;
 	struct page *page;	/* valid only if is_xdp_tx */
-- 
2.34.1

