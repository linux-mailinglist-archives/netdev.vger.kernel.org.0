Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C4842A37B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhJLLnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:16 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:6177
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236275AbhJLLnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dn4w0oG+pKXoSspg9Ge+9ywnK3o+KpMZ+RQLqoo7zPp51+Bxhs8xPR+IaYbcmyPJGjQOtoHZ/lkjiguC6nK/vcMT5uBTe3/HiQ/OPGyVHB94URS3qBnqHKMFOweGkDj0wwP9/Xg+egoL5QS6uy3TuwEQGPZH2sfCoAn0gld4I5EFdQrBxo94E6M4gdwD42VNa/uY6j0lS7aT/rMNDrJfJKJfy0/fU8QNS1QNVuGrqZ52QHBbgEZnllxqhpjY9bzarRK87aWoGLh62Dq0/WC7Xen4nldtAMaw+iqg26u4cs2PLdfkOzEApBogzBTPEA1CVm42KEo2+Z7ZtVvP9qUIqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3la6fH5mopMqllaMpU3OEBkwyvpx+zXbqbvpomH2Ew=;
 b=WrtTFD8MCNS81YBLmNyTYnx5rtDF+Amd68YpqkAIhbse0q4EWxRQRUTpj9TWCOVSPbp4TkRkm1hoMW6UWckOW4o/Zf+jZJk71MaMnMWSoBgOv4mfVaaprP6K9mNvmoywLbYHf5fkZT8WryXDTfRgifRPcRkDhcBoiE8P/cKFzhI1ANbRysMc+QET0+xZIBT1mQ9sSzQ3LRE88EgChs89LgDtQ2Fuw1dqrb5qbIFFPdz0OvD/yEOxsPUbKLv7y4UeaQ2tQI0sp9+h8Qp3k0ZKexU3k6pPpbim4Uj39FdiCi7goYJ7PeWa04bmSZdZjSrmejmsIdKqxK4Zi78qyUxjNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3la6fH5mopMqllaMpU3OEBkwyvpx+zXbqbvpomH2Ew=;
 b=VoJv6/WOopF7tm53OKC5kr+JynG8XWNny66m3YyCONgkT7h3+b4lZ2Cc7As69hzBA4XiMopEoXjXRIOHfQJ/Oh2D19aV+LM00HRVqFe/S8lx1EzHqEi+z5pjrGIMqBOOzz+cjVJBGk/K3gdDuCFcw3PXHPXjFdOhMGMfQdKF0dI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:40:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:40:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 04/10] net: mscc: ocelot: deny TX timestamping of non-PTP packets
