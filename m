Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D16D15BB89
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfGAMbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:31:17 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41132 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbfGAMbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:31:14 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so23219221eds.8
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 05:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DoyCZtmIB+Vznz4UkmlQ+1eB/hSfD15pJd3VqmIYMIA=;
        b=JWnYFvJoLpvFGu72Q/gRQn91cc1K0WAl52lueTgxAplr4xb/wVOUV6pWmhWjvYJNmg
         JGoOZF1MkIVlRQrxtSLg+3+bWeEtY66asIWD9qS1zw0aXIAz13Bq49yWmO3SxdPJ8uoy
         zf7q1iUjUjY1btpWnU5g/4ty/GEbJ5HrXcE3ZpQFQCUmSHgp1RHm+CHqm2TifjdfxjgQ
         y9AyHPi7FDiFs6e0MmqNCnqZSApgfs9QG7NxIBmCziikwH+lqWdWIgXDV5ahensGzeK3
         979RXZgoEj1nHdf2XCkvvyF983giDjsD+Py9FkpTb+KE1YMWABrsdQJoKQlqm2JTLZ36
         4ZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DoyCZtmIB+Vznz4UkmlQ+1eB/hSfD15pJd3VqmIYMIA=;
        b=QTp3tvizPub2vfoWcbf5AY+argLHncPWA3Fnnrx3ZzI2EW6pQn2OhHB3NMYiVsvM6N
         LweT/wwL9dJix/xXccnjLPr51iZV81Q9iWc7tGsgOe2hH1/jFuoWpGcRXQvgvyCSQBjY
         gHr3Q6aJnVUjnYu253fa8pp9awOXRPJ/2dAIP06VwM6eotUeI4TOUPIiQt2mO2MbiXXD
         FF2z8FmuX5kTFBuEg3ZgPCCApF59U1vEs8pZ+wgAMUcWP/UwiKJxfBGgZh1/QagQk1bN
         Xj0XO7vKjlxXK8XobiVthQC1PoY4WQzjjaQqJvmoI3xTW3oS5uBq/vyADuCN6wxg/2F3
         HHhw==
X-Gm-Message-State: APjAAAWO63KEd1ACZqGlIZTB+wrkIxPH7rUKjUWNQMxGtCP3yLSESk6V
        GObOw9dgju7oQnmDk4gt/eoOvTLfa/k=
X-Google-Smtp-Source: APXvYqzEANFZZ3SZfWLpJ8X78Kqg0eVTIiAPI5/Hsn/ywQnEA1tx2pHyYMaWXCUwkROfZNKqwtzGqA==
X-Received: by 2002:aa7:c99a:: with SMTP id c26mr28019612edt.118.1561984272821;
        Mon, 01 Jul 2019 05:31:12 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id a3sm2099204ejn.64.2019.07.01.05.31.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 01 Jul 2019 05:31:12 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v4 3/5] net: core: add MPLS update core helper and use in OvS
Date:   Mon,  1 Jul 2019 13:30:55 +0100
Message-Id: <1561984257-9798-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561984257-9798-1-git-send-email-john.hurley@netronome.com>
References: <1561984257-9798-1-git-send-email-john.hurley@netronome.com>
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
 net/core/skbuff.c         | 34 ++++++++++++++++++++++++++++++++++
 net/openvswitch/actions.c | 13 +++----------
 3 files changed, 38 insertions(+), 10 deletions(-)

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
index ce30989..398ebcb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5433,6 +5433,40 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
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
+	struct mpls_shim_hdr *old_lse = mpls_hdr(skb);
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
+		__be32 diff[] = { ~old_lse->label_stack_entry, mpls_lse };
+
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
+	}
+
+	old_lse->label_stack_entry = mpls_lse;
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

