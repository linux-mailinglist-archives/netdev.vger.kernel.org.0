Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18A94C6199
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiB1DOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbiB1DOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:14:05 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300112.outbound.protection.outlook.com [40.107.130.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997A942A11;
        Sun, 27 Feb 2022 19:13:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFfDA9wCNUM3H1xhEwkj70JAASFHPzBF8KnvlUgGmCbjA3rh73pR2/zAIYyWmEJjw2UnSJvJxN4TUCWVRRkHBf7ujUGYJmkrA4u3yoyXG9sMHMnyzKOxJZf7LZnyR3qbWMkWIHCty99VyTGhdMKzgxNAajWdTCTWDYt2TjFznwLYcsNud/TBnYpPuEYuz9GiOWoocs9ejucfqfYSASoNjNfwn3Y9oa4rQLRTyJMSO9voilnJ/Hdoe2wzjawpznL37fb/uwFGIyqtPIeSlrFmXoEyyXjy8aSZJZ7YgMKzgPfQrOTMRGp+ayfU7r1Q56mSlxDeZjXeHRvt2bkwiTP+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQ7qcJrH65kwz4FOCCF7tkF2zkxebwSXugzERM2rQqc=;
 b=WWS/sN2E5ZKCG9+RLqf8L7zRim1Bdi5v+eMwFkWRDsyFeHnWZ1MplzIy2z7WbZ2/xHPBnQTOg18mj+s04RkXIBUUubIeuYnvEoyDKk1EzeSFa63nMjhvZ2hYMOjRyhMjy3tBZzNrv2A/6m+svut9O6+lj4gUE9kRwDp65uPM8plAro2eINwqkuY/SEzKxJxfaHr/xqpBWTjBfTNkKC7z2V0gLAvh9UlNIvzqPRbX7XhtOoGoNwHLpTYOJsbnFrd1lpdCmvMN5qnjxRKeepDNG3gjG9qqOcgDe8IjEh8HdgUd6iBJX6KSvBW5GFwIbPD208hhmzeZjpmuqKZqlNc7FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQ7qcJrH65kwz4FOCCF7tkF2zkxebwSXugzERM2rQqc=;
 b=FNEZ435PzhbEwGzaWwy490zHJcX66GdFHgMxm4N24snYWRyDnFKHDsIyKRw+kbar1imKUklCfp3t+7hrJLkn6PTkIAvHEBJG1qXln2oLWCTHPgSRkKjyBcfGmvJqxf1MX6loe6QlFXRZhDiRsT7u84PepOiyeldNEeZ86SLl/M0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by PS2PR06MB2454.apcprd06.prod.outlook.com (2603:1096:300:45::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Mon, 28 Feb
 2022 03:13:25 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:13:24 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: ethernet: sun: use time_is_before_jiffies() instead of open coding it
Date:   Sun, 27 Feb 2022 19:13:15 -0800
Message-Id: <1646017995-61083-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0178.apcprd02.prod.outlook.com
 (2603:1096:201:21::14) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2c2631d-8105-4d97-952b-08d9fa68483b
X-MS-TrafficTypeDiagnostic: PS2PR06MB2454:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB24546A2835E14F344232FD03BD019@PS2PR06MB2454.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtPZ0wetv38TZjLPKlFjiOn/DnE8i6VR/9E2wfEAPfB4o037pK9UMxhGuq8vdpwHCD0h/pYHcLltSGMCJQm1tZpsFSJHGiao9TnzHiwy+EwPw4K6TsNSXccCpWUi36zGsnIJzFGMCJWb/yoN0CKMGKn3o0Z8zTrNOS4TvWIb6qqZ9g+Bh46v00aLqLr85/4OG1mIvu97w2tlPtbwFpbkPRGGA0uuBE4uuTIqPfRhPbvO1nQ5/Pgc5srNdFJte+5Ufa04y1i51YlFMkzs5LiU9PD17jx7o5+hsOhCDl+KmPMzhWWBc2bTCr9dv1ODnz9a7MyLvV5XS5DHGiCuu7MPS3w1HkUOlXNMP2jFnWeJhDDokY3+k5e2Euu2Fx3juCkYtKXJlFkXJca6KLzRtIdEsb4ZzTWs/p9zF3QFr0n/x32pvscn67NH1B2HLb2DEWGgBHJeozQ80IyTrRMsK3hxrC0atocNP7fKWQ5VLvAh9U9MKOpZVeWn8Mq1kKop3pkOOxBisYWEUGRknwm6eeBmnm80cBco45hht5tnV8yfDUsV96GV/LpxFvqDK7I7coj5Qs7jXPbQh4pnhp58kh9tWHbuIx/Lq06o4UMUOf2cqQWP3tYWd03Iie6ByHlAPzsPBfQtKqQWZ0e9bKLXaM2tXXwZnsjSm2qC6Z1iFvltfVT/g8Th2f8u2LyVY0GuTEMTbI1VHV5OU4II2WBg1EErcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66556008)(66476007)(66946007)(316002)(4326008)(2906002)(86362001)(38100700002)(38350700002)(8936002)(52116002)(6506007)(6512007)(8676002)(186003)(26005)(107886003)(2616005)(83380400001)(6666004)(110136005)(6486002)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SA+2LrXJBnoHDykQr4rux5Xk5lzF9Xj1F44kWK7UxdACefv01yjndMXxIkwA?=
 =?us-ascii?Q?hKFAlxT6ZpmMTTn+BFmvDINolQEDvaj2cHY1nDeETNhQVqRuA/NDZsE47GgN?=
 =?us-ascii?Q?ZXZF2L63hQGRL0Exq0wsO1io1uDLxjn6UfnXDyzS9Yz0n6BSpUkGAhaGtDmG?=
 =?us-ascii?Q?CSG8Pyu6OJNmNCRloxuxKec9U5Prd7lxttIGnJ9w+j9HDf3C/M0x+6NxQQrp?=
 =?us-ascii?Q?wKDLByb03YwuL+ACPks0g4iyjSbLMeL7npQ5RdNEshHG8rlGvhI4bhfbD9qN?=
 =?us-ascii?Q?5btHesZ9qGZG7EgcHG3mTk616FvokbuwvxvRJ1hzz7wQKhscaF7XCmvNsCTR?=
 =?us-ascii?Q?Z0hkc7W0hDWTx4D+duosyGQmaXhsSMQIpO+UcOYErkyL+BpEcF9luvCv17L5?=
 =?us-ascii?Q?R8ETrsT2WPQwBDIw5BZxXzEPH0u6Qa5jeme5l1awb7ko2fp6NGMNLRcDQXIM?=
 =?us-ascii?Q?lv1wpuTzugI6DOxH2OKVRtRLzuCPG6jB5AKf3bp5COUHC0SuZKZG6fL4t8dg?=
 =?us-ascii?Q?ejIBt6Srclr1VF9xr5uW/l5HXuNZdc26Z65fyQxMQ5yd13kxZxCiS1ItyMuk?=
 =?us-ascii?Q?XPj8XKr/++WQBMtV9C7tzMnnyAHiAK+sEuFi4odX5AScuANcP6woId8gptg7?=
 =?us-ascii?Q?nO/H365Dp6p9cwTiQ3F6Z8KB/qfQoJ10olfcJ/cuzGMbFKExeG+mhwt6+pmG?=
 =?us-ascii?Q?l8ob6iri1atkj8bW6QNalO5qqbdLOCAvSJjTne4yH2xB3qt0ZT4dskiLCWWe?=
 =?us-ascii?Q?lid3KNuJ5xDxpbJAPpuacfSddnfbC6J7Oj0fS0nW1UU/IiVOa56/jZ/4H4pP?=
 =?us-ascii?Q?cbnWS0OkI8CD9/180WtRYhapYKHVxYPXi8NF6FPpLWszprmj+ZA0gr9P/vV1?=
 =?us-ascii?Q?XHq/xw9V+uYMMfWGmxUI4B/RKIuOStkWbAZmEOup+PFdZ/5CNEFsdedgHp2Z?=
 =?us-ascii?Q?o7fBql5VJlqbVMtKXNzqWQ9EEFkymyiBuNgZaOI3bGBNWPSByKHUk0hE9szN?=
 =?us-ascii?Q?wsT7+JGA8QYmLuJ4rkPYJ62bs9baOVJTkEl3ZJWcvW3QFW0uDddT4Jz4YbsW?=
 =?us-ascii?Q?xvpb3xSfKZviX6arR7W2Rv+ISOPFsto2wYdzVZ8IQYpqX7G2zBbUNr6aUvQ7?=
 =?us-ascii?Q?y2i84ZEz/NRgM/i5oxrP2uakXKr9GWiLSSr7R0CSBmmypYqQxYQvvDndXbqF?=
 =?us-ascii?Q?j5U/sraA/ZyMPvgBDWO9qh1gGuLGElKdoMRnoMNAsK4KsMsGk+G9F1ZSkgWY?=
 =?us-ascii?Q?D2XKsIN4FVPnfZNzcm7br8cPtC2Jc7x52stKu1g1VIfMqBhs6yVkFVg1fwxW?=
 =?us-ascii?Q?e98e0Y42cHYU6nbT9Yo6DEEVomLwlS2krv3J/3nziSfqc+QGhG0MF18oVgCI?=
 =?us-ascii?Q?2aXpp4NhCHZFtloNi6II+Enz/yNTi5FlzmqAZXG2svfR5FzeIOtwTquZ/iYJ?=
 =?us-ascii?Q?qXaYn4tSfdQPVb7rnKSfLu5aWLehelONMtpoDJZ0iko6bPUNSe6U+vzak0Je?=
 =?us-ascii?Q?/3hwEVuCCf+qHNFzhrCYudzi8wbLbhhAVRJSAM9aL2lq61D8pDfhSPy0ZeuJ?=
 =?us-ascii?Q?d45ckefnbm1tQFa2edvv7eZtxVhNCUlaxTwkPt8qu69hUc7+YHQe3ArfKEpB?=
 =?us-ascii?Q?BkK03ei1Kj1sj9B9Hfim9xg=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c2631d-8105-4d97-952b-08d9fa68483b
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:13:24.8167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hTKsfN53YXPFOkZn3/U1CK9TrQv4e3XvFMa5FYpvbgQuvl28ohHSk4g2t9JI/WFHRfVE4WT2WWl/5R0UmPTqw==
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
 drivers/net/ethernet/sun/cassini.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index dba9f12..947a76a
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -88,6 +88,7 @@
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <linux/uaccess.h>
+#include <linux/jiffies.h>
 
 #define cas_page_map(x)      kmap_atomic((x))
 #define cas_page_unmap(x)    kunmap_atomic((x))
@@ -4063,8 +4064,8 @@ static void cas_link_timer(struct timer_list *t)
 
 	if (link_transition_timeout != 0 &&
 	    cp->link_transition_jiffies_valid &&
-	    ((jiffies - cp->link_transition_jiffies) >
-	      (link_transition_timeout))) {
+	    time_is_before_jiffies(cp->link_transition_jiffies +
+	      link_transition_timeout)) {
 		/* One-second counter so link-down workaround doesn't
 		 * cause resets to occur so fast as to fool the switch
 		 * into thinking the link is down.
-- 
2.7.4

