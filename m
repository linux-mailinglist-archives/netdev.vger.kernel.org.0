Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7BA610036
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiJ0S3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiJ0S3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:29:43 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BD4C768;
        Thu, 27 Oct 2022 11:29:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyH7plKIQlf+GnxqjP4RfgWq81C4DjwgJt9JLSQYUzfBUM9dvOSAyIyR6C2crJaaThvZhh+4BIoSQIhENBeE5ehTmi5/qYg64MmJNf1+eR9B1Y55ZAfU7gH9/O7DXSSI0V/Zxw5WV7eneEOo3bv/yau5yiIZg+no2VEKWuuWSsyHgFLxeLIocE6cuiMm5kabWxDgmVTY7H4XURx+g9ghZaDkmPNatwWNxh9v9y9LSA75FhX3VC8nhpScYV9epig251OT+XALZfgF6gIm+sMAYWOhf02GKldmnV8uF8AI9kyYTUgzopHWob/fP4rRseSQKEdBquIh0vvrIOGG5BRTbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihiGnBIueeJ9Sag9uUBaUdYr5cQlvQ/iTuIqUS/g/HU=;
 b=Ev+s0cTHcXFJ5oLxgh/Re+qS3G5RyukKyJG/rrLegyW2z/zPVVSfcDR6D6Ukl5nNN5irGJL8uKRP40zkOa7xRKpK4lWgAJWKCN/9WqKiEnJyN/P9rVUEDLr/DLkvKHCHE+RdHXshsJHDcjck2HHaSznDPSVg301Syd39bUZX5hPEzTcq70CeE9O86bTJyd4fw+ad21xpRr+eL0Un7g6L3VzD6FD2DIetGeh2tdjWNjzcVk26biN2WXwVoVXMkne8WBx9RDk/SGcmYDeJqrDtAQePIRR0Dlf6wuMcHNa5WCRmIrRZbZOzqYQ0C+VZXNLjMjN183GKzM7yBgCYY75eGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihiGnBIueeJ9Sag9uUBaUdYr5cQlvQ/iTuIqUS/g/HU=;
 b=nQQCxxHs9HvRw5WO+HHhaJlJteXOZjLJXY9iHGhjISJoI4HdRGR0CkvI8sxPqisMGRTwmA+ctd6SQuHCzw7AEa2VcwV8dOBfNRQELURRCawMJXd5r9ica9kpwGn4WK8uXflFf+KPCNpyDujrx+pC0Z64DmsvxhNgEqMgZBLpiiE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7345.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Thu, 27 Oct
 2022 18:29:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 18:29:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net] net: enetc: survive memory pressure without crashing
