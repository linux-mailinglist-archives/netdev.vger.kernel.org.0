Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8646E28FC6B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 04:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404142AbgJPCbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 22:31:42 -0400
Received: from mail-vi1eur05on2102.outbound.protection.outlook.com ([40.107.21.102]:4179
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393760AbgJPCbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 22:31:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+h7sZkWTsO3B6PCss48SrkzLYLJURaKZEsbNmkThpjc8JsZcYECsgBZWJ83bPxrRn9z8UP0Sj4IhimZ/+/Pvy/IPZFeIIuAjx4fkK00b1CTa9eEOLD9Nb+eqScWOCPqklfI13bPwSoJ7/loxTaKHR2nEnXeSoO0pwZG+kJXZKH8e7mU6e/MxqE1feba5SnjN+l7VIaq3+6Y6BNDa21QNrsAiXy/dunk/5w2x1V5oaGNp7EtUySjKNzbsXURCOL4soaKvgRLfIjiQM3G4aMQzz5Q250+a134PgfsSlnozIFdDU1PoxHk/agoQ30znKgUXDGGX4n+F7MY436D+atmfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSqqmw13e9BVajLLa0kjsbB7a61mb0HGDSRyt+dpWSU=;
 b=R3Tdz3h3CPlhD2xSg9vFwfYZsK8r5UEjt5wISjderPkW7WJFXFMRw2KhHb5Po2prLyYbGC40C/yKN5XjQ9zWJwVOH/GrxtREBT4cHUhVwxrpqQ6rbq5TDXqhJGBCVztNvQkvIQEPseLoCQcBDarV13nD+CY1DtPzgnpzELiTzdeaQvWZT5qy3oTkZjd80iflgZoXHqW2SyKkEfxrYWCYYR/e+9bQP5fwBs30cQaAxH9QjxOGbckswGJtyxUdcQ4EcHw5yE08kjZuYLtva1plijX1i+22x1tSfpKQMCBH/47X39zV9DzT73a49YnKnpbAwmFj44TTXL287AjvMM10yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSqqmw13e9BVajLLa0kjsbB7a61mb0HGDSRyt+dpWSU=;
 b=STOsFzVWQVWzhB142roXDq0e7qK1jEIn8bHVc/564ztLDQbunYq30gPSzW51s1RM6iiOjE4A10Cian2gX8bE/IGJk3jFXe+1l86Usbw1V3j7dp5ynnxZOzHHUcgGeJEhvF+SjjiZy23Gfunmgc6/7OkStOkrxbHTXIcsr5czi9A=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR0502MB3040.eurprd05.prod.outlook.com (2603:10a6:800:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Fri, 16 Oct
 2020 02:31:35 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4%6]) with mapi id 15.20.3455.031; Fri, 16 Oct 2020
 02:31:35 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, ying.xue@windriver.com, netdev@vger.kernel.org
