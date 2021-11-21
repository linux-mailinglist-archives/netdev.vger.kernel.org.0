Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9110458473
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 16:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbhKUP2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 10:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbhKUP2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 10:28:05 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1AFC061714
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 07:25:00 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id ay10-20020a05600c1e0a00b0033aa12cdd33so1749087wmb.1
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 07:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S9WLe8WKu73eItxI1OPXNsAPfg7p+H6z003Aki7WYfw=;
        b=Y83CKSdVR2h7NLnf+iKLwFqCNKezrpV7eXi6psqDXNcstCsPmZh17PbsPZgfDbRPfH
         ZhZdD9+cAVj9gmmQEnKVnOlMejpN8XWsQNq2HVyEXs52CEdK3r4b7TqnXyP/ePOJtIGF
         UW9HfOA9BNv0+ifout2/fkRJl1nQUFVv/EqXYav3UN35ZY5/nMcvjFeCUEZIjaPKVKz+
         EXLpoXgvsUQQy9K9YhGFiIwErzNl2Tg544hD9iL8sXbsok+XAlh8KM9k2UM+agBLXFUp
         y0uV6Q3kB4YdmPrrKicrWQJxYGV2I6N1UcX9pI1k9du/+s8rsu7gJ8QcsKHpf1W9/sZl
         YX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S9WLe8WKu73eItxI1OPXNsAPfg7p+H6z003Aki7WYfw=;
        b=xuPPFxhn5lj/bs7cmTn4ZR4Tn9PKnMhC3xHUco0XfUV4rZDBNtS2Od+AgZtt8u0P8L
         hHRRSw0FupOd7NAOVerUqB0SnnNaIYSSaY+AXX9t+dlUtL4iE9fb6Zs4SLL91dNeSWeX
         a13kBcvz+uqifdS1AhtQr/UpXkjWnACU4tUVlB52IupgyzJETiesO7sqDtvbJxTranVS
         4ERtmnFC9+1Zp6dVyuQZcftO4cmZ6TyEOPLEjJvQcPLJXrmmaKj9I1I3U+XkwJrNU09D
         lokh1t3+TZUi+JR+Tu+bFGdYLDip+nQigy+OHAP1G9WaFhYXMF8QBxxqPn41uHpUj3Sa
         4RpQ==
X-Gm-Message-State: AOAM530O8b5w14PpSC01n3kifQxpto9qNsB8XFd+s6Z+1dRov0/96VOe
        mSXui7LQSsQYGL5+vZ0ttm8zSrg29oO/ouBv
X-Google-Smtp-Source: ABdhPJy/G3rkYS56XVQd6cLy/idvbyGpKDb0wg2Y+TarmAnzKb3zV8/vNZ9+XaPeD6PemU9f8MjEbA==
X-Received: by 2002:a05:600c:4793:: with SMTP id k19mr21623960wmo.72.1637508298314;
        Sun, 21 Nov 2021 07:24:58 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m36sm7165559wms.25.2021.11.21.07.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 07:24:57 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 2/3] net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group
Date:   Sun, 21 Nov 2021 17:24:52 +0200
Message-Id: <20211121152453.2580051-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211121152453.2580051-1-razor@blackwall.org>
References: <20211121152453.2580051-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When replacing a nexthop group, we must release the IPv6 per-cpu dsts of
the removed nexthop entries after an RCU grace period because they
contain references to the nexthop's net device and to the fib6 info.
With specific series of events[1] we can reach net device refcount
imbalance which is unrecoverable.

[1]
 $ ip nexthop list
  id 200 via 2002:db8::2 dev bridge.10 scope link onlink
  id 201 via 2002:db8::3 dev bridge scope link onlink
  id 203 group 201/200
 $ ip -6 route
  2001:db8::10 nhid 203 metric 1024 pref medium
     nexthop via 2002:db8::3 dev bridge weight 1 onlink
     nexthop via 2002:db8::2 dev bridge.10 weight 1 onlink

Create rt6_info through one of the multipath legs, e.g.:
 $ taskset -a -c 1  ./pkt_inj 24 bridge.10 2001:db8::10
 (pkt_inj is just a custom packet generator, nothing special)

Then remove that leg from the group by replace (let's assume it is id
200 in this case):
 $ ip nexthop replace id 203 group 201

Now remove the IPv6 route:
 $ ip -6 route del 2001:db8::10/128

