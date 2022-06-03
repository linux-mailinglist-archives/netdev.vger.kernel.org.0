Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CB753D3D3
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 01:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245755AbiFCXUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 19:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiFCXUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 19:20:02 -0400
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92184D13A
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 16:20:00 -0700 (PDT)
Date:   Fri, 03 Jun 2022 23:19:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1654298397; x=1654557597;
        bh=YRxUSVZ+qoYXN7oduiTL6n6ULE7wKJlSgwj7h0HLgHM=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:Feedback-ID:From:To:
         Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID;
        b=o1s5FLQJV0PZnekxGDyYMCYtXLRlpONNj/ST25pY9hk45FRzzyQz3ZObMjAg+ESLs
         jor4duyb28Ttyvrm+q7tAUfEAobKghC/1e2dzy8PbOA+oZysCh3Rm7t/x28QdJ3ggU
         Qo3ked079mAMXat6ogdOcUsrD3jIUSPLwi1167WUZaWfYCIDGynrl9jErbu8mZzLqm
         Ol/ikykY8phBcVdFxZBsBFEp2uJidFlIcbk3jCGQGFnmvY212mTPVq+wlVpT4Rb0cl
         N5ZYB28pEaIc+bCoxbxgYb9lYCqibtugKmn5blR43aW1CiJeN97haDlKWCPl8mxeks
         E3+XtmzRB3FCw==
To:     netdev@vger.kernel.org
From:   Jacques de Laval <jacques.delaval@protonmail.com>
Cc:     Jacques de Laval <jacques.delaval@protonmail.com>
Reply-To: Jacques de Laval <jacques.delaval@protonmail.com>
Subject: [PATCH iproute2-next] lib/rt_names: Fix cache getting trashed on integer input to rtnl_*_a2n
Message-ID: <20220603231933.127804-1-jacques.delaval@protonmail.com>
Feedback-ID: 21766145:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cache value 'res' should only be updated when the cache key 'cache'
is updated. Otherwise the rtnl_*_a2n functions risk returning wrong
values on subsequent calls.

Signed-off-by: Jacques de Laval <jacques.delaval@protonmail.com>
---
 lib/rt_names.c                         | 48 +++++++++++++-------------
 testsuite/tests/ip/route/set_rtproto.t | 26 ++++++++++++++
 2 files changed, 50 insertions(+), 24 deletions(-)
 create mode 100755 testsuite/tests/ip/route/set_rtproto.t

diff --git a/lib/rt_names.c b/lib/rt_names.c
index b976471d..a67d8e89 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -202,7 +202,7 @@ int rtnl_rtprot_a2n(__u32 *id, const char *arg)
 =09static char *cache;
 =09static unsigned long res;
 =09char *end;
-=09int i;
+=09unsigned long i;

 =09if (cache && strcmp(cache, arg) =3D=3D 0) {
 =09=09*id =3D res;
@@ -222,10 +222,10 @@ int rtnl_rtprot_a2n(__u32 *id, const char *arg)
 =09=09}
 =09}

-=09res =3D strtoul(arg, &end, 0);
-=09if (!end || end =3D=3D arg || *end || res > 255)
+=09i =3D strtoul(arg, &end, 0);
+=09if (!end || end =3D=3D arg || *end || i > 255)
 =09=09return -1;
-=09*id =3D res;
+=09*id =3D i;
 =09return 0;
 }

@@ -271,7 +271,7 @@ int rtnl_rtscope_a2n(__u32 *id, const char *arg)
 =09static const char *cache;
 =09static unsigned long res;
 =09char *end;
-=09int i;
+=09unsigned long i;

 =09if (cache && strcmp(cache, arg) =3D=3D 0) {
 =09=09*id =3D res;
@@ -291,10 +291,10 @@ int rtnl_rtscope_a2n(__u32 *id, const char *arg)
 =09=09}
 =09}

-=09res =3D strtoul(arg, &end, 0);
-=09if (!end || end =3D=3D arg || *end || res > 255)
+=09i =3D strtoul(arg, &end, 0);
+=09if (!end || end =3D=3D arg || *end || i > 255)
 =09=09return -1;
-=09*id =3D res;
+=09*id =3D i;
 =09return 0;
 }

@@ -334,7 +334,7 @@ int rtnl_rtrealm_a2n(__u32 *id, const char *arg)
 =09static char *cache;
 =09static unsigned long res;
 =09char *end;
