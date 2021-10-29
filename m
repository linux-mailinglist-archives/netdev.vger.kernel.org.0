Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D58A43FB5E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhJ2Lbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:31:51 -0400
Received: from mail-mw2nam10on2134.outbound.protection.outlook.com ([40.107.94.134]:11008
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231807AbhJ2Lbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:31:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leuE0IBIiGqvg4PoQs3gTJn0Xn3y4Wac3eSBYd7Ux+T3+2RS4IJGv1yv0Xdv/Nc4pYfeo5pUrEbHMixwHxfHEJJR1EEljCzWW7vAM1YAiy5O8WR1dBfxODJ54LCeMC85z4hH164htawb2j6/2qHKU3Ei62DV0mXffC3o7ROTldF4J1w8Hia7AgrH5mpC1jbGrmYzceYfgiuUwTqm9Kzc5RJyD7cZskOEMyTCYJVKvbwGhHEMvjNzgLt5dWyH5FS4aDsxJmoFEGEzksAbNg3MODysDSdAbb+M9xNAtbkobykiLxlKLYwDVZP7RKEDW4SP+jjvjsW5EKXFfYh5SCMJHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKs1GzUL8/avXPIe8YBkoXOM8GTUHsRLDsBPsZCUDhE=;
 b=XytlWsfkxpQtZr3G07UYdHhzrCcpPS559uw2VBU8DQK3O+4h8pEOQyk1wPnqVtksMyNLpZjLqyhlk7spI+a69p0Jo/AkQ83iaEsH8GM3v/hTh3ecrPtsyl93m4uDp1vU8pY4Alm1KdX23wgcOve205RXoU1RPirALnBLAhuHkJfvjJ1o4YzH/zNJ46p2dcirz4BP4LxFJlnj4p7VgoLp5554MDRJKd9Kqv5dbVVh2U3FVBjIh8/K5f531kI3kz5cCDZ8kdCBr/es3IjhFLEURGkOlyrzquX3lxAL51qsgZYY6c3lg/l6AUveQgRhTvwTGdCJNtZKnuLkyE1k+1K+tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKs1GzUL8/avXPIe8YBkoXOM8GTUHsRLDsBPsZCUDhE=;
 b=dfwYpkA0mXM2gsTj8vXfWGBryCD83QUY8LLE0jPekGRh+dcOE/Use/0EBpCikczzpf7jMpyECIsevv6uMidQg3zK8F16vRpEXKWmKFd8dpC7JhmaeCjjnZByXTDITssegoYIK+HrRsCRDGqf+0yF0nBIzjdn8zqM+Mt+Ib+nebQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4828.namprd13.prod.outlook.com (2603:10b6:510:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12; Fri, 29 Oct
 2021 11:29:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Fri, 29 Oct 2021
 11:29:19 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 1/2] nfp: fix NULL pointer access when scheduling dim work
Date:   Fri, 29 Oct 2021 13:29:02 +0200
Message-Id: <20211029112903.16806-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211029112903.16806-1-simon.horman@corigine.com>
References: <20211029112903.16806-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0015.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR08CA0015.eurprd08.prod.outlook.com (2603:10a6:208:d2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 11:29:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f57261a5-abf0-4f8c-1900-08d99acf5945
X-MS-TrafficTypeDiagnostic: PH0PR13MB4828:
X-Microsoft-Antispam-PRVS: <PH0PR13MB48284DC9B3D21DD931A034F3E8879@PH0PR13MB4828.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vs3nvlK2/Ffxc/a88DSFgV8runNN+e4giH/EB6Cv5DQbb/SwfVGgg2AOLpQ+nyzsPXF27gBDC3o+VUIW99WrK5yL+5U6WzYxicgxZpaADYEUgp4I7W6eVSH2Ow1GbohRZhS7fI6DAJJV/a+x8pPloJfand3VIZhl/JTWGX/kctjcXdM6FnqgLJeMT4BdXWSETsFtN77aHQu3tzuNsIxBycehy7SG0g8K1XrdiA17CweT5Uoav/HMa+8QL/zsBTfHJZrGQCsRLuw7Lqw3XXfLV8KK3xCjz+NCaPOGajhSdAZPQl+PnHSdXj5JkcG9VwkRYqhXW2bLZGVg4jZxth3DC4Lj1jjB9BHFqr3yjENjgrK1J6v6hWz9zYr2Q8/uEzKAG48TsKcwHcfeY6lYmOygB4GQ0CLm61A7WKwQ2ZwNL/alXhfcvSUWqK50y3ll0I03rd2l/+mstkaH5ciDm0ivqMasqOHBPcmedtDhjlmRkcrivX1kJET0/+3m43XT/ecHTq2ieeS99UJNv+XDlReHX14ajAu3VFb1u3hKgf9J1+U5g+GnjTLRB4aZTEwrDPTR2Y15N13ISEtyJkoYU2+4c7NNuSNHTYKeYIquH0nbvvECDb1i606cvVsvSwFSHlZQ0RgnOWZWcFvdlcmffn9mKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39830400003)(136003)(366004)(376002)(66476007)(86362001)(4326008)(110136005)(107886003)(54906003)(2906002)(52116002)(6506007)(316002)(508600001)(186003)(36756003)(83380400001)(66946007)(1076003)(2616005)(6512007)(8676002)(6486002)(38100700002)(5660300002)(44832011)(6666004)(8936002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NmTHEXIppjHNE6HD506x9bGKu+u1iuEs4Y0g1Nd7PGkykug7TVG46N99EAaX?=
 =?us-ascii?Q?XyWxIAzbWc8tPhsgui281fUTmwZwnq070rBtxZDBFCq1TJ4Zgx8ABR+KeT/n?=
 =?us-ascii?Q?BRiyuGCiFiIcHisxRoCmZdsal07CSqRCZ3Q6hJ9G541Qgo4D5aNumO48UZ3/?=
 =?us-ascii?Q?diijPjJ3dnYwc1S4EE5pNABhA/7JIa330pooXId1dhCfP2hj2BPfILO3b2VF?=
 =?us-ascii?Q?lveA4CeFcO58ehp370e+L3WpfMCPic3AtAxGD7djTsA0hQOD9yeU8Jest4+L?=
 =?us-ascii?Q?cQIyboBIiBVNPNov4kA+dIjgfFwXXUT8YFj1RrAQFtRKy88G66d5KezbkilG?=
 =?us-ascii?Q?ncgqWgFzfjdfCzj000NBZBZ5K7nG8toZ/0xNMNjRgNMR2ry4RbQlc7I6up0v?=
 =?us-ascii?Q?n3+1eq9WSINoYdc2TtuxXeGZHKx9qoctNc7spZZR4taWnQSpSzDRX96zP4bs?=
 =?us-ascii?Q?G1PW3M1q4cv9U7KCxjiI+tnbDAeDPd+XuYznKSfwJRpGfR61X8QzaaANWrh6?=
 =?us-ascii?Q?1xg3JDS70hGW+JS7Pdp78ZbyMbC01tg5aH3nZ9CxSsapI5ZIpT4/dWebI7He?=
 =?us-ascii?Q?S5dm4Amo0boTf6JJxNuLB9fXrV9joba55Pk1qQMi3lXK6sZp9ex01M5qI7h3?=
 =?us-ascii?Q?CdLR7bTzw+HPAtaHMoZtM8eB3JkC1Q3Q2/eYPR8e9ovO4RO+jjRPWvvJjUhd?=
 =?us-ascii?Q?1NJ5tz+/AEHX6N5W8iaJm6/7hUpkYGDxnXWfTs9F+OsJoMj+HddQCrgQJsMR?=
 =?us-ascii?Q?I782ccu9yw4kSBUOIeE+9dl2kMiVmZDKcK4G3xqHqDYHjX5xMXo9ZK/W2+SY?=
 =?us-ascii?Q?icl69/zPHZksUyuxKG+9/Mj9lPVFzQtoW1fRMTcH0TPjpROksY1LG7KHx3/d?=
 =?us-ascii?Q?wIYb/KfWoUTH3f/QmxOq4Cr0OAewv8q0xfQ0CMuF+kXrbQhjJb2zz/82d/E6?=
 =?us-ascii?Q?d8ubHg2OLheyaCtB6IzpzdGN74LxiE//FA/FnFovelo4ln71QvQ07iiXAIk7?=
 =?us-ascii?Q?QTln+qHHj3CNKw4PndY6QwDGrW6WePocDjfRMTs72t6ZRQ/NmVI1omIh2VQz?=
 =?us-ascii?Q?HYHyS9gMNXQRkUP+yH/EVU5Ftvdny978vDPqSiDL2L+M4tJpMQcF2rZH98Ch?=
 =?us-ascii?Q?/QhkY4w9eJhGfNUoB2Bz8rjK2PvQjq2nFrmEDqwYYLh6DkfQFitg9EZgLBhV?=
 =?us-ascii?Q?KscTDmClDvEKJOXEnnqknnoUvsDs1MiiTid/01jOodgkPME00RyZCenTPJkJ?=
 =?us-ascii?Q?ze85WcUMnVZRsRWpz6OPuE6X4UrtrUh5Cp5Q8di84YbIswzMSgDl63B22uvz?=
 =?us-ascii?Q?AMb46GkVYflUaO49vdqQ4ihtdpnbAqvDtnB38HEme+glyAzqqg+HiQccxDes?=
 =?us-ascii?Q?s6wwuyqtvgWBK/iv0rl7fOpIWcKsCeptGJX/xgC2GQXJpC2Bb0ilzKVkGUSA?=
 =?us-ascii?Q?8oUU4lOhxzuYjjuzseXZpc4YQx3j2cz8OcbXvvtFLF0lQ5uJAnuJ2PkVOB8O?=
 =?us-ascii?Q?M2gRcbuD8A4RsRfacZ6O75LrA/vcn6DKzqQTMPIHHoXr7HtvdVkaS29d/Xij?=
 =?us-ascii?Q?dnpwN2TC10xcL8010jMzYIpJgG3dXXL4RPDpo9VammI638hSe4LfaVidLVGn?=
 =?us-ascii?Q?F2W7EgjNiAywQEP4PNgW62dotn8IZmXIP5DgXwYduImYR52UIj/y18PHz49U?=
 =?us-ascii?Q?3mzWe5bOD5ELRYQ2WqVPJj9OLTBYiX0fxyCBZttJRMMVE31/gH+rIYJroKdZ?=
 =?us-ascii?Q?/Vw+dLaILw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f57261a5-abf0-4f8c-1900-08d99acf5945
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 11:29:19.7229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m9JmGxF9jUrA8E+X5ul32vVYfAlAPN2NBmG2HbgXKMObdqPxybqmNf1VHFldZ/1AVBdJNbMZgPyUyaSt+Kxd1q61rOn5M7g2BwTNrJ5zzps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4828
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Each rx/tx ring has a related dim work, when rx/tx ring number is
decreased by `ethtool -L`, the corresponding rx_ring or tx_ring is
assigned NULL, while its related work is not destroyed. When scheduled,
the work will access NULL pointer.

Fixes: 9d32e4e7e9e1 ("nfp: add support for coalesce adaptive feature")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5bfa22accf2c..f8b880c8e514 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2067,7 +2067,7 @@ static int nfp_net_poll(struct napi_struct *napi, int budget)
 		if (napi_complete_done(napi, pkts_polled))
 			nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
 
-	if (r_vec->nfp_net->rx_coalesce_adapt_on) {
+	if (r_vec->nfp_net->rx_coalesce_adapt_on && r_vec->rx_ring) {
 		struct dim_sample dim_sample = {};
 		unsigned int start;
 		u64 pkts, bytes;
@@ -2082,7 +2082,7 @@ static int nfp_net_poll(struct napi_struct *napi, int budget)
 		net_dim(&r_vec->rx_dim, dim_sample);
 	}
 
-	if (r_vec->nfp_net->tx_coalesce_adapt_on) {
+	if (r_vec->nfp_net->tx_coalesce_adapt_on && r_vec->tx_ring) {
 		struct dim_sample dim_sample = {};
 		unsigned int start;
 		u64 pkts, bytes;
-- 
2.20.1

