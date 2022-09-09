Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABFD5B3684
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 13:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiIILiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 07:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiIILiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 07:38:16 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8452BB85E;
        Fri,  9 Sep 2022 04:38:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6bv/Fzd6flRKQRm07IM3wkU3EpsE1PUg3A7AtEjrgV7fZfeTpOLgKicUVQpvRFti7BhAzi/ItpjTgSXv0OGLg7bdiViDcX6c67BFP/Nu08cGg48NZwTROZsmzVHFYhPKyxavE82jNUPdq0saWsfxd2QOJ88KCX4un65DaOMRKzEVqKgIRXz7BRGbfNIRf3FSn5VeG4rbQLafQ8pDTseSjdxEAjYbfjvuYvfKRhJCzAqPwITMusVsRP01BsptgbUYWilvrfSSU8UVx8M9mezNHRmqdXxXQO4Dv54Q5JI5m+vNP5zo9QKrkSglvA0/4CMg/nVOAsgLQclvxa28uQDRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYPADy4MSWPSOTb28LEI785hWR7N6sS/n7BoTdXWthw=;
 b=gjTmFW9MK1he+jQON1IhPw/50r3iJWTZGp365dv+h9HHxjmbI8e2JKOs6VZgirInLZAFTDKgncgKzFBhx1xlaFATUkgBUoF35CzbBKT2YfYVsKOPUPnLMuhPCsregu+Cezp4AUERXEKoMDPe6QGnA+Asqfq3AIc3BR31d2bIhd/lQC68p+sXhu7LlvAMySqTbJO7Z2ETxLVeGna+zO04kBgj2JzsfShUuJrBORjy8GopvKN4Xw0EG8i7+Y7LdPdG44wi62V7XSp74lmDVOcaONmkKP+4dBrK0jNx0vGUm7sDvfDP8gMfwmzRZA3UMflswLWd/v+hFY+MkMFm4ZMnng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYPADy4MSWPSOTb28LEI785hWR7N6sS/n7BoTdXWthw=;
 b=Egq9CMfyMsCTGh0JUO3a5Tg2N8nX6/lR9KR48BiF+eN9dobQoSGoK551RCdWpl0pt0tnZdgSlLalpsWwX8g9CG3mok90Nlz65ThuV7PNSJZKOhjy0mEAMI8C9UAVOJO5MxaXZLY51XaDomeLh9Uzyx1n/2GUWPyNslIjl17cG5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6616.eurprd04.prod.outlook.com (2603:10a6:20b:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 11:38:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Fri, 9 Sep 2022
 11:38:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: enetc: parameterize port MAC stats to also cover the pMAC
Date:   Fri,  9 Sep 2022 14:37:59 +0300
Message-Id: <20220909113800.55225-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220909113800.55225-1-vladimir.oltean@nxp.com>
References: <20220909113800.55225-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0074.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1695855-62d9-4d14-499b-08da9257c5be
X-MS-TrafficTypeDiagnostic: AM6PR04MB6616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPhDttLJdFPXXLFKioNKECeVj8ooxQcwkMTIELv7phMLRp3AUnkqXwh8fStTuM2easFoj0/HXMei6yDMBRZri20CoEuuK5m63IGKyANZgiH1l0KVH+ZZODYBwixk6HJAsNGFBNE9vx7VE5oBQ+wip/xGT1jALNskBloQ92dpF2piT7bQVuseq4eIzPFRvGb5eOqrOm2Oxo+ggMKoAQSKx2qJk83CUuLT3q841gNdx331TvDXB0NiPG0ubMI3XLjfvYdycnvfVW3rE0nxMA7TCuRuUDv31CYNWfi0ho4+wO2Y4LipSceqMlGjWbahqvMimyprIvKII6Irq/UlRt27lAxiYUgzFppr8nj7SIyrDtD2x/I93LQdEv7hRyAHwe+sFZyN7RNz2ynqoPHz8A736ONcvjht0IjGl62AOO+hHQYCxr4+PPm8x+c8OqYZFu7nJqz+3/DudPyrfIHMlntPzUteoOIt36EhkMPsIimALsi9ILaz+P/Meq/8vmtSUPU+OgvFqKRd5QhVCQhu3prqYbqgJfeavTpGyocXAdW+6/FVOlM7FhQOhDarsNWMAqIaHtytefMPRe/pYLrBVGLTmN7dFLa4A7kevlSjUXIFnP6VD/kzI1M99IzU47AHP/rgXC7bBt/FxNjq8bNdAhjtnh3eILyDuw3GDrAMTVFUeb5QAErhMsz6QMnXkJ2W/yriBQXQtbHFJzGshhdlJTsy7XsMTSRyePkcTr51Hb+U1kPiofNFu1DCBfA5fe42MtU3TmKL1iPZNBBmBQ8+LBnJcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(316002)(2616005)(83380400001)(66556008)(66476007)(4326008)(478600001)(30864003)(36756003)(1076003)(186003)(44832011)(66946007)(2906002)(52116002)(6512007)(6486002)(5660300002)(6506007)(54906003)(8936002)(26005)(86362001)(6666004)(8676002)(41300700001)(6916009)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?83xzs4wy4xTm6uidJf7gr15VtKJvp2k+3K6+mrALDBGD3eD9a/uc1b2QM5Ca?=
 =?us-ascii?Q?XWTIFlPvnzIJMXY8NmF/JWWgDjLiAvll21cQNB9Zn1t2WGCalel42wUPuzFh?=
 =?us-ascii?Q?EWwdoJsf/Js1LMqVk231FpAZa+pb6EAfY1igezc+Zgt4zGjLMZbAZK/Hkp+y?=
 =?us-ascii?Q?hh2WA34sB8aqNjRVzYW0pTMTW1J80L/4k5O5uVJpOKBpREECpzJ9rtghzN5R?=
 =?us-ascii?Q?+pnw0ZYESeldD2PSz84VG6WfSf8Y8c3ff1z2cuijtTeUU7qXdK6gqqCkpl7l?=
 =?us-ascii?Q?Ss3kTXYnejctjp5CAgJMkMDLwHwJpuohHn2qz4H7hJiv+Y97TV4GNhv9xTbE?=
 =?us-ascii?Q?w0XEcxkTac+TJPoL7/lvYhS+wGV3APIr6FbRdGaPSb00HaASIIuxnVQnW0zq?=
 =?us-ascii?Q?7oZ/s5f/bFcGlgdR+9FFUWudXhnPwjy2tAbOqHpCNCgvtd7H8QL3jSYBSSjO?=
 =?us-ascii?Q?CcfSQRwz9BSdUD7p5nlLr9NGimXPKoBIBp+3bbrDgtU4AE5zY5DgLznGkcw4?=
 =?us-ascii?Q?tsJQWIdRtrFTLRLakhdHomy107S5yZLtXEc+13VM5xoJQJeSlqGQG88oS5Cg?=
 =?us-ascii?Q?MB8yh1ywqmRDOLRjotmnPBb3O45BexuNyzbK0QdMdAaa3wlwjjxSrLKJ7wgg?=
 =?us-ascii?Q?jgQGBuHDlmUUY1aRpFZXx4Zdp3fJTZ+rz1QC1mDgHCb+MG6w4npVxlq9Repb?=
 =?us-ascii?Q?8AN9l4B38iu0vo309R/dOT1CRWhQN/LEemFOp6bL4DC+ifQDwCdTkwxpSyqp?=
 =?us-ascii?Q?9u66aWcadhbho+5RNGfo28INL2YfIrV7S2aQiFhmyI4FWq7Uq/m/deVU3FVu?=
 =?us-ascii?Q?yWcqTk4Wx2kA/KdkIeH8oL3+0ov0YuBPdjl4FiSl7h0Oy2HJj4YWx/2ShzoV?=
 =?us-ascii?Q?p7+D6UrMy9yVSOV/PPI5I6bXFlRkqCkYPZ1+ZuGx1aJkXlslUvlL5Q3xPwVR?=
 =?us-ascii?Q?CaiGaw9fScnPz3wX+6ra9d5zJPIQXsVcFMYupAKG4rM+XscgSRDjacASTgOd?=
 =?us-ascii?Q?RO7lM8B2JhjQItU1L0s8P34oSbnkXCtX7bjLTfDyQPZhcARX62SReBXuYUcC?=
 =?us-ascii?Q?g/CEAMVqPMkGVDK8T6P9jMtX064/jqjaQ7nO1D3vb/B6Y719MKURaMJNZQp+?=
 =?us-ascii?Q?cbazTV3/4YnUV174nijtJ/S95IqJVGby+tEEJS6FAWF8GhIhfsaORN5y1Kzt?=
 =?us-ascii?Q?eBGHQsbddysVZnJrnGOOmqENGRxhC3wcP3et82tVc5ozodT/gObupxJ6xQbi?=
 =?us-ascii?Q?U5IItGe+an/ckVgMWyYPsgkpuU8et4lZeaDdZPvQBW5T/tqXEcLrKPhaLeCz?=
 =?us-ascii?Q?PQC7iW+ukwcpd3H6C8+xi+lQ3VsoK+ZqPa6GA/nbzQ7RS6+LBXD0pQo3saJh?=
 =?us-ascii?Q?CB7qD/8csHDbIv+XJ/lPQCSE+ItvkJFAERZly0Q74P5++F8gmOzzwCb6+Pwj?=
 =?us-ascii?Q?Gy4bc0LjYPwA2Ld2Bj/3fRLzo2zesDI4h71+MrVYyhVeaP3Z2S0k0c6eMw15?=
 =?us-ascii?Q?mb8042sTY1PawnTnrJRNg0HmF1pwA0nRyOJRJz0J/pVkU+acz6sPTGMl6bsc?=
 =?us-ascii?Q?LGFG0Y8xOObcl+I++NHQFN8aQsVgX+AOeY0FqNHQCHpGkmV4CxOxLtTlTs+c?=
 =?us-ascii?Q?lA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1695855-62d9-4d14-499b-08da9257c5be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 11:38:10.5457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OCHsl4pzLakwVZBQujWV0JyAs3bM1R1hnpllivGwZTXP9U1j80VIWiagp+oO9FGpvt2dNpefd09vFRGGo3XAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6616
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ENETC has counters for the eMAC and for the pMAC exactly 0x1000
apart from each other. The driver only contains definitions for PM0,
the eMAC.

Rather than duplicating everything for PM1, modify the register
definitions such that they take the MAC as argument.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 124 +++++++++---------
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 106 +++++++--------
 2 files changed, 116 insertions(+), 114 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index dec721e82938..b07139c97355 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -125,68 +125,68 @@ static const struct {
 	int reg;
 	char name[ETH_GSTRING_LEN];
 } enetc_port_counters[] = {
-	{ ENETC_PM0_REOCT,  "MAC rx ethernet octets" },
-	{ ENETC_PM0_RALN,   "MAC rx alignment errors" },
-	{ ENETC_PM0_RXPF,   "MAC rx valid pause frames" },
-	{ ENETC_PM0_RFRM,   "MAC rx valid frames" },
-	{ ENETC_PM0_RFCS,   "MAC rx fcs errors" },
-	{ ENETC_PM0_RVLAN,  "MAC rx VLAN frames" },
-	{ ENETC_PM0_RERR,   "MAC rx frame errors" },
-	{ ENETC_PM0_RUCA,   "MAC rx unicast frames" },
-	{ ENETC_PM0_RMCA,   "MAC rx multicast frames" },
-	{ ENETC_PM0_RBCA,   "MAC rx broadcast frames" },
-	{ ENETC_PM0_RDRP,   "MAC rx dropped packets" },
-	{ ENETC_PM0_RPKT,   "MAC rx packets" },
-	{ ENETC_PM0_RUND,   "MAC rx undersized packets" },
-	{ ENETC_PM0_R64,    "MAC rx 64 byte packets" },
-	{ ENETC_PM0_R127,   "MAC rx 65-127 byte packets" },
-	{ ENETC_PM0_R255,   "MAC rx 128-255 byte packets" },
-	{ ENETC_PM0_R511,   "MAC rx 256-511 byte packets" },
-	{ ENETC_PM0_R1023,  "MAC rx 512-1023 byte packets" },
-	{ ENETC_PM0_R1522,  "MAC rx 1024-1522 byte packets" },
-	{ ENETC_PM0_R1523X, "MAC rx 1523 to max-octet packets" },
-	{ ENETC_PM0_ROVR,   "MAC rx oversized packets" },
-	{ ENETC_PM0_RJBR,   "MAC rx jabber packets" },
-	{ ENETC_PM0_RFRG,   "MAC rx fragment packets" },
-	{ ENETC_PM0_RCNP,   "MAC rx control packets" },
-	{ ENETC_PM0_RDRNTP, "MAC rx fifo drop" },
-	{ ENETC_PM0_TEOCT,  "MAC tx ethernet octets" },
-	{ ENETC_PM0_TOCT,   "MAC tx octets" },
-	{ ENETC_PM0_TCRSE,  "MAC tx carrier sense errors" },
-	{ ENETC_PM0_TXPF,   "MAC tx valid pause frames" },
-	{ ENETC_PM0_TFRM,   "MAC tx frames" },
-	{ ENETC_PM0_TFCS,   "MAC tx fcs errors" },
-	{ ENETC_PM0_TVLAN,  "MAC tx VLAN frames" },
-	{ ENETC_PM0_TERR,   "MAC tx frame errors" },
-	{ ENETC_PM0_TUCA,   "MAC tx unicast frames" },
-	{ ENETC_PM0_TMCA,   "MAC tx multicast frames" },
-	{ ENETC_PM0_TBCA,   "MAC tx broadcast frames" },
-	{ ENETC_PM0_TPKT,   "MAC tx packets" },
-	{ ENETC_PM0_TUND,   "MAC tx undersized packets" },
-	{ ENETC_PM0_T64,    "MAC tx 64 byte packets" },
-	{ ENETC_PM0_T127,   "MAC tx 65-127 byte packets" },
-	{ ENETC_PM0_T255,   "MAC tx 128-255 byte packets" },
-	{ ENETC_PM0_T511,   "MAC tx 256-511 byte packets" },
-	{ ENETC_PM0_T1023,  "MAC tx 512-1023 byte packets" },
-	{ ENETC_PM0_T1522,  "MAC tx 1024-1522 byte packets" },
-	{ ENETC_PM0_T1523X, "MAC tx 1523 to max-octet packets" },
-	{ ENETC_PM0_TCNP,   "MAC tx control packets" },
-	{ ENETC_PM0_TDFR,   "MAC tx deferred packets" },
-	{ ENETC_PM0_TMCOL,  "MAC tx multiple collisions" },
-	{ ENETC_PM0_TSCOL,  "MAC tx single collisions" },
-	{ ENETC_PM0_TLCOL,  "MAC tx late collisions" },
-	{ ENETC_PM0_TECOL,  "MAC tx excessive collisions" },
-	{ ENETC_UFDMF,      "SI MAC nomatch u-cast discards" },
-	{ ENETC_MFDMF,      "SI MAC nomatch m-cast discards" },
-	{ ENETC_PBFDSIR,    "SI MAC nomatch b-cast discards" },
-	{ ENETC_PUFDVFR,    "SI VLAN nomatch u-cast discards" },
-	{ ENETC_PMFDVFR,    "SI VLAN nomatch m-cast discards" },
-	{ ENETC_PBFDVFR,    "SI VLAN nomatch b-cast discards" },
-	{ ENETC_PFDMSAPR,   "SI pruning discarded frames" },
-	{ ENETC_PICDR(0),   "ICM DR0 discarded frames" },
-	{ ENETC_PICDR(1),   "ICM DR1 discarded frames" },
-	{ ENETC_PICDR(2),   "ICM DR2 discarded frames" },
-	{ ENETC_PICDR(3),   "ICM DR3 discarded frames" },
+	{ ENETC_PM_REOCT(0),	"MAC rx ethernet octets" },
+	{ ENETC_PM_RALN(0),	"MAC rx alignment errors" },
+	{ ENETC_PM_RXPF(0),	"MAC rx valid pause frames" },
+	{ ENETC_PM_RFRM(0),	"MAC rx valid frames" },
+	{ ENETC_PM_RFCS(0),	"MAC rx fcs errors" },
+	{ ENETC_PM_RVLAN(0),	"MAC rx VLAN frames" },
+	{ ENETC_PM_RERR(0),	"MAC rx frame errors" },
+	{ ENETC_PM_RUCA(0),	"MAC rx unicast frames" },
+	{ ENETC_PM_RMCA(0),	"MAC rx multicast frames" },
+	{ ENETC_PM_RBCA(0),	"MAC rx broadcast frames" },
+	{ ENETC_PM_RDRP(0),	"MAC rx dropped packets" },
+	{ ENETC_PM_RPKT(0),	"MAC rx packets" },
+	{ ENETC_PM_RUND(0),	"MAC rx undersized packets" },
+	{ ENETC_PM_R64(0),	"MAC rx 64 byte packets" },
+	{ ENETC_PM_R127(0),	"MAC rx 65-127 byte packets" },
+	{ ENETC_PM_R255(0),	"MAC rx 128-255 byte packets" },
+	{ ENETC_PM_R511(0),	"MAC rx 256-511 byte packets" },
+	{ ENETC_PM_R1023(0),	"MAC rx 512-1023 byte packets" },
+	{ ENETC_PM_R1522(0),	"MAC rx 1024-1522 byte packets" },
+	{ ENETC_PM_R1523X(0),	"MAC rx 1523 to max-octet packets" },
+	{ ENETC_PM_ROVR(0),	"MAC rx oversized packets" },
+	{ ENETC_PM_RJBR(0),	"MAC rx jabber packets" },
+	{ ENETC_PM_RFRG(0),	"MAC rx fragment packets" },
+	{ ENETC_PM_RCNP(0),	"MAC rx control packets" },
+	{ ENETC_PM_RDRNTP(0),	"MAC rx fifo drop" },
+	{ ENETC_PM_TEOCT(0),	"MAC tx ethernet octets" },
+	{ ENETC_PM_TOCT(0),	"MAC tx octets" },
+	{ ENETC_PM_TCRSE(0),	"MAC tx carrier sense errors" },
+	{ ENETC_PM_TXPF(0),	"MAC tx valid pause frames" },
+	{ ENETC_PM_TFRM(0),	"MAC tx frames" },
+	{ ENETC_PM_TFCS(0),	"MAC tx fcs errors" },
+	{ ENETC_PM_TVLAN(0),	"MAC tx VLAN frames" },
+	{ ENETC_PM_TERR(0),	"MAC tx frame errors" },
+	{ ENETC_PM_TUCA(0),	"MAC tx unicast frames" },
+	{ ENETC_PM_TMCA(0),	"MAC tx multicast frames" },
+	{ ENETC_PM_TBCA(0),	"MAC tx broadcast frames" },
+	{ ENETC_PM_TPKT(0),	"MAC tx packets" },
+	{ ENETC_PM_TUND(0),	"MAC tx undersized packets" },
+	{ ENETC_PM_T64(0),	"MAC tx 64 byte packets" },
+	{ ENETC_PM_T127(0),	"MAC tx 65-127 byte packets" },
+	{ ENETC_PM_T255(0),	"MAC tx 128-255 byte packets" },
+	{ ENETC_PM_T511(0),	"MAC tx 256-511 byte packets" },
+	{ ENETC_PM_T1023(0),	"MAC tx 512-1023 byte packets" },
+	{ ENETC_PM_T1522(0),	"MAC tx 1024-1522 byte packets" },
+	{ ENETC_PM_T1523X(0),	"MAC tx 1523 to max-octet packets" },
+	{ ENETC_PM_TCNP(0),	"MAC tx control packets" },
+	{ ENETC_PM_TDFR(0),	"MAC tx deferred packets" },
+	{ ENETC_PM_TMCOL(0),	"MAC tx multiple collisions" },
+	{ ENETC_PM_TSCOL(0),	"MAC tx single collisions" },
+	{ ENETC_PM_TLCOL(0),	"MAC tx late collisions" },
+	{ ENETC_PM_TECOL(0),	"MAC tx excessive collisions" },
+	{ ENETC_UFDMF,		"SI MAC nomatch u-cast discards" },
+	{ ENETC_MFDMF,		"SI MAC nomatch m-cast discards" },
+	{ ENETC_PBFDSIR,	"SI MAC nomatch b-cast discards" },
+	{ ENETC_PUFDVFR,	"SI VLAN nomatch u-cast discards" },
+	{ ENETC_PMFDVFR,	"SI VLAN nomatch m-cast discards" },
+	{ ENETC_PBFDVFR,	"SI VLAN nomatch b-cast discards" },
+	{ ENETC_PFDMSAPR,	"SI pruning discarded frames" },
+	{ ENETC_PICDR(0),	"ICM DR0 discarded frames" },
+	{ ENETC_PICDR(1),	"ICM DR1 discarded frames" },
+	{ ENETC_PICDR(2),	"ICM DR2 discarded frames" },
+	{ ENETC_PICDR(3),	"ICM DR3 discarded frames" },
 };
 
 static const char rx_ring_stats[][ETH_GSTRING_LEN] = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 647c87f73bf7..0b85e37a00eb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -276,58 +276,60 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PFMCAPR		0x1b38
 #define ENETC_PFMCAPR_MSK	GENMASK(15, 0)
 
-/* MAC counters */
-#define ENETC_PM0_REOCT		0x8100
-#define ENETC_PM0_RALN		0x8110
-#define ENETC_PM0_RXPF		0x8118
-#define ENETC_PM0_RFRM		0x8120
-#define ENETC_PM0_RFCS		0x8128
-#define ENETC_PM0_RVLAN		0x8130
-#define ENETC_PM0_RERR		0x8138
-#define ENETC_PM0_RUCA		0x8140
-#define ENETC_PM0_RMCA		0x8148
-#define ENETC_PM0_RBCA		0x8150
-#define ENETC_PM0_RDRP		0x8158
-#define ENETC_PM0_RPKT		0x8160
-#define ENETC_PM0_RUND		0x8168
-#define ENETC_PM0_R64		0x8170
-#define ENETC_PM0_R127		0x8178
-#define ENETC_PM0_R255		0x8180
-#define ENETC_PM0_R511		0x8188
-#define ENETC_PM0_R1023		0x8190
-#define ENETC_PM0_R1522		0x8198
-#define ENETC_PM0_R1523X	0x81A0
-#define ENETC_PM0_ROVR		0x81A8
-#define ENETC_PM0_RJBR		0x81B0
-#define ENETC_PM0_RFRG		0x81B8
-#define ENETC_PM0_RCNP		0x81C0
-#define ENETC_PM0_RDRNTP	0x81C8
-#define ENETC_PM0_TEOCT		0x8200
-#define ENETC_PM0_TOCT		0x8208
-#define ENETC_PM0_TCRSE		0x8210
-#define ENETC_PM0_TXPF		0x8218
-#define ENETC_PM0_TFRM		0x8220
-#define ENETC_PM0_TFCS		0x8228
-#define ENETC_PM0_TVLAN		0x8230
-#define ENETC_PM0_TERR		0x8238
-#define ENETC_PM0_TUCA		0x8240
-#define ENETC_PM0_TMCA		0x8248
-#define ENETC_PM0_TBCA		0x8250
-#define ENETC_PM0_TPKT		0x8260
-#define ENETC_PM0_TUND		0x8268
-#define ENETC_PM0_T64		0x8270
-#define ENETC_PM0_T127		0x8278
-#define ENETC_PM0_T255		0x8280
-#define ENETC_PM0_T511		0x8288
-#define ENETC_PM0_T1023		0x8290
-#define ENETC_PM0_T1522		0x8298
-#define ENETC_PM0_T1523X	0x82A0
-#define ENETC_PM0_TCNP		0x82C0
-#define ENETC_PM0_TDFR		0x82D0
-#define ENETC_PM0_TMCOL		0x82D8
-#define ENETC_PM0_TSCOL		0x82E0
-#define ENETC_PM0_TLCOL		0x82E8
-#define ENETC_PM0_TECOL		0x82F0
+/* Port MAC counters: Port MAC 0 corresponds to the eMAC and
+ * Port MAC 1 to the pMAC.
+ */
+#define ENETC_PM_REOCT(mac)	(0x8100 + 0x1000 * (mac))
+#define ENETC_PM_RALN(mac)	(0x8110 + 0x1000 * (mac))
+#define ENETC_PM_RXPF(mac)	(0x8118 + 0x1000 * (mac))
+#define ENETC_PM_RFRM(mac)	(0x8120 + 0x1000 * (mac))
+#define ENETC_PM_RFCS(mac)	(0x8128 + 0x1000 * (mac))
+#define ENETC_PM_RVLAN(mac)	(0x8130 + 0x1000 * (mac))
+#define ENETC_PM_RERR(mac)	(0x8138 + 0x1000 * (mac))
+#define ENETC_PM_RUCA(mac)	(0x8140 + 0x1000 * (mac))
+#define ENETC_PM_RMCA(mac)	(0x8148 + 0x1000 * (mac))
+#define ENETC_PM_RBCA(mac)	(0x8150 + 0x1000 * (mac))
+#define ENETC_PM_RDRP(mac)	(0x8158 + 0x1000 * (mac))
+#define ENETC_PM_RPKT(mac)	(0x8160 + 0x1000 * (mac))
+#define ENETC_PM_RUND(mac)	(0x8168 + 0x1000 * (mac))
+#define ENETC_PM_R64(mac)	(0x8170 + 0x1000 * (mac))
+#define ENETC_PM_R127(mac)	(0x8178 + 0x1000 * (mac))
+#define ENETC_PM_R255(mac)	(0x8180 + 0x1000 * (mac))
+#define ENETC_PM_R511(mac)	(0x8188 + 0x1000 * (mac))
+#define ENETC_PM_R1023(mac)	(0x8190 + 0x1000 * (mac))
+#define ENETC_PM_R1522(mac)	(0x8198 + 0x1000 * (mac))
+#define ENETC_PM_R1523X(mac)	(0x81A0 + 0x1000 * (mac))
+#define ENETC_PM_ROVR(mac)	(0x81A8 + 0x1000 * (mac))
+#define ENETC_PM_RJBR(mac)	(0x81B0 + 0x1000 * (mac))
+#define ENETC_PM_RFRG(mac)	(0x81B8 + 0x1000 * (mac))
+#define ENETC_PM_RCNP(mac)	(0x81C0 + 0x1000 * (mac))
+#define ENETC_PM_RDRNTP(mac)	(0x81C8 + 0x1000 * (mac))
+#define ENETC_PM_TEOCT(mac)	(0x8200 + 0x1000 * (mac))
+#define ENETC_PM_TOCT(mac)	(0x8208 + 0x1000 * (mac))
+#define ENETC_PM_TCRSE(mac)	(0x8210 + 0x1000 * (mac))
+#define ENETC_PM_TXPF(mac)	(0x8218 + 0x1000 * (mac))
+#define ENETC_PM_TFRM(mac)	(0x8220 + 0x1000 * (mac))
+#define ENETC_PM_TFCS(mac)	(0x8228 + 0x1000 * (mac))
+#define ENETC_PM_TVLAN(mac)	(0x8230 + 0x1000 * (mac))
+#define ENETC_PM_TERR(mac)	(0x8238 + 0x1000 * (mac))
+#define ENETC_PM_TUCA(mac)	(0x8240 + 0x1000 * (mac))
+#define ENETC_PM_TMCA(mac)	(0x8248 + 0x1000 * (mac))
+#define ENETC_PM_TBCA(mac)	(0x8250 + 0x1000 * (mac))
+#define ENETC_PM_TPKT(mac)	(0x8260 + 0x1000 * (mac))
+#define ENETC_PM_TUND(mac)	(0x8268 + 0x1000 * (mac))
+#define ENETC_PM_T64(mac)	(0x8270 + 0x1000 * (mac))
+#define ENETC_PM_T127(mac)	(0x8278 + 0x1000 * (mac))
+#define ENETC_PM_T255(mac)	(0x8280 + 0x1000 * (mac))
+#define ENETC_PM_T511(mac)	(0x8288 + 0x1000 * (mac))
+#define ENETC_PM_T1023(mac)	(0x8290 + 0x1000 * (mac))
+#define ENETC_PM_T1522(mac)	(0x8298 + 0x1000 * (mac))
+#define ENETC_PM_T1523X(mac)	(0x82A0 + 0x1000 * (mac))
+#define ENETC_PM_TCNP(mac)	(0x82C0 + 0x1000 * (mac))
+#define ENETC_PM_TDFR(mac)	(0x82D0 + 0x1000 * (mac))
+#define ENETC_PM_TMCOL(mac)	(0x82D8 + 0x1000 * (mac))
+#define ENETC_PM_TSCOL(mac)	(0x82E0 + 0x1000 * (mac))
+#define ENETC_PM_TLCOL(mac)	(0x82E8 + 0x1000 * (mac))
+#define ENETC_PM_TECOL(mac)	(0x82F0 + 0x1000 * (mac))
 
 /* Port counters */
 #define ENETC_PICDR(n)		(0x0700 + (n) * 8) /* n = [0..3] */
-- 
2.34.1

