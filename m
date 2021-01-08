Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E82EEDC6
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbhAHHOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:14:41 -0500
Received: from mail-eopbgr150115.outbound.protection.outlook.com ([40.107.15.115]:49123
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbhAHHOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 02:14:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVtyZCMeo6amwvqP3CAcxLVX0Mpd7KfqnFd23r4HgAnLPbi3XeMu0UewZ4QPyYUwh16W+7qsTzEU+nOwpzIRTjLtLs3ZDUB7x/yNp5vXxut+HlTSgTtJZaywVNMV7uLxXEqL7Q3gaew3748tjxZ+WtBW+G2uTLXzKsNHIk4GPFRpiGkQ/klo3uCCMysD8Qi6dG+XQxQhAIpSu9A5GDMdWSGv+JRTX/epGrqJAXY508ZbZG3hIzkiPGCuyCKdDrVZ689REGIo5TlC36OgHsVHnk3hSEDs7BbJ9NhG0rW3NQPD7zCbg2RgSmghHwO8ZOUwkBn/TZghECsx+JeJheiksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjYnEFuifdhZ14XljqA4PTVPv9W+IicaegchparFxvk=;
 b=ZW5Lj2pUTOOCqhrwBo20VF73ix3DWC16oru2WKzf9egYbXWwgotrqYCOclMsc+U4F2yBget5e9jHEBmwxrbk3Am2jBHy99vYQB8KLkWUan/xd1JmiXLxVEw19FAJ7mPSWes74FL048079Jb3quU0YFQ5U3+7SAzdWf8z0WjOz63qcoArcEOZgPNG9Kya2Y+QDnnL4sCgKhUcb+SQkq8lJnhfSW9337H9wOQ15dpqkHX6lI3FBjbww2TLbVWBjQ9ZbmJ/MvnahRvESw3oPLc/ToxOM5egchVznngQ9KHx3lFbKNsZjdgaqXo9RfFvu4q0bN7THI/R0/g4qIRuPOeFVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjYnEFuifdhZ14XljqA4PTVPv9W+IicaegchparFxvk=;
 b=bwU8DLhqc3wz4vaedkc3gewmzJ9itDZ/k5ti/CyUce/R+txfTm4ARqqoV0fFRYCbphsF0mu9/mlyDzvUbNHlbn5/zT5645Cw5v/UaXYbFUrLlhDu2b8frU/Fmwx5Y/0FM4fMAHoW0ve9R0ahgwKfZUmu2FZtu5/G1aYazA4fpLQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (20.176.4.149) by
 VI1PR0501MB2286.eurprd05.prod.outlook.com (10.169.134.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3721.20; Fri, 8 Jan 2021 07:13:51 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883%6]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 07:13:51 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     netdev@vger.kernel.org, ying.xue@windriver.com
Cc:     maloy@donjonn.com, jmaloy@redhat.com,
        Hoang Le <hoang.h.le@dektech.com.au>
Subject: [net v2] tipc: fix NULL deref in tipc_link_xmit()
Date:   Fri,  8 Jan 2021 14:13:37 +0700
Message-Id: <20210108071337.3598-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [113.20.114.51]
X-ClientProxiedBy: HK2PR06CA0024.apcprd06.prod.outlook.com
 (2603:1096:202:2e::36) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by HK2PR06CA0024.apcprd06.prod.outlook.com (2603:1096:202:2e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 07:13:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48bf8591-de13-4346-0e5b-08d8b3a4f35e
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB22863C9A73F1D88111F4612EF1AE0@VI1PR0501MB2286.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UCXfSdkGimOHkv/anbjn8SJyj177ImDYNF4rOcA7oPKK7rDElJNjV8nR92QH8UrrYE0FoDnCH0idCJd1WX2mhZdLn9SzjnQN77LFXSYnh7PWe4WkKCkWuhW3oaik+9MKho0mymys5ra/XjgvKxeSdid99iqIvZFpTithwlnzlQIZYlPYxljFOS75HSmiSBt9bDra1gBynrvc4SKQfSlK2VJN4iKKuDtifWgglRwQs59bqVqdlGk6km2KaPjKTLrNiPIBSASUZAT7GvfZlCrx4DF/kaVKppMSjMyV5yAKLbKr080y9xxr8EO1abcr0NHih6ZqEZTj3/lXo0pWziFgUMRwUSb+x6LTkadtzh6MQIzl6BfjyjspNAV96oo0DyBKV3ZEXv1HxEc8JF59OPIMMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(136003)(39840400004)(7696005)(6666004)(1076003)(2616005)(103116003)(52116002)(956004)(107886003)(66946007)(86362001)(83380400001)(316002)(8936002)(478600001)(4326008)(8676002)(55016002)(186003)(36756003)(2906002)(66476007)(16526019)(5660300002)(26005)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AUCc7PYjtKoO3VGgLI/N5A3QHH9ItS5l2OOUYkOsMHeu9oH9RaqQ2PUwM+PL?=
 =?us-ascii?Q?0yRRe/9lH8zY0eNXxe4sb3BQZM7V5qUOMRla5p6Vo5i1ltkG0l+9aXL6WCzY?=
 =?us-ascii?Q?6KmMAfUyWWDZxDAm/Q/q1cRJ2QsnVfGYaVOJujYdp2j+8QDEqJR+ChiI/tuE?=
 =?us-ascii?Q?Ssvm+Bw3YX4pz5WIkC9DJznwsw8Zb55tumnLlnreGnSNY2jOe8W+psDAPs0f?=
 =?us-ascii?Q?GCyMKuskzATbJXsFWUKLTgTUxBCAM5nrLqk1Ey3WTbCgvyx3W7bxOmQfKSwv?=
 =?us-ascii?Q?xrcons/NH1bDoHvlfpD8Z4NZuzZUBhU0CoR77FOHjdI99zIq6UvpaGGczjmH?=
 =?us-ascii?Q?y9EdU4o3307xBCsjnxEFV1xvjChVpgyA9olFi6y80J3Y9WUCdcrS8FY05VZM?=
 =?us-ascii?Q?ufLno9wzbNTNzgyr0tXAK/Cl2I8cD/iBz3HqiIzBb96J6bSu/KDuoEcOGtqx?=
 =?us-ascii?Q?MvI4+uDNf1Yy5NejxirBEQwwaYNjq3xoA/iOEdbmanNBPmXt9jo9/GFTQyzO?=
 =?us-ascii?Q?GpGwR1NAofmCo8RuB5E+NAEXXVGR0Gu/gFzzYRHP4C7LOJ4pyxxYyb22xd6F?=
 =?us-ascii?Q?/PZZu90wbl5BCz+nTeFOvwWD4NPX2amFPRUF/R5QEiUCRZCRumvMKCC/PFoY?=
 =?us-ascii?Q?uEXZ1D1r28jUMH2Qkr61arR1v2Wsju4erLAJe+pJQho57wGkjOQoVJ1076lJ?=
 =?us-ascii?Q?RkIepNuXzqYZ8XW0UgyXO67U8XRB31s04BDMsbgyBX+YAEYGDkEOyYkKZIHF?=
 =?us-ascii?Q?cVgLpTw6xgAGW1Ms+gGHpAlZiqwPz3E0ErpIGhFt11yXgFECW6TrSYrA98A7?=
 =?us-ascii?Q?koD1xJJGomGoLbXw/WqsywMKNuqTIJ3cF4uTf5cHS2es8EbxtO+RjkYAaSty?=
 =?us-ascii?Q?pU5E1XEzam6V1jYo5sV2xfzZbmY4uCJo+nSorZFxVk/mg9xwJcK9hjPz/cTr?=
 =?us-ascii?Q?rjBBFueRwDTK+7dhSP2cGmu3QVX4oFlqEm+6SILg8oYoyi6b/M5d4ee6CMJd?=
 =?us-ascii?Q?W3sp?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 07:13:51.0621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-Network-Message-Id: 48bf8591-de13-4346-0e5b-08d8b3a4f35e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7E1agQmY4+DOAoQBN4i3KqeXgcf00gYel5SCHiBNgVZFcusJNxCue6OpdBo9FznL6mwAFs0SDow2dmiRAsg7r/f/17TlqOrQzTiq3gCMfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2286
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

The buffer list can have zero skb as following path:
tipc_named_node_up()->tipc_node_xmit()->tipc_link_xmit(), so
we need to check the list before casting an &sk_buff.

Fault report:
 [] tipc: Bulk publication failure
 [] general protection fault, probably for non-canonical [#1] PREEMPT [...]
 [] KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
 [] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 5.10.0-rc4+ #2
 [] Hardware name: Bochs ..., BIOS Bochs 01/01/2011
 [] RIP: 0010:tipc_link_xmit+0xc1/0x2180
 [] Code: 24 b8 00 00 00 00 4d 39 ec 4c 0f 44 e8 e8 d7 0a 10 f9 48 [...]
 [] RSP: 0018:ffffc90000006ea0 EFLAGS: 00010202
 [] RAX: dffffc0000000000 RBX: ffff8880224da000 RCX: 1ffff11003d3cc0d
 [] RDX: 0000000000000019 RSI: ffffffff886007b9 RDI: 00000000000000c8
 [] RBP: ffffc90000007018 R08: 0000000000000001 R09: fffff52000000ded
 [] R10: 0000000000000003 R11: fffff52000000dec R12: ffffc90000007148
 [] R13: 0000000000000000 R14: 0000000000000000 R15: ffffc90000007018
 [] FS:  0000000000000000(0000) GS:ffff888037400000(0000) knlGS:000[...]
 [] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [] CR2: 00007fffd2db5000 CR3: 000000002b08f000 CR4: 00000000000006f0

Fixes: af9b028e270fd ("tipc: make media xmit call outside node spinlock context")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
--
v2: add 'Fixes' tag
---
 net/tipc/link.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 6ae2140eb4f7..a6a694b78927 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1030,7 +1030,6 @@ void tipc_link_reset(struct tipc_link *l)
 int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		   struct sk_buff_head *xmitq)
 {
-	struct tipc_msg *hdr = buf_msg(skb_peek(list));
 	struct sk_buff_head *backlogq = &l->backlogq;
 	struct sk_buff_head *transmq = &l->transmq;
 	struct sk_buff *skb, *_skb;
@@ -1038,13 +1037,18 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	u16 ack = l->rcv_nxt - 1;
 	u16 seqno = l->snd_nxt;
 	int pkt_cnt = skb_queue_len(list);
-	int imp = msg_importance(hdr);
 	unsigned int mss = tipc_link_mss(l);
 	unsigned int cwin = l->window;
 	unsigned int mtu = l->mtu;
+	struct tipc_msg *hdr;
 	bool new_bundle;
 	int rc = 0;
+	int imp;
+
+	if (pkt_cnt <= 0)
+		return 0;
 
+	hdr = buf_msg(skb_peek(list));
 	if (unlikely(msg_size(hdr) > mtu)) {
 		pr_warn("Too large msg, purging xmit list %d %d %d %d %d!\n",
 			skb_queue_len(list), msg_user(hdr),
@@ -1053,6 +1057,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		return -EMSGSIZE;
 	}
 
+	imp = msg_importance(hdr);
 	/* Allow oversubscription of one data msg per source at congestion */
 	if (unlikely(l->backlog[imp].len >= l->backlog[imp].limit)) {
 		if (imp == TIPC_SYSTEM_IMPORTANCE) {
-- 
2.25.1

