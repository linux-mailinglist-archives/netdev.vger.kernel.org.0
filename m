Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D19C6AB17
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 16:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbfGPOy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 10:54:26 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38285 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfGPOy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 10:54:26 -0400
Received: by mail-qk1-f194.google.com with SMTP id a27so14804358qkk.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 07:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=efDi+xP5INucJ72Ory5WSWKAWY28AH8aBSxZ1vzGwHc=;
        b=p755n/nX6bwjJSrkylNF7fxrv7W5hZtw60PSVXeEzFLHxFrCisrMxGiEhVcH3gcTw7
         D9Wp5C6bJCEpR7BikI2qJRDyevOQhEHxMYcUc3K6+L0cQC2ItC8kd3Hvv3Hq+ljT5XZZ
         fcRqbPLBZTW1fBCWoT+tsoJ/oggL/hODGz194O1f/5Ww/DwSflLKIjPOA35by1UsTLEL
         CHPlkXAlPZMhJ47v4xCBp60T6JMkX4wZGEvHJ0OmoXlh9NPOjOzDx3DAHTA3Kps4z+P9
         MohtuefQXjnTNkyJ+5vqfMh9+EMzA6tzPpek1Y3IEk2rfTDB5GVHRN6FcLm/vnc87Um7
         V7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=efDi+xP5INucJ72Ory5WSWKAWY28AH8aBSxZ1vzGwHc=;
        b=RTuy0D4vZjZRxKyYmBySZw06iM9IRg9GpQjbkLEcTHCabJ//7VC9cT+E7b7cBbltb2
         48erCeBmMdcv8AIqIh4bTjFjwoYK34BmBR7fzJJxKKAPG9qCFn5YXdwGVN15KQ2P34gJ
         X6ISdbqCjVNVnXMJ6pJgG+xSLRKbscVT7cimMmOKvGHn7EFv52XpuRvXRakFvcnAP8vQ
         cAl3EPL4Wg9EJGNTBS3yxdWAHzOo3ahWpGCjIpKNfuYBg1mOfRkSgR5KnbVyfmDFgZfp
         WZ0E4RD9vadB/q49if+nKgmZBcMI+q3anSM1ixHABKs6kq6tYC7HIq7B2W8lyX/cN/DY
         pfYg==
X-Gm-Message-State: APjAAAXCKRFbAPfb4Quiyvrr55Uk0bXKGonpEKt3nJkh+/vJS6PYv8rS
        3XcS588AAjs1xUPIpBPTsH2u6g==
X-Google-Smtp-Source: APXvYqxZ2/YvnzkZrvDp1LDwL2lt/6YOXxw8yEnn6sCMwbhbfEHB6Z4LVFHdxZwD2Fb46MvBFSpUBg==
X-Received: by 2002:a37:dc42:: with SMTP id v63mr8083647qki.488.1563288864804;
        Tue, 16 Jul 2019 07:54:24 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p13sm8008218qkj.4.2019.07.16.07.54.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 07:54:24 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     willemb@google.com, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH] skbuff: fix compilation warnings in skb_dump()
Date:   Tue, 16 Jul 2019 10:54:00 -0400
Message-Id: <1563288840-1913-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 6413139dfc64 ("skbuff: increase verbosity when dumping skb
data") introduced a few compilation warnings.

net/core/skbuff.c:766:32: warning: format specifies type 'unsigned
short' but the argument has type 'unsigned int' [-Wformat]
                       level, sk->sk_family, sk->sk_type,
sk->sk_protocol);
                                             ^~~~~~~~~~~
net/core/skbuff.c:766:45: warning: format specifies type 'unsigned
short' but the argument has type 'unsigned int' [-Wformat]
                       level, sk->sk_family, sk->sk_type,
sk->sk_protocol);
^~~~~~~~~~~~~~~

Fix them by using the proper types, and also fix some checkpatch
warnings by using pr_info().

