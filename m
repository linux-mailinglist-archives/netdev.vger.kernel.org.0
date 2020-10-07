Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CE628576E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 05:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgJGDzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 23:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGDzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 23:55:37 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B9FC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 20:55:37 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id g10so563364pfc.8
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 20:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=89p52txoW1oSargTnktdznI9WU0QDYleW+J6gra6b/U=;
        b=V1riVKcU4vcFZq0xN/Mbu1a6Upbte8/v1kLJnjz89zwUzv3pjtoEx792LWocKxAglw
         QpbF4iw1IwELxP52xv0X7L/DQqOB2eyi50dvjZxd7J4tsv4TvHi9HOR+q8z1NOTQWLBz
         fCUcXsC3dwbwEfB61jI7Ax9wKDsMsprA+QlfVTFShyrXmTe4NO8D5ltZ4ov98M+Vwlil
         sy5I8o/NBVQTMRZ9uaZJ7Ifj2dR43xx24QpvL4k89WkZAOh4JKWE10v1VEMp53TDRSNo
         JPSyFp74/46zt7dtRjwK3DWHO79Hz7M2AwL5TxnJMrdQ7Lq5o/JAGZ4M3PeIb1Y/u22P
         pWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89p52txoW1oSargTnktdznI9WU0QDYleW+J6gra6b/U=;
        b=QCAUd/uram7XUajKa1V41tfKbwV0CayeQua4aqtrxYlhM7doIIa7tYDGkgGsajvIgD
         +MOI1wqj3R7vmliQiMwph7xZx0Qz59Q91a8y+ALSIgj0DPUWXiC8eh4rtyBOEXHnElne
         9rEAz+x5ozWInVZXRVBeHsqcYVj8O2RMKfXNQkaF7C4x/Eh9HcvUsZxoTNbvgsTqGnHD
         jpFWjQvEfAcS+ijO2TZiWvcsvUdhX1hGll9L4YzhwFy4VEU/umazyI0rk2Ch4pT/7SZk
         USdEYXfABsuBrPXR50o9T4/eCm04C/jOMJFIvSeJgUjepngxAwt1Vze7oLYiJsIQJqE4
         knbA==
X-Gm-Message-State: AOAM532y3i2XE5GJYnS1IFKhVUv8M+bj2GUSxWH37yG2zvof1qOJsvzO
        bPPLgmbBaCsEHAc5iNBFeOOPVGp3K59n/w==
X-Google-Smtp-Source: ABdhPJxbFR4OaGHJG8vNLBHzduygWLyEXZ1UaH/ityar5HytZQwM9UXNvdkhXha9baFVfOjPrir8ng==
X-Received: by 2002:a63:e61:: with SMTP id 33mr1214763pgo.394.1602042937004;
        Tue, 06 Oct 2020 20:55:37 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d12sm748246pgd.93.2020.10.06.20.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 20:55:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/2] IPv6: reply ICMP error if the first fragment don't include all headers
Date:   Wed,  7 Oct 2020 11:55:02 +0800
Message-Id: <20201007035502.3928521-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201007035502.3928521-1-liuhangbin@gmail.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
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

As the packet may be any kind of L4 protocol, I only checked if there
has Upper-Layer header by pskb_may_pull(skb, offset + 1).

As the 1st truncated fragment may also be ICMP message, I also add
a check in ICMP code is_ineligible() to let fragment packet with nexthdr
ICMP but no ICMP header return false.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/icmp.c      | 13 ++++++++++++-
 net/ipv6/ip6_input.c | 20 +++++++++++++++++++-
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a4e4912ad607..03060c8f463d 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -145,7 +145,9 @@ static bool is_ineligible(const struct sk_buff *skb)
 	int ptr = (u8 *)(ipv6_hdr(skb) + 1) - skb->data;
 	int len = skb->len - ptr;
 	__u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+	unsigned int offs = 0;
 	__be16 frag_off;
+	bool is_frag;
 
 	if (len < 0)
 		return true;
@@ -153,12 +155,21 @@ static bool is_ineligible(const struct sk_buff *skb)
 	ptr = ipv6_skip_exthdr(skb, ptr, &nexthdr, &frag_off);
 	if (ptr < 0)
 		return false;
+
+	is_frag = (ipv6_find_hdr(skb, &offs, NEXTHDR_FRAGMENT, &frag_off, NULL) == NEXTHDR_FRAGMENT);
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
+		if (!tp && is_frag)
+			return false;
+		else if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
 			return true;
 	}
 	return false;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e96304d8a4a7..637d8d59e058 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -146,8 +146,11 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 				    struct net *net)
 {
 	const struct ipv6hdr *hdr;
-	u32 pkt_len;
 	struct inet6_dev *idev;
+	__be16 frag_off;
+	u32 pkt_len;
+	int offset;
+	u8 nexthdr;
 
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		kfree_skb(skb);
@@ -282,6 +285,21 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 		}
 	}
 
+	/* RFC 8200, Section 4.5 Fragment Header:
+	 * If the first fragment does not include all headers through an
+	 * Upper-Layer header, then that fragment should be discarded and
+	 * an ICMP Parameter Problem, Code 3, message should be sent to
+	 * the source of the fragment, with the Pointer field set to zero.
+	 */
+	nexthdr = hdr->nexthdr;
+	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
+	if (frag_off == htons(IP6_MF) && !pskb_may_pull(skb, offset + 1)) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
+		rcu_read_unlock();
+		return NULL;
+	}
+
 	rcu_read_unlock();
 
 	/* Must drop socket now because of tproxy. */
-- 
2.25.4

