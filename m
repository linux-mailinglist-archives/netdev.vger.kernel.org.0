Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EF84CBF5C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiCCOCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiCCOCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:02:33 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1046C188A08
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:01:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFhkjy2LhO6cOlOPAFoNEaE0DGedtQrbvoy34SO6lNE+vYPPMx/7eaRPbqIOd0uJkYre17mcdoxuKLpP6pKbDMzaymcAxQfdAn4dvTnR4aAkReIdjKUyQw3jDYNAca6zkzGKS9qwn+/35MUFZoJE6M/jLw4O0bqvC9I91l34k0YKoQtytuW4VDAU1tm0YC+NGgNheZREb2i+N2NI3uWNADv/R9kOgRdwtWm7jO6BwFP9adRZfoxeNS6tGQRyp7W0AvI87xCO7v37jBZEWZsu2ad3oNtlAJDRflfHk4fjnu81skliJPzxQ9V7wPM5hv5yBm+ONVOWvVeQ2fBBCxy5/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwDU1lttu5I7Ls3Th3zF3hIjwqW37lu+K3Aq6+ZmCCY=;
 b=eLiuQXFojfq1Fk2LUHv8aXio0I6au1FKvyonehnRhy/BITlxCv4TntR6LXtmLNkEHNQQhy6N/nPYk0HZ8Yml0m6CjN3j+VlKUA+N38NhuBfCyqZyl3ctADFJl1rYK+DxNT+4AkSZBE5q/5Oalc8rw37ac0OT5xXudpgd+x0PnnG/Cu4S1cZ0dzEekEh/1Q289Twm9XQiCDxedL0/qIv6GGFuEe1nqeYud3uHGDph/8XaqWNZ+6ucabIqEX+eo9Xxph0TF+1LSWohIaTd7CVS8bMAT/UxIoFzAZqsxeQNRrcygIE0mfxxm3EAQO3mpqubJ/4Ut6CdLxi/v17OTfePtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwDU1lttu5I7Ls3Th3zF3hIjwqW37lu+K3Aq6+ZmCCY=;
 b=hCiMd+LlraUrJBLvkavZbidi3XEUNjvfXf+1F8eWQ0WQOVQzk9A8p2aYKXaE830rVTQWJ+CIucrKH7Y96tXCgFvhvKg8jJ4Gbs1Jx2o7qiq7AwVMjtrVflOeyw7YxcHr3NFmnfT06r9TQhofthSAcF9si3N+MkNSVe2koAJKufE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8879.eurprd04.prod.outlook.com (2603:10a6:102:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 14:01:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:01:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/7] net: mscc: ocelot: use list_for_each_entry in ocelot_vcap_block_remove_filter
