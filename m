Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1DA2EC929
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 04:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbhAGDf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 22:35:29 -0500
Received: from mail-db8eur05on2128.outbound.protection.outlook.com ([40.107.20.128]:18848
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726829AbhAGDf1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 22:35:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ny4q0bUciZDTFc7SGWbMnkmc6ERjTHee0e3xPi2YIECs3ezNGJV5StAicy5P583wpyqzZh0g5RR5xkkC34FgzUV0rvrL2KId6LTLqydLP2zUh4/jykX++A1bnhshVYEnEIRANIgfmjbqSMatpglnpfKBrFZ01YfC+JeY8EsGL9KZawzpE/+L23+KGT97ZGf5Dotj1JAKcRFKkon3QBG2wHJqQOOireXGyl752CFTH0zTtCM9gvLY2q3NijIwANSOo9Zu0vWbNjHBkXRnjdhy89nDlNtBHBJW55u+16dw5Km2DzLldoczMdT8IvMlQZ2+WLIMjcDHITpSsZO2e5wF7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHEnXiHLkApKfXjpUzXIXrcSFqiPs3vPimyHtKzKerw=;
 b=AN7sV9UcOqM+6FwoW0x+NOKG4zIhiJAURV7vYZRhwo0gb/7BuprhQGm2j3YClcjv1NULS40iRIDTNM7P1PhXGR/IbjcTFSEzKRMJc8BMyvttLn0AXuDpkyrBMnTBZ5ELCr5eotRXjvpiNKGSIo4ht56h4bB+9J9LJtCFklSemr5A6VYSyNLjYEkKJ3eJ+getDoueACKMKklYnOz1n3tNh3ZtqsaoL85FW7HgqwR+eifw+E2HW9s10eCdUiVKxx17Oq0RduvMOD1YuFuggALiXJaDQg68Efgm3jCVjkCZJWvr2/4D2OI5a7o/K5KACvPI1QyDxWuhM8L1WSBdcD30zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHEnXiHLkApKfXjpUzXIXrcSFqiPs3vPimyHtKzKerw=;
 b=NfcEpRNrww6KjOr8PjTBAFk0gtTBw8OLtTcHR28Jg/55eQ2d+NjcStthl+0+8nAhJVqkuJc2o5v86T86Rfkk3Yts95vHkXE/ekJlSXcAfrfnVvBq9U7tm5fL/2h0PArNjbbQMD7XPZbS3do0JRykGxDWbIBreS14ctMl6DM8gZk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB4270.eurprd05.prod.outlook.com (2603:10a6:803:40::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 03:34:35 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883%6]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 03:34:35 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     netdev@vger.kernel.org, ying.xue@windriver.com
Cc:     maloy@donjonn.com, jmaloy@redhat.com,
        Hoang Le <hoang.h.le@dektech.com.au>
Subject: [net] tipc: fix NULL deref in tipc_link_xmit()
Date:   Thu,  7 Jan 2021 10:34:19 +0700
Message-Id: <20210107033419.8090-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: HK2PR02CA0133.apcprd02.prod.outlook.com
 (2603:1096:202:16::17) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR02CA0133.apcprd02.prod.outlook.com (2603:1096:202:16::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 03:34:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1df41586-cf13-48a9-1a3a-08d8b2bd27bc
X-MS-TrafficTypeDiagnostic: VI1PR05MB4270:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4270C5573B9B850982EA03BDF1AF0@VI1PR05MB4270.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HqxWkocCGOYsRLgO+4rsBQec8IqWIwDloihfMk+XRiv40hxQX9Y5VTi9Y+SZSGWvcyvUOOWif+Xh9BpXwxmyidbeG/LlqyDVf7TjMt8yfvYC1SVBS5Q2/TEsG9k860SIg99kizhGA/TnWuZD7LqRFD2eyQBdNaZ183LzGyMcLrs1AgdxY/sORV4u2oyM3dHuGjj8kM6oQNCMAHLC85X53deF1yGNN5kyw10PdWJzUCDO2KK2b6gKXkruHit0RQwtoPHj/qcrUuY9b1ACnpoS2G6N2zhhqhX6HNaDm+XFpg1SNNOwDH3uySDQOEzzWFpdj8+PyXbmRsDmB4idSSOuQXt3agCLKOMMDzaeEx2tLGDAyClgPobHmngCYopWLFPTaAv0sMnORjDlZe4Yt60Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(39840400004)(396003)(26005)(66476007)(66946007)(66556008)(8936002)(7696005)(52116002)(5660300002)(316002)(55016002)(956004)(186003)(36756003)(86362001)(107886003)(6666004)(2616005)(16526019)(8676002)(478600001)(2906002)(103116003)(83380400001)(4326008)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p1oU28R/5Bgg6StO3/Wi94Xs5BMMu83tyg86x4/OulEg0Dam94IGiu0VI4pA?=
 =?us-ascii?Q?Jdez9BFaMMRqAnNqWPE9/wMusHiAWa+2ZlA5RVcuTUJiueQ+ORlGD0SKBZ69?=
 =?us-ascii?Q?NdXZT2PJEKqShIVa0QP3eVoReGtvm0BJvCg4KxfJ6IsPI/ExB5uql7VEpiYf?=
 =?us-ascii?Q?qB2qAZq1x92cThWBvaA/WgSlqZyIR6KZaHK6AMyx8/XWkDn3w2mwM0IOa3JQ?=
 =?us-ascii?Q?pxo3dU9EUB+q1VskO2hSSV7ZfUMprK3NaLLUnv1z/kEHK6c9/769RoGOmXTV?=
 =?us-ascii?Q?FwDo6poJUVeq30JZoC+rqHHyueW5kz1j3sg0mWJUqOkJvrGwZa2i1QB2z78e?=
 =?us-ascii?Q?dFSFx60hJgSbP4e03mkLKZJ+az+uJFRTTyjff/KSGr4hDPx5AZYuVnh/diJ1?=
 =?us-ascii?Q?0Zd2w3Fdqmg1tTZ0+UkaZIc49vjKf6GxI3I5WXU7dQMa7s4s+TuS+xm69ZIF?=
 =?us-ascii?Q?/sCQQgIwyOVc4U3xLRAhsooylgw/PcqDyLU9VG27YqV0C5Ioe0xw3Hm9i9rK?=
 =?us-ascii?Q?63CWjCLAazaAFgKqUbgfQ4xeQba6NP/lpnlWeiZMmINiU4E1AN2Pw6D2WuiT?=
 =?us-ascii?Q?nPps13xpmIf1778O2TVsOiyk0N6Vt7ZVWrZQZvqmWSoLGS1qTOrJ4V2NE4Xs?=
 =?us-ascii?Q?vUY+mJn3M5fzpAkrvvIZwT5PkFAemvnwCt4jGUFITjb2yNX7cPezq7/fzUVi?=
 =?us-ascii?Q?AAmDwH9GlsuhctWc4hDQDVKWjxXsAlFhDfXyMLsFa/2Bx+i4e7lFTYw7GUf2?=
 =?us-ascii?Q?PmKymLDfR0AhavHKCD92n1hrrtU8wQzSAZTw4s9zyS2zpQbQGG4SzpRc709D?=
 =?us-ascii?Q?rlZsWmU8KSpicJxhOh3Pav6jB+M+Zok5NlEmTzZxkjHDa27gCDxzC+Gt1Ngp?=
 =?us-ascii?Q?n50A9LuUnqin6WK9C3yRPw9kmrXV1y0hvRPv8FIevP8T3NmF3LT8gcpBKIpy?=
 =?us-ascii?Q?60fL4TnPutjOc3u7dtZkEjrJ78Oqx4DEwPV5UWTfWg0ScoATXBY32LJyQbDb?=
 =?us-ascii?Q?Ems7?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 03:34:35.6638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df41586-cf13-48a9-1a3a-08d8b2bd27bc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIvIFXofwYHHg9swJvI5h/ZaIramv4QTpja7el7vBi2wRntaCeRXRkB4wwBA0MO6foCDQWCXGszDhixDrJtb4KHP6n3GJ6jGXq5xXj/9rmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4270
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

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
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

