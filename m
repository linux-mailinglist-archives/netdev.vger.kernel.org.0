Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7308614D1D3
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 21:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgA2UUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 15:20:22 -0500
Received: from mail-qv1-f41.google.com ([209.85.219.41]:41400 "EHLO
        mail-qv1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgA2UUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 15:20:22 -0500
Received: by mail-qv1-f41.google.com with SMTP id s7so331396qvn.8
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 12:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjX86EZp0AORR/ZOXYa37fTT0LeUgPCxGPyjLIC2jgk=;
        b=TD8pvDrncYwIe8KhJErFwypYTw5zs0uaoIianyZJt/Zd5fIMs/pCVlN14O/59xCFXu
         SfjYtnFw+w5ixD3hkXNjTVpq4x4E1jNQND2rxJ0PwXr5KHWYMI7OXKaREEs9vOeLzlcp
         22QQ68DXRvdDd5o1nl7SOQBQI9oZ3B6nHxVq+ws09llqXYC0UJK3pAjK6CeYClMEn8sH
         /Jdz2cph6rXb4oTKMtLrs6n3ZwDnumxFkzIlqctKZnK/yunGF+raJuoK7FFORB0ma9IS
         f2u46RWS5s7YY9tgB/gwvhZAROKkTFt4eBoH3nvUc1J3ZBp8WYYqZMUggO9jKLkrwaAm
         DvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjX86EZp0AORR/ZOXYa37fTT0LeUgPCxGPyjLIC2jgk=;
        b=Soetcq01SxM9lJV+aa5cAVybKhNPVP6NWjdposgAWrpzwYslMNXaEOsL3ptm3JlB0i
         i0LKIDQR6giqPH1908CA4HD4JYNiE+RnsHV3T+pJTdxdEkV49hvGARc4nzvcJv66AwS/
         2Xel89RUr2P0HbksIeYrTibuRLRZRzav6d/Jld3MoD3k2Oa0dVGVhVpDVRIbaFJ7nkfl
         UiWg52e/sWA2gqZRIZkb8Xa6ZE/N8JzAGWc8IKSUrbqGfPPD1tP/t3quSZpd2EK2N/CU
         Du52GObWtiW2Qn+XCTZyW2gqtEL+mvF4FoHx5DkRjF1En0sPbZeLt8NgrdbxT1qKpGwq
         f+dA==
X-Gm-Message-State: APjAAAWYkN19vH/3DMDEh6csc61okHX+tvIbU6Z+DJmA9W29/tb07CAC
        ackpgd+QYtiJFIL1qZCW7fadUkiR
X-Google-Smtp-Source: APXvYqzQKFZ8SXcM+OylI8t9VrnSf5tlqNO32ts1C8DwpzvgVDNAin6KjQPZEhGs6IGJTWGLHY79ig==
X-Received: by 2002:a05:6214:166:: with SMTP id y6mr929655qvs.120.1580329220535;
        Wed, 29 Jan 2020 12:20:20 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:6084:feee:4efa:5ea9])
        by smtp.gmail.com with ESMTPSA id 21sm1540854qky.41.2020.01.29.12.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 12:20:19 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] udp: document udp_rcv_segment special case for looped packets
Date:   Wed, 29 Jan 2020 15:20:17 -0500
Message-Id: <20200129202017.67765-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Commit 6cd021a58c18a ("udp: segment looped gso packets correctly")
fixes an issue with rare udp gso multicast packets looped onto the
receive path.

The stable backport makes the narrowest change to target only these
packets, when needed. As opposed to, say, expanding __udp_gso_segment,
which is harder to reason to be free from unintended side-effects.

But the resulting code is hardly self-describing.
Document its purpose and rationale.

Signed-off-by: Willem de Bruijn <willemb@google.com>

---

Let me know if you'd prefer net-next.
---
 include/net/udp.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index 4a180f2a13e32..e55d5f7658075 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -476,6 +476,13 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	if (!inet_get_convert_csum(sk))
 		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 
+	/* UDP segmentation expects packets of type CHECKSUM_PARTIAL or
+	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
+	 * packets in udp_gro_complete_segment. As does UDP GSO, verified by
+	 * udp_send_skb. But when those packets are looped in dev_loopback_xmit
+	 * their ip_summed is set to CHECKSUM_UNNECESSARY. Reset in this
+	 * specific case, where PARTIAL is both correct and required.
+	 */
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		skb->ip_summed = CHECKSUM_PARTIAL;
 
-- 
2.25.0.341.g760bfbb309-goog

