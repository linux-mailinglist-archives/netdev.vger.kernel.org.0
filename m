Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8162C22FF2B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 03:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgG1B4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 21:56:09 -0400
Received: from mail-dm6nam10on2099.outbound.protection.outlook.com ([40.107.93.99]:46977
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbgG1B4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 21:56:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFnFpG1l3kP6h+g4ku0K9jRAPSQN6ovmXqEmJc9ZMFJXDWYElzfV9/q/1EGkuBNPl1ofjP/3b7MbeLMPUJ5KbLnk44zksL6DZQDnay+8eG97/A22b1HhAz2pMUh1LNaRG2Sq7r6eM1yCqlsD8z6CBJNVP9yo+TWQQ/DYkxWoyPdJq0k0FlP4v40AueVJc7ziJ0CHw/EftfKZDDgyqcny2Ob/qi+iwuCHJ7qO8BZwiTgzOWOrG7wsNBufghj7BHK/QpB2xH0WhtsXdeQ9AHrlt5YQd9WjGiyVTEBZX0yMHxmbdEqliO+mF2fCQohS74XCh2N+P465r3AfJGvUTeD3iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ajq5a6uzJi9mneeg/ITDZGx33dxnLTie5Q9ERiweVs=;
 b=T5J/m9vij6XpBTG8EzfwloUik7VtHvVqRW7NLOAqR/hmjPXJEbmfC5hVfI4G/pcAzYfeAT/wwlBRT3I+qCh2k9wNnia4KC0yUBaRq7CluW3jzV16gI/gnBXHvh5Q1fQk+2W6TEfQgQQuJNY7LxJVivdDRPYjAj2T/bspl/K3lPG3/5w4CwFtuZ9fO2yPoLX/sO+Foi1wVv+XovEBBX3IBq9R4e1fGUoAmlWWF9PKiEQU1wEQyBFggQ/Z5exBMI5ZAf+SPeHhoFhyHKYnUcBjRlkZl+lWN8TGRdmAaUfAwZKlzng2eN9wx9pujDM4A/D9LVaWNbVMDD62S3riSdItJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ajq5a6uzJi9mneeg/ITDZGx33dxnLTie5Q9ERiweVs=;
 b=ECfgEIVEqbkQQV5loGcU6mPEspgQxu/Eb8NhhUz21MoRYkjGdashqIqM1b7Fa041BG2rX8JqpllcFUJNXLA03mo0iFBNRqO+EpHFm0CHA3N1lBE0atT0sq2sJ/ZcVLnSW4kZdRgOK+nJRHPI/dznN41iMrZfLimugmEu0GUzKyI=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microsoft.com;
Received: from BN7PR21MB1713.namprd21.prod.outlook.com (2603:10b6:406:b3::21)
 by BN8PR21MB1250.namprd21.prod.outlook.com (2603:10b6:408:a0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.1; Tue, 28 Jul
 2020 01:56:06 +0000
Received: from BN7PR21MB1713.namprd21.prod.outlook.com
 ([fe80::35be:7298:8ea1:6574]) by BN7PR21MB1713.namprd21.prod.outlook.com
 ([fe80::35be:7298:8ea1:6574%8]) with mapi id 15.20.3239.015; Tue, 28 Jul 2020
 01:56:05 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     gregkh@linuxfoundation.org, edumazet@google.com,
        stable@vger.kernel.org
Cc:     w@1wt.eu, decui@microsoft.com, Joseph.Salisbury@microsoft.com,
        mikelley@microsoft.com, viro@zeniv.linux.org.uk,
        netdev@vger.kernel.org, davem@davemloft.net, ohering@suse.com
Subject: [PATCH][for v4.4 only] udp: drop corrupt packets earlier to avoid data corruption
Date:   Mon, 27 Jul 2020 18:55:05 -0700
Message-Id: <20200728015505.37830-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0197.namprd04.prod.outlook.com
 (2603:10b6:104:5::27) To BN7PR21MB1713.namprd21.prod.outlook.com
 (2603:10b6:406:b3::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:b:b837:47b5:ae73:7450) by CO2PR04CA0197.namprd04.prod.outlook.com (2603:10b6:104:5::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 01:56:02 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [2001:4898:80e8:b:b837:47b5:ae73:7450]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f6602666-2250-4f1f-2d74-08d83299629a
X-MS-TrafficTypeDiagnostic: BN8PR21MB1250:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR21MB1250B349A1EB880570E73518BF730@BN8PR21MB1250.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qE0Dp6Hw8N/65cu3wgXFFtUjdBr2Ay5e7I6R6ylHnJk+10RUzai9GhD/ML5/DVxnCRkLnvlQ5RAfSsVZeP1ckPXhaoEyfUtlNq+/dJtbt779LIUi4Eta1Dqz+BHVoxbEqXHZiI9IkyEIBdbgFqD9lHhHKw8z1QfQVREpwSoSdUmiQWn7ThYihumHVW/Qn5On4ndrKA9LbIYb8sYylmRaXWIV4syGMfrc+CQo92YiVc/m7cnfTimZhRNhJyBarPRuqtaduQwLjc6Ov9d2K5mXW3hbsHpYCj34icDmcQ3Nx0+0gTpBIZUUfqhUCJSasPOXITeVpqkDshkVbX+0SObK4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR21MB1713.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(83380400001)(2906002)(2616005)(66476007)(66946007)(66556008)(36756003)(16526019)(478600001)(8676002)(5660300002)(86362001)(3450700001)(6486002)(10290500003)(1076003)(316002)(4326008)(82950400001)(82960400001)(7696005)(186003)(8936002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: y3wfchKRQk9n1BFEABERN0+GtHAYfusxSpcnI2efacDVPA4xB+NWJxWJM4t1EXoHUNF3Dt43XXcrwVz/5m4ZO6phCaihATwLL3dPHS8URSCR4dqVBgfSoSUSGWnGNXWvFOwpVkMw9q3WThjgRSRFxS2pjype/KkSFbYFUlAE4d++DD38k/2g9y7ALQkmV5MCBMPA4c0S9v31SNfPolL/NIt80QJzZK7nwkL77ZFIaSocfbR2O+V85/dWto8Y4I1RFGDCdtplUHiiSsdUVcgVMz0Mwj+j6v9e2KwpOeZUIdO7IAcyh3sA4eQk1v0v7pemq1JZHGQUSKHa7Wx7a9n7t+ZmOd8SzgnVba8zBnWR2HdMYv2odbchul9y3NVBrwdEMkM0RUxx+16ewdNKfJy07cqsoSY2asPkI2R5BlZKQJlUssprrvMRQyLw1CFZ2RwJN6bRnk4CrvF2tu4nBDaCPTuTTbQ0f3+Iza3EuVwc4hZDP8l4HwauyIshDPl9SyPANOZvqgXq5Or3eYqE+KfqdUfYeOnZQN2gVyyvka73d5HRy6R20n8O8S5w/TgRvT7EeSsCyaEiOW2c5QNjxfPxLu32PplMFwIR8hovD8BsOWG3oCc49nYBXS3AiQoL2iWIWIno94HsXtQouJJbWAAOJjSNTWa4vIeFP13ya9cLKAQZt8pvdFW+p7cY5Em3LtQZoA0TMvwrdUZpHqwT+wCCEw==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6602666-2250-4f1f-2d74-08d83299629a
X-MS-Exchange-CrossTenant-AuthSource: BN7PR21MB1713.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 01:56:05.4472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovC4/7johYqHij/ux/kuBPCTJWj+u4nc4qUK8benOQL4FpOFacDM2Y4iSveIIw0KiCfhAuL7MaO1YDciyu4EPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1250
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The v4.4 stable kernel lacks this bugfix:
commit 327868212381 ("make skb_copy_datagram_msg() et.al. preserve ->msg_iter on error").
As a result, the v4.4 kernel can deliver corrupt data to the application
when a corrupt UDP packet is closely followed by a valid UDP packet: the
same invocation of the recvmsg() syscall can deliver the corrupt packet's
UDP payload to the application with the UDP payload length and the
"from IP/Port" of the valid packet.

Details:

For a UDP packet longer than 76 bytes (see the v5.8-rc6 kernel's
include/linux/skbuff.h:3951), Linux delays the UDP checksum verification
until the application invokes the syscall recvmsg().

In the recvmsg() syscall handler, while Linux is copying the UDP payload
to the application's memory, it calculates the UDP checksum. If the
calculated checksum doesn't match the received checksum, Linux drops the
corrupt UDP packet, and then starts to process the next packet (if any),
and if the next packet is valid (i.e. the checksum is correct), Linux
will copy the valid UDP packet's payload to the application's receiver
buffer.

The bug is: before Linux starts to copy the valid UDP packet, the data
structure used to track how many more bytes should be copied to the
application memory is not reset to what it was when the application just
entered the kernel by the syscall! Consequently, only a small portion or
none of the valid packet's payload is copied to the application's
receive buffer, and later when the application exits from the kernel,
actually most of the application's receive buffer contains the payload
of the corrupt packet while recvmsg() returns the length of the UDP
payload of the valid packet.

For the mainline kernel, the bug was fixed in commit 327868212381,
but unluckily the bugfix is only backported to v4.9+. It turns out
backporting 327868212381 to v4.4 means that some supporting patches
must be backported first, so the overall changes seem too big, so the
alternative is performs the csum validation earlier and drops the
corrupt packets earlier.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 net/ipv4/udp.c | 3 +--
 net/ipv6/udp.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index bb30699..49ab587 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
-	if (rcu_access_pointer(sk->sk_filter) &&
-	    udp_lib_checksum_complete(skb))
+	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
 	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 73f1112..2d6703d 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -686,10 +686,8 @@ int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
-	if (rcu_access_pointer(sk->sk_filter)) {
-		if (udp_lib_checksum_complete(skb))
-			goto csum_error;
-	}
+	if (udp_lib_checksum_complete(skb))
+		goto csum_error;
 
 	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
 		UDP6_INC_STATS_BH(sock_net(sk),
-- 
1.8.3.1

