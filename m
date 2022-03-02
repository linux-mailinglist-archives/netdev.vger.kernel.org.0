Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB774C9B3A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbiCBCap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiCBCao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:30:44 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300108.outbound.protection.outlook.com [40.107.130.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DA4A8EE2;
        Tue,  1 Mar 2022 18:30:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGzNoZGU3+l5+219v8uQB3nEI9AXz7PfAA/Bxek3HCdw9+/p+5qa4HJdcuLjN61ziAmNcqEQDEabFJn/opB/fYzbOhDR2CMEK+5f3SFmwwviC/8Di5htUQUF5IcS6dm561l4hcmo8R5msKw3s22i6rqcY5HalrhMtrOsIAR8vLUrD0VJlFJ9RUCxHSzzGM+7kN4zqXjDbcoMPb2rBgP1BpcZwfjhr+2wD9aaTd4boj2/TjNnLljuPxQRX6ssAqOZB0kRC4+wEJujL6rUxXY1MM3yXbuc6TA99OagRTjVxMDBC4ZjCcyn0qrJmRVgPDQzqFMnCbz2zqVHfHFH5CeV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hfpex77UUxkpnx/WicXmrroWr9FfviIWowPmRoFx9vQ=;
 b=cz6FJ7VzpSZovG6TVj7ocv1efHBgjYZx11QyshJIUaZBXNuRvVgTa86e47byycKeFaskDKkkGHk232NQ0fcBX1xRplj0igtpjdUm1EmbdJ/dtoR0dRoQ/NUiH3ULSWnV1kif2YiXRJL+5xNrbOmuszs30KB6G4wxbPBP6zzLz4FKFYO2u24lyTTBhj0rPnSxCPYGCgjrrGNZBSsWFXYj5LJ89JNRiyVnc+anU6eh3zGso6SedUJX4MeGHuiLxygGimqLQWJlf8PVwK61aQ5SEtLo1MuQN7s0/9QbBYBdPBWeHjXgkI8VQSv2ktwTtHfZ9MXh6D57e3+tb9SAn8cZtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hfpex77UUxkpnx/WicXmrroWr9FfviIWowPmRoFx9vQ=;
 b=mr+rfy1al35A+sZYkTX6GEDtSpS0apZlAm4IxGuw1QZ4MDZ6pxnhuLunbR5LzWgm4kyFF3SjaopoboVTbrQKr9O/KVTLk4Dm9OaSEUMzJ8fu1v62tSSu+ByC0x6VCNJBopZJOu+dwS1D3ExCkWfowdsTRGSsQwHjr2CkiNk35AY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SG2PR06MB2698.apcprd06.prod.outlook.com (2603:1096:4:20::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 02:29:46 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 02:29:46 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Joerg Reuter <jreuter@yaina.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH V2 RESEND] net: hamradio: use time_is_after_jiffies() instead of open coding it
Date:   Tue,  1 Mar 2022 18:29:31 -0800
Message-Id: <1646188174-81401-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:203:d0::27) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3a9e276-f576-45ee-e446-08d9fbf48453
X-MS-TrafficTypeDiagnostic: SG2PR06MB2698:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB26983C945A6C1DA92451A724BD039@SG2PR06MB2698.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: irSyz2y+aOu9SkFyN+t3JrotMoM0xLdmmtwdU7441Lzdf3k3wYDcOMyRCrCZJ6oNUn29yn5ktZQLalRTT1WOk5v4w3AoWy2I0Exe+zltz1wHSmksQp4NExNIpPEC0ZhYLWylBHMXlABjlJsnAT6pzHtOPkaG0KV25rqWG9kQokoDhk+7WRn3bqMyHEUZSWuv34m79AJhu42nbTnOPQkeXPz6Ff3Dv8hb0i5xMlsWAH0U+9ia4eWKkTMNkO4cGpiwvo9Yw3ZyjX1njXPYtRel+e4YCG5a9wZxjo01M1l3f9SWtcy7GB+QUglkQfgPqo53GOieZROud9CTHlX1ODJFCalC+39zuTLGKXsC//cRedCMI2gkNYmpIXsWvjrc/6EmpnELuuRs6y6uZgL5LiToYY1BssRJ7BEkBbdJZDIWymPBV3+1HG8pxKLbGTwxmxcXuLfqdJa1Fl2ZvqJj/e9ovu5XYy3Vuzfm481B0hzHNXloLkl0Fspd/NX9Ge4Y8Bj0HDs3/Gm5b8X5eRC6O3HRShtnlsvkMfQy/zQabA/vOOmXlvU53OrkbgXqfMJT2ttv2ZqC1CEDgHN9+hfQDjgXPZKq81zVTdyFQ3pnTwIDTZcRGgCadWjZ0i0JDv4qU3bCCTfrRO3yRkJOLbhCymk+DbqXshqNx7vNVn+WcEkClEt3vOFI9jD6hWfVg9znmuTWWd7/apKXnc/cJqCMc9DPgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2616005)(26005)(66476007)(107886003)(66556008)(66946007)(6486002)(508600001)(83380400001)(36756003)(8676002)(4326008)(186003)(5660300002)(8936002)(52116002)(6512007)(6506007)(6666004)(110136005)(38100700002)(38350700002)(2906002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f165EaHWNbnvpLqEHzD5lcJ5+KUigjOGN93HBI0YaMtZJ5xvQqC5pMPitmEl?=
 =?us-ascii?Q?YisCuLQIFL0NlG5z9HPIje1ljm7mEzZWWXW518KE8cDJHW2Kv6ws4wxX8eHi?=
 =?us-ascii?Q?aJljAxsaJw4K9FyircsvwahxsseBqEjuuD4FvfxOgi6Xb9kppWOkZ7nve73A?=
 =?us-ascii?Q?1pqvYMrEc4WE0frNZb861thP2WaifQTj+6NHsLmq3OtMMKKjQwhFjmPvH0mN?=
 =?us-ascii?Q?bHUgJDu8zVqmIeKtvcvFoF497MRXWEv852rFLpayRySe5e6psJ400BqU/ABq?=
 =?us-ascii?Q?kkmyqApFIkmDOHioLj+n7dwHfWZ0tPIrkYC8CgBRm9lXbKgHFod3/yoB6Tv5?=
 =?us-ascii?Q?+6QhHE35V4HrLJ7ovHEAMnzuCxHOp12z0ybsd/ut7/fc7nO0HyKGG7+VaDfM?=
 =?us-ascii?Q?pNUPWaz4LQJQpRqh9RrRl7Vcz0inQfrdpL4MKwFBBu4VRM1Lb9/KMiav1xwc?=
 =?us-ascii?Q?+k+DgQP5HuuLGiIU0D/qYusRi4ePQ8yqMt+IokuTSQdf8rVCL1uK/TcarA4H?=
 =?us-ascii?Q?pS6wCpTGql7LeNt5eZ1ecq2AFZBjPRcUpvCA1Vs7oQd/tzi+nkp2c+xiGcXc?=
 =?us-ascii?Q?RS0qxLk0a1+G01HX0zbtCBfM38n077J0Pp1CvOXrMbd9jZMPBfXkEGklz6d7?=
 =?us-ascii?Q?rS2NuHmP8mEVH7p8aEb6cs3AVkhyluxP/1JlWJdC/WV2b3DKLtdivr7OXAe1?=
 =?us-ascii?Q?XCnZxuzMFJucb/bkhIhSHyIRJn3DPZfe+S5dc7TB8pVg/MMZogW2KjVR8vMy?=
 =?us-ascii?Q?mbAocubNz31mRNFjdBU0J65YXI3xoW2gFBD/EiKl03SKG6CZdet0qmIybEfd?=
 =?us-ascii?Q?4q9WHUL1bCetMurmKXGyV9YKr+AkU4sivlvMIgshSV2OsIanUFOSJFwFx70t?=
 =?us-ascii?Q?iKEXKWLxw6dGsu2B1vOOGoeYmIq6WRfeN2442cvBSLIhlu3dnsE2O+OQlDhn?=
 =?us-ascii?Q?OFNKQltb8qMn1W6gg4tG8KU15/LqwbhhgaARf5RYzNh//xI3q4h2yO4sWoDw?=
 =?us-ascii?Q?hkWaQd5YskPoytUz5SGetZtFg41WyBNVUdF5VvPIj7PFPW8jG63+jFRpokcr?=
 =?us-ascii?Q?WGNwthagnxkckWOvuLnXx8cYWy03qRaVOEZR7+buSO+/etPyRs8s3zWfGI4f?=
 =?us-ascii?Q?EC8qf7BAWQPifYJediH8RfYTbtT/oE8Z/tM7/UYvxLaoSErnj6a2IIgvKVpl?=
 =?us-ascii?Q?05aJCnggvtPd/kJn/t8Xmxw17Nr2QT7M/rgd4T3U8lTpNx7rtGRYmLRw+6xa?=
 =?us-ascii?Q?myx+8KfjLca/yyn6T3QGQxQAuY3Czesf03pdGlqOhxOGqxwcQTpj0G/WUqm+?=
 =?us-ascii?Q?sozteyxtvFiTg1D6x4yx89HolD4UeK7JtBuBqrBCrMGES8QgI2Tlare+IphG?=
 =?us-ascii?Q?uKou3gVgNr/CPLDQo53e7/B0K7wa1Z98kL/tmNsfzw3c4TUzOji9EMGPjnoO?=
 =?us-ascii?Q?VJ8fBWlnP5J9PF+KfdwCVRbEdtnF14/IrsNgPYwhENWyphlV1CBP+r09K0y4?=
 =?us-ascii?Q?0qQs65sVIrplLo60Tv59iFN76zVl/mCzjbYZiFDeqOIMmhm11HOfXOC+2/T3?=
 =?us-ascii?Q?N+rTN6aIROc5Vz62CfOI2cwsu4wHirogKu/o1Liljmgarn/eqnne49BEn09p?=
 =?us-ascii?Q?LviHc/uqxUMHRBxzmcdhHT8=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a9e276-f576-45ee-e446-08d9fbf48453
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 02:29:46.2349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ke39xS6G6P3c/dl3NzYBvO6850kIL8O6pCVfTL6feaQo7fNcoWozlvww6ujAKmby/vFjE6gy7qRRQwZfmqFDcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2698
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

