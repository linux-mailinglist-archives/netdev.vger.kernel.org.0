Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA649D2AC
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244521AbiAZTpl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Jan 2022 14:45:41 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:30983 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244513AbiAZTpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:45:40 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-TINpU8VvPUmZ-CFB4ciJUA-1; Wed, 26 Jan 2022 14:45:34 -0500
X-MC-Unique: TINpU8VvPUmZ-CFB4ciJUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B64401091DA0;
        Wed, 26 Jan 2022 19:45:33 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.16.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D51565DF21;
        Wed, 26 Jan 2022 19:45:25 +0000 (UTC)
From:   Wen Liang <liangwen12year@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: [PATCH iproute2 v5 1/2] tc: u32: add support for json output
Date:   Wed, 26 Jan 2022 14:44:47 -0500
Message-Id: <57492c3d29c42235627777d739b0b0f28ba60a36.1643225596.git.liangwen12year@gmail.com>
In-Reply-To: <cover.1643225596.git.liangwen12year@gmail.com>
References: <cover.1643225596.git.liangwen12year@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently u32 filter output does not support json. This commit uses
proper json functions to add support for it.

`sprint_u32_handle` adds an extra space after the raw check, remove the
extra space.

Signed-off-by: Wen Liang <liangwen12year@gmail.com>
---
 tc/f_u32.c | 83 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 46 insertions(+), 37 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index a5747f67..11da202e 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -109,7 +109,7 @@ static char *sprint_u32_handle(__u32 handle, char *buf)
 		}
 	}
 	if (show_raw)
-		snprintf(b, bsize, "[%08x] ", handle);
+		snprintf(b, bsize, "[%08x]", handle);
 	return buf;
 }
 
@@ -1213,11 +1213,11 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 
 	if (handle) {
 		SPRINT_BUF(b1);
-		fprintf(f, "fh %s ", sprint_u32_handle(handle, b1));
+		print_string(PRINT_ANY, "fh", "fh %s ", sprint_u32_handle(handle, b1));
 	}
 
 	if (TC_U32_NODE(handle))
-		fprintf(f, "order %d ", TC_U32_NODE(handle));
+		print_int(PRINT_ANY, "order", "order %d ", TC_U32_NODE(handle));
 
 	if (tb[TCA_U32_SEL]) {
 		if (RTA_PAYLOAD(tb[TCA_U32_SEL])  < sizeof(*sel))
@@ -1227,15 +1227,15 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 	}
 
 	if (tb[TCA_U32_DIVISOR]) {
-		fprintf(f, "ht divisor %d ",
-			rta_getattr_u32(tb[TCA_U32_DIVISOR]));
+		__u32 htdivisor = rta_getattr_u32(tb[TCA_U32_DIVISOR]);
+
+		print_int(PRINT_ANY, "ht_divisor", "ht divisor %d ", htdivisor);
 	} else if (tb[TCA_U32_HASH]) {
 		__u32 htid = rta_getattr_u32(tb[TCA_U32_HASH]);
-
-		fprintf(f, "key ht %x bkt %x ", TC_U32_USERHTID(htid),
-			TC_U32_HASH(htid));
+		print_hex(PRINT_ANY, "key_ht", "key ht %x ", TC_U32_USERHTID(htid));
+		print_hex(PRINT_ANY, "bkt", "bkt %x ", TC_U32_HASH(htid));
 	} else {
-		fprintf(f, "??? ");
+		fprintf(stderr, "divisor and hash missing ");
 	}
 	if (tb[TCA_U32_CLASSID]) {
 		SPRINT_BUF(b1);
@@ -1244,27 +1244,27 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 			sprint_tc_classid(rta_getattr_u32(tb[TCA_U32_CLASSID]),
 					  b1));
 	} else if (sel && sel->flags & TC_U32_TERMINAL) {
-		fprintf(f, "terminal flowid ??? ");
+		print_string(PRINT_FP, NULL, "terminal flowid ", NULL);
 	}
 	if (tb[TCA_U32_LINK]) {
 		SPRINT_BUF(b1);
-		fprintf(f, "link %s ",
-			sprint_u32_handle(rta_getattr_u32(tb[TCA_U32_LINK]),
-					  b1));
+		char *link = sprint_u32_handle(rta_getattr_u32(tb[TCA_U32_LINK]), b1);
+
+		print_string(PRINT_ANY, "link", "link %s ", link);
 	}
 
 	if (tb[TCA_U32_FLAGS]) {
 		__u32 flags = rta_getattr_u32(tb[TCA_U32_FLAGS]);
 
 		if (flags & TCA_CLS_FLAGS_SKIP_HW)
-			fprintf(f, "skip_hw ");
+			print_bool(PRINT_ANY, "skip_hw", "skip_hw ", true);
 		if (flags & TCA_CLS_FLAGS_SKIP_SW)
-			fprintf(f, "skip_sw ");
+			print_bool(PRINT_ANY, "skip_sw", "skip_sw ", true);
 
 		if (flags & TCA_CLS_FLAGS_IN_HW)
-			fprintf(f, "in_hw ");
+			print_bool(PRINT_ANY, "in_hw", "in_hw ", true);
 		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW)
