Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B185D918
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfGCAeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:34:13 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35685 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfGCAeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:34:12 -0400
Received: by mail-ed1-f67.google.com with SMTP id w20so325211edd.2
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jZFFaBntFOF6JRAZzNgyKqVJG53qU5arVep/YxRIE2c=;
        b=1+t/zFypOJcD8ZyuDUxAuXNQK0fPqyj2jBN9P9L7d4gAjjeGnwCzTQxeavL5oNFfrA
         VPI5vAQ3fC99aNrL40h61dk0hPQjoHXyu39JdPW01dycU5M923ckYhQzz62erps87rHS
         W3hNMMoRfsNGCsMzb90QWSC+UF12hUjwG/dGbyDjlwYswDiw2qkyPaQoMV812L+90UIN
         0ZKKows+C9AlONmOjmShI7XsqMuSe4jEiCX0X2xKKwNfbTNUd58SiGXF7RSF/ftysITr
         71lWJbKQSD3XNCiZexyfOM7PgPGQrdLTzSl5rNjf3l+CU3qwDFAQgM1NN8DiU6Q8MQTN
         q1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jZFFaBntFOF6JRAZzNgyKqVJG53qU5arVep/YxRIE2c=;
        b=ShxJLnheMoeLM1vXTtHjErcOHCDzUZb32yo+GBnOmqSlRBWy/FESSOudOz/DX7oJcM
         BSWMTI51EbbH9MapW+8m6014XxYz+Peq9s1ZC1oW89DRmp0JbSTlaPpLkJX1WmJeCzqE
         jT2Qw8p/ui1LeWY7DeVmRG7EtwZ2c149U5NIq6CoxVp6VP0pxOIGeZYPXNBehQB0xEPI
         B6ozfeTbN7ElArBr4j5xHh6TC6EfagRR04r7sNlGnOEi+33oPEoohcg4i8U0UURJAdPG
         le2H6155qMX2uanNL/JxCpjkcCNGNIfZGZeidjyuG0NerM5SLS4Num66IpWxsoe535Wz
         bWtg==
X-Gm-Message-State: APjAAAVsgq51OwxBI9pjr8LrZeGLWZVEiMGdX3duOP6dQV6JNeP4Mtnl
        kMbQuJAemJxNfizwN9FbhSFHN0ilMxI=
X-Google-Smtp-Source: APXvYqwB3lNZxsFGBhwdJTmmLAQWuK5ftewuAfXoFboowcxbpjOm8bd8B8H5KiniTFpMqdsg1QG22g==
X-Received: by 2002:aa7:d888:: with SMTP id u8mr38753634edq.264.1562113556324;
        Tue, 02 Jul 2019 17:25:56 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id h10sm168768eda.85.2019.07.02.17.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 17:25:55 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v5 2/5] net: core: move pop MPLS functionality from OvS to core helper
Date:   Wed,  3 Jul 2019 01:25:28 +0100
Message-Id: <1562113531-29296-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
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

