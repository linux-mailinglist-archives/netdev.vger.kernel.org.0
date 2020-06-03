Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F981EC890
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 07:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgFCFGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 01:06:20 -0400
Received: from mail-eopbgr70108.outbound.protection.outlook.com ([40.107.7.108]:55305
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbgFCFGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 01:06:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RljspTh/J08iCv5FycCPMBRfGCFaebtKoPVULTuj4/td6fDZfHsIpQRZadBf8puQNJOIGiKuMOQqmZqF1sCQ+LnURoErJJiuQLx5bZXIKae9Ogk2otYNXKT/JE5Pcnye8zahA9/+XgA5L/MKpglMsnDnIOLTGwyuhm1lFUNSt3gzfvU2+nuvs5g7lQ5pd8Rv9xsSJ38BiVM0gjFSYcxTdzKStP+7vHmkihFsTmrvKiCPAWNDcHrWhATM7Gr0YrpsCkO3qjrIBEdNXKtRiOLWS2xZ9WqNnZgOBmTEh2qRuLBJzbabUvWHrxpzDHFq8Eax+rM6mRbHm1+oUzuT1EzDmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGDHhH9hsPFOBCEFq/hUrHDr9zO2x6MATSyU2JpaKUQ=;
 b=TW4owd6fguyebPUuDL7cWBt6d2QgxPl6UXAq/u1l2pb2Jsj/XSqeAJaJH+VgJh85FgHFviXmITCHEpu2pe0eDM7opel++e+IxUPbHE65FFcHCW3hlg7SGgWzb94izdERvHBnzKGH8uL0cZ2t/vCHHu5bFag6T6V5dwKYDRBrnznDfol6r3ogYQnRycHnbvlD7+ARRy/LTrfo19Fga7foYsFFrQyMM2LUHRUFmkOPh+8J+DmPj3i5mlnODnOiilWxaROKGNxVuvfZlXtuPUUsOX/9Nr0guSePANn8xpMftpWltKjiYKKaVXP51YspJy29aCyiPBVpJnJ4s6xUilSS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGDHhH9hsPFOBCEFq/hUrHDr9zO2x6MATSyU2JpaKUQ=;
 b=D9eI7mp/SwzL999taKJQ235vA/q890nooFQ27m2iFtbYSSDFHxW9/vczrhD74oDD2yXjKnUavDaHp355YGWLmkxKp5csSzN8MQCeemWhshUxhSHvZF0iNt+Ejk01BP6G0ILuvABUgIKEaNZJTQVkGDpk5+J8tIwp+SMXGq9YHzU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3686.eurprd05.prod.outlook.com (2603:10a6:209:10::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.25; Wed, 3 Jun
 2020 05:06:15 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 05:06:15 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next] tipc: fix NULL pointer dereference in streaming
Date:   Wed,  3 Jun 2020 12:06:01 +0700
Message-Id: <20200603050601.19570-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0023.apcprd04.prod.outlook.com
 (2603:1096:404:15::35) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by TYAPR04CA0023.apcprd04.prod.outlook.com (2603:1096:404:15::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 05:06:11 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0312019-419c-47f6-2c24-08d8077bd6de
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3686:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB3686F871D8F1CBACCBFE735EE2880@AM6PR0502MB3686.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cStKIZKRhV9yy9XZRhB9PJinw9JsJt273E3dk18Uda/fVxJz63/CkChmtDATw+kDmlrUZu007OA1g3gkdnRc+mQ2JNpvoMp/4BSrFTo2dwkl8hcok+iI+K+2m5mCCsAp+b72uwls3Hnjb5KMZRrgdts06xQDwledHlF9wDyWcWiQnYWceb9HZinPS2LsuOcWpVNsFXc+d7M9RWxlE3kMAZdEJikErBMDUbRQI65ZhgTJyBACd5UyYX2TCPJrqsgNlqubMS1pGGg6EbrrqDVxsSw3tVaoR5GZMdc2BZVQxVCCh9sCIZXE/XoEv3NFyiOl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(396003)(366004)(376002)(346002)(136003)(5660300002)(1076003)(66946007)(66556008)(6666004)(66476007)(956004)(83380400001)(2616005)(16526019)(7696005)(86362001)(8936002)(8676002)(186003)(26005)(52116002)(2906002)(55016002)(4326008)(36756003)(103116003)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rl5G9rgT1wSMwi9yc8Rzs09qK+KGlQt+kje7Fj1BcgSsPGyPcyouQUY4npvNvS83tS2l8jbpl5sxR9USp8sFUYQphFlhlILcIoSXyFFSictST5xtYd9m7P/VUUsm5jzFmcqe3DFH/a8KYzw6jMLGGop22R3nUWZiOlkQpvt0BZ0Ms8uOGz0rMuEmJAS8qFNdBZGW2rjKow6WycgMyPbPZ5/Eu1t3YzyuuQ9vs6xI3+U65X2K390yGU77eldE73JDh8usCPGLKxJpPqVSzjdQgOrfBt35Lgzvhi6keY/eTNtAP+ojFx8sMy8OrTBYK8O8MHRXHdLbDrUkXUjkx3I6A/PDoFptY/rT2z1u8isUCIS589Rl50uQycF/FRsqObM/qMYfe1zMIuFpbuiZ8718mfoGfkkJXrAPP6qHMTUssek08CbugxNpJ2Jd+IwG5IqrJT4XrJBDd9H6DNwgxdgD4xd9jU5Lc5wvZ+LnIfuCiEA=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: e0312019-419c-47f6-2c24-08d8077bd6de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 05:06:14.9776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q6CSuJiiFGZy44bfP5dTjOsrZSRks/JgmdZgFC5aTunCoFUKa3DfnajHGW9GH7gVPMQ0vv1Lv7+ktk6D1w3knnRse+FSzjca4Qr9jRHo7eA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3686
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found the following crash:

general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
CPU: 1 PID: 7060 Comm: syz-executor394 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__tipc_sendstream+0xbde/0x11f0 net/tipc/socket.c:1591
Code: 00 00 00 00 48 39 5c 24 28 48 0f 44 d8 e8 fa 3e db f9 48 b8 00 00 00 00 00 fc ff df 48 8d bb c8 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e2 04 00 00 48 8b 9b c8 00 00 00 48 b8 00 00 00
RSP: 0018:ffffc90003ef7818 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8797fd9d
RDX: 0000000000000019 RSI: ffffffff8797fde6 RDI: 00000000000000c8
RBP: ffff888099848040 R08: ffff88809a5f6440 R09: fffffbfff1860b4c
R10: ffffffff8c305a5f R11: fffffbfff1860b4b R12: ffff88809984857e
R13: 0000000000000000 R14: ffff888086aa4000 R15: 0000000000000000
FS:  00000000009b4880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 00000000a7fdf000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tipc_sendstream+0x4c/0x70 net/tipc/socket.c:1533
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x32f/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmmsg+0x195/0x480 net/socket.c:2496
 __do_sys_sendmmsg net/socket.c:2525 [inline]
 __se_sys_sendmmsg net/socket.c:2522 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x440199
...

This bug was bisected to commit 0a3e060f340d ("tipc: add test for Nagle
algorithm effectiveness"). However, it is not the case, the trouble was
from the base in the case of zero data length message sending, we would
unexpectedly make an empty 'txq' queue after the 'tipc_msg_append()' in
Nagle mode.

A similar crash can be generated even without the bisected patch but at
the link layer when it accesses the empty queue.

We solve the issues by building at least one buffer to go with socket's
header and an optional data section that may be empty like what we had
with the 'tipc_msg_build()'.

Note: the previous commit 4c21daae3dbc ("tipc: Fix NULL pointer
dereference in __tipc_sendstream()") is obsoleted by this one since the
'txq' will be never empty and the check of 'skb != NULL' is unnecessary
but it is safe anyway.

Reported-by: syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com
Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/msg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index c0afcd627c5e..046e4cb3acea 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -221,7 +221,7 @@ int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
 	accounted = skb ? msg_blocks(buf_msg(skb)) : 0;
 	total = accounted;
 
-	while (rem) {
+	do {
 		if (!skb || skb->len >= mss) {
 			skb = tipc_buf_acquire(mss, GFP_KERNEL);
 			if (unlikely(!skb))
@@ -245,7 +245,7 @@ int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
 		skb_put(skb, cpy);
 		rem -= cpy;
 		total += msg_blocks(hdr) - curr;
-	}
+	} while (rem);
 	return total - accounted;
 }
 
-- 
2.13.7

