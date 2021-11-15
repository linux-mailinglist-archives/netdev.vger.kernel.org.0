Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798A1450A8A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhKORJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbhKORJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:09:00 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FE8C061570
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:06:03 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id b4so15076747pgh.10
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UgQdktFBq2tUAcsKMlBEMikurBHCVaUO0CYYQnINmEM=;
        b=EY2TyetCD+iTBe9aXt615TeY8RvQqld4cqWOtKB0CneTjnv/bY9mZ0xi/8KBNHOHRV
         ghd5WOQ+6M0fb9suJ+5O3S/Zl1gc7KKzKf1Hdb1cJZRc6ikhrrIZUrauyiiBy9gnmAzw
         rOoRbdNr8uvrx4FM6YtnyoX7RbP5u1+boyrEfNwNAKj/lUub7Sg53+tK7PRhRwUjHLi1
         OZDyKBAFyWJqwM/4ElSpD5p1hCAOgU3/CGdlv8M8drJzxp/fwG6Kw/DVs6V1r91rMyt2
         8RAOfQjnqsYa+MMgjUgnKqJCCDvdLrnHagRMFmS5KI9YAHlY40yEEU0GKmn3vRpqFhUs
         Aa1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UgQdktFBq2tUAcsKMlBEMikurBHCVaUO0CYYQnINmEM=;
        b=TEaY34BMv3PHSgwTiDZiFdwDtl2tkgdQUxj1F1asH6kCgDvLI/QnDjCU4Dco8U2nr+
         KrECiCLL9UUZnkRZo7StTp1aC8wG9nv43M/RsM+uQJjH3DFNrEBVlTRHP7FyQIQaOSvu
         20fwhRKE5hyxri2ak+nKaf3eIRrZBJkmueJdGgC+XLO26dlujzgjTdx7KXV2aWiXRggj
         VRuHJ2LRsAeLt7scFZqhonA9I+NjbC1YNMeokfFgAmSuLoXvVv7BtYi3auqobvbZ/0Mh
         wMkM/aIRjLg6UHZELMg82uuCJCLg5YJ6A1a428MYDLMwWLR7Tm50uYIncurrLDmlx36b
         Qs+A==
X-Gm-Message-State: AOAM5318qwTil3XZzsXskQO0Jpjiem+YeixGuFUyCH142aIyaAEkHtwi
        qbEQTaUFreL5h8PTPT7WQq8=
X-Google-Smtp-Source: ABdhPJyd1d+DWzN7u2bibfPv+9TPaNXVC8G6OhytKjITLSzSKhPhg/5ENg8o7VSJndu5HwTfkHVEog==
X-Received: by 2002:a05:6a00:10d2:b0:44d:f03e:46c7 with SMTP id d18-20020a056a0010d200b0044df03e46c7mr34195653pfu.0.1636995962983;
        Mon, 15 Nov 2021 09:06:02 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id y28sm15971845pfa.208.2021.11.15.09.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:06:02 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/4] net: gro: move skb_gro_receive into net/core/gro.c
Date:   Mon, 15 Nov 2021 09:05:53 -0800
Message-Id: <20211115170554.3645322-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115170554.3645322-1-eric.dumazet@gmail.com>
References: <20211115170554.3645322-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

net/core/gro.c will contain all core gro functions,
to shrink net/core/skbuff.c and net/core/dev.c

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |   1 -
 include/net/gro.h         |   2 +
 net/core/Makefile         |   2 +-
 net/core/gro.c            | 118 ++++++++++++++++++++++++++++++++++++++
 net/core/skbuff.c         | 117 -------------------------------------
 5 files changed, 121 insertions(+), 119 deletions(-)
 create mode 100644 net/core/gro.c

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ce6ee1453dbc3691fab13ee079347fbd49e587d3..93d397db9ec417b92192296374ebc672bde557a3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2902,7 +2902,6 @@ struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
 struct net_device *dev_get_by_napi_id(unsigned int napi_id);
 int netdev_get_name(struct net *net, char *name, int ifindex);
 int dev_restart(struct net_device *dev);
-int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
 
 
 static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
diff --git a/include/net/gro.h b/include/net/gro.h
index 1ffbe74b2e35eb2f24343da1765633ba7e74ab67..f988bf3440f8972151848d6321713b1a0184df59 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -414,4 +414,6 @@ static inline __wsum ip6_gro_compute_pseudo(struct sk_buff *skb, int proto)
 					    skb_gro_len(skb), proto, 0));
 }
 
+int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
+
 #endif /* _NET_IPV6_GRO_H */
