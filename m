Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D65372D7D
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhEDQCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:02:53 -0400
Received: from mail-eopbgr10128.outbound.protection.outlook.com ([40.107.1.128]:8179
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231485AbhEDQCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 12:02:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTRTD0EzZDPz0kFavSZ3Ug7xj2jIC5Cxkbkuh2Qr3k3OjcR3OQ75he4S+3GfwaZEzuS1tKsxLHaqy/4/4x2L0BIM1+paxPbZ8nau4LkUc0S2m373gVb/vTm51m8McetvN82E3/uKxlQ21LwGhWWe++2r/HiRs2SdAoco5vKlGnCG+X3zRajxih7bNQjSiydi1e3Z1lxsWSc6xGTSWBrlncMjpETMk5+Pf0QdoPmd4V4yHAoU9hMFX+scuVXKn4jG1oJGE9oiAWEqMQhbc00ioQOn2AwoG2ra1B56+iPhL65fYFpGkro9Di5rRgm8Qo7u5rVaFXV+SuDuLFYcA8op4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxZnGbZy607AhhS492k1WB/lGz+EvbftLRhjI25eLKs=;
 b=a2SBPbAuSClVyjIeP+a9Qb8OwcTujZN79MTXyQy2daJbEckp2BY7wGVFB2J3Psfz1q0qhtOSB49V0EeMyfMi3KsAeXuHT2zy/ymdLoc6scVao6ZoTJuumrmnOUyj/a+uq2sJwGhhnh9kZyfdYze3KNiDOzZC5DjSqw6eN0tb5D1/AS5tMGPZylY1UBmjqi3V7C+1K1Cno6N/lTfQFhut55HVgywl6QO01Awn8pVPGNvDn8Uo4SM8X+QGdKc0Ij7x270i72MeMuos0vgTLF4OUE3WUrmomd81EcltdNZ5Gnk6lvVPsfK9uEsk4mLa/YeQcHnkUJFRCh/NNs0Pv/ZgeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxZnGbZy607AhhS492k1WB/lGz+EvbftLRhjI25eLKs=;
 b=UseaFPhcQlPIKHW6VMDRUXh/jyTIA067LWdFjmD1Q86efjI5qiGnOsl/qlE7NrBxvG+Pcko665qcCIjYwOHvqoMATtWkCxk29wiU5N2U/uspX3c8Zt/itLz76yvRM9RFLHa+hTnHpigxEuv7USCMrjjiov3MLJL6fMnkzq/1fcM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3427.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:159::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.40; Tue, 4 May
 2021 16:01:50 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 16:01:50 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
Subject: [PATCH] can: mcp251x: Fix resume from sleep before interface was
 brought up
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        =?UTF-8?Q?Timo_Schl=c3=bc=c3=9fler?= <schluessler@krause.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tim Harvey <tharvey@gateworks.com>
Cc:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <bd466d82-db03-38b1-0a13-86aa124680ea@kontron.de>
Date:   Tue, 4 May 2021 18:01:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.244.177.213]
X-ClientProxiedBy: AM5PR0602CA0017.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::27) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (89.244.177.213) by AM5PR0602CA0017.eurprd06.prod.outlook.com (2603:10a6:203:a3::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Tue, 4 May 2021 16:01:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be6aec2c-17a6-4be6-eb06-08d90f15ed73
X-MS-TrafficTypeDiagnostic: AM0PR10MB3427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB342782FA7032ED0B434BE41AE95A9@AM0PR10MB3427.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HuO2h+0J1H1h8P1MLwtXj/ixd6qMPN2/FZXJbbgMkX8CkogRmXVfqjZVz55lHP8hq/w20wGGk5EFxOSfyqedcnTiaTZyapwHRDiphY+GtgWE26VOSlwBgn2xnt+tNZDKJQWVnUsfpP1oeoTuQCdh4nDTzyYjLXG10Rms3l11sIryLC+uGnzxEDhAEpj3Kjf/Ke7g63hVG9Jngkhm30PzDjQe05eSxVPbc3G3+Rh9f9ivNd8KES+w1vRE2AiUXVPeX23LbcYTC7ICklnVTzYJyxpkqsmk1/0PPSfRiu1Yp+FIxyiCHkRIUfANx7U36PFJ6sJauhk487VWD5FlJUCx03CgG6oap3qDIF8UHA8HRIOuMezN4kDeYKbRrxJ8gKP6yzNgkZ1VfO+MbYS5J/FAdEPGzH2CuWe9eTDzuw4m3YKdEX7LxXd6izG9majfAdOLTOfEyU3rNCiVUMpdDShWPmnw3rIffG0Vjy3kh6XpdeDYzjfjO7P+yRLxjLQrBJ3y0Huk504BHfI+qmxhkPiDsYZj8AKP42uFNMeBtueOeGFjifFzOM5mfiniLa81kVRBsDLXnFr5EB1nBJbK8iWcuzRhCQwRBogQrVHh0M4q4xOWb3xkyYcbPTmrGKQt0Dg78QNBx7oCPPl/dXZyA6y+vL9KYCb0jT7160D/FcxnK09ZPwpn5kyn1X+YlrQhyl6l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(346002)(136003)(366004)(6486002)(16576012)(4326008)(110136005)(36756003)(7416002)(478600001)(31696002)(16526019)(26005)(31686004)(66946007)(66476007)(5660300002)(2906002)(8936002)(83380400001)(8676002)(956004)(316002)(38100700002)(186003)(2616005)(86362001)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?wO5sZecQcdnPMevIll2HI1NVV1GU4exfo7onYjXaLBjxP3C3OSwRrRIx?=
 =?Windows-1252?Q?ZQmaVAtD7QosFcrJA+sGRb6bxe7dkheSBdMKY6FZgxmD5CTbuQJZY3WK?=
 =?Windows-1252?Q?az/1sTXYKlqOPNWXUPMkr6C6sU7lMqB/VvFGDJyBoDkO8EZIImn+DuKO?=
 =?Windows-1252?Q?yaxF8gQWpQDCPTleOqwD2YLu+P3pbxSt+aJV6TPncsISxWsBoHJOlKq1?=
 =?Windows-1252?Q?9yWcMU83PZ10lV8zrSANNQ19+UntWAAbMRbEE/1LC+5welWXZYwp6oh7?=
 =?Windows-1252?Q?odnYBlR6irvLvpHYQ8nMS8WG/na9jOjGhZN6pnI2moNWLP+hWtV2KZsK?=
 =?Windows-1252?Q?I+bx604cEvil7xfMlw5zwsTCdpVGc/MjUTVQiZHHjLRiILfaPe5oekWF?=
 =?Windows-1252?Q?s2ZikxaKjW7Iqn3Z2+gJ0wKr+pWn2u2RPGorHfC1NBQFkuGPvoa2Qq6R?=
 =?Windows-1252?Q?WtmMbtnEAPnEyW7uIiXeaysHxEHBTCxaQbLdPt5TvfpDiJ2owBL3av5r?=
 =?Windows-1252?Q?JXYNn2AMpReg50JgAKNGNHiwc0DHnizLBvszamw4nOsc9WGPPOAbPTKn?=
 =?Windows-1252?Q?UgKOh3u1BB/yHJIztwrAlVr+cOA8Q5e1BJxharDxgfJpFzdX+WAbfFfo?=
 =?Windows-1252?Q?TRi4WiDYAfgPd4hqAkFyZB/C2A1ak+BfzwL8+wXn5iuAOOch7myYGnho?=
 =?Windows-1252?Q?jCFRa5dF9i9rQ8CQcJDCTqzmzKALnAc6vua1OrQy55DBGx9emgj5cSaN?=
 =?Windows-1252?Q?cgF1FxxQscW7U6GkF4gsmWrAezWIKc7UABM7//xOKpLSjIKbTtQHwzuT?=
 =?Windows-1252?Q?UEbeAA+rfRpmnaBX8HDwzKLUa5sSKCzpv44uq1+VAaXXoKBuUuSKmvYU?=
 =?Windows-1252?Q?NhTSbdi0rNSG0hyyDve90TaonF76+SRvFVps0PlfQxtmkdkQSlQV+zY6?=
 =?Windows-1252?Q?LK/u8vN2UkyraBAW/ByDsuKi4eMECXrBBVvTXOQWkcar3ED47mnoSqlR?=
 =?Windows-1252?Q?OR14xv1f1BLR0UDFxw/9zofzqTeEZ01H5RFn87I/62F3bqZrFAwsyI+W?=
 =?Windows-1252?Q?I143S1CKFS7eFVugLujsDq9kIQ3f0jFAfwcAipahljiCbJTodNdXcGbh?=
 =?Windows-1252?Q?BxQg6RfaNVNvXkxKWoR8staaOLAI6GAyJ1rM4j7BOfexRpdXdh0/bt7V?=
 =?Windows-1252?Q?mQHvFge16dSCKD6S5k1UgTdRxggqmArgF3LM81YPzGk+vTmvVmi53m+i?=
 =?Windows-1252?Q?MXR6NBW93EOGWfXXtZ7+bYFNBZ689MFJ2NYq8x/apMj7iOWnPYXFLCJU?=
 =?Windows-1252?Q?+LZ7FGx9S7jlk53hOBcELp+4koDJF7XOJ0AD/BMtGz5RJWf/t9T52ycA?=
 =?Windows-1252?Q?trJu06EFvD34pcmdJfD3Wv1NN2j9jXJM5a72NEcIX/KA3nItoUUsU7wd?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: be6aec2c-17a6-4be6-eb06-08d90f15ed73
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 16:01:50.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auCA48NaAK2it3gXdLOTs03Z85j5p678MtZ+YVec4AJR4OxoUrRvireXEMfR0WNWzTNij59Zk4L12zG8XzDOXR4tmPI6CTKtckFx9+Y7uTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 8ce8c0abcba3 the driver queues work via priv->restart_work when
resuming after suspend, even when the interface was not previously
enabled. This causes a null dereference error as the workqueue is
only allocated and initialized in mcp251x_open().

To fix this we move the workqueue init to mcp251x_can_probe() as
there is no reason to do it later and repeat it whenever
mcp251x_open() is called.

Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 drivers/net/can/spi/mcp251x.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index a57da43680d8..42e8e5791c9f 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -956,8 +956,6 @@ static int mcp251x_stop(struct net_device *net)
 
 	priv->force_quit = 1;
 	free_irq(spi->irq, priv);
-	destroy_workqueue(priv->wq);
-	priv->wq = NULL;
 
 	mutex_lock(&priv->mcp_lock);
 
@@ -1224,15 +1222,6 @@ static int mcp251x_open(struct net_device *net)
 		goto out_close;
 	}
 
-	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
-				   0);
-	if (!priv->wq) {
-		ret = -ENOMEM;
-		goto out_clean;
-	}
-	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
-	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
-
 	ret = mcp251x_hw_wake(spi);
 	if (ret)
 		goto out_free_wq;
@@ -1373,6 +1362,15 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_clk;
 
+	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
+				   0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto out_clk;
+	}
+	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
+	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
+
 	priv->spi = spi;
 	mutex_init(&priv->mcp_lock);
 
@@ -1417,6 +1415,8 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	return 0;
 
 error_probe:
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
 	mcp251x_power_enable(priv->power, 0);
 
 out_clk:
@@ -1438,6 +1438,9 @@ static int mcp251x_can_remove(struct spi_device *spi)
 
 	mcp251x_power_enable(priv->power, 0);
 
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
+
 	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
-- 
2.25.1


