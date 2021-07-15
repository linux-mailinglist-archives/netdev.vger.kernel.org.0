Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74943CA0D4
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbhGOOmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:42:11 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.33]:29402 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237214AbhGOOmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:42:10 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5C1CB4C0066;
        Thu, 15 Jul 2021 14:39:13 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvoh3ge7AfeHSXpbazZuAquE5o13ZvLWoqWxdBm79H1SYLE8C57bvm8SIvXKW7nAmAf3+i3KBgumiffoCLfKZMizdxyajHFWv4Ro/0Ha7l8dVEvT1l+Of7FVe642f0ugX3AnnFMqItJc06UeZ7HJxl1DHuJp6dDaYQ6JOTOnAr9+ntbOs5h5vvj6eE5Yz564yWvkwbpkTDejmSvDHEwuqJmSumMQdbK/700ltj4vuMHGrkZkHhcfxwiZZZ5uzT0ePo5ys0vkJgdmxtQs7/4Y0poXz8B4GMvUkfld9XjYfNPLgCo8vMc76lsMycf6BjGpFuoj7Va6cqmhRe2npMKWuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Va8SRTz8wdzzG8LhlsJy8jqV14bUnzzMe9Rh73H9DIQ=;
 b=FlzW6lSwlFxSPWUpf4g6Z/MWzJtd4MgLnkbp7Z+h89ml1pm7GhreYRNaWkvXvBi3LHSvsiODz00wsW1VapUKKPI/rPQ/OcwXgYquEHS5+3oJswAJ0MEavyXcrN1Ts8yInytScTRA1ZkcoKFGHXNmZtI0oG6/6lWlbdnsuYkUSFc+/4g6cxXhumoBlITVJpYybs82TEmxTnwcG8u/rmUJdxW+e/EEYG0RGi6fCaI1xoZDFwfgi1LY9rTkzP6AiJWjziHzF4bHkXF1haaytdstZsT0zChOz05X8CqitbE8xa8UhM47igL6rVGppqyUd/p+y3saW1O5VxsU92M0waIpPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Va8SRTz8wdzzG8LhlsJy8jqV14bUnzzMe9Rh73H9DIQ=;
 b=t850i17fdH/qurcVi1T15HQdSQWAAI28zlyUSXyE4wJwzdwRkDy0RSg7VNIkvqfCRqdZmp0Z+OCHPJW0lgNezZjrQkjLL4G1w7Z5UOudxbzUcoXF0LpZri7AZTpsG5zetuv4wOtcJ4e42WbXZEME4VGkfJa9kQ47YeVi1L4/ENw=
Authentication-Results: 6wind.com; dkim=none (message not signed)
 header.d=none;6wind.com; dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB2685.eurprd08.prod.outlook.com (2603:10a6:802:1d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 14:39:11 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::d8cf:e8a5:615d:2c40]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::d8cf:e8a5:615d:2c40%7]) with mapi id 15.20.4242.023; Thu, 15 Jul 2021
 14:39:11 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     nicolas.dichtel@6wind.com, dsahern@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] ipmonitor: Fix recvmsg with ancillary data
