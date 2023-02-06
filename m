Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878B568B983
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBFKJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjBFKJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:25 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADFD14227;
        Mon,  6 Feb 2023 02:09:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/oXj8fisPVvd9AmfoolXeoAPkhbkTHL6XbhiM+P6Li+O2BcCosv64qStLRxz+b0hUHjG9KtbZNxcnqGAst27u7UEKv6jFzJbaVwmwsG1NjRfZ9fOTrCE6yi8VqLzrZlsOpZg8+gslQj7sM2W/+zAmeMBp7XrxZjtVR211eozakmkkHuWht2LIlqmxQwzpC2RYIbtzwnETI163ISZSfxj4b/Wg7HbXuLrWjLO9kCxdnX7NVXvOAEvdR0f0xDvSfR/WQQJJjT69ExzgA4C/s/jADBV6DnDyEZqibZm5UkP7AErSNxZ2hXV6yrXzui9NOZ0NFgOSRbaAxfJkjLTBRHIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFheC66cT3tfPIpD57/N6f+31U8k5oUfW1jOh54W+R0=;
 b=Xc2Vqn+X3UeQs8Ok6uo/PtTdunFlqKagHy0H/3RHTQ+XMj4fPa/15nqg+jgDETgcDw3+DHS6z4YutV/ssPmZ8Fq+nPLxHs0KzMZrzozVCXFleaY6fzbsCG4uBWBzxUwzCwGD4PgUrAOaK2VLGxhwzdx/75a33mxuMxrlJIBdjUP2b/VR5ksHsIpPkaaZuzYbXAVjYI9r2UERq3aIKLmXngF2Pxol4QQ1ijOCFM/VwFcIOWi0z5n5p1BQDmUw3biRdCsHlYusMuCyLnKqGKzJ3szMFrnW66VIU71i+vl0wN/POc5jSQ57pMc/M821vh+97/lWpXL4cMBSGGd37vd1VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFheC66cT3tfPIpD57/N6f+31U8k5oUfW1jOh54W+R0=;
 b=KEcQK3SNJ1qCFPjF9vARD6Q4KGFQae5RcYd4nLaiJJ4EZFar8yBn3c77o0UUPBTC42ISn+4odqkFgF3j1oBUXy24y2LK0MmPhOkiYJJD6wXfYJk0EFoTKRZ41HVn5k11Ugt0S5tY5whBUdLvjOKcgaMJqZgfn5bPop2U5L9gxOQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7735.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:05 +0000
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
Subject: [RFC PATCH net-next 05/11] net: enetc: add support for ethtool --show-channels
Date:   Mon,  6 Feb 2023 12:08:31 +0200
Message-Id: <20230206100837.451300-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 78a4fc3c-c3fa-4791-2ec7-08db082a2de8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YXZ8JrJ+UTsmi7wi/m82BMAxRCQMpUtSNbxIxwMMYlqpjPEG22C7j9iBQTB+XgK6TlfbEuvla5GMUGM32xTO9NIm5ENVIbmHjRyOVqlx0QWOEPWTrGvPOfYUug5X4H30nodu87Yd1o63cGgXiobvfjzJZyfpV8fTxIXnjzqBYKzXhTiXY56fvmzjxZZ77tZMRiUW58i0GzMd3aqJhC1PMh7i0GxQO2UAqLCxhUjYqCXG7AJREwG8Uy/OlzUbIv9358O1o3frSS62XrVaoD1hg2KXCl4GrQISafyfpVTFXKngzRUCdEgQxw2QRkDmDioKZPNNu86uf39NxCdSg3A6lFcAxYkr7yEEY0RlMOB/bREx91mdJL4cYRD5WhmZixmL9h96q0cNHXCzpppWbgkuK1vVg0bEq1MwXY3183dObpIgoRYmpdP9G1E+UlGpOfKGSCRkun1uZF9uMy8pl775x9NiD8iy7SDWOhTLYf+26fv8jeRrgRkDzcf8sjwdkT+TB10jmFkteLHlX1ZZ+Mr2YP52/IQuAECyCAYT5wN0vCQYKqcTelwFzUoFX4NYvRamM3eCXU7BX12Lbpr/UH0QdwfGExWgF3RvEUu4uTAJemWEiZTd7ZC1YtHQ9EAT3Yf3feY2AHE7y5MQo+Oa8/srlUlW/9spQMQ7Mn+57NV0Z1WRnxLP0JgsF26nvb7H+DhxvU0lhqg9dxgq7SShTBGpyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(66946007)(66556008)(4326008)(6916009)(41300700001)(8936002)(8676002)(7416002)(5660300002)(54906003)(66476007)(2906002)(44832011)(2616005)(478600001)(6486002)(186003)(52116002)(6512007)(26005)(316002)(6506007)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cNiCUmU7MmedTCDinnwDM9bF4z8cPLEZwQzKINoa8QLpM+CfqdlNfIto6B2Y?=
 =?us-ascii?Q?fekbELM5R5sAzfrYUazUPOhP2OAXnatR+obWf8q3cSwFF71xlH6cjcwQP81X?=
 =?us-ascii?Q?8fcXS4UBVg75Py/oEXmod+KVvteP7PXW6cTePJA+ygPISxJ0yTFDTkdWpqsL?=
 =?us-ascii?Q?8BXWJYILqpNeZ/ElOSBV9UdIUeNKZdB6c7y8y2IV/i822GJz5vrFQ49NK9ce?=
 =?us-ascii?Q?Cw3PiIBO491rdhOMoEEv57U9bb9ksLEqLbnU35cyEJe5Ac9NZvgn3cYy+Z0m?=
 =?us-ascii?Q?hAXmAf03PidELrt80iypbbIw3zDfgoAoGfI9rhZPws1swUSGn+4GxakRwin5?=
 =?us-ascii?Q?C2JYqq4W5CpfdLqMpyZSPEtqSyg4cmDjfA4Y+k3jm4tD/xZSUxEebYokpZyP?=
 =?us-ascii?Q?rhcPgiAYgD7m23X/MXKE6OeiShqn3Oz0F+9ii3GqCneuJor7VN01ZPK+as+9?=
 =?us-ascii?Q?2hSeFg/KxyS5H31uP7qpk76t1e427dx12WzzN7E9XMVsMlZtff+n5g187Abr?=
 =?us-ascii?Q?I3DP3lHiW8BiaD3DRG85pcTeI2njmzkwZA6EIBqnW9bCGTodSiJeB9rK5tju?=
 =?us-ascii?Q?aSB2qNSsLofQoU9VRRqPGAF1oFwaYR5538oTo6DRAD1tjS60Z85XPeuEAEA6?=
 =?us-ascii?Q?Z/KAXku4Kr3OnEsmxybFA6ZbBmti7ilbFi0pbaljG/ZA6p3y4Qa1xbsaHlyl?=
 =?us-ascii?Q?qHb5chTXhD/hGyy+Ufkk/eTf1TonIqv6z1u/P6Pzwz1M8NqDibEKP4V0QP/b?=
 =?us-ascii?Q?ogl7pVTQCyBga+UeqJ5x98fvB6g/QqJYMCgz46TaaTZsKxmkKCjmKLnEOxQZ?=
 =?us-ascii?Q?Wt4ffdOFxKwXbTit7KzHvTq1AQ+Lr20BRa/2JrBZVYaxVVR/ei+3NMPwRuHT?=
 =?us-ascii?Q?16t+rngfiq2HJfai7+FviwpYrME9eF1nQO9z+Ekm/Hff5rtLfigVdYLwnRDY?=
 =?us-ascii?Q?AM6QXEVnmHBU6m9XHnvhompDfI3ROWETzabUbPFhvOZ8nWdyu9Rtwli0F4hz?=
 =?us-ascii?Q?J8fLcXz5bEzxOaY67NosAagomrN2ilqxNqgBpQawpSpQIDnVRypizd8vXL0i?=
 =?us-ascii?Q?nSMSqt29H9DASiXYJlAljuVKEHoK7Yi+iFpSmCoSk0yCMaf42a26Knby/UiK?=
 =?us-ascii?Q?AZPnZhycLAbmVT/9NJ9KI/G6xTYFPxPiAbxOGgoOhHD99JHkyKrqP/XbKx06?=
 =?us-ascii?Q?wokO3mta1XVJodu4gr43zKaDjWzsxd65RSCpb2gUIhipdLfAPvRHt+blvr14?=
 =?us-ascii?Q?KwRcw/hc8MoVHH2r/Ey/ICTyj/nvThNyiFv0HLCkb+bhkjcLPoc2Ck5JDqq1?=
 =?us-ascii?Q?pkKlRn5wBQ6ZiJ72w3GgBeTmELWyuwqqWEqQ8v2WcYNoCU8N2HJy1CssVktV?=
 =?us-ascii?Q?QnT59AGJTPxWUet44BXAg+qV1MPWx6g/138PCQWv9JJb5yAHXBrqnP/3xg0L?=
 =?us-ascii?Q?cipDR+LV2yyZSf7jd3IbktQrGCq8d3T5jM+JvLPtfyQROlfpxzwlsPB/x1bO?=
 =?us-ascii?Q?1W5MSgzkfEaQ5Henq3mR7p+HHRKkX0wFaP2n8o9VXD1rhaTEFrAEm/8MHrYL?=
 =?us-ascii?Q?S1xN2xdMOyXOr/u/Ardae6dFlgOISSUH9ib8pBXgqUsw19wjFDbf09ZkOBUw?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a4fc3c-c3fa-4791-2ec7-08db082a2de8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:05.6615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNDDBUXi0MHUHDr3mAY+NsIaaRZCBA9NiiImGyGR4zdqwVC0KNn7TnwnzeWThR4Jmp+EQ4F+gB9C3t6dgCDqJw==
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

