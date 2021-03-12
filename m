Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1F338382
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhCLCUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:20:37 -0500
Received: from mail-am6eur05on2130.outbound.protection.outlook.com ([40.107.22.130]:26430
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231644AbhCLCUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 21:20:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5WR+cBBuOLN1Lk23hi3f8j3TjHnLMixhBxD6dBlYVtPR++llMTiXFkeu3eko3Sv60wYM3MkuEDP850DbcDSUsmWodhfoJTVWz7owJLEVHkvvBGGVwxGyM9NmigCN448BtmDWhD9GV0LudOHWvVwN1fiActr91NOogv7aPF6xbuWr0VDKQTCz7BNl1MW/eCoxXeJtL8XJlCw7/fACUFO/nIwo/X2jDUtTbPswMxg95hB4kMMx6sYb2lOIoq5RaItSXQcRywUT3w8dOHL0CuYAv40Wl85baVlzgpWINNsIKYAFo/F+7OlcYE7+TEpU02bKnS6QpEB40tsPRc15ItXAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mf2IMQ5oQssSJiD/7gbnrV+fH2OU6xJAHR1DqReUfFs=;
 b=S+YiAL+WfHlsjpWqfM9m/QQtwu5nHxtISisjKjD5DhfCtu+nx5MRcyg5KRlIkePy4LzuKR1NPyybQJgOEclhgZdGQbeIyaHJZjuNTkZIDJUyuSnt2o4lRQCIyL1IfzsbRSGbUPQXhusYi6upUR8BJi9zSTHHCmDzjNPMtcVWNsZ1J+PszAWplp2BYLnSicu5LXp/RZXZDp9SZj1sL5OsASvIrcfJdWZAP1nm05/xvHKPYXN2JJPg2gJ/JJxVHbsXD8LcrGAFxAWvKlzMAWX2nO204UqfZD0QJigqQyi42w6ZuOnT0OLFWiGPbLVTtcw6YhPVxvruqm2QeCeVPTRGHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mf2IMQ5oQssSJiD/7gbnrV+fH2OU6xJAHR1DqReUfFs=;
 b=i0sdDNbAYhYJt+LwreAtZosCmDA5O5JVl6HfmclyABL79Ahb7MCXKoOsfjKuqWruFby4gWFDzNSMH9GIb4/bPSHTkkfKRoybHbM8oNF7RFbPgLUtWUrMa2PAcyki9y5wmGyi0ci+Es3ONoMZYu3cz/rjLe42vkNoWNY//u4Rx1Y=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB4782.eurprd05.prod.outlook.com (2603:10a6:802:5f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30; Fri, 12 Mar
 2021 02:20:22 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3%7]) with mapi id 15.20.3868.041; Fri, 12 Mar 2021
 02:20:22 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Cc:     Hoang Le <hoang.h.le@dektech.com.au>
