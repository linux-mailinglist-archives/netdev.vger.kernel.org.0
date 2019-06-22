Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2344F2E0
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 02:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfFVApo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 20:45:44 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:38545 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFVApo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 20:45:44 -0400
Received: by mail-vk1-f201.google.com with SMTP id u202so3100800vku.5
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 17:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mmP+fV5cy5/NoNcNYiiJaN4iM05M45CWe+WxnFdBezM=;
        b=vEOAzobq3y+X9MlSV5eP2oe7+N/g/Mm5mbcvStpzbrIpiAu1+QMLLrmBwChpivj9k3
         C5IYWaoWIeye1hV6xBD3nB1eZeIh0f4Q3nq3m5pVFWn5yydfezPDohwVzwA0iKPUc9qX
         amYKb+ItYz7jdAcUB4mxW7oB34fN+NlHtoVLuOWH0JBT9cMHIJkuBk+PPb7yevfLDp7i
         kgeacW9SJsU6fQcxtxGeiSemr7Npv3uhnKk6bVgLp7EsExud4KEMEOOqEsWy+f7l46M7
         E5vebr6d2NW//CZgLPAnTy+jBrUlAQXCE+4XS+VpLAV32Wy6wLmur8UvZWZhcXXDxtIM
         E/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mmP+fV5cy5/NoNcNYiiJaN4iM05M45CWe+WxnFdBezM=;
        b=WC03sktIBJICuj8gZc0+zyJl2cqUC/qhPYuhANdMH86qqx1Qtugr1FbFS85VMetboj
         3WdIr5wqQF1ze4dfTY1S2yVgyUI1wE9uECky+okguSjjZLBqkYSdS2+uRFUZUmPTIR2j
         1vaKfbDOdvATPRaAhMEx/bvbNi1Dv9PWkxbqancBaMgP/RapgNq2+FMIHrJvXFV2eE6G
         jmyKH5KDyzOKAoJeJJFmoBLS8pw7QRE0knqSY8eXfVnDJInTWFuaBW+Lq6zYk6JeqeUz
         UO2G1wT3ATel0MbsBaiVPKvkC77FU6v/1F0VJkbi7sJ6+U7c5CfRKKQXdFu4rkph8kGU
         qFTQ==
X-Gm-Message-State: APjAAAWsw26SaLGCy7j90dUt0CpBNxOyHoXUvI9OAPVh7EFjSocniwea
        Vf0xVbMTdcKVgurZwV/hXTpcw4Wx+bAu0whG9TWcnYXmglJraRdUhLs2/Tex4Sh4DHVCJ2EAmFT
        uq66Fw936PozpjlpHPSoFCRUqq+ubau3mOZL9E4qlK5GXHvdmorIB1C4hdFSHj2S5
X-Google-Smtp-Source: APXvYqyi+EaWy1QpXiWZ0XOHMgKgC0UDooCGjJLuZj7kFLt5A1gQcQz7cEZseuTzcuf6vfsJhGLn5gZggM9r
X-Received: by 2002:ab0:30c7:: with SMTP id c7mr23676228uam.143.1561164338200;
 Fri, 21 Jun 2019 17:45:38 -0700 (PDT)
Date:   Fri, 21 Jun 2019 17:45:34 -0700
Message-Id: <20190622004534.91201-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH next 2/3] blackhole_netdev: use blackhole_netdev to invalidate
 dst entries
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use blackhole_netdev instead of 'lo' device with lower MTU when marking
dst "dead".

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 net/core/dst.c   | 2 +-
 net/ipv4/route.c | 3 +--
 net/ipv6/route.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index e46366228eaf..1325316d9eab 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -160,7 +160,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev, true);
 	dst->input = dst_discard;
 	dst->output = dst_discard_out;
-	dst->dev = dev_net(dst->dev)->loopback_dev;
+	dst->dev = blackhole_netdev;
 	dev_hold(dst->dev);
 	dev_put(dev);
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 66cbe8a7a168..049af0f88307 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1532,7 +1532,6 @@ static void ipv4_dst_destroy(struct dst_entry *dst)
 
 void rt_flush_dev(struct net_device *dev)
 {
-	struct net *net = dev_net(dev);
 	struct rtable *rt;
 	int cpu;
 
@@ -1543,7 +1542,7 @@ void rt_flush_dev(struct net_device *dev)
 		list_for_each_entry(rt, &ul->head, rt_uncached) {
 			if (rt->dst.dev != dev)
 				continue;
-			rt->dst.dev = net->loopback_dev;
+			rt->dst.dev = blackhole_netdev;
 			dev_hold(rt->dst.dev);
 			dev_put(dev);
 		}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c4d285fe0adc..335bcf812b25 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -176,7 +176,7 @@ static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 			}
 
 			if (rt_dev == dev) {
-				rt->dst.dev = loopback_dev;
+				rt->dst.dev = blackhole_netdev;
 				dev_hold(rt->dst.dev);
 				dev_put(rt_dev);
 			}
-- 
2.22.0.410.gd8fdbe21b5-goog

