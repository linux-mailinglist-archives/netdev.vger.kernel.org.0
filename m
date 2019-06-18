Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEC94A9C7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbfFRS0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:26:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45294 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRS0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:26:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so8131181pfq.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZBRiDHj2Qi4Q8hZbrg7ij7OVMKRMOh5DuaaYEMelFvk=;
        b=dd/okHKQEJK9fBmiN+68X/nPxl70q4G6aY7miQDoqqYPfD2EdADjMYQlW0+TCeETxV
         nO4IJ5E6qnLbYgbSKltfIKoLmO8CMxV11Tw5Y+yW0SYoTBiNhkIdv0Qs74V0aWXVaxRf
         n5Il1suFZlPUcjvZlQovqvxo/fiagTr4TjCunDAWNDa9z8YGQQMvjrchkRc17ZKt3zrB
         S0gJS2f7v3Fxm8UNX0xqUrA+GZAY3qBwe0tMt2DBh7jjV7Ocf5RpMI24hnXcuzKE9jb7
         ey/isAZYF5eQgWYAbiO7X+jdFq0+e2Qd6GNCiXsNvWb8kZ4T96SQKk69y2nH2ek7fL5Z
         DIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBRiDHj2Qi4Q8hZbrg7ij7OVMKRMOh5DuaaYEMelFvk=;
        b=O1r89EUZIabYhBJLKyHzffl835ssxDDRk5GxRgBwQ4ACnaryCczk9yCYu3PpB4bg1Z
         OqC4Pyqi5yo5uEbz5SfHvs0WU5ayEuKfoWjBAlegD5/1GMl0gef/EuMaFYuTrsj7H6SB
         h3wYP8hBHkskgByMmuvVsYjcnweQtd5+4UxL1rB0ys2ZZaoFnQ2HRAqw9zkPTmoWCE0i
         aZrG6x6xde0Rs9Yc0yiIjl8JCtKoVcfgfYOB2Yriv5UzsVR2fkCxGhTigefdu4/ya3zU
         VwQPrm4iveU9wFfZdO5JVWWTfNlbZlN6D/B91Nzi2gaRr8CbkQSfuDoktz98rKk6N7hC
         241Q==
X-Gm-Message-State: APjAAAX2RpVIyXPIj/3qbuqyeml3eyrcWFJNLX1e6FDGLxhoTl4bCWdw
        ry4FJxj0AweBrq/oddItZ44=
X-Google-Smtp-Source: APXvYqwFNm1wbbiSmKs/akJGfM8rbTKsg7B9ZM0jQ+LN5/9ZdlLN8vtetk3liHp64j98WYef7a86+Q==
X-Received: by 2002:a63:e14:: with SMTP id d20mr3930438pgl.264.1560882382112;
        Tue, 18 Jun 2019 11:26:22 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id h6sm2845859pjs.2.2019.06.18.11.26.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 11:26:21 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH net-next 2/5] ipv6: initialize rt6->rt6i_uncached in all pre-allocated dst entries
Date:   Tue, 18 Jun 2019 11:25:40 -0700
Message-Id: <20190618182543.65477-3-tracywwnj@gmail.com>
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

Initialize rt6->rt6i_uncached on the following pre-allocated dsts:
net->ipv6.ip6_null_entry
net->ipv6.ip6_prohibit_entry
net->ipv6.ip6_blk_hole_entry

This is a preparation patch for later commits to be able to distinguish
dst entries in uncached list by doing:
!list_empty(rt6->rt6i_uncached)

Signed-off-by: Wei Wang <weiwan@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 net/ipv6/route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9dcbc56e4151..33dc8af9a4bf 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6010,6 +6010,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.ip6_null_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_null_entry->dst,
 			 ip6_template_metrics, true);
+	INIT_LIST_HEAD(&net->ipv6.ip6_null_entry->rt6i_uncached);
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	net->ipv6.fib6_has_custom_rules = false;
@@ -6021,6 +6022,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.ip6_prohibit_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_prohibit_entry->dst,
 			 ip6_template_metrics, true);
+	INIT_LIST_HEAD(&net->ipv6.ip6_prohibit_entry->rt6i_uncached);
 
 	net->ipv6.ip6_blk_hole_entry = kmemdup(&ip6_blk_hole_entry_template,
 					       sizeof(*net->ipv6.ip6_blk_hole_entry),
@@ -6030,6 +6032,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.ip6_blk_hole_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_blk_hole_entry->dst,
 			 ip6_template_metrics, true);
+	INIT_LIST_HEAD(&net->ipv6.ip6_blk_hole_entry->rt6i_uncached);
 #endif
 
 	net->ipv6.sysctl.flush_delay = 0;
-- 
2.22.0.410.gd8fdbe21b5-goog