Subject: [net 2/2] tipc: fix incorrect setting window for bcast link
Date:   Fri, 16 Oct 2020 09:31:19 +0700
Message-Id: <20201016023119.5833-2-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201016023119.5833-1-hoang.h.le@dektech.com.au>
References: <20201016023119.5833-1-hoang.h.le@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Fri, 16 Oct 2020 02:31:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a13ff20b-c095-4803-2225-08d8717b99e9
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3040:
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3040F4294D981953CB1F4365F1030@VI1PR0502MB3040.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUZe6+/1ffLh6vC0y3e+VsuB9HZajs51VgGgG6TNZZDAYYce8cl4Cr2ruX9O8IUO9+CS5Sjh1Mqox83knrmzdt10J/VfEONMLRuEpJAE13KAyijEhwPilI+/OYaWQk8gHPAAqKBq8kArfvQQmq/b6pHq8slTR8sC5oYQeQGcZnWkYpX0GmE2o8vKgR1QcuUTnuUJyuNsFzb53v3dhYQnv9dLEbikqh6D+6PeYJQUtmSgbDvEQhn6JLtytAoAnJYtLymsUNfyiK3Sjs/c92J0n5hUE7I7SFdulSfdC/3OgWIbY/a7kmOI0iPRQql1g4uRLBh9mYvOQb2v1gQvE3xh3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(136003)(346002)(396003)(376002)(366004)(36756003)(186003)(2906002)(1076003)(16526019)(8936002)(7696005)(52116002)(5660300002)(66476007)(66946007)(86362001)(66556008)(55016002)(316002)(103116003)(6666004)(83380400001)(26005)(478600001)(2616005)(956004)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: VBISrSTngnhBwkgmnMtvVwuKfCQQALUUupd+zFB3IK7llwvCbT2LwZPrzXbjZdQidS8SBzIZrx8wTyE+mI4Ky5HpM+ybjdSNRllzv/LENCOEjfP5T6mVjR7lW1IU9msUx6n7OyAEmRReuoF99buQ37vso3c4eAJuK7BMx4+WGwcjix+VgZLh9U4/DQDs9Eo/Pxr1qrTj3v6ZpS1Mg1+nTS6QEWiAS7LSd35jjd3qK4RX/kHStkpCYuBE5I3XbpMftGyxhhf9xRnOwgC5mtRb1px32BFw/VFG0c/rzeE8pgp+Pk2O8GVK3VGV/EiGhmXcc1ugNW/VvK8FuSFHADIhcxpHIch7GNI0PFxnhtue/idej0E/WWGWF3qJaTQPgQQeMieBOzU9yVSFSTHycF1Q1dh6QDPIUBMb2JFt7hGwhP/vpiFUObr1tBLfWHUBXNLyDJ5zmW/rGQOmotpyQ93tnZ94MBszyCizLY2wM443dANKlch5zY1KGvtbhzlbIx7bCpJFxz8tpwh13crBXL9iXS2JYyC8gQqA9SbkPH5pGnulRHUrhWmsCuJ8MwsW60GtYOV0ov7f+SR8sll6Lg+IVSM5cTpKj+cKqPgtOIClzddeZRz2LRIOl1UnSYgYpho8+aOOkRQwtXqvGGji2EOCCQ==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: a13ff20b-c095-4803-2225-08d8717b99e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 02:31:35.3082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S6JY0Ul1Koq9OJ+a9VIqAQmBlGsB15djhGESow95qabjnujyENrSr87199HHctuNasQhPqM7QDTebXMm4uD+lMnAwsx+XC/H7SY9JOUngCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 16ad3f4022bb
("tipc: introduce variable window congestion control"), we applied
the algorithm to select window size from minimum window to the
configured maximum window for unicast link, and, besides we chose
to keep the window size for broadcast link unchanged and equal (i.e
fix window 50)

However, when setting maximum window variable via command, the window
variable was re-initialized to unexpect value (i.e 32).

We fix this by updating the fix window for broadcast as we stated.

Fixes: 16ad3f4022bb ("tipc: introduce variable window congestion control")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/bcast.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index c77fd13e2777..d4beca895992 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -109,6 +109,7 @@ static void tipc_bcbase_select_primary(struct net *net)
 	struct tipc_bc_base *bb = tipc_bc_base(net);
 	int all_dests =  tipc_link_bc_peers(bb->link);
 	int max_win = tipc_link_max_win(bb->link);
+	int min_win = tipc_link_min_win(bb->link);
 	int i, mtu, prim;
 
 	bb->primary_bearer = INVALID_BEARER_ID;
@@ -124,7 +125,8 @@ static void tipc_bcbase_select_primary(struct net *net)
 		mtu = tipc_bearer_mtu(net, i);
 		if (mtu < tipc_link_mtu(bb->link)) {
 			tipc_link_set_mtu(bb->link, mtu);
-			tipc_link_set_queue_limits(bb->link, max_win,
+			tipc_link_set_queue_limits(bb->link,
+						   min_win,
 						   max_win);
 		}
 		bb->bcast_support &= tipc_bearer_bcast_support(net, i);
@@ -589,7 +591,7 @@ static int tipc_bc_link_set_queue_limits(struct net *net, u32 max_win)
 	if (max_win > TIPC_MAX_LINK_WIN)
 		return -EINVAL;
 	tipc_bcast_lock(net);
-	tipc_link_set_queue_limits(l, BCLINK_WIN_MIN, max_win);
+	tipc_link_set_queue_limits(l, tipc_link_min_win(l), max_win);
 	tipc_bcast_unlock(net);
 	return 0;
 }
-- 
2.25.1