diff --git a/net/core/Makefile b/net/core/Makefile
index 4268846f2f4759b4dbd759ea7206287781ef9a3d..6bdcb2cafed8e6bcac499798b800c11715ca9204 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
-			fib_notifier.o xdp.o flow_offload.o
+			fib_notifier.o xdp.o flow_offload.o gro.o
 
 obj-y += net-sysfs.o
 obj-$(CONFIG_PAGE_POOL) += page_pool.o
diff --git a/net/core/gro.c b/net/core/gro.c
new file mode 100644
index 0000000000000000000000000000000000000000..91a74c4da9ff5b6ba50382a593ef12b43b16d20b
--- /dev/null
+++ b/net/core/gro.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <net/gro.h>
+
+int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
+{
+	struct skb_shared_info *pinfo, *skbinfo = skb_shinfo(skb);
+	unsigned int offset = skb_gro_offset(skb);
+	unsigned int headlen = skb_headlen(skb);
+	unsigned int len = skb_gro_len(skb);
+	unsigned int delta_truesize;
+	unsigned int new_truesize;
+	struct sk_buff *lp;
+
+	if (unlikely(p->len + len >= 65536 || NAPI_GRO_CB(skb)->flush))
+		return -E2BIG;
+
+	lp = NAPI_GRO_CB(p)->last;
+	pinfo = skb_shinfo(lp);
+
+	if (headlen <= offset) {
+		skb_frag_t *frag;
+		skb_frag_t *frag2;
+		int i = skbinfo->nr_frags;
+		int nr_frags = pinfo->nr_frags + i;
+
+		if (nr_frags > MAX_SKB_FRAGS)
+			goto merge;
+
+		offset -= headlen;
+		pinfo->nr_frags = nr_frags;
+		skbinfo->nr_frags = 0;
+
+		frag = pinfo->frags + nr_frags;
+		frag2 = skbinfo->frags + i;
+		do {
+			*--frag = *--frag2;
+		} while (--i);
+
+		skb_frag_off_add(frag, offset);
+		skb_frag_size_sub(frag, offset);
+
+		/* all fragments truesize : remove (head size + sk_buff) */
+		new_truesize = SKB_TRUESIZE(skb_end_offset(skb));
+		delta_truesize = skb->truesize - new_truesize;
+
+		skb->truesize = new_truesize;
+		skb->len -= skb->data_len;
+		skb->data_len = 0;
+
+		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE;
+		goto done;
+	} else if (skb->head_frag) {
+		int nr_frags = pinfo->nr_frags;
+		skb_frag_t *frag = pinfo->frags + nr_frags;
+		struct page *page = virt_to_head_page(skb->head);
+		unsigned int first_size = headlen - offset;
+		unsigned int first_offset;
+
+		if (nr_frags + 1 + skbinfo->nr_frags > MAX_SKB_FRAGS)
+			goto merge;
+
+		first_offset = skb->data -
+			       (unsigned char *)page_address(page) +
+			       offset;
+
+		pinfo->nr_frags = nr_frags + 1 + skbinfo->nr_frags;
+
+		__skb_frag_set_page(frag, page);
+		skb_frag_off_set(frag, first_offset);
+		skb_frag_size_set(frag, first_size);
+
+		memcpy(frag + 1, skbinfo->frags, sizeof(*frag) * skbinfo->nr_frags);
+		/* We dont need to clear skbinfo->nr_frags here */
+
+		new_truesize = SKB_DATA_ALIGN(sizeof(struct sk_buff));
+		delta_truesize = skb->truesize - new_truesize;
+		skb->truesize = new_truesize;
+		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE_STOLEN_HEAD;
+		goto done;
+	}
+
+merge:
+	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	skb->destructor = NULL;
+	delta_truesize = skb->truesize;
+	if (offset > headlen) {
+		unsigned int eat = offset - headlen;
+
+		skb_frag_off_add(&skbinfo->frags[0], eat);
+		skb_frag_size_sub(&skbinfo->frags[0], eat);
+		skb->data_len -= eat;
+		skb->len -= eat;
+		offset = headlen;
+	}
+
+	__skb_pull(skb, offset);
+
+	if (NAPI_GRO_CB(p)->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		NAPI_GRO_CB(p)->last->next = skb;
+	NAPI_GRO_CB(p)->last = skb;
+	__skb_header_release(skb);
+	lp = p;
+
+done:
+	NAPI_GRO_CB(p)->count++;
+	p->data_len += len;
+	p->truesize += delta_truesize;
+	p->len += len;
+	if (lp != p) {
+		lp->data_len += len;
+		lp->truesize += delta_truesize;
+		lp->len += len;
+	}
+	NAPI_GRO_CB(skb)->same_flow = 1;
+	return 0;
+}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 68b13bc77b749dbacf739a71ef7a1b5f48d89e0c..1aa32c053e4de9aad50600053ae9011243b3ac37 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -64,7 +64,6 @@
 
 #include <net/protocol.h>
 #include <net/dst.h>
-#include <net/gro.h>
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
@@ -4272,122 +4271,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 }
 EXPORT_SYMBOL_GPL(skb_segment);
 