Date:   Thu, 27 Oct 2022 21:29:25 +0300
Message-Id: <20221027182925.3256653-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7345:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f7c9e97-beac-4af7-ae22-08dab8493448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UibTu9Zrf82GBZFuS1leOz0V1ChxuQ43qg+nXApvZXCoGu/L4h5mb4/nwMpShXktr0jQm4+JTAB5A2VjQ1QBYJyk1YcsK/MmxV7pmkyT3zzoaLPOkkmMctE/QPKAx5eiqm9Nmjsj757Vx5OsqCvFRMlOhfwSo78eLMQAfJwenJhayS5AJ0s2W0NLtgpn+Vjv+tqwZMS3ZxyH/MlRnoPsxRUyEpKE/OA9xZZQGSHvBn59Nfr3LGIxAdy55Rrc5mfzlmcUVnxYyRMkiqz8pjXz1Y2YrvwwQN0rjXiswepy3sv1Rd2I2CpdKUQxe3FmhMtvXmzuu/ealRGpQ+slu4k1ja+lxAPDjzl89eRGgTk4WsFlGgUT3LpMuBWxVzlmi+mewuHd0Nqbqlc2RrbH+RyiPvDT4TYvmSE41ALroLukzWxDdtWotQfeNxTzQtCMeiKfXDMAFd3cM4BAtJr9ufXij5eOvsCo5Sfgpb/zEmZzXLwh4gUPNQ2VLoSi2r4W2WeZo8jNlhCgHIQT8JORXrW7g7JiuGVSpUdBLYshhbKZ5fsQAvZsNzGuvgyUund0S5lM10JwNXOVPL/X6WDJORaxRJ+jwrcgOvDy3bsYyBzCwogSzoCqdYdibfPoRl5ogab9aqEXVmwlu3zLrmThRPYGLwlIV+PLitIUxdMi1G36VI6xu6KIZCBAl/44UfSvNyd3+A7C6/IZwrI+/SbR1h67sId7pFmhPyDhyTKMhwK1Yft7f4WnySTp2udeKJTZQ51RGaXvy4UN84nY/ITnwAL8c8TGB6lJsnEs5lJ82PuyB5osIR9U4mBKedd8wCjvEVGmTbNYPlkzaHPHgF8TUwgr4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(6506007)(6666004)(36756003)(52116002)(6916009)(4326008)(2906002)(66476007)(66556008)(66946007)(54906003)(316002)(8676002)(1076003)(83380400001)(2616005)(186003)(86362001)(26005)(6512007)(44832011)(5660300002)(41300700001)(8936002)(478600001)(6486002)(966005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b3br/43uhy1KMWtKY5R3XfN4AHS8t/jDkQaSwMHvJeLZh5fr7HbbABS0i6QJ?=
 =?us-ascii?Q?ZuahRHiv01b8HmPORlREbnFOoA6Re8vr68rJOe6eGY1Jx3K7zxvIev/ZW4Gu?=
 =?us-ascii?Q?/V/T3gRJo5eUtWw0U9y+5rkdMxBmChmYNO8YUJRngykhvHMk3sboiqI/IxoX?=
 =?us-ascii?Q?sQSOTPAmRGlKC7Z34baDKQfgkzeUFYT63gqd6WrxVmymR9HX5eAETZarZjHj?=
 =?us-ascii?Q?dQ5NisA0RzHwSzb3NfaEyvpBAsYOenFHOfgtYuMI9DZFrCM16n1o6ZKbstcL?=
 =?us-ascii?Q?UgCfUG15kVrRmnFARVHg7IarVR72cY3KOzogh3DivLk1jJ1grqwGi52bIpVS?=
 =?us-ascii?Q?vK3X1ErLLjxtJI/XfvyggfN5G4eLUoL6Fm506VSQ/lEfMF3XyiQZ7RVlpEpF?=
 =?us-ascii?Q?lF3bpqFGSJRWC6qouOlj7xHYbeQPNwXX3YaxlJSE0OqCTbc0lekttINdkR2T?=
 =?us-ascii?Q?l9w+NQo+02pyHuITmq4FQ5pwRZKpa0Jr4MNwktWgzW8o0cO3sJ1mR1XfG8p/?=
 =?us-ascii?Q?YOegSodOIwDtiC4gx/ltG13sGLgwQcfYUetiN2qHAGm9g/M7KOp1stxPMpKe?=
 =?us-ascii?Q?Jb1vfwT4KAWTQ2LGffenGnTDbFw6oczMAt72UssNEaHwaX22w0TXfEEfa3sO?=
 =?us-ascii?Q?O/aVhC3Wxp7tOElO0qldhJ9tFRXUwjDCLpVM6ammW64/ExiPgGgzs/WLKyLK?=
 =?us-ascii?Q?6536CO6nIlCkhGJxrK7v9HjwxBgNpiihd/7S97q2jplyjM6B/+oAPneUlTA+?=
 =?us-ascii?Q?FeCmT3scsmXvBWf4eT7Y5wcfdHeLQOrKbQKo8mLtXZmbQr9CctnVgfPBlwBF?=
 =?us-ascii?Q?g+F+6Gcs56kN4L05G/6J3zDzTyrsG9BFh9qkZG1039D0rwKwUM43fBiFtZ7v?=
 =?us-ascii?Q?XdQEmDXWvszVw0946y3tIBzM9x1w0cKl/Lgi745AY5c4CEzRzcd8+U6jYz+A?=
 =?us-ascii?Q?bnkIIIctPt6H7UPKQved95EPCNCsFvrVStP8ETJWpIF01FeiCaF972QXJW+B?=
 =?us-ascii?Q?ZhNVFoW1wjzMPtEgbeDLP8DIubbP94bkcG8lXxc1KF5a87eiGiZU4OZLcHc2?=
 =?us-ascii?Q?D3suhVoD9Zw51OZfxHmtQhYf4nksMq9agjCqq+W1bl4d3e5YeXxYeC51t41S?=
 =?us-ascii?Q?l3kukQp/CaZBnJueN76S/tOB54XrMXOqh1O0jDmUhPNIgJf/OaJ7j9SzBZjQ?=
 =?us-ascii?Q?4HwNroD6Q4VKrpoBq1mkaU1DsjGqN/oBm1l+YpC6C4XaNqf6xJ/2nTMvQmz0?=
 =?us-ascii?Q?yA1YF2x34ZtT0/7XdeZnqaGLm4512CqXfWQ07sUiweO3cxhZOwUDm8zT+agP?=
 =?us-ascii?Q?Lw1gIAXkjS0+vrJFyrt6awzMY5zBcCh0/IwgX4eAE7WVSpUfvCWNzZ02orh2?=
 =?us-ascii?Q?jIfNM7zD/G5PwD0eNfd+O6R32oHf8c4jv2YO2IJjGCyPNcVpIwpjNUdIRhzC?=
 =?us-ascii?Q?4OpTTo6JdpLAlWzjrnBJKO25xDcUYO1Tco1nkiXXEgwyGIsYyHaXlN7kzcI1?=
 =?us-ascii?Q?rrNWJQeFQ8rE/CrHNmLldIFQ6L6UV0H06ANIBoXD+DfuCoMcZYBYq2pOC5BS?=
 =?us-ascii?Q?HW3sCBs5jmhzts7AX7lxjEWASBhz28bLfMjuWus8NdH4moxlb3Yu4Q8bRVTC?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7c9e97-beac-4af7-ae22-08dab8493448
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 18:29:37.7835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZhlVNsSCI07GIz1lukTk3Bs2vqJNK9fr0uTbQApyoVUoYeWD4u6p/RokGgTalIsazIYWYEQsmRrmzbWO4Qye6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7345
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under memory pressure, enetc_refill_rx_ring() may fail, and when called
during the enetc_open() -> enetc_setup_rxbdr() procedure, this is not
checked for.

An extreme case of memory pressure will result in exactly zero buffers
being allocated for the RX ring, and in such a case it is expected that
hardware drops all RX packets due to lack of buffers.

This does not happen, because the reset-default value of the consumer
and produces index is 0, and this makes the ENETC think that all buffers
have been initialized and that it owns them (when in reality none were).

The hardware guide explains this best:

| Configure the receive ring producer index register RBaPIR with a value
| of 0. The producer index is initially configured by software but owned
| by hardware after the ring has been enabled. Hardware increments the
| index when a frame is received which may consume one or more BDs.
| Hardware is not allowed to increment the producer index to match the
| consumer index since it is used to indicate an empty condition. The ring
| can hold at most RBLENR[LENGTH]-1 received BDs.
|
| Configure the receive ring consumer index register RBaCIR. The
| consumer index is owned by software and updated during operation of the
| of the BD ring by software, to indicate that any receive data occupied
| in the BD has been processed and it has been prepared for new data.
| - If consumer index and producer index are initialized to the same
|   value, it indicates that all BDs in the ring have been prepared and
|   hardware owns all of the entries.
| - If consumer index is initialized to producer index plus N, it would
|   indicate N BDs have been prepared. Note that hardware cannot start if
|   only a single buffer is prepared due to the restrictions described in
|   (2).
| - Software may write consumer index to match producer index anytime
|   while the ring is operational to indicate all received BDs prior have
|   been processed and new BDs prepared for hardware.

Normally, the value of rx_ring->rcir (consumer index) is brought in sync
with the rx_ring->next_to_use software index, but this only happens if
page allocation ever succeeded.

When PI==CI==0, the hardware appears to receive frames and write them to
DMA address 0x0 (?!), then set the READY bit in the BD.

The enetc_clean_rx_ring() function (and its XDP derivative) is naturally
not prepared to handle such a condition. It will attempt to process
those frames using the rx_swbd structure associated with index i of the
RX ring, but that structure is not fully initialized (enetc_new_page()
does all of that). So what happens next is undefined behavior.

To operate using no buffer, we must initialize the CI to PI + 1, which
will block the hardware from advancing the CI any further, and drop
everything.

The issue was seen while adding support for zero-copy AF_XDP sockets,
where buffer memory comes from user space, which can even decide to
supply no buffers at all (example: "xdpsock --txonly"). However, the bug
is present also with the network stack code, even though it would take a
very determined person to trigger a page allocation failure at the
perfect time (a series of ifup/ifdown under memory pressure should
eventually reproduce it given enough retries).

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2->v3:
- Jakub points out that dma_alloc_coherent() returns zeroized memory, so
  v1 was completely wrong and v2 contained an unnecessary change. Remove
  the changes made to enetc_dma_alloc_bdr() and rewrite the commit
  message with this in mind.
v1->v2:
- also add an initial value for the RX ring consumer index, to be used
  when page allocation fails
- update the commit message
- deliberately not pick up Claudiu's review tag due to the above changes

v1 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20221024172049.4187400-1-vladimir.oltean@nxp.com/
v2 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20221026121330.2042989-1-vladimir.oltean@nxp.com/

 drivers/net/ethernet/freescale/enetc/enetc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 54bc92fc6bf0..f8c06c3f9464 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2090,7 +2090,12 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	else
 		enetc_rxbdr_wr(hw, idx, ENETC_RBBSR, ENETC_RXB_DMA_SIZE);
 
+	/* Also prepare the consumer index in case page allocation never
+	 * succeeds. In that case, hardware will never advance producer index
+	 * to match consumer index, and will drop all frames.
+	 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBPIR, 0);
+	enetc_rxbdr_wr(hw, idx, ENETC_RBCIR, 1);
 
 	/* enable Rx ints by setting pkt thr to 1 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBICR0, ENETC_RBICR0_ICEN | 0x1);
-- 
2.34.1