Date:   Thu,  3 Mar 2022 16:01:20 +0200
Message-Id: <20220303140126.1815356-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
References: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:803:64::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fac42471-dd74-422c-61a1-08d9fd1e5890
X-MS-TrafficTypeDiagnostic: PAXPR04MB8879:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB887976855ED1840F6118EE6CE0049@PAXPR04MB8879.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRKoXKKYkhM/5WTQp7SDP+DLBWOF9hlj8JsxD2MiwZytEDfmSbnOXk0hoPCZkwcn5VKcC+cMl7/nApLPQf1Q85xTfwf3z5Gfe2IhvBmSWnORw2RYGCm9cYxbiNi9iQ7X5WT5dqZoPFTOcQMRa987ADmW9z3xbdDZcidqNBMMSipdmBEZG+al0NsBDGYZHm4mcQhCmM+XhdPtHcTGTGwdqygvS5rvRUFpLaQnJB6zC5OSYFSqZRvkTy+sD3BZDnwEQZ9Z5EgEmYtOIxjRb/1qQmqEGfpUXiWJbEppLhuB2Lj82VRZgyYlHI7wALDOsnJb7Sr3PaKrQUUzTJ9ta2K0bKegD6zyefucVBB5rUCUGvNAZVnfkRh6l9PFip4li0r2uG+9hyXL7IvzL29Rly9NWoN6j5nnOGyyA8cKwi2mdwNp+PXgE+DafBSrpW9+U/KA3ucO4+7XY/ppTwhOWbaARnpCWWAGp42V2+LRgO8IfRZ4l0Dn1lrv5zpanPB455G9T94LodZb2aC0RWXiqU8WAErnn659q08AS63A4Pi4oNaGgPrqK0GGu5G88JKgOq6pgl5rdYYZL/LbuPrgN1glTDWX5R0+s2WvPArQRNZfvG67SGTPfrYi1d8J3pcUiN0jXcupF24Gbk5SpsYEYcp/Z4A/JdZGv3V27pzXUsFOuZdDej8T6QCiLHhD2yM1HyqM0OlWDU6LyJMwIQo/ih5WKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(186003)(26005)(6916009)(316002)(54906003)(8936002)(2616005)(66556008)(52116002)(6666004)(6512007)(66946007)(66476007)(5660300002)(44832011)(4326008)(6506007)(8676002)(1076003)(508600001)(86362001)(6486002)(83380400001)(2906002)(38100700002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ECxwGxVPJpadkrEiI0fNU4tbqmnLZh4T+Rdk/+TiGS4NcpYn67EZDOyl/b/N?=
 =?us-ascii?Q?huUJmDLjGYB4CoSoRAyIdUOJSifbaAHVDClztOFLxYs5gSpJCo5K809M3UpI?=
 =?us-ascii?Q?4NS+t2gnGbeDSUJlzYAWYjDFtf4pRBRgrTlnPcF6RUUsa4YH0QC/Rvuyij4C?=
 =?us-ascii?Q?ISwOwNjC2mWRiXPpfn/HeIR4RzEaxiDKkxUFF9MVTBQ9YCmFUWQtKOoaLfKv?=
 =?us-ascii?Q?7wCpUCxjIvY4O4diyYV58VijEzOmSLIbuCk8zOhOReLSvIc9gUWtZJYRWdaG?=
 =?us-ascii?Q?O2bAqjQAJyMpcjnmxEcAVEFu7224b9QAMbQ0LTDgjhEjaqjKa3AxrpwUhdFU?=
 =?us-ascii?Q?wQUwuaksgAWF4d7/tH4FGso5YgYEyYCRgND7WYL5IamfkVrDzJylWIEiLPqN?=
 =?us-ascii?Q?y85a8T4mNUDX9ncB6/z5KKUJ7nYjXnWD5bI58HzohqfLcjiAVe2XJZ9VhG8f?=
 =?us-ascii?Q?5bo3ApGT1BcDLJ4/0PjZ9g6Q3D8CL19FIHjQjv80OBd+lJ4L3pZoAAb+IMaX?=
 =?us-ascii?Q?vML15fkKjZ8KeDKI9Z/Qt5Hk5lbhQ4XDGciFmrbPrxcXybhxfN4BtQ9BwNXl?=
 =?us-ascii?Q?KtSA40mQ98caJz5NwaDRM/W6vyjQlEIUxxYLZm4U6m2OzFrpRZy/oXoC6QLV?=
 =?us-ascii?Q?zSg3IEWXvU5fFPghw3Tm5SK8ICGtoqVbbiZD8ZyeL1uGjdI964p7Jb7T5hBI?=
 =?us-ascii?Q?1szZi8RbDCc+rRb3lW1z8sLaj2pgZ+bSUCX5FNuVBWvHgA5IC6+Bq6IdFgmL?=
 =?us-ascii?Q?gJoVb2ELB8y4ZuhEZ2uMiFZhXbUTB467TrF7m+GCGlT5nS/SSGU/H4HUp4cR?=
 =?us-ascii?Q?EV3DZ7FYC5HYZPZoov8qINJtXFOlW4OxAFpMBNOwZsgudqI0mAbh0sThurgB?=
 =?us-ascii?Q?GWa8cBv8XijIwNVuBf3eYbkNvkoK42+AbntLF5bN0uWVe5CL3hiQ2bf9c9Yf?=
 =?us-ascii?Q?Nuono7GVnEfNeO+4tUgYWaEgVtSeEch/WqnGPhWeAl7gO6Rc1/X5EXvkGfD6?=
 =?us-ascii?Q?cXe+XjUAxfNO5VKNBfjkW7vWrcYn1tlt9kxUNWiyOkVzns5tdZgZ8MynNaQy?=
 =?us-ascii?Q?c8XV8EC08aWQYIC/GLaWmC3nBwWgcLfGH5EKYvLTbqI1f8qXHXLpbiARplvT?=
 =?us-ascii?Q?lW+0ZYkVeB/kLfpmAkGBBfYI+8lxobWC86MNjiK+pfDiDlF820nH8rIGqiPJ?=
 =?us-ascii?Q?xTJwpOTJ2WGI+VWCESLFpD3iKSWlDlqKzvE83r2IUwMi5uEFx6FrQxlnyTL1?=
 =?us-ascii?Q?03Q0iulPbruWNgMBnQPOb+i9PzwDonVOMmjURa49BnOaG6D4IGf3WWoKiLWA?=
 =?us-ascii?Q?w/m1Y4h7CDkinALOpAXWbzCQ5T/YbC3GzIAuAt2KvHkMSX547pvXqvmKVqox?=
 =?us-ascii?Q?4W3j/duFpZ6VndRixj3LxtmY9gsZZZUEEUFHjgxKH5OfsThwKLk2N9O3oj88?=
 =?us-ascii?Q?TX+pb4REupq/Le85BJhm2sDiPaGjDuS51Py+pK13/MhYxs2PxgTWEQ7Pt8Hd?=
 =?us-ascii?Q?4yKxSsAF0rmtvjXzTfdR4vOKWedVahsi/PaROlmkChK6TDV48V2PNRR4jKhq?=
 =?us-ascii?Q?9cKJyREVkTsqGfUqE4CSJaI9g8d8sqxk6pyebAmHYYP8E/Zn1EMyRJFu1PGk?=
 =?us-ascii?Q?AFnXRGo0ONFnRLz5YB7Dlv4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac42471-dd74-422c-61a1-08d9fd1e5890
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:01:42.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7KAcWH6t7Ziu6/0CYMmsEWHDGDBAJtd8UUhbZL7qfez7mmzHww15bzZPXrCMxLpqq29FDHQeZI+NWtDKzRpAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify ocelot_vcap_block_remove_filter by using list_for_each_entry
instead of list_for_each.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 852054da9db9..0972c6d58c48 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1195,18 +1195,16 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 					    struct ocelot_vcap_block *block,
 					    struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_vcap_filter *tmp;
-	struct list_head *pos, *q;
+	struct ocelot_vcap_filter *tmp, *n;
 
-	list_for_each_safe(pos, q, &block->rules) {
-		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
+	list_for_each_entry_safe(tmp, n, &block->rules, list) {
 		if (ocelot_vcap_filter_equal(filter, tmp)) {
 			if (tmp->block_id == VCAP_IS2 &&
 			    tmp->action.police_ena)
 				ocelot_vcap_policer_del(ocelot,
 							tmp->action.pol_ix);
 
-			list_del(pos);
+			list_del(&tmp->list);
 			kfree(tmp);
 		}
 	}
-- 
2.25.1

