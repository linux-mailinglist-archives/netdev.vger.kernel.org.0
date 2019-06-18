Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8824A9C8
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbfFRS0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:26:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45625 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRS0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:26:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id bi6so6037512plb.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KZfn7NbJ04uTddCXuYKWyb5rgFZ6AjmZM0F8GgNTxFM=;
        b=Qq4NCp6Dc2YYF/+3mWlep94OvEJJYVemx3i9A5v3zFi/CIzMMTW9Za0FVn0BY9I0aM
         PdX3KiIcG7e/Feh+WD3Vm6igPVxjAUSzF25zkio7FM5YUZ8ZkEbHweQxLahLW4ZsC19L
         /c70BkGQIA7FraoWkhetGsQG0OKgwJ6e7Bb3BUc+pRYL6orLMgkE5sE7yroCvqK/MRM+
         0iwVqWnd4T0f7UcazyUgTDkwyKsKkZf8KFKG6o29zHICViSz72G4oAKN3mVEEElowHcx
         piSX02fgviqk4uxOSxV2JtqfDjjlbS1v5RZ+U4JFHlbWA0KomDKrAgPX5SyYRvWSWhTm
         jlYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZfn7NbJ04uTddCXuYKWyb5rgFZ6AjmZM0F8GgNTxFM=;
        b=f0sna8apSKc+G4PVdSwDNGyjf/y9YvH/cKxWufjpj6CXKYOX3V131qbapMGzdYl1l+
         PT8UY0UJ46VGvcu+PbbiXkU8YCFinLjAB1yB01Kh5Qr/b5zSDyr2vI/gDJMrFxO9XvTE
         xX3eGOaiULkbtnom4Cin0APM2JjLcrroa5lBEt5F8rxSBAMfJDQgmio4JaGtGosTrsW+
         L8izqlEctPZxDDWjrYBHYVBA4nYtTaPtqjz84kXA8OzRE6JvAXUJN1T42/6t03E+XzS/
         XXcXjJ1TJZAK3rXr/4McCqZnAmw1HapiDfAmuG07jV/uPweQg1alXblyhcDHSSTtB26f
         y+/Q==
X-Gm-Message-State: APjAAAU8BoC4wsnIRHkUOG8cm1gtgcOP8ncgZfIh+N848g03fQfpbeEl
        j3jDGw/4ZGqDI8pdWwUuHUM=
X-Google-Smtp-Source: APXvYqzUKQa+1J6LnWRJBz5+gcw2CUmhebn4DN3Z4PgSnDAd9Hrhxy6fp3Bt2I8gkKTM5GPrccckZw==
X-Received: by 2002:a17:902:8489:: with SMTP id c9mr35169074plo.327.1560882384028;
        Tue, 18 Jun 2019 11:26:24 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id h6sm2845859pjs.2.2019.06.18.11.26.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 11:26:23 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH net-next 3/5] ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic
Date:   Tue, 18 Jun 2019 11:25:41 -0700
Message-Id: <20190618182543.65477-4-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190618182543.65477-1-tracywwnj@gmail.com>
References: <20190618182543.65477-1-tracywwnj@gmail.com>
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
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 net/ipv6/fib6_rules.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index bcfae13409b5..9bbcf550cceb 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -113,14 +113,17 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
 		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
 			return &rt->dst;
-		ip6_rt_put(rt);
+		if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+			ip6_rt_put(rt);
 		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
 		if (rt->dst.error != -EAGAIN)
 			return &rt->dst;
-		ip6_rt_put(rt);
+		if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+			ip6_rt_put(rt);
 	}
 
-	dst_hold(&net->ipv6.ip6_null_entry->dst);
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+		dst_hold(&net->ipv6.ip6_null_entry->dst);
 	return &net->ipv6.ip6_null_entry->dst;
 }
 
@@ -237,13 +240,16 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
 			goto out;
 	}
 again:
-	ip6_rt_put(rt);
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF) ||
+	    !list_empty(&rt->rt6i_uncached))
+		ip6_rt_put(rt);
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

