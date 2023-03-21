Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB676C26C8
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCUBG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCUBGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:06:24 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215311A65C;
        Mon, 20 Mar 2023 18:05:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWVId88W4Pa179tgAARtrLm6v9j8u5dbAsi/LMtkQSkl2WAy/fpfGGxaQRQsC+DKVI4SMbJVQKj5qjnE7DQFNQHAZtiTQ38z9bw9T8gr6qt7iqiXN+QwNy5ZNKMP3XjvDHJ+auaFkIBuOb81Y+KwIcVf3sPspIIH1o3X6xEZs6SJD8NYUjGHly4LRUKmAqmovQXpcMznhUj7wCkWzVbZv3FsoskdLBnm/Oks/PW9H8w6JCNsvDRr/w82DYSD2wmgfC6amuvtjwFWHRpp01TUIGGegwdztXLs2tmsEN4ypBFo2FITIAjCIua4S1R0DteXADjsKAqCDy3mFMyrQ675Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ED9U6L90DgyAbqglcH3xbFZnJAyAXXtQhzwSeMTg3MU=;
 b=C26QByNYljoD1cSgnwpXQXM5R61pWTF2ei7utmHgi33Dqn90K4+RJuxBQEzVvjGxfHd+JuqtzY4LorwB7dwI4O5z2Xdl8SMoDz/r4oa9QYAMt68e9REza/DqNbaoUcAwHVOIrzDIzOYhRoSwI5/pD4K+KYmh04L2TYSbc1aHs00kuVNtV9jjjpbSZKuv84rH6Y5q6v0zb4xfmLomZnMZID5bo90eSlKkmQdrd+cf0KcjkrG99ey7/hn8EAwxXi9JqdjFSynvP5GXgpdEb70Q0p/tvC0fwWYFfowlnPzI2O1zCOxpv06lFCcbmcfjkCD3Dto7v1RYebaZ8MtSkhIcLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ED9U6L90DgyAbqglcH3xbFZnJAyAXXtQhzwSeMTg3MU=;
 b=XReC4S7b0oDcYHMJ93fw5oeLAwmJIQ3uzGmsPCgWxgGX5l9sZFCwhEQhrpCKNhx9skbW1i5D/MYHSmxp4DWiL6f1l+jwwezPF5sEk6nCcZqXU5z6I/5tpmrdpTsloHYoLgr1ZYODi9cN3Z9RlHh0ZPWTkugLJ9I1UsG80AHsKms=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7911.eurprd04.prod.outlook.com (2603:10a6:20b:28b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 01:03:41 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 01:03:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 3/3] net: mscc: ocelot: add TX_MM_HOLD to ocelot_mm_stats_layout
