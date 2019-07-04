Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E575F9E3
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfGDOQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:16:55 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39482 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfGDOQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:16:54 -0400
Received: by mail-ed1-f66.google.com with SMTP id m10so5568408edv.6
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 07:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YuMQJ0c+ZhAYe2cDwGYkQu3aUPB9qyrbaARQWBMi8N8=;
        b=h9kLonFp7hsmKwgAKz4YYr8ZTGGK3q2+5b8S/ukkSxtsjspfrk++TomDkjIKqCUxtA
         qp4kj02Ahg2bLBkINP/6S/c8GpdnMr3yyzbhbcUWjcozia6q8H3Hf0ml5XIHV8H4C5FN
         jfIEwQO515+Z1A/vnzAXqxtBRQXZKcouWvT1bPEwExYR5jHkEbgbvpeyykFS2SVJFw9Y
         iP4hbKThuMVFh9+/FlchERWhWcwBD18RIy0sWBqW+o6c5+KF04UThG1W5QD1zplUJZ3L
         T5U1B3LtYRaN+WF3tHLKyRzXqx1lUMUBgItlJWcSvUd6RBlSbT5+wGmsxP0BbCuL3Jl3
         GVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YuMQJ0c+ZhAYe2cDwGYkQu3aUPB9qyrbaARQWBMi8N8=;
        b=AG0gphmnUI+qYnAU9NQDIq/gAGGkN1g0L7woBiOx42cZJ2GqMQZoeVUc/PS2Ugvytd
         trxK5ETpp/PXHD4vxVccv/lLUbiavAvbrskILb3A7svBPvVKsW9bA4TK5ebaX93zENFI
         9BPfexkWO/iIJqUTR88IgsQwMN1nylggQBLi36dphENr5ZIHwvoIwdkAw+pRwL31/1bo
         OE6L3mRJKdfuvgCP4BVsZnJ7wd/YG5JfBe5H4DkV4H8ioMBY/KZ31CshQ9u6VYdypOkk
         Ufvux9LlXZIgXy4N5w8RybTQP/9LM+ynKdg3C6ao0Hse/PbvoqSZGJ6RNHD0jDd9so+H
         XOgg==
X-Gm-Message-State: APjAAAVSeQrCyxncFtncYvGT4K6scbOflJ6pJi3hf3R8UT5PvKcAoG7+
        8+UyPBX59iBZrpgZbzuZUTU+j5+TkH0=
X-Google-Smtp-Source: APXvYqwqKbGo7Qy0yMoxJP4jh7pzHpGv0PC3WBeBzvo9xja/oELvzVXfXnLf9yACBDu+x6jlKuiUDQ==
X-Received: by 2002:a50:a4ad:: with SMTP id w42mr47957425edb.230.1562249812005;
        Thu, 04 Jul 2019 07:16:52 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id s27sm1702705eda.36.2019.07.04.07.16.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 07:16:51 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v6 2/5] net: core: move pop MPLS functionality from OvS to core helper
Date:   Thu,  4 Jul 2019 15:16:39 +0100
Message-Id: <1562249802-24937-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
References: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Open vSwitch provides code to pop an MPLS header to a packet. In
preparation for supporting this in TC, move the pop code to an skb helper
that can be reused.

Remove the, now unused, update_ethertype static function from OvS.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/skbuff.h    |  1 +
 net/core/skbuff.c         | 42 ++++++++++++++++++++++++++++++++++++++++++
 net/openvswitch/actions.c | 37 ++-----------------------------------
 3 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0112256..89d5c43 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3447,6 +3447,7 @@ int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto);
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
 			     gfp_t gfp);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f1d1e47..ce30989 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5391,6 +5391,48 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto)
 EXPORT_SYMBOL_GPL(skb_mpls_push);
 
 /**
+ * skb_mpls_pop() - pop the outermost MPLS header
+ *
+ * @skb: buffer
+ * @next_proto: ethertype of header after popped MPLS header
+ *
+ * Expects skb->data at mac header.
+ *
+ * Returns 0 on success, -errno otherwise.
+ */
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
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
+	skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
+	memmove(skb_mac_header(skb) + MPLS_HLEN, skb_mac_header(skb),
+		skb->mac_len);
+
+	__skb_pull(skb, MPLS_HLEN);
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, skb->mac_len);
+
+	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
+		struct ethhdr *hdr;
+
+		/* use mpls_hdr() to get ethertype to account for VLANs. */
+		hdr = (struct ethhdr *)((void *)mpls_hdr(skb) - ETH_HLEN);
+		skb_mod_eth_type(skb, hdr, next_proto);
+	}
+	skb->protocol = next_proto;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(skb_mpls_pop);
+
+/**
  * alloc_skb_with_frags - allocate skb with page frags
  *
  * @header_len: size of linear part
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index a9a6c9c..62715bb 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -160,18 +160,6 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			      struct sw_flow_key *key,
 			      const struct nlattr *attr, int len);
 
-static void update_ethertype(struct sk_buff *skb, struct ethhdr *hdr,
-			     __be16 ethertype)
-{
-	if (skb->ip_summed == CHECKSUM_COMPLETE) {
-		__be16 diff[] = { ~(hdr->h_proto), ethertype };
-
-		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
-	}
-
-	hdr->h_proto = ethertype;
-}
-
 static int push_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 		     const struct ovs_action_push_mpls *mpls)
 {
@@ -190,31 +178,10 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 {
 	int err;
 
-	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
-	if (unlikely(err))
+	err = skb_mpls_pop(skb, ethertype);
+	if (err)
 		return err;
 
-	skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
-
-	memmove(skb_mac_header(skb) + MPLS_HLEN, skb_mac_header(skb),
-		skb->mac_len);
-
-	__skb_pull(skb, MPLS_HLEN);
-	skb_reset_mac_header(skb);
-	skb_set_network_header(skb, skb->mac_len);
-
-	if (ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET) {
-		struct ethhdr *hdr;
-
-		/* mpls_hdr() is used to locate the ethertype field correctly in the
-		 * presence of VLAN tags.
-		 */
-		hdr = (struct ethhdr *)((void *)mpls_hdr(skb) - ETH_HLEN);
-		update_ethertype(skb, hdr, ethertype);
-	}
-	if (eth_p_mpls(skb->protocol))
-		skb->protocol = ethertype;
-
 	invalidate_flow_key(key);
 	return 0;
 }
-- 
2.7.4