In a strange twist of events, some libraries such as libbpf perform an
ETHTOOL_GCHANNELS ioctl to find out the max number of queues owned by a
device, number which in turn is used for attaching XDP sockets to
queues.

To add compatibility with libbpf, it is therefore desirable to report
something to this ethtool callback.

According to the ethtool man page, "A channel is an IRQ and the set of
queues that can trigger that IRQ".

In enetc (embedded in NXP LS1028A, a dual core SoC, and LS1018A, a
single core SoC), the enetc_alloc_msix() function allocates a number of
MSI-X interrupt vectors equal to priv->bdr_int_num (which in turn is
equal to the number of CPUs, 2 or 1). Each interrupt vector has 1 RX
ring to process (there are more than 2 RX rings available on an ENETC
port, but the driver only uses up to 2). In addition, the up to 8 TX
rings are distributed in a round-robing manner between the up to 2
available interrupt vectors.

Therefore, even if we have more resources than 2 RX rings, given the
definitions, we can only report 2 combined channels. So do that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 05e2bad609c6..dda02f8d102a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -863,6 +863,15 @@ static int enetc_set_link_ksettings(struct net_device *dev,
 	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
 }
 
+static void enetc_get_channels(struct net_device *ndev,
+			       struct ethtool_channels *chan)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+
+	chan->max_combined = priv->bdr_int_num;
+	chan->combined_count = priv->bdr_int_num;
+}
+
 static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -893,6 +902,7 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.set_wol = enetc_set_wol,
 	.get_pauseparam = enetc_get_pauseparam,
 	.set_pauseparam = enetc_set_pauseparam,
+	.get_channels = enetc_get_channels,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
-- 
2.34.1