WARNING: printk() should include KERN_<LEVEL> facility level
+		printk("%ssk family=%hu type=%u proto=%u\n",

Fixes: 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 net/core/skbuff.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6f1e31f674a3..fa1e78f7bb96 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -740,30 +740,30 @@ void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
 	has_mac = skb_mac_header_was_set(skb);
 	has_trans = skb_transport_header_was_set(skb);
 
-	printk("%sskb len=%u headroom=%u headlen=%u tailroom=%u\n"
-	       "mac=(%d,%d) net=(%d,%d) trans=%d\n"
-	       "shinfo(txflags=%u nr_frags=%u gso(size=%hu type=%u segs=%hu))\n"
-	       "csum(0x%x ip_summed=%u complete_sw=%u valid=%u level=%u)\n"
-	       "hash(0x%x sw=%u l4=%u) proto=0x%04x pkttype=%u iif=%d\n",
-	       level, skb->len, headroom, skb_headlen(skb), tailroom,
-	       has_mac ? skb->mac_header : -1,
-	       has_mac ? skb_mac_header_len(skb) : -1,
-	       skb->network_header,
-	       has_trans ? skb_network_header_len(skb) : -1,
-	       has_trans ? skb->transport_header : -1,
-	       sh->tx_flags, sh->nr_frags,
-	       sh->gso_size, sh->gso_type, sh->gso_segs,
-	       skb->csum, skb->ip_summed, skb->csum_complete_sw,
-	       skb->csum_valid, skb->csum_level,
-	       skb->hash, skb->sw_hash, skb->l4_hash,
-	       ntohs(skb->protocol), skb->pkt_type, skb->skb_iif);
+	pr_info("%sskb len=%u headroom=%u headlen=%u tailroom=%u\n"
+		"mac=(%d,%d) net=(%d,%d) trans=%d\n"
+		"shinfo(txflags=%u nr_frags=%u gso(size=%hu type=%u segs=%hu))\n"
+		"csum(0x%x ip_summed=%u complete_sw=%u valid=%u level=%u)\n"
+		"hash(0x%x sw=%u l4=%u) proto=0x%04x pkttype=%u iif=%d\n",
+		level, skb->len, headroom, skb_headlen(skb), tailroom,
+		has_mac ? skb->mac_header : -1,
+		has_mac ? skb_mac_header_len(skb) : -1,
+		skb->network_header,
+		has_trans ? skb_network_header_len(skb) : -1,
+		has_trans ? skb->transport_header : -1,
+		sh->tx_flags, sh->nr_frags,
+		sh->gso_size, sh->gso_type, sh->gso_segs,
+		skb->csum, skb->ip_summed, skb->csum_complete_sw,
+		skb->csum_valid, skb->csum_level,
+		skb->hash, skb->sw_hash, skb->l4_hash,
+		ntohs(skb->protocol), skb->pkt_type, skb->skb_iif);
 
 	if (dev)
-		printk("%sdev name=%s feat=0x%pNF\n",
-		       level, dev->name, &dev->features);
+		pr_info("%sdev name=%s feat=0x%pNF\n",
+			level, dev->name, &dev->features);
 	if (sk)
-		printk("%ssk family=%hu type=%hu proto=%hu\n",
-		       level, sk->sk_family, sk->sk_type, sk->sk_protocol);
+		pr_info("%ssk family=%hu type=%u proto=%u\n",
+			level, sk->sk_family, sk->sk_type, sk->sk_protocol);
 
 	if (full_pkt && headroom)
 		print_hex_dump(level, "skb headroom: ", DUMP_PREFIX_OFFSET,
@@ -801,7 +801,7 @@ void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
 	}
 
 	if (full_pkt && skb_has_frag_list(skb)) {
-		printk("skb fraglist:\n");
+		pr_info("skb fraglist:\n");
 		skb_walk_frags(skb, list_skb)
 			skb_dump(level, list_skb, true);
 	}
-- 
1.8.3.1