Subject: [net-next v2 1/2] tipc: convert dest node's address to network order
Date:   Fri, 12 Mar 2021 09:20:07 +0700
Message-Id: <20210312022008.6495-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [113.20.114.51]
X-ClientProxiedBy: HKAPR03CA0004.apcprd03.prod.outlook.com
 (2603:1096:203:c8::9) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by HKAPR03CA0004.apcprd03.prod.outlook.com (2603:1096:203:c8::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Fri, 12 Mar 2021 02:20:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7043eab-7cfc-41ba-d450-08d8e4fd6399
X-MS-TrafficTypeDiagnostic: VI1PR05MB4782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB478221AF7819F4E89BCEEB91F16F9@VI1PR05MB4782.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMpmbSXzWSkcVWGVNGQZTfWZzQ4klrXVxU2ElufplbEn6DEJGf7ZeKRktXq9wuInWuVOVCwzvTEfHtEOnyURu2alZ/JhLpcwwrNmXkpYkC09zF1TbSIGDioEr+9v9zteRhrF2vVfUtopEQgUhhfK48DMruBdkLHWcXijJxD8lLDpPfhBtZPhFB4R5cnbwC59upVpfpRf3CaPMeJIh3x8/xFeH9VUdn1JuHsVYNVUUXt4qxKm8ZebRZDFJhli4F0848r7zBtPN8i5f4n8Li3jQvIpN64Z6CJW8Pj02Jky18xiTj303luoaj96c6+EffnE0uJFgg7Mwahd+Z48vMtrLIrUwyrdG0zICTnAUrXYJdiPuZ0+v2KFomPyoOhCke9Xi5L5bD+dsdY3LPJc+ls/AeVe2WG1RYcdFkvKG4lWsoO3YF3lI2wM5OCOWuWr1mctfaJRdGHTseKUlZPpxR/ehszvLmg4TdilA92bGrYcyORAhMp1QlarnMv0waDyw7GoLo3beLjExHqE7nqFRomR1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(396003)(39840400004)(136003)(4326008)(52116002)(55016002)(66476007)(186003)(7696005)(83380400001)(5660300002)(36756003)(103116003)(478600001)(66946007)(2906002)(107886003)(66556008)(8676002)(1076003)(6666004)(2616005)(16526019)(956004)(8936002)(316002)(26005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?T9S0g0xkZ2vYaM2ggMW02ATxIz2EDsLUrf/htwujRkQYA/bA2eeCY7sKZ1Xk?=
 =?us-ascii?Q?ZWu58frIplEHlzRsIUDhtfo7XgIluHKjclr9y6waO7Brvgkj/dIw90BGWEma?=
 =?us-ascii?Q?c9EU+ebu7bkHbTtJVPjZd+d/bHuD7hzENdYuolEQVtXRSeoTjAGUHGkTKXmO?=
 =?us-ascii?Q?oOYCh3IyFEfFTjEleR9TF3VNTtHU8k6swZ44oFvpJqE8PbhRVp6msuHvr+9y?=
 =?us-ascii?Q?HPOzRUH6gvTrTuA6vTd1PK9JOsROTlZe/FgMXND/gfhq94w8YazBqRkW/DEn?=
 =?us-ascii?Q?ASUJkSr8JAIA9X/jHPfu0FTLNcUwyt2iiZoiHvDnDxGFGpAdOQT8TQ5HReY2?=
 =?us-ascii?Q?F4+mIZG8ytOCuQ2gTq3z/BO/V3z/yjO0WaLjruaVcVy6q+f+Z5nr7oQpJWFS?=
 =?us-ascii?Q?18UGL7Uvs99Zuq8PKc/3eG7p2ac7Xw9HzaxXU1mdWaz80hDry23F8/hN7fx9?=
 =?us-ascii?Q?VavceH2ae/oEUTT2TG7vRGFj+Ua9nPVodt3lJTsFYRvvP8pNLbVaL0h/KYQd?=
 =?us-ascii?Q?nbBCq73F2MYM6tBUZXb6Cco09Bk+UEl/5PF1F16AplsIkkA16cvR+B/ZUnPi?=
 =?us-ascii?Q?2CJ4O62dM+3OsA0aWUn4yA4pQNY3PzZzzP2Le51iog0wfnZcrryuQM4WPZhv?=
 =?us-ascii?Q?oMqAuOjlP8tYLZGDEZZUM/K9iykcgUIKx9nzG/ilSpPSpHGrx+3OzJeIBDpN?=
 =?us-ascii?Q?GPMUl9yfn7iso8GWcEFKuGzGk/7cVvVmdfweFAOI54UjuvFVD2wY3RZBZBjt?=
 =?us-ascii?Q?OFifKeH9ZxSWYoZ5Km+Db4ZKWs6lKZ0i2kAMza125Z5FIRx2ZHyVR6+MB1P5?=
 =?us-ascii?Q?Y4ikqrgSWjtvF3twhtquNV7U2KJpEo3wb1H6loZOgT7qyzFmfM8O2EwV9Ymb?=
 =?us-ascii?Q?ljhGtiM8j7Q/pHIRRx/PDOOz7L+0RDwj5Nd6y9HZhHnTn+eW78Y4TM4rszlY?=
 =?us-ascii?Q?49jGQh1xjp3MJ+hGVypm46HRLYEAU4xhW08e9c3qA6GK5wXh9o61Q6C3reoJ?=
 =?us-ascii?Q?lbCo02LUdc/Y3mIsrlAgWd2fFJSOYl/XRuJjKpvwA1suKNo/saYITvwHxaH8?=
 =?us-ascii?Q?Ygz9dafC4ozbFo1J5KxHX8rzeBZ04UVB0ecnYxZ3HrPt9L9FE7+bbN3SKVbg?=
 =?us-ascii?Q?S2ueP+SO0uWkOy9wR6l+hMdmtNI5dC66eh8A7vo3xYCe1p8vVjraENn7TCL9?=
 =?us-ascii?Q?CZwRJvOvR2KlE3re33cre2g6pjRYCXrzA/uOVooShRbBq5ED8ruAX/K6Aq07?=
 =?us-ascii?Q?GKPs0kZkj7et3BYk17ebI9EjlncI+Wy3Zok1/jY1NV/ebpMcb1s0dl88Cexn?=
 =?us-ascii?Q?GKzX/nv4HYB8tt8htPzVjK7X?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: d7043eab-7cfc-41ba-d450-08d8e4fd6399
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 02:20:22.5547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyDtQulRF/gYydo2MafB4CZjSgJJVM7tAZKQZAxgNokinDkUDZ3fGWgddXxy06LqymBihkDiL3X4RfLtTnELICogBDfkSmuJ3B95BbT5MJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4782
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

(struct tipc_link_info)->dest is in network order (__be32), so we must
convert the value to network order before assigning. The problem detected
by sparse:

net/tipc/netlink_compat.c:699:24: warning: incorrect type in assignment (different base types)
net/tipc/netlink_compat.c:699:24:    expected restricted __be32 [usertype] dest
net/tipc/netlink_compat.c:699:24:    got int

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/netlink_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 5a1ce64039f7..0749df80454d 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -696,7 +696,7 @@ static int tipc_nl_compat_link_dump(struct tipc_nl_compat_msg *msg,
 	if (err)
 		return err;
 
-	link_info.dest = nla_get_flag(link[TIPC_NLA_LINK_DEST]);
+	link_info.dest = htonl(nla_get_flag(link[TIPC_NLA_LINK_DEST]));
 	link_info.up = htonl(nla_get_flag(link[TIPC_NLA_LINK_UP]));
 	nla_strscpy(link_info.str, link[TIPC_NLA_LINK_NAME],
 		    TIPC_MAX_LINK_NAME);
-- 
2.25.1

