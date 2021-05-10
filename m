Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1A0377A3E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 04:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhEJC67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 22:58:59 -0400
Received: from mail-eopbgr60134.outbound.protection.outlook.com ([40.107.6.134]:11909
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229670AbhEJC67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 22:58:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkZU4Vmuwi96XOTx5AQzKi5ZttFT2PdveoZgPypTHxjlxaq0pts415iXQPMympkjuYzqkBIblNaCbm9iQTZbITvNc53dVqyJjnX/6m2S0+2ScCjKMF+0957fBOk6peMOltVpLVssbONtYSfRM+dgukOtuVS1xOJZ7ZhBvRpmuEfHJI55sLdHGABp7644891BCIAGBwZy7WmAnxlP99vNdkk/bmQKNwUgJAhQaHb8Pyoyp4Tyn7WeyngtHON9s1gDAm5D6P9Im2JbyUdpd+5v63oT2JM4qocFFDLhA5Yx4uH7aWVqfnZy0InFcy8e8Asmt55f/+vVM9mpArVDenTOFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmdI+bK3+gi/GPUdnBJJp4NAMiTK9xx0YaO1Ga4mU60=;
 b=kSkXPPAlb0be+ZB6XYfO0gyNTwW0OgHbrvUkx1Ce9sddM6iXKXnC+IchxkesQts033iclzC9e/hT9D9Mmnvu/NqFtnbuEIAm01sMXuHk6XSfgPmSdHbnRCE87/BNw4fkrno3UzZphu0Jwof8W/JskdxfhHUMDuV2ibLpgnMAqXv1PVhGsZuWCee/aLzWBPgV68GTxFwo59J+wE4bP5ZO1gB12yinQUhuvBV1JUy6RVHKJlD61FVX/eXcmbPcImWZJ1QG14I5A+xNUglapYlYlRxi7gglWq7VBsgJbVc1jySUF0uYMGzAPfQz1bXygvfxiq4DiuTy7lpAVn0gS2potQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmdI+bK3+gi/GPUdnBJJp4NAMiTK9xx0YaO1Ga4mU60=;
 b=JSOhgAyRJ9Oe1wJKxlGSIZiDxaVKspgm+Cv93Xo/0bkfrR9nCuY2qO2a31IWl8+2QL85HpNTv+fcNGrdcxujsue6t/3o+gQnPdI43pDtGIpmawapJFDGgxofCAGJGrIrjUlCIdsukjL9z4EYsgwtRCXpxU5i1AaLUpYf/LRVN4Y=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6877.eurprd05.prod.outlook.com (2603:10a6:800:185::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Mon, 10 May
 2021 02:57:53 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::c1b1:f949:5243:8e89]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::c1b1:f949:5243:8e89%4]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 02:57:53 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: make node link identity publish thread safe
