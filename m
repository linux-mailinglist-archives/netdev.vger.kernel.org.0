Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0939E37356F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 09:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhEEHRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 03:17:10 -0400
Received: from mail-vi1eur05on2105.outbound.protection.outlook.com ([40.107.21.105]:24607
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229482AbhEEHRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 03:17:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZuAZbw+dWFO9AUgPAEUqs3TW3gwdau4FAwczh8Pjfg5ut0oU2zXl2mOKK9sbm2LvZ+fq4OWJLD2nVlZtp5r8wXbm8dkVKNczhN7A12Pc+TESdX0v8yPXXkKKM05VL3qQ8xBIP2MjDmMCdhvm1+vFY8dUCbr1oZjeNLqYCQt/XeBJ6WHO36WqkbDeBuFwcOAw1xiCWj3cG5SN7NJ0ADCS4D9nn67IKbeQb6FRymRbRzhLBPrjudFJFbKQoIuAwBu+TUMD9b3vsRhTb6aY5zR84FIOglxkgr0gTgozZ2Gv/iCOw5SoLgi9IorOAEchwQ/pImYiQJAVWiCol+uyRTdp8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cg9rmdFCTOIB7WTfLbkh2B8I2UtSTFm5id2jLVgc+Cc=;
 b=mDEC+1G5IrggiBD2mhUOvUAUeh1gvnoUJOI9YQ3Tth1VYDfMO0sfkpy+kTXsZke9tJuhRVojpD4WRfJu6USknVn7pmAOMH7emzQvWTxEJg14xWbhozMo+QVOZVdJLchpwRyuMPkliuk+68d2kagaoG8kgd9lLm2ODZaim3Mf3nKfPWIr9s0bqXZ8yrtyB/z1dJXqoCmdvdzySxE/I07a3QHeccNWjfIoHreVi7r+ZrRjssKCKWAknoiHpeevGxKxPPOtWHPeZKmH05MNzlsQw5ktN+Jl/TaO0XCjiXMafAgXRe3irCHtwWVdKLXuTqrMAoXkXY1V2usDw/lTzsLc/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cg9rmdFCTOIB7WTfLbkh2B8I2UtSTFm5id2jLVgc+Cc=;
 b=ZkUhzOtxZdKpqcNmbY7bC8MXU9modnR5skemD+4AO9J1tap3rUx+07NL6HZOkQUHCNmwlfbhmnNNo/CEFz6EytX5PMOlLfHY7R63Np5JakKSY8uxDZi3MgOk/AAdxV1lZxat+mpb6Txi41CpD8YQt3C+4STHQ4GLhQrFGMp8VLQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM8PR10MB3985.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 5 May
 2021 07:14:17 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4108.024; Wed, 5 May 2021
 07:14:17 +0000
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH v2] can: mcp251x: Fix resume from sleep before interface was
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
Message-ID: <17d5d714-b468-482f-f37a-482e3d6df84e@kontron.de>
Date:   Wed, 5 May 2021 09:14:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.142.67.208]
X-ClientProxiedBy: AM6PR01CA0069.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::46) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (46.142.67.208) by AM6PR01CA0069.eurprd01.prod.exchangelabs.com (2603:10a6:20b:e0::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 5 May 2021 07:14:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3ed74d2-67f0-416d-a0b1-08d90f95651b
X-MS-TrafficTypeDiagnostic: AM8PR10MB3985:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR10MB39858C454751DF6B45345EF8E9599@AM8PR10MB3985.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JeHTPD0TZREsyWfxDG+l4gLqaZWW8xQSv3FCE2vmbcroH3S6a+TOLdZhKhqJDuy3J+nmGZ0tAaLAX90lk3r7H9UpzKWis2DPsizfbpjHuHI+NSG5IdkYDh74dRj+q8sogPKKYuppZdo2DF15UDCdMCx7lTlXe4nErIitWKzGS3mm/89VyvaDd7kX3LSFAUDwhAzIjAWjY5kkFCwodQddYLfNHW03Y7BEya3+UOdXumtw0vM43LPGzpE4LkKwfj/VUkHdbwL06JvezCXJ+6Dy5bzLhZB7g1lKRuq7YR+ii0EvoXAaKJG1iubKjuXK/tcMXFtX3m9QAZM/qz/tPeC52TOTAS+aLeeyrVrSichJ+qialQar+SQ5l9+fP6voCMxF0rp0J8wkGttI++75DJONyjo3/lviCGGYl/n6AU60YLq8fYlIy4AORRg/jKOv1ajAYiBbtj/FbTfYou2cM7airj0xc/JYl0RslA8R0Z6zY4vw79yhvp/ErBKG4hdfRPjeDKc3quDg0rEE7Ojy8+TAVCFpg30DPd5SIKLhFuVv0/w/o/NAUqPRMklbXPpKQ+5FPUGb1Eo0T2s/VE2jYDp3NNCdm+ygIvjOHDDPn7Wpyvqs4lI59ARFNt4zzuH9LGQJOjLg3/LdnZQUqprUgOFqpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39850400004)(956004)(2616005)(16576012)(5660300002)(83380400001)(36756003)(8936002)(6486002)(7416002)(316002)(478600001)(186003)(44832011)(4326008)(2906002)(31696002)(86362001)(31686004)(16526019)(8676002)(38100700002)(26005)(66946007)(66476007)(66556008)(110136005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?G55Ni1hdVu3nVsEnF7lXehaGe2J3ahXENh9WfcrTdIWoanpYHIMo7LYC?=
 =?Windows-1252?Q?dm7HqZ19aY5SfbGe3X/3K5Pss+uubSJ/9Fr/3YJlr8GwyYaejeqXZ3b+?=
 =?Windows-1252?Q?cqQalaaSEkLBvH2L4ZpjKmeH3TSy3sbWmPChct2fx49+jJ91Gq0tei47?=
 =?Windows-1252?Q?wpLzBCNdvzeOHE5LQYsYR7lcdkjLnRW20OzW9qNM93zy2spiGr4Kzb8n?=
 =?Windows-1252?Q?30c+mOAUFWRv+X+BgGOyQoMGY657MD64Meg9tMHF6EWMHNFcJcNud3Ri?=
 =?Windows-1252?Q?tncw79iPDxFRY23MK54W41eQC1qtiUPqaaM7Tcw2wMPwhIlu6Qrcyjfv?=
 =?Windows-1252?Q?HmrHutKrpY8dBc5+2t44XR/efP4Ncap24hxrv6BEeq5AUG68V+OTUqys?=
 =?Windows-1252?Q?VZmCGx2mWilv3j+F7649Zd9VCVmP1fge6Q3KtNRpBachGvD/GN3V0qac?=
 =?Windows-1252?Q?aH+FyslhM200hQpkihuRmc0oR9XvpC9R9M/eTUksoaW3LH8+4CmecWDo?=
 =?Windows-1252?Q?sBmaKU0gXDyLqJJWhn6KqtNwC3nLqhAptb5dNY4lRs0igjTZ2eQWGgQa?=
 =?Windows-1252?Q?ZQRZjM4imrTr84xOZpAuotWy58hWT7G6hxQ3eZm0xFQCx7fk8ZJvveCs?=
 =?Windows-1252?Q?Ua1fkVJxsM5Jutcu1VowVPGdbxsjht6TzO2YG+2Gru43NbUXhTwuL9vz?=
 =?Windows-1252?Q?6tegBpJfL0qCVyfjUmanO2uEdQRqX2B5ksCgeXfGMA0fBvyLFJyXVzWB?=
 =?Windows-1252?Q?iVCEjT/zB7KdnB5yzS13wzmEvttRwdPMbC3hijH2c4nXGKG1VtmKE3dR?=
 =?Windows-1252?Q?QAl9Y+hnGZ9/xS5Bghihgodlcz7yy4XAej+97u2Rmjv/69bJ9gzC/bFW?=
 =?Windows-1252?Q?KiIqZpRg6RymyDylQoHi/oySh3tWmlM1l/Flh5KY4RXyZbHekhwx5Esj?=
 =?Windows-1252?Q?8aFV8lLH+1hwlFyNRXgOiFk9nEKjwE/cnKJockXsWhaeN5GP1sWNRxdU?=
 =?Windows-1252?Q?AUl22f+F0IH4ImvQ2t84l554pre+lIxE7pBEBp7yOMEUtTRCUNUpN1ps?=
 =?Windows-1252?Q?jMR0r1pzcAJj7cNUYAVybfGs9SToUNoPmGducPBbS17NqhO0dLBYbjMn?=
 =?Windows-1252?Q?9PIrIyGFRmjrbV4K1Aiw161LYyQlOJE31JYwPDFVsL3RUzV17oulpkuT?=
 =?Windows-1252?Q?KQLZ2RPCs03zfBckobXIDhQATXSTkrp/ABTTEpVF1aE0eHx8I4SURZO7?=
 =?Windows-1252?Q?5yvNpEbNXCaUA0AzL3mWaXphmDQeABlst4A1swlt/8KpiWloulS3UVBJ?=
 =?Windows-1252?Q?GK/yZ4rbKvYApew8hDYpqWusX06ehq2egkfTbOiu16L7U0sjdWEIBZii?=
 =?Windows-1252?Q?YVLYPYdC/dHx7TU8MPY4r4mPYgfijW7K3yqeuZIWEnWzUKxqp0yOvz4q?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ed74d2-67f0-416d-a0b1-08d90f95651b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 07:14:17.2088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1P33E6h2qh62ZJ2wYU6cC0MBobvLK/FyTySKFXxsid8AGn2pHoAo5g4s9mUyYHUhnU8ZGk3C1SE4chD+3mhtZuJ9zFLALodpPkGD2cy4OWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB3985
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

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
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
Changes in v2:
  * Remove the out_clean label in mcp251x_open()
  * Add Andy's R-b tag
  * Add 'From' tag

Hi Marc, I'm sending a v2 mainly because I noticed that v1 is missing
the 'From' tag and as my company's mailserver always sends my name
reversed this causes incorrect author information in git. So if possible
you could fix this up. If this is too much work, just leave it as is.
Thanks! 
---
 drivers/net/can/spi/mcp251x.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index a57da43680d8..6f888b771589 100644
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
@@ -1252,7 +1241,6 @@ static int mcp251x_open(struct net_device *net)
 
 out_free_wq:
 	destroy_workqueue(priv->wq);
-out_clean:
 	free_irq(spi->irq, priv);
 	mcp251x_hw_sleep(spi);
 out_close:
@@ -1373,6 +1361,15 @@ static int mcp251x_can_probe(struct spi_device *spi)
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
 
@@ -1417,6 +1414,8 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	return 0;
 
 error_probe:
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
 	mcp251x_power_enable(priv->power, 0);
 
 out_clk:
@@ -1438,6 +1437,9 @@ static int mcp251x_can_remove(struct spi_device *spi)
 
 	mcp251x_power_enable(priv->power, 0);
 
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
+
 	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
-- 
2.25.1


