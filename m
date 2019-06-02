Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8643230E
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 13:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFBLKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 07:10:34 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35577 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfFBLKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 07:10:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id s27so988534pgl.2
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 04:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5TTMOLEScgSAihfdLvAGl84YJi5CxuK7So96A+cIHzY=;
        b=NTobo7+gMynjEJ93tTzN3h/usCaJWB6UKsXVa9R8vldO/9RHx2WO2JbqPelrYZUgZs
         nZz0Wqg5NhV4Dqj3/Zo8go4RMOGbd7O7mWQ1pGJkHpyjF5IvgCNnwkF49J915Wik1cAj
         /Sk52/XEcfYWNxSyBNTNjZAmhBk5/yPoI01FsteuaseLMFRkzLuUeECD3ZONkj+X4ZWt
         /lOf/AuT1A7jQ1GR/SmV4uNxb8N7J2DHMhvB8YrT7H+gOat/k9pkLtcBtqtjgDRsEWmj
         KkvfUVFr/dGkQYw16HUSqGHsiIbCqj4ueEp9RhKy2LPO0220JIz6+AUf3vgk87L6q/DV
         QMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5TTMOLEScgSAihfdLvAGl84YJi5CxuK7So96A+cIHzY=;
        b=UmhA4JAItauob0i2ttan7CcOWXFbsjmqzpNzWu9op6EIhCgRN7F+VQSk5/s3EnDrhT
         jx8OJjTUGeyzWGV10bX9QbAczStCcHbPN1QfrgJIbTfBZCaKhO4+3ZA3ak3jumxgsRWE
         3e65TlpoHL7/TEXXHzHO/gl9e7/s0TQdmn5+nQsLZYf+hS9EPvXfGnr2bDpyHnfddITx
         xovoeMJzKaPJRQR7B3WOs0CBwEQ2xB/pn7+nmyexkwSxAn92mR6a9k/ijYpADdmyYsbL
         cxcX1jDe9/11lnaPs6Yr7KYkIQw0wN/ltRCd42A9e7u4H36NuHCs45tJ7vGKC1+/0ONl
         8fJw==
X-Gm-Message-State: APjAAAV3p8h1/nKtdC/+VahUJAbH4dg1NgNsRNhsQy+rjC4l6ffl39Uq
        4524HVBaptRCirZU0pplwxyt3T68
X-Google-Smtp-Source: APXvYqwj1V+P8IHOyKfii0DV5eyL5lLuPo5Dm4SkDAYH9y7RDMKJlKdjBwhDuiPu61DtL1S5LHIuGQ==
X-Received: by 2002:a63:5d45:: with SMTP id o5mr21394955pgm.40.1559473832878;
        Sun, 02 Jun 2019 04:10:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d35sm9367999pgb.55.2019.06.02.04.10.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 04:10:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv4: not do cache for local delivery if bc_forwarding is enabled
Date:   Sun,  2 Jun 2019 19:10:24 +0800
Message-Id: <9b4ce2be76ea7a635fe431ec42a784db0196a5a0.1559473824.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the topo:

    h1 ---| rp1            |
          |     route  rp3 |--- h3 (192.168.200.1)
    h2 ---| rp2            |

If rp1 bc_forwarding is set while rp2 bc_forwarding is not, after
doing "ping 192.168.200.255" on h1, then ping 192.168.200.255 on
h2, and the packets can still be forwared.

This issue was caused by the input route cache. It should only do
the cache for either bc forwarding or local delivery. Otherwise,
local delivery can use the route cache for bc forwarding of other
interfaces.

This patch is to fix it by not doing cache for local delivery if
all.bc_forwarding is enabled.

Note that we don't fix it by checking route cache local flag after
rt_cache_valid() in "local_input:" and "ip_mkroute_input", as the
common route code shouldn't be touched for bc_forwarding.

Fixes: 5cbf777cfdf6 ("route: add support for directed broadcast forwarding")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/route.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 11ddc27..91bf75b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1985,7 +1985,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	u32		itag = 0;
 	struct rtable	*rth;
 	struct flowi4	fl4;
-	bool do_cache;
+	bool do_cache = true;
 
 	/* IP on this device is disabled. */
 
@@ -2062,6 +2062,9 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (res->type == RTN_BROADCAST) {
 		if (IN_DEV_BFORWARD(in_dev))
 			goto make_route;
+		/* not do cache if bc_forwarding is enabled */
+		if (IPV4_DEVCONF_ALL(net, BC_FORWARDING))
+			do_cache = false;
 		goto brd_input;
 	}
 
@@ -2099,18 +2102,15 @@ out:	return err;
 	RT_CACHE_STAT_INC(in_brd);
 
 local_input:
-	do_cache = false;
-	if (res->fi) {
-		if (!itag) {
-			struct fib_nh_common *nhc = FIB_RES_NHC(*res);
+	do_cache &= res->fi && !itag;
+	if (do_cache) {
+		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
 
-			rth = rcu_dereference(nhc->nhc_rth_input);
-			if (rt_cache_valid(rth)) {
-				skb_dst_set_noref(skb, &rth->dst);
-				err = 0;
-				goto out;
-			}
-			do_cache = true;
+		rth = rcu_dereference(nhc->nhc_rth_input);
+		if (rt_cache_valid(rth)) {
+			skb_dst_set_noref(skb, &rth->dst);
+			err = 0;
+			goto out;
 		}
 	}
 
-- 
2.1.0