-int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
-{
-	struct skb_shared_info *pinfo, *skbinfo = skb_shinfo(skb);
-	unsigned int offset = skb_gro_offset(skb);
-	unsigned int headlen = skb_headlen(skb);
-	unsigned int len = skb_gro_len(skb);
-	unsigned int delta_truesize;
-	unsigned int new_truesize;
-	struct sk_buff *lp;
-
-	if (unlikely(p->len + len >= 65536 || NAPI_GRO_CB(skb)->flush))
-		return -E2BIG;
-
-	lp = NAPI_GRO_CB(p)->last;
-	pinfo = skb_shinfo(lp);
-
-	if (headlen <= offset) {
-		skb_frag_t *frag;
-		skb_frag_t *frag2;
-		int i = skbinfo->nr_frags;
-		int nr_frags = pinfo->nr_frags + i;
-
-		if (nr_frags > MAX_SKB_FRAGS)
-			goto merge;
-
-		offset -= headlen;
-		pinfo->nr_frags = nr_frags;
-		skbinfo->nr_frags = 0;
-
-		frag = pinfo->frags + nr_frags;
-		frag2 = skbinfo->frags + i;
-		do {
-			*--frag = *--frag2;
-		} while (--i);
-
-		skb_frag_off_add(frag, offset);
-		skb_frag_size_sub(frag, offset);
-
-		/* all fragments truesize : remove (head size + sk_buff) */
-		new_truesize = SKB_TRUESIZE(skb_end_offset(skb));
-		delta_truesize = skb->truesize - new_truesize;
-
-		skb->truesize = new_truesize;
-		skb->len -= skb->data_len;
-		skb->data_len = 0;
-
-		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE;
-		goto done;
-	} else if (skb->head_frag) {
-		int nr_frags = pinfo->nr_frags;
-		skb_frag_t *frag = pinfo->frags + nr_frags;
-		struct page *page = virt_to_head_page(skb->head);
-		unsigned int first_size = headlen - offset;
-		unsigned int first_offset;
-
-		if (nr_frags + 1 + skbinfo->nr_frags > MAX_SKB_FRAGS)
-			goto merge;
-
-		first_offset = skb->data -
-			       (unsigned char *)page_address(page) +
-			       offset;
-
-		pinfo->nr_frags = nr_frags + 1 + skbinfo->nr_frags;
-
-		__skb_frag_set_page(frag, page);
-		skb_frag_off_set(frag, first_offset);
-		skb_frag_size_set(frag, first_size);
-
-		memcpy(frag + 1, skbinfo->frags, sizeof(*frag) * skbinfo->nr_frags);
-		/* We dont need to clear skbinfo->nr_frags here */
-
-		new_truesize = SKB_DATA_ALIGN(sizeof(struct sk_buff));
-		delta_truesize = skb->truesize - new_truesize;
-		skb->truesize = new_truesize;
-		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE_STOLEN_HEAD;
-		goto done;
-	}
-
-merge:
-	/* sk owenrship - if any - completely transferred to the aggregated packet */
-	skb->destructor = NULL;
-	delta_truesize = skb->truesize;
-	if (offset > headlen) {
-		unsigned int eat = offset - headlen;
-
-		skb_frag_off_add(&skbinfo->frags[0], eat);
-		skb_frag_size_sub(&skbinfo->frags[0], eat);
-		skb->data_len -= eat;
-		skb->len -= eat;
-		offset = headlen;
-	}
-
-	__skb_pull(skb, offset);
-
-	if (NAPI_GRO_CB(p)->last == p)
-		skb_shinfo(p)->frag_list = skb;
-	else
-		NAPI_GRO_CB(p)->last->next = skb;
-	NAPI_GRO_CB(p)->last = skb;
-	__skb_header_release(skb);
-	lp = p;
-
-done:
-	NAPI_GRO_CB(p)->count++;
-	p->data_len += len;
-	p->truesize += delta_truesize;
-	p->len += len;
-	if (lp != p) {
-		lp->data_len += len;
-		lp->truesize += delta_truesize;
-		lp->len += len;
-	}
-	NAPI_GRO_CB(skb)->same_flow = 1;
-	return 0;
-}
-
 #ifdef CONFIG_SKB_EXTENSIONS
 #define SKB_EXT_ALIGN_VALUE	8
 #define SKB_EXT_CHUNKSIZEOF(x)	(ALIGN((sizeof(x)), SKB_EXT_ALIGN_VALUE) / SKB_EXT_ALIGN_VALUE)
-- 
2.34.0.rc1.387.gb447b232ab-goog

