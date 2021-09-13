Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42825408836
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 11:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhIMJa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 05:30:26 -0400
Received: from mail-eopbgr60113.outbound.protection.outlook.com ([40.107.6.113]:47747
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238597AbhIMJaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 05:30:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KokTzdTkwUOrKc9LMPS5tnHjk214IZnQBEj4F5o/63sedBgYQ5+TU2HxHALip2bh8RF7dN07Uk/6NjWQeDVFzERjP0lQYHi6GdtnP9opdzcQnKggcRQE3TrKnbNNBrgs02OMdDwoQ1+2QAUusf04zcjsDBaEFbFpS4AjJG+vDS30IFw/r6cWCtEeT/xK2H11CYWP+joqWjMfuyWVUPYdy3dkWWymNurCzhPL/u422/v6VxvDZeGxGOJEd4ElMawsvsxxmt1k+CMIcFXINfQxWgfrxRsWEBRe7749XO1FC4Pf/uh0OLYhY/bCHtFw4pBQINbK8sEqEXwt5TloFjpZWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+sdWEeEOWeGRTUSi/M9hxxbx2E2gIwzi8wAAJp3kgKk=;
 b=bK6JnrfTffjLDuHcahHIC2FRnGyHpV6hKRwbJDgCRFMHy4ZVxsBFD4rZbxPIvzVFajRAsPAT02vqnul+cN5zGx6kt0jpPKq3WPb3vSiuaaHaXYWOrq4EXJyN6MmpW5rsV8Tv3im71gZ/RYRpWU79iDAUz2ZS/4gc81Qq2/Dh0KziqO7v2DKiK+Sd+mukPM0lUwV70pKY56QJved7tcsunGrM0kZ9tXk7YOkZakkefpbpjT8FYuUPQSKCxxsDLoM5cqhoaxrGFJn2/Mp26UkmDQuwexrWXAH3d1nIuCRTcLwkAJD8B/G4/khMCS3JNQ9RV4jcKlYnijHBXGXvFJhBsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sdWEeEOWeGRTUSi/M9hxxbx2E2gIwzi8wAAJp3kgKk=;
 b=PMv4CA2lvEB6FpoHR+TdfKo8ZINDt33ZiMQVy4q2pPdXdwxTkmxHIybt05dVmV/WtmJ54siOlhQG3jPzehONcHq+cWpH9W53r86t5c+rJWfzU+BCArHHedzdTmKzcYgxJ8a0m4CYIHu1Sy5AYxONE6h1cAJRxyrHC/bLxabaQUw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com (2603:10a6:800:1b0::18)
 by VI1PR0501MB2559.eurprd05.prod.outlook.com (2603:10a6:800:6a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 09:29:07 +0000
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::31d4:18eb:d210:dce7]) by VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::31d4:18eb:d210:dce7%7]) with mapi id 15.20.4500.018; Mon, 13 Sep 2021
 09:29:07 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, eric.dumazet@gmail.com
