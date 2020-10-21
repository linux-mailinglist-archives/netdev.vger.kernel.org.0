Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA39294738
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440144AbgJUEU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411910AbgJUEUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 00:20:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFA8C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 21:20:25 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b19so562054pld.0
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 21:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pZJRlKVL71IM7YseITMTi9x+YYS8JbHfUP8NgxHZ9Gw=;
        b=MOeVPzwiIZ1IHlBPRJZSFBPRzFJ3c4DnZsYo70QZpVoFoTvmX1XGoKsJnSGIiMVsmw
         pTL8W735irwWtJepxEua0VODRh5YtAhz4A2qU/ki706hfMnWFEQi9HSVs1ZERi1ahUlE
         /ozxJdtgIvCeKl5XRzFmyYV1aDPpdXBDGj0awSI1FW2Oxd/SrleONef5LsmTlQJa/My3
         3oTvdEu0IkDMK7zTFnZs9MPiS8sJgi71FaxKMQD3gHA/x1Kao+qNFEf9I/kBPvB+CRSm
         s7DlOfh0xWqJbanX0skNpMvQzlXj058q6LItwGHsmoeGvaXqMQnNU0TAQyqc1MyPKXFQ
         eegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pZJRlKVL71IM7YseITMTi9x+YYS8JbHfUP8NgxHZ9Gw=;
        b=VIrTIfaOlNJBszRcfDDQSE272xeqrzVfba/QVFZ+gqb9hkBjQClSYv+PGtzJQcGfIh
         dvssEo8Y7D2TnJpP7WBq9KkWZlqoZZ6M3DAiOK2YY3C6tba8SsDW5htkLWjPfw91Ey7U
         L2ZBQxRXxr+qm+oNUTbmXYwRuQHuMHU9TCoj5fd3s/dTPaoOfdaB5DGGM82YMiZCYH65
         2uBglL3HrGF+Bc5igK9TQ2Tr/RF2tQrsskjFegJfuLjVaiP55EmX3UMP6IFLOGUOXi9G
         bN6LqnNJyNewmtuXDcLP7o3q2al7voBTnKtPv02SBX0K/9ZYEmyk37OXyF2AvvUQ0F7p
         4Zkg==
X-Gm-Message-State: AOAM530csWvpDW0kRH9fbywJN8QeTqli8F4LtcBOEWWjZ5Y7FRhfXXML
        lKEYTLvmW0AQCxB5JMZvmGlwXWn7HZMUCd5H
X-Google-Smtp-Source: ABdhPJykxcMoLpKsvCr0jxB6qldzgKxao1W5IMVRKIrvpSARbXZQP2MuKrpE4LiUubPvLBY+mWbFaA==
X-Received: by 2002:a17:902:7b90:b029:d4:d9e5:e5bf with SMTP id w16-20020a1709027b90b02900d4d9e5e5bfmr1222155pll.83.1603254024410;
        Tue, 20 Oct 2020 21:20:24 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e21sm545796pfl.22.2020.10.20.21.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 21:20:23 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 2/2] IPv6: reply ICMP error if the first fragment don't include all headers
Date:   Wed, 21 Oct 2020 12:20:05 +0800
Message-Id: <20201021042005.736568-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201021042005.736568-1-liuhangbin@gmail.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201021042005.736568-1-liuhangbin@gmail.com>
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
has Upper-Layer header by (offset + 1) > skb->len. Checking each packet
header in IPv6 fast path will have performace impact, so I put the
checking in ipv6_frag_rcv().

When send ICMP error message, if the first truncated fragment is ICMP
message, icmp6_send() will break as is_ineligible() return true. So I
added a check in is_ineligible() to let fragment packet with nexthdr
ICMP but no ICMP header return false.

v2:
a) Move header check to ipv6_frag_rcv(). Also check the ipv6_skip_exthdr()
   return value
b) Fix ipv6_find_hdr() parameter type miss match in is_ineligible()

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/icmp.c       | 13 ++++++++++++-
 net/ipv6/reassembly.c | 18 +++++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index ec448b71bf9a..50d28764c8dd 100644
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
+	is_frag = (ipv6_find_hdr(skb, &offs, NEXTHDR_FRAGMENT, NULL, NULL) == NEXTHDR_FRAGMENT);
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
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1f5d4d196dcc..b359bffa2f58 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -322,7 +322,9 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	struct frag_queue *fq;
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
-	int iif;
+	__be16 frag_off;
+	int iif, offset;
+	u8 nexthdr;
 
 	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
 		goto fail_hdr;
@@ -351,6 +353,20 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
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
+	if (offset >= 0 && frag_off == htons(IP6_MF) && (offset + 1) > skb->len) {
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

