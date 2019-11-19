Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD371026F6
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfKSOjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:39:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26806 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727646AbfKSOjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 09:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574174361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kj22VKfuPr8xgWn5ytNLFUh9Sf0VXmp37QTREguHOug=;
        b=HfcQuj2N7ZSYxqQRC0BMA4cei0GtagcTMTkXB4+yDiSxc708C5CBAOHEMhYcpjFVj0kfNM
        DlChEQjDMOvyCceA0SIw/WaQjgsIIaseWXlKTeiptQ25D594nQhgIAzkq8ET/2PSiFRkFa
        CWGRbRM/JxmpiTH0+yjbeH10HZub1ds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-b5OpI-krNNqjVCpQe-pdpQ-1; Tue, 19 Nov 2019 09:39:19 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C938410CE7BE;
        Tue, 19 Nov 2019 14:39:18 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BF766058D;
        Tue, 19 Nov 2019 14:39:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3 1/2] ipv6: introduce and uses route look hints for list input
Date:   Tue, 19 Nov 2019 15:38:36 +0100
Message-Id: <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
In-Reply-To: <cover.1574165644.git.pabeni@redhat.com>
References: <cover.1574165644.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: b5OpI-krNNqjVCpQe-pdpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing RX batch packet processing, we currently always repeat
the route lookup for each ingress packet. If policy routing is
configured, and IPV6_SUBTREES is disabled at build time, we
know that packets with the same destination address will use
the same dst.

This change tries to avoid per packet route lookup caching
the destination address of the latest successful lookup, and
reusing it for the next packet when the above conditions are
in place. Ingress traffic for most servers should fit.

The measured performance delta under UDP flood vs a recvmmsg
receiver is as follow:

vanilla=09=09patched=09=09delta
Kpps=09=09Kpps=09=09%
1431=09=091674=09=09+17

In the worst-case scenario - each packet has a different
destination address - the performance delta is within noise
range.

v2 -> v3:
 - add fib6_has_custom_rules() helpers (David A.)
 - add ip6_extract_route_hint() helper (Edward C.)
 - use hint directly in ip6_list_rcv_finish() (Willem)

v1 -> v2:
 - fix build issue with !CONFIG_IPV6_MULTIPLE_TABLES
 - fix potential race when fib6_has_custom_rules is set
   while processing a packet batch

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/ip6_fib.h |  9 +++++++++
 net/ipv6/ip6_input.c  | 26 ++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 5d1615463138..9ab60611b97b 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -502,6 +502,11 @@ static inline bool fib6_metric_locked(struct fib6_info=
 *f6i, int metric)
 }
=20
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
+static inline bool fib6_has_custom_rules(struct net *net)
+{
+=09return net->ipv6.fib6_has_custom_rules;
+}
+
 int fib6_rules_init(void);
 void fib6_rules_cleanup(void);
 bool fib6_rule_default(const struct fib_rule *rule);
@@ -527,6 +532,10 @@ static inline bool fib6_rules_early_flow_dissect(struc=
t net *net,
 =09return true;
 }
 #else
+static inline bool fib6_has_custom_rules(struct net *net)
+{
+=09return 0;
+}
 static inline int               fib6_rules_init(void)
 {
 =09return 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index ef7f707d9ae3..792b52aa9fc9 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -59,6 +59,7 @@ static void ip6_rcv_finish_core(struct net *net, struct s=
ock *sk,
 =09=09=09INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
 =09=09=09=09=09udp_v6_early_demux, skb);
 =09}
+
 =09if (!skb_valid_dst(skb))
 =09=09ip6_route_input(skb);
 }
@@ -86,11 +87,26 @@ static void ip6_sublist_rcv_finish(struct list_head *he=
ad)
 =09}
 }
=20
+static bool ip6_can_use_hint(struct sk_buff *skb, const struct sk_buff *hi=
nt)
+{
+=09return hint && !skb_dst(skb) &&
+=09       ipv6_addr_equal(&ipv6_hdr(hint)->daddr, &ipv6_hdr(skb)->daddr);
+}
+
+static struct sk_buff *ip6_extract_route_hint(struct net *net,
+=09=09=09=09=09      struct sk_buff *skb)
+{
+=09if (IS_ENABLED(IPV6_SUBTREES) || fib6_has_custom_rules(net))
+=09=09return NULL;
+
+=09return skb;
+}
+
 static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
 =09=09=09=09struct list_head *head)
 {
+=09struct sk_buff *skb, *next, *hint =3D NULL;
 =09struct dst_entry *curr_dst =3D NULL;
-=09struct sk_buff *skb, *next;
 =09struct list_head sublist;
=20
 =09INIT_LIST_HEAD(&sublist);
@@ -104,9 +120,15 @@ static void ip6_list_rcv_finish(struct net *net, struc=
t sock *sk,
 =09=09skb =3D l3mdev_ip6_rcv(skb);
 =09=09if (!skb)
 =09=09=09continue;
-=09=09ip6_rcv_finish_core(net, sk, skb);
+
+=09=09if (ip6_can_use_hint(skb, hint))
+=09=09=09skb_dst_copy(skb, hint);
+=09=09else
+=09=09=09ip6_rcv_finish_core(net, sk, skb);
 =09=09dst =3D skb_dst(skb);
 =09=09if (curr_dst !=3D dst) {
+=09=09=09hint =3D ip6_extract_route_hint(net, skb);
+
 =09=09=09/* dispatch old sublist */
 =09=09=09if (!list_empty(&sublist))
 =09=09=09=09ip6_sublist_rcv_finish(&sublist);
--=20
2.21.0