Date:   Mon, 10 May 2021 09:57:38 +0700
Message-Id: <20210510025738.4713-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR06CA0252.apcprd06.prod.outlook.com
 (2603:1096:4:ac::36) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR06CA0252.apcprd06.prod.outlook.com (2603:1096:4:ac::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 02:57:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f069cad7-49c8-4f1a-9ee5-08d9135f67a6
X-MS-TrafficTypeDiagnostic: VI1PR05MB6877:
X-Microsoft-Antispam-PRVS: <VI1PR05MB68778DB3A4D87ECB00F3CA91F1549@VI1PR05MB6877.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYdbDX7Zd7JNe/DvUtgYGpoYqlpxpBWRgK+xHVbEInltDZVBSBNwOFKkwLI4amH+mZ1N0gHcUdfxwqDB+Sa/mIv3TJ9Z5pGe33PNiBAd7+SgSfqPwtUaL0MXFtbPKPlgeSTlcTA3/9jenX3xueME5NiehpB8Ls4G7pH7ECuH4f35mP1WO7y+sWSxI20c6sp87jocS+wsAmwv55ik0S14yuUwBVqKdpaQG12bYiJj4YvxkIM+zPvzO02FfMtwkcBGJSu7WUJzOrDsKB1hqhVhoAnh99P0CfD8Z7EoGixmInW5t3HasPYaZeRraSP9khXeYaoq+1Jcx0P+lp3YOeDqcEgux8muqQw5IMVRuUsgOHwRk7iiPk8xzU+ufm6LD9TqzRg7MXy67YywsBBGJZ3mmkb3pwFidRN9zG/INFovbqSjxA84pB67U4gmaHHtwNbdDFw1t/+v1/BXMV7iCX3Eyk9JxeeP71FL8djXiQYCbH/QPvYzPTfKIRb5MzAYCtOGBBuOLClf3GH3y5yxISPUqj+Kjoyk50EJvljaSmS/ZdjwBTHPyhBo5MnqqCEfeRccnTWa2BXOi7Bwmrlj1/5Ox0vD4ShVgUe5pX2xcqaKPNa1t6PTut6X33jSTzlXqD5JErb3ObqconZjntlHDylpbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(136003)(39840400004)(396003)(8676002)(26005)(66556008)(66946007)(8936002)(52116002)(83380400001)(16526019)(186003)(38350700002)(7696005)(1076003)(5660300002)(66476007)(478600001)(2616005)(38100700002)(956004)(86362001)(36756003)(6666004)(2906002)(55016002)(103116003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bz/lHdkEvwRTTrCn5h0bP18b7qCArZYELmKPDq+d15yDyqLwtKjE46yqqzj1?=
 =?us-ascii?Q?1nfnQ+sG7hj829T31m8/X2pRGmqRFbn8eS+O+sip9qzcCTyIWjc6o289E/7K?=
 =?us-ascii?Q?+MGNw5bgimIEYKmmXjE70uppGf+FZizfjAc0NKb5FTAONOl/jjxX6X+BuHB3?=
 =?us-ascii?Q?ZLFMa1uXJ2dCzuiF6km5xjq4OAjQzVRTM25c0dujWB1XQ6LsysQFGg2AQXZm?=
 =?us-ascii?Q?L+8j14c4yI7b218+VFOLlUPh0xmRWDkIMy85AwpIvNXo4fxMznOIg29ZmpIB?=
 =?us-ascii?Q?O4X3ORRCxr5UTUDBV1l+HY+SdnR+eCdk11Hv/qqbUSeBGclQJel4gxvb0IGD?=
 =?us-ascii?Q?c5FM5agVpUD53VQsezm8DG35Hj0srDMXX8rAXba/U8dp2AjEFqG5RxwNtnem?=
 =?us-ascii?Q?91ytzpKOe8xL7MHIoRv+fBIYn7IMVpoxgakJLY7hruYTnp+y40nqsG6mhZ5j?=
 =?us-ascii?Q?1blFhw0YsMS4FF9hCeAgR2/CKTX65paY5RS/mE5Y7vm6BbaweA1nHrNeOOUc?=
 =?us-ascii?Q?oRQgv6+C+l9WA4a3CWfBUY1khtwA97lVcKeaq6sHFlRX7gaoor5baIg19J/S?=
 =?us-ascii?Q?ZewfJA5mHs+2xOLzKEfqlGAqXzf/2Ord5rsKMF3M0JgZ3DQwD3472iZ+cZiK?=
 =?us-ascii?Q?+knf5Doc5BRvXnYQ7em0FCT601vf0IfVqgrCkC5+Zk8/6QVmUX5s8egXauoL?=
 =?us-ascii?Q?z6+m585v8torz5EFG+J4iDgr+mAa7KZByY5MuvHKQF2atevUKnTlHGITIoZ+?=
 =?us-ascii?Q?M0AxJ0+wLuhZTw1Lr6UeQPz4MwKIwiuqdkXy7eNR5JrhzI617bqtWqxSN5+x?=
 =?us-ascii?Q?mc2jULTjotkK1FPQnaPfwPbnVQZlS0JstGC5i/EHITFb6CDb0ow9HsfbuZoz?=
 =?us-ascii?Q?dun5NcPFxaTn3c+faG7xEvmZZrLzA/lYnCwoSH+i80BPNMz05SAucsTaz9Nd?=
 =?us-ascii?Q?gmLPPD6nEtd3bJOxEzkIvbx5pzyuyOY3DXNETL0et3iQtATWi9nNRMMoHYM4?=
 =?us-ascii?Q?aqcijSbcoMARZaSfc9SERrF79l4slgXvOWCD5odyuqHl6Jl52sbYTeKlVviT?=
 =?us-ascii?Q?INwK5ypEZ9HBv+4va8ZLqRxeK810rg4faIlhRwyqrF6U+UKedPs8++o9zZLM?=
 =?us-ascii?Q?9YKkxuSQEwDg4pxgsodMzWIGQPZ+cBie9+RNFSJpPpNdJOaM/1YlMsxDmcpd?=
 =?us-ascii?Q?zPVYYEekoVSYpVvgEVUPF9v97xstw9vWEUvxoDJw0PD6erRdxZkuf5No0DIQ?=
 =?us-ascii?Q?QTU3lV3pARwwL4jmWbTIGUF8/k1akjukT8usPUjO0ecrPPBfcU9zPKSd85Cn?=
 =?us-ascii?Q?9APCZUjzjx8QzQP5UoQgh1lU?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: f069cad7-49c8-4f1a-9ee5-08d9135f67a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 02:57:53.4747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zws+qjpSbIG7TbAXY/z9YL5F+YFmh6hTCW/jcIncEt8as+ObX2jDq+JCyfXnD+dmUjFg9rKS91L0zrCz7yYKRcb0R+v9pnztNIMqfdQudho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6877
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The using of the node address and node link identity are not thread safe,
meaning that two publications may be published the same values, as result
one of them will get failure because of already existing in the name table.
To avoid this we have to use the node address and node link identity values
from inside the node item's write lock protection.

Fixes: 50a3499ab853 ("tipc: simplify signature of tipc_namtbl_publish()")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/node.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 8217905348f4..81af92954c6c 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -423,18 +423,18 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	write_unlock_bh(&n->lock);
 
 	if (flags & TIPC_NOTIFY_NODE_DOWN)
-		tipc_publ_notify(net, publ_list, n->addr, n->capabilities);
+		tipc_publ_notify(net, publ_list, sk.node, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_NODE_UP)
-		tipc_named_node_up(net, n->addr, n->capabilities);
+		tipc_named_node_up(net, sk.node, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_LINK_UP) {
-		tipc_mon_peer_up(net, n->addr, bearer_id);
-		tipc_nametbl_publish(net, &ua, &sk, n->link_id);
+		tipc_mon_peer_up(net, sk.node, bearer_id);
+		tipc_nametbl_publish(net, &ua, &sk, sk.ref);
 	}
 	if (flags & TIPC_NOTIFY_LINK_DOWN) {
-		tipc_mon_peer_down(net, n->addr, bearer_id);
-		tipc_nametbl_withdraw(net, &ua, &sk, n->link_id);
+		tipc_mon_peer_down(net, sk.node, bearer_id);
+		tipc_nametbl_withdraw(net, &ua, &sk, sk.ref);
 	}
 }
 
-- 
2.25.1

