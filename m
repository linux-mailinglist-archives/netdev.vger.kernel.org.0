Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5614C61A4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiB1DPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiB1DPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:15:10 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300120.outbound.protection.outlook.com [40.107.130.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BCE46B3D;
        Sun, 27 Feb 2022 19:14:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyJUciPMtZN5fH3c0zovWa4K9KiD/tuI5uxJEd6qx90R9Frlma9IKbMcFg34xv9MzjKV6VpB4vU7I0Lk85MOIvXdL6/pP36Xbt8f5VM74sN5yZoe3dfkechnmwuekRhrbiodl6kePL+wcj3P65QFPSPfDBHSSjkkiEk7A6awHgpxJuuP0HPqHFY5hKk+QsvhDEnlokB080HkTCoOFy3pUfig2QP+jiwUx3edUSQ7lcZCq/fOq6z/kKr8sV+tfp5btzjGaHw5ajfQy1Gd6wxRSHtax5nkDqhGMMW7U90SPMD8pLVRrnz0y3NenkLbvKXlPNAoH3SWM4ri5/3LsaRYrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYCnTyH3vW2COYxZApTsgjum+3hsCXQMFB6+xwMsQ0Q=;
 b=mkeUi6IT40SRhW83sha6jhHLyJnEN4/VZBXkXoGsir89ql2QCVxX8QNYhTNv4CowrEmtBIGalGR5Ul02cwxA4lLIoeRwUnTYE22iFOJRnseYvwt4DzePg/GMcXpByXoMiIOq7CX6s7Ane5VS6YF5gAEnh/A0ymdkyDApaPs8zb9qMY9blkukGOVN4lI8j71LJTpqXrv0zpZIoMxGyWPRhOzfmDNobP59sTEYOFZxyCqd33iO0ic0xE/b4MNcQFONzoyWLxRMaugWEaioKwJyPKauNw8eyQmnjvwmhEKtHedOCYnFGLL3sQGQvKMFtGznXrE2CwJZq9YthdhCAtZymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYCnTyH3vW2COYxZApTsgjum+3hsCXQMFB6+xwMsQ0Q=;
 b=HuYmwbWJ4DzmikV6l3D4DLAr0EOnx8tpqy5kEw0mhHPIJmo6J+tLNvBZYOUbDSWajgOn3bgUwPX5Q2l43woIEYs/JsLj2UnT1g611pl7Mr6IkEgUwtdSU1CafqsLYgcoHbm6kt/STcOkbhUAFaqWHISlBNzGiBtu/yxURFhT1Co=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by TYAPR06MB2191.apcprd06.prod.outlook.com (2603:1096:404:25::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 03:14:28 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:14:28 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: wireless: cw1200: use time_is_after_jiffies() instead of open coding it
Date:   Sun, 27 Feb 2022 19:14:20 -0800
Message-Id: <1646018060-61275-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:3:18::33) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d59e7b38-d6fc-4b28-cf46-08d9fa686e48
X-MS-TrafficTypeDiagnostic: TYAPR06MB2191:EE_
X-Microsoft-Antispam-PRVS: <TYAPR06MB219137733D0F15F7372A96F5BD019@TYAPR06MB2191.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ynD4YwV79V8gWc+r87S/TFlpaDst14xK7gh6xXcwGt50/LpC0vtihUj1f+Yt7DnzsPiaN6J/wyI8kjVhlbHBlmWX9alqCdMk71pEFNbrqpiVb+x61WtRreOgdxL01tiE0+k29oPyw9uouu/st2yUf6fPypWadpNQvI078jZaM/Mt6Vbgnz01lvRruJmHy6/27cBGeqq+q05tfatEj8Bb0qWIwPrEVSPKm5irI6w7/m5ub93W7fe1SZ65cOdlJQpOYffm+r6bPMJRT1J2nVmwFWC4GeGS85Q7kP7AH7RWHE+F58+XVd1aQDJ04cwS6s58YqiiIgJCH7nrVwsaqOKRtgB/QVaBtlG1AE/so/XCQW2T7ySwMqgPODQ8eul/wFCOZS5isnRIqDyd7oKoTa16iFqF070k7S458cxiTfe+Sj//hgJ+eHNKO6zYWfdAklBzcgeqgElmy8p0NQspy4mHiRm2qGJAZGfsGJDq1f5PM7FowrYXhSVKSb6E8hFQRcrpI/cdnTnP5vkcX1S5BJTdKPmQFyaZKxWwRrt9ChHujYAL45sMNu2T4CBa8j2xTzreI6dWmGdYF4qMbj6jyly2N138W60DzV3skwvZtIlVxZk3EeT5DfUCBHuswwJc5+hk0VFE+XhsMXqLOJO0cRKjVtNIW+0ZGpHUlu42+jDuRQzFRq1yrEaSAS5rKXbZq3m3fSHDhg+SM5PmsLlnzh/rRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(107886003)(6486002)(6512007)(8676002)(8936002)(4326008)(66556008)(66476007)(508600001)(6666004)(36756003)(83380400001)(110136005)(2906002)(52116002)(316002)(26005)(2616005)(4744005)(86362001)(186003)(5660300002)(6506007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JqBMcEao2/e32QbVFBHcnKYXXd1oJzi8HcyNu3WxJz5O13VMOEP4BSBGs99a?=
 =?us-ascii?Q?u4OeBTAyc/coxL43o1tLT9APLhYgwbun5Pzt8Meg48lIxaIeYA9ch3CHsw5q?=
 =?us-ascii?Q?Ahu7OS8IaOAha6QjoutU+ZP+4+SBfWGGDhrRTBeMB2lOadtga46uvLDb9LKR?=
 =?us-ascii?Q?vX9AM//12Iy9IyXCo8aeO+5vLJLoDVU+moSKJpEEaZhxHLRtHt5bGLu7SO1V?=
 =?us-ascii?Q?Gk1IYxG7jiwY9J1Kb/diPp0V3yqtmrcJ8OGD3oryjQVn8K2k7rYNRXTyO8tK?=
 =?us-ascii?Q?QB8M2ICr4oMX8MEF+jFAe4wUbl6ztCfIE1Qsd6xaMzNaVcYDnBoO228O5ZYQ?=
 =?us-ascii?Q?BfDj6Lue+tBA5WlHu/C0bT1Lnob0BDtuIPQ4tzMEpGdoF9De7+gCWdL9BoM5?=
 =?us-ascii?Q?ezdWSPKtOrGZp1HfR1BLhaHuCXxRNmPC7wMPutbNYXRvHPcdL4HAMBx33rsb?=
 =?us-ascii?Q?oE/dENJAj1mCPoQoQSSIknhNUGhnrzHqQgtWoJnGHUJ7cg+R8HRAH146/+4z?=
 =?us-ascii?Q?hASMlBpdweVmLqV3n+DtdDCZ8uGs5x9p5JSE438AD5qJumkvUxTpz5mUaavf?=
 =?us-ascii?Q?vGasd4Qm64XnUoWpmn33OGjreGe5t98IC9wM+0Z7OuNV4D5rtlfF5ai+rbDz?=
 =?us-ascii?Q?CSlaYG/mfd1SN9TqfKR2HCshVF7T6zVVWNWdpTVqzkKcvjpO8JIOoVz6F6vn?=
 =?us-ascii?Q?Srf9eLMiL2sHk+WGcz888ZijT88iKCGR44Ktnkquujs3Q5c5xFrieFdeOJTa?=
 =?us-ascii?Q?dNKbhJTSPIxSmXxBrD6vtPjpRzP92zY69NqdDxjSK4hrg5DWoAh/t2CJn5k7?=
 =?us-ascii?Q?QY/wMuWDA3uqOCzsowoE7Y9TwO7z23/i7tLBADaSax55tljCHM4DSrRiDwTZ?=
 =?us-ascii?Q?mS+l3jL49m9lx3v0eKOE9NQ6L+jZbCL+nI8DR4G9x17B3nmyog++wK4UD9oJ?=
 =?us-ascii?Q?M24WboC0RPJO1Tcp6/1i1iu8pIz9GlxA40bL27ronb5x1PD2O3DHRr3yQhwO?=
 =?us-ascii?Q?RpOti1JLLqCd953oniJeU9oCxfa4b7CWgmAdXBxw5fbMhz1N9kGcyw97Iqyt?=
 =?us-ascii?Q?t8kVtpOOSMMgHceXeR84lU4RUarX3XC6scmyZD3EeC1sWj04vKYr9rgFE36e?=
 =?us-ascii?Q?WrASrMBvbSOQccMQR8hsgqNiMbwhn8fg2k88y/9rp5ByAXoG2JvF6LaOZFty?=
 =?us-ascii?Q?BgyJhW+Iuujw3oII/2EtlUuFW7dKpoS/4MBEjiMnTBNkU6lbof2kCHsPwSgv?=
 =?us-ascii?Q?/WvopF69N/bGA1qSo5Mb2rcxWOKXIsHHOhUWkDbzZHVR6rYwxMQhnMV2HWTX?=
 =?us-ascii?Q?DBPAzkaoyZZQevueWE91XXAdmJiDf7Eo1lpveOtwNApIGuwATloqFYfMKU1g?=
 =?us-ascii?Q?OQyBrNiPER/vTkwAbvKS5xKuKqmyFSCfcm0WMaFl5OtPuQ/q5XpMF7t63MXp?=
 =?us-ascii?Q?E2ivf6JuSszK1lIaQ5XYZANwrvQT7sgAzGWjOLR7NJC3XckvJFnmcpE2V9FF?=
 =?us-ascii?Q?M5AZzxTOcAa0N15zz3RuUkNx7wNzo9628OkhIhA30/q9BnVlt91c9w2hiFS1?=
 =?us-ascii?Q?0BoOp37aJuE4DldPqZ5atFO/Wlwe/82D3YKdMDzCI4UnBbaZz5jzk2MDz/Ry?=
 =?us-ascii?Q?pDmYIghcUEwiJ1m+ONIXasI=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59e7b38-d6fc-4b28-cf46-08d9fa686e48
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:14:28.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdDP4qjzqzQQpmKGiBv4WbgivP33phO6HCOX790s71MmLw0duwG9PUiveU2iUSm/RNnxxlR9/bql5XXgGdSmPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2191
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
 drivers/net/wireless/st/cw1200/queue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/queue.c b/drivers/net/wireless/st/cw1200/queue.c
index 12952b1..e06da4b
--- a/drivers/net/wireless/st/cw1200/queue.c
+++ b/drivers/net/wireless/st/cw1200/queue.c
@@ -8,6 +8,7 @@
 
 #include <net/mac80211.h>
 #include <linux/sched.h>
+#include <linux/jiffies.h>
 #include "queue.h"
 #include "cw1200.h"
 #include "debug.h"
@@ -94,7 +95,7 @@ static void __cw1200_queue_gc(struct cw1200_queue *queue,
 	bool wakeup_stats = false;
 
 	list_for_each_entry_safe(item, tmp, &queue->queue, head) {
-		if (jiffies - item->queue_timestamp < queue->ttl)
+		if (time_is_after_jiffies(item->queue_timestamp + queue->ttl))
 			break;
 		--queue->num_queued;
 		--queue->link_map_cache[item->txpriv.link_id];
-- 
2.7.4

