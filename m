Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799FC4298D8
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbhJKV2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:40 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:16861
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235263AbhJKV2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kENeGxa2ylyMhp+upkuPrNfAi3tjI+Na0eg+uNm3QOvqsrUiSC2q/dD/VHDTr4sEm6xqYKVW1lz7eLYjNMiucjLaV/70VS9/7eS3S2YmbXmHQD9uF4zMXcMfkqgbwTNhQ6heVBBe1aQx2q6QzdjwWIvy1Jaa1Q8D1BgN+9pCSQiyG8Rjtxs3OrKGY0kf2HWvAeLEvQ0fnuSU3c2j1aoCb22DbM8s6iSNH9cMo6lptTfWwyKY02oyQyLWpp291+3CLL+na7bOfe68rzTJPK+95A8at05CTE5fEb/YfYwsbTgXxT2FO5XiUNZFhVk20A0nIyaevOiFl9WeqtnVRkIQTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rov4s2JrkRRVdv/vVuPMdK+sL3G3RIoWdiiXGbgrgVU=;
 b=apR1safKC5WtmYO6l8I98eU7O/b7iStt2KOJ1bXAR47w6GUfNmh52xFKFViyfFKbxveW1S0eCRaP1t8Vb2Wti51YAYvRa25yx5SZoqsKy4RIiOoq8hGrz1wcW1InPwPN+uXJr0IFT0LBA9tclNOjQ3eWts0ioQMTV8ggafCcownPCm0rhTMhmbG1BGi6xjDY5IcLVAamF86Zo7z3a51r69DqWE4kz8WCY8i68alHHss/93X3HqmkAmNBNXZHeqbZ2+85Y/fK6JuuBxHGnKrujQ8DNbMQzxDefpXLE5DwjbmUbmlETiCQJW7JAiQ6le7Wt4nC2KFvfRDY+/PMSmJt9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rov4s2JrkRRVdv/vVuPMdK+sL3G3RIoWdiiXGbgrgVU=;
 b=QJht5TPyC8psowAsavnh2mRrb94qjmj/28nNxIUzWuHdE+PfKPGrJM4oJJtbbQ9ZhP1Y/ktLtzGAIxR7YaRnTx7GnnO4qlZJz7yvGDdDnrLUE6S2p0EpGCQgJaHUR+yJbspEAOdkwF60B966Jznf3tyRzht+GzYN2dahApN28MQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 VE1PR04MB6703.eurprd04.prod.outlook.com (10.255.118.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 11 Oct 2021 21:26:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:34 +0000
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
Subject: [PATCH net 03/10] net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
Date:   Tue, 12 Oct 2021 00:26:09 +0300
Message-Id: <20211011212616.2160588-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be357a1b-3846-4301-04be-08d98cfdccc4
X-MS-TrafficTypeDiagnostic: VE1PR04MB6703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6703CA3FF71B1837A23EAE9CE0B59@VE1PR04MB6703.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d4RaIPPEsR/9DeykVPEsM+GvK1bpXuZsBypgK+YIgGGXjPbsqmeEjVcXtGVETq+noD7md3zLfomQ3WnxCeeZSevPOV0r3iZGtKOsMybpAmlem1LgYIvfvpvmfeuZqpvEjej/HjYI5L8spInIhhENNeiksewYs+dFO91S7us0jDrpd3jKyR2MWSHPjd2+4Xr0ejmvAcd2zB68qmpYFITb0AAZ87SCjs1i2oZf5VESs1ubfLL0SNnK9MeRAKSNxVUrwppaJwtLFcbaH2nNsay53fw/9oLv0tWbMTkuHEn6OzqplTBYAn15CMBRRlJSt5Cu3TKJ1VwymwGvr4D+T73hycEiqatrSt3lkrFG8KnuEjsFAb+usF6CNbzyoMgRavNtKWv52oqbneubVDGbR/ZH7owtL69chWXb2MnJapfzccCoLbL+7cFvkLW0nYYrQadQm0A8In2tUprImtM3Ij8ShfPVhavuSvJMPdsBqEiEDECTlyo1konJw4W4DAGo7Twx8rIBplefXc9AQ1ldo7VK3zWfHRyoZF0SQBmcv2lAULubt8xWxTKvtzQ4jrj/WHbweQ/0MpEV936iZtLIsoR0S21EkSEyp63lGuoup4nwk+qo3LlPrwjEvq3koni7yuArIBspTvPaYiVHPzWW/PawnRv65lZ81KDTiSaAw0YUBTCuT/AliChHmLnc6+Hdqtu4899G/N1Sr5J3yceFEFf0Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52116002)(36756003)(1076003)(2906002)(6636002)(86362001)(66476007)(66556008)(8936002)(7416002)(6506007)(6486002)(66946007)(6512007)(508600001)(6666004)(2616005)(8676002)(5660300002)(38100700002)(38350700002)(4326008)(316002)(956004)(26005)(54906003)(110136005)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oA7d3a2pvRaSLOffqImTSfDjcSBGs0HaiUaqOxzk3RJDw0WM9wutzXBtYjet?=
 =?us-ascii?Q?0mCnJNY1hNAbsSCbUVzubmJeLmmZMFznE4EulUbNeMxYf4gxeARANZ1GpBNM?=
 =?us-ascii?Q?WWnqKEm8yg/PjzminiyeNpKD2VMoG1hVMMVfWcfeuBrsvkgDsfFFxPoYSnL+?=
 =?us-ascii?Q?kjYW5YZpNlDZLEgyY2d1PFDEEx3GCF9wGvZXZj1OPzHFH76aorefbDN78XX0?=
 =?us-ascii?Q?wncWqHDqxT/RNS9OLpk8WE/ZKeU9EsYYJ9fYo27urCNaS9uC1wgLchaJqqmw?=
 =?us-ascii?Q?CAd0sq8AOqpz/puvs7R0gpzz9+WXcpOYiJmCfR4iYJOaeid+VZAqYbKUryBv?=
 =?us-ascii?Q?c7Q35P5lZt6FE86TgXTxnrQN/FXF5cQP4A0t7qWtYLAAd08CO4qCrOnKqca6?=
 =?us-ascii?Q?B5hGH6uX7SKy83dnnXDTxV93++j8gLvrRTsK3MjyczyRzPypIZ1S+tw8wzDX?=
 =?us-ascii?Q?mjvcYtJrXxPFk6M60PbjOt0n4U+FQS2HazJrUuAJLGmF08KEdkLVSycfA76u?=
 =?us-ascii?Q?TFw3o3C5xcGGl4DpeJvvp8a2vovo2aHbwWhN3FDLhIsS6BEoG4VK3/p34I42?=
 =?us-ascii?Q?lH5mUE3eH/Bo/fsgLkcRiIviYLPtg8uCc5AUxsXULVKKTjCnqP4OjNSqORlW?=
 =?us-ascii?Q?DRaHjeTSSjXzicugVn/6KKM0ufm/c0T6MyRn1lf/djhg2rLsJCEP/odfbOG8?=
 =?us-ascii?Q?AQ2WwbPYWDSEcr5KP2Hspg7+q3dKCE3AX6++DaBdNuy8J8x8W7dgf2rf2UgF?=
 =?us-ascii?Q?CY166AEHiuxGBQIYNlDLYE9rilJYdffA3q0UpkCq5SGE/ZRPExe4ylPeFtLK?=
 =?us-ascii?Q?lzOIx0soz48QRv6IZFG08rnhXy03noB16zyq1turbyG/RZyESZtWWTKsRU6w?=
 =?us-ascii?Q?B6wU3En38FLl9h4Oyj5OPDrWPYclYZ4h8/aWfdaccqR2dg4ijCArCO4MBYAN?=
 =?us-ascii?Q?JugRw/1Cln3NRBybrI3haWggez3TjZTIvaJAEW323eXFr9ETPt8VtxEL+NfT?=
 =?us-ascii?Q?USN4Cl+WLTxJ+ECuxr/3168z1YloyoNCodyBSQ/BTGEj92LDTP7JyJsHLqiJ?=
 =?us-ascii?Q?S7kWgSLfHtg59O83J1NSvNIWbTKvVAmR2Oso/PH9C+mxE+SLeFxUf1L6JQn1?=
 =?us-ascii?Q?kXtseQNlub1O8fb6ooQO4UGLHq5SsvIE8xVxXyARb5SM+om1W4uKT8unmFJd?=
 =?us-ascii?Q?5wNu1HlZtkAF2SW5RIfXTgHufciU8wMy+x/IAWab57Hyzm4hevi+Qi4iNeZQ?=
 =?us-ascii?Q?SKbKuF1zXTM/zfg8ZjJ6TnaKMhaR80MAUnj2mv0/TYUuxVt7LDrygMvO8DhY?=
 =?us-ascii?Q?Q3BbDrlVssZgWwuTiCJeclbt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be357a1b-3846-4301-04be-08d98cfdccc4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:34.1327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dxo0Vr+egE3QTFpghkxM/46tLIg+EZhW8RVRNnXkRXblQD26zMqzGyQ+hf7KHAKca2f30Q78/7m4oe3MhSrFfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When skb_match is NULL, it means we received a PTP IRQ for a timestamp
ID that the kernel has no idea about, since there is no skb in the
timestamping queue with that timestamp ID.

This is a grave error and not something to just "continue" over.
So print a big warning in case this happens.

Also, move the check above ocelot_get_hwtimestamp(), there is no point
in reading the full 64-bit current PTP time if we're not going to do
anything with it anyway for this skb.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 82149d8242ba..190a5900615b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -747,12 +747,12 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 
 		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
 
+		if (WARN_ON(!skb_match))
+			continue;
+
 		/* Get the h/w timestamp */
 		ocelot_get_hwtimestamp(ocelot, &ts);
 
-		if (unlikely(!skb_match))
-			continue;
-
 		/* Set the timestamp into the skb */
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
-- 
2.25.1

