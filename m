Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C501E149F
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 21:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389991AbgEYTHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 15:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389437AbgEYTHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 15:07:45 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D2AC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 12:07:45 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id n11so12832875qkn.8
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 12:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TwosTNtiS7RZsI1TZNvPZOmslzUFSqUMOJz3SseXn2o=;
        b=Fj1GcZv4JvAgl0DuTs+qMDn47zXweXlCZLiDT3Omze40Wh64mIzEikhzpgLn57fxQ3
         I95dvNyZSwkqIY1c237to0eG8GJotgQVukbhEPmb0zAuABE5jxfFwqtyNRUt0jg0/2Um
         rtSM+KIRBw9Q4X7ZYzu/FEu9LZPWGdca8eaBFxGAM/4JmbB8lGoQ9xQvfn53WLjYENFs
         rcrm6JcCz0IOiY+BD/8rrowAQgiYxX0GMVtP6JT2nbZJtZ2tt0oZ7VvL0SupLnsA/74h
         7fQgWWpYpfuY+ZijzrBO4t+wQeT3IkJGZagH1JF/nmaI9H0VIdo+2fAmFOUgPKJrM4UH
         XoGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TwosTNtiS7RZsI1TZNvPZOmslzUFSqUMOJz3SseXn2o=;
        b=kSW0hpVw73a9/Ngw92FffG0F+lzuPdgpab+PCL08UfFP3A581ziL9x31zPu3v07DnM
         b45AY1inrLCYmgYyvyMpLdqJZ4B+BZ+jbzCAvxks9zG8c2zjSuo6fUonrqmxZDRamIiI
         1GdgnJNSsDuHME/5U9pKurpm1U3hRybv3QhSQ1UGBarX8M5jMKJPRUM9YayI/68HrbBL
         pT6DtSh83t7azEh3F/6Gnl79AtPVflHXRH24lV1gPbRdDw/ScPs0DCfuvXT5E6Ph+XQn
         SUdsK7F4y6tcGdOOArMA+F4BIQgeRPJTKL93CMQfdn6qggEpFkXficOCKAYrbK+PEZgE
         7+Zw==
X-Gm-Message-State: AOAM530xqf4AHgDJtQFbwev6b6PK7cch51ldMXE+vm/1oxjxYUZcEzlq
        6KK1luoxrD6g9ShX8++6WuNYoWdH
X-Google-Smtp-Source: ABdhPJzYEIZl3P30PKJAzQwplM7oxBhRYMiRdKpToksp3KRjvH8A39BJdkyM6KD1/HkI6qMYiXg8Og==
X-Received: by 2002:a37:a09:: with SMTP id 9mr14455606qkk.84.1590433664126;
        Mon, 25 May 2020 12:07:44 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id n206sm15054361qke.20.2020.05.25.12.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 12:07:43 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: check untrusted gso_size at kernel entry
Date:   Mon, 25 May 2020 15:07:40 -0400
Message-Id: <20200525190740.82224-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Syzkaller again found a path to a kernel crash through bad gso input:
a packet with gso size exceeding len.

These packets are dropped in tcp_gso_segment and udp[46]_ufo_fragment.
But they may affect gso size calculations earlier in the path.

Now that we have thlen as of commit 9274124f023b ("net: stricter
validation of untrusted gso packets"), check gso_size at entry too.

Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/virtio_net.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 6f6ade63b04c..88997022a4b5 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -31,6 +31,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 {
 	unsigned int gso_type = 0;
 	unsigned int thlen = 0;
+	unsigned int p_off = 0;
 	unsigned int ip_proto;
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
@@ -68,7 +69,8 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
 
-		if (skb_transport_offset(skb) + thlen > skb_headlen(skb))
+		p_off = skb_transport_offset(skb) + thlen;
+		if (p_off > skb_headlen(skb))
 			return -EINVAL;
 	} else {
 		/* gso packets without NEEDS_CSUM do not set transport_offset.
@@ -92,17 +94,25 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 				return -EINVAL;
 			}
 
-			if (keys.control.thoff + thlen > skb_headlen(skb) ||
+			p_off = keys.control.thoff + thlen;
+			if (p_off > skb_headlen(skb) ||
 			    keys.basic.ip_proto != ip_proto)
 				return -EINVAL;
 
 			skb_set_transport_header(skb, keys.control.thoff);
+		} else if (gso_type) {
+			p_off = thlen;
+			if (p_off > skb_headlen(skb))
+				return -EINVAL;
 		}
 	}
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
 
+		if (skb->len - p_off <= gso_size)
+			return -EINVAL;
+
 		skb_shinfo(skb)->gso_size = gso_size;
 		skb_shinfo(skb)->gso_type = gso_type;
 
-- 
2.27.0.rc0.183.gde8f92d652-goog

