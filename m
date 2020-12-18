Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016D22DE1A4
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 11:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389334AbgLRK6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 05:58:04 -0500
Received: from mail-am6eur05on2091.outbound.protection.outlook.com ([40.107.22.91]:14817
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389320AbgLRK6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 05:58:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0o+b9TSn3tmpZVqisxNKPpYYvQ0Uwq8EwrnG8FGnWnrK0WB/PJ/bOOf5H3D+XJ4mxVpj+vqvdU2r50/qDR77O+VE+LBlouCNTzs19L5+SD9kAmrXZRo59gYtxIn/9AGHXEH61wv5B+4CCkgyJQXyv0Z056KbZo5q2sVOEJFT/vA328G853k+N0jbCJuXCIs0V4pXcC560jbgD+t5ULiT0mBatZEm2TDToLygBgrZCBdqC1Njpe/JyLPmR/euhun1eYdcTcgHqi3aSUMM72tR1pwiegCWQv6Oiq9WyyTsWRYSDRw7oVGYi+1H4USxQ/0uejCLhEGz1AqIoZXpMmETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB0k3Bnfct1PffRRGNKMNfOgMxsNzekRSMbeyMqp8go=;
 b=Q4jL5Y7Sj7cWQEK3/G7PttNPMjOdA6WE6b8UnUCgnf8IOtRkZpEywHVVpxkfNRPN81t1Kx0MTLCEilyx51OJ91OsFtcSqUm2P2sYkII7Odr1SyOEPbyXptwdjlGEOxPafW9qmDWAyb+86qNav4yYj/68GB0bbNP/8Tf/uM5yqZv3MGWFS1m9sVlu6GPTzNQOUHPnm8eB9mbRfPsOmtDG3q4oud3vW+As1C2WO/WD9wJc2SB7lrboNhF/i3qOm30mJmejLft1NgzwHry2kB/PM3l34pXM1iZuZFsH/H02yCn2uu0CC7tSQ278TTuPS3fn3AnU0fhFGzNZAatJUEvZew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB0k3Bnfct1PffRRGNKMNfOgMxsNzekRSMbeyMqp8go=;
 b=codgDWSDJebTjg8pYKMrMKA0zwgFeXdLlKrVHf/Gr9Ooq6i8lgK57OVpj8z69Efj3N/MecM6S3fy4neXqfaeD5bWkma6bxwsaXa9erlksjICqML+MPABEhj88c3MvjzFzU01aRlZlRByxlfaJ2gZ5YCVm4C7DkhvofuCf4sukfI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2675.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Fri, 18 Dec
 2020 10:56:41 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 10:56:41 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Zhao Qiang <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net v2 3/3] ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
