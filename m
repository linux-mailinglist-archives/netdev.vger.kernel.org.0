Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107144C6190
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiB1DN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiB1DN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:13:28 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300133.outbound.protection.outlook.com [40.107.130.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B45541F90;
        Sun, 27 Feb 2022 19:12:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvZ3TCuC3+6LYP42g56otnfegU4rUtIsC6l2ZQkg91RxYEVTMaP7zZhvJlYBX4mkxPVFwQC5p1gkv3q1KKsVALQ9PDrG1X2v2TkVnv64Tz15N4RV899t+O9aNptx+b3OJfcIgQiwmKCBgFqwscLRBY8NZWJbd3hR9a7CLd61gwb1F5YoZNhcZF+ejF8SlIzqZRYQjKL3sekrWq53UV87p4605IjtQU9fmyieAJvkGngaqtDD2e0MBXlWr5fNdijGff8kClkpOgDjR/Kq/LgS+i9u+pzLDpGxD13SUimXXlH2b0anwh+fI+zj1XfnUcAMzKyZPS7IPteKllKwIs/BkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Wyfm7sZP2XGbrEbD8oyWJ6q1CJ6bf4PXaWmPuVlmG8=;
 b=Arh/8Fmnnj/IVaWUWPwwBFdfF75A5xyKicQM5a1cmR2LqBvgZubBFK7os0gCFdd8xzHFsaQVVSUP9Md1OULJWJHL9dLFMzr7yAeLRLpQyD9ZAdAHFVXxpjVwT7mr61ntTsKG8nJLksxk12rqn4TAJOAUvmgVpaYYb0tG9lVBc6Zw0v9GTO7Qw2mZKyF+Gnd/SP6IAIkDJxAWvTorEHzoVNrGmT9+Ot0z2tbiJ95jS0GStuIDYJPND2eBYVksdbKqpDBWagLAnrFaLO7e0eLRgV3KwD4H1Eviq5ddtB7rHqrY7GkZ3egwOhOu/5DRYXOvidxiAzZmVAQKrR+p4tsPOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Wyfm7sZP2XGbrEbD8oyWJ6q1CJ6bf4PXaWmPuVlmG8=;
 b=Gi3G1V99J1u41Lcz1Bt39CP/O56NtameUgz7Mr4TOI8JGDdWR00omzhz9FrYWcJZxfqOu/j3V1yqhSHIc/oWbVQeco/9BR5WMuRo7HqZ00e4b0ihfOoAeFMFQCSMoYn79ZVeqZhcoKhjSxXB7TyIvcyUJmANMOoGUK30O+l7iko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by PS2PR06MB2454.apcprd06.prod.outlook.com (2603:1096:300:45::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Mon, 28 Feb
 2022 03:12:45 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:12:45 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Guo-Fu Tseng <cooldavid@cooldavid.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: ethernet: use time_is_before_eq_jiffies() instead of open coding it
Date:   Sun, 27 Feb 2022 19:12:22 -0800
Message-Id: <1646017944-60946-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0158.apcprd04.prod.outlook.com (2603:1096:4::20)
 To SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c83170b-456b-4508-7ce0-08d9fa683077
X-MS-TrafficTypeDiagnostic: PS2PR06MB2454:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB2454B007BAE23805B1FC422CBD019@PS2PR06MB2454.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4IRWkA7CeCXd/AKXOCxeEoysHoyHKThkPHOvjTs5tgP9H1ZMuaVhBwcDcZnsUzQ65XaeLvfYPV+oPeok2Cf2DGLOV2ERSuTAAt5WlqG3Ax33HL6xOeNhZwkTqoNMXFa+TsNS1XX5L+OyiiafoRPzqrh0phYjlfcgTett1/8V6cJsQ+o265DMhnFa8OgS2jBDMnO1a65qbtSgjAuyK84jxUVkvhJCCOJUztsxKSC9onQVigorzgwtbyT9CpM95EHKtb1ClFrIPCCXHK5vhjw7b6LGifidKYtwGsjYi211c7wy/NnTLBEQk40CfNdopdnKo0caUuA1LDILWcoZja/Y1t2CCptkXt5TgkcR6V+8TueBm0CzkXG+jez4732C0hdscLpAN7Qgmt9ae/aj2HOvbwQd3byjGNJ8lrbMHzzCEz78LgFnFcYxyRnKlTJhduPOxeE4JzDolcG2m9jYn0JMhf7vOHt7HT7/yYuEvvHU3kPVDcXYhcfu/7up7vzi7U7MN59PyKlrOHWjv7dvpLsoA87xeRvyFVBKFfzZXUmyWYjxNUru2SGAWR8jdxDhNL4u5HKvbewSEo2Dv085wNyU1NP6qLueYHih7WcLVd/6IixvbFPC5BZvKvp0OXAxSsa+eBd8UrtlLzrLkLzXD6CBR5KuSsvqrLBApTKd8EgVNsLe3tJAhX1a0toPCLw9gx4Y40ttx3ghfJ/eTa/AisnXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66556008)(66476007)(66946007)(316002)(4744005)(4326008)(2906002)(86362001)(38100700002)(38350700002)(8936002)(52116002)(6506007)(6512007)(8676002)(186003)(26005)(107886003)(2616005)(83380400001)(6666004)(110136005)(6486002)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V8iaMdU8Ljn5zSlg97F1KjOEX4tnkKKIAmjFPvOQwBKCr6snezZKO4apRGBN?=
 =?us-ascii?Q?SERoTX287fzF9mULfdy9DLKaLWY+XCeZ6weT4w12dxEhNID3z+k4BIIWepfs?=
 =?us-ascii?Q?4trijiVesXGjYqqkO59+qbFqK5X/FzilAFDF+YdnEXq4bc+P8hCmRJlaQMtK?=
 =?us-ascii?Q?CsKnAr/okdKHYhCueL304Lc0KRHeKpnLwN0fcBk6q55wfi13B7ALachb42ZH?=
 =?us-ascii?Q?05CbeiteZv5praMC+AEyQ1se+uPEOoUXEDavJfJ6U2MgrZfbM1yL4YgWk8vd?=
 =?us-ascii?Q?cdxGBH7S4C1LsDDmEqFKBVShQ9oDhbLKi2CXd6FQd1bmmrV+39YqzwGrD7jW?=
 =?us-ascii?Q?FSHYLGy8pxrvvopqf+h299FqXGGEMBUeINonmW6vOHXsBV9KQurzNR+yKX79?=
 =?us-ascii?Q?/mY09erG6Xdn8QaSmnYknP+/eyeZEbHgrMFaN0TV0V0rArWRRFFzuxaolOKH?=
 =?us-ascii?Q?gtgmOWVn/ZPUmAx0Eh0t8gcu8MlNr6/aEPwezoMZ6Zd/HHrq6dELxfvLz9QM?=
 =?us-ascii?Q?RRaDGZjS55RkPvk9begVjA2REYtO786rA+PGwlFqigwRbDEbmqU+Gt7qCcOE?=
 =?us-ascii?Q?lLx2bSZpatppUniUy492QEhtk/NpkDecOTxdrlDVsdQzGrN+HbpGgwTnEIPx?=
 =?us-ascii?Q?c9pj9Y3bsGMfeAQEwmlUCsIrDYgfKUBJmylox9X609FcQScuLYG/+6dm/SgJ?=
 =?us-ascii?Q?xbEC4ako6Zs5QvbWh2rO+6MJy7u5AHO/a7FaY7i7JK+iVDtzX9hDoIM/J63n?=
 =?us-ascii?Q?zguIKXbOo6HjLJqePlpS5jZts/zRz2OH/Fvga4wfE9sNcHH6ZJXhXexG5O+o?=
 =?us-ascii?Q?bpLhXaLob2BhohhnlhT07Ujzt77TY8+hiPMFJ2JN2GrhXOR3IESeQKd3yuJT?=
 =?us-ascii?Q?/fFzoa0rbadodOPK3PGhhRrcAA0pPhUxiIwmK+bH2KzOgJ5+wFd+NB2ExSpP?=
 =?us-ascii?Q?Fs5Y0bzWGxtTr9ZCMIt61ii6Zug61E7Am4KP6IrgNzgfrluEimuC0I5xeV16?=
 =?us-ascii?Q?H/fNqlJNOwbWKwUWQ8HhdwK3+Z7dMOSCy/DylCte4MoMeFokeDv+jGoYpnIf?=
 =?us-ascii?Q?H3pQr4BCM7kWCIK4d4+KsN9AQus4FI+S/HjTxfSR1aflOSWd1vfXuT6xgdR9?=
 =?us-ascii?Q?ljrVFkGz//CPTMN3Ky4KeuYdwG12RxguzUFR0gnkhQMlrmoaB1cUWJDGr0UI?=
 =?us-ascii?Q?FcpeqLfJgyMXJmldkt09kj1pvhisyfUR/my2L2GQUmCihRDS25OWqtXrA7PD?=
 =?us-ascii?Q?XWmz+vAVdFE/cOjKKuWqNXmO1JI25CUIDAy5cXcLIxc51N7109TB4z2l7LQR?=
 =?us-ascii?Q?tSPd4wozasZCH9ERVuzZhHCD6DIo1p3prCb1Qe32dEDnhDiv+PM0fKUcMSxk?=
 =?us-ascii?Q?qZ8fmOv9gQIkuar+FEJ0d72D9GVXeTSX5z/1wWofHJ96mZw+gUTmGLRdm2Tf?=
 =?us-ascii?Q?Z1SqRalARWIiR1u0bQ6HNIvSqNjKgJphzYqFPfCuqRzIhsX6/eoVdGf0ispG?=
 =?us-ascii?Q?NVANDo2u9Sd0pXTnydT4zBgwDlz4ckFo2plWS/K+JCmx1MqzVDzUi4/OXgvG?=
 =?us-ascii?Q?ie+/3DztBN62xofOtiqEsZ2hLIzZ7HIOZtadf6yeQvxT0XnuFa4S2BMOHmeW?=
 =?us-ascii?Q?ZfAeAnIUkKq+VJvMzAKZEtk=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c83170b-456b-4508-7ce0-08d9fa683077
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:12:45.2721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqL1/JJj9cILnph3pM1iMoRbNdn8FaHpRE2ceyZAw0a69+2hn4+SgHhXGc5WjtkOSeyzIEVEmb3EjgUD0QvuzQ==
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
 drivers/net/ethernet/jme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 439674f..b6c5122
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -28,6 +28,7 @@
 #include <linux/udp.h>
 #include <linux/if_vlan.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 #include <net/ip6_checksum.h>
 #include "jme.h"
 
@@ -2179,7 +2180,7 @@ jme_stop_queue_if_full(struct jme_adapter *jme)
 	}
 
 	if (unlikely(txbi->start_xmit &&
-			(jiffies - txbi->start_xmit) >= TX_TIMEOUT &&
+			time_is_before_eq_jiffies(txbi->start_xmit + TX_TIMEOUT) &&
 			txbi->skb)) {
 		netif_stop_queue(jme->dev);
 		netif_info(jme, tx_queued, jme->dev,
-- 
2.7.4

