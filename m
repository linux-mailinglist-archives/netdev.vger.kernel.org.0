Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D540729AC2B
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751305AbgJ0Mdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:33:42 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:45420 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409439AbgJ0Mdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:33:42 -0400
Received: by mail-pl1-f181.google.com with SMTP id v22so666154ply.12
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 05:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bFEjBfyvj8SMVTCu9Bj3WXHrUwR1qUn3C1u+lijdykc=;
        b=F3QRebhe/CFaaw2cMIhi93EWXszJtQky414Z/Y8MkVCzqN3eK6vewSjCXf8s+a1htL
         ZUMi2cR/qD3sWHuHIfR8zOdz1cqdbHTOINrszonOvLULC7Zt2HK5/E+sBxNLlaLo9ZUJ
         SiOOzJyOKTrcgNnZ+j/X80I1jQ9EowSh9SmnS5NSd5M8765ACBEdpJN788SVXz0UDdbh
         7IyhENsvCTTsYymsQQzWPg4d7/EUrQ2VwmUSAurBgWjq9SHle0UtGXAd1QzFgSwMzLMq
         +XtmBBT06hoHpNi4DgauAv2T0W5Mwqu6P4SBDzUILPIMBiwSIeseLdyh9VFSSkAHvmA/
         gPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bFEjBfyvj8SMVTCu9Bj3WXHrUwR1qUn3C1u+lijdykc=;
        b=Qcv8S+rX9AFm/rEPilbf/3ty7cmN5hGB30YgA9JoX6tJYRr42EY20d8d/aHEPfOEdi
         2CSfxmsGuVxj+BDkCS99OBF+FosHtzguaCVtnBSAz1ZjLNlp9z3XSaO5OA+se+E+cbgD
         wz6xvlH6sJ6HDTY1qpM+WT6wQJb5lmkhtpq33llYHIV3fFHpi4S12Z0HzvrF3uDH+NHZ
         5ZtCoazDKNj8uZWtxXG6KNhMGXICHGsvOpQ85aaDLr8oozETaqh2/uTTs4cEnJ8+CNVu
         1swbGd9Xzs6gRzkK4nQztxDBvAxWI8jrcxg7mWqHcSeV9D6xbqOsyotqkUijZfoHQrrN
         FARQ==
X-Gm-Message-State: AOAM533OpSVgay/dbPECuO+ZU120pCsC8fg07kOk8luBt+anY6yUCz0o
        ZiXnREpMjDCVeGmDXldnK1WR1rGak3RxPVw0
X-Google-Smtp-Source: ABdhPJwCetVQVTMyR5ULoQQuQwCSubxdgUQ8nVtViSJVS01bCRcRlack3wJTiERtBJDKbvZEdYUnaA==
X-Received: by 2002:a17:90a:4549:: with SMTP id r9mr1928089pjm.146.1603802021448;
        Tue, 27 Oct 2020 05:33:41 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q189sm2251231pfc.94.2020.10.27.05.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:33:40 -0700 (PDT)
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
Subject: [PATCHv6 net 2/2] IPv6: reply ICMP error if the first fragment don't include all headers
Date:   Tue, 27 Oct 2020 20:33:13 +0800
Message-Id: <20201027123313.3717941-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027123313.3717941-1-liuhangbin@gmail.com>
References: <20201027022833.3697522-1-liuhangbin@gmail.com>
 <20201027123313.3717941-1-liuhangbin@gmail.com>
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

Checking each packet header in IPv6 fast path will have performance impact,
so I put the checking in ipv6_frag_rcv().

As the packet may be any kind of L4 protocol, I only checked some common
protocols' header length and handle others by (offset + 1) > skb->len.
Also use !(frag_off & htons(IP6_OFFSET)) to catch atomic fragments
(fragmented packet with only one fragment).

When send ICMP error message, if the 1st truncated fragment is ICMP message,
icmp6_send() will break as is_ineligible() return true. So I added a check
in is_ineligible() to let fragment packet with nexthdr ICMP but no ICMP header
return false.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v6:
Use !(frag_off & htons(IP6_OFFSET)) to catch atomic fragments

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
index 1f5d4d196dcc..c8cf1bbad74a 100644
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
+		if (!(frag_off & htons(IP6_OFFSET)) && offset > skb->len) {
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

