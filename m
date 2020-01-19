Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CE0141ACC
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 02:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgASBNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 20:13:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43279 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727070AbgASBNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 20:13:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579396393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yn8DIVRK5vXcj83pNr0t0S9jGr85bQYx/dZhgS3xJig=;
        b=W6ObNAYYKTwz6O2l9rtVMRUK8lPGUe+SDaoSKKVLtlh/E5npexwPr2OKq9oS7BVicAnRkH
        /BCNHvaw0wV5w7kTg0/F7RSRCPgfhAIdJcDZrQ7HwXWVh55RI5rDUnUOmQf8Q2FgnbfexY
        jitS+14BMCJvFhI5zSpyJ1kHdTBoKq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-pV_R5iLVNiK8xn8b22mldA-1; Sat, 18 Jan 2020 20:13:09 -0500
X-MC-Unique: pV_R5iLVNiK8xn8b22mldA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10AD48017CC;
        Sun, 19 Jan 2020 01:13:08 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE8E78478B;
        Sun, 19 Jan 2020 01:13:05 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     netdev@vger.kernel.org
Cc:     vdronov@redhat.com, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George Shuklin <george.shuklin@gmail.com>
Subject: [PATCH iproute2] ip: fix link type and vlan oneline output
Date:   Sun, 19 Jan 2020 02:12:51 +0100
Message-Id: <20200119011251.7153-1-vdronov@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move link type printing in print_linkinfo() so multiline output does not
break link options line. Add oneline support for vlan's ingress and egres=
s
qos maps.

Before the fix:

# ip -details link show veth90.4000
5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop s=
tate DOWN mode DEFAULT group default qlen 1000
    link/ether 26:9a:05:af:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minm=
tu 0 maxmtu 65535
    vlan protocol 802.1Q id 4000 <REORDER_HDR>               the option l=
ine is broken ^^^
      ingress-qos-map { 1:2 }
      egress-qos-map { 2:1 } addrgenmode eui64 numtxqueues 1 numrxqueues =
1 gso_max_size 65536 gso_max_segs 65535

# ip -oneline -details link show veth90.4000
5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop s=
tate DOWN mode DEFAULT group default qlen 1000\    link/ether 26:9a:05:af=
:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535 \    vla=
n protocol 802.1Q id 4000 <REORDER_HDR>
      ingress-qos-map { 1:2 }   <<< a multiline output despite -oneline
      egress-qos-map { 2:1 } addrgenmode eui64 numtxqueues 1 numrxqueues =
1 gso_max_size 65536 gso_max_segs 65535

After the fix:

# ip -details link show veth90.4000
5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop s=
tate DOWN mode DEFAULT group default qlen 1000
    link/ether 26:9a:05:af:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minm=
tu 0 maxmtu 65535 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_s=
ize 65536 gso_max_segs 65535
    vlan protocol 802.1Q id 4000 <REORDER_HDR>
      ingress-qos-map { 1:2 }
      egress-qos-map { 2:1 }

# ip -oneline -details link show veth90.4000
5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop s=
tate DOWN mode DEFAULT group default qlen 1000\    link/ether 26:9a:05:af=
:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535 addrgenm=
ode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 655=
35 \    vlan protocol 802.1Q id 4000 <REORDER_HDR> \      ingress-qos-map=
 { 1:2 } \      egress-qos-map { 2:1 }

Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D206241
Reported-by: George Shuklin <george.shuklin@gmail.com>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 ip/ipaddress.c   | 6 +++---
 ip/iplink_vlan.c | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 964f14df..8814c298 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1072,9 +1072,6 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 				   "max_mtu", "maxmtu %u ",
 				   rta_getattr_u32(tb[IFLA_MAX_MTU]));
=20
-		if (tb[IFLA_LINKINFO])
-			print_linktype(fp, tb[IFLA_LINKINFO]);
-
 		if (do_link && tb[IFLA_AF_SPEC])
 			print_af_spec(fp, tb[IFLA_AF_SPEC]);
=20
@@ -1126,6 +1123,9 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 						   RTA_PAYLOAD(tb[IFLA_PHYS_SWITCH_ID]),
 						   b1, sizeof(b1)));
 		}
+
+		if (tb[IFLA_LINKINFO])
+			print_linktype(fp, tb[IFLA_LINKINFO]);
 	}
=20
 	if ((do_link || show_details) && tb[IFLA_IFALIAS]) {
diff --git a/ip/iplink_vlan.c b/ip/iplink_vlan.c
index 0dfb4a8d..1e6817f5 100644
--- a/ip/iplink_vlan.c
+++ b/ip/iplink_vlan.c
@@ -183,7 +183,8 @@ static void vlan_print_map(FILE *f,
 	int rem;
=20
 	open_json_array(PRINT_JSON, name_json);
-	print_string(PRINT_FP, NULL, "\n      %s { ", name_fp);
+	print_nl();
+	print_string(PRINT_FP, NULL, "      %s { ", name_fp);
=20
 	rem =3D RTA_PAYLOAD(attr);
 	for (i =3D RTA_DATA(attr); RTA_OK(i, rem); i =3D RTA_NEXT(i, rem)) {
--=20
2.20.1

