Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B5D4371C4
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhJVGfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:35:10 -0400
Received: from mail-eopbgr1310114.outbound.protection.outlook.com ([40.107.131.114]:27456
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229609AbhJVGfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 02:35:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdgDWZhR/6/SCTrkrDhq1kEduS+zKOQEUhJfBxlskoaWWoheuh0LgELwTEXnKkqr2aw2yaChipMem6KvlgHL411co98zRIg8DhZ2zScH1KvnU2oBqRzooDE6j1gccHQHJRPOpzlEhkJhkJvwXO+8ixPJx7DvsaJ9sb3AVFYgKsXQkrjysPyEwAy/RD8pTNuhOoAC4dBftQeikWsVsil4o4TOwfmawVHFnf7IIiJdOY+qGMuxGlrEvxmQDJl7rBH/dKzuhtw4FJrLVJjjNSFauD4/nydL2uisdENLwUyFlIzJEp5l+i1tm1q4ynw8aTTK7CZhsybOKTwcfJN0g6RupQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKqhYEJT+lOTm9xodx9eFPZbWJmR2j/pu91XJs4T8RE=;
 b=Ruduks4dRQWUt+cL0GaBwLs/wXoSKKzx/q1bIdkaYKH9K0xfrwfDX1Tg7FP47vX70rgUHqFs4GbxC51r18qQeroqf7Vwz+VQm1xcjz/gOhYxcEXLS0lEBHieiI+SeDl0LBGeaRFdMcMlbhF1CA+L1IvgrAucqpJtl+QA01e1n0pEy+NZpRuMG0Wckbt5VDvDyGbflPUBF0XESEnbjQJWwSmXjmtBLKe7288z0P5sE/UPA6qdAPigAKJ98o7PcJ/zrEixXweunTmA2TPU2ktRiNVO4zlaqDnRXEWbYRCK/1n99Vhok4sdpa+2ahnfYvDRpTE1CohVIEkd4mxUQnCXDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKqhYEJT+lOTm9xodx9eFPZbWJmR2j/pu91XJs4T8RE=;
 b=gsIjZix8k56lfxlPohMkwLNt5Cp250bBP0XEu7s46fr7dw7XPQy9NUAJQlD4IqCOpI8ggKU8D3Jjg+0Bk8Yy4KwpJSWYWv5ZUTA8uPeN6AYnuusr1UWrqGl0JdLsWshs7N/sQvZ8rxfX9/UUAuD2Tt9LdqProxFPyj2LZ6B8sr0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PS2PR06MB2902.apcprd06.prod.outlook.com (2603:1096:300:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 06:32:49 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385%4]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 06:32:49 +0000
From:   Bernard Zhao <bernard@vivo.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] net/usb: potential fix divide error: 0000
Date:   Thu, 21 Oct 2021 23:32:38 -0700
Message-Id: <20211022063238.21800-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR03CA0036.apcprd03.prod.outlook.com
 (2603:1096:203:c9::23) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