The route won't be really deleted due to the stale rt6_info holding 1
refcnt in nexthop id 200.
At this point we have the following reference count dependency:
 (deleted) IPv6 route holds 1 reference over nhid 203
 nh 203 holds 1 ref over id 201
 nh 200 holds 1 ref over the net device and the route due to the stale
 rt6_info

Now to create circular dependency between nh 200 and the IPv6 route, and
also to get a reference over nh 200, restore nhid 200 in the group:
 $ ip nexthop replace id 203 group 201/200

And now we have a permanent circular dependncy because nhid 203 holds a
reference over nh 200 and 201, but the route holds a ref over nh 203 and
is deleted.

To trigger the bug just delete the group (nhid 203):
 $ ip nexthop del id 203

It won't really be deleted due to the IPv6 route dependency, and now we
have 2 unlinked and deleted objects that reference each other: the group
and the IPv6 route. Since the group drops the reference it holds over its
entries at free time (i.e. its own refcount needs to drop to 0) that will
never happen and we get a permanent ref on them, since one of the entries
holds a reference over the IPv6 route it will also never be released.

At this point the dependencies are:
 (deleted, only unlinked) IPv6 route holds reference over group nh 203
 (deleted, only unlinked) group nh 203 holds reference over nh 201 and 200
 nh 200 holds 1 ref over the net device and the route due to the stale
 rt6_info

This is the last point where it can be fixed by running traffic through
nh 200, and specifically through the same CPU so the rt6_info (dst) will
get released due to the IPv6 genid, that in turn will free the IPv6
route, which in turn will free the ref count over the group nh 203.

If nh 200 is deleted at this point, it will never be released due to the
ref from the unlinked group 203, it will only be unlinked:
 $ ip nexthop del id 200
 $ ip nexthop
 $

Now we can never release that stale rt6_info, we have IPv6 route with ref
over group nh 203, group nh 203 with ref over nh 200 and 201, nh 200 with
rt6_info (dst) with ref over the net device and the IPv6 route. All of
these objects are only unlinked, and cannot be released, thus they can't
release their ref counts.

 Message from syslogd@dev at Nov 19 14:04:10 ...
  kernel:[73501.828730] unregister_netdevice: waiting for bridge.10 to become free. Usage count = 3
 Message from syslogd@dev at Nov 19 14:04:20 ...
  kernel:[73512.068811] unregister_netdevice: waiting for bridge.10 to become free. Usage count = 3

Fixes: 7bf4796dd099 ("nexthops: add support for replace")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/ipv4/nexthop.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 9e8100728d46..a69a9e76f99f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1899,15 +1899,36 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
 /* if any FIB entries reference this nexthop, any dst entries
  * need to be regenerated
  */
-static void nh_rt_cache_flush(struct net *net, struct nexthop *nh)
+static void nh_rt_cache_flush(struct net *net, struct nexthop *nh,
+			      struct nexthop *replaced_nh)
 {
 	struct fib6_info *f6i;
+	struct nh_group *nhg;
+	int i;
 
 	if (!list_empty(&nh->fi_list))
 		rt_cache_flush(net);
 
 	list_for_each_entry(f6i, &nh->f6i_list, nh_list)
 		ipv6_stub->fib6_update_sernum(net, f6i);
+
+	/* if an IPv6 group was replaced, we have to release all old
+	 * dsts to make sure all refcounts are released
+	 */
+	if (!replaced_nh->is_group)
+		return;
+
+	/* new dsts must use only the new nexthop group */
+	synchronize_net();
+
+	nhg = rtnl_dereference(replaced_nh->nh_grp);
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		struct nh_info *nhi = rtnl_dereference(nhge->nh->nh_info);
+
+		if (nhi->family == AF_INET6)
+			ipv6_stub->fib6_nh_release_dsts(&nhi->fib6_nh);
+	}
 }
 
 static int replace_nexthop_grp(struct net *net, struct nexthop *old,
@@ -2247,7 +2268,7 @@ static int replace_nexthop(struct net *net, struct nexthop *old,
 		err = replace_nexthop_single(net, old, new, extack);
 
 	if (!err) {
-		nh_rt_cache_flush(net, old);
+		nh_rt_cache_flush(net, old, new);
 
 		__remove_nexthop(net, new, NULL);
 		nexthop_put(new);
-- 
2.31.1

