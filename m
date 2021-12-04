Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7E0468710
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355635AbhLDScr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:32:47 -0500
Received: from mail-dm6nam11on2112.outbound.protection.outlook.com ([40.107.223.112]:6588
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345608AbhLDScp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:32:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9LFhdA7SO4qeImvyFgditfd3E0p7eCkNdFYPeP1CiiL+KeTiwx0tHl1x8RGfffJEni1OFldHulFn6IA2ExlLlV49lIspbOU7/2OJjdAWlwXB6Z+aafLUq94rMALWiFoDVc49OSCqL8cMByxEEbYC1Pqzu5P85rzf+B8lDBbrMiS7zsKpsCzWOyKoyyWiscfYz5dO2hDbCcSqzZezlyBYr3XO1SyYBXA0Sw+ybBNULGtPLieDdZMNRKliY4jDbqC1RoIjZ2rBuyh3SqJvyFwTr7mrg7OojsbtC+r5cxkcWyU0FbKi7tu1c5T4++tSjvmARxZJmAzzboDqCPrU02Dkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHmqs7jtXlyl5vT34Rh21MJulNwRKv0aEp3a8Ind7mo=;
 b=CuP7Mcq17XGVTddM7KX57Zj0JkHLukw6BKvNLyXHKT6KY8S5llZKb3UurghxIy/TznX44CXzMPedg3OJKpFJLZq+TAsP8YshG9GOqsuD2Neaj/Y9+ykoGI5jS1TwLa0GttTZcA4HXrUo3fSc5+KgAP8RiyJrdZgEebP3ZubrghUWpAqCTBX3HPidxKAblb21FIHx0a7y1M/PkEerUqL9cG3k84R7F1CQdDe++GU93AfJDTWD+QhmRLVs8dHO4N0jua4iraHJXeBCzmi+9fJq9xLfqZed61qhVglPzrgRZIL1/lwiD7gV9SQKNp4/PrJK2epUwj6kK0aaZuWDoZpRZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHmqs7jtXlyl5vT34Rh21MJulNwRKv0aEp3a8Ind7mo=;
 b=Wib8r0m/fpiUWyUWJgMVeoJCBYRmHYQEvBQ3fAkQb/94tEtibMX3VBGStdUzEtkaKlKx4Tdbf/lFLzoWiC1yzV9UwOLGKSp3xTxS0f9SJRuY+J52UkT9UWLP4ea5BKBzK6g99d3tqxVjlcPNfZczBewCeMIk7e7OJCN7g2geTjU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 MWHPR1001MB2063.namprd10.prod.outlook.com (10.174.170.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Sat, 4 Dec 2021 18:29:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:29:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v4 net-next 2/5] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Sat,  4 Dec 2021 10:28:55 -0800
Message-Id: <20211204182858.1052710-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182858.1052710-1-colin.foster@in-advantage.com>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:300:115::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0045.namprd11.prod.outlook.com (2603:10b6:300:115::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Sat, 4 Dec 2021 18:29:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8685568-f2c7-45f4-473b-08d9b753f669
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2063:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2063FCD87B3C0B470C145200A46B9@MWHPR1001MB2063.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3YqKbUI/Kj4iMM7bqTbaCi296g8f1dlhvSt2qPggV3SHgjFKfS//CDR1oCpTsEhq2P+/m2ube5a2+MTl6ufQnG1lMVkc8AgpCOPEvwHTIA4T0IvtaotiFu+yzOO7IHOEDDSNe5oAOQm7HIsGRPa+6ngdTozXjjql5+Emd+f8lTGehxSnYF3TxEaoG3GHAwJJTMUxNFYvx8+H9Dbqna4y72iP9JbG4e4XPXeLmsdHEMMVbY2xucPvYQoaf7RuRfFK20kT9M9FLjWGsULMjR333fGQIS3CFUhpjblGtPujAA9dNcoc4jtoa2lfEDmys8juW9f8Xv7zkgo9E92PPt9KEceff1HqTUEal4DMWnhw2DrgkMHeL26hNBu6JNkD+J8T+8dCBnW9867YJMPHeLKYeCnuKCTyzDbusLbeBNfpRqYCH8ZoABlTpVBsaJ9w+n6HaJH9e6hGKf5YLEZF0JrY3P+VXsCAmCcRg8ccjynRSvNluHkcBgT/eApLVDOyfDlPqPhZViAao7CDVe8OeNFjoch0omEWDHX5k1mH8nybkSUas2zHjNFqQ3o0EsJZ72BZ76vRFrW7M7W6okGBx1vWNk2VPzyddCN0BabmPamsE7xCJVMwOvCg+a2oyqIG/zLRixV7qj9N+KETWTwrsKGB+POrKHTuqHujAbfuzl/s6kVr/Sojfw0vy36AD8+FZvePEi1MwthqGhHfjuv2mHWCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(376002)(136003)(346002)(396003)(8936002)(2616005)(956004)(86362001)(4326008)(508600001)(1076003)(66556008)(7416002)(6486002)(66946007)(6506007)(52116002)(4744005)(6512007)(36756003)(54906003)(66476007)(8676002)(83380400001)(26005)(5660300002)(44832011)(316002)(2906002)(38350700002)(6666004)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LXmMlpyfmBszqzVjw2ri5ZDvFZcpCLze1SpOer0f8osT4tGXkmVvl83I7UIn?=
 =?us-ascii?Q?n0BJjQ8uduYZ5V0bjYj6A3BL3IDRhLxDF+fDaLHsnWfggWcUCQyNGHdZQsCo?=
 =?us-ascii?Q?dI42XXigCbruDk8aX3p8PcAOoZZATjyNt+kx21XJ0akdUpwXa61lndYVHBz4?=
 =?us-ascii?Q?xCq8Jq7tSd2JdDwIU19tncri1MzsagOhWS0PvJYsuhPkCsvun6cLCRVNwXSP?=
 =?us-ascii?Q?+YdNBP6WiREcdkR1EefZiXRfpKEPozMB4JQaV5UEGiJK7J5xij81yezWxwh9?=
 =?us-ascii?Q?0UMUhzemSWKSrL9Qq7xcTfGvrCaRP0jItlDQeC2smBepnvU6AE1ANUGa9/d5?=
 =?us-ascii?Q?dlUOuBqquK+uv9vOtYMnUXgerf9gycs/Z7WL/ZVBcJ23I5lD5nBuH95nuoK0?=
 =?us-ascii?Q?fMH62xcoKijCDX0g1pwHgvwGnbyB2WVPlYFheaiEHRkmsP6uJfqK+gby+zOt?=
 =?us-ascii?Q?RGW4/dtuxJy+HvIz37clYsWzyHc9foQYR9OKSbwipkEq6Pduv63iQFw0F8Ev?=
 =?us-ascii?Q?F2rMc801UXMmegBdtFRC4kzlxKsrm7x7J4VnRFKwmGxSg0eeCI5KLmuokG2h?=
 =?us-ascii?Q?nGrfZQf6kqxQaA6Duo956KXqZ1o+X6GMZn1bJYOP83rxE43IzWfx82/bn/Hz?=
 =?us-ascii?Q?8r1kYgkKn+MncNUi8IK01jHP3WRyL94G+mnGuUsLGfDRhKLWw9K41YS4fkrI?=
 =?us-ascii?Q?u0fiI9stuMWZXBfIzEWn9ajfKs0PqfeIzmQAie1rsf9qH4WeMfIqifNaIxd8?=
 =?us-ascii?Q?Dmb5HvZfZAVFNO/u43GRa4vfm+ONBVuXzlyIkArv9vUyOnkNrknWK9rjqfil?=
 =?us-ascii?Q?bmijfnAZLhpKE4wjX9eDQUS/pquE17otNTxYitO2fvPa7BntuR3V1gjoZBYX?=
 =?us-ascii?Q?Z4BNeVCIDOK9I+Nh9NNNBeQApHQYzN+5sRIUB/A29XLdSluVZY2vb8oTTdIL?=
 =?us-ascii?Q?o8zEFXXcF2j5Kn0YkwjvSKNNz1tKSkqXJ01C2Eo0G0uY5+F4k6RuF8d1ma6O?=
 =?us-ascii?Q?4s1KF25fCkdzrwnt++qAF/9DpYHDhn7g8SzGuOl+blFtwtoodIAfT3ES8AC1?=
 =?us-ascii?Q?WTRiWoeQ+3vjuMCI7cwEvxtFIMiI3IcAJS0PXFc/IZ7E9cFWbj5aK04CQt6q?=
 =?us-ascii?Q?dpTUxHDPEeS0g0h19VJZlfGrlZgOX2WpU9VxF3mr5ouXnb36vm1zbsNdKG7w?=
 =?us-ascii?Q?SY74+Z4lkvRARi8e3jgTWLZQJ8OCgW2tl1JL+hr3dyjzCtgY+MDwau2bVg2y?=
 =?us-ascii?Q?OcfZMnlrgUaAyOQRcXEGO7KkZB+tFDw5o00LddAK7V+1KDfnusneNh3mxr7F?=
 =?us-ascii?Q?loK1ARf7gUXLMXVP8mkfHc8P3CmeEjbI1Xri0T0QOWtGAY3BsmXiLLqX5XtR?=
 =?us-ascii?Q?143qFmDbsB4TiL1QYYqa00wNjpsDfkenEIZ8P4T1oi5QbFlIuZczsA2ELU5X?=
 =?us-ascii?Q?bkKhcCKeG3NkcDkJc8rgp+3BiNAcNTWoxdrliEQvE9lVUudo6KN7GSYkg6n9?=
 =?us-ascii?Q?tE7QL0Hoq5l0sV/zj9Pf7Q8oii7hvLVgsmyzhiX/7TVcWgLoqubDBVpiGSUf?=
 =?us-ascii?Q?GrvjJDwQ7o4BVvjgU0E3UB23VaKgGKKx9Xb/pQlpFHPu6f4lZZ/RoC5GfGss?=
 =?us-ascii?Q?XHTO5EdQ0wcudYnOXIP3Qwu/MfIY18AWT6GL39ImfDIyx8gSGzJk4WDJRTtR?=
 =?us-ascii?Q?AU17El6plrIjrpLLw6lIec3CB2E=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8685568-f2c7-45f4-473b-08d9b753f669
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:29:09.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tatz5AZuca8erRA6CegRvIuiQJoDobkAuY6Om7GzSLE6RIGZ5xYjGqImW+X8dpfCIk32jHNuUHrS2FeaJHRNSobYyp/1DuZ7aRXNm/XWzbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing felix devices all have an initialized pcs array. Future devices
might not, so running a NULL check on the array before dereferencing it
will allow those future drivers to not crash at this point

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0e102caddb73..4ead3ebe947b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -828,7 +828,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.25.1

