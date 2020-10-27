Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C230329A2B1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 03:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409556AbgJ0C3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 22:29:08 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:45045 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgJ0C3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 22:29:07 -0400
Received: by mail-pl1-f176.google.com with SMTP id h2so5673051pll.11
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 19:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9AydZF2IzRQ/33nchTL9Pk5tq1fQReDa2QIz6Q7fwrI=;
        b=o0BgQmDnXMCo8CEuHInv9HGgC/ESHETRqc+13o4k0Wj3LxaUsC56utwV1QRqFflMEC
         CvhKzUE2KbPvf/4b2/Sx3a6eApPEGqSBi4/pnK+zOCNUdCUA47yj2pUVzKyEqLRQLzF4
         KN7h1OGBwkWkc6iV4X16m7tTh0NAuUbacR6pUiu99LtI8WOBKOpe1em62enzHQHRrJfd
         IQB3Wha/F6pfp9pGx1aIjtaq+46Abn7u24udXPuIDjfKSS/2ZQ6ybHGIgORnjFdtXgMC
         BSR9OnLfOUw+BmwhIFzW0O0W4ouTvbg/45XF0e95t329atcyUnETLiJRVzggUPohgcer
         8+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9AydZF2IzRQ/33nchTL9Pk5tq1fQReDa2QIz6Q7fwrI=;
        b=blwRlxT0WwA2LZfIXHiCjK8kgIjR1ps5sKnSOjq5Df2Gzksh2huXUmb678TT2Pkqbv
         5hC80Gv0JvifuhLKjarnEIFOiacVsFt1kkqmKPQQMjCNh3yzbnAkMxkQoXQb0WvM/6KH
         3/vb8HOvAlt4uRsTebhE/N26vbAjciS/F1C76Zbv45UcUTGQJLKie/aO6llXZgtA6vyW
         LTMtnSwDTRmXMd6NDjeXciF5L//u8oD9zAn8kVvSayGPFmIbWnnkw6Kes6EUlV2w5oOf
         04CT60XsGK1uJOf6HA0xq+6Xq8v38SwETP3IBrEOScVOUwWWfaMY+D64yNJhpzbKCuEU
         gptw==
X-Gm-Message-State: AOAM530WZxLdC2oMM4RPW6B/uSluSOKoCZpRXknH9nvLfqo4Uc4opbQr
        lxznEWiFWaE1oIfzmTn4Ysc2mlOs0Y7AG070
X-Google-Smtp-Source: ABdhPJzjaE6M2cWYWKDhKTKf0e9eV25xHfchFK74JdpZar0ge+74j2YjwqtwEfEX+J1rali2F3vt1A==
X-Received: by 2002:a17:90a:7f81:: with SMTP id m1mr239149pjl.197.1603765747073;
        Mon, 26 Oct 2020 19:29:07 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o10sm5066131pgp.16.2020.10.26.19.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 19:29:06 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Georg Kohmann <geokohma@cisco.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment don't include all headers
Date:   Tue, 27 Oct 2020 10:28:33 +0800
Message-Id: <20201027022833.3697522-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027022833.3697522-1-liuhangbin@gmail.com>
References: <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201027022833.3697522-1-liuhangbin@gmail.com>
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

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v5:
Only check nexthdr if ipv6_skip_exthdr() does not return -1. For
IPPROTO_NONE/NEXTHDR_NONE, later code will handle and ignore it.

v4:
remove unused variable

v3:
a) use frag_off to check if this is a fragment packet
b) check some common protocols' header length

v2:
a) Move header check to ipv6_frag_rcv(). Also check the ipv6_skip_exthdr()
   return value
b) Fix ipv6_find_hdr() parameter type miss match in is_ineligible()

---
 net/ipv6/icmp.c       |  8 +++++++-
 net/ipv6/reassembly.c | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index ec448b71bf9a..8956144ea65e 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -158,7 +158,13 @@ static bool is_ineligible(const struct sk_buff *skb)
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
index 1f5d4d196dcc..effe1d086e5d 100644
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
+	if (offset >= 0) {
+		/* Check some common protocols' header */
+		if (nexthdr == IPPROTO_TCP)
+			offset += sizeof(struct tcphdr);
+		else if (nexthdr == IPPROTO_UDP)
+			offset += sizeof(struct udphdr);
+		else if (nexthdr == IPPROTO_ICMPV6)
+			offset += sizeof(struct icmp6hdr);
+		else
+			offset += 1;
+
+		if (frag_off == htons(IP6_MF) && offset > skb->len) {
+			__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
+					IPSTATS_MIB_INHDRERRORS);
+			icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
+			return -1;
+		}
+	}
+
 	iif = skb->dev ? skb->dev->ifindex : 0;
 	fq = fq_find(net, fhdr->identification, hdr, iif);
 	if (fq) {
-- 
2.25.4

