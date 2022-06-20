Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D565512E5
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 10:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239935AbiFTIfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 04:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239923AbiFTIfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 04:35:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1793D12AAE
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 01:35:11 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id hv24-20020a17090ae41800b001e33eebdb5dso11653453pjb.0
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 01:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dWC+4f7xj2fYw7RfCu0ylHqU5RzikHTQ6Gl03CieYbM=;
        b=nrbYkejiRVICpTQ7XpomnwadVx8FhyG6WqzjIurkZeqEshawZcRGpg7vo0R4uuyeQL
         Lvgd1KAAzttBZafG3xYNt2hZWUqlfYRuN/khfYOwjAGYP7rAj1MBKQ4Qfb6Wm3WuMosA
         8S4nFCVz53IExsO+OxNIZN11YZghBDjk9c7n1vo+Pj6GRWwRUPzv/2ivO7Gtw17niiOS
         678uhICEdenMKQMFg+U0oJ45N36ZHMzd+Zp+ycQ0Q/gzmUn6vbCBnzQ0BTiluGM/xRwT
         /jQ9VrHY2MwM+mvSDfStwwh7arbCMSe7XT8VwYjcTDW2OPaE2ufakTyi0f9XXFfYZLze
         2Bcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dWC+4f7xj2fYw7RfCu0ylHqU5RzikHTQ6Gl03CieYbM=;
        b=XZKxJuLS+EYEBg4cPTm1mDouChSywtv0CmIBvV08NhZCpG2mqYP42oEYKI/HRj7dUo
         sV1/oPKNKtvbWrpeA8vg868msM3OU9jG27Bm0rblWciUadR6cCvpYe/z0bkHyqQygcxb
         fdjWOu+0UGYohCf7Jta2ek1hFluyeI+vyOnwql2Vu9miE0FbNOq+Ia42gMcKqmL+1GsC
         Kv0+l9eGGj45AmNxQQMrzteHGbTcORYxVhuJ3BYxymSuDitT5WKZy0zFL44D9haCMH5J
         XBbUx7mJOTF6cr3G4GogiCCNYRM+6Ko01uuctC14d+d9XJYhwDaPdLvpxTzDhhU0z7FG
         aTew==
X-Gm-Message-State: AJIora/G+HgDv8am8D4om3bceAtkbC/+WVTO6taARwnpVHkWXcCzrle2
        QDHHOaCZVLVEvYF8f5IQJQE=
X-Google-Smtp-Source: AGRyM1tz7u05k6AJO1yFUmskpHiwnXIs7Xf+2MR/llRy18Gwl/rr83wd/2ygoufs6RxjzzJNTvqZEg==
X-Received: by 2002:a17:90b:1d06:b0:1e6:7a84:3c6e with SMTP id on6-20020a17090b1d0600b001e67a843c6emr25930299pjb.202.1655714110484;
        Mon, 20 Jun 2022 01:35:10 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:394d:a9d5:3c7b:868e])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903024100b00163fbb1eec5sm8002872plh.229.2022.06.20.01.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 01:35:09 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        William Tu <u9012063@gmail.com>
Subject: [PATCH net] erspan: do not assume transport header is always set
Date:   Mon, 20 Jun 2022 01:35:06 -0700
Message-Id: <20220620083506.3274878-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Rewrite tests in ip6erspan_tunnel_xmit() and
erspan_fb_xmit() to not assume transport header is set.

syzbot reported:

