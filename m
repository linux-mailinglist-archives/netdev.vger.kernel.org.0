Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A474D286F7C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgJHHcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:32:13 -0400
Received: from mail-vi1eur05on2125.outbound.protection.outlook.com ([40.107.21.125]:64832
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727232AbgJHHcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 03:32:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idGPCMVNjA0rmqYwlrU90mxocz0CW2qaI/rr+PDAojAhSjefHfNQDWugUSuQttSAlphMQB2DxNERIx8MZF/BujXonDwtCx0dWpAWFWVMmOvHsOtF1xUcCd7Z+ddiON+WGCXuZt13PPMjF+v93eZQhk0t933ubxBgqyN0GJOT9RqTuEcw49EEka2PJp/BunIWzhrLHHiN1rHxzpeRT6PcFHShDocLzDYSO2c0T9ef5ED8Gao/+E2YWmlIYyWbJkxRFGO2NBRHaAy5SFCCXWmimlLnIPtw4B8bbGXC0ti2UuYOh4paGxnlMRGyrWSm3n74kmuILzRMDVhkrmKJGvekgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kr9aZUbBXd1cpl3fEog/kvWScIfSN5vVZKS/QCQeO3Q=;
 b=XMBChw460D+V/gDCvOJVjbmktcU5HONioCe1yZHdPYHyhkQPwRZzsfvOMtaopTLR4smbfr/ToRhLAP1m5q/04t4qiDnQUjsR1PcUOpWV+nNO5Y/m5jdn0CWvf4HzzdDu280pp4Yw9YcqgX5h2+Mhiz/7J33NQWrfpBm/ievHdp6FkRQKt5rLFIZE32XTtRXGpRBwYbKbc5fUK7IDSnUTK839o0foCA2Ed5kRqNjUsYCHnm7dfx2YNVGD4eCoPaRqY7hhsgHNmMCaanQQ0PeykzjLY/0eEB1NcHtn0vaxV/MQicYDyw+6dp45D9mgduC+2cPxRK1geNaAvrgCXF4SuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kr9aZUbBXd1cpl3fEog/kvWScIfSN5vVZKS/QCQeO3Q=;
 b=UutjU6mxOD6FM+3LUvVPKf8tqvMMgfMIXuYhKCxpCrjgv65Vu2NsB+VUtfTI6tZeowWMCz/x+LxkqsYNO9SD9rMO3YEcrgOgYqfqyXAjN+BNguw3rWLUrje5kruE0hlJEOcsu1PgWqrkKJLpMi3v3eRlyvi53zZmz+Dl0oHAbjQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6720.eurprd05.prod.outlook.com (2603:10a6:800:139::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36; Thu, 8 Oct
 2020 07:32:09 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4%6]) with mapi id 15.20.3433.045; Thu, 8 Oct 2020
 07:32:08 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [net] tipc: fix NULL pointer dereference in tipc_named_rcv
Date:   Thu,  8 Oct 2020 14:31:56 +0700
Message-Id: <20201008073156.116136-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SGAP274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::34)
 To VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SGAP274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Thu, 8 Oct 2020 07:32:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e36044e6-012f-40ff-fbd5-08d86b5c435b
