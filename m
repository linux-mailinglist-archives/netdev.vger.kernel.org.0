Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D39734229E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhCSQ6X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Mar 2021 12:58:23 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:56764 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230228AbhCSQ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 12:58:14 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-Bo27dnbtPMesSTCFQqaQ7Q-1; Fri, 19 Mar 2021 12:58:09 -0400
X-MC-Unique: Bo27dnbtPMesSTCFQqaQ7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E0F8101371B;
        Fri, 19 Mar 2021 16:58:08 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E17215D9C6;
        Fri, 19 Mar 2021 16:58:06 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH iproute2-next] ip: xfrm: add support for tfcpad
Date:   Fri, 19 Mar 2021 17:57:17 +0100
Message-Id: <1a3dcd1916cc4399c88315e19ab3c2d8948d28c1.1616170525.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for setting and displaying the Traffic Flow
Confidentiality attribute for an XFRM state, which allows padding ESP
packets to a specified length.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 ip/ipxfrm.c        |  8 ++++++++
 ip/xfrm_state.c    | 10 +++++++++-
 man/man8/ip-xfrm.8 |  2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index e4a72bd06778..9902fdd3f58e 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -907,6 +907,14 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
 		fprintf(fp, "if_id %#x", if_id);
 		fprintf(fp, "%s", _SL_);
 	}
+	if (tb[XFRMA_TFCPAD]) {
+		__u32 tfcpad = rta_getattr_u32(tb[XFRMA_TFCPAD]);
+
+		if (prefix)
+			fputs(prefix, fp);
+		fprintf(fp, "tfcpad %u", tfcpad);
+		fprintf(fp, "%s", _SL_);
+	}
 }
 
 static int xfrm_selector_iszero(struct xfrm_selector *s)
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index a4f452fa4f48..6fee7efd18c7 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -63,7 +63,7 @@ static void usage(void)
 		"        [ coa ADDR[/PLEN] ] [ ctx CTX ] [ extra-flag EXTRA-FLAG-LIST ]\n"
 		"        [ offload [dev DEV] dir DIR ]\n"
 		"        [ output-mark OUTPUT-MARK [ mask MASK ] ]\n"
-		"        [ if_id IF_ID ]\n"
+		"        [ if_id IF_ID ] [ tfcpad LENGTH ]\n"
 		"Usage: ip xfrm state allocspi ID [ mode MODE ] [ mark MARK [ mask MASK ] ]\n"
 		"        [ reqid REQID ] [ seq SEQ ] [ min SPI max SPI ]\n"
 		"Usage: ip xfrm state { delete | get } ID [ mark MARK [ mask MASK ] ]\n"
@@ -331,6 +331,7 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 	struct xfrm_mark output_mark = {0, 0};
 	bool is_if_id_set = false;
 	__u32 if_id = 0;
+	__u32 tfcpad = 0;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "mode") == 0) {
@@ -465,6 +466,10 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 			if (get_u32(&if_id, *argv, 0))
 				invarg("value after \"if_id\" is invalid", *argv);
 			is_if_id_set = true;
+		} else if (strcmp(*argv, "tfcpad") == 0) {
+			NEXT_ARG();
+			if (get_u32(&tfcpad, *argv, 0))
+				invarg("value after \"tfcpad\" is invalid", *argv);
 		} else {
 			/* try to assume ALGO */
 			int type = xfrm_algotype_getbyname(*argv);
@@ -650,6 +655,9 @@ static int xfrm_state_modify(int cmd, unsigned int flags, int argc, char **argv)
 	if (is_if_id_set)
 		addattr32(&req.n, sizeof(req.buf), XFRMA_IF_ID, if_id);
 
+	if (tfcpad)
+		addattr32(&req.n, sizeof(req.buf), XFRMA_TFCPAD, tfcpad);
+
 	if (xfrm_xfrmproto_is_ipsec(req.xsinfo.id.proto)) {
 		switch (req.xsinfo.mode) {
 		case XFRM_MODE_TRANSPORT:
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index 2669b386ebca..003f6c3d1c28 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -65,6 +65,8 @@ ip-xfrm \- transform configuration
 .IR MASK " ] ]"
 .RB "[ " if_id
 .IR IF-ID " ]"
+.RB "[ " tfcpad
+.IR LENGTH " ]"
 
 .ti -8
 .B "ip xfrm state allocspi"
-- 
2.31.0

