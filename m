Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB00045911B
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239766AbhKVPSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239755AbhKVPSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:18:32 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F93C06173E
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:15:25 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id v1so44903544edx.2
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pftb0Lsb1bJIdCK96aoAVJ6JA25jDDfs3VUOFrqF600=;
        b=NkJe4OTWS5s5LRfXZS2bbun5l7burQiFRsnlsan9br72iBJRjWQ9a/hFQYsNzPpCjh
         jr03+U/3i6xK8WyWBQyoZXq433ZU2e/xLiUVkY8AfMWHpFQffyKVXZcL6SXX+S049+Q7
         7K5S2ctpR3m7FSW3u3E7QW5pry1whRCqu8FMgqTBLma65M50+S2HmfiRGJt3dft4r6+r
         yZniQW5g2Kemdwmt4+GnsGahhCHLgKcSk3gOArVOlpMHIWsBzqn+NoMIpqdy9nWL4iZ+
         4uxYWRQllIvdaWV0VVkjzHZD31cPjQb6k5pNmqFSv3VbmcZp1f/4XBfsZNuVWiFNDgO2
         o1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pftb0Lsb1bJIdCK96aoAVJ6JA25jDDfs3VUOFrqF600=;
        b=M9iTsRNgArt3sIKseVGQSGdQIJlP0+mZ/3Dh3eUL1d521OIVsBYa42LB+N9NFQFmKR
         gOI2oMi1GQ64mzTKBmhm2IlNBrbm9g2YfjQ5k+sMt/mm9Zk4xgiEcFHYO1WYQfe/AI0a
         ILkIJhGJy0ffZfaJ+fqQaipBOKhscJRe+Tn0DX8hFLASBTv2Ju2GqIOyTDQQSqtfp1QQ
         YzyJIQaHBBHsA8qPIT3LIC3I3RRV5JaySDwIzZfaBtRp2uUKZkshIzwHmnJ7I6yplC4d
         c4hhs0MCZ4ez3RxpmhV9u0IcyShj90LLUBT+UM+8RJexJGPnx4JNBYoXeEnmGryJkY3U
         cOHg==
X-Gm-Message-State: AOAM532j6O6oU2vuVEvU8da3QC5b8bgTH7V2mkGG2/mgwcdJ+jjra5yJ
        y4zHDAEfIaZPykTDG0UhFEXYTSnexoAN9Nm5
X-Google-Smtp-Source: ABdhPJxzRtmw8pRquQAAKgOiy7yYpOsUuTVe4iJ4f0f5MBCAm3jGg9Yu1vQH8y/gU34UIMQfc40O5w==
X-Received: by 2002:a17:907:7094:: with SMTP id yj20mr41049042ejb.265.1637594121513;
        Mon, 22 Nov 2021 07:15:21 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id qb21sm3906904ejc.78.2021.11.22.07.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:15:21 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net v2 2/3] net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group
Date:   Mon, 22 Nov 2021 17:15:13 +0200
Message-Id: <20211122151514.2813935-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122151514.2813935-1-razor@blackwall.org>
References: <20211122151514.2813935-1-razor@blackwall.org>
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
imbalance which is unrecoverable. IPv4 is not affected because dsts
don't take a refcount on the route.

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
v2: added information about why IPv4 is not affected to the
    commit msg, no changes to the patch

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