WARNING: CPU: 0 PID: 1350 at include/linux/skbuff.h:2911 skb_transport_header include/linux/skbuff.h:2911 [inline]
WARNING: CPU: 0 PID: 1350 at include/linux/skbuff.h:2911 ip6erspan_tunnel_xmit+0x15af/0x2eb0 net/ipv6/ip6_gre.c:963
Modules linked in:
CPU: 0 PID: 1350 Comm: aoe_tx0 Not tainted 5.19.0-rc2-syzkaller-00160-g274295c6e53f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:skb_transport_header include/linux/skbuff.h:2911 [inline]
RIP: 0010:ip6erspan_tunnel_xmit+0x15af/0x2eb0 net/ipv6/ip6_gre.c:963
Code: 0f 47 f0 40 88 b5 7f fe ff ff e8 8c 16 4b f9 89 de bf ff ff ff ff e8 a0 12 4b f9 66 83 fb ff 0f 85 1d f1 ff ff e8 71 16 4b f9 <0f> 0b e9 43 f0 ff ff e8 65 16 4b f9 48 8d 85 30 ff ff ff ba 60 00
RSP: 0018:ffffc90005daf910 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000000ffff RCX: 0000000000000000
RDX: ffff88801f032100 RSI: ffffffff882e8d3f RDI: 0000000000000003
RBP: ffffc90005dafab8 R08: 0000000000000003 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000000 R12: ffff888024f21d40
R13: 000000000000a288 R14: 00000000000000b0 R15: ffff888025a2e000
FS: 0000000000000000(0000) GS:ffff88802c800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e425000 CR3: 000000006d099000 CR4: 0000000000152ef0
Call Trace:
<TASK>
__netdev_start_xmit include/linux/netdevice.h:4805 [inline]
netdev_start_xmit include/linux/netdevice.h:4819 [inline]
xmit_one net/core/dev.c:3588 [inline]
dev_hard_start_xmit+0x188/0x880 net/core/dev.c:3604
sch_direct_xmit+0x19f/0xbe0 net/sched/sch_generic.c:342
__dev_xmit_skb net/core/dev.c:3815 [inline]
__dev_queue_xmit+0x14a1/0x3900 net/core/dev.c:4219
dev_queue_xmit include/linux/netdevice.h:2994 [inline]
tx+0x6a/0xc0 drivers/block/aoe/aoenet.c:63
kthread+0x1e7/0x3b0 drivers/block/aoe/aoecmd.c:1229
kthread+0x2e9/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
</TASK>

Fixes: d5db21a3e697 ("erspan: auto detect truncated ipv6 packets.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: William Tu <u9012063@gmail.com>
---
 net/ipv4/ip_gre.c  | 15 ++++++++++-----
 net/ipv6/ip6_gre.c | 15 ++++++++++-----
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 3b9cd487075af20fa31ac4786a6f124ff080270e..5c58e21f724e98f4d7a450f9be2e5b25e98ecc8d 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -524,7 +524,6 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	int tunnel_hlen;
 	int version;
 	int nhoff;
-	int thoff;
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
@@ -558,10 +557,16 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
 
-	thoff = skb_transport_header(skb) - skb_mac_header(skb);
-	if (skb->protocol == htons(ETH_P_IPV6) &&
-	    (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff))
-		truncate = true;
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		int thoff;
+
+		if (skb_transport_header_was_set(skb))
+			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+		else
+			thoff = nhoff + sizeof(struct ipv6hdr);
+		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
+			truncate = true;
+	}
 
 	if (version == 1) {
 		erspan_build_header(skb, ntohl(tunnel_id_to_key32(key->tun_id)),
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 4e37f7c299004f71956a479b6933bd6526d17dde..a9051df0625dce5aa99b2be21cdbc06aaa63f61e 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -939,7 +939,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	__be16 proto;
 	__u32 mtu;
 	int nhoff;
-	int thoff;
 
 	if (!pskb_inet_may_pull(skb))
 		goto tx_err;
@@ -960,10 +959,16 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
 
-	thoff = skb_transport_header(skb) - skb_mac_header(skb);
-	if (skb->protocol == htons(ETH_P_IPV6) &&
-	    (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff))
-		truncate = true;
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		int thoff;
+
+		if (skb_transport_header_was_set(skb))
+			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+		else
+			thoff = nhoff + sizeof(struct ipv6hdr);
+		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
+			truncate = true;
+	}
 
 	if (skb_cow_head(skb, dev->needed_headroom ?: t->hlen))
 		goto tx_err;
-- 
2.36.1.476.g0c4daa206d-goog

