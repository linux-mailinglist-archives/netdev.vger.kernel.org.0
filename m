Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E8EEB365
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 16:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfJaPHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 11:07:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47674 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726642AbfJaPHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 11:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572534455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+X+barDmBU6tY5JVRo13usriPISCS+dspcgm1jynFsU=;
        b=OJWM1qKzgG7hphI6rN3+AEOVqVQFxZcV0Nzq35ptxXifM2KrK9zi/PwV3PlXmlkpHbKhfO
        /y4d02+oCVqwHl5tI3Hhs/UYo6PP4M9S2xIxewQ9E5B53uDXe5gudFlj1pPwqg/8xhnpdp
        8GIgX1hKM9+3GJEGRTKCNBEWI7QyB60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-Qw84FZfkMEC4TRhwYzDT9g-1; Thu, 31 Oct 2019 11:07:31 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798EE1800D6B;
        Thu, 31 Oct 2019 15:07:30 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EF74600CD;
        Thu, 31 Oct 2019 15:07:29 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] ip-route: fix json formatting for multipath routing
Date:   Thu, 31 Oct 2019 16:09:30 +0100
Message-Id: <99a4a6ffec5d9e7b508863873bf2097bfbb79ec6.1572534380.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Qw84FZfkMEC4TRhwYzDT9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

json output for multipath routing is broken due to some non-jsonified
print in print_rta_multipath(). To reproduce the issue:

$ ip route add default \
  nexthop via 192.168.1.1 weight 1 \
  nexthop via 192.168.2.1 weight 1
$ ip -j route | jq
parse error: Invalid numeric literal at line 1, column 58

Fix this opening a "multipath" json array that can contain multiple
route objects, and using print_*() instead of fprintf().

This is the output for the above commands applying this patch:

[
  {
    "dst": "default",
    "flags": [],
    "multipath": [
      {
        "gateway": "192.168.1.1",
        "dev": "wlp61s0",
        "weight": 1,
        "flags": [
          "linkdown"
        ]
      },
      {
        "gateway": "192.168.2.1",
        "dev": "ens1u1",
        "weight": 1,
        "flags": []
      }
    ]
  }
]

Fixes: f48e14880a0e5 ("iproute: refactor multipath print")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Reported-by: Patrick Hagara <phagara@redhat.com>
---
 ip/iproute.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index a453385113cb9..4c268c72c5bd6 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -649,12 +649,16 @@ static void print_rta_multipath(FILE *fp, const struc=
t rtmsg *r,
 =09int len =3D RTA_PAYLOAD(rta);
 =09int first =3D 1;
=20
+=09open_json_array(PRINT_JSON, "multipath");
+
 =09while (len >=3D sizeof(*nh)) {
 =09=09struct rtattr *tb[RTA_MAX + 1];
=20
 =09=09if (nh->rtnh_len > len)
 =09=09=09break;
=20
+=09=09open_json_object(NULL);
+
 =09=09if (!is_json_context()) {
 =09=09=09if ((r->rtm_flags & RTM_F_CLONED) &&
 =09=09=09    r->rtm_type =3D=3D RTN_MULTICAST) {
@@ -689,22 +693,29 @@ static void print_rta_multipath(FILE *fp, const struc=
t rtmsg *r,
=20
 =09=09if ((r->rtm_flags & RTM_F_CLONED) &&
 =09=09    r->rtm_type =3D=3D RTN_MULTICAST) {
-=09=09=09fprintf(fp, "%s", ll_index_to_name(nh->rtnh_ifindex));
+=09=09=09print_string(PRINT_ANY, "dev", "%s",
+=09=09=09=09     ll_index_to_name(nh->rtnh_ifindex));
 =09=09=09if (nh->rtnh_hops !=3D 1)
-=09=09=09=09fprintf(fp, "(ttl>%d)", nh->rtnh_hops);
-=09=09=09fprintf(fp, " ");
+=09=09=09=09print_uint(PRINT_ANY, "ttl", "(ttl>%d)",
+=09=09=09=09=09   nh->rtnh_hops);
+=09=09=09print_string(PRINT_FP, NULL, " ", NULL);
 =09=09} else {
-=09=09=09fprintf(fp, "dev %s ", ll_index_to_name(nh->rtnh_ifindex));
+=09=09=09print_string(PRINT_ANY, "dev", "dev %s ",
+=09=09=09=09     ll_index_to_name(nh->rtnh_ifindex));
 =09=09=09if (r->rtm_family !=3D AF_MPLS)
-=09=09=09=09fprintf(fp, "weight %d ",
-=09=09=09=09=09nh->rtnh_hops+1);
+=09=09=09=09print_uint(PRINT_ANY, "weight", "weight %d ",
+=09=09=09=09=09   nh->rtnh_hops + 1);
 =09=09}
=20
 =09=09print_rt_flags(fp, nh->rtnh_flags);
=20
 =09=09len -=3D NLMSG_ALIGN(nh->rtnh_len);
 =09=09nh =3D RTNH_NEXT(nh);
+
+=09=09close_json_object();
 =09}
+
+=09close_json_array(PRINT_JSON, "multipath");
 }
=20
 int print_route(struct nlmsghdr *n, void *arg)
--=20
2.21.0

