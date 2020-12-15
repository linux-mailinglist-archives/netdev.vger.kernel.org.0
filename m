Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4722DA6DD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgLODbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:31:48 -0500
Received: from mail-vi1eur05on2126.outbound.protection.outlook.com ([40.107.21.126]:31329
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726387AbgLODbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:31:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0JxAk9gfNjqarjfgvvuFowmknXD9LPlXUHD0AWLRaZOIZRiAZwo8L6vH8VcZxKewI8aUnT0ACxUqwY1+dCNUyeHwNA321jAkh1ogI9/w3icm9lPIvETWtHbUPY28e6xM50GX2GpQGraqwoDllQVPao/eeL0qmEtFfuE2RZixPpItks9HPvqWlP98FGjRLQG8l57HR4TOePIyeJ5myLkAKK1qaDI7FSO4uad/FWOBFX6yCnTlQo/uERrlTeDEYeFqLtzvpRz+ThDTD36P6SZqHhiCkgo82jM/cQRMhlb3D5JROzSGAv8gR0Tu5470bxZx8/YAR1CsDtsRQQsr3nGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFYKJ12/pusig60sFY4Iq9ArkSuWZtuliFWfJp/4+aQ=;
 b=cn3GOjz6lXRYnHjsWgqKI4j5yXWozfuxPElkCg7oJuyKiNj84amN7rr6KsX6+DjUuoteYi6zJSSTmrTXH5nMEzD5ZskD3daV6QdgTpPgAoFkadLLhQpdrSyIkrh2HrysORzvSV+zthX7/Vrh5sVhV4Or4mRnHsahTtfNkPqow92Ifvz8sv7Mzu/CfRnnf2ro1WPhUHh4lZ3h2A7NyjUjwMg6y2AQDxp5w4Px9d7f8CufS7PugDTgKJx19buzDC0UZ7TLnF+YH0nE9yAj+BC2cYvUewqukNvGesaQOObmhj4idoAh0RkDXyCB3UZNfjVfK1/m3CvwwP3LOqX7a5VwAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFYKJ12/pusig60sFY4Iq9ArkSuWZtuliFWfJp/4+aQ=;
 b=IeTGyjTqbQlzSI/ESGtTQrrXZ2v65g8569p6kTKjbiYCT8jMRIdHLJqtK4qZJhIIVC+lLd3VIN21I+YmrbblnJFiBUoWA4Lt4yrAI05Kj0vUJKJAHz6uREDW8gFa85jKw+adKxizvMsdhP7IyAIrGg2rC2dy/InxBm4mljyi5/E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6720.eurprd05.prod.outlook.com (2603:10a6:800:139::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Tue, 15 Dec
 2020 03:30:43 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883%6]) with mapi id 15.20.3654.024; Tue, 15 Dec 2020
 03:30:43 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>
