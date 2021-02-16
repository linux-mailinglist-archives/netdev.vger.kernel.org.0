Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE0B31CE6E
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 17:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhBPQwI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Feb 2021 11:52:08 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:20473 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhBPQwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 11:52:05 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-ttvpe5R2OXasl8DsY-n9Ew-1; Tue, 16 Feb 2021 11:51:09 -0500
X-MC-Unique: ttvpe5R2OXasl8DsY-n9Ew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF9AF107ACE3;
        Tue, 16 Feb 2021 16:51:07 +0000 (UTC)
Received: from hog.localdomain (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 974801B533;
        Tue, 16 Feb 2021 16:51:06 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Paul Wouters <pwouters@redhat.com>
Subject: [PATCH iproute2] ip: xfrm: add NUL character to security context name before printing
Date:   Tue, 16 Feb 2021 17:50:58 +0100
Message-Id: <11af39932b3896cf1a560059bcbd24194e7f33bd.1613473397.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Security context names are not guaranteed to be NUL-terminated by the
kernel, so we can't just print them using %s directly. The length of
the string is capped by the size of the netlink attribute (u16), so it
will always fit within 65535 bytes.

While at it, factor that out to a separate function, since the exact
same code is used to print the security context for both policies and
states.

Fixes: b2bb289a57fe ("xfrm security context support")
Reported-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 ip/ipxfrm.c | 46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index e4a72bd06778..3fc0e13ef112 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -916,6 +916,22 @@ static int xfrm_selector_iszero(struct xfrm_selector *s)
 	return (memcmp(&s0, s, sizeof(s0)) == 0);
 }
 
+static void xfrm_sec_ctx_print(FILE *fp, struct rtattr *attr)
+{
+	struct xfrm_user_sec_ctx *sctx;
+	char buf[65536] = {};
+
+	fprintf(fp, "\tsecurity context ");
+
+	if (RTA_PAYLOAD(attr) < sizeof(*sctx))
+		fprintf(fp, "(ERROR truncated)");
+
+	sctx = RTA_DATA(attr);
+
+	memcpy(buf, (char *)(sctx + 1), sctx->ctx_len);
+	fprintf(fp, "%s %s", buf, _SL_);
+}
+
 void xfrm_state_info_print(struct xfrm_usersa_info *xsinfo,
 			    struct rtattr *tb[], FILE *fp, const char *prefix,
 			    const char *title, bool nokeys)
@@ -983,19 +999,8 @@ void xfrm_state_info_print(struct xfrm_usersa_info *xsinfo,
 		xfrm_stats_print(&xsinfo->stats, fp, buf);
 	}
 
-	if (tb[XFRMA_SEC_CTX]) {
-		struct xfrm_user_sec_ctx *sctx;
-
-		fprintf(fp, "\tsecurity context ");
-
-		if (RTA_PAYLOAD(tb[XFRMA_SEC_CTX]) < sizeof(*sctx))
-			fprintf(fp, "(ERROR truncated)");
-
-		sctx = RTA_DATA(tb[XFRMA_SEC_CTX]);
-
-		fprintf(fp, "%s %s", (char *)(sctx + 1), _SL_);
-	}
-
+	if (tb[XFRMA_SEC_CTX])
+		xfrm_sec_ctx_print(fp, tb[XFRMA_SEC_CTX]);
 }
 
 void xfrm_policy_info_print(struct xfrm_userpolicy_info *xpinfo,
@@ -1006,19 +1011,8 @@ void xfrm_policy_info_print(struct xfrm_userpolicy_info *xpinfo,
 
 	xfrm_selector_print(&xpinfo->sel, preferred_family, fp, title);
 
-	if (tb[XFRMA_SEC_CTX]) {
-		struct xfrm_user_sec_ctx *sctx;
-
-		fprintf(fp, "\tsecurity context ");
-
-		if (RTA_PAYLOAD(tb[XFRMA_SEC_CTX]) < sizeof(*sctx))
-			fprintf(fp, "(ERROR truncated)");
-
-		sctx = RTA_DATA(tb[XFRMA_SEC_CTX]);
-
-		fprintf(fp, "%s ", (char *)(sctx + 1));
-		fprintf(fp, "%s", _SL_);
-	}
+	if (tb[XFRMA_SEC_CTX])
+		xfrm_sec_ctx_print(fp, tb[XFRMA_SEC_CTX]);
 
 	if (prefix)
 		strlcat(buf, prefix, sizeof(buf));
-- 
2.30.1

