Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77B3103A4F
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfKTMsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:48:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727656AbfKTMsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:48:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574254086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nBP+XP+yK31w7F0UyYxvcv5T+T9iVp+dNzii9GwDAS8=;
        b=cFN9h9tdkcrE1tEqJxdrLMrjMAeWvPs1l9z5TxIrGK4ZvJ1owETwrxVYDkZF5SftQtDl2u
        yeIlLBf3IsSO87Fb7fPuDKxLVi1+FQialL5xEBaAwGTs3ajPNLgqwPgdoYALJLLMfU4n3f
        MOdGC/fKCR0IxnQKUKieHBKFITyWM3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-sTKehq1RPiS3JPPO2d0gaQ-1; Wed, 20 Nov 2019 07:48:05 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBC4DDB6D;
        Wed, 20 Nov 2019 12:48:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-23.ams2.redhat.com [10.36.117.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F67F2CA76;
        Wed, 20 Nov 2019 12:48:02 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next v4 3/5] ipv6: introduce and uses route look hints for list input.
Date:   Wed, 20 Nov 2019 13:47:35 +0100
Message-Id: <af831ed39b697b86cd380d67b976438156d04da2.1574252982.git.pabeni@redhat.com>
In-Reply-To: <cover.1574252982.git.pabeni@redhat.com>
References: <cover.1574252982.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: sTKehq1RPiS3JPPO2d0gaQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing RX batch packet processing, we currently always repeat
the route lookup for each ingress packet. When no custom rules are
in place, and there aren't routes depending on source addresses,
we know that packets with the same destination address will use
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

v3 -> v4:
 - support hints for SUBFLOW build, too (David A.)
 - several style fixes (Eric)

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
 net/ipv6/ip6_input.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index ef7f707d9ae3..7b089d0ac8cd 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -86,11 +86,27 @@ static void ip6_sublist_rcv_finish(struct list_head *he=
ad)
 =09}
 }
=20
+static bool ip6_can_use_hint(const struct sk_buff *skb,
+=09=09=09     const struct sk_buff *hint)
+{
+=09return hint && !skb_dst(skb) &&
+=09       ipv6_addr_equal(&ipv6_hdr(hint)->daddr, &ipv6_hdr(skb)->daddr);
+}
+
+static struct sk_buff *ip6_extract_route_hint(const struct net *net,
+=09=09=09=09=09      struct sk_buff *skb)
+{
+=09if (fib6_routes_require_src(net) || fib6_has_custom_rules(net))
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

