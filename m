Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27063994A
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbfFGXGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729725AbfFGXGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 19:06:12 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E95AA208C0;
        Fri,  7 Jun 2019 23:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559948772;
        bh=W05UqUHRYiEErzbhqWxdkUKmVuDbJXkZXt4dpOgeDS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcmskL8x3p1KB+/aD5oG9BkgjTbnCxUCAeyp2o2eoxLb8ua8PTaO9rihVTZOMrCMj
         LaLXFzF0nw8mfTZFZen0QMP2STq5kt5DMdxmknZxsQLHioedsY2/xKHhSIngXlgngf
         NzYWhzodtW6biJGlaM/kHxr2V7alHM9Ua8RJtPzY=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 02/20] ipv6: Handle all fib6_nh in a nexthop in fib6_drop_pcpu_from
Date:   Fri,  7 Jun 2019 16:05:52 -0700
Message-Id: <20190607230610.10349-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607230610.10349-1-dsahern@kernel.org>
References: <20190607230610.10349-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Use nexthop_for_each_fib6_nh to walk all fib6_nh in a nexthop when
dropping 'from' reference in pcpu routes.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/ip6_fib.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 02feda73a98e..fe326402cc0e 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -910,19 +910,42 @@ static void __fib6_drop_pcpu_from(struct fib6_nh *fib6_nh,
 	}
 }
 
+struct fib6_nh_pcpu_arg {
+	struct fib6_info	*from;
+	const struct fib6_table *table;
+};
+
+static int fib6_nh_drop_pcpu_from(struct fib6_nh *nh, void *_arg)
+{
+	struct fib6_nh_pcpu_arg *arg = _arg;
+
+	__fib6_drop_pcpu_from(nh, arg->from, arg->table);
+	return 0;
+}
+
 static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 				const struct fib6_table *table)
 {
-	struct fib6_nh *fib6_nh;
-
 	/* Make sure rt6_make_pcpu_route() wont add other percpu routes
 	 * while we are cleaning them here.
 	 */
 	f6i->fib6_destroying = 1;
 	mb(); /* paired with the cmpxchg() in rt6_make_pcpu_route() */
 
-	fib6_nh = f6i->fib6_nh;
-	__fib6_drop_pcpu_from(fib6_nh, f6i, table);
+	if (f6i->nh) {
+		struct fib6_nh_pcpu_arg arg = {
+			.from = f6i,
+			.table = table
+		};
+
+		nexthop_for_each_fib6_nh(f6i->nh, fib6_nh_drop_pcpu_from,
+					 &arg);
+	} else {
+		struct fib6_nh *fib6_nh;
+
+		fib6_nh = f6i->fib6_nh;
+		__fib6_drop_pcpu_from(fib6_nh, f6i, table);
+	}
 }
 
 static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
-- 
2.11.0

