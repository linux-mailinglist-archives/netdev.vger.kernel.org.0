Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CD94C8B8C
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiCAM1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiCAM1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:27:21 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2116.outbound.protection.outlook.com [40.107.215.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9A5939E7;
        Tue,  1 Mar 2022 04:26:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfhjwDvsTCxTfB0u3+7pt9V3MDoGRUzGj3JMHVmDDiIlyLU/ET03axQ0X1qOOeQESvBE4LNhpzjBkdC3oCCrp8oJLj12o7CcA/XBy98pH4/tsPyEg3s2C7m7mUZ03paWN48sJFn4+hC7rBh1uzURbZ+yhLq9L8kMegvsVLmAPCLWO2yo3JDg94O/iR7GVyhNidw/kLvCD3WEUpy6AczRcxXUrl9ilwRyiWtPhW8wL/VGzhe+iHEYFk48QBYTWj1FOoTr7MGub23j9WuDLN74jiMInMVoaY/P60vBi0MnNdVks6GCIhDpIX8RaiRQhQMNGj92JK9S5p77WvZox2/Ayg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhiAku5LeJpF8dIyxxB/WzRL7R2lu7jVlo0UhDwjO1I=;
 b=OuKMXAFI0y4XteKUron51eMVcKl4GceCsOsuAtRceGgp/0c2F/62gFMLJbS/zZ2G5m1Hr0W1PH9HDjzOdxRFPPKxpgMlwSUdTmCQSfPL5hdLJYPWksu/p2T8luy/TLr9EkRVbWx7x3GrdPT9OlgR2j9IB3tUWZ5dDTr59BRmsv4YZQtALa12Onudxs6NX9+nQmbSWcv7Bdr41K/1aOVgz6Uchaqx4pH31LnUsY9wcLlJFEdBZqk3YkPAnSweyOFnz4F27NHtcKqbXF8XGOMUIyzMq1GSCAoInBMAlR4fcF+YxB18nfyVI/vklripSsHBl7WWfscs6QgOFbVgAHsfzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhiAku5LeJpF8dIyxxB/WzRL7R2lu7jVlo0UhDwjO1I=;
 b=cgBDREK1pR53RnQtb0oOrCzu3zeYz+al2pCXlJaJtw5b2/vI0tKmzO2Oh+q+xWB6Tllhh8z/jpj/X2giNwbvs9pxpGG1mPDBHohKSETLumHCu847AixeseNBv54xiPuDR5uwJAUfx6yP5kkX0iekGt+C0hjcGQBSQxwSOwW4jlE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SG2PR06MB3109.apcprd06.prod.outlook.com (2603:1096:4:6d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 12:26:37 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 12:26:36 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Joerg Reuter <jreuter@yaina.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH V2] net: hamradio: use time_is_after_jiffies() instead of open coding it
Date:   Tue,  1 Mar 2022 04:26:16 -0800
Message-Id: <1646137579-74993-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0189.apcprd02.prod.outlook.com
 (2603:1096:201:21::25) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5a62d50-ce4c-424a-ac16-08d9fb7eba4a
X-MS-TrafficTypeDiagnostic: SG2PR06MB3109:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB31092B6EC9690C936A135E8ABD029@SG2PR06MB3109.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aDv/LKlf4czYSfD9UI5cHAIHIMoLH8ljXgM4va9uviEDXtq6tqraCECoAWye5FJPOlv/P1K/QeRe8q+9E5cvwteiZwhL33VbIftJBm/mYHTpruWAq3SexGvgKyOb+3iSoK5ImptRhjoODeLYfEjJ51e+5Z0kC7whpE0FIjjqZKgvr4uWomKP2bn4I2B+WqkqZ/YIBbGpSchrMhqo4s91pTuAH+OSQsNXcgUHaNCkWV1LLMFKrBCkRzaEQFcMXHWBzX9zS2tUnxVafW2vqrPzEXUo6OMXvtGQ5BbINSNWbHgoOR03T8t6CHcEb9OCguK8lfGFtLnj9V54wjNXRXHm5a8op4ZvZXXE0L6CClcSlc9FdYYXyHCkxE4lXf6ClIHL3jK6m1E0DkGIqlSUu3nHg5V/GUA9saSa9UvD9G5WFuTb8EADBCqwt5Fww+SuUHjd4/Yp9mV+gQ5riTyrg0ntn6N1ij7nUG3JyDvipe063OekWqiLEy2A2JtawkCK0bcqxHRYa/O4PguEF4x9uOuytQSzCy0MuwpI26EbWp8+B7zkv1HHv/KGPToP79CkrUUgIECLHBu/R+YWJyCK6uhO+aWcRwJeCy2uVDCJmGOcXUJrsT8tykaFVV2lBaqXVaF0jjkkmIXdXTi/XbeO7VpIe1TC0Y0h+hr3AKkmJyFtcCI4cTXK6MtBCpFIjYQEe656mzHR8VQOYXvZHB1WbBqDIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(83380400001)(316002)(6512007)(36756003)(107886003)(110136005)(6486002)(52116002)(38350700002)(2616005)(6666004)(6506007)(508600001)(2906002)(5660300002)(8676002)(66476007)(26005)(86362001)(66946007)(66556008)(186003)(4326008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p4lYGfNJWU0YFJsuq/S27jZgbCDHGCeyeLmv4G5EPSL0bg+unBDWDYWEcTmC?=
 =?us-ascii?Q?cjrkAHVBdVaJ0Up3jma5VOr+hlz00hkR3Ng/u/RZ/1LAtUvTBPb5M4nO8UWy?=
 =?us-ascii?Q?OrxPCqUGmOKuD5o7RolPGavpbTylAmt1cgQDpGoyw/fDtFti0k8d9B9jdDKE?=
 =?us-ascii?Q?OemCH8F3+gK7UDPaJoBGhSjAW2WMFwn/4C6osBzYfq6zi+NFCFF9oUJAR1Sy?=
 =?us-ascii?Q?NPW86g2cUQvwL/3eXdjldM8lC2J9tEqa1honagIheQjDFL2X9Jbu744n1XOK?=
 =?us-ascii?Q?EuL8d+idM0GMKE3pVsfdKGLgqyiDVZN6d+alj58xa/v8DxLWZwYY9jTgVukf?=
 =?us-ascii?Q?QpfCVA6FjM6Ok7thFBWizcjYoxlV4rhH3OS17039SvxhU98v/fsRC+RzxPS3?=
 =?us-ascii?Q?nqvw+/vhjnsZ5QrapH+fIPGeJdz8WgXAPHjwLkkzfYp3RTa/4A1OROBtssLO?=
 =?us-ascii?Q?b6NThUNFgbIIH2RJy0cO4miqOP9ey/0ZHzMWCUoSzO5O2keFuUOjw6NK+7t3?=
 =?us-ascii?Q?y3t3RAU/FQMYdbY18gcyT9zX47irjG+BKzTU3AmC9HD8G3F480NnZPD8P25e?=
 =?us-ascii?Q?zmm+kfHr9FMfRoVez/pWepJJ4uI7Xcy89Y3k2HyDx7YLYwS+yxhXXn+42Qpq?=
 =?us-ascii?Q?aX6PkU67Lf/yfi93061QNY6N1V4NXH+ikBkrHswTJVGt9xA7tOBtzCikFtpm?=
 =?us-ascii?Q?iVtgHzu91LfD1Pfs0AQLRiuhvJSe6DrDyCXw/jjB83P/JNKFTu3RTV4jKSq/?=
 =?us-ascii?Q?t5W6jVIHBiF6YeHLBQ1w031B0xFGS+Nb18b1D4P1CkzAEvfkfwOICd5tlkc3?=
 =?us-ascii?Q?GOWMy4J8PUcf1S1IkZhew57N2iP4qlGgeAGka8UNR8dw3PJeFqlpgoJU2IbT?=
 =?us-ascii?Q?NS6yV/pF9JNBXJkzx5G+Cd8NG6wQEClL2nf/QJ0pz5hMZFT2t62P7DkxFotl?=
 =?us-ascii?Q?L83iflzccGtMd5WaUexu32UE0lyDuOhwxUs1a8HNMzsH4k8uBXwVq54OQoVL?=
 =?us-ascii?Q?aL4IpE2lmg8XBMIszc/vH0BAdOiRYSivY+jGv/cXWRSawYo9v/ROr8/Hmf7f?=
 =?us-ascii?Q?4LeNETysIYlnfQi539D/anP8dJWjH0j2cxswJxBQzMUniG1ksO3rcyX5mZUL?=
 =?us-ascii?Q?F4RQuj3kGGmSXLr+Px93YSB44j4dt71MN6C7pi7f9GdLNM4xuftTkGllCZtt?=
 =?us-ascii?Q?d807+mzdiL7Me985ix/1FqtsoB6rDMu9EkhF0jeZRJAio49hFZWQYWZUQx44?=
 =?us-ascii?Q?psLODQ6H5iN53ABdmnVzuZK3dimNMlYT9HrXNEXLaHFEB4pOZqF1J4yV5p/Z?=
 =?us-ascii?Q?3RD/cpLW1N4QEZuBUmbWOOctllIQizOoUtbK9O6w6UGq34CTBHPwL0dT8kgn?=
 =?us-ascii?Q?R67zavR2/t94pQIFiC3lr8ALvsogZHN6jE7zm7sJcBOt2j1ITZVseTD5M++x?=
 =?us-ascii?Q?RVrmwicu526tGJLWuR6kNeKUgf5cxV1iPq/78TIv7kLaYxXuVTjkSyNaeiQC?=
 =?us-ascii?Q?yIT+GQ1XlKKfUwF+9/W9hk2ocqVoK6cCzT6ODFTfB7xD38YPRqZU41lUHTcm?=
 =?us-ascii?Q?Q0t4lGNFYzgg/5JghQOVu283KwbaweffHS2lEOfW6vadACzA+xYHBXTJNCkX?=
 =?us-ascii?Q?v8/P4fSQT/RhqMS2X3VIl8I=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a62d50-ce4c-424a-ac16-08d9fb7eba4a
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 12:26:36.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEz80u+qr5PrOjrrppTptrIWWrVuLk1/+kMA7GLvXpa/zW1gtRjJB3Cind6qEP9pmIcSTd/STaLnJwOrdHT5/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3109
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
+		    time_is_after_jiffies(priv->tx_start + priv->param.txtimeout)) {
 			priv->state = TX_PAUSE;
 			start_timer(priv, priv->param.txpause, 0);
 		} else {
-- 
2.7.4

