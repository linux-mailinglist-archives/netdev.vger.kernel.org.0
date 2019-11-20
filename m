Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3A0103A4E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfKTMsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:48:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51040 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728459AbfKTMsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:48:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574254087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qbbsDCU2VwsB/j2EHAUYMYkzBAQaeUa7hXJzaSJuZjI=;
        b=DJ0NfOqLpSra8YYwSoeRZ9xqAwZZ0B4QNSlzQQkJbJujmLXnA04YwdDKo5/AirnqS6ZSFN
        7+xM7NcqocDdRwwcEocpCIwM8ufN11gIVGT9jli7tcQzz3hLYKOywTnilNuAUKhmiaNhMq
        Nf/mAg19E9w3xBXvjG8EV4CZUsY4Kn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-PPaFM9lRNYOA51agP7GJ_w-1; Wed, 20 Nov 2019 07:48:03 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0060E80247F;
        Wed, 20 Nov 2019 12:48:02 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-23.ams2.redhat.com [10.36.117.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8484E2CA76;
        Wed, 20 Nov 2019 12:48:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next v4 2/5] ipv6: keep track of routes using src
Date:   Wed, 20 Nov 2019 13:47:34 +0100
Message-Id: <8e2c5bdc1b81e411da76df89cd9c13be2869ea2d.1574252982.git.pabeni@redhat.com>
In-Reply-To: <cover.1574252982.git.pabeni@redhat.com>
References: <cover.1574252982.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: PPaFM9lRNYOA51agP7GJ_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a per namespace counter, increment it on successful creation
of any route using the source address, decrement it on deletion
of such routes.

This allows us to check easily if the routing decision in the
current namespace depends on the packet source. Will be used
by the next patch.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/ip6_fib.h    | 30 ++++++++++++++++++++++++++++++
 include/net/netns/ipv6.h |  3 +++
 net/ipv6/ip6_fib.c       |  4 ++++
 net/ipv6/route.c         |  3 +++
 4 files changed, 40 insertions(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 8ac3a59e5126..f1535f172935 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -90,7 +90,32 @@ struct fib6_gc_args {
=20
 #ifndef CONFIG_IPV6_SUBTREES
 #define FIB6_SUBTREE(fn)=09NULL
+
+static inline bool fib6_routes_require_src(const struct net *net)
+{
+=09return false;
+}
+
+static inline void fib6_routes_require_src_inc(struct net *net) {}
+static inline void fib6_routes_require_src_dec(struct net *net) {}
+
 #else
+
+static inline bool fib6_routes_require_src(const struct net *net)
+{
+=09return net->ipv6.fib6_routes_require_src > 0;
+}
+
+static inline void fib6_routes_require_src_inc(struct net *net)
+{
+=09net->ipv6.fib6_routes_require_src++;
+}
+
+static inline void fib6_routes_require_src_dec(struct net *net)
+{
+=09net->ipv6.fib6_routes_require_src--;
+}
+
 #define FIB6_SUBTREE(fn)=09(rcu_dereference_protected((fn)->subtree, 1))
 #endif
=20
@@ -212,6 +237,11 @@ static inline struct inet6_dev *ip6_dst_idev(struct ds=
t_entry *dst)
 =09return ((struct rt6_info *)dst)->rt6i_idev;
 }
=20
+static inline bool fib6_requires_src(const struct fib6_info *rt)
+{
+=09return rt->fib6_src.plen > 0;
+}
+
 static inline void fib6_clean_expires(struct fib6_info *f6i)
 {
 =09f6i->fib6_flags &=3D ~RTF_EXPIRES;
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 022a0fd1a5a4..5ec054473d81 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -83,6 +83,9 @@ struct netns_ipv6 {
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 =09unsigned int=09=09fib6_rules_require_fldissect;
 =09bool=09=09=09fib6_has_custom_rules;
+#ifdef CONFIG_IPV6_SUBTREES
+=09unsigned int=09=09fib6_routes_require_src;
+#endif
 =09struct rt6_info         *ip6_prohibit_entry;
 =09struct rt6_info         *ip6_blk_hole_entry;
 =09struct fib6_table       *fib6_local_tbl;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index f66bc2af4e9d..7bae6a91b487 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1461,6 +1461,8 @@ int fib6_add(struct fib6_node *root, struct fib6_info=
 *rt,
 =09=09}
 #endif
 =09=09goto failure;
+=09} else if (fib6_requires_src(rt)) {
+=09=09fib6_routes_require_src_inc(info->nl_net);
 =09}
 =09return err;
=20
@@ -1933,6 +1935,8 @@ int fib6_del(struct fib6_info *rt, struct nl_info *in=
fo)
 =09=09struct fib6_info *cur =3D rcu_dereference_protected(*rtp,
 =09=09=09=09=09lockdep_is_held(&table->tb6_lock));
 =09=09if (rt =3D=3D cur) {
+=09=09=09if (fib6_requires_src(cur))
+=09=09=09=09fib6_routes_require_src_dec(info->nl_net);
 =09=09=09fib6_del_route(table, fn, rtp, info);
 =09=09=09return 0;
 =09=09}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index edcb52543518..c92b367e058d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6199,6 +6199,9 @@ static int __net_init ip6_route_net_init(struct net *=
net)
 =09dst_init_metrics(&net->ipv6.ip6_blk_hole_entry->dst,
 =09=09=09 ip6_template_metrics, true);
 =09INIT_LIST_HEAD(&net->ipv6.ip6_blk_hole_entry->rt6i_uncached);
+#ifdef CONFIG_IPV6_SUBTREES
+=09net->ipv6.fib6_routes_require_src =3D 0;
+#endif
 #endif
=20
 =09net->ipv6.sysctl.flush_delay =3D 0;
--=20
2.21.0

