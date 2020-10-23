Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFD22969DD
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 08:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375360AbgJWGoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 02:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgJWGoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 02:44:08 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5B6C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 23:44:08 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c20so384684pfr.8
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 23:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g6Ujv3OlUtg3fmKKB1eL4GyZ7IB8K9srfu5bDeffZvg=;
        b=DphuBfSKwsr6gP7oqHiNiUoOYQRSOrNtDRl5FipqCjrc6XkgIbNpz4t1hRz+0lq6Th
         /iAWJnXxnFOxcnW5P2o1DSQ9LLUFfdjOdjj1GJ6XLtW0ov8UovFXmkp9D3XUbPw9OtUn
         8u4XZP0PjwWcKQJynjdpPPjVT/oTpiCkTztEnu4+r0caB3sQgQWpJUt46D8YPvObe7pt
         18JTIbcSQTRkmvdWY8CzzejPtYTTP7m6n+00iTQBpUjJud5O40m0IBXYVagZvlIzg8BT
         /BWCrahHpEbN/zF2xbXEhtqEQ75RxOm0G7hWPiU7XpGbeP+L6oh3Orv7/RsKQc4X55sd
         /DBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g6Ujv3OlUtg3fmKKB1eL4GyZ7IB8K9srfu5bDeffZvg=;
        b=rpYivtRYsnv2hu+Rl5qwEk6xxq1cNKJtEX42tOeFm4Y45oDxw9YGaMFiUn/kawJWo3
         X9GYplqHVnLDUH1zAOQ0CqzYRxEu3HuJ5Daqmv+DrA7AKgNF7LjD7K0SI3HkhxNmHARi
         sNIzLXkbROJExqzjhCGkGN49aqr/PIC5LFetl+ORsCoQvXacUJ9O+iT79ciKcyj463+r
         n7mvaRUmFYjWnQhwljH85eCzX7ub4F7XIiiRF7PjeZJ+foDjz4tprI4uwmH2mW3XFk+k
         JoNc3r9dE/Z8DFUjwbLI3Z/u/CMBunQd9nRWjXKWzRWrtN+M5MrtQsKOXM7X6li9Oiy0
         Ogdg==
X-Gm-Message-State: AOAM5308PO1qazguZ+rti6lhVBjj98u1+yIBCikfrA7uLR7QKFJ7gpLH
        ZlQ6dGjTgn0ituXnZL2ZAvKc4I/M0Nr/B2RW
X-Google-Smtp-Source: ABdhPJy1A8ew/bNfdNDf70HKVkXuKH/Geh1aZTg2nqGWk9N/cV91DIR9eAm2ugggSw86LXeb8JT+QA==
X-Received: by 2002:a65:5c4c:: with SMTP id v12mr948505pgr.119.1603435448191;
        Thu, 22 Oct 2020 23:44:08 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s23sm716088pgl.47.2020.10.22.23.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 23:44:07 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 2/2] IPv6: reply ICMP error if the first fragment doesn't include all headers
Date:   Fri, 23 Oct 2020 14:43:47 +0800
Message-Id: <20201023064347.206431-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201023064347.206431-1-liuhangbin@gmail.com>
References: <20201021042005.736568-1-liuhangbin@gmail.com>
 <20201023064347.206431-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on RFC 8200, Section 4.5 Fragment Header:

  -  If the first fragment does not include all headers through an
     Upper-Layer header, then that fragment should be discarded and
     an ICMP Parameter Problem, Code 3, message should be sent to
     the source of the fragment, with the Pointer field set to zero.

As the packet may be any kind of L4 protocol, I only checked some common
protocols' header length and handle others by (offset + 1) > skb->len.
Checking each packet header in IPv6 fast path will have performance impact,
so I put the checking in ipv6_frag_rcv().

When send ICMP error message, if the 1st truncated fragment is ICMP message,
icmp6_send() will break as is_ineligible() return true. So I added a check
in is_ineligible() to let fragment packet with nexthdr ICMP but no ICMP header
return false.

v3:
a) use frag_off to check if this is a fragment packet
b) check some common protocols' header length

v2:
a) Move header check to ipv6_frag_rcv(). Also check the ipv6_skip_exthdr()
   return value
b) Fix ipv6_find_hdr() parameter type miss match in is_ineligible()

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/icmp.c       | 10 +++++++++-
 net/ipv6/reassembly.c | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index ec448b71bf9a..0bda77d7e6b8 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -145,6 +145,7 @@ static bool is_ineligible(const struct sk_buff *skb)
 	int ptr = (u8 *)(ipv6_hdr(skb) + 1) - skb->data;
 	int len = skb->len - ptr;
 	__u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+	unsigned int offs = 0;
 	__be16 frag_off;
 
 	if (len < 0)
@@ -153,12 +154,19 @@ static bool is_ineligible(const struct sk_buff *skb)
 	ptr = ipv6_skip_exthdr(skb, ptr, &nexthdr, &frag_off);
 	if (ptr < 0)
 		return false;
+
 	if (nexthdr == IPPROTO_ICMPV6) {
 		u8 _type, *tp;
 		tp = skb_header_pointer(skb,
 			ptr+offsetof(struct icmp6hdr, icmp6_type),
 			sizeof(_type), &_type);
-		if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
+
+		/* Based on RFC 8200, Section 4.5 Fragment Header, return
+		 * false if this is a fragment packet with no icmp header info.
+		 */
+		if (!tp && frag_off != 0)
+			return false;
+		else if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
 			return true;
 	}
 	return false;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1f5d4d196dcc..bf042bcb5a47 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -42,6 +42,8 @@
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 
 #include <net/sock.h>
 #include <net/snmp.h>
@@ -322,7 +324,9 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	struct frag_queue *fq;
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
-	int iif;
+	__be16 frag_off;
+	int iif, offset;
+	u8 nexthdr;
 
 	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
 		goto fail_hdr;
@@ -351,6 +355,33 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 		return 1;
 	}
 
+	/* RFC 8200, Section 4.5 Fragment Header:
+	 * If the first fragment does not include all headers through an
+	 * Upper-Layer header, then that fragment should be discarded and
+	 * an ICMP Parameter Problem, Code 3, message should be sent to
+	 * the source of the fragment, with the Pointer field set to zero.
+	 */
+	nexthdr = hdr->nexthdr;
+	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
+	if (offset < 0)
+		goto fail_hdr;
+
+	/* Check some common protocols' header */
+	if (nexthdr == IPPROTO_TCP)
+		offset += sizeof(struct tcphdr);
+	else if (nexthdr == IPPROTO_UDP)
+		offset += sizeof(struct udphdr);
+	else if (nexthdr == IPPROTO_ICMPV6)
+		offset += sizeof(struct icmp6hdr);
+	else
+		offset += 1;
+
+	if (frag_off == htons(IP6_MF) && offset > skb->len) {
+		__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev), IPSTATS_MIB_INHDRERRORS);
+		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
+		return -1;
+	}
+
 	iif = skb->dev ? skb->dev->ifindex : 0;
 	fq = fq_find(net, fhdr->identification, hdr, iif);
 	if (fq) {
-- 
2.25.4