MIME-Version: 1.0
Received: from ubuntu.localdomain (218.213.202.190) by HKAPR03CA0036.apcprd03.prod.outlook.com (2603:1096:203:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Fri, 22 Oct 2021 06:32:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a06b250-f6ba-456a-b0c1-08d99525c45e
X-MS-TrafficTypeDiagnostic: PS2PR06MB2902:
X-Microsoft-Antispam-PRVS: <PS2PR06MB29023FB68EB3A7266B05A734DF809@PS2PR06MB2902.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q1LKKnDM/cTHunts4qjRaHNhvVLwFt0fSxmgH1ohmT+aT+IDeTHN5MLXXPqJ+G+rn5sNrqp0lh8q6IUFVC+R9IdBoVxmpB0xl89K8bQTfpEDJWyR6bizJsKtEUWNqvDX2/WYi1N5hOyksEcj1mxajqBQj3mY4NqqHx55EgkUsK/BCNlYRyyJgj6qZFQinpMiTvuMEyFTtBNNQnN31f9vMRTqp7w4ojlhU6rWc4d0XvSjHj9RFiVKgTsqptyhgra3wisT9XEcRPVOX0D0RZbWQMHig2+c0z73tFjp2+Qwvfh6/+qpsgIQ4Jb2bqYPuzFvsARiwdN0nLbR16AxlhzLSMiLNjILnRP5adpn4MzajIlyeIDYlmdykVy4gl3rPgwyDagXHj0YfjWQHAQVqPcVVwifAs3Xtke9Z+MzA4T0oPBLouh7DfQBU0NeVVxKtSc7BzC1rXPzfxSmD4hBm411H4s37iODCPyeVqb2CkCWCHJUu7m0ocPq5CcczncBRoguxxtrkoGSOAsYyY9wqVfkWdWkS+PS1cgc9k9sIyGYpRFaCAME7rMCW1kD9zwlNuBKMefW1xp/dDeAijaSqMOpLjI4eG+854QlRv5MhpRxl9G2XitXakvMFlzcho+pidhLMBSXQLFKXWhd1picymhNNhVzFTS0QXyuqT6Q6ElRdeFMl9OvM07DQBROIZcd4n9Pdid+gGMjqdq0CwL88PFokgAtGTOtXPWa29NBs2QbKgiGs+6/u312p8Rgpc+zi9aE7M8iiEDughI7huOr4Oq9UiiLT3xH0gtG4VuhXLY3MchnNTh0Z4rOXZ3NIT9xGbcE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(66946007)(66476007)(66556008)(1076003)(4326008)(26005)(8936002)(2906002)(38350700002)(86362001)(6486002)(52116002)(38100700002)(956004)(186003)(5660300002)(6666004)(6512007)(36756003)(6506007)(8676002)(83380400001)(316002)(2616005)(107886003)(966005)(508600001)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sb1n9h8jzSQh7Fz3HFE47B4dGgtT0b76qQzkh3vx6rZErQot6pQlTJisdXKq?=
 =?us-ascii?Q?uW0Ya3ro+8Bj5AiIXCg66MqqeiJfcyjxyDjQ0O1fYcucrCgidj1JYCKAivjS?=
 =?us-ascii?Q?UvzyZmCeuFtmx/Os/xaxJN9Uqqdpea2DaKcwORLsvOiAsf8d/z2JLBW09VLA?=
 =?us-ascii?Q?Uwhl0Vkwa+JM7cyDL1Ru27iI8LIRWptOT+kDZ9RPnRb6bkaquDSbJ6Mz3+xq?=
 =?us-ascii?Q?1W+Orv65rFSA/enl41mYb7E86DDH26JUkGgPZJhorgvRnJHm7LQj1Vcx3kz8?=
 =?us-ascii?Q?VjuUGcPnb3aUJR/C0ynhWwWOyvkQrlidjDNtteenDqXj9MniOiaalALeiKmi?=
 =?us-ascii?Q?oiBBjxrpkf4clpdeFtviKnnXbCDgjlFijCJaZ+0Zos9/411W/K/GnTxZdDYt?=
 =?us-ascii?Q?hgHDMy+9RWxGygWy9jTVF3NhJ4F/TBZyvSFDDCe4HqrHlAo8lQL48c8liWh/?=
 =?us-ascii?Q?sYUX8NicXbgVtwkWFm+0GDcvj5RFFoUwi50ZTrG6mkfWV2jRRINe7y9xbrKS?=
 =?us-ascii?Q?ArfLdpEnp0MvTA6k8jsNP7/txcZIwBLF8PoSKud8gFTj5ioM2T1cHJEDUyDG?=
 =?us-ascii?Q?LAxEWxMYz2qas2f3gUHjJWFOX3JHNbuNu6FOM1WBhxQX4HAhIvwhx+MT/5G1?=
 =?us-ascii?Q?EzPrG/9HHusZZlV8xRSsGQF9xDiWOh31SGlOOZU220D3Bl7aRmZJDwE37FZs?=
 =?us-ascii?Q?+uAgQ+svGdxbKmHhpdzNz5TcRckKXMM99KpY6E5Op4/yKrDS1prDo7cWgYJj?=
 =?us-ascii?Q?9tjxdqmBiI0Dy/lKoa6mqotN0vkGb21OxQPEU0PyA3h0tQKRxq/Jb+uVpx52?=
 =?us-ascii?Q?rRXqZfRsUUuqPYWh2SFikLvzPq8eYj852h7okaW+7zsxEhvebL88CCjdYXEu?=
 =?us-ascii?Q?J3zXepQs5glaZ4uixMwrm+ORp1244TgXnbfSrCLrfGru/C0dAIfmuew9brt0?=
 =?us-ascii?Q?0JbClGvkA7Py/cFb941vWUVdF+cosO/9yehUx+eDQzFbz19WqfQmQXzfcPnI?=
 =?us-ascii?Q?Z0sMZVuhtABQHA7AM57jvparElxEvGvzPd2IOS+zY4oYYAKstX80evuvZDmK?=
 =?us-ascii?Q?GEuGM5d4CdJcCorBMGC/GSMydJKY6pkz5SvvigkCDzvsjbtQjSIfgiHFjzCf?=
 =?us-ascii?Q?tOmL8i4n5XSk2aEif9MaJqel+AAb4Yhe/3EUXkmk5Dm1PG7q0oRxCDvTdspE?=
 =?us-ascii?Q?YQI2aFZbr7UakGXAY9BNcFQ3ZC1HhB6C0ijdntmXWCk62kwYKampT6b7ImbU?=
 =?us-ascii?Q?yFtLlRwbY61gGAO/Xe0e4CVahdpeqJo8Z5GqxQiImwChbqaQ7FKsXJODEJVy?=
 =?us-ascii?Q?7PSKgptRm4qfjbn+mINtz5I/55U7PfnHToyq7wesfUVk6q1EIfZ1UG4CxwB1?=
 =?us-ascii?Q?l8zcXzisueZuhLHsMvgAURVzj7nta/5Ukl/2TwMFJS/ElILAOBTeu8nfurBA?=
 =?us-ascii?Q?Oj7CNX98uR8EjepL4y3O4XWvudylRsvO?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a06b250-f6ba-456a-b0c1-08d99525c45e
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 06:32:49.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11115066@vivo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2902
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch try to fix divide error in drivers/net/usb/usbnet.c.
This bug is reported by google syzbot,
divide error: 0000 [#1] SMP KASAN
CPU: 0 PID: 1315 Comm: kworker/0:6 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: mld mld_ifc_work
RIP: 0010:usbnet_start_xmit+0x3f1/0x1f70 drivers/net/usb/usbnet.c:1404
Call Trace:
 __netdev_start_xmit include/linux/netdevice.h:4988 [inline]
 netdev_start_xmit include/linux/netdevice.h:5002 [inline]
 xmit_one net/core/dev.c:3576 [inline]
 dev_hard_start_xmit+0x1df/0x890 net/core/dev.c:3592
 sch_direct_xmit+0x25b/0x790 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3803 [inline]
 __dev_queue_xmit+0xf25/0x2d40 net/core/dev.c:4170
 neigh_resolve_output net/core/neighbour.c:1492 [inline]
 neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1472
 neigh_output include/net/neighbour.h:510 [inline]
 ip6_finish_output2+0xdbe/0x1b20 net/ipv6/ip6_output.c:126
 __ip6_finish_output.part.0+0x387/0xbb0 net/ipv6/ip6_output.c:191
 __ip6_finish_output include/linux/skbuff.h:982 [inline]
 ip6_finish_output net/ipv6/ip6_output.c:201 [inline]
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x3d2/0x810 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilt
the link is:
https://syzkaller.appspot.com/bug?id=e829c15b6c30d4680cf3198f72b0414adc907911

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 drivers/net/usb/usbnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 840c1c2ab16a..ada1b8242498 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -397,7 +397,7 @@ int usbnet_change_mtu (struct net_device *net, int new_mtu)
 	int		old_rx_urb_size = dev->rx_urb_size;
 
 	// no second zero-length packet read wanted after mtu-sized packets
-	if ((ll_mtu % dev->maxpacket) == 0)
+	if (dev->maxpacket && ((ll_mtu % dev->maxpacket) == 0))
 		return -EDOM;
 	net->mtu = new_mtu;
 
@@ -1401,7 +1401,7 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 	 * handling ZLP/short packets, so cdc_ncm driver will make short
 	 * packet itself if needed.
 	 */
-	if (length % dev->maxpacket == 0) {
+	if (dev->maxpacket && (length % dev->maxpacket == 0)) {
 		if (!(info->flags & FLAG_SEND_ZLP)) {
 			if (!(info->flags & FLAG_MULTI_PACKET)) {
 				length++;
-- 
2.33.1

