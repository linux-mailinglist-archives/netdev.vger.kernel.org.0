Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4755A4C619C
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiB1DOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiB1DOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:14:39 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300093.outbound.protection.outlook.com [40.107.130.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85E84666F;
        Sun, 27 Feb 2022 19:14:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sgivx6y99jUt7qqbpiSkXZuuag+DUoTKlS/3BFelPF6Gla8tP9OdH/pQsZmloWbQRf27D4JfgOZBzmEuBTqQwdILvCQHV/iqjQn/tkGiiRxE1C+b8h+oEgdkimgC1keGu9lpcZKleGdg986XrYW1jB0a/AA7Y1XS/XTtUNAqNVzEB4yMqzow0b5G0dVD/so1tCYRNF6URZOGUkr6iaeujv66myFjmbVPt4NI4xwEwrnfjzTmmMLq+DUYBFznLKO4bIkbMH1GhNnEHb8tRiBNc8noKsrmyQrG+jNgfPpBj7NoCGZrSYX1YuS1chImC4IrD5bqmUCJShla2ya3vs5zqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6e919Xz74r7hOP8xmFzFumaG5x8I9K4IcXO+soQah2w=;
 b=NRO+TB3w/r8uArqIsMLJzKPNb7jHzopYpUR97g3zUnJc5j3gbsKwe6VRpSfTu9eikb1F4vGKCcVZ7Cxr+ZPO8JXnV3FWMwqsO/KElYZJjI4B+mtRtX8HlvHQeV8G9vbJEdOUZ+MGCBRwdFIdGHDKJzrx2XKqT/h1ERUbXCfWFAgNcYat2wAbCA21mUDKS0JD9vdmr/iVWQ8gkXTEy/uERBzOPMdfobCnVCZAay2g1EX7CxTNMuWkWidpoQV9gMH2Mu0MLPX7TYzfvUGcN2oG+dbdhFWii/R81gb4zYoltcMVH89xD5WKz636abL0r+1Qw2jzzGTpB/5Vk0f5EpGuEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6e919Xz74r7hOP8xmFzFumaG5x8I9K4IcXO+soQah2w=;
 b=RiSihxYnMlG2HQBIb2gvbUxS+Ad9xz6YgtDMk++3Cwb3vHBgzXayb6xh6f37wwqc8y01ilaZ4mcPFV3sqmko2KiR+eYLuqgQxWja2P9frnnthePhvvL4twzs9za02BL68hwUvhS37KhaeQVdL1Lepdsj/O5zlCdEv5Ka4KlfLZY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by TYAPR06MB2191.apcprd06.prod.outlook.com (2603:1096:404:25::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 03:13:58 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:13:58 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: wan: lmc: use time_is_before_jiffies() instead of open coding it
Date:   Sun, 27 Feb 2022 19:13:48 -0800
Message-Id: <1646018028-61175-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0064.apcprd03.prod.outlook.com
 (2603:1096:202:17::34) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b9b8702-7d83-4d80-2316-08d9fa685c3a
X-MS-TrafficTypeDiagnostic: TYAPR06MB2191:EE_
X-Microsoft-Antispam-PRVS: <TYAPR06MB2191C9E61995E49E145BBA43BD019@TYAPR06MB2191.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eZdsbzaMBnRsEooUt5w6TQ/TaHDXSHVA70IyCfzNVt6FGgf4/KDmlLMZE1Zzbrrtud83jAzk0yZ/pFftQ/518r16J+5ahFw7CKVZYgxGlFG2W4aAGOXmCsshTVe4Bna3NDajYsTC9ZlHunKWK46/1vVMr0g1icETl8M7Cfzvyuk4TJj9Vo8r0NzzNEBCq71zzrMowhg8j5d5z1TrZRTwOW9rIk7exoDy7bxLICU12Za64J/6kVAX2T7r8j/3P9xZAK5e+FPaZnI9SnK006FvoCGEFv1g94yO2a4w1pzinLHpmOp7eMUmdtjHyJc51z9LbQfOq5tsXJeFw3ABvVFEnUVP0ZGgNdIqe4BNXCqJWwvbJtd0RYPxgGyF31R1KuZBr2ICJhi5JxAoORi3ceRVd+SJR+Cz9Acv8pd+8gnLajf8JQTnvrH8dHus3GIVe4qkvyVmz8c3rLnTGLYtUi3HBOPDuzvIcuLIdyVSQ9vx1AyNI5H/PSOX3XwSpBQQnk+8UmL53q3J6pAuYEn1yMnr4o/p86d27zFawyzsu+Mux5FFeZeQk6w1vLQOSndMX7hKEZgRh/Wug9OC7zRZXSwHVSe1AOG8tXZ4douda7vu5AdKLYYrRU5KW5x1KS3skW1i2KJorfhVai3Jllhtew3ttw3a3y57oyLq/q+uTXR0ziUkVV9n3t4GtTcxzwvXj6XUQmJu0UJrnH6NJ1semZ+kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(107886003)(6486002)(6512007)(8676002)(8936002)(4326008)(66556008)(66476007)(508600001)(6666004)(36756003)(83380400001)(110136005)(2906002)(52116002)(316002)(26005)(2616005)(4744005)(86362001)(186003)(5660300002)(6506007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a9B6GkMwKPlWKFpsPHmHw8Q9N41p20KgO6nwS/x0FKWlizmAzpB+QUgPL/4f?=
 =?us-ascii?Q?9DX7CEF1vpaIVVPlL9frk25B8Lx5qZvNCkAdwj+rdgtt/70mkfrOe+fNRgIh?=
 =?us-ascii?Q?j3B0T/3JAmLMX/V7fGL/5czb87jjeZ8G1zTBxlf8M4UqsDPCLPCshIdWXEjN?=
 =?us-ascii?Q?hal3FQEbUJhzZl9EUo2BTxU0FC1aqQTBxuYIzYiPGqUGqmKXNPHT8w39KvNS?=
 =?us-ascii?Q?6r8NfFbv7bqo/Pav11DsEMXrtIWsKSYiti4sYIVxGMMqOR/2pf5v3Tm5foTG?=
 =?us-ascii?Q?9PmAUwx22D7vh5dlI8OIRRLrXIsVyKog8geN7me/w8WC91ZT3jCDmwDrJK+e?=
 =?us-ascii?Q?Kwp2j7ZUdA/8XQD7JSKa5/KWwOKegPmjC+xtbCgfPZDYXQWB1DTeBQ9Nx44b?=
 =?us-ascii?Q?FOjl+UzqxdbRarJaQwt+pUCHbQ+tSa93PfSO7syMzhQDsqVdN4WZaA8x0G6X?=
 =?us-ascii?Q?f5+JCTD0hj3lphsyBgdcBaV0vAU9y11TALXOtZOot+Z6QemN1Bq5yPei2ICB?=
 =?us-ascii?Q?KADY1n2NGtahMTc1ehGy79cySmPD2CYKKxYYvpPqtK9s7nqzzIjBM+2Z9Efd?=
 =?us-ascii?Q?Hr96FDnafm300uPUuvl0MNIVofnJmiBS7Z5TwKwCn6tJ7PGEXlfiDymRguJh?=
 =?us-ascii?Q?+6oId63wE9FCccMUtzoTT6rc8TCaK1P0IqkDWgW5U3qUxX26NNNu01ZaMUWR?=
 =?us-ascii?Q?rZXDfRelq2sDJ0/G2gWJnp7oiXaabZ8rqqaZa7w/E2wQDUqZL1buZKU8z/kv?=
 =?us-ascii?Q?+/y1jWsnZKMGUoUH4wBY9E4ti/jGY3cJroR3/nX5GVGOJskkqIqF2RUyJ9Ty?=
 =?us-ascii?Q?wz8FfGItZsNTdDDYrSbEzpJTkq5O0e8Wuo3BsSit+CnPFv8tuA0VyDRxPx6+?=
 =?us-ascii?Q?KvjRyL8aLyysLbkRxAqaMnfH5yhCD3LpYj2IYnoxPSUL6OcajD/HA9a4fpdu?=
 =?us-ascii?Q?ZVz9lvm3Fcnqzh22iouyN7ftd2Ur1rZxkAacE04W+UIz3ORj7djlOwIMRRXS?=
 =?us-ascii?Q?7BfrR7Q4Sa3XfqlzoNj3cvZbj6+0ak7W3xEAUV8lOeqgQNraqpccM8qan19H?=
 =?us-ascii?Q?4X91LTrbg9NxLdSLXnwY1nTR84c4AmSfUv889bytTE5ivO4nlhm4AKhn+5s3?=
 =?us-ascii?Q?t7BRJCezHOfgLIFNzGH0H5Ao7sX41NKOhfEK+m578YVVrStuWPk7bhe5FLH6?=
 =?us-ascii?Q?UmkzYIHNzNW+8gf/p2epfT88vNSiF97fm3vMtJUXUSIDIAvEcOPvPuyukeug?=
 =?us-ascii?Q?yCgj3GXbHyEtF8ZZnC6yoVU2FalaJdonDHN6kxv7jU3u8yuOYnZPsxs5FY84?=
 =?us-ascii?Q?Xs8caWoMKGJUq9sSbnXoMTkIfboUFexblf6V1UsYsHdZXEMEAFEOEN0nXx8j?=
 =?us-ascii?Q?YMlAhR+0ykOyHTRbnQk8+JmNqVJQL7Mcbjw7yRl0qgHxVk3cFQKCEQ6Z9o75?=
 =?us-ascii?Q?R8kqWaWg6dPrqJYZu1VjOWo+NupE7B0RQgBcFRg+gQ/Bo+qAXV89RWlLwij0?=
 =?us-ascii?Q?1P6xRF+h3aZ0hVGliqWPYtaWCzh4Tyd/CVfyYTluOVB7mn9KnZ1bl9ksDBSV?=
 =?us-ascii?Q?ZQqX7uSorW2DOcT86nOHAzX4y+rHo3mgRegbV9R4cEIM0KmC7dBCexMQixII?=
 =?us-ascii?Q?YaoOL1ZoCZrqkN0aaJxZw58=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9b8702-7d83-4d80-2316-08d9fa685c3a
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:13:58.2679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBTQNKQuJWFFpNsCQtw1FuSpnnULcvVFq58RR6MihPmAJ6U+zQ0pMNaupotbuQ9w1x9LkzC3//DgxE1xNoMnkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2191
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

Use the helper function time_is_{before,after}_jiffies() to improve
code readability.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/wan/lmc/lmc_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 6a142dc..76c6b4f
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -57,6 +57,7 @@
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <linux/uaccess.h>
+#include <linux/jiffies.h>
 //#include <asm/spinlock.h>
 
 #define DRIVER_MAJOR_VERSION     1
@@ -1968,7 +1969,7 @@ static void lmc_driver_timeout(struct net_device *dev, unsigned int txqueue)
     printk("%s: Xmitter busy|\n", dev->name);
 
     sc->extra_stats.tx_tbusy_calls++;
-    if (jiffies - dev_trans_start(dev) < TX_TIMEOUT)
+    if (time_is_before_jiffies(dev_trans_start(dev) + TX_TIMEOUT))
 	    goto bug_out;
 
     /*
-- 
2.7.4

