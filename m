Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1796146253
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgAWHMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:12:10 -0500
Received: from relay.sw.ru ([185.231.240.75]:36282 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAWHMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 02:12:10 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1iuWet-0005q4-2q; Thu, 23 Jan 2020 10:12:07 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 6/6] ipv6_route_seq_next should increase position index
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Message-ID: <96ba1cf1-7b88-0b34-4447-7c7752a5b9da@virtuozzo.com>
Date:   Thu, 23 Jan 2020 10:12:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv6/ip6_fib.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 7bae6a9..cfae0a1 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2495,14 +2495,13 @@ static void *ipv6_route_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct net *net = seq_file_net(seq);
 	struct ipv6_route_iter *iter = seq->private;
 
+	++(*pos);
 	if (!v)
 		goto iter_table;
 
 	n = rcu_dereference_bh(((struct fib6_info *)v)->fib6_next);
-	if (n) {
-		++*pos;
+	if (n)
 		return n;
-	}
 
 iter_table:
 	ipv6_route_check_sernum(iter);
@@ -2510,8 +2509,6 @@ static void *ipv6_route_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	r = fib6_walk_continue(&iter->w);
 	spin_unlock_bh(&iter->tbl->tb6_lock);
 	if (r > 0) {
-		if (v)
-			++*pos;
 		return iter->w.leaf;
 	} else if (r < 0) {
 		fib6_walker_unlink(net, &iter->w);
-- 
1.8.3.1