Subject: [PATCH] tipc: do sanity check payload of a netlink message
Date:   Tue, 15 Dec 2020 10:30:29 +0700
Message-Id: <20201215033029.76088-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: HK2PR0401CA0006.apcprd04.prod.outlook.com
 (2603:1096:202:2::16) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR0401CA0006.apcprd04.prod.outlook.com (2603:1096:202:2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 03:30:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8463b9d8-982d-403d-a93c-08d8a0a9cd8f
X-MS-TrafficTypeDiagnostic: VI1PR05MB6720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6720F884A0E99FF1155B034AF1C60@VI1PR05MB6720.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sv7GSLiNH7aXvGWBXLTpHx1u3v0PNimTtaw2wFNMNsTCd/iWX7gwHmQDswfVgH8Mxm7HI+zflnXND4PYPBypCg+ePkQJkYYWzp6FzlH8t2Zwm78NsFK8anc+sSLse5rQ2YMjz4k705OVnQp6evZoqOCdkWuISbVJ8j4SZ1O7+7WHr0V662RaD0+i4W0Nyb7qJdAmcN9n8mZnTnOwSlpu7cB4UHlOYg3twvdv4uPYMudOanX/tf55m2IX13oSS10vyNdByfeN7UHwigowKpLyZpjBf1tOeqJT/xrPne83Vn56RBrpLVQrp0v6ABZ3pRXS0mrhw312uKtwusJXASfWjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(346002)(376002)(39840400004)(8676002)(36756003)(316002)(478600001)(8936002)(26005)(5660300002)(7696005)(186003)(66946007)(1076003)(66476007)(52116002)(107886003)(103116003)(83380400001)(66556008)(6666004)(2906002)(16526019)(2616005)(956004)(4326008)(55016002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1gtLQLwbljWjN0LUcA8BgeWaEuBbvOa2rRgU0HnHFnzck3kt1WabpwcgxaHj?=
 =?us-ascii?Q?RJVwwClRWWeGJQ8X4sc+fLNUYd9ZxEQe7H7oYGj6J01K40Ftr9uQ/yozWEDi?=
 =?us-ascii?Q?4jXK31Lo/hjJBGBWbAemN5rmkmnKM5U54S5RD3/GX7gQwlfDDWwdsQBEJ6CC?=
 =?us-ascii?Q?xc+Ln2eNrdRaT9tdAiI6CC1+hk3kFhTCFrbxeKjVjWuaAqNpbo+i8iy2XHph?=
 =?us-ascii?Q?iLzjzcsX/qqnGo4CCcO9/zzbPArhLGRVoTkYDvjUrkU9iE+ktQa/Nssieheo?=
 =?us-ascii?Q?c1D7eq9/W3mabF0YWWQjA2jxB4boK7mGVHE5fNDUbblpnkpfQUGYjCTQGB49?=
 =?us-ascii?Q?KSmG3FqaS+sMqFEVK81MwnpskxGpm21BuhGO6lfVtsghO9XCmn4dZAkt2KWP?=
 =?us-ascii?Q?OjWfshBmG/2N0AENAm6AulN7VCp6Dpfb6XMS5bwPHktbXOgl66d0WRUJEJiR?=
 =?us-ascii?Q?kbgK+x8eQIgaQvIfyW9RTbx19NNJJ+yOWYoOfLpAfbWKZiUKxpgrdqlVfuo3?=
 =?us-ascii?Q?7Ag0cmBGxlpDuurQfmDcYQwUhV1a+IWyHqRcwHAFVu5XCfaz8pmqNnT1HAcd?=
 =?us-ascii?Q?pkw2LueipIJtQDH2aXCL+e8LVBvi0bX3q7z0945a6Hwa5fOpzevq3VY93rNW?=
 =?us-ascii?Q?sc48oD7AFQBjegQtfBbLxGqhHejihzmKrBUCXubi85mTkQ4laW1xVpUJg2zm?=
 =?us-ascii?Q?0erDgEkqXw6MhGF07qkG+d7l+A1dlaKmC5ZEGs4z7+6x1oQEiJrpMNV11tT9?=
 =?us-ascii?Q?sa+8oJx8WBjSMBE1XsA7irEs62iBC3K1BLIhd8fn85m/OeQye9CLsW8VUxg3?=
 =?us-ascii?Q?EGUlMiunMGMdELFIhxua5VSW6GijDAvw/sdvdvJt39CdZ6kf9jGx/nDK0cGi?=
 =?us-ascii?Q?qF7z+I5qjugT4MIk8RrfMnyM9XwKr8B9EyebNPElsx8oIkswTUbfH6eMNx7B?=
 =?us-ascii?Q?QXJhMB1gaSKt1iIYnZHihvB/kbPgY0OJ1z/zN980SiuKSrAeEtFfnneCR4Pw?=
 =?us-ascii?Q?kBnt?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 03:30:43.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-Network-Message-Id: 8463b9d8-982d-403d-a93c-08d8a0a9cd8f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJ9KawKYSbqS9fAXrh0zAaDg0ge+1OsmBP6gOlOGaiL4AZOv3RL5roCCFdKDVHWkt/AgLC8rW1dT1iE+LsgTIu/9r3Jsllu0RcAlqPcmKO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6720
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

When we initialize nlmsghdr with no payload inside tipc_nl_compat_dumpit()
the parsing function returns -EINVAL. We fix it by making the parsing call
conditional.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/netlink_compat.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 82f154989418..5a1ce64039f7 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -213,12 +213,14 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 	}
 
 	info.attrs = attrbuf;
-	err = nlmsg_parse_deprecated(cb.nlh, GENL_HDRLEN, attrbuf,
-				     tipc_genl_family.maxattr,
-				     tipc_genl_family.policy, NULL);
-	if (err)
-		goto err_out;
 
+	if (nlmsg_len(cb.nlh) > 0) {
+		err = nlmsg_parse_deprecated(cb.nlh, GENL_HDRLEN, attrbuf,
+					     tipc_genl_family.maxattr,
+					     tipc_genl_family.policy, NULL);
+		if (err)
+			goto err_out;
+	}
 	do {
 		int rem;
 
-- 
2.25.1