Date:   Thu, 15 Jul 2021 17:38:56 +0300
Message-Id: <20210715143856.6062-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0394.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::21) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kgollan-pc.dev.drivenets.net (199.203.244.232) by LO4P123CA0394.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18f::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 14:39:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 252afcba-e04a-403d-6b3d-08d9479e4f5c
X-MS-TrafficTypeDiagnostic: VI1PR08MB2685:
X-Microsoft-Antispam-PRVS: <VI1PR08MB26857EC8918106C95415A7D1CC129@VI1PR08MB2685.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ss6HS/u7FZuqQfSuCdvr16AkGJ8v60g+jS/pX7lcQ1dRlopQW8yDRXIMuQw3/i7plZHzu6Us9NEjGjhkprFpoDBLNh7S91xWq4ws1Ztpqi7KlkSNk0NOsWEsht5cm5Dr0Y463PqoJ02CoNi1jPn1iZ4I4Ad6zQbtp37Rrln1Q7QL1t/7ancIxsgUNUCSv//UNq5UiXuHoPyUmFBaOPinCL69Mv+h6cBsxs6WMC8/7MUcSLeOU3unZNG6ce3Coec2cMUwl32hL4aPW9Og428aUnULSBTP+3PEl8qWKHR5TeG0d/CxPuxSkx7VtciuUzryPnqTY+LmDwIdjXiBBIZlv5OQ4FS9Fx/+zb3BsnE8Xze2aBQla1H7ecduQP8i29TJVXmtJF5WtVykBAdnBhoYje1OA8eErCR5rgtOGnY63FagAvCq+IEoXHW0ovctw5tjU+9z3DsGd5jGGA16RKNXwbBdBObjiEB7GbX7rNxBJ30UEH/4YI0S5boGjnUp4XhZjXO0fQyM0fIWiaLrY4CXi7t4YcZOzps0p6jO/y+xNsohdpCVHUUto37OvgEMZOcZi4QmfUrOfPXfjQWqTi+UVT3W/rQDIZs2dnEmuRBKDrRH1j2AreNAsu6RQbamhxpAjgZfXnPBDizyK+ZAKiUeieiBxucBli44ObAhNJwlrK9HJ8TkmFLaMU1e+UmISXJljc0apSKjslTMXBQspd94LJpWSTJ0pmvrjX2iZwpyfRs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(366004)(396003)(346002)(136003)(186003)(86362001)(5660300002)(52116002)(4326008)(6512007)(6486002)(8936002)(6506007)(38100700002)(1076003)(2906002)(478600001)(66476007)(2616005)(956004)(66556008)(8676002)(6666004)(83380400001)(38350700002)(316002)(26005)(66946007)(36756003)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cr86B4pLnYKQ0CL3GZ5vVOTY4brQj9KZ9VYnfA/zJ8Wy23JIrYoYZs5km3gx?=
 =?us-ascii?Q?rPpknVzC2isjw+URm0VDtHMGsQM80fsOp9QsGckipeh1gHilo8nlxFv4bUl7?=
 =?us-ascii?Q?1pE3/17xalys5WNCo/Vhjsld1KJ0jCuwLpCgfrW1tfHoKnVIQyzZ74jhjmid?=
 =?us-ascii?Q?7IqSQftJlXV636ZQiKNR7kPdkTBPbm7i+ESvn05jobQeL1awdMwIo+3xLWKi?=
 =?us-ascii?Q?8fl+dwKdbA54dEAZBKkZX2LypDojfFg7D8ch9JjZ0PkcsepZZPL7n7G3HXm6?=
 =?us-ascii?Q?jPjbyuQeVbGmEWDkvF5TzkhKxcVrDX39TPsIZvfuOklTZjOPidWn6a/v5hEN?=
 =?us-ascii?Q?xSABqlozdEs62lMS9GCWZHA+1A/VGhokcDodmVYiVeqsPlRalbCHcHRt9KEz?=
 =?us-ascii?Q?VU/uKQNRBerFitM5kp6cwt/MIMy2FpOIjH8fvGJI5DarthK+UleIt6qeibwQ?=
 =?us-ascii?Q?s7OQx3ZTvX7Gi7uVTs1j7lPHb99u4WeaJZOTRjUCa7PX15rUU/gne06GoLNM?=
 =?us-ascii?Q?ZxfPRGCalBHI8Hgp70fS9+ANE2AzIcEIapj+A6Mw92Coy3qplr/43SXLC8+O?=
 =?us-ascii?Q?tre23c+6jOG8B93DHsZIniqprpMoKACOt6wrw4TYrxN7HVOPQDa2jDkqdyQ6?=
 =?us-ascii?Q?EO62UIUswchlPaECM6FfijzJ3MiBBFcEk0NQ5xbddGznnC5dG+oNzhG8WraS?=
 =?us-ascii?Q?6GM8cGZ86bu6h5okt7T8eCL7naG1tXwekS1too/X/AVWTjtDw2HhdjwfgO5t?=
 =?us-ascii?Q?Oax8XUxeUpvtxBI6F1xWuwwNCKxZ4+01mQ+woeY/YRC4YIR1stPlAorjwja+?=
 =?us-ascii?Q?24pMI1eQDqP6xvNFy3GEzscW6MfFL6zGzYwNQjaANM/BS6bry/aQx+p6Jhb1?=
 =?us-ascii?Q?xYlcEErZO23jgktI168OP7B8eSpPHJwsGJuyJis4G6TItWEcAVvLVda7BXRD?=
 =?us-ascii?Q?l9oReVzRYLnE0a851bZjTxJ/YIhQxwJjpYis/AXMRohXgSbty6CmYKYw1RfP?=
 =?us-ascii?Q?0AhNfDs0TPQPKa/kRDgiV8gCkgqd0ajDxQ4gDZXRR/+da3TsI85H1WwhZe/O?=
 =?us-ascii?Q?qBwUWfBXuWMVjRjw/Qnv7cdT71pSvnYO3HJmr/Q1I/XaMDSPAUAvFHHV8SfA?=
 =?us-ascii?Q?KODSLG633oDE2ktUAGCcmZZ3iJHyDR/fwBpKHmU+P1bqH+Kg8kUYaaYqMfRy?=
 =?us-ascii?Q?1xpgXIemh5uoabfxX37bZsfG80N2G2X97r53SVYLv0gDE0isuBXDssbVbn16?=
 =?us-ascii?Q?a6gPLVKSNuCYPlDi7wKlPqv5T5MDZWg/GVi1csZvHtd7vPnunkPfzaspMHKT?=
 =?us-ascii?Q?Kq5kePAjSywjDdfdFJwvc++G?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252afcba-e04a-403d-6b3d-08d9479e4f5c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 14:39:11.3436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEwRFzNPm7fAMrIQcv0ihfra5aMJEEkf3dW0s8PwjLaLVB0PivTbaxNy7Kj4lIgIjiYjD9mQ+z48C+1C7giSZITcSATdTVh5FeXT49INE48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2685