Date:   Tue, 21 Mar 2023 03:03:25 +0200
Message-Id: <20230321010325.897817-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230321010325.897817-1-vladimir.oltean@nxp.com>
References: <20230321010325.897817-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0046.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::27) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e8431e-bdaa-435b-a4c0-08db29a81c9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xe0R4Qm3GC1tXAlkOTMIl/ZhEohQeR7qOy3ytnHfS2hBHPHZLYiQ8a5zvO5jTrHRy52+H+WlQhwdO4xj6IQuc6inWIbcSHI105x99n4KRg0fhKhHaJg/8v14gR4zFjBUvgNI2MXJB2zMXhvXP7m36Ds8WEeXgHclCRh7UqFD3u0DE73uB3fU87DPQd8xCQNEpw31BTTfkWWsx/WlJpQ30YkOcTpEx1YdWHinDIggUUq8vk6b7tfoIlrCfuZRMezHzCCVrAfegmCC49hyF1/ENewXs/nScVNdMzRyEE1YBAvoaO4WsjWVHxQh+AJpIZbldTOJr+/wEzBN2m1uLRng/+wq12QcYmbXFxToYnLjt1NCqzG/mWB1UtT7R1brtvfu/+kEqpFJMANFNyICnWOoeas40m+O4aoxmRm1O7CjmGZZtzx1qe+hXADtEhs/UnCcm7eqUbkHVUHuYBgiEozr8/oJNjd6TIiOWI5ZeEohchQ+ihlf1b2554o1YCxicNPlOFjD8j+/ls/+wZ+IDEcFNYfxGCkpn7zqDz0+xyWOHkpEWUjMx2lxD8sHbkSNjBzqBkxe0D9VnZk0Q3ButPAhHNdcqlsULffSYH+LwIs9BkaDycP4wOqLdiPH+Jv0qP2BKiuhodBvRhgbGNTzRr/WTRrvVmTjw4MARbPwydFK+lEfWT0In8urZXnp1sIZZhgQ3MGiq8rz3Qd4nxvyTm8BlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199018)(2616005)(54906003)(86362001)(38100700002)(38350700002)(8936002)(4326008)(8676002)(66476007)(66556008)(36756003)(6916009)(66946007)(2906002)(44832011)(41300700001)(5660300002)(186003)(1076003)(26005)(52116002)(6486002)(6506007)(478600001)(6512007)(316002)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CYV5SGKHlI9ZLq2z1QeuHIMvA7n1j4kasUU6oPtroO/mUis1e1tBT/XxAA/u?=
 =?us-ascii?Q?u7UWt/aaK/rXLExPcgC/UQ1XCDHXx4HDHol+2uOnf2PnXYWlvaRB5BZV1l1c?=
 =?us-ascii?Q?03Wr9oA4bukWsm90PjU9R9au9j+5pviMqwU48inufrtzAi9EjFn1INto3z12?=
 =?us-ascii?Q?oqE+pb5hFTPJMUsBOxMVguYB3gORr6OoVV3oCasWePBvNQ5yEhyF9/xknRk1?=
 =?us-ascii?Q?piSeZl9Aj4DQnco502LgbVz21jUQYDOAjSaQrHSh+agk+NmIpMDBPJdHZ5MP?=
 =?us-ascii?Q?A9iYfEgAxcFK8mGd9s2U8KYz1oOdCK5KJ51NedkGONCJpyDiTT4TVauUOUpL?=
 =?us-ascii?Q?8aWAY21TKvbGaUsgWZZCXmzqxscaBZCdK8v18FG5un2tz4OF/1J2wrF/gBXp?=
 =?us-ascii?Q?j9OJlX4gfOQki4isiePpRN8c9rzwoh0IHkUUpAeqIXCZrXCIe/PytxVx51fb?=
 =?us-ascii?Q?BsnBP+6eP+R/vpj8YMHP2L12+iEa6+RhSM6pysmuxs7beChctJzKyoNNoOjU?=
 =?us-ascii?Q?WG0fKs9zuZwIcmlUiKZjFYYOJxN5lkKTGrs5gAGA7+jGKtsf9iuK7W6n1g2X?=
 =?us-ascii?Q?lQsvTXZUjXhrgHDq7h/OGsCk0k17LBv/flGl5kwJ2IPzjf0DfyI4fqhIw6lS?=
 =?us-ascii?Q?pW4lQHfzxfm0Lw3/79qPOUz+cONplwFz6jRkajEh7REVZpCFg8j79+1XPUek?=
 =?us-ascii?Q?Vao5r+cX5y3pRdUmvWJ2ljWllVb2TMAIsjwmqylb8tJbR7QgdJus2YydBYqR?=
 =?us-ascii?Q?ViJQpNAdjH680ydi/GUYhDioPmsLnH5DFgiFwqaAcdIRcSV29Q8ftE7KnfUl?=
 =?us-ascii?Q?xb4f7bYiUfSxB0+s8vRJlaqgIU0V21MrMJ9SfD5spoofSm/ejOC7IR5+sHRn?=
 =?us-ascii?Q?5wFK/4E27MLFdKeB/TFuWFfVghns4tdlHIEC1rNgvHCnZ3IiyDGhjAFA5+b1?=
 =?us-ascii?Q?D/Pnem9IzKtw21oALoTbHTulGhDcaceh5gcYYGQuUggagW/IwSvlUyzt2Ro6?=
 =?us-ascii?Q?N0D0LlLI6tec2Xan35CJKgxowlMps2ubtZGDDVJwbOqb5Mud4hLLQADrRKCl?=
 =?us-ascii?Q?QrfjNxvkc42C/v1F1nX8GT5K/Nwgdik3R3RWlyTl44v0bNasgchjiAFu13wV?=
 =?us-ascii?Q?L7iWzTy9qdLIzlMUnhubXDMOCYMyxcU4goOtIN26dtD4McrETC7nicz8Is+L?=
 =?us-ascii?Q?vNX+GD4achREda9gm73GGG5Caxy2y0UWwxqLFBJicgGYDJfRbY6ufNXkxexc?=
 =?us-ascii?Q?/Cdq21Y0SMuFCxaqawk0gUKCrhqEL/X/2sWDygKJRKtSw3ur+2Fzuv8Z5qC9?=
 =?us-ascii?Q?lS+jaYyYY191BLWuDenIhM4fZI00CkrL2vLcbZttvdTgxIuSjyinREnmk3AW?=
 =?us-ascii?Q?5zziBWxDpYrudDQ5JCs8rwBqftibiPDrIrLAvn4geV+ErhUWM7gbHUWx9qVy?=
 =?us-ascii?Q?DslJdC5qe0vTW6uGBIw7bpbmDB2ZZ3WRFJKxvMJSNETFJy0Mj1/jVL4XAjH9?=
 =?us-ascii?Q?aHSzymE++VCBbCXz6252aBWV1WRQbhNjrCQrKzGhidcQ+vBx28zGpf7s3u1D?=
 =?us-ascii?Q?utM25uUKVSI6Wx+5SO9BthCBXSz7gmAfIgYfTgVDmTUHNzDrV4FYZf6ZoQSU?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e8431e-bdaa-435b-a4c0-08db29a81c9b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 01:03:41.5982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jVMiIV3jmb5GlBBXmXb8Cf01C/QUx+d8tLYVsS5pJ92RFR/PSc+9eKJiXGVsJ16JV/1TapM/C0z8nXhUVbYqPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lack of a definition for this counter is what initially prompted me
