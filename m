Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB56A5D90F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfGCAdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:33:33 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38357 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfGCAdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:33:31 -0400
Received: by mail-ed1-f66.google.com with SMTP id r12so313941edo.5
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X+WIAGeEZAsnX9sVVrTkNZK2Q8Ls+XngbXiUAlgAt54=;
        b=OA6lwZk/0glmkKCGhRitUPMH+38aC5T75sSJzLt5fET3iP43gI3WNcxfcsqwN/utve
         6kBcTPd72dJ1NQYEpWAYIJe/V9Y5hePGUl9+J259gor+m2DajM5dSBuje/btb8kM9Qlu
         Da+GiCEN3qsYu0a5ZRhpohdaMRAkHxVQyTqMWOWViYMynU4POY6f6F3ki9Wh+hLr8K4I
         OfAJNwboWFWZz5lTPwz/PL3H215dvQ5UWkzaHzE6Z02IPlTuzTriy84SJPVJb41/XWKC
         hwu3JxKJ/oE/rhz6K8Irzzj39kA+YdyXtXhZfOvQaTeeAS87xEbqG/GOGaXXcKB4ylfy
         PFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X+WIAGeEZAsnX9sVVrTkNZK2Q8Ls+XngbXiUAlgAt54=;
        b=KnM3IpdqZCm8YBWlqufMVRnBFaQajYJvDzR6ojBPL3kssRJWwFF77eDQoidNnmU7hD
         /aEYSOgT5XEliDpNOadfph+OpTP8CxJuaTTWmAq6w6LKUP8heahyh1rlKJB7QjdYm9zY
         WijFZLj9/CSLERiS7P2ttA7h1zSSZzmRdjqs936X0kh2VQRHaGe7r/uzmorkHA7Cc/Ji
         dZLkb0SQWp9AVsETJ0D8TLAjSlXVkLM6D0jFHhk99/3RZsrqWodpR90CcAvU7mRhXMUc
         jVbY1krxWgi3BKhrNaePmFUEmX2Fm40B0FUHISzOzNQTad+iJ+4sJsbtXbwZaAVzHfQM
         LiLg==
X-Gm-Message-State: APjAAAW4WgIrfAyEtIT3g0Q/F3h0SQgd9hs0qKcKgY7eA5xyspJs+QmJ
        C/Qlhr9YN1xXGEeDuuvIzhuEcd6ZH7M=
X-Google-Smtp-Source: APXvYqyyC+RQP4eTASdRM712RTVZNLP1MGV6F7rOuE4X/ubfHBVi5nFO5MGqvQ7T+waObyB9cuH8QA==
X-Received: by 2002:a17:906:90cf:: with SMTP id v15mr30290160ejw.77.1562113557460;
        Tue, 02 Jul 2019 17:25:57 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id h10sm168768eda.85.2019.07.02.17.25.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 17:25:56 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v5 3/5] net: core: add MPLS update core helper and use in OvS
Date:   Wed,  3 Jul 2019 01:25:29 +0100
Message-Id: <1562113531-29296-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
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

