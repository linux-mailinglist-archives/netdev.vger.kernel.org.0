Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCFD51B646
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbiEEDGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240491AbiEEDGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:06:19 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2108.outbound.protection.outlook.com [40.107.117.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F4A245A7;
        Wed,  4 May 2022 20:02:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVjkvekQFgpRMYtnJJNfI9ep8sAvIG4nFjgjEvQ1W+JW0196RSDFIgzJ2J1uxKhDg6pWHzweXlJnyDwoyqJP3yI5lT33YndJgjktZguJUwIi6H3RayhC/iKwTYBrtPu2zVSTRuwWZidztmPRnsnuHxDTFUT7XIBXQmI5EKXg/2seNl3+m9Ts6MuK9fLX3oy+20T7sNQKRnAn1wBTrX/vuP2ATSn95kDvI+rPQZUUVSkredl9Y2PIoy9m6ZULUoMLRb+fBUyDBRD3ugapjlAMWhL912gDnbEISQO17ZsL6Zp8czTmdih39Cvd8ysDzyERUIHGzjoAAOey3HJgES2MaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlBQDYDt+sTbID8ZwDzg0uoa+LpLWoDFST6Oempcp0o=;
 b=T+W0B5BdRpXw2XcK2wZb7Af0Nay6Pjqe1aUe8bc39js0PgPfyPafetxGeDPF61Kp9wtimg5AiHq0rIFM2orcojF+DZ9kLPNZcx64eJhgs74mNXg+u5G3fqWhodbJRTihAr+lMcSsfecaXwcDoLBA4gGcDRl0kZUTF7N0X9eQ9mPsKQGIZvAN66xIK69u+HOWSRmG3mrYKKhjBLf+g4pqnvHNjEzLJOOT4j9w6vV2uMOivCM8RnrEo97hLJKqtTOHcTZ2Z0xIVHvLxH7+tKtLJ/P7uQICoPSRnNu/pUeN4YD05IcQ+AbJilsZrOMM4fT8q/w8bBH+qip5nuYa8n4ZlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlBQDYDt+sTbID8ZwDzg0uoa+LpLWoDFST6Oempcp0o=;
 b=IMn3Dmmz21lXR50Zvo6eOJ0DSXKTlyUkMF8dAMbxH3pQUhU4h/C30lOjrFUJJvE6wT1R89S9VeT5rFdyN9rTEHpLQXbhP8RlZT9/VgRXQZb5oKvA8+TGLcsRWwLrrDa8xU/+5crjNAMFecQBiMDv9sbbS0SSftpumB2IXUYxfZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SI2PR06MB4506.apcprd06.prod.outlook.com (2603:1096:4:156::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Thu, 5 May 2022 03:02:35 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5186.028; Thu, 5 May 2022
 03:02:35 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: phy: micrel: Remove unnecessary comparison in lan8814_handle_interrupt
Date:   Thu,  5 May 2022 11:02:17 +0800
Message-Id: <20220505030217.1651422-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0181.apcprd02.prod.outlook.com
 (2603:1096:201:21::17) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4469903a-25ee-4093-b3b5-08da2e43b405
X-MS-TrafficTypeDiagnostic: SI2PR06MB4506:EE_
X-Microsoft-Antispam-PRVS: <SI2PR06MB45064A025F8A3B897EF3FF9FABC29@SI2PR06MB4506.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KkX2O19w55UrUyZYELaJsKM6pTDGHgEOUj6iAJA0/FS0W3ICN9NGKzGhMvLXcBRg8Y8JebGY8/JmC0iZiYnZxHkccF2cXMVNKIVy9syQ5NP7IUG3H8aMeSoQ48FzT+l7RmQmpgWmr3P2ldT/JN30qA76BIGdZDJje+GVMLIsK+0JKK9X8PkLhnwgBoLFwORse5OT606e4YSButQkVGogBPs/msZpi3zgv6M+AYwQwGtD8X+o1wFGHTmqKdPwqFGi+1CqlqJ7Pg+qYGzEkGdTTwDrK8SdTGVgti98wP1qYN0FFBUyUpgGxIIY3li/Y1ggtRCbkNihFYly0fvYiEiXqZveGSDI5617nXmAWQEFUQarwJW5kISbKEJ4iFse9arPmoxrof7DSnAKSdtdKxjxzn+P6+wvS+shBPeGcfG1fjiqB/OMX0MVb0+UryK/Y/s76Bnl1+s79QiKbiZ479nxKe1hoXQ2FacPhfwxO1DeD+Zd/Dvc5qaVlN9Y8ev6nHewiLj52aFQpSqY7uwnHDf/3smkOS0wKIK6WcDYYdvlG47aozIHYZfdtR98MYGt110nYBqojVN5nceAet6XxudU1sb2E8FneLpc+qeWj07zWdFrgY0fb8heF3vUKwUaSVwcmqvwxeLAG+IEu2RuZj3GLepQSzamyRkuZdWPdgB0vTEHlaR9EpcQhSJILTbCu6BMeGQSiCWiBvXq+dO40ZI+MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6512007)(26005)(2906002)(36756003)(6506007)(1076003)(186003)(316002)(83380400001)(8936002)(6486002)(6666004)(110136005)(38100700002)(38350700002)(52116002)(107886003)(2616005)(5660300002)(66556008)(4326008)(8676002)(66476007)(66946007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UAJ/PoNeChlc7hQk9XP2v9h73kdwBDjZCXo+HD0J7pmK6Hi3oRlzOI8JvCPj?=
 =?us-ascii?Q?T0roCHOLiH6wNU4QTvjRLNjS1dzWrfCfDkISwuee8QhIJOVGA1ESPrZ6P2uT?=
 =?us-ascii?Q?LHCTKZpJYRJhN3wIzqHX/dcHPSYttT9ZDJYV8W4f3R4myPFVUuj7DIgUVmFv?=
 =?us-ascii?Q?0d52pfYIohJg+x1La0Rj4vfQGQTfyDnqKIyho9bz6cdZOWG0+89w+BV7IM0Q?=
 =?us-ascii?Q?8K3zY2YB+AuyRLfxg7PSpZnrI/3w+I/Y41hWkpn+5XpyZUr9/ZyIwioda9vh?=
 =?us-ascii?Q?0UfjgASxPl5dONblpEudmLXlsXj7U6fpPove5THc5OZzdOvIYCe/+YBQPYU2?=
 =?us-ascii?Q?tfZHw2vBKyhmGYcmW4tKiHNF9eKanP5BjsUF3hE5dOBqEo0jNm/7/Ae7cb/c?=
 =?us-ascii?Q?p/c35z2Ywh4WzkkUTu0HfoIjZmYnzg/sSOvhDM2TIcyA716+CnNqBE9vkXjT?=
 =?us-ascii?Q?1dZfFkA4EjJJbcR7euTNd9xagxNnXeoPOl+kARPNadJhWCohEjYAql+7ELhd?=
 =?us-ascii?Q?hbbWZBn7ZQCL3DASh+bSMpi/+j2P3vfeOhY2+2qTTEOTN6yg/iY2GO49vP9G?=
 =?us-ascii?Q?lqBCIiHTU+yB7PKIbAKXh4WvdELyS5wMASL9GBq+7UXiHn9zPsaAr5XgKMpt?=
 =?us-ascii?Q?CE6b8RGWb36maRrRscDoSZqhxuLvA3ItfJ9pfrc8AYskluSgiN/gjny6KjqF?=
 =?us-ascii?Q?g19kyJ+OzOeWjKPumkR+rHcrW8hwzJ3TnPP4Y5OQ5uMCQepMVW1tx8ImZ3Xd?=
 =?us-ascii?Q?nIFuAWj6XbEuymbluapSBoDklic//ODCleHwtK799SSjCXHNDG9leM7VADXk?=
 =?us-ascii?Q?z0mNX114qcT7hkd5mTuPyYsYh4y6rgen7dlGzpkgAlLpqd6fgBzXxu5cYT2r?=
 =?us-ascii?Q?1YZ3gyyQplMMRIyIM72UA6S8BuPbmbK9zCrZWswQej6f0GATrplWDMsoLhrQ?=
 =?us-ascii?Q?3/1cGpVnwOsHXuWY5Wq0MuzXCBRaKBzP7PanC9QqHvOwG2flO7W3FZQs5WZl?=
 =?us-ascii?Q?aW3voC1ZXrl6FJ3jFCHNpATvXhOzpNXxzlFXTK4PDkWM4UIXsholfjFVL9hd?=
 =?us-ascii?Q?1l7LAjL1VEScE3kU5l0ZXXPj/6ovalW32VIwKjUoz722n6obsLJfx6ePoapr?=
 =?us-ascii?Q?tgbX7sDufnqmEaqOR9D5jWF+cFm7+FIYT3n/O5AWOtvYLF4YyzAup90SBqMU?=
 =?us-ascii?Q?zwtIFrt4u7bXukI3FCYTx3vZ8I7Nm+YXJanV2tuKFMX6JtJI37+CnlD3FsCy?=
 =?us-ascii?Q?G1RRUfi+Zzvtw4FUmRq3XuUA6toTgqEHJ/hHdrFOoJswMWGmloT1d1pjOowa?=
 =?us-ascii?Q?SkNvk4n62ZwUVM7dwb3MrHvsNrGKY+3EqXztGmp4z/kMTCJb50NKps2zvMbW?=
 =?us-ascii?Q?N0C16inPYOK+1kllLW25XvgzcSy1fQa/CHZB5irUhe1JvVIfR14sl+cqHak8?=
 =?us-ascii?Q?13cgTB55it7dkIFLvBPc16pvqa3UvPVJ+UlTLdrZCLyehKiZsvLPULugijvx?=
 =?us-ascii?Q?AsmhrveSacobLGX133UY4S0VaeDK95E2QJ7vG+caQyHbine6XoJ2v5ApwEV1?=
 =?us-ascii?Q?wbHJK27BW5EbkEmIS2xH+zKCLu5vq8LWAzSM9xsN2geLV9BvrpEjsTa89bZO?=
 =?us-ascii?Q?yL9OEZDI0UnKhMxmNW/qcOrCz5E6DI7SGinhlsfcmIQC1W92cYTZEVXdkHT5?=
 =?us-ascii?Q?jzhY9xRpQ+xIoPm2KQj0M5xUGv+/GfJAM89NkHIVVlPR2gEBcx5KsiBFj+lG?=
 =?us-ascii?Q?NtY/z6V46Q=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4469903a-25ee-4093-b3b5-08da2e43b405
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 03:02:34.8992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aB3ffA8O38qQfjqGuMUnSTAAnvrlManMXApXX8dQCKd8jd3FgV50hHfQ5WpX1jcOhap6S2zeGM4IFD4Rf/r6sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4506
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/phy/micrel.c:2679:6-20: WARNING: Unsigned expression compared with zero: tsu_irq_status > 0

Remove unnecessary comparison to make code better.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/phy/micrel.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 685a0ab5453c..6820882be59b 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2676,11 +2676,10 @@ static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 		tsu_irq_status = lanphy_read_page_reg(phydev, 4,
 						      LAN8814_INTR_STS_REG);
 
-		if (tsu_irq_status > 0 &&
-		    (tsu_irq_status & (LAN8814_INTR_STS_REG_1588_TSU0_ |
-				       LAN8814_INTR_STS_REG_1588_TSU1_ |
-				       LAN8814_INTR_STS_REG_1588_TSU2_ |
-				       LAN8814_INTR_STS_REG_1588_TSU3_)))
+		if (tsu_irq_status & (LAN8814_INTR_STS_REG_1588_TSU0_ |
+				      LAN8814_INTR_STS_REG_1588_TSU1_ |
+				      LAN8814_INTR_STS_REG_1588_TSU2_ |
+				      LAN8814_INTR_STS_REG_1588_TSU3_))
 			lan8814_handle_ptp_interrupt(phydev);
 		else
 			break;
-- 
2.36.0

