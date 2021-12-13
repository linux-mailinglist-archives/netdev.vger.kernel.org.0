Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5840472628
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 10:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbhLMJtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 04:49:18 -0500
Received: from mail-eopbgr1300112.outbound.protection.outlook.com ([40.107.130.112]:14432
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233475AbhLMJqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 04:46:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqu5VQNLAfyujgFmxbq3lc0Rw9NVdEqxf5mFYSn2NijuIj81xFgZLc1gGiaGOzYhGzU3DUn2Y4sp5F7C7sn26p8qhV2mPoi3oqga805PWMu1jQ0w/18WC6rrri+siwJ8lRTnt/izH+r8939zfQ5Ojs8dbsd1N/7/kRv8gSOu4C3GlKwcPMxJ/VhOEOf7fmq2/JmQ7pNQRfDmFgFrgcAN4/9lcAXxrXp6bmH2cXQc6PBfG6hKrUVWyUUFEVxbtzSjifqcME9VWKC/9iFgSxoyfEQlPAMZ3QUh6rc7LmJV8nCnJTlhJJbOk1ajSLjaQW4BVvEDRiWi5uw8/W6gcpCv0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oq4dffxUDEe3uKsrvW9bgNXZMs5E6XKRnw07iUHTvOY=;
 b=hCYw8M843uyKN8Non6HqpA7X0YvPmLTir03d1DSBVZBuxSdMZRctGuTBr2sIytXXjbDbv2uhNl2RGC0UyD7GE3iuuPdEykp4z33RjpNI7OktaV7ONL3eVL4oFJ7TrLHHA9rfdtNSf0UU1jWRp2ND/Y8+k6Z1PJFgsANOHatdxbFV6rPMRDaDjaKSJYdZpPFtlK3a174M9qPTr65w+wLNQeCwxZaEOHgThOKByW/TmnxZlakkFMEdbT4KqEpSyn/4/gh6RUZH9SIvANnWXHWiGGm4sdH5KareO0gwfMdYHp/ttQLRYtyWmb3GMKg+dqsl4DId0T0d4rWcteQnsCSm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oq4dffxUDEe3uKsrvW9bgNXZMs5E6XKRnw07iUHTvOY=;
 b=HF9uKxMGCVAsBzLv+Cy6Z7+jDW3EhcojcB4Ld4I0Eux2MbFyKVNr0D4yBCY2kLz12LCstpCjJ3cJg6uDf6KaZRut+eLW6cH7eBwUGuEenSwAAGrkKJtH2riq+85kUmUxhu7ASfILGEu9PkMYzCOcFBJdVYGy433nwRVqAxdVLgQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3050.apcprd06.prod.outlook.com (2603:1096:100:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 09:45:01 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396%4]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 09:45:01 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: phy: add missing of_node_put before return
Date:   Mon, 13 Dec 2021 01:44:49 -0800
Message-Id: <1639388689-64038-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0217.apcprd02.prod.outlook.com
 (2603:1096:201:20::29) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcf037e8-64ff-4843-317c-08d9be1d3b46
X-MS-TrafficTypeDiagnostic: SL2PR06MB3050:EE_
X-Microsoft-Antispam-PRVS: <SL2PR06MB30503FBB4DE0B46F6589AFA0BD749@SL2PR06MB3050.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYk/BlImKLcAbNsjKB1QUvKMcA1gxTAAihle2BfbdjlgSN94RaCPII8dDdTBeggaw22a5FMY/0p697TRw4MAIeJCn/5kGnCBvTBVEQ0+HmHJDzoUO8BFHi6jX7TB2dje/sybzCHkx+BU6rvytqq0RxcK6vkdQM/1A5ca9OhTTt/w9HpMkorq0Cnfz525V8E5MwKID20zUak8oOCYknKFtCBHxzE36+EMR1qeKwO5wo6zyxz9tHRsdeOJycYz7fZOPdKyumiwlSxW3GcCGvkO5qxMeUVujefHKWDsCZSg0HmzFbg4N5V1+vV1JSqEbuRtUsF+svoSQmuIJMQ/oCkM60rbrVEWXTi0RmQGntsDzjq+efnjPumGZ70RO6FIMger9ltmV4Hf3rcNve1O6Am982R502Z3jIfv2L4diXxLrS5w9XALe073uKFpczWE/N0FTTXqXeYi8KR8ExNVb4hAYilAvl2Vjw4Maa6RgDgwnC62T1Pv2na3plsrJaYT+Vd0KGXPnB1NF9nk7+DVgAYKT5oxv1jpGs6ZxCdCGI3clSqOU7cQicMoXJbyCvmTdu8m/PWRbbh5+Tw2jiNp1TwSAWtCNlTNT1oDsXaSqYHvQ8cWKgCZDNOn2JwE44CCtH+WRqqXK613yRTuWRT+TSYbLEY4/oce4YUhJvGq1VsOMv6L1bPZf01QtQgIxRE9QbGiu/exufGgnElZPpis+RqSag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(83380400001)(52116002)(6506007)(110136005)(2906002)(316002)(508600001)(26005)(186003)(66946007)(36756003)(107886003)(66476007)(2616005)(66556008)(8936002)(6512007)(8676002)(4326008)(5660300002)(6486002)(38100700002)(4744005)(38350700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XkBHqAV52m5pbA9W0Q9p6e4fHzAUSQRmcCsDT3lLK02atXlqWxzymjNQLSOy?=
 =?us-ascii?Q?I6WWC8j/ylyQsCr5Mkju3sH/KLzzpuQgdYeCiWl/qma0GYq0aasCY5wvkhq5?=
 =?us-ascii?Q?3Kpy9yt3b6Vnib3zLGMD0cKoiuM+zHwfdelY0Z5HIDigRkSPXUbzfPthIikC?=
 =?us-ascii?Q?fKwMi7Z20n2shtPdXB0zaH9iCCb8H3jMMscFFW41pyIagZ2IyN24VE9AY6zu?=
 =?us-ascii?Q?RP6l2w5ozX1C++Sgf6WfpokjWmuP6S9HtjFo4+77WymolJM+41NvDyxamiya?=
 =?us-ascii?Q?l/EmDbH7HEL7O5qsLgJK5pk8KxsO/cCsP8DHYqUJifBSbnQIHR1oXpim4ppm?=
 =?us-ascii?Q?4Eopx1/rUI0jxZtv1FzGqHbb6pvtNEGRzZZnMfROVXlqDfvwTpY4llP61MZW?=
 =?us-ascii?Q?ZFOYuD/MhPHVDrP0p3LPkLfqPeEYcIQno4PZW8gKZz8fa7j97qdkkxWq3tgd?=
 =?us-ascii?Q?G5CgYjQzLGE5p7vjtiJrolTlnzN8GBEofbBJoKAhRi95jpD0caC7LB/QVxa2?=
 =?us-ascii?Q?pTNfamlyuFTTX8RM140woymwSBKOZGxGIMNq4ifSFawceJc7IK+BRylESC7J?=
 =?us-ascii?Q?UmIYxZJmqnyAQ2Etj8GxdXREAdRoLhiQ5/StKONY6YjweIweGHpGfOAoPlWk?=
 =?us-ascii?Q?LRKSB7o5Y8BhLpUymWtDeDQYNI7zi2cqGPxH8XsH6RBZzUhQibSAcoCtt13W?=
 =?us-ascii?Q?yDC+UiMtE0Gdoluihu/QwhW1IL6K3/GAjYmBHZ7l8ojLaAdibb+kjjDcYMJb?=
 =?us-ascii?Q?1zMPl4LAZbmfh+SPXPaW6PtIxAGs2yoQIZSqx2HNtyTglZ0ffnSoo1tHysbC?=
 =?us-ascii?Q?himRHkTpe7b8qJHn9aR7MU/f0BYm+ABxGUOGCqNYmvRupR/rikbf4CGzv/Nt?=
 =?us-ascii?Q?eRLea8i6554WGYLG8vPNa2OM3iSo/Jsh4VQwOLFhITn8rdgS+l8+P7x4fHY4?=
 =?us-ascii?Q?Fb6yybrmo34d8EheEhJJMV0WLXObPbQJF9dzm1qU1tESfpUcTkQyLjrUXEA5?=
 =?us-ascii?Q?+u3EUe61uiaAzG2gSY7EVicNoBYxZhtDMtrYJhthVOSVr3kspPV1kWScvFHo?=
 =?us-ascii?Q?fqipjqkubIE7ZB2740cNT6YqPXz5gvz3BEbIlB/9N1raJoQHOhjvlYlOaEMT?=
 =?us-ascii?Q?ptk0wnt2xb9aa9NTIrmQs5uT3FStCjZ4FGFkfYLP3QpN/uSZp6aqPpBmgve5?=
 =?us-ascii?Q?htdmLMcyAKkycstTX38DNYsjFzfbZzIRbnNHZ+yXEseGSpZ9vHvDYWj7DM4t?=
 =?us-ascii?Q?nRniBv800CDeosQ0piwnwcbKSWgRu+KqndJ08apl9TcGAiH+yTtAaDD2Padi?=
 =?us-ascii?Q?qIccybSq3oPi/mQm4vTo5GPiGW944hu4minGzGRldy7U0xs4Lfu1PwnI9Ahv?=
 =?us-ascii?Q?Bd4HRRNo1tfsNYmLdRqktA/i0PMIgdCXvkye2tE/1l2r/lhmRoRhe8bvGAN2?=
 =?us-ascii?Q?nJZSV/Dnwsgomzd9u//Zq9t2P+ivIPAFFqY4Uxw1iBTpV2XwxS3nMpZI7W1e?=
 =?us-ascii?Q?8BnLmWI+u5n2CIrWmKsWBj4/e3JY5poYhNIQ35oC69GeTf6nO1w6/YjGlx0o?=
 =?us-ascii?Q?UcLd0uga5/A7xvzV0MflOQf15GjNOJWc0j7jzd63pKmS80AgfXgagk2eRiL/?=
 =?us-ascii?Q?bpDLCsRjZ3PXaJDfF7AOirU=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf037e8-64ff-4843-317c-08d9be1d3b46
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 09:45:00.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdNUoPsVCCrLSgUIPGeZsOEh9Dy94hYU44uUIO4ce3jJ6KLxavCRlKyJhNc6O5PkCNraANbTc0InhwpQOBYLxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

Fix following coccicheck warning:
WARNING: Function "for_each_available_child_of_node" 
should have of_node_put() before return.

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/phy/mdio_bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 9b6f2df..3c5e8937
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -462,6 +462,7 @@ static void of_mdiobus_link_mdiodev(struct mii_bus *bus,
 
 		if (addr == mdiodev->addr) {
 			device_set_node(dev, of_fwnode_handle(child));
+			of_node_put(child);
 			return;
 		}
 	}
-- 
2.7.4