Use the helper function time_is_{before,after}_jiffies() to improve
code readability.

V2:
add missing ")" at line 1357 which will cause compliation error.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/hamradio/dmascc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index 7e52749..6e7d17a
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -28,6 +28,7 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <linux/uaccess.h>
+#include <linux/jiffies.h>
 #include <net/ax25.h>
 #include "z8530.h"
 
@@ -377,7 +378,7 @@ static int __init dmascc_init(void)
 		udelay(2000000 / TMR_0_HZ);
 
 		/* Timing loop */
-		while (jiffies - time < 13) {
+		while (time_is_after_jiffies(time + 13)) {
 			for (i = 0; i < hw[h].num_devs; i++)
 				if (base[i] && counting[i]) {
 					/* Read back Timer 1: latch; read LSB; read MSB */
@@ -525,7 +526,7 @@ static int __init setup_adapter(int card_base, int type, int n)
 
 	/* Wait and detect IRQ */
 	time = jiffies;
-	while (jiffies - time < 2 + HZ / TMR_0_HZ);
+	while (time_is_after_jiffies(time + 2 + HZ / TMR_0_HZ));
 	irq = probe_irq_off(irqs);
 
 	/* Clear pending interrupt, disable interrupts */
@@ -1353,7 +1354,7 @@ static void es_isr(struct scc_priv *priv)
 		/* Switch state */
 		write_scc(priv, R15, 0);
 		if (priv->tx_count &&
-		    (jiffies - priv->tx_start) < priv->param.txtimeout) {
+		    time_is_after_jiffies(priv->tx_start + priv->param.txtimeout)) {
 			priv->state = TX_PAUSE;
 			start_timer(priv, priv->param.txpause, 0);
 		} else {
-- 
2.7.4