-			fprintf(f, "not_in_hw ");
+			print_bool(PRINT_ANY, "not_in_hw", "not_in_hw ", true);
 	}
 
 	if (tb[TCA_U32_PCNT]) {
@@ -1275,10 +1275,10 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 		pf = RTA_DATA(tb[TCA_U32_PCNT]);
 	}
 
-	if (sel && show_stats && NULL != pf)
-		fprintf(f, " (rule hit %llu success %llu)",
-			(unsigned long long) pf->rcnt,
-			(unsigned long long) pf->rhit);
+	if (sel && show_stats && NULL != pf) {
+		print_u64(PRINT_ANY, "rule_hit", "(rule hit %llu ", pf->rcnt);
+		print_u64(PRINT_ANY, "success", "success %llu)", pf->rhit);
+	}
 
 	if (tb[TCA_U32_MARK]) {
 		struct tc_u32_mark *mark = RTA_DATA(tb[TCA_U32_MARK]);
@@ -1286,8 +1286,10 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 		if (RTA_PAYLOAD(tb[TCA_U32_MARK]) < sizeof(*mark)) {
 			fprintf(f, "\n  Invalid mark (kernel&iproute2 mismatch)\n");
 		} else {
-			fprintf(f, "\n  mark 0x%04x 0x%04x (success %d)",
-				mark->val, mark->mask, mark->success);
+			print_nl();
+			print_0xhex(PRINT_ANY, "fwmark_value", "  mark 0x%04x ", mark->val);
+			print_0xhex(PRINT_ANY, "fwmark_mask", "0x%04x ", mark->mask);
+			print_int(PRINT_ANY, "fwmark_success", "(success %d)", mark->success);
 		}
 	}
 
@@ -1298,38 +1300,45 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 			for (i = 0; i < sel->nkeys; i++) {
 				show_keys(f, sel->keys + i);
 				if (show_stats && NULL != pf)
-					fprintf(f, " (success %llu ) ",
-						(unsigned long long) pf->kcnts[i]);
+					print_u64(PRINT_ANY, "success", " (success %llu ) ",
+						  pf->kcnts[i]);
 			}
 		}
 
 		if (sel->flags & (TC_U32_VAROFFSET | TC_U32_OFFSET)) {
-			fprintf(f, "\n    offset ");
-			if (sel->flags & TC_U32_VAROFFSET)
-				fprintf(f, "%04x>>%d at %d ",
-					ntohs(sel->offmask),
-					sel->offshift,  sel->offoff);
+			print_nl();
+			print_string(PRINT_ANY, NULL, "%s", "    offset ");
+			if (sel->flags & TC_U32_VAROFFSET) {
+				print_hex(PRINT_ANY, "offset_mask", "%04x", ntohs(sel->offmask));
+				print_int(PRINT_ANY, "offset_shift", ">>%d ", sel->offshift);
+				print_int(PRINT_ANY, "offset_off", "at %d ", sel->offoff);
+			}
 			if (sel->off)
-				fprintf(f, "plus %d ", sel->off);
+				print_int(PRINT_ANY, "plus", "plus %d ", sel->off);
 		}
 		if (sel->flags & TC_U32_EAT)
-			fprintf(f, " eat ");
+			print_string(PRINT_ANY, NULL, "%s", " eat ");
 
 		if (sel->hmask) {
-			fprintf(f, "\n    hash mask %08x at %d ",
-				(unsigned int)htonl(sel->hmask), sel->hoff);
+			print_nl();
+			unsigned int hmask = (unsigned int)htonl(sel->hmask);
+
+			print_hex(PRINT_ANY, "hash_mask", "    hash mask %08x ", hmask);
+			print_int(PRINT_ANY, "hash_off", "at %d ", sel->hoff);
 		}
 	}
 
 	if (tb[TCA_U32_POLICE]) {
-		fprintf(f, "\n");
+		print_nl();
 		tc_print_police(f, tb[TCA_U32_POLICE]);
 	}
 
 	if (tb[TCA_U32_INDEV]) {
 		struct rtattr *idev = tb[TCA_U32_INDEV];
-
-		fprintf(f, "\n  input dev %s\n", rta_getattr_str(idev));
+		print_nl();
+		print_string(PRINT_ANY, "input_dev", "  input dev %s",
+			     rta_getattr_str(idev));
+		print_nl();
 	}
 
 	if (tb[TCA_U32_ACT])
-- 
2.26.3