Date:   Tue, 12 Oct 2021 14:40:38 +0300
Message-Id: <20211012114044.2526146-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:40:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcc20505-87b7-4cc1-9059-08d98d7528e5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3709EFC7DD7A0872E430F5B4E0B69@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6+jloAMGQE3XLlbHCwKLa2c/UoaYW+IpHTMvjDqqTNTHBWxi57IUQ8Adf/je06+vn5XupTaqrgNf8VKnCJQfOOz9adW46Wja8jLGV4pb2LeZnOrumqRaRWMgRLC52DmoMGXeDU7fE/5I7bzVE0KafX0uRCL4aB8/ycU3sOA9kWiS8y8F0NHcfnIZ3ng2AmHJMe4/TqaH4lpxHzuxln+ul2J1qy/E4VlDHoEz5MERsjGqr4y9snGm/tvzJlt0/9RLy8+8Cag5idWW8V1rdlDPAH+a+l2sUP61QNb/h7YLSVWqf6z2wPxNEku1jvjIzwZWCqxT7oPq34XqK02HnCDBiMcsgSG5sV0o8vFNIxZvcskoCc8WjW0De8c92ikHU1KB8swOiInL7FQVD/DxHvDyskhUcW8ah1YiKdYUFGnuGhW34PksmwSDu+y14XCm7d9m7hWb1a495gsdHAOMn6iVtehCvpDtEg0xBhvP8to1p6ZNDfe9FepxYqL8LXhmoLU9ei/F/jf0vvVZE93mzrQt7bx6BkZbyAeUytazlpujFqgq91EWLhsmk4a7mlcquHpgR2I92+X78HYRidOFdaJ+qFSBXM08jy3x9R7khKYqNecxaI2ga2UFt+IYtkdYX3N6R7LIDXu3m3yamhwhWHBZFfKLk8a5CbqF3xtAr8PpVG4SqsKQ0GAp2QpEdfoGTxSZs5Prg1eLWIlIrwMxFBFWvW8V1qQm2J/UZOnsDOrgX/TM6gJSIcbjd0EKnba1Jk8hayvlh/rxDQETUIQitBzC719wlSQc+wZ17W93Gag4i8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(83380400001)(2616005)(44832011)(38350700002)(38100700002)(956004)(508600001)(52116002)(4326008)(6486002)(966005)(6506007)(66946007)(36756003)(6512007)(1076003)(186003)(26005)(8936002)(8676002)(54906003)(110136005)(6636002)(5660300002)(6666004)(66556008)(66476007)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/vULLRO/u4DtlGuFUwSTwbCIxInO5UV0rJHc6d0qHxjIxYm4JieHAVAnfSTp?=
 =?us-ascii?Q?PxEsP5fqpdXiWBlQaMKCyV4w10hu82zj1ihFjHafBtJyaR+cKe9+Ll8tnJz3?=
 =?us-ascii?Q?oAeJ/VxWvGasdRaMnRz8XtrhvcwXBxSMOHO4pnddO+7T1oe8v+09FmZAMPzI?=
 =?us-ascii?Q?zMny/8ZGbCSCGAYiGW4eJwG9KFjMvCd9sZuAaVJylBMyckram0cvxQoUW2ok?=
 =?us-ascii?Q?wv4L500gUcgS3zABTTXMF4AAV5v4UV8oU3MiGDUinNLvKCxlie6dgV9gnCOb?=
 =?us-ascii?Q?0Z431wb6vbu8OEqtY0/g9val7OPAKXtQ/sXLlLHUa6YYwDIRvTjGjpC1gBE1?=
 =?us-ascii?Q?1m+iKNg0GDczEXURo08AfyKhNX7g9QX+mlr+m4296bmjAx0WoWJdCxnQ6IY+?=
 =?us-ascii?Q?tt4RaZEdSBHZleSGCAQElBbv4C1KR2GLD6A/eutseZGfJDgMfk9h10fRe22E?=
 =?us-ascii?Q?jOSH30KcXME7zpP/vw+3hilKuRROk7zULGVUh4Z0f1J3DeseIG9GW7EsCPmb?=
 =?us-ascii?Q?K2R8HfFxv9vUDYVsJ7tOKiuLFjTNJHxFDL3cZhIMUCxB1BsjphMsJIj9EI13?=
 =?us-ascii?Q?qjJh5qamMyehGEBANOC46Rc3YNMvBvTVreGumoJa3EplXnXSWNMqn0BzBz6h?=
 =?us-ascii?Q?r1mLq3mJtPgrRfwz54pi3jJWPJdI9L+DG+348oal4l0UVhDpmfqO01z7j2sU?=
 =?us-ascii?Q?o7+FtTj8eZRZUauyTxmfx3TPk0ncdOxaikr3ar8MCvGkI3RJ+RaFmHWFcZa7?=
 =?us-ascii?Q?3+mi5cEmg7+9ZnGBWBPOp/xkWsCl7MpNy/EGzAHVfN+ch8L1UYRfufua7MGn?=
 =?us-ascii?Q?umce3XE/RdrngElpsvk9HFdU69o+QVcsWgHbu1+cp3S0y24KmosCvfFUAWiC?=
 =?us-ascii?Q?sGP+RT5rzkZeJZLsj1NzacH7Tt9G6DwXMvt4fyudgL6DNLk27e4hu2BJKgok?=
 =?us-ascii?Q?HAuJnqLbtIvu/jkww8h9jrRSK677QZrFylZBcHOXMV3UEayYxNkxYP+jBuhP?=
 =?us-ascii?Q?awKiGdPs+4nlzl0OsJTC67yvu8kH8bmbnQQd9GeEgwriVfBAibWv2JvCGOWf?=
 =?us-ascii?Q?XGXNYsDIU92wT3yxWbOqMiVrcI9fJ0bl0ENV9BJTQfN9EcNc1Ob5nKj1PJRD?=
 =?us-ascii?Q?MVh3dZes8cljXBPJr4hxwCt/FQ58K9k4Ir9xonQxJg4uqN5yGO346ZY6lXFZ?=
 =?us-ascii?Q?FCNFZ4OqJetSHUa+N2va+95j7F7MpEZJprhaNyCglgqIyGUbk5itNSGv6rXz?=
 =?us-ascii?Q?bZPFpvDHMNi5+j/Cci59Tnz7ixkYp9jR5o3DaC7x07/cR7oWuGQeLQxlCFra?=
 =?us-ascii?Q?pZx84D5mmobyctQ0CPHcgEeG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc20505-87b7-4cc1-9059-08d98d7528e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:40:58.7988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LILNRzeGn3xNnzWrusAppNP1oBa28ObWZ5y0E7XyC+R/FlT+Tivf5bNsWlXoaf5/xGkIEG4gyXYyzBnkGEj53g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears that Ocelot switches cannot timestamp non-PTP frames,
I tested this using the isochron program at:
https://github.com/vladimiroltean/tsn-scripts

with the result that the driver increments the ocelot_port->ts_id
counter as expected, puts it in the REW_OP, but the hardware seems to
not timestamp these packets at all, since no IRQ is emitted.

Therefore check whether we are sending PTP frames, and refuse to
populate REW_OP otherwise.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: return early if TX timestamping is not enabled
        (ocelot_port->ptp_cmd is 0)

 drivers/net/ethernet/mscc/ocelot.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 190a5900615b..b6167c0a131d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -618,16 +618,12 @@ u32 ocelot_ptp_rew_op(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ocelot_ptp_rew_op);
 
-static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb)
+static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
+				       unsigned int ptp_class)
 {
 	struct ptp_header *hdr;
-	unsigned int ptp_class;
 	u8 msgtype, twostep;
 
-	ptp_class = ptp_classify_raw(skb);
-	if (ptp_class == PTP_CLASS_NONE)
-		return false;
-
 	hdr = ptp_parse_header(skb, ptp_class);
 	if (!hdr)
 		return false;
@@ -647,11 +643,20 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 ptp_cmd = ocelot_port->ptp_cmd;
+	unsigned int ptp_class;
 	int err;
 
+	/* Don't do anything if PTP timestamping not enabled */
+	if (!ptp_cmd)
+		return 0;
+
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		return -EINVAL;
+
 	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
 	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
-		if (ocelot_ptp_is_onestep_sync(skb)) {
+		if (ocelot_ptp_is_onestep_sync(skb, ptp_class)) {
 			OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
 			return 0;
 		}
-- 
2.25.1

