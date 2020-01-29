Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A690414CCD5
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgA2O46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:56:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726314AbgA2O45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:56:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580309816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/qm5aHkGYf0tXpDpwmazjFC7+K2icdeqWs8ozBESY5s=;
        b=LIYtko6yybGFb+VKuJZVSr9MT5K2iEaR22Pu+7R4LieSGgqCmMpEaTLGh6nJBv76zh6t2L
        NnzrU6bQs5wIuIeWFMhKFjh4F83jqCA/pAVdMMoSfI2XKz+400W6dza27fc1J/t84tfBnt
        28bklRhmGxuSiqwvyoVGjjC9yEhbJms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-GCv-nnZGN7ObksMcNHQjCA-1; Wed, 29 Jan 2020 09:56:55 -0500
X-MC-Unique: GCv-nnZGN7ObksMcNHQjCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0353A800D41;
        Wed, 29 Jan 2020 14:56:54 +0000 (UTC)
Received: from renaissance-vector.redhat.com (ovpn-116-61.ams2.redhat.com [10.36.116.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC62084BC4;
        Wed, 29 Jan 2020 14:56:52 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] ip-xfrm: Fix help messages
Date:   Wed, 29 Jan 2020 15:56:40 +0100
Message-Id: <7136ded9fe876eab3b1cdcae6a6fc45960b7b3d9.1580309665.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 8589eb4efdf2a ("treewide: refactor help messages") help
messages for xfrm state and policy are broken, printing many times the
same protocol in UPSPEC section:

$ ip xfrm state help
[...]
UPSPEC :=3D proto { { tcp | tcp | tcp | tcp } [ sport PORT ] [ dport PORT=
 ] |
                  { icmp | icmp | icmp } [ type NUMBER ] [ code NUMBER ] =
|
                  gre [ key { DOTTED-QUAD | NUMBER } ] | PROTO }

This happens because strxf_proto function is non-reentrant and gets calle=
d
multiple times in the same fprintf instruction.

This commit fix the issue avoiding calls to strxf_proto() with a constant
param, just hardcoding strings for protocol names.

Fixes: 8589eb4efdf2a ("treewide: refactor help messages")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/xfrm_policy.c | 21 +++------------------
 ip/xfrm_state.c  | 24 +++---------------------
 2 files changed, 6 insertions(+), 39 deletions(-)

diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
index 7c0233c182902..d3c706d3225f0 100644
--- a/ip/xfrm_policy.c
+++ b/ip/xfrm_policy.c
@@ -66,24 +66,9 @@ static void usage(void)
 		"Usage: ip xfrm policy count\n"
 		"Usage: ip xfrm policy set [ hthresh4 LBITS RBITS ] [ hthresh6 LBITS R=
BITS ]\n"
 		"SELECTOR :=3D [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ dev DEV ] [ U=
PSPEC ]\n"
-		"UPSPEC :=3D proto { { ");
-	fprintf(stderr, "%s | %s | %s | %s } ",
-		strxf_proto(IPPROTO_TCP),
-		strxf_proto(IPPROTO_UDP),
-		strxf_proto(IPPROTO_SCTP),
-		strxf_proto(IPPROTO_DCCP));
-	fprintf(stderr,
-		"[ sport PORT ] [ dport PORT ] |\n"
-		"                  { %s | %s | %s } ",
-		strxf_proto(IPPROTO_ICMP),
-		strxf_proto(IPPROTO_ICMPV6),
-		strxf_proto(IPPROTO_MH));
-	fprintf(stderr,
-		"[ type NUMBER ] [ code NUMBER ] |\n"
-		"                  %s",
-		strxf_proto(IPPROTO_GRE));
-	fprintf(stderr,
-		" [ key { DOTTED-QUAD | NUMBER } ] | PROTO }\n"
+		"UPSPEC :=3D proto { { tcp | udp | sctp | dccp } [ sport PORT ] [ dpor=
t PORT ] |\n"
+		"                  { icmp | ipv6-icmp | mobility-header } [ type NUMBE=
R ] [ code NUMBER ] |\n"
+		"                  gre [ key { DOTTED-QUAD | NUMBER } ] | PROTO }\n"
 		"DIR :=3D in | out | fwd\n"
 		"PTYPE :=3D main | sub\n"
 		"ACTION :=3D allow | block\n"
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index b03ccc5807e90..7b413cd9b9a22 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -106,27 +106,9 @@ static void usage(void)
 		"EXTRA-FLAG-LIST :=3D [ EXTRA-FLAG-LIST ] EXTRA-FLAG\n"
 		"EXTRA-FLAG :=3D dont-encap-dscp\n"
 		"SELECTOR :=3D [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ dev DEV ] [ U=
PSPEC ]\n"
-		"UPSPEC :=3D proto { { ");
-	fprintf(stderr,
-		"%s | %s | %s | %s",
-		strxf_proto(IPPROTO_TCP),
-		strxf_proto(IPPROTO_UDP),
-		strxf_proto(IPPROTO_SCTP),
-		strxf_proto(IPPROTO_DCCP));
-	fprintf(stderr,
-		" } [ sport PORT ] [ dport PORT ] |\n"
-		"                  { ");
-	fprintf(stderr,
-		"%s | %s | %s",
-		strxf_proto(IPPROTO_ICMP),
-		strxf_proto(IPPROTO_ICMPV6),
-		strxf_proto(IPPROTO_MH));
-	fprintf(stderr,
-		" } [ type NUMBER ] [ code NUMBER ] |\n");
-	fprintf(stderr,
-		"                  %s", strxf_proto(IPPROTO_GRE));
-	fprintf(stderr,
-		" [ key { DOTTED-QUAD | NUMBER } ] | PROTO }\n"
+		"UPSPEC :=3D proto { { tcp | udp | sctp | dccp } [ sport PORT ] [ dpor=
t PORT ] |\n"
+		"                  { icmp | ipv6-icmp | mobility-header } [ type NUMBE=
R ] [ code NUMBER ] |\n"
+		"                  gre [ key { DOTTED-QUAD | NUMBER } ] | PROTO }\n"
 		"LIMIT-LIST :=3D [ LIMIT-LIST ] limit LIMIT\n"
 		"LIMIT :=3D { time-soft | time-hard | time-use-soft | time-use-hard } =
SECONDS |\n"
 		"         { byte-soft | byte-hard } SIZE | { packet-soft | packet-hard=
 } COUNT\n"
--=20
2.24.1