-=09int i;
+=09unsigned long i;

 =09if (cache && strcmp(cache, arg) =3D=3D 0) {
 =09=09*id =3D res;
@@ -354,10 +354,10 @@ int rtnl_rtrealm_a2n(__u32 *id, const char *arg)
 =09=09}
 =09}

-=09res =3D strtoul(arg, &end, 0);
-=09if (!end || end =3D=3D arg || *end || res > 255)
+=09i =3D strtoul(arg, &end, 0);
+=09if (!end || end =3D=3D arg || *end || i > 255)
 =09=09return -1;
-=09*id =3D res;
+=09*id =3D i;
 =09return 0;
 }

@@ -511,7 +511,7 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
 =09static char *cache;
 =09static unsigned long res;
 =09char *end;
-=09int i;
+=09unsigned long i;

 =09if (cache && strcmp(cache, arg) =3D=3D 0) {
 =09=09*id =3D res;
@@ -531,10 +531,10 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
 =09=09}
 =09}

-=09res =3D strtoul(arg, &end, 16);
-=09if (!end || end =3D=3D arg || *end || res > 255)
+=09i =3D strtoul(arg, &end, 16);
+=09if (!end || end =3D=3D arg || *end || i > 255)
 =09=09return -1;
-=09*id =3D res;
+=09*id =3D i;
 =09return 0;
 }

@@ -668,7 +668,7 @@ int nl_proto_a2n(__u32 *id, const char *arg)
 =09static char *cache;
 =09static unsigned long res;
 =09char *end;
-=09int i;
+=09unsigned long i;

 =09if (cache && strcmp(cache, arg) =3D=3D 0) {
 =09=09*id =3D res;
@@ -688,10 +688,10 @@ int nl_proto_a2n(__u32 *id, const char *arg)
 =09=09}
 =09}

-=09res =3D strtoul(arg, &end, 0);
-=09if (!end || end =3D=3D arg || *end || res > 255)
+=09i =3D strtoul(arg, &end, 0);
+=09if (!end || end =3D=3D arg || *end || i > 255)
 =09=09return -1;
-=09*id =3D res;
+=09*id =3D i;
 =09return 0;
 }

@@ -760,7 +760,7 @@ int protodown_reason_a2n(__u32 *id, const char *arg)
 =09static char *cache;
 =09static unsigned long res;
 =09char *end;
-=09int i;
+=09unsigned long i;

 =09if (cache && strcmp(cache, arg) =3D=3D 0) {
 =09=09*id =3D res;
@@ -780,9 +780,9 @@ int protodown_reason_a2n(__u32 *id, const char *arg)
 =09=09}
 =09}

-=09res =3D strtoul(arg, &end, 0);
-=09if (!end || end =3D=3D arg || *end || res >=3D PROTODOWN_REASON_NUM_BIT=
S)
+=09i =3D strtoul(arg, &end, 0);
+=09if (!end || end =3D=3D arg || *end || i >=3D PROTODOWN_REASON_NUM_BITS)
 =09=09return -1;
-=09*id =3D res;
+=09*id =3D i;
 =09return 0;
 }
diff --git a/testsuite/tests/ip/route/set_rtproto.t b/testsuite/tests/ip/ro=
ute/set_rtproto.t
new file mode 100755
index 00000000..f6dfe053
--- /dev/null
+++ b/testsuite/tests/ip/route/set_rtproto.t
@@ -0,0 +1,26 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+ts_log "[Testing setting protocol]"
+
+DEV=3Ddummy0
+
+ts_ip "$0" "Add new interface $DEV" link add $DEV type dummy
+ts_ip "$0" "Set $DEV into UP state" link set up dev $DEV
+
+cat <<EOF | ts_ip "$0" "Add routes with protocol set" -b -
+route add 10.10.0.0 proto ospf dev "$DEV"
+route add 10.20.0.0 proto 255 dev "$DEV"
+route add 10.30.0.0 proto ospf dev "$DEV"
+EOF
+
+ts_ip "$0" "Show proto ospf routes" route show proto ospf
+test_lines_count 2
+test_on "10.10.0.0 dev dummy0 scope link"
+test_on "10.30.0.0 dev dummy0 scope link"
+ts_ip "$0" "Show proto 255 routes" route show 10.20.0.0 proto 255
+test_lines_count 1
+test_on "10.20.0.0 dev dummy0 scope link"
+
+ts_ip "$0" "Del $DEV dummy interface"  link del dev "$DEV"
--
2.36.1


