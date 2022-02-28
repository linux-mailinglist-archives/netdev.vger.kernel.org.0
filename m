Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4374C61AF
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiB1DQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiB1DQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:16:49 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300110.outbound.protection.outlook.com [40.107.130.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDC8522CF;
        Sun, 27 Feb 2022 19:16:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ib8nSIKZiBQMP/e2TX1/risesE4ks20zJUNnqSl1KXc4D8alOjXC0brQ25WGxfxJr4+z5gmAIMAY8UqjYDlKO/Lr7BHDfhpTCb3E4SgWzSQrUlD52RaV7PbW0zHNtJ0RV65FrRVT7aFcuVsMiuP0hmRqBRUFN/KHDuGEOLKp7lk8/nfiBzBdJPj5DFcUmonIws3duct8T9/GuKsluDLM6Ez/2mNXelyyE4cIAw/fSnPtndAIkyj/m7ZWIqVEyeiqcfhgLT99eEZrnkjxHloJbzlQR7Or+wiFDSNO96ok09iWMfUYXhzsCIz73PUarVMl90e3ttxLBCg9ZiPR+jjzJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lGKUUEr07hzr/luZZlXsQ8iZvsgHRnKA/qfTj0/azHI=;
 b=ogI61g+97nhOIa+YtZvfPuO11orI7EAjl0O3amljVQVD4YeIxmLjGIn/BEzJD0fDWeskXSRuJFpt1vIFtDRJo+wEhe0df26TchYyYdgOwfg47oWPtVgkNWoARMMICuumXzfQUOPYbvr/yPhRvBd6SFN0SO7f/Wfv+2O5iSjIx91n2PwrY/b0dJOb/vtqHAVN7VpXnDdEsW2HaQ+/eOdDSS0rYYVK7doGdx9qN0Wxfbi1PKZT03jW5i6ePSN+ir2baZ4MPuZ8LtySIIDVy9Fd59Hk8EgctdiL6WWCNaR1jbUZ8uGw9aQ2xBFHflRfACLWPDcoDIxrejZcxXksMzJqsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGKUUEr07hzr/luZZlXsQ8iZvsgHRnKA/qfTj0/azHI=;
 b=VwYnqphaRq4+EnxjIfhY22VcP2eRol0fVzgDGOn++YRoKllZ4QDnSeBqhY712HxxAScQZGj+qUU+xBTZIkIWvmUjaeyMLUogg/BgO4nQl0stSmA0zigP37FhFSNUHXDpDKvv349PDAwNUvbx0+YDdHDWKj3z8vmNdSRk0IyV2vk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by PS2PR06MB2454.apcprd06.prod.outlook.com (2603:1096:300:45::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Mon, 28 Feb
 2022 03:16:08 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:16:08 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: decnet: use time_is_before_jiffies() instead of open coding it
Date:   Sun, 27 Feb 2022 19:15:55 -0800
Message-Id: <1646018155-61556-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0100.apcprd03.prod.outlook.com
 (2603:1096:203:b0::16) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa7e6be8-2394-4494-6b50-08d9fa68a9f3
X-MS-TrafficTypeDiagnostic: PS2PR06MB2454:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB245418984D63FB25C2E64BD8BD019@PS2PR06MB2454.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4SSAas2zn7MU8V8HbqO69IMri4KWOjCRgxfq0Jgy+V83Xul1RvwYtQ9PIXrrAGCdlfLBdybT4XHcIdWbabn7geUi7nlAl19lICprprxC+abQE6V7Otpco0pB2rNO8vxKjrol2j519FwBdSJU28JBqVb9U3j3Py9cetDnJNsA7Zzg9HvLMftTd8nK+sQzYBtg1wchFW/5Kdc7rHQF+tZdUkUOS9kDzwVwWADBofQagHz1zFePQWW0HDeSwTXfJ4+xlkU8U6oEHXO7ASxRjGcPB7iWlXLHXaInTbWFdRYLz8kXRUcGwfOuGgNhEsGPhnW2yF70osXbcu9ko7cGf4UJw7EiTCoGmf/mMF53H0Aw8X/PE79tbWqUUjpGloxIy6eA9miE0ZHYCEDbCUaI47El+i1y2lS5OAhuV1/TC54d67fBpzXYNDt5HbPOneEhBYQqfnr258+JvUfnoYo9xl8SGFVpYZQaDFkQOtMevmDmok8JDKh8oGJ9YCGEeOjovSIYRvdta/7y/qp7HKYNlpcqpDbDx5LB361CK3QaqOFTkaL7Pc24t2Nx0k1l/2ECnNKa/Mdys/9gdFo5g/04nq7ZbUCKRDND779MhRNAY+3sdPB57ro8XjJyAxnje6DzKxQrrSorVlsmSEEX7b+niAp4kWb+l8DOKNzz5Cv1huc+fIqndaQNAkobKWVxm4Xo31r1TdNxKx8GIP48rh3vRbMPew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66556008)(66476007)(66946007)(316002)(4744005)(4326008)(2906002)(86362001)(38100700002)(38350700002)(8936002)(52116002)(6506007)(6512007)(8676002)(186003)(26005)(107886003)(2616005)(83380400001)(6666004)(110136005)(6486002)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1EqN30g7IRQJ3GUctOokkq43twgT66S+KTbqz8CWM26VmJkYSdM2LWA+/+aI?=
 =?us-ascii?Q?iXxviswEPtceBU2vyfz1kXsqQL4AuapOMu46dxWuIVMpD+rQ9T8rISgTDnzq?=
 =?us-ascii?Q?9/DjSkwv6gQCvwI9o7ugIbIDlW+wM2W/htr21jYnOipFnOP2clp7MVpIAGaA?=
 =?us-ascii?Q?h/Ob+rR/SYr8kE2QGwkLbKqIoLE0yM3KEy3tCk8uuItM4enE3BsowyhueGJz?=
 =?us-ascii?Q?WVvsV+8E+tX1fsiVoOaD6a/4RQELhBVZIU9cUTVQ/Ix9NY/avOPkztQelEyp?=
 =?us-ascii?Q?hpBvT9LrNVHSWjLthZIZg/equXnVxq4WDENDfwnw/LZiS0v4xlpo3JsTS7wz?=
 =?us-ascii?Q?i82AFm/TNE8WH/u+eYeCNXXzw8Q0xYaNo/aPi6Hep0dCQZ/Wzcdyyz4pgFSi?=
 =?us-ascii?Q?Zmsuf6arDYywC+GH1iMjPHXzKDwmjLnsIDwHIWsQcoO1m8/esviBIt7d69yQ?=
 =?us-ascii?Q?3GNQXfQpi2mVoCEeieoGXB1q2m6MfodCzaZdonCHfIuIi9mbHH7G/K0RVHFT?=
 =?us-ascii?Q?K0Zh6xOVUyusjCDg/4zSxB1uOLZBr0AoJ3M5thJBCTRAnVnxYVL0tUSNv3Sx?=
 =?us-ascii?Q?flqyHzFMzM9TdPg/2IIka5/vW5Iqp82UXqcXU82E9l1YVko2hyFnFVXEY51E?=
 =?us-ascii?Q?nbpLhLynX+h2Ci4wsctYta5cwP7hL5UGtwHfFySLzeltceOMUK3IuxOTVA+b?=
 =?us-ascii?Q?+SqizxnbI6PNmX/DLam/By1u2TEVYED6yWcEJ1fEQy1fKw6S3fa8R3FLh4DQ?=
 =?us-ascii?Q?4yncIvXKO5N3WFoKb15G6fwEjLYWK9S/CWzEpYV/74Xq00izkNPIYh4F1iHp?=
 =?us-ascii?Q?EwWlR99c6nYoa4K+WehAaxYSbSkcwb0qw1eKXA28ha1qRTO2jIlxik5XtFDs?=
 =?us-ascii?Q?SaGwHyRt9IDnoxZJcJTiTKp8ahq/f9iQC3F+0QuRqiyn67Tzvo7dZonW6D2O?=
 =?us-ascii?Q?4j4LVj658tA/Om7bcDvA1lkXYStEfKNc4IBUabobBcyXn4O91QB/pYeTbjx2?=
 =?us-ascii?Q?DpLOWcFCsDsQMnf7DuMsw3FDKP+cn1aEoMuswLCxrbJ8SaqRbeEb6AF0I30k?=
 =?us-ascii?Q?VQYp0BaQfeNwlghyg8Mo7SJZiHoLq2y95i/IhqE4m0gT7OL0QhV7VBqda5Q9?=
 =?us-ascii?Q?NUfie1hE+J7sqvAZjj4GJ1955IfHCq3MMRqTXrpNE2O0cDu7JbnuyGOfwhbS?=
 =?us-ascii?Q?w+t6j/9skh++6cOA07OhTcCf9kC46/dAlUEHH9xkkHuUEmHr1x4RPWN1/8nJ?=
 =?us-ascii?Q?Qc9b/mxj/ntm3qy5JtPiiT13QuPdlpnDHH2U/J4gLWLAHu2TtNWR5flEs6kK?=
 =?us-ascii?Q?KXlvuUUtJZkb4opV765FKa9Ka4YGxNDAwcyFbcc5b9hA5HDbzJauK7FBvUFQ?=
 =?us-ascii?Q?kKiW5ZU4oWZWkmgs7eTWP59ZzOLZw2CseuDl0NfEVbrR9Shw44M+b0sn1GAh?=
 =?us-ascii?Q?Lkv7zf21tJWphnQmdnLvOzXfwyYoRXmc1rEIqcvX15F73caR5ixIpQBpBY6z?=
 =?us-ascii?Q?D9iHTQxQiedfSvGxt8txIJXVjXsBuM9g/4szsUb4TvrN//yAnfWWx8KhukaZ?=
 =?us-ascii?Q?mcGjBrkpSyPmWHUkIsfB1OT4H3EEyXA3gFeGJnzyrh16vutkFvWGBMMw404G?=
 =?us-ascii?Q?oMPmTbPp4V1LDE73hvZ28pU=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7e6be8-2394-4494-6b50-08d9fa68a9f3
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:16:08.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XItbpQZ9WPjDfqdZSLbdJMhKNNCWIt8gffuJkIetI2lKGGjUPN06tiLWppyTAV+XsorgIUALew7sTH5ZjacAdQ==
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
 net/decnet/dn_nsp_out.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
index eadc895..b05639b
--- a/net/decnet/dn_nsp_out.c
+++ b/net/decnet/dn_nsp_out.c
@@ -52,6 +52,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/if_packet.h>
+#include <linux/jiffies.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
 #include <net/flow.h>
@@ -351,7 +352,7 @@ void dn_nsp_queue_xmit(struct sock *sk, struct sk_buff *skb,
 	 * Slow start: If we have been idle for more than
 	 * one RTT, then reset window to min size.
 	 */
-	if ((jiffies - scp->stamp) > t)
+	if (time_is_before_jiffies(scp->stamp + t))
 		scp->snd_window = NSP_MIN_WINDOW;
 
 	if (oth)
-- 
2.7.4

