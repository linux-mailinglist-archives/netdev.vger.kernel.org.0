Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1E4C4BC0
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbiBYRNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiBYRNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:13:46 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40083.outbound.protection.outlook.com [40.107.4.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC5F1A6161
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:13:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A69tbVZ0fleAHnbQbGSKqqa+WOu2zbW4+1ie31Yq62odm6Biv6CIXFj0hXhyxZ0iSOhg2JH0uxeoVnVJlVaYoQwEadEwROVYMgkHEj1Vjqiud4/anedwrI5kAkM9SmQAXCW2RddFj72p8odwWOpMF0aAqKCySwZ4DcLNeZ93t4huYuqV2EMFKUIuGuBDAPNXl8S8hS1b2tK2PC4Zxe4UNWo/Q+Y8wOt19lyPvJYMPX8cBe4bcD3Hlwddrlx2GIv4TmW/tRk3yPYg+fRnWZ1hIYLlWceeSB2U48jr5Qbd2ufh8FXO28S3bPZDDLly2s9nLpWUAAEC0tmc3Iti9vJE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbgGwynog+fYtjvR+CT6OaoVbYwZ/g/aIpi0wRIjqAo=;
 b=QfePUhC2bHWaVEzEKI+wnu+l0YqFXcFqbPgia1w+AGRbq5RY3YSyRSmn7tZ53KbR+Bf6g4G7ywZ1xc/lvougFAQJ7fFM/YVHA/tNFZqy33gdvDXXHN6NgI+oi0Q5y8oGQT3v3Q8plU/uBJwqPjWPJaMd1WM9N1ehkNSRmcBQnDz4B2PwicHS0v+OMzAM3yaXDSgkV7etZ46BrEdEhEEehNmFQHpaVryRQYwy0/btgOilNcwnKFNm7zhb2WEu6MeEWZ6I1tmDpsI6PLoIFLhp/SzHg6r+ed6Sm4uJkCEpaBK6wYYH6yEKLSXx8DUMF0qEJLhXdnxHgnJ8swl9uKYLaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbgGwynog+fYtjvR+CT6OaoVbYwZ/g/aIpi0wRIjqAo=;
 b=getpiefWlyzYAF5h9Okvkh0/NarzaG+4Ee2LtEL8dNLo0Wv2M8y7OeoWQsrGwtQEBg5u7wbrOxin0dwki6OnjlmwSytxtsftM6T0W2iIYwVUm0BVjH9wCvJ3Q9l2Xv5sGaggCvv1n08RIYdm6C+WOT/hvHF1g4B84vRa3qBOp5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5940.eurprd04.prod.outlook.com (2603:10a6:208:117::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 17:13:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 17:13:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2] dcb: fix broken "show default-prio"
Date:   Fri, 25 Feb 2022 19:12:58 +0200
Message-Id: <20220225171258.931054-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR05CA0019.eurprd05.prod.outlook.com
 (2603:10a6:20b:488::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40069b9c-9023-4f95-e669-08d9f882193f
X-MS-TrafficTypeDiagnostic: AM0PR04MB5940:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB5940B1208008B5A12C761986E03E9@AM0PR04MB5940.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RR4jiNzKs7/+PWgsAIafaX9nQMqoNXbYb5P5swv0gdhJt5K/nuMXUK5C9utlxKKxEboK5Ph3J7BqJXTek1NRWaUHrwf3SDNuPXUu/Jkc8GGiIBJ6AEAR/KWEmxFA7burohHxHLZbApz7XlPgQ3gMEYk7wbOfd/jnS3CkMH/JF3oiTy+mKM5qXJTzbMDEh5ufdWdU926bxgVb3Dq9PZ9lJ8vouPFoQGQWHsdMONWIeckk6KFhLeySBg9SHaXOeznEkkIo5Cl9skGcIUXfxJgRakFvGbUtYxIJhcdecHP4uUvCeI6oXSz2V1gOWHDLlBSrrNs69eq56EGPi5apGpBeVgR8hqVhl8QLvSB2r0SQ7wk4pjM/GOdEdRYsrHprHaxolJNKktFCvba/6Gkga2JY1we+MVz/dQjHyWBDe6AgnbaNL7qqOCFIWlgrpcZ8buDdLTYjjDFv/6EH0AkqRRoQQpxY2HVQe3fyjYOZ+JLl+IFzPVU67RM2sQ83KgJIhuOweN/T/qRyRT1Db9ndXjqjp9TmZ52rmbJQMF1n3atd9WVys9WUlvcE9WFy5VUzkwWwYPzgx+8aGExNubdsRKnWnsXD4kP33ZaJyTFBYB1Hn9Ir6Xs89vpIt+AzPC0KzPakd8qMXHLrZOCVOiUQzCGxpdqWr+hvEvrH+/vaL1wrIDcffM1Ajdyr+rQ7+McZQ5lQQAgvNQPpgFgMCf0JNpu40w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(26005)(2906002)(86362001)(316002)(6512007)(6916009)(54906003)(6506007)(6666004)(66556008)(66476007)(66946007)(52116002)(5660300002)(2616005)(36756003)(6486002)(8936002)(186003)(508600001)(44832011)(1076003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UyHHQzJZCb+4dbMDefV0C7HM6vfsqKA7ogJg9QwUMI8e0RKlTFVhjemBGE27?=
 =?us-ascii?Q?WnjZyfMlfD2G/tiIIYsjfblbMsDD1j68A74CTgJIQn+jR3xUSi+OX7gIopTm?=
 =?us-ascii?Q?BmzWARwgXIHQkuLBh15n/pfsnLcaIXEzVIIoT/FXwxGNiwmOFT2bDEKlTEIR?=
 =?us-ascii?Q?QyYiW5Clt7Ov9icfyT7TldUcykmffnyWzda/NCQiCSFIdbN0IBPByMvV7GYo?=
 =?us-ascii?Q?klPk/Uv5EDDeZQHw/HrpYahWRL/wzK4x78OmVY5MxU8zr/yKeUs1S6UiHOjJ?=
 =?us-ascii?Q?iqBNmN9y1RssuG0sUimQGSDQI9zgKI5F9pxbGA0CvvLMKg33TcewBAqBDA4p?=
 =?us-ascii?Q?5YXtynLiQk42HWkmW8PvCe66m4hcYzdFdTH9/zet+8GGEn0MNHKnwRfVz0hD?=
 =?us-ascii?Q?OMSoYZqI9T25CqvQVM1ErFFEim3KCdGK8QViri8SD8qSI0pP5FU/+TWMdd5i?=
 =?us-ascii?Q?51kiwpO1rZCAuZtYoSYCwG5TuVS87roNXC8qTdaRcAa9gA05iRz5wzh/pHBw?=
 =?us-ascii?Q?0O6s5RXcqKK7qnwCjOPuAJzlJNjERxaJBuQxO2sl7koRpleYv+Vp4HU7oExh?=
 =?us-ascii?Q?Ft8DHhcy6H7tbQ9PWTfaT9BkIKxKCnMRDmsjPOH/GrbH7yfrVta8EZZjGvcp?=
 =?us-ascii?Q?2lcUaR31CZignc8XPU/P1JDy9aLdM8SR9bZaClzlyqadsdwdunLbg4Fn4deB?=
 =?us-ascii?Q?+Js0NL3OmTgEAxJq0gpVotTvu1rSsBMph/MDqscaJOzi6rz5+Hy+TCMgkJqi?=
 =?us-ascii?Q?OdcQUUt11Ipw3GVnGQvdVtvSzwbXMilqVG1IaXtNei7QF6feR9LMVDzB1TqQ?=
 =?us-ascii?Q?2QFSDseVcFUv5mjPzIGAIeBpLg0XdqPKOFUsN7IMRGmVVouwHIob7EIOckIT?=
 =?us-ascii?Q?Z0tAu8cvoyVq7OK4HCwvulz3CKJNTxiGe8RRDlJlHgwwNtPa3Yre49qYhNpi?=
 =?us-ascii?Q?mLC0KgUKYadSK8vQlo7rKQP7GtGqxGaOjXEOCrbtN0C1cQPVgv9w48h2EKtu?=
 =?us-ascii?Q?Uv5jhPI9uJNZH6Z4zuoqcwvYuVdmTAytI7i08Sj+7V32oD4oU2XiHbt2H26l?=
 =?us-ascii?Q?QgYMkRaEEj700Y4GESKE5V5lkHU8yVQY1YJIzMjnhZqXMtd1fcYxZYmgbFS7?=
 =?us-ascii?Q?siNtmbUnEJjwS/z7HFPqpABr5nO/rrqtA7untLHErCngO9kJv9aS8y7d0vsJ?=
 =?us-ascii?Q?17UoClI3uGI3ohHhNe/6OAERMzg/OVX8jPNM6GMqHJ5TFhMyZqr5ru9k3JMZ?=
 =?us-ascii?Q?Z4q2KkS3TsKN9gt/HbV2FinrzIxqaVH56pvftgXRNzc1qSL4DrQoLDfH+c6x?=
 =?us-ascii?Q?zuSdjVDhliN/xkbwbBjyA+HlnMcAu0LKGZ1PRmr3er48ME0vMOdM0m70XgTX?=
 =?us-ascii?Q?9yE4YoExcegBwwQO1v3VFXNGamRSYfyw0ZSy/4dOPy15nN+3FYE6p/BP5ooG?=
 =?us-ascii?Q?fUsMEHvGYd8R4G3Fcv0SwYdfUhKsr6Iet7kWdXA/S+a6Dx9NYjba0hJlQm5A?=
 =?us-ascii?Q?aclU83as1iGuWrYEk6vYpjGe0KDvWYrCiIkxnS3cAdaVizRE0YVD2OQSsjot?=
 =?us-ascii?Q?yDN3rdxglAWBNvdDp0rjZHj5lALS+L6H2pPFw+m8ZCYC0cwsin/4BmQiTOea?=
 =?us-ascii?Q?qKgK12R9HlwglRRxb17KKiU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40069b9c-9023-4f95-e669-08d9f882193f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 17:13:10.5815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2gv8Uqga0xU4STyguKKp5P9vMisoLmU0MhzqFM784Z1jxMzI9r/MHROUbo/ql8k5VmQvyVouOU+j2VIGohGyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5940
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although "dcb app show dev eth0 default-prio" is documented as a valid
command in the help text, it doesn't work because the parser for the
"show" command doesn't parse "default-prio". Fix this by establishing
the linkage between the sub-command parsing code and
dcb_app_print_default_prio() - which was previously only called from
dcb_app_print().

Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 dcb/dcb_app.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 6bd64bbed0cc..c135e73acb76 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -646,6 +646,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
 		if (matches(*argv, "help") == 0) {
 			dcb_app_help_show_flush();
 			goto out;
+		} else if (matches(*argv, "default-prio") == 0) {
+			dcb_app_print_default_prio(&tab);
 		} else if (matches(*argv, "ethtype-prio") == 0) {
 			dcb_app_print_ethtype_prio(&tab);
 		} else if (matches(*argv, "dscp-prio") == 0) {
-- 
2.25.1

