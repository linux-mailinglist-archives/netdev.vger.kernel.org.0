Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A28649AD83
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442284AbiAYHVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:21:03 -0500
Received: from mail-dm6nam10on2098.outbound.protection.outlook.com ([40.107.93.98]:28769
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1443610AbiAYHPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 02:15:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHIgFnHJLcrBwup+2GzNl9qKd9rtAD10PUN0KNUpryn+7FCxDwY8JO6oU4RA0HHNhHx7Iehj+qLKrt66qMyNwPz9ACPlxQxF46z8FKIgT9ZDin4Ih5d0KXP92tBm73hOIjT53wkRHemcrsQXCCMtRupO7Tlfn4f5xMkl//Ppwsy+VSBAb3uJS/XEJd9y/wSEcf6JJBa9IryPUQVodqQ7FhfaBR1EcXG4MlQlSLxA5YXe9ONam2uQvMwjj3jWOmsdkNq40vRJGBrGZzuvDjOsbCNN5RQ/Q3fGERTa9c2EIOBJuwyE0Q/Xg+n5sfPlkpO57PasJwov7ctrE58hA4F22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whwbk6T1Kv7OS5XtcGVmvmHi2YEiBJy1sgZHu+PwC3U=;
 b=fWKrT8PNxogRG+OfiHtsOWdk8shjKAi72ZjohWLV4rrwiCVLcPlk5XADsAEqUWuhwDFgftID7l0hdGVLQbsbDCf/Q+82QDOZHPbjKef2KvbV9bVhYJuZ9iXmfoQex9Aw9egmwNteoulhEMlN3Gbv69D6AC6s61Isdx7pDZ+F31rOJXrOE3JjJUQ37HCakHs6+ThoCqjxLxt1mqpLJPzXkFrsxYLso0+T3ah50IXEvdecEEtiy5UHb0YUNDIsbEuxvGqX2f1aY5GnhqMEj+SgDohzNAKe6DdPxzmNY60ohRtMxMK2F95LFhOi0dBiGHYn0DlJ58pxnLt9Qiv+U5jZFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whwbk6T1Kv7OS5XtcGVmvmHi2YEiBJy1sgZHu+PwC3U=;
 b=eef0zLr6WabcEMANon+YwlKU23aOMhelr1oUg5ddboYHJvYLVl9U4yiz3zaZNBVKxe2AXn03Cyy+z7U4o4IxYKx9SLNRaK8VEkKtqYSLQq3IdrG6TCnhBo+mkhHqCvJKEhaTghq0jsAXYlrJEChIK+nM3wM7hxN/GNCY1KLTHCk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB2538.namprd10.prod.outlook.com
 (2603:10b6:5:b3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 07:15:42 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 07:15:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 0/2] use bulk reads for ocelot statistics
Date:   Mon, 24 Jan 2022 23:15:29 -0800
Message-Id: <20220125071531.1181948-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR20CA0028.namprd20.prod.outlook.com
 (2603:10b6:300:ed::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca33d131-be8e-4029-6b89-08d9dfd27f1e
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB25380D429658BC129F9EFC3CA45F9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rf8IusnZ4PignErdSDd4o2SRt5RQuXz0hokH2lil6HAuUug1XtvNiQeLrd57NKf9Iuzjug6CTLbiP5MXJPssgGWgnTGC+xxgwjJYWDosB20DSirMlO7MdBvRlbAn7fMOs/BR5cSyGfg3SNBct3epzvYrjVZDWrRDc7gPRYaBRCuxHS4fm9OaBTL1Xj9zVJTIKXPXXK/TRIOhqCAF9zjhy35dmRg05pYkwEkHXjIuMGldB9GB/goxhZIpf49yBk0Fryo7mMCJKHkj9BQPzpbLKKYN+q8oEqasPBOBMZoZf/837xcutgT/F31VQZDF3BH+Ijy5c23/XqVCwRR7cf/VFmcFJxp5dHtk4cBtHBHFrKRpiHLfXwsZwMLcwdTJGakLvnqTl4dHUz7+3biT04Pz7+2GcXomky+z+2AcvSTZgKwWxPG0SsIl/e0Xt6aGTbdLBWWRX+o7VMjBAHDE+0g6v4EwHZa6/x+hH1nDQZLMUc2T+k5KTtV4LAKsJuRjx3LRw35Pmpq09+Z8OrhDr128aXhlLVOmNwel9eSxe3JGcqeMBEnpO+oFEcTLY0C/2E8U6kXRrejn5TIq6izoHgzMmwtTON2v17JC2W5nJKZfWZj+6uFsujgIgK2qUWhMr//aaZzXStpX6NnamJHydUC7FF6+9w/GUGiL1+cQXZ1npBVZ9DUP3gdBR444gzfh3pbS3HKrYNwXH0KAOoYdWLiHEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(42606007)(366004)(39830400003)(66946007)(38350700002)(6666004)(2906002)(8936002)(36756003)(38100700002)(508600001)(6512007)(2616005)(8676002)(5660300002)(316002)(4326008)(44832011)(6506007)(52116002)(54906003)(86362001)(83380400001)(26005)(66556008)(186003)(66476007)(1076003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tL3ECIwNcxVRDJVbxn/zjALW9Bv+W1VfQT9RLxQAEZ9Nn+s9fYzxTSv8/WbX?=
 =?us-ascii?Q?7iIWchIwZjhPhB3wG6H0U5qbHKzwC2s4wHnIRseajwV1bupfT6wu2wAhDK0X?=
 =?us-ascii?Q?1w0l8YXN4Jxsh6iUsWLy315Qcak1eeO805ErHBg8g7Du0+9yaIkJGJtKk7dC?=
 =?us-ascii?Q?xEgXuWHAywlNRi/HbJ0o60LBmbnCYt4Fe4oxTh1+BT2wkSvyThhf5LVS4qLF?=
 =?us-ascii?Q?hDUweMvMYVWDpyHWXTIEb/c37An896Pgwi/ocj978OFBZs0gP8NgOzOq108k?=
 =?us-ascii?Q?aYmiESvpjOoJJx7JGKaRt8RG7XMztCrIg1mk4jn5uj8WJut/t6Y6Q7Q0aW0v?=
 =?us-ascii?Q?igRj8VQ2IdlmYsa+XJ8WwiUnTyb04kTh062376kwWtFITT6UZBwhOUCGTTKN?=
 =?us-ascii?Q?jWjH4wHWVDco4uLECsT6uvdpuwYHdAvyUxYKB1aBcjG1MpnMEvC4JFVteasq?=
 =?us-ascii?Q?u81snHFv0ucerbrwxpwlsOXA5NUKDVsqadMvFP6fp+8AynleCdrcogVHDRe4?=
 =?us-ascii?Q?P15AfsRiG7ab+ubeQEYy5lqFdgDEZe6vWA/49hGY7f3Ejc7b4FeOUgBtdNUU?=
 =?us-ascii?Q?a9mJRmPiiE6wNyAymSXei/Bqn9zBgH5KoXN8O0439srCxudqI1tPCWqcpy0L?=
 =?us-ascii?Q?8fZPR4qx4D7KsEqvCHTOT8NCTfPHuOK5UPrvfcUN6XhjR3PS170jfn/hs5V1?=
 =?us-ascii?Q?EU2fJWvHjO4NqI+1pzqlkNkSg0MLkBY41F4iwjF1Vyi2S13xFgSoudoZ/HPK?=
 =?us-ascii?Q?daSgq03i1Cio9iWazLiaBMdGQX/+qGxJeqIO3vXwIU51oSF/F7ay/CsAqDiH?=
 =?us-ascii?Q?jPVxbJ3rZrgB694W4YKu2NxD/3EZdtx6zQZ1lx/87+jbmyugNY8mTeMjrrWd?=
 =?us-ascii?Q?8qR3N4znAYTwnHKUMCUb000THbmZPoKv0AGDC/8CrYrRMorr/5XHGX8JB4+i?=
 =?us-ascii?Q?a/2N8ef0TMtb0qFLS+z3Fk0/4PJPFnbjC/Xoy+Ck4YfhCg3alxGAe4AywlSP?=
 =?us-ascii?Q?T9zbWG936px9wfiS2izPxuwwmqMS5Cerlp4JmtSKqQrdsUsucCHbfsz3Yg6s?=
 =?us-ascii?Q?vevjM2o+qpkMw55EUj9J0raf6gxb2Rp/GcWIUiKDdamS8imcjOC4WBtKDfTw?=
 =?us-ascii?Q?ShrdSWo3tHJkLzKmoTDzb0fcJvASOevnoPSvoj8j7LXpHNPTTqOD8ycuG0lD?=
 =?us-ascii?Q?qbULAPqw6U+VK9fT38n/l858wvTzRd1Qt47JmQtFnZurqoBK2clTXt5cw3Fm?=
 =?us-ascii?Q?gDwaQrbbopXUGqEK70+2ROwxV6g53BMXJMbbSkbX/wStlUF5v8GtzDPwXqdX?=
 =?us-ascii?Q?ERQwcqmUL/UFKugRiSgll1S83nVLXIqYUtNmnYIKPvlvv1tJIIRCEibLfP0s?=
 =?us-ascii?Q?YE1ZXG5xJgWusQVa5TiVkHRtJMTBE8bhz9FxdfoR4rxMQFfpa7VAiChy+FsF?=
 =?us-ascii?Q?hHc0HtgtzzgdNgrcLlYnKPQW7oG4ixDISlpy/OXhR70Jy2K/LmHTy/wfzmUd?=
 =?us-ascii?Q?s8Y/gKYDdeNUPwwxL7Kh1tuBZs/A8X6OGsfSkNVnbT9w9tMFW8LdLqPWg01n?=
 =?us-ascii?Q?GOhOYEoozU3CRXugNENWKQaVOffL8cz9A0A9ij5SLtg185YFRfKs0d0mPizz?=
 =?us-ascii?Q?JM7A/wujFKpJRfslmukN0UmiTP3WdEYw6FewkbArViCKwTPhdLnVU7gRG5gI?=
 =?us-ascii?Q?qs4FcDjtVMPEORVOxxSeSySoAOo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca33d131-be8e-4029-6b89-08d9dfd27f1e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 07:15:42.0805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4fHVN8QsNy5bV4IVrViGzhSRdWOKJ9e+Jw/QTqrx+cKb2vl2UbXtqnSMcDL4Pzsj6k67FmlfY8Ah3G3inxcaXeJL+CCkKN1PFHJpc24X2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot loops over memory regions to gather stats on different ports.
These regions are mostly continuous, and are ordered. This patch set
uses that information to break the stats reads into regions that can get
read in bulk.

The motiviation is for general cleanup, but also for SPI. Performing two
back-to-back reads on a SPI bus require toggling the CS line, holding,
re-toggling the CS line, sending 3 address bytes, sending N padding
bytes, then actually performing the read. Bulk reads could reduce almost
all of that overhead, but require that the reads are performed via
regmap_bulk_read.

v1 > v2: reword commit messages
v2 > v3: correctly mark this for net-next when sending

Colin Foster (2):
  net: mscc: ocelot: add ability to perform bulk reads
  net: mscc: ocelot: use bulk reads for stats

 drivers/net/ethernet/mscc/ocelot.c    | 76 ++++++++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++
 include/soc/mscc/ocelot.h             | 12 +++++
 3 files changed, 88 insertions(+), 13 deletions(-)

-- 
2.25.1

