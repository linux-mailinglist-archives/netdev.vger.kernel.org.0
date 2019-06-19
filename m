Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38494C3A3
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 00:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbfFSWcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 18:32:17 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34208 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730182AbfFSWcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 18:32:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so441860pfc.1
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 15:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UtXeAU0owx71Zr1h7JGJYmNFV8PORkz4rS8g11qc07g=;
        b=rIdl9wATc5QuJqo0iIr9w3OwayT7lC7QaTNgAEq2UEdxAUaBSRL6pgOZ7vmMr8hJsx
         3iv8Kq5udC4uVCPSW2DlZft/AXpE0SO6pnaI9U260indjMwvnpGLdz819h4Vd7hwB/j1
         aMdGscakUC+eQUoPbSXU0B/9hmPdt+6t6dVEkvCrWkiWS/kvIteaz5cJv/QzFGY4jG/D
         ewLka2nn4nn9gz9YtZaZeUpm5dlnNBnlU14W5xGiUKC3mxSGN88J7m7J35wMJHGBU4RV
         4WYE/4/DtBHcDlBQ2E0YEOs4jnm1l3mpCm3OWZPn50PpxkBQBqzpgBOb0FRVy161uNJ0
         teDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UtXeAU0owx71Zr1h7JGJYmNFV8PORkz4rS8g11qc07g=;
        b=SmQq4wxYtBz9fZ6P1sboQi0IBmmWxj+qcl5Z8bipCXv9mQAVz6r0WhQt69IOnuOhl5
         bm4OGCWDI1pduSlidyabD+N3reZ+/W+CJ9SJf8Hdl5VdbS+8uqxDgdK0DZMV4DkVbtlp
         jlVhFfQcrjVjLwC256lY+KURNZTlbfOP27BrM211Z/lZ7SZzwETdoMSA5MBmmhC0c0Ev
         W7DpT+hLfTHE6Gh22fN5EXdyIpijlklWV1LLnnHK440JLPLbxGauablzmMwF9LKKTZOQ
         benJFebcIsjyaHgbIVzMq+zc+vbpVMUZbuolQ9wkUshkUBzQ2cnicJH2BwjbCr/FOHZs
         6nvQ==
X-Gm-Message-State: APjAAAVlJJ0egZao0DtyJem37P+G5157UJH3wSNTlzGiCtu8qvTvrrvZ
        SSKX+O98/xwo02qRW/ACORI=
X-Google-Smtp-Source: APXvYqz6rFKEL2TUtZ3/6scnDRSKH4udbCrXQkvEFux7C8+d81+E1eGZA56ewT/3q+3uwqHbBKOehA==
X-Received: by 2002:a17:90a:208e:: with SMTP id f14mr13825998pjg.57.1560983534780;
        Wed, 19 Jun 2019 15:32:14 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id g8sm20037687pgd.29.2019.06.19.15.32.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 15:32:14 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH v2 net-next 3/5] ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic
Date:   Wed, 19 Jun 2019 15:31:56 -0700
Message-Id: <20190619223158.35829-4-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190619223158.35829-1-tracywwnj@gmail.com>
References: <20190619223158.35829-1-tracywwnj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

This patch specifically converts the rule lookup logic to honor this
flag and not release refcnt when traversing each rule and calling
lookup() on each routing table.
Similar to previous patch, we also need some special handling of dst
entries in uncached list because there is always 1 refcnt taken for them
even if RT6_LOOKUP_F_DST_NOREF flag is set.

Signed-off-by: Wei Wang <weiwan@google.com>
---
 include/net/ip6_route.h | 10 ++++++++++
 net/ipv6/fib6_rules.c   | 12 +++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 82bced2fc1e3..0709835c01ad 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -94,6 +94,16 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
 	return ip6_route_output_flags(net, sk, fl6, 0);
 }
 
+/* Only conditionally release dst if flags indicates
+ * !RT6_LOOKUP_F_DST_NOREF or dst is in uncached_list.
+ */
+static inline void ip6_rt_put_flags(struct rt6_info *rt, int flags)
+{
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF) ||
+	    !list_empty(&rt->rt6i_uncached))
+		ip6_rt_put(rt);
+}
+
 struct dst_entry *ip6_route_lookup(struct net *net, struct flowi6 *fl6,
 				   const struct sk_buff *skb, int flags);
 struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index bcfae13409b5..d22b6c140f23 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -113,14 +113,15 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
 		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
 			return &rt->dst;
-		ip6_rt_put(rt);
+		ip6_rt_put_flags(rt, flags);
 		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
 		if (rt->dst.error != -EAGAIN)
 			return &rt->dst;
-		ip6_rt_put(rt);
+		ip6_rt_put_flags(rt, flags);
 	}
 
-	dst_hold(&net->ipv6.ip6_null_entry->dst);
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+		dst_hold(&net->ipv6.ip6_null_entry->dst);
 	return &net->ipv6.ip6_null_entry->dst;
 }
 
@@ -237,13 +238,14 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
 			goto out;
 	}
 again:
-	ip6_rt_put(rt);
+	ip6_rt_put_flags(rt, flags);
 	err = -EAGAIN;
 	rt = NULL;
 	goto out;
 
 discard_pkt:
-	dst_hold(&rt->dst);
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+		dst_hold(&rt->dst);
 out:
 	res->rt6 = rt;
 	return err;
-- 
2.22.0.410.gd8fdbe21b5-goog

