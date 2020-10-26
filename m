Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44215298768
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 08:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769488AbgJZH3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 03:29:53 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:33815 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769479AbgJZH3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 03:29:52 -0400
Received: by mail-pf1-f178.google.com with SMTP id o129so156274pfb.1
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 00:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l7cBOviGAP/VmxeNVblw0rGKPLdK4LzynK25GZ54GEc=;
        b=n8XkIE1ewiSSlCKhdLa1d/Slf3geZe6RwIuOUnIgVxRx1hgllJW0GWQI1BJG0Vyycn
         ljQH8iMMiZ/eubcfLzgFVXaNnM9JS6EiuZmhubBE748u3bfHgZuko1k8w5ggChBPd5x8
         +JxgWqGBzh+OZyspxukHLyB1WFUzzx4dmo9EbeUAHpXwjTCYukbxa2n35o8OzLvL17kP
         TyxFi2pzzs5e7C4CE4qS1xlKn10m7n5uN6y8af2k4LpXnsnUw2DdgHcXsVYFDi8I3gla
         K+E2lKZjHMrnsJ9g+LjPuvm4329jAsqv9hhnouKQt+IGxcYPfAUXURngNaxwrGIzUxHn
         2nqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l7cBOviGAP/VmxeNVblw0rGKPLdK4LzynK25GZ54GEc=;
        b=GNXt3XRg7GQJNq/ssew3reRh/M6cxQ9KhR/5Cp2AoN7GG9hHU1zp0AOs12wGAvoGn4
         uaDbMWv7igqOiAS5mP0hc/eIo4TiElRH1U3t5Dubi72uSsAdO834GHEeDqKriZCcEgHC
         ELRESCEBlSP0MuKMouc0D07qlJhbyRe0Tm0ovFaRTtBVZl1RrHrZR0NQAqLmf5akg6Ye
         WSq4g/y2ASV3XUHJZepu8+jl3JWeNb2UjDS2bMqzfQ/ygm0w7QgkTqGQhLzV6tTXRiLT
         w3MFVWC+wId6F+5gX95bnxDrVGk7YyNFttv1Y4XWasl9oKurnUx5v/hnXLRXONzhnpms
         kVUg==
X-Gm-Message-State: AOAM531HZUvlICVai930ppM9fvEQXUlprHDA8bc1YYo7akG8OnKYeBJ7
        erUwLdEmS8RsemcaTw+8AWI5l97lwy+8Ic+y
X-Google-Smtp-Source: ABdhPJzVeGBBwkypbep9TD01l7BIuJpJSl80i9/pN3UBqB4+TXxqQm2yz3O7R3jRuoLGQKZANXWsBA==
X-Received: by 2002:a63:2406:: with SMTP id k6mr12323183pgk.366.1603697391761;
        Mon, 26 Oct 2020 00:29:51 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v24sm9766547pgi.91.2020.10.26.00.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 00:29:51 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 net 2/2] IPv6: reply ICMP error if the first fragment don't include all headers
Date:   Mon, 26 Oct 2020 15:29:26 +0800
Message-Id: <20201026072926.3663480-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201026072926.3663480-1-liuhangbin@gmail.com>
References: <20201023064347.206431-1-liuhangbin@gmail.com>
 <20201026072926.3663480-1-liuhangbin@gmail.com>
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

