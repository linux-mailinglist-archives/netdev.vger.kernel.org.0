Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75F4D99A7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436670AbfJPTDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:03:34 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:40484 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436666AbfJPTDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:03:34 -0400
Received: by mail-pf1-f201.google.com with SMTP id r19so19373968pfh.7
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 12:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OXRiIHrusFcEZCWkh4tV2rZcXknLX4rp2p782/26c0I=;
        b=iratWK4eC3qBI7Pbi+o7xWy/BIKB1j0hSjDdzwHuoQhnasFXdGH0WEbCEhAF6scMI8
         ck0Bja61WWKskMyhsLdEWEGQVIU90MBcdyLGDx5VPfE4YIly0C33b+uIB87x/jlHqGrC
         eeh2BLVjIZREpiiuk0mrrCAUWO9gnenDYhEqcrVfGYs7KaKExuLfNtSAlH5b76LngCSy
         4v6OtkFDY2ZjgmCZHF+wZmj2gBs7p5dAapLddvcPvsKyYTMcdm9baNq+cQld7MPMYZ6D
         xYS8YyzOHZ0EKWjomDFpxs7CuodQ/4tYjEIdzMcyzYg1di2NAoQcX5FdNKM+Zy2onFJG
         EpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OXRiIHrusFcEZCWkh4tV2rZcXknLX4rp2p782/26c0I=;
        b=SUiu5NlvIlW3QNtV+hqiCUqeHkXaBuF46xPuh1IKpLpXnblg7cguSd1OSTWl0ysIkW
         nvOZwynQK0YO/YqFXyqn/HHcYIwEK1OjcJrNC0SolISrPBxpg/xVCU/7Pw8Vr9nVoTHC
         wEiexGJ6s7+GXWyewwQUN+K4llQoaHH3lwez7rTf0pFe/mQyODhDiQFWyzCY97T8G4Gt
         GVe3PCFjL5SntZMemxUxqXoLPcg6BUv1uTXRcThRzJUm5HKsxIlaRyw/ugXwDeMhb3Se
         2IXDuA+mzsmkGAgyCy/YQh05flm+9hTXqr731S1YE18FmHLjHQKXwHXn39x+QzY0Cr0C
         rKSg==
X-Gm-Message-State: APjAAAXkVhdR3VQkQCv5cvZec1YVt/zad6l98a8J/9CmD95ObrQT8Gb4
        DB20lD6ZD5qlUHGHEiiX2l5a6HSKH9o=
X-Google-Smtp-Source: APXvYqxpCeJsJDwajnvcwAOC3fo2di2U80SUYVv+NRfVW25nQYDNbNePkdarMwfuCDUwGkpCOBqSYdtdOwQ=
X-Received: by 2002:a63:f250:: with SMTP id d16mr45726366pgk.165.1571252612906;
 Wed, 16 Oct 2019 12:03:32 -0700 (PDT)
Date:   Wed, 16 Oct 2019 12:03:15 -0700
Message-Id: <20191016190315.151095-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net] ipv4: fix race condition between route lookup and invalidation
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wei Wang <weiwan@google.com>, Ido Schimmel <idosch@idosch.org>,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesse and Ido reported the following race condition:
<CPU A, t0> - Received packet A is forwarded and cached dst entry is
taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()

<t1> - Given Jesse has busy routers ("ingesting full BGP routing tables
from multiple ISPs"), route is added / deleted and rt_cache_flush() is
called

<CPU B, t2> - Received packet B tries to use the same cached dst entry
from t0, but rt_cache_valid() is no longer true and it is replaced in
rt_cache_route() by the newer one. This calls dst_dev_put() on the
original dst entry which assigns the blackhole netdev to 'dst->dev'

<CPU A, t3> - dst_input(skb) is called on packet A and it is dropped due
to 'dst->dev' being the blackhole netdev

There are 2 issues in the v4 routing code:
1. A per-netns counter is used to do the validation of the route. That
means whenever a route is changed in the netns, users of all routes in
the netns needs to redo lookup. v6 has an implementation of only
updating fn_sernum for routes that are affected.
2. When rt_cache_valid() returns false, rt_cache_route() is called to
throw away the current cache, and create a new one. This seems
unnecessary because as long as this route does not change, the route
cache does not need to be recreated.

To fully solve the above 2 issues, it probably needs quite some code
changes and requires careful testing, and does not suite for net branch.

So this patch only tries to add the deleted cached rt into the uncached
list, so user could still be able to use it to receive packets until
it's done.

Fixes: 95c47f9cf5e0 ("ipv4: call dst_dev_put() properly")
Signed-off-by: Wei Wang <weiwan@google.com>
Reported-by: Ido Schimmel <idosch@idosch.org>
Reported-by: Jesse Hathaway <jesse@mbuki-mvuki.org>
Tested-by: Jesse Hathaway <jesse@mbuki-mvuki.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Cc: David Ahern <dsahern@gmail.com>

---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 14654876127e..9e0c8dff2cd6 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common *nhc, struct rtable *rt)
 	prev = cmpxchg(p, orig, rt);
 	if (prev == orig) {
 		if (orig) {
-			dst_dev_put(&orig->dst);
+			rt_add_uncached_list(orig);
 			dst_release(&orig->dst);
 		}
 	} else {
-- 
2.23.0.700.g56cf767bdb-goog

