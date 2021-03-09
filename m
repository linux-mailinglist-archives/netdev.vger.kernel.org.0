Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6BA332ADA
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhCIPox convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Mar 2021 10:44:53 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:43534 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230320AbhCIPow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:44:52 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-iP3sHKgxONuOenQueOxIGA-1; Tue, 09 Mar 2021 10:44:41 -0500
X-MC-Unique: iP3sHKgxONuOenQueOxIGA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 068EA1009E3B;
        Tue,  9 Mar 2021 15:44:40 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.194.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E24710013C1;
        Tue,  9 Mar 2021 15:44:38 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Paul Wouters <pwouters@redhat.com>
Subject: [PATCH iproute2 v2] ip: xfrm: limit the length of the security context name when printing
Date:   Tue,  9 Mar 2021 16:44:33 +0100
Message-Id: <30d3fd8902faec256942ffd09176ea53aa03119b.1615303062.git.sd@queasysnail.net>
In-Reply-To: <20210308091841.5d572cf1@hermes.local>
References: <20210308091841.5d572cf1@hermes.local>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
the string is determined by sctx->ctx_len, so we can use that to limit
what fprintf outputs.

While at it, factor that out to a separate function, since the exact
same code is used to print the security context for both policies and
states.

Fixes: b2bb289a57fe ("xfrm security context support")
Reported-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
v2: drop the memcpy and use %.*s, suggested by Stephen Hemminger

 ip/ipxfrm.c | 43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index e4a72bd06778..8a794032cf12 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -916,6 +916,19 @@ static int xfrm_selector_iszero(struct xfrm_selector *s)
 	return (memcmp(&s0, s, sizeof(s0)) == 0);
 }
 
+static void xfrm_sec_ctx_print(FILE *fp, struct rtattr *attr)
+{
+	struct xfrm_user_sec_ctx *sctx;
+
+	fprintf(fp, "\tsecurity context ");
+
+	if (RTA_PAYLOAD(attr) < sizeof(*sctx))
+		fprintf(fp, "(ERROR truncated)");
+
+	sctx = RTA_DATA(attr);
+	fprintf(fp, "%.*s %s", sctx->ctx_len, (char *)(sctx + 1), _SL_);
+}
+
 void xfrm_state_info_print(struct xfrm_usersa_info *xsinfo,
 			    struct rtattr *tb[], FILE *fp, const char *prefix,
 			    const char *title, bool nokeys)
@@ -983,19 +996,8 @@ void xfrm_state_info_print(struct xfrm_usersa_info *xsinfo,
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
@@ -1006,19 +1008,8 @@ void xfrm_policy_info_print(struct xfrm_userpolicy_info *xpinfo,
 
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