Subject: [net] tipc: increase timeout in tipc_sk_enqueue()
Date:   Mon, 13 Sep 2021 16:28:52 +0700
Message-Id: <20210913092852.10271-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) To
 VE1PR05MB7327.eurprd05.prod.outlook.com (2603:10a6:800:1b0::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (171.252.154.213) by SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.0 via Frontend Transport; Mon, 13 Sep 2021 09:29:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2cf1663-5af5-41f8-e379-08d97698eedc
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2559:
X-Microsoft-Antispam-PRVS: <VI1PR0501MB255921435373D4F6EF12D9DBF1D99@VI1PR0501MB2559.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4jPCEvg2Z5JUxutvYsd9DKc85A5OuiegLjBbQgntLnq2rYzsQA0nPysrYvax5xAhsrihIsKNDA8lxDsq5TkwCsENRv10vYdyNXcSTLseZIbVatgy1PisQJOx8SY9UNa3DuGFr0nLIFIfSaECvJhOBkeOB569m5pAMzhChxqumzOTc1fyE/5LNT1VKDUAzm+qauXo+tSzswELvh3u7KsEazf5mU6lNSdk9A60nFP5AsERm6if6McLbE8SFWMp7+0I8rPWUFWh/n6WCr9k3M7WNoNSDvOXpnvesaJZAwupzGGtq+f0GNgSkrXbk5Q9CSADvL2gAvzzaup4DJyAZvjeCurwAmA51w7vRZcJmx60p5f6Fhnh3q/pTbGm0bHRYzFjV+8lViDZuGsRIlhl+arS+QlEKPu/47vqcadY+vH9a7YWcajfzJ6f8vC4NAgF+/vdfPCWzAgWQl8cEJfv/3ijlKY8dlVpojGX853XNGsVItzHaSCDlz2kqNgoNjVG47OS3HlnNF/SU5pcswCqx5NCShcMmMo/iz0YUSduGp+pNBgYvitgSbqrU4S3bteArTr7EHBe5QCTqPuYD+saixelAkGW3QbKdBDVQhKL0k2TSlStremJz3Ob8KKNlaKmZA+DIMoXK07n3aL23ldMW0UBN1oYue1KSdeVvodOQCYhQGAd8FWsVzM0FJxRQ3gl2HGK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7327.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39850400004)(396003)(136003)(38100700002)(2616005)(956004)(7696005)(55016002)(38350700002)(8936002)(26005)(2906002)(103116003)(66946007)(8676002)(478600001)(36756003)(66556008)(86362001)(6666004)(5660300002)(83380400001)(55236004)(186003)(316002)(52116002)(66476007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TSknmoPIZlSw5sQ9K8230TMWJifqNXV341rG18Jc9X184MbMt2iuf4Y0i3qE?=
 =?us-ascii?Q?Ml7VtQrTaBG6mZOrKK2QheswmCY/V1uHYq42t6YaUGd3avkAJZ7Ks/OKl21c?=
 =?us-ascii?Q?tdvU9rkX7aRlm0Np812qf0O1hn4s12DKQ2UHC+YpYAsCfpK8R9GIMwoIQel+?=
 =?us-ascii?Q?uri25cBVQGG4anhBRqF3kVedF3ov82VLHIBlKUBWh7CsQGB8jjFPzL+E+UEI?=
 =?us-ascii?Q?JCthRmqaCIeGjeXFY5SR0KuFKXLd/LuH7+lW5PhLUxeI5A/gKNagDDFZm8uv?=
 =?us-ascii?Q?qXihhdwosWboISKh2BkaR8y+H6NbZcZJ+QfiWDer644PHSPA/GuLCu0cMi9n?=
 =?us-ascii?Q?nRf3Nnt4qWCENNmmpiTgrk5+K1/jhpPwCYQSQeoKibTdwpYXkYfF18RZTXMM?=
 =?us-ascii?Q?3TmGzzjV9UlGvme6m798G++kKm9omUd0q2S16Bts/KZ84PsoauAOUHHAXl9Z?=
 =?us-ascii?Q?u4snJIwM2J+1J3QzjFaVprpg6UkL5slYzhBY27s8usa5tizSWbM83O0K2qaY?=
 =?us-ascii?Q?wLcxUZGk/MQlVf1kyzGxLjkAd5CAznO3GGmJKGIuHHN22Zq21n1p2iEn6LDG?=
 =?us-ascii?Q?9Ph+P0V4vTIPZ51Q5/3M6t3T133GigdSOiSGlMIs62oj7pSmYi4obuYcq3k4?=
 =?us-ascii?Q?oABgcaRmbqbputI6hLSyb5d1RQlttFq3V/MBi7u2nsHYgp75nVqqks7em/vw?=
 =?us-ascii?Q?L6c7+iVMmbfrM49IDsYi7PRgYH2n9BPoZyzYJrDH3Wt+nLwcKXfYUdvfSvR0?=
 =?us-ascii?Q?+6oQ/aNIYdzKEg60JMpLtzhLltpkBDINJyKu04ffdCQaUeNJuJf79iQWEZAq?=
 =?us-ascii?Q?13+bBBGdI0iQbG+DoZEcO5jqqUMX3wpT/XKxrm4c+g7qBf7NoxPV0/A0kSsP?=
 =?us-ascii?Q?znzGCEE+/B8BhSMtFTZXvZm3Mrqyy/cAlLN+JDxfsBVhAHBkBiI56g32/9y/?=
 =?us-ascii?Q?6JLt5mRRSnpclN6J8oS8iN9BqWVG5Mnj/s5u56HSmDn/jnhrnwFQ28BEIjrw?=
 =?us-ascii?Q?z3ACIds14HhgZbIfpGq7rAKD5kKvZzRGYmPUvQjGV6/KmlDogQKdFHmDcJBB?=
 =?us-ascii?Q?D9yyb2W6IV01FM+TZzh0lK7N4H0izkX3vqFf9BTg/Ybq0OsaBkPGT6eC1xMn?=
 =?us-ascii?Q?vRyLIOya/Sh4k6KnMidnLy3Ov1b8tTTZ6plLfuAQonlnsxWz8HyebsR2v8Zx?=
 =?us-ascii?Q?zOSjKyxdIA2t0LZJH5IDJPXi7EOwMUBlhy+XaNUJ9E8f8M+f9TFbt/mISzTc?=
 =?us-ascii?Q?BpGFhn5J7Epa2NzNA12DBghcfPhaCKtk6t1QZTJLrYtsTST4cU4ifWz+MddC?=
 =?us-ascii?Q?cc3NNhl7JQJ5fV5pP9cHTL5F?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: c2cf1663-5af5-41f8-e379-08d97698eedc
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7327.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 09:29:07.1264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dczo6Wp4/hgjT9ECRPwJ4a/Tdk/pvj0B7ePDZXTlu7NRmMTJQODE6QXyeji62qY+VIZep/S6tAicfGjFE4xxQWsZ3avazEWLxRqn2xULeAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2559
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tipc_sk_enqueue() we use hardcoded 2 jiffies to extract
socket buffer from generic queue to particular socket.
The 2 jiffies is too short in case there are other high priority
tasks get CPU cycles for multiple jiffies update. As result, no
buffer could be enqueued to particular socket.

To solve this, we switch to use constant timeout 20msecs.
Then, the function will be expired between 2 jiffies (CONFIG_100HZ)
and 20 jiffies (CONFIG_1000HZ).

Fixes: c637c1035534 ("tipc: resolve race problem at unicast message reception")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index a0a27d87f631..ad570c2450be 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2423,7 +2423,7 @@ static int tipc_sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 static void tipc_sk_enqueue(struct sk_buff_head *inputq, struct sock *sk,
 			    u32 dport, struct sk_buff_head *xmitq)
 {
-	unsigned long time_limit = jiffies + 2;
+	unsigned long time_limit = jiffies + usecs_to_jiffies(20000);
 	struct sk_buff *skb;
 	unsigned int lim;
 	atomic_t *dcnt;
-- 
2.30.2

