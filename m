Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B15F9E4
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGDOQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:16:57 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35745 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfGDOQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:16:54 -0400
Received: by mail-ed1-f66.google.com with SMTP id w20so5589449edd.2
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 07:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HfZcJgxFD1cllR6LVewBcpjEqpbPSqgbolFEb3o0z/E=;
        b=lZyMVfSg4z0Z7J8I+wrYEl3xRyk35duggUCDJ2vY7fI9wP/itzqXIVqDH+oc6ZWxdg
         yfmKSilEWoHepK9ssCk1YY6FovZFX6Yo+Or/k2CTzVUY8o9zdiUFZ3r2xUls3CJI1H7L
         x9qdc8fMVcXFNPtq647jGWadjk1ibYGjraTW5xRi1e8cKm3Kr44XkWeXW+RNUkr0tqsW
         Y0ZjckAAfWfE0OFg2iQ/Tninv62r2miXcpBBu5DHau9Vf+uShJL9YHPFwot5Y/ghpbIE
         XMnZS9tIY7kJrvDTwaS9fJnZrZCi2euRrLcF4dJ8VmvQ48JBk0IrA54nq0gZQaFJo1Ok
         d95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HfZcJgxFD1cllR6LVewBcpjEqpbPSqgbolFEb3o0z/E=;
        b=H76mRrc2SRDuHGjZxF4fd7IGiLyE2G8veIvz8AfjFeIWHYaMk198oE0u0870VrpPsg
         C/AJ7ykbBU/keDmcBsCGfrHzyOUAi4ZjR4MZ9XBnNnQFu8hbd4KuH/Sp08NJQCuvaqSt
         L/iOxyUevwGAHRoQyvaBSy9DEoD71ZtAZ0+RvDfhKFVCCa2C+Iwwx6MZ+F3ZcABitwZp
         1f8Nqs0PzZNOc2ZfiCITVzOzud+IMaUci1qx2v3OC7e63eNHl//aEzaZtbspnSLlk574
         RwK0CfbtLBxmN5+9vu8Rp5cqaKNzN6BG6WcegQmgOfY4e/2SGATaTyIsricwsFLC9t7g
         0YAw==
X-Gm-Message-State: APjAAAVW3WcwtEa0YuHQ218BQ4ypg9udVemqvwORit6Hv1hPDGlYuo6K
        8FlRQXjdtMCEoVUOd4Mx5sJQWNqSlBI=
X-Google-Smtp-Source: APXvYqz8M2ygFrFXmbPE6YbqYOdvvk7w2wURVhCPq7ukislPtD9tC9dKIfthCtpxtW7daiCqt8Juag==
X-Received: by 2002:aa7:c3d8:: with SMTP id l24mr50658620edr.58.1562249813140;
        Thu, 04 Jul 2019 07:16:53 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id s27sm1702705eda.36.2019.07.04.07.16.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 07:16:52 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v6 3/5] net: core: add MPLS update core helper and use in OvS
Date:   Thu,  4 Jul 2019 15:16:40 +0100
Message-Id: <1562249802-24937-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
References: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
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
index 89d5c43..1545c4c 100644
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