X-MS-TrafficTypeDiagnostic: VI1PR05MB6720:
X-Microsoft-Antispam-PRVS: <VI1PR05MB67209E9923DA2C82A9261798F10B0@VI1PR05MB6720.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3coTc+J7K/npbjffOp9qL8zHLFugmacK2pwvqHL2WzLqvxHhgeTJdAg7P/NVjvW2mDgLHRKgloEobFTpndg8y4pYMk2KBf4MQvGHHuXfLOKhUeyOHdsY8y+E5TO0aVYWeTg4UUPJIPJNAkvZTzhltdvLVPMihH6z8oGeD+9/vH5A0KMtMPCsbbAvPaNn7T2deAt8txFRin+vLA7FvlRMXt/8eLfQAtC2+pJjVdDLHLG+QcaQ/rn5oxrGnh1Kf3b5vbofDCHY5rR/6kO3v+wOq9x9Ip+RC6HQAultpT44sN2bu+bQ1GUP117XvbRp0sANMVjXh+9Gz+09DKorDbKnBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39840400004)(396003)(366004)(45080400002)(8936002)(55016002)(1076003)(2906002)(6666004)(52116002)(66556008)(66946007)(66476007)(103116003)(7696005)(5660300002)(26005)(316002)(956004)(86362001)(16526019)(478600001)(83380400001)(8676002)(186003)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BsJwFBJfBv6YzKi8xP8r+PMG+m5zfYbzJ1R/UiJvbjFvatiRHjNJLtXekllha/QcOuplx7UnuZgxQl6jFRcjw9E/hnkdICV97BtA5dWOxWbiX+o/wcRFjGqrsibifntydd+8ZI7sQBpQ5XO0voXkXs1JU5eHnlyGjHvXkmXAlwJfzBdP4fyi+N7PTpR6tumFnRL//RDi/NQKIiIXJuvsZSMK2jZSxjUNntR9iDEk68KPYKmuesdz5UWB65vUYYmIuQD/jG/vbZIMcbSEhxr4GG+yUAT4ebqLhBrzllGJEiKUbFtywlr3fSBWYbcc/7ctR8jxyqqy45pEDyXVgvRkdHz6TJXdI45lCucmo54RFEPktzmCgUDnTDjOPIt0TANSFQH9qjJutpDv3hK/iYW91pBC4ZoE9eas2f4jGrMD6ls87pVJTudI0Dra35+MzZn9l2FhhpeCufw5gSV4Qkb8VK6BTlFxJi/C5siJ7vlwbBcCbv3OPE0G5XaneFqCLfeDFQisRGAITkTJsW4b8N9F9s5obwgqbOTeNI7AvCrbTZ86ATDFEeiXzqQ7usKb27jemmz8sbM4uTqF0uyriYqoBIOW4Q5k53sxgVzmqqeVArHrFIi9ynpAzxzC0vkFWEkQ6Zub/JJ9VyEMKI75LSnGFA==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: e36044e6-012f-40ff-fbd5-08d86b5c435b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 07:32:08.7808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2My/U9tklB9ky2WTICAI1BcUNSf1f4bnb5OJb0uFsaSET3jUTMwXvcP07NKMNJ3tk8b6c1YU70QISiyPOCHsDGkqcS0oVF5Ox5a81x6StAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6720
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function node_lost_contact(), we call __skb_queue_purge() without
grabbing the list->lock. This can cause to a race-condition why processing
the list 'namedq' in calling path tipc_named_rcv()->tipc_named_dequeue().

    [] BUG: kernel NULL pointer dereference, address: 0000000000000000
    [] #PF: supervisor read access in kernel mode
    [] #PF: error_code(0x0000) - not-present page
    [] PGD 7ca63067 P4D 7ca63067 PUD 6c553067 PMD 0
    [] Oops: 0000 [#1] SMP NOPTI
    [] CPU: 1 PID: 15 Comm: ksoftirqd/1 Tainted: G  O  5.9.0-rc6+ #2
    [] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS [...]
    [] RIP: 0010:tipc_named_rcv+0x103/0x320 [tipc]
    [] Code: 41 89 44 24 10 49 8b 16 49 8b 46 08 49 c7 06 00 00 00 [...]
    [] RSP: 0018:ffffc900000a7c58 EFLAGS: 00000282
    [] RAX: 00000000000012ec RBX: 0000000000000000 RCX: ffff88807bde1270
    [] RDX: 0000000000002c7c RSI: 0000000000002c7c RDI: ffff88807b38f1a8
    [] RBP: ffff88807b006288 R08: ffff88806a367800 R09: ffff88806a367900
    [] R10: ffff88806a367a00 R11: ffff88806a367b00 R12: ffff88807b006258
    [] R13: ffff88807b00628a R14: ffff888069334d00 R15: ffff88806a434600
    [] FS:  0000000000000000(0000) GS:ffff888079480000(0000) knlGS:0[...]
    [] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [] CR2: 0000000000000000 CR3: 0000000077320000 CR4: 00000000000006e0
    [] Call Trace:
    []  ? tipc_bcast_rcv+0x9a/0x1a0 [tipc]
    []  tipc_rcv+0x40d/0x670 [tipc]
    []  ? _raw_spin_unlock+0xa/0x20
    []  tipc_l2_rcv_msg+0x55/0x80 [tipc]
    []  __netif_receive_skb_one_core+0x8c/0xa0
    []  process_backlog+0x98/0x140
    []  net_rx_action+0x13a/0x420
    []  __do_softirq+0xdb/0x316
    []  ? smpboot_thread_fn+0x2f/0x1e0
    []  ? smpboot_thread_fn+0x74/0x1e0
    []  ? smpboot_thread_fn+0x14e/0x1e0
    []  run_ksoftirqd+0x1a/0x40
    []  smpboot_thread_fn+0x149/0x1e0
    []  ? sort_range+0x20/0x20
    []  kthread+0x131/0x150
    []  ? kthread_unuse_mm+0xa0/0xa0
    []  ret_from_fork+0x22/0x30
    [] Modules linked in: veth tipc(O) ip6_udp_tunnel udp_tunnel [...]
    [] CR2: 0000000000000000
    [] ---[ end trace 65c276a8e2e2f310 ]---

To fix this, we need to grab the lock of the 'namedq' list on both
path calling.

Fixes: cad2929dc432 ("tipc: update a binding service via broadcast")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/name_distr.c | 10 +++++++++-
 net/tipc/node.c       |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 2f9c148f17e2..fe4edce459ad 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -327,8 +327,13 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
 	struct tipc_msg *hdr;
 	u16 seqno;
 
+	spin_lock_bh(&namedq->lock);
 	skb_queue_walk_safe(namedq, skb, tmp) {
-		skb_linearize(skb);
+		if (unlikely(skb_linearize(skb))) {
+			__skb_unlink(skb, namedq);
+			kfree_skb(skb);
+			continue;
+		}
 		hdr = buf_msg(skb);
 		seqno = msg_named_seqno(hdr);
 		if (msg_is_last_bulk(hdr)) {
@@ -338,12 +343,14 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
 
 		if (msg_is_bulk(hdr) || msg_is_legacy(hdr)) {
 			__skb_unlink(skb, namedq);
+			spin_unlock_bh(&namedq->lock);
 			return skb;
 		}
 
 		if (*open && (*rcv_nxt == seqno)) {
 			(*rcv_nxt)++;
 			__skb_unlink(skb, namedq);
+			spin_unlock_bh(&namedq->lock);
 			return skb;
 		}
 
@@ -353,6 +360,7 @@ static struct sk_buff *tipc_named_dequeue(struct sk_buff_head *namedq,
 			continue;
 		}
 	}
+	spin_unlock_bh(&namedq->lock);
 	return NULL;
 }
 
diff --git a/net/tipc/node.c b/net/tipc/node.c
index cf4b239fc569..d269ebe382e1 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1496,7 +1496,7 @@ static void node_lost_contact(struct tipc_node *n,
 
 	/* Clean up broadcast state */
 	tipc_bcast_remove_peer(n->net, n->bc_entry.link);
-	__skb_queue_purge(&n->bc_entry.namedq);
+	skb_queue_purge(&n->bc_entry.namedq);
 
 	/* Abort any ongoing link failover */
 	for (i = 0; i < MAX_BEARERS; i++) {
-- 
2.25.1