X-MDID: 1626359954-j3Vg2XxLV_En
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A successful call to recvmsg() causes msg.msg_controllen to contain the length
of the received ancillary data. However, the current code in the 'ip' utility
doesn't reset this value after each recvmsg().

This means that if a call to recvmsg() doesn't have ancillary data, then
'msg.msg_controllen' will be set to 0, causing future recvmsg() which do
contain ancillary data to get MSG_CTRUNC set in msg.msg_flags.

This fixes 'ip monitor' running with the all-nsid option - With this option the
kernel passes the nsid as ancillary data. If while 'ip monitor' is running an
even on the current netns is received, then no ancillary data will be sent,
causing 'msg.msg_controllen' to be set to 0, which causes 'ip monitor' to
indefinitely print "[nsid current]" instead of the real nsid.

Fixes: 449b824ad196 ("ipmonitor: allows to monitor in several netns")
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
 lib/libnetlink.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 2f2cc1fe..39a552df 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1138,16 +1138,16 @@ int rtnl_listen(struct rtnl_handle *rtnl,
 	char   buf[16384];
 	char   cmsgbuf[BUFSIZ];
 
-	if (rtnl->flags & RTNL_HANDLE_F_LISTEN_ALL_NSID) {
-		msg.msg_control = &cmsgbuf;
-		msg.msg_controllen = sizeof(cmsgbuf);
-	}
-
 	iov.iov_base = buf;
 	while (1) {
 		struct rtnl_ctrl_data ctrl;
 		struct cmsghdr *cmsg;
 
+		if (rtnl->flags & RTNL_HANDLE_F_LISTEN_ALL_NSID) {
+			msg.msg_control = &cmsgbuf;
+			msg.msg_controllen = sizeof(cmsgbuf);
+		}
+
 		iov.iov_len = sizeof(buf);
 		status = recvmsg(rtnl->fd, &msg, 0);
 
-- 
2.17.1