Date:   Fri, 18 Dec 2020 11:55:38 +0100
Message-Id: <20201218105538.30563-4-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
References: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR10CA0100.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::41) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR10CA0100.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 10:56:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9dd0446-01b3-46b6-ad8e-08d8a3439a47
X-MS-TrafficTypeDiagnostic: AM0PR10MB2675:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB26756F0D271A816390D7577193C30@AM0PR10MB2675.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cu0Nqtb9wbcEy2+cMA1aJcHqOGx12mGw1ES/Y78GJ+yd8HY20WJfjqT1enFze3+ZBD472Iib3a9PTHhC028xNBnBjN7csCaqn7kSf5hjTabdcllwlx8HjzHvJz9da9IxeaUCbTVIrHiKMwyBYzkY/dPOKFB7yjxJJYhQPmcZ0eC/waR1DphhlRrRU1pXOL/AeQo3O08lBqnpBNPWzGaTn9GPMVUfZHxzy6mcRoRkwkIyka6wJtFvKyz1SKWaZ6/tL//nncNh89vuWl5wnDKO4QkyMzjI8FodiGrA+tYVLFehOo+oFXTDHp2+ld/rkI8oe8d3NN3R16SjOtoKESMPOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(16526019)(6666004)(54906003)(8976002)(4744005)(6506007)(36756003)(52116002)(186003)(107886003)(8936002)(478600001)(4326008)(110136005)(26005)(66476007)(316002)(6486002)(2906002)(6512007)(5660300002)(86362001)(66556008)(83380400001)(44832011)(66946007)(2616005)(8676002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NHtVKlC3RW1iUTt+7s0yTqepN7uaO6DIMQb/AyFdTlGqXgvDECGP8A+CkvXi?=
 =?us-ascii?Q?vFHm2GFkyyEB/QJw3X0EBCE35a/4lTT2pfmY4X/7muwbTdydFrgMo8d/xJZd?=
 =?us-ascii?Q?PdHP4B/AH5pk7EJBRZpl9DGTQ+2BdlpVz8ZqHpQ58ujCf/9pXT1QP/KeYhwQ?=
 =?us-ascii?Q?JfDlBRvF7H2zwlRthlB1yUlG8Lk20M98qHzdcFr7KeG721FNVusaofQvv17P?=
 =?us-ascii?Q?C6n8f0mbT6afUbJ8P6EdTh8F/MqbrCLnXIHRkjE7F5AKZvSEtGhLrQRmG7qa?=
 =?us-ascii?Q?E5efV5beC/2HuygCsszoofJb4h94glvB3I1b33MLrbNKb7QrrPpLepiPAhVb?=
 =?us-ascii?Q?1lgie1hTQlXwFtARq0HbhOettkmDi3qbAD31lIPW4grI+NmZcceCVpUcfdBk?=
 =?us-ascii?Q?hxDFzx0uUQ+RHVF/pBT4LjHeU0b2d46WeoNnGj7ewFNWxn4B9d72KgofEBgm?=
 =?us-ascii?Q?9Gb/EvDrzAKBY5t9gIO6Y1iL0yt1m1/RLukb29jb8H+qDMC6c3pa2yGvuQO0?=
 =?us-ascii?Q?J2L3/rdlIpBGaKrEIbYUmm3NsKaHOS0RkPIbr+LqsNX/ASTaq0VbVgtFOqKK?=
 =?us-ascii?Q?XoNPl7D9BV7BwkKPjiKmDFnfT0o5bZiyrP/3GYwn4RMojZCO4wOjvG+D/SCh?=
 =?us-ascii?Q?kDpOATvA7Q+2DSJfrELfTvPy/Rwd5b7MmIHDTccs7hYAEsBqGAwMBGR9KkEU?=
 =?us-ascii?Q?JUYjBBBcNRC1ZZqNA9cLzqqJ8sPtv9xA49NNchuy3J08fid3sBHcmfOF+aC0?=
 =?us-ascii?Q?vEWTERyrl9FacW9xo8f4h5LOxzOV2HARjLnof9/+UvCRuM3H5AvECDKFNscY?=
 =?us-ascii?Q?i3BGt8vxO0mBuHbfLjVf7Z65N/K5c0aMwtxOyXTyCa4ocVpzn3o7G4g2urFz?=
 =?us-ascii?Q?KeDdi1TUBvT0niSOqmeUQ8C8kAMOvoM5p5V6/LPC41KC/HjIfeDK+hM6lEtZ?=
 =?us-ascii?Q?OSOo7KJiizoEDKu4ospifA90TGWwTPfDckHanrzO+ydplWCc1JTsQci/VJw2?=
 =?us-ascii?Q?NeZT?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 10:56:41.8270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: a9dd0446-01b3-46b6-ad8e-08d8a3439a47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZI1OkZXXMJrM5mLnSGAXAqPpJqbYUfibZBzeL0dsN3VaFOuaQ1uLr3KNhlY9tte83U488Uoz/C7grEjVHtIN01ZIS51JW4JcpSOjJvLd9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2675
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ugeth is the netdiv_priv() part of the netdevice. Accessing the memory
pointed to by ugeth (such as done by ucc_geth_memclean() and the two
of_node_puts) after free_netdev() is thus use-after-free.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 380c1f09adaf..3f9fca061cc0 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3935,12 +3935,12 @@ static int ucc_geth_remove(struct platform_device* ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 
 	unregister_netdev(dev);
-	free_netdev(dev);
 	ucc_geth_memclean(ugeth);
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(ugeth->ug_info->tbi_node);
 	of_node_put(ugeth->ug_info->phy_node);
+	free_netdev(dev);
 
 	return 0;
 }
-- 
2.23.0

