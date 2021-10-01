Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1873141F102
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355038AbhJAPRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:17:46 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:29755
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355041AbhJAPRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:17:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y19aKPLQT8lHxOBG8PAjJtAKcNJnB5cTHC61pskBk1V7lBM7DX2/2KMtuBtelj+2o4jfuzs7Bd/2nn7w1h1m2v57nYzMWAYqVpXpu+nkdgN/7HVhiUUaNkE9v8n2uYW6WCQZnKVIp7TQ1x0i6+gxHeg8EIHPXcPp588EU4lMclezzeWT3wTCeRweN8dJBZ308L8o4xBvUHSj8XDozVwoC+GDZ7f85e6HsqO+yz2ORFtrR+3mdYeQ7EIZgzqwGwtT3TNydagnrpfGpyRTnj8uRcjYJuMEA2r3pjYhs0rUr6BaGQUMMNakqU/kBjC19qz75KiwnZbQO7cICPWrwN9t+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgiFl4eWQizJTgKYryie23At2Y779uh2XzjBkbAPXmc=;
 b=KttOUEJ4sqFUuj7FHxcKnqKsGrh3P+8HGQrgOg7r886izKb0vxDTV0veiOVfMhdr6c9w0ScOnk0OOCRFVQiAujsu1rIgkWg+sThsNGSIph/ZbqmyYQho2vkBVaZ0MQozDxFsJN+k8Ix25HAQCOZCJPIdAy5PrMEd85lT7jDapWH2sXtgcoPIQzIpi+W02nejh8+S0yA+LWdAxss2XLm3J1pnJzqvmr8tyj/xRVH/20bEQgAuqbsJDF3ING2PfaZI8MFZnaaIcGZ5plx1isozaWteDysyl4pvs6rgoNxwvsIImgzM1mHGeTkOzeLPP51JOcMSq2+5Le3h16GjyLNCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgiFl4eWQizJTgKYryie23At2Y779uh2XzjBkbAPXmc=;
 b=fBnJqRBBcvKtHWbbgxmAvK1wUxxP4I7micuir8nXP4Ev6F8iyozN2uV7fOhImYXwE9RrTvQy/ag4a6S41i8m4iUNic/Mo1X7tGoWk0zQFdCVawUT2O96c3vLW7Yx+Vtm0R4asKz9dKu8zZ2pz5zpB8X2hr67OuBfR/hQLxddB6I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 15:15:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:15:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [PATCH net-next 5/6] selftests: net: mscc: ocelot: rename the VLAN modification test to ingress