to investigate a problem which really manifested itself as the previous
change, "net: mscc: ocelot: fix transfer from region->buf to ocelot->stats".

When TX_MM_HOLD is defined in enum ocelot_stat but not in struct
ocelot_stat_layout ocelot_mm_stats_layout, this creates a hole, which
due to the aforementioned bug, makes all counters following TX_MM_HOLD
be recorded off by one compared to their correct position. So for
example, a non-zero TX_PMAC_OCTETS would be reported as TX_MERGE_FRAGMENTS,
TX_PMAC_UNICAST would be reported as TX_PMAC_OCTETS, TX_PMAC_64 would be
reported as TX_PMAC_PAUSE, etc etc. This is because the size of the hole
(1) is much smaller than the size of the region, so the phenomenon where
the stats are off-by-one, rather than lost, prevails.

However, the phenomenon where stats are lost can be seen too, for
example with DROP_LOCAL, which is at the beginning of its own region
(offset 0x000400 vs the previous 0x0002b0 constitutes a discontinuity).
This is also reported as off by one and saved to TX_PMAC_1527_MAX, but
that counter is not reported to the unstructured "ethtool -S", as
opposed to DROP_LOCAL which is (as "drop_local").

Fixes: ab3f97a9610a ("net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index f18371154475..d0e6cd8dbe5c 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -274,6 +274,7 @@ static const struct ocelot_stat_layout ocelot_mm_stats_layout[OCELOT_NUM_STATS]
 	OCELOT_STAT(RX_ASSEMBLY_OK),
 	OCELOT_STAT(RX_MERGE_FRAGMENTS),
 	OCELOT_STAT(TX_MERGE_FRAGMENTS),
+	OCELOT_STAT(TX_MM_HOLD),
 	OCELOT_STAT(RX_PMAC_OCTETS),
 	OCELOT_STAT(RX_PMAC_UNICAST),
 	OCELOT_STAT(RX_PMAC_MULTICAST),
-- 
2.34.1

