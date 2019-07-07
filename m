Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6E961527
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfGGOCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 10:02:21 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40764 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfGGOCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 10:02:19 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so12166662eds.7
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 07:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vlG+11lIl1lw03AljqHdE3syssxaNamo8ya8sCJ1gX0=;
        b=1WmmKSGUVhLm86OhSyPHXeyHchNhc1WhF/ZDO4aYNe7KimkDb24QImUl0L6UBpnicF
         M4vEq0eS/r4TdwUQotvH062+wQx860um1CugOxHlKA+cTc4VFktL4ScsRbO2KYyiJ7dl
         QJ943yOrZBfJsTHnKG4x7rSXYPyXiwUwRZcG8X+eVaBCEzWYcH5WYFQksPbueMv62/td
         /3vwcuwi0KO0JRL4T9w4HFEPdMy3aUm4Nlfst+mDEky2ZeaNCN4d8KeV/LXPxQ99KDxz
         AN7mqdE0ZD4PhiQRf8Uhkl1Hx3Fqi5riB178cDyQ3l6krdGTldKSRxWIS90hcFCL+pqA
         BVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vlG+11lIl1lw03AljqHdE3syssxaNamo8ya8sCJ1gX0=;
        b=srbYY55L4T+YTsCqEVslGeQSOugQaPbuZSUtXltG+KBLCBj9YMoAaW0i4v3LAOVE80
         x9ukSmGyyYC21v8lUsge6OaId0047cq+1XFiSL1+irzKhKx8/gJqAvrrgdUZWuvW0Tpx
         mMTqFe+GjBwg/r7MGP9UE7ilkcgS8/9IVSn5LEHch5HPODIZND1kiBgBhzH9ZhNHtNY2
         iKGnnUEfmQrEQPQoM/i4UPx3fkr8r3d4PvTSk5quluKv4+geZHlbouYRveGQTLtnBZp5
         U+ddcZ12Cid4k4B/5IxS84cmGXPMx3ncaSyRwLQLu54+qcwNs/UTiYxXRbejYJwKaAiv
         NF9A==
X-Gm-Message-State: APjAAAU7AnYZjVecFaR7BwzoQTyl7XJ8IWNRSZMwEsqMcCBeH6+caKbE
        WjPIrlS/bt6ryt/sboonVBAwooABxV4=
X-Google-Smtp-Source: APXvYqxMfEyLM6pzkFH89Hunc46fYMTw+zthgDEiACx+q/+I3q805CZXfbCPJ6zjdQQAbyvlNtLoQQ==
X-Received: by 2002:a50:f4d8:: with SMTP id v24mr15093046edm.166.1562508137764;
        Sun, 07 Jul 2019 07:02:17 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t2sm4673327eda.95.2019.07.07.07.02.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 07 Jul 2019 07:02:17 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, mrv@mojatatu.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v7 3/5] net: core: add MPLS update core helper and use in OvS
Date:   Sun,  7 Jul 2019 15:01:56 +0100
Message-Id: <1562508118-28841-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
References: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Open vSwitch allows the updating of an existing MPLS header on a packet.
In preparation for supporting similar functionality in TC, move this to a
common skb helper function.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/skbuff.h    |  1 +
 net/core/skbuff.c         | 33 +++++++++++++++++++++++++++++++++
 net/openvswitch/actions.c | 13 +++----------
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 88b34fe..dc07f00 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3448,6 +3448,7 @@ int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto);
 int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto);
+int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
 			     gfp_t gfp);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ce30989..46da15c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5433,6 +5433,39 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
 EXPORT_SYMBOL_GPL(skb_mpls_pop);
 
 /**
+ * skb_mpls_update_lse() - modify outermost MPLS header and update csum
+ *
+ * @skb: buffer
+ * @mpls_lse: new MPLS label stack entry to update to
+ *
+ * Expects skb->data at mac header.
+ *
+ * Returns 0 on success, -errno otherwise.
+ */
+int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse)
+{
+	int err;
+
+	if (unlikely(!eth_p_mpls(skb->protocol)))
+		return -EINVAL;
+
+	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
+	if (unlikely(err))
+		return err;
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE) {
+		__be32 diff[] = { ~mpls_hdr(skb)->label_stack_entry, mpls_lse };
+
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
+	}
+
+	mpls_hdr(skb)->label_stack_entry = mpls_lse;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(skb_mpls_update_lse);
+
+/**
  * alloc_skb_with_frags - allocate skb with page frags
  *
  * @header_len: size of linear part
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 62715bb..3572e11 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -193,19 +193,12 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be32 lse;
 	int err;
 
-	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
-	if (unlikely(err))
-		return err;
-
 	stack = mpls_hdr(skb);
 	lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
-	if (skb->ip_summed == CHECKSUM_COMPLETE) {
-		__be32 diff[] = { ~(stack->label_stack_entry), lse };
-
-		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
-	}
+	err = skb_mpls_update_lse(skb, lse);
+	if (err)
+		return err;
 
-	stack->label_stack_entry = lse;
 	flow_key->mpls.top_lse = lse;
 	return 0;
 }
-- 
2.7.4

