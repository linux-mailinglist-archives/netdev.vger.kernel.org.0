Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643D3596588
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbiHPW3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiHPW3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:29:42 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44717C515
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:29:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvEhvQMJ7EsKoazYSX6hU1VJigvHlyjh5LeNNdtOWqoXVTii5DNcmGl1cUyceKjHtYkkd4IZLuAKJKtRHEfntjQ4d/++5kXmuMq2Wh/TEpJX9rwH9+ADAIQMtOE6TkvOIrvEyUO/M5dkO/JRPn2GsqRMy2273KbiiOIlwjjJrcKSCHyGyXtV8Uvm8YflDdK+G4svFCXsPgeX2QY/It8PHUPNFf1rvYtea8/b2YD/wwNpMUXBB0cb/2wSd8TVxw6BWFa/ZUIHeiXUXxx/4SbqxutqP1OLh/QLj0MHcDtv5Xv+dgPIhNntNQL/6l4qeFRqB3GRloQboIIjEmV2FX8gaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uk0NpJyq3ItGTurYlEhtJo1o3qA8DRnS9wBUUcMzjy8=;
 b=Ahj2r3RAcn/R7GUhaB/8m+01nnuRbIRBTSDbVFL7fB37ern4P53J7giaf4a1NQ517Czn7gCno2X2AShFum4WQl4JxqwxrtM81X1yv/PWyghzo1rE1ex0FbrSFkluiaJfuI2l2dgGz/n6aPeDBVQTAHKs6i2zfsjw4nIkFzP0v6l4DkK4rsAFlVPioji4/UIKG5F04YhLAucUNVwj2KuB0UWg3z/3llYjLU9Pu7D7fsf3qvfD22YgwZyt7TsrROdcxrkjBunyWou9xFr3W4zc0ChbdHlfFKzJdpwxQRPeao1kQUleOzOKyXYbazbsG2qy5OQV9kxJG5+/NsbrTy3Y9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uk0NpJyq3ItGTurYlEhtJo1o3qA8DRnS9wBUUcMzjy8=;
 b=YzG/K6z3N6j226KGG6mHIs2+MMYmW4oK1qrgTak05C6pHFymF2SQ3TDzHglD5IpATWpeUjuDtPGJLyPASIK/qjEXxlzOfmzR2ycrNgSWwqn/rhkk8p82vFOSYIASTrVir7ywL8S7kaXHcGRKFRHecs/Bo77ZxahQctcBm0uNUAk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8618.eurprd04.prod.outlook.com (2603:10a6:20b:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 22:29:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 22:29:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: [RFC PATCH net-next 5/7] net: enetc: parameterize port MAC stats to also cover the pMAC
Date:   Wed, 17 Aug 2022 01:29:18 +0300
Message-Id: <20220816222920.1952936-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3287262f-3b60-45f6-ef13-08da7fd6cbb1
X-MS-TrafficTypeDiagnostic: AM9PR04MB8618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WtRSv6XgFYdqFhE/XyzOc/NOogn0mJ/dRGgQPX7RUhZ66pjz77isCjDdvPVTHxofNMREKjxyi/iJUqaDAV6uBktVk1kz3n7YOB4l4OZpMYbC5NlF24+JD3YfAWJ4Lu8vS9glCjggBrGLjsrLSXSQQHnquvNFMsYpqIIzz6S7OQVmcXVwEmsxjHUY321CjkP2Dt09kQcmSMOe88c3lT+8lR/XNvzUT7IuEZLiU+GyOgOYsVFIQroJBFgMEnLPq04wwezG972cxzy+Vep0UgqKr8+PEELa/zw2BzdXNSGfzVofCFqOimP0xTPn+VE/hxXiCN8htVaxRYzupMkUV72EBqyuUJnDnRBgI8BUqVGJKFJDkeprMQ6Ak5sssqFWjyWiPt08FCWkuFWY7cdtWDED+SKhjhB8ADU2ZkoK8wns+BtsyYUsmaLWAyJ5/zvJqbYrWQRYbXJUCXooBJ0FI8TzJMemgqwwjCwhbsIV14CrD5Uia1dmzsWwTi40HGy2ft53coIks8bAVKGWgphwyXadsS1OO29Csy0QoW1Bk4Mudm+xMlMC5ct6e2/pkGYmiVJkRBCMPH5C2INi2mR0XWB+y0e57q7bktC2/AuInQG16I0nknrpd1YdkbGutWW3G3vPMsvYagWXvNJoTQdnEaSap5XPlWDJvNnH3EbkPXi4VLUT4cMQv8IiOXOO5uEklmXpx6O/9ZWV7pDz76iiZhszLRTa607Yh/iHPr50cDuU+tPOJC2wMOQA+ltmwu+gbq8rYWULsc8AFVaMtcGfmtiL7+NLgxpxS+LTcWbcNv7cH6g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(66946007)(44832011)(316002)(1076003)(66556008)(8676002)(83380400001)(41300700001)(6666004)(6916009)(4326008)(2906002)(36756003)(54906003)(186003)(2616005)(38100700002)(26005)(38350700002)(30864003)(6506007)(6512007)(66476007)(6486002)(8936002)(86362001)(478600001)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rf9WWlLykrk6qj5a7poAvS2q5sSVZiuRMb2mKgtgoeik8KcAh59UI3Gin1TG?=
 =?us-ascii?Q?BWU7Qqm05VzQZo08QARDVWKNsUTco0a2gtyKRyxY9KUINjMUTS7OB2dfwXfS?=
 =?us-ascii?Q?dBNYHq7ynf2RZgvTYIET73Z1zQwRRJOFGRfWzXKBlIG2R5wd0vnivqeHQLIM?=
 =?us-ascii?Q?Zf+90KHmv2scQa2K3NfsWKZLSeoI5DjwqbwSBtBtvfzYmjJwuY8BL7OTuGqQ?=
 =?us-ascii?Q?kDtV9QhBSWvOUN2BbGM2KIBVJkU4P0ydEpm0TDByw3CgDlgdo+4iQaq3/vEz?=
 =?us-ascii?Q?6nx7imyLjdxWiXMrcg2il2YriZq40lpCFZOlACYRONPkzRVX9HUQe2LxGmLa?=
 =?us-ascii?Q?dOo/UPEIroWZB24nvMlZatEPmd+IdL227vbpFEqkT0TiBeBwHoR68MqzPNN/?=
 =?us-ascii?Q?FffYRw4+ryvn20xRhqPE63nn1SKO1ePXTBIq49+4beaJ+VzPdMnkZNel98e7?=
 =?us-ascii?Q?VHUvILDU6bN2gOECeeqxN6dz9yL5QgsE5Ln6XbTCwpc9RKAmPaYKNYkIT94g?=
 =?us-ascii?Q?9uHkGdqZMCVCQnUuiYD3RrzTWga+FG0ShW5lXIfdD66L+MypJjPmpLZxQaym?=
 =?us-ascii?Q?rWFoV8d0+f/m8qqLblSSiz3vgjtdtOqv7H+hxHEJ1IiS1oHQdElxNN46ZO88?=
 =?us-ascii?Q?7Z4XJkNVzIYEmKdvQ7nZT3TMLudVLipK8y0v1VnsiDgO5bqZiS9K5xcc7HPm?=
 =?us-ascii?Q?eCaxzQNHGvjpSShRkWaD8WVUP2NB+sP0/Diw3MKYgkIu0UA/Kx8hyWAZ2yTb?=
 =?us-ascii?Q?KlC5UyaLjo2cXNh6kYrhRh0PE1y4rJfpHUYqNaMGZ2EfD9IVRNV3cmMDwQQ+?=
 =?us-ascii?Q?rZ0T4WrRM4BtSzsZpy0PI+IT1UexjWdzjSUpA7WY075eLOphKQU0hYrzui66?=
 =?us-ascii?Q?PO8eWfBSGx7F4cMWt+VV0vug7wLcw8CydCwwHgbrcxvx6aM9HnZVZc3kN4QC?=
 =?us-ascii?Q?ZDN7VCIeNja05dpjjkbV36VMExv5pCUW5fMHYeKUxCC/DvDcqnoqjraNN16p?=
 =?us-ascii?Q?NKEGikyPr+AUNG2salNdCAuSwG8v25ZkGFAk++umm9PeUIFSS0LMB3FJHUkZ?=
 =?us-ascii?Q?HatI4XeATKD3IPeKnd8QFfWnGnAeBCW72wx0lClQYUweWjEMBLTS/PaMHykG?=
 =?us-ascii?Q?0/ybq3DPCca19T+zjG1/6wq5GYkfcvmdC92glJeVp4ew1adjt9u1RVAB22nS?=
 =?us-ascii?Q?MLu2vD8kIx2pTIubBsvIjkOGIKOt8/oQ80ZW5DJgdSmHRk0AYyTJGU8Y3los?=
 =?us-ascii?Q?FzXTYCioALcsC8iKA6fczLcvgwO0cztdRa47zVv27rpZcrUrsBk6C394jvoL?=
 =?us-ascii?Q?RJhxFDTEv89IoyOR+JNzszdyiZAfxLsKomit0VeHKk7ITKroDYfUImmqOLTj?=
 =?us-ascii?Q?oQCNpatbpN/dY0lZZHFAxkdq+lt+oEngOEfXzqPfHUV7hDD9/tH50+M10xQp?=
 =?us-ascii?Q?xI7GfZ3oX9pTzHogKI0IKJs/2XZefrsLgLAmKgyz0vlDzFVtVO0zQiDTn7Ll?=
 =?us-ascii?Q?FVSjUbFEvhhXMkVuOubGcqQdHSRVrELDkWeW1PqaQsnxLz4+3xoCEs1WvyTd?=
 =?us-ascii?Q?aQyXQVnrO+N3tTP3UainUk51W/zYKA2GhiVRqXZ67+CvxP9a4t9Zz1wPa4wO?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3287262f-3b60-45f6-ef13-08da7fd6cbb1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:29:34.5854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obRWNEKQiJ+PJzDbUwxnrRzJdQDg/ZWFAUtgoS3v1ijQjJGRCwLRoGgq/eUfKSjQaBJcZzBX0w9R8On86mrZ6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8618
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
index ff872e40ce85..236bb24ec999 100644
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

