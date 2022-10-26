Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5F360E073
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiJZMNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiJZMNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:13:46 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B85F9A282;
        Wed, 26 Oct 2022 05:13:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ct+chf7XKGCi3fMHxMcvXvEVXX6m2kyPLrKGozf30djhhfvd3dpAAPVbu90mZ0LHt4QRJB/e+B0oRcb4WunNMQudZb03OiiJ+NUhRn2FgXunsUSQQK79KRZGRchDM8NPgclNTJweZTnM80t9y390xs8RSAotS0DIekG6GRMR7GnIUTrnPm3RdEVtpZkHr7RhkcVWa6zZZYV5WqObAD4/O2b9wRf2Nse0tKGdrQpRzpmUOfqpApWOFSdaHRXmTBHsad6D5nndPQJLFXtTqZtaHq4s0pWCSsO5Ko8OKfE5jZA+VHJT587GajpvukztoLaVCvPcRvelHTDQAu4h+pb+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCOQQStCCUlSL6cxBh9AvRyINUScTi3wc40RxfMBBV0=;
 b=NjcfCFXK7wKgBIr9sAbwzV5/ESbqVt1dLwRyEOxZuB2n81I5gMc0lITHKXRVCH9fGxTIvS2i03AK+ZtbMmrJE3bdVyfbH/JbaWh/+atlfBcCfuKAaIWyWcXIKxVHFE9CPkOGXgUKlMdwQT2Zc9QNPKqKCvCcu8ylfN6h7p3wVvbaVOsv5kJ1K1D3RMevpQFsByxV/d8mDPcJzabRprN8ueIiIWcWY19YmkFKr57U6SzgZdm9J+zCWfkyi89/Xv0zgQH1p1vSwoaqfplpgXPQuGc+X+blLz7qhAhY8CdEQQ7cI6mR6ZHg7nr91yMbWohR1pHL2Pj7NeMYa6tN29xa9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCOQQStCCUlSL6cxBh9AvRyINUScTi3wc40RxfMBBV0=;
 b=L33plVaEnvWlnDmGOXlJ3/Js/DMfVLoNA8M316H9j14CpdBTNs/L6ZaYcIe7dNgMlnsxi3aeohIufCA4ZPx2Pj2Z9RSo372tVfroNrosmjW3NvVWUwBAp2rc2Y4N/T9t4CCAJNz83550I1QRds20ThteK7ERW5CpVexr28WuFns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7109.eurprd04.prod.outlook.com (2603:10a6:20b:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 12:13:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 12:13:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] net: enetc: survive memory pressure without crashing
