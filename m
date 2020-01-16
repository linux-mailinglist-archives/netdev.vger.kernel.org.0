Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B271C13D81C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 11:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgAPKjk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jan 2020 05:39:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42761 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726100AbgAPKjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 05:39:40 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-bV1XJD5CN_ShKaH12UXmnA-1; Thu, 16 Jan 2020 05:39:37 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FE37DB21;
        Thu, 16 Jan 2020 10:39:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-110.ams2.redhat.com [10.36.117.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCCE0811FD;
        Thu, 16 Jan 2020 10:39:34 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH iproute2-next] ip: xfrm: add espintcp encapsulation
Date:   Thu, 16 Jan 2020 11:39:24 +0100
Message-Id: <0b5baa21f8d0048b5e97f927e801ac2f843bb5e1.1579104430.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: bV1XJD5CN_ShKaH12UXmnA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for creating xfrm states with TCP encapsulation,
similar to the existing UDP encapsulation support.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
The kernel side patches are in ipsec-next/master.

 ip/ipxfrm.c        | 5 +++++
 ip/xfrm_state.c    | 2 +-
 man/man8/ip-xfrm.8 | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index 32f560933a47..e310860b9f1f 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -759,6 +759,9 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
 		case 2:
 			fprintf(fp, "espinudp ");
 			break;
+		case 7:
+			fprintf(fp, "espintcp ");
+			break;
 		default:
 			fprintf(fp, "%u ", e->encap_type);
 			break;
@@ -1211,6 +1214,8 @@ int xfrm_encap_type_parse(__u16 *type, int *argcp, char ***argvp)
 		*type = 1;
 	else if (strcmp(*argv, "espinudp") == 0)
 		*type = 2;
+	else if (strcmp(*argv, "espintcp") == 0)
+		*type = 7;
 	else
 		invarg("ENCAP-TYPE value is invalid", *argv);
 
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index b03ccc5807e9..df2d50c3843b 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -130,7 +130,7 @@ static void usage(void)
 		"LIMIT-LIST := [ LIMIT-LIST ] limit LIMIT\n"
 		"LIMIT := { time-soft | time-hard | time-use-soft | time-use-hard } SECONDS |\n"
 		"         { byte-soft | byte-hard } SIZE | { packet-soft | packet-hard } COUNT\n"
-		"ENCAP := { espinudp | espinudp-nonike } SPORT DPORT OADDR\n"
+		"ENCAP := { espinudp | espinudp-nonike | espintcp } SPORT DPORT OADDR\n"
 		"DIR := in | out\n");
 
 	exit(-1);
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index cfce1e40b7f7..f99f30bb448a 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -207,7 +207,7 @@ ip-xfrm \- transform configuration
 
 .ti -8
 .IR ENCAP " :="
-.RB "{ " espinudp " | " espinudp-nonike " }"
+.RB "{ " espinudp " | " espinudp-nonike " | " espintcp " }"
 .IR SPORT " " DPORT " " OADDR
 
 .ti -8
@@ -548,7 +548,7 @@ sets limits in seconds, bytes, or numbers of packets.
 .TP
 .I ENCAP
 encapsulates packets with protocol
-.BR espinudp " or " espinudp-nonike ","
+.BR espinudp ", " espinudp-nonike ", or " espintcp ","
 .RI "using source port " SPORT ", destination port "  DPORT
 .RI ", and original address " OADDR "."
 
-- 
2.24.1