Date:   Fri,  1 Oct 2021 18:15:30 +0300
Message-Id: <20211001151531.2840873-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
References: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0001.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM0PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:208:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 15:15:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 930ea08f-0f46-4a8b-a4f8-08d984ee594c
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4224F486D6A9040C9BEDAC6CE0AB9@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lejHFOGtVBMwFsbT92Ww8HORDTQmIZuk5mXHpvlxmo/cU8OrF2xzuRrxYwr6H0MC37/Mk0ZbpViLX0yGdHRLZkOcsYpVFhak4Y4up1LD2UWHOmfT3Hosw49GfX5t0b3Uyiq5UtwaXuTnBSwZCi1W0JwbwR7EF9pEB0mlCcAuAZnoxct2jQ0YH+0lGMs1jbuO/Mo+D6wl7SmbLomaQae9tI9UAoQL0elxcEGMxwSDyBT2rvEemm3spOjJvOmexsZH4QpLg8VQVe0TUAbyztG8Km7DPn143FokiTl3LJ49OBvD9GyvYmEdX9QDlYWHpZOy4Hg0XvrTI6MbsL3X7Dtphfd/Umrvp1JL82tnQFHI1SjfKw5rNI+I4KELydS4q6Yc9Iy7gLbYqvbIEM+OVh/cjoty5uGgsSnh85Q/a44cbkwgIbKmgQOSAJna+2gYnARPsy2WeEZQ0hUHwwuSoyhOLhtVsbEmh0VTgznNZ7IfpK9sivuqFTQVBs1oATvxzvE9bgC0K14pzrehsu2feWeVUJoMHLHZVg46/s41XtkypBWKaNI/IZEs14oPiyNO3w++4qI+KZuS9mvIVpZdVTUubJfFB1WAZPHZ7pMmCpN5fPw9U5gS5y+unslkH4qGunXUPRJChvd7Dl6ywd3WSyJ2zvoEnS1KFZFT3h+zWwSoIUaaVSFuNUIKR01rnbRiGVCKYIqqAF9+D4kj4xKgcerpaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6666004)(1076003)(5660300002)(6512007)(26005)(38350700002)(38100700002)(956004)(110136005)(8676002)(2616005)(36756003)(54906003)(52116002)(6506007)(8936002)(66946007)(508600001)(4326008)(83380400001)(186003)(2906002)(6486002)(66556008)(86362001)(44832011)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1QMJNWBe1T/hO2ZThWNYEwx0kwfxchb4ShPORdMNkLkNslym3tNG+JkoJoYA?=
 =?us-ascii?Q?DgS2gqRwC7zFsaCU1CVTZm42/Fn6Lyzpn/b51tsM3afPVQCzMadEyjffgiOt?=
 =?us-ascii?Q?tasI0fXFQHZvsnprHyYvPX2ZTBtd6aA1RpA7SOcDZPZ/yKuM7gLZcC3zieFP?=
 =?us-ascii?Q?1wXWn2H6cGzDYU6st58wQ1CZ0i+x9ioCaPQ/1EA8SWhwoqNFd3RZSmugr/5y?=
 =?us-ascii?Q?m30ae8I37t+BCYiCC7p6Th6LIid3avVxTsHdA+uYbiRs0R5tzxOGzhJ2L39Z?=
 =?us-ascii?Q?JqnxS1/6bwIIos41vvtdHcI9ULTaqWlLKyhdL8+Q1u7CkeHXkTUjZ19oR5iI?=
 =?us-ascii?Q?fiabsci85ISr9MdfRBbNqj1XYkQqlccASj7p1THzohPcGAKW3oQu4K+J17RV?=
 =?us-ascii?Q?xE76SEbpdr1o7cppdXADsINN/Sz1cXdb8h5pZvdWH2aCMY49SNTQEic17hb0?=
 =?us-ascii?Q?GMi3NXJ4TuY3BrHjvDEaUxueJReedpgEP0I2QOUYQmNfYGxY/TcIpmQ+/7OJ?=
 =?us-ascii?Q?gE9abAbrNiR5dCuYUt4jEhgJY4NAAfLVubiktQZ4MmVMVe1Qj9U9Crl5fYIM?=
 =?us-ascii?Q?apqRxYyTQamOR56Im1EQljFBAUqLsLNo5kt1/dR/D5qhuO+98iLrF/1bX49Z?=
 =?us-ascii?Q?cecyUq4/7JShk4/ZgdN6RjGGNOrElhnCwa0vGsY0ea+q9jKj3GXJz5x8hsEZ?=
 =?us-ascii?Q?mvA9tT9zmdclfVlcoKHTY8xvBwrWAIddoWYWsPy3Vw0kbiIpLlRljG12oDwR?=
 =?us-ascii?Q?yn02bO3XRZZWD1EAo94SPTXN8PTVXl3nTmuRu8qtkWZXOB4MBVW5zDmcpGh9?=
 =?us-ascii?Q?dpCmMQ3BqNliNV4IHYiCYZw1L4hwevXYZrcSRHkUAGjebRRG/jIECCsAB/Ar?=
 =?us-ascii?Q?LkANus0kxBXYlPfD4OCIYp97ZQ1fLvhCjDKX0p0uPpidkPxpXfuoQmjkioSD?=
 =?us-ascii?Q?cxRbuvSmPC8bIDRC413Zw/uczJtVmZLDf6v7xtr7dgZON6Z4Vo78YbPHGK8J?=
 =?us-ascii?Q?wlYtJvxUQclWpvWjZYBw+Pl3/IFeazq0ijWfK/OzYXSlxQEDxMh30oBnv6Tf?=
 =?us-ascii?Q?gQncImir4Mn5PGFT4vLKdH5qrc1qlOvKwmP4uKEiSwu47vbf0XMdl8ujHGtG?=
 =?us-ascii?Q?G1DtUuKp+iH9vS5Jkavov0diO43StEzgGzljl72O6VdrqI0rRfqVlE0XadAC?=
 =?us-ascii?Q?RHpDgDekYwDdtA+RhuGqBE2gx1IiBdf7NnGTcBj0WTITdiqW/5n6Vvkp1c2b?=
 =?us-ascii?Q?qPmXpifB5VkO4oJ8mSIGzrG1Igz2EcPHjO9PIBdqArZp3hMents5sAGxvs+Z?=
 =?us-ascii?Q?DTC1+N26UpPDvMdFvzuRjPVc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 930ea08f-0f46-4a8b-a4f8-08d984ee594c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:15:48.6772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GV25V01HeFEmWN2DHR9mPhClRbOKrmTOFSPN7OTMw68xQujbTf1SGgto3ElkYAymlpaMjljM5kEIaCfSTBlAbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There will be one more VLAN modification selftest added, this time for
egress. Rename the one that exists right now to be more specific.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../selftests/drivers/net/ocelot/tc_flower_chains.sh        | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index 0e19b56effe6..4711313a92a3 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -247,9 +247,9 @@ test_vlan_push()
 	tcpdump_cleanup
 }
 
-test_vlan_modify()
+test_vlan_ingress_modify()
 {
-	printf "Testing VLAN modification..		"
+	printf "Testing ingress VLAN modification..		"
 
 	ip link set br0 type bridge vlan_filtering 1
 	bridge vlan add dev $eth0 vid 200
@@ -309,7 +309,7 @@ trap cleanup EXIT
 ALL_TESTS="
 	test_vlan_pop
 	test_vlan_push
-	test_vlan_modify
+	test_vlan_ingress_modify
 	test_skbedit_priority
 "
 
-- 
2.25.1