Date:   Wed, 26 Oct 2022 15:13:30 +0300
Message-Id: <20221026121330.2042989-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P193CA0024.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7109:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d9fc093-2155-416a-f67e-08dab74b8487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CIEmt0OxnCEXuoyYvQ3YOrh+G04CoAdViAGGrLRz/sWz9KGoUFRw/BeKG17SyJolu5lnTmaTxGhAwmlZTyNKYcQt0mNKEEqaQkBC7fPiTNyE8lBC5PboPl4AxxyvcMTnW9NXwNIfxp5VB7Idzle+yZbL9hPI52CBV+R6iikb/IHwDS3YykjSqmrpV4OKmDLg1SucXbYREOXFgWwPYgvJD4PX6TvEzkcF/XGS3XU1CubjiJ4IMDApQi3ck3tPim6uArywAC9mfn1n8ueb99xyJDI2cxl2O6Y1xFIBtoW6sGy9ZbTB4N37mLVRgAneAEngHBvnkeWGipP5KhKyqWJqSwT0mm6nEvq1zGpHt5FT9CaF7ludaucBngkFu2XZVqXSCKtfy+Tsj3Y48vCyRocNomq5o3x2s0PBlM37Jg8/d9w/GcRjg+/NXfVyh6WpBSeqkeXE8Gv5IpNMG1MpjxFuWitaiQrNF4D5veER1RFmCrH77IW1KWX505aYwMeX1O0RypAg7XLZaVV/tqMmgQ+q2kvJGbGPlPqVkwOWoLcChjU4cT8+hkIA9oEg/3+d3CXDxjNgia+RW1nqtJvSZV3bA4Pg7ZYCimY/ER1SBiP7k6SnhEm3fK9HmmDs6IMRHUYVLhVivaZt/LbIxa+8ARsXCaTDEyx3aIaOqcBk4sRVzSjPtIcaq4fbT8fRlfr5xed9qjkgKADqFQbGds78+JlofETG7O5Vvf0ABLIlomU3neaK7UX5exq4J1ZzmqZMtcTqrkX8OQnIOqI9pNP37joANGGqzjt6Owb6qeYIBQWrOCQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199015)(2616005)(1076003)(6666004)(52116002)(6506007)(186003)(6512007)(26005)(44832011)(8936002)(83380400001)(5660300002)(478600001)(54906003)(6916009)(66556008)(966005)(4326008)(41300700001)(8676002)(316002)(66946007)(6486002)(66476007)(86362001)(2906002)(36756003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yAHvRCeCXYP62XzwA5qhtgFjyBKmKMl0XbSFjrOG4MHfJih04KGiCRQqXL0e?=
 =?us-ascii?Q?f2DemmTF7z8jG5RoA/Y+PAsLXgW0OHFlrQiMa+iETjX8krBt+a5Fz98RAXPM?=
 =?us-ascii?Q?rHvKv7bvfNxVN+HFbOq71w2c+H83/b52gJr7GCSq+gbsDsoawdRElgHfVXaZ?=
 =?us-ascii?Q?qXCSez64uk+qCUwXaCrabW0FTGLkLr/c1fJY3+MPiZqr2mdlZpxLFNXNbyCE?=
 =?us-ascii?Q?n8JuOerV3YdzzMh/QGiTzu+DUEgRFRPPKwWQJNoJRFy5fxnJudSWpVAl0AHF?=
 =?us-ascii?Q?Bx19chvOhqQhrapAzvnz2eREXWYY4zaQq5I48d0VLwk52DovFzhYzff8VgC1?=
 =?us-ascii?Q?XL5GcCSViIlXhihWg9hfNRHkG6wTy0s4b2w08z6EQCizD+Pd8lSNtOMz0mTk?=
 =?us-ascii?Q?3W40BQgiqzxiGduH06UA+XEjPvmYuSMb/B3hlW/jG3PbDQx/dkGC1/flLO+/?=
 =?us-ascii?Q?NAFXjLSKmMR9MQQ+Tf5gPR6GXgQaNeHcU8GhA51Rlj61uIMSdcrtdFrQirpk?=
 =?us-ascii?Q?usFfApMpiXbdz6lyMWsJ2TXuO1eUfPNnJJab00Hii03uHJTEvyhFJgtMPZ7R?=
 =?us-ascii?Q?kLabtncZzqfTi/X8rUXbhLNKw4LH2Dr7BcMkf+lTGWja9DtMiVhYgxViLmGD?=
 =?us-ascii?Q?4/ZuxI4DG+SR/WT+qA9i3h7r+LNlnvTNbUHt+jftG2tOhrk30ZYYlDgY0xTp?=
 =?us-ascii?Q?wnXsOGENiXAkDTh/rJsYVmRzr8+XaB25doH8BJQHOwOV393hhfk2AlM32psq?=
 =?us-ascii?Q?t500+TnMlJN4LyfNasiygZ4hSrBUn4nO70rSV20fFHcDsJ49UJpbS2J9zqKb?=
 =?us-ascii?Q?ilbkY01r+COtlHWMG/L/FEngpc04FQoxw1m6MSLBOLxzac68n38vhiXLpgef?=
 =?us-ascii?Q?CgkTY418i8wB1SgGd4qqU5KCQtLFpPwC2+YQasx/+BAzdvGDR8NuUAoV11Yc?=
 =?us-ascii?Q?H6yLTjOTV/7GvG6Qv1FVKuBNvLfipIyeUK1gDYlw2FBHbKyLTx0J2WwChcav?=
 =?us-ascii?Q?8nFLaqPDA8a6g9+S4ddlY8Hk4Gze0JFBQsQUNAxwgViqiUgzn2UL+91Xt1gQ?=
 =?us-ascii?Q?Oa1tIp8tpCkAAguJsW8+tyMwVMq8+uG57oj0heOFxVQnc9HyGAY275UwGUTI?=
 =?us-ascii?Q?4GQDZk1aUQ9XH+K8ticCAo4YF8476e+K2BPg/UxTZA+Sb7xnDTqk3TkCt5bZ?=
 =?us-ascii?Q?geNUNtRzIxH2PsMH2iRbmGD1xpGSfEmjrGFRUwjRwvQ+OsfF7EQplZwtawuz?=
 =?us-ascii?Q?aXJUXNtxRet05jUMkUGhQkvzBpp7MOOarVpu0DiDDJKKp7xPlQIhBqS2Cnnp?=
 =?us-ascii?Q?wtk8NsfLLq2/hngUZieJgvLKYJYxbLLyyO2076lwiX8ZGV+ED7qIuq3BXOFD?=
 =?us-ascii?Q?CJ4wTd2whaFQpdSQikD4oiJV1tI0fvueVoTCVUyu6ijdLCNPVPbq+7ebNP4d?=
 =?us-ascii?Q?bqgt5jqooq3MS5k8PApp0QTmeqPX9f9DXsRlyuLc11zQpOvkxz5wz5fqTB+P?=
 =?us-ascii?Q?4Cr6uvBp+QOSKcaIAlkNwg2y3V1eefXmCOwyvCmSk9TzEtiACpfX7T2Pk+Lc?=
 =?us-ascii?Q?Wz1hGRL7xpUIurc13zKimOou7q+zI7Tdq6SDy/6/sFW9E2SW2lHaiDOEoiH3?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9fc093-2155-416a-f67e-08dab74b8487
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 12:13:40.2623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sKVC6NqcYROWYdZgDZvVQ9ZGHuYzAxUWivr8QnrGQWTVSvKhdRHZEEn3j4fAR/PvlGuORjjcYQQ6aEf4A4fhGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
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

There are 2 problems. One is that the hardware drop doesn't happen, the
other is that even if this is fixed, the driver has undefined behavior
and may even crash. Explanation for the latter follows below.

The enetc NAPI poll procedure is shared between RX and TX conf, and
enetc_poll() calls enetc_clean_rx_ring() even if the reason why NAPI was
scheduled is TX.

The enetc_clean_rx_ring() function (and its XDP derivative) is not
prepared to handle such a condition. It has this loop exit condition:

		rxbd = enetc_rxbd(rx_ring, i);
		bd_status = le32_to_cpu(rxbd->r.lstatus);
		if (!bd_status)
			break;

otherwise said, the NAPI poll procedure does not look at the Producer
Index of the RX ring, instead it just walks circularly through the
descriptors until it finds one which is not Ready.

The driver undefined behavior is caused by the fact that the
enetc_rxbd(rx_ring, i) RX descriptor is only initialized by
enetc_refill_rx_ring() if page allocation has succeeded.

If memory allocation ever failed, enetc_clean_rx_ring() looks at
rxbd->r.lstatus as an exit condition, but "rxbd" itself is uninitialized
memory. If it contains junk, then junk buffers will be processed.

To fix this problem, memset the DMA coherent area used for RX buffer
descriptors in enetc_dma_alloc_bdr(). This makes all BDs be "not ready"
by default, which makes enetc_clean_rx_ring() exit early from the BD
processing loop when there is no valid buffer available.

The other problem (hardware does not drop packet in lack of buffers)
is due to an initial misconfiguration of the RX ring consumer index,
misconfiguration which is usually masked away by the proper
configuration done by enetc_refill_rx_ring() - when page allocation does
not fail.

The hardware guide recommends BD rings to be configured as follows:

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

The reset-default value of the consumer index is 0, and this makes the
ENETC think that all buffers have been initialized (when in reality none
were).

To operate using no buffer, we must initialize the CI to PI + 1.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- also add an initial value for the RX ring consumer index, to be used
  when page allocation fails
- update the commit message
- deliberately not pick up Claudiu's review tag due to the above changes

v1 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20221024172049.4187400-1-vladimir.oltean@nxp.com/

 drivers/net/ethernet/freescale/enetc/enetc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 54bc92fc6bf0..a787114c9ede 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1738,18 +1738,21 @@ void enetc_get_si_caps(struct enetc_si *si)
 
 static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
 {
-	r->bd_base = dma_alloc_coherent(r->dev, r->bd_count * bd_size,
-					&r->bd_dma_base, GFP_KERNEL);
+	size_t size = r->bd_count * bd_size;
+
+	r->bd_base = dma_alloc_coherent(r->dev, size, &r->bd_dma_base,
+					GFP_KERNEL);
 	if (!r->bd_base)
 		return -ENOMEM;
 
 	/* h/w requires 128B alignment */
 	if (!IS_ALIGNED(r->bd_dma_base, 128)) {
-		dma_free_coherent(r->dev, r->bd_count * bd_size, r->bd_base,
-				  r->bd_dma_base);
+		dma_free_coherent(r->dev, size, r->bd_base, r->bd_dma_base);
 		return -EINVAL;
 	}
 
+	memset(r->bd_base, 0, size);
+
 	return 0;
 }
 
@@ -2090,7 +2093,12 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
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

