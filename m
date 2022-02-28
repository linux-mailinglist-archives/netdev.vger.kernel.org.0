Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7424C619B
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiB1DOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiB1DOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:14:20 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300098.outbound.protection.outlook.com [40.107.130.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E4D424AB;
        Sun, 27 Feb 2022 19:13:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cliKDW4Be4OrA0zcvtDOo91NH4LTBQ2/cwjjKrnrwCEOcqSocy/qN97lSAMo538wsZ/M0u8SyPkRbHaVz726/bHw+Y/89Si7sAi0UbKhOpTsVU2Jgs/VNUowECvB0yUXdzVb/W16TZS6VRLihddOIoslhjMn6TY/tdP0Wv2/n1yFArtniDDAoCjwtl1YucPSmuX3nkX4eaqi5KbEzkd57j2+D8cfD8ZM8+cFjSSZ1tk3Vs9dtq40w3PaNZkilufe5xyGYP1lzbadGMyz4cBL/auM/DHqzlrcAo+pBACzT9goDF1uWbUUXW/rinTQgeHs4YRr1o8UfVdMLp6t6n9lMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qr+UbYZ/pNxnajqZq1NUECl1yH+wciNlUhp6REVVXZg=;
 b=kOoWL9Mx9YOEW57sD0nCKykf9+eTBypGHD39Lt8dgDTsEenhZK62r7m5xtv7me6YZmogVkpOTFS942UCpp6GV6pTOpYPNdYTDOnoM/W8qi+hiAPZfI1RGZTfvYC+gzE/geR7485Lmr4n5Nxgc2JmFqEhamPYnbPFGV8+dhGQA/KYLVgzvQsBY24VIhU9YBg24dD16covwS0ynscX81DdjJcbQkLas+t7wlHs1MpgtsNp+jQP10l/OVR520DcgAwJR57pExXr5tZsbb9Toc9qR751ccln2Hu/fsGI6697H06f00iaUhOI8TMZsohCMi9R6iLD0Dp3Pp/Txp5Z1ZFydA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qr+UbYZ/pNxnajqZq1NUECl1yH+wciNlUhp6REVVXZg=;
 b=G/lz6ow2MtHQSmFDN0v7mjAMkxL1lpWJ70PJFydOfDLeBB4LdS64QoHEWpT6VRAqsxvdw9dguv+fbqrSF1RhtdwFD8tqQe5vp4L0+i9j1S3dpuQwaEvpjao1ERSwszm08cx6Pe0Z0r7LLnDkNSc/UEZ4JpHKcKpSSf/jGS2C9+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by PS2PR06MB2454.apcprd06.prod.outlook.com (2603:1096:300:45::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Mon, 28 Feb
 2022 03:13:38 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:13:38 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Joerg Reuter <jreuter@yaina.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: hamradio: use time_is_after_jiffies() instead of open coding it
Date:   Sun, 27 Feb 2022 19:13:31 -0800
Message-Id: <1646018012-61129-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0020.apcprd06.prod.outlook.com
 (2603:1096:202:2e::32) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6578132-ce84-4b08-f3c7-08d9fa685012
X-MS-TrafficTypeDiagnostic: PS2PR06MB2454:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB2454B3D150998BCCEBB2FAABBD019@PS2PR06MB2454.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5yJxOS61FroayEUVBQcEbQo4RUgYVnQ4R8BJTImkBgip+xC7B99bQiJD1dKzcatlI3ufCtQjO8N+0aiftdD6iy7RVkVBoGAAYzXpqNnaQCK5X6jCeX7IKDqWEUR+IeXtzDj8kjSTY+/555w+qtW2XMedP8dY1xK7abgArG3Ts2p02x25vSFDNn06qU6ideQmEOibL9giB5BtS8BgSyfpYUFDmgpPIz6DxBs6S6iPyxykzuh0gPetMYeBB7JcuWmUnkF/xIJJ+cpncHp+3ddcYFjLMvmrFYoQORJ+t4aT49XNbVTfa/lkcw32A8Sa68AjdcvIDsGGzSZ03CNCcocUU6w8TBhfw+n+w12SByfL4ibsJClxNRkDuG//ADwAVCGz9jyQe0u0CQyWCROw8193LUh9X5MIx0v/KrnxxhJ46z0pofh1MjllCCZnK2aoda4M2EdKpwOydjyO19ZKHLC4PHhjxLBMA7Oo40Ibk/pjv4Ln64qDodF3pB23BZZzfW9e02zFcj3+wLSw2iWhRZ2qOYKd2777iv/dGKzWT1OQo5Ze3Q3J2lLjZi3M92n9n57BDQ89gEKZt/mpBTm0rhUrFn2t5wRneZ+0J1w0Njerk7a0/4nwQDkAJoNCHVUGH/EL/ATd6z3RwuNGZ1t5ESFv2roQP0OzUaNrnhtjBapj+KRnEgdq8z84Pl/KtgCPQt8UVuqOkM8cNgY1+uWdonoB0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66556008)(66476007)(66946007)(316002)(4326008)(2906002)(86362001)(38100700002)(38350700002)(8936002)(52116002)(6506007)(6512007)(8676002)(186003)(26005)(107886003)(2616005)(83380400001)(6666004)(110136005)(6486002)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J9FpyRlxz+ZQ++XxitCaF2ulbCyaEVyL18Due5NMwHu6O7ongRrueEMET9AU?=
 =?us-ascii?Q?qd1LzjJGURTq82GqtJm3l7Nf7EAkju+83J/cCHFb/p3AzEkt9EBTYPSHBi+2?=
 =?us-ascii?Q?P2JSu2Apg7OF70874wzhJyC6Hwvm7fSRtf9hR6CoPZ/j+Dm1OPJldlEZ1mXf?=
 =?us-ascii?Q?K6vM9DCCzCh2XjSNoSq46S4R+Ye9PLPjnYWjtqNxiiW/z1XnWvY5jhgy9Q3Z?=
 =?us-ascii?Q?tpIQb9zqU9sJmMmDp7qyCxpF6iFKXyFbMyrleKiyBzudHmvUN0qjsyPN9YIq?=
 =?us-ascii?Q?z3WjaPZnNPneJFW9pjDHoGn+9kNLLj0Y7kNMHUu7lBBSmWeBph2LmreRylHr?=
 =?us-ascii?Q?JBq1v7UjF6OKgTiYUYv3eN4DTXqh7coeiCH2LGCm6T+E/cbuRExC8ujq2Tbg?=
 =?us-ascii?Q?+I6ZbGL6Omj5enxhna9yJO4xZHDbSB99AcP5Jd7dt0sMA/ew4JYm7ApKmYFX?=
 =?us-ascii?Q?Zaxn/58JGt/yWu3VkpR2TnmeRq8weq06DaRYTyiUOLhuDnOk38Yej1q+dvne?=
 =?us-ascii?Q?AZOw8NNRmxHV7ZmVh5xkKSnsD3KEqQZugu9Das1CkrY1FEZ34HuESAnTilDI?=
 =?us-ascii?Q?af6s/67phiixkNqcOgefdsToEpYuSKjdQ8JSUN+Vedu3NDKrapS9+xACCa9n?=
 =?us-ascii?Q?4ym2xF6CBypLIwDPFyDOqBpSZEyK33wZH9rhmK2KMIbgGjChhdt+bD5pNa7e?=
 =?us-ascii?Q?T3h52cpbAQLlludBQH641KmPC7OebHMWCDgf9zf/sLhbB0hqegmgmnj1m1f+?=
 =?us-ascii?Q?dpnMDBozITYohBckawccXsgG/FbhpX/ZV2pxAXCrQVDkMGrCorDnSAoGyDfF?=
 =?us-ascii?Q?irH6D9pEUbOLjpMxAa5z2YgaxP5fAcGzwM84bUVfNda5xH2PlmDWPTWM5Zot?=
 =?us-ascii?Q?OQVu4gyVqoIStOLOL2MrtyobGxZWtPglaOyEE5reqCDEX270Jrq8wcpluV1z?=
 =?us-ascii?Q?5MK+tdm7sbENlgjm/IDoRaO91XjTmIqA+9ci6qHQLs3B+a+DhgUzkk8uvfPg?=
 =?us-ascii?Q?Pn2nnm9JQo7gnKhBYBNWTnGxgKsgPPKeCsBU8pcPSbA1wU1ILKi8eT9q6RWr?=
 =?us-ascii?Q?FjqRgPvpokNGkkqPhMLeO2/5lFLO/xLSI7MA3e8ZaFnWwRhYnK8MjQqJua9q?=
 =?us-ascii?Q?oUhW3CwbGU3UqVSpC5hNFNFC8jmz2MvgwnOA+JD4BQhWUQXIaLKcSi0dlH2T?=
 =?us-ascii?Q?Ehy5AR+1vzLh26uAIA4HeLURF/8SOXxB4YG15u8lL5TSVpXxwF5dLfPoDiQ3?=
 =?us-ascii?Q?SZcUp3BJNfqK91QBbiGngbD7gF0fGrkTd45RM4ssjitxZluaa4hK/mZ/4GfP?=
 =?us-ascii?Q?gL/AnsuE5xXH0BpGXIKF1zfyQu09FXZG+UHaBqx+pE5m6ZHHLJjp2XE4HZ+f?=
 =?us-ascii?Q?PTfsUmybnDupNyJ5ig+GAu0cfBH6/qLdVXuaDIU0T1yhr7+LtG57gVBcmyG4?=
 =?us-ascii?Q?oi6qvGuRKXZdPtreHyOthv0iJlP6kZToCg5ijvqfwlNHYWErF2w/2A17Z0XE?=
 =?us-ascii?Q?gYhuK4JvgEnub1xrnMc7KMy3otBUvqQLkZWx7the5sFc0RdCfSw/gguUz556?=
 =?us-ascii?Q?gN44Q3TaLULanR5M2Wvuww7pASJ8deSUGY2SnLj0Dlhrwn+Tq9wV07sKfMvD?=
 =?us-ascii?Q?1rfWiXrqDecdxdlKrSJ+pqk=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6578132-ce84-4b08-f3c7-08d9fa685012
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:13:37.9097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FkVrEBN8JW6OyWy3wII0pX/3YL87vDYM/21GzBa/PhGgCD5gq2id3jpCUJrwmqNMPHe/k2Zs0tJ9L3OR3qVGHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2454
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
+		    time_is_after_jiffies(priv->tx_start + priv->param.txtimeout) {
 			priv->state = TX_PAUSE;
 			start_timer(priv, priv->param.txpause, 0);
 		} else {
-- 
2.7.4

