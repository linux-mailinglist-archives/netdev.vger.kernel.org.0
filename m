Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAD44919B1
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346528AbiARCz3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jan 2022 21:55:29 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:33697 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347667AbiARCmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:42:35 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-24a67ZNhOQiH-RbIKePALQ-1; Mon, 17 Jan 2022 21:42:28 -0500
X-MC-Unique: 24a67ZNhOQiH-RbIKePALQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFE6C1083F64;
        Tue, 18 Jan 2022 02:42:27 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.32.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E72D4D73A;
        Tue, 18 Jan 2022 02:42:27 +0000 (UTC)
From:   Wen Liang <liangwen12year@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: [PATCH iproute2 v4 2/2] tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`
Date:   Mon, 17 Jan 2022 21:42:21 -0500
Message-Id: <562f7200730502e65486cac9341cdbedac84c5be.1642472827.git.wenliang@redhat.com>
In-Reply-To: <cover.1642472827.git.wenliang@redhat.com>
References: <cover.1642472827.git.wenliang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Wen Liang <liangwen12year@gmail.com>
---
 tc/f_u32.c | 119 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 42 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index 03dbe774..93c8a840 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -824,23 +824,27 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 {
 	char abuf[256];
 
+	open_json_object("match");
 	switch (key->off) {
 	case 0:
 		switch (ntohl(key->mask)) {
 		case 0x0f000000:
-			fprintf(f, "\n  match IP ihl %u",
-				ntohl(key->val) >> 24);
+			print_nl();
+			print_uint(PRINT_ANY, "ip_ihl", "  match IP ihl %u",
+						ntohl(key->val) >> 24);
 			return;
 		case 0x00ff0000:
-			fprintf(f, "\n  match IP dsfield %#x",
-				ntohl(key->val) >> 16);
+			print_nl();
+			print_0xhex(PRINT_ANY, "ip_dsfield", "  match IP dsfield %#x",
+						ntohl(key->val) >> 16);
 			return;
 		}
 		break;
 	case 8:
 		if (ntohl(key->mask) == 0x00ff0000) {
-			fprintf(f, "\n  match IP protocol %d",
-				ntohl(key->val) >> 16);
+			print_nl();
+			print_int(PRINT_ANY, "ip_protocol", "  match IP protocol %d",
+						ntohl(key->val) >> 16);
 			return;
 		}
 		break;
@@ -849,11 +853,20 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 			int bits = mask2bits(key->mask);
 
 			if (bits >= 0) {
-				fprintf(f, "\n  %s %s/%d",
-					key->off == 12 ? "match IP src" : "match IP dst",
-					inet_ntop(AF_INET, &key->val,
-						  abuf, sizeof(abuf)),
-					bits);
+				 const char *addr;
+				 if (key->off == 12) {
+				       print_nl();
+				       print_null(PRINT_FP, NULL, "  match IP src ", NULL);
+				       open_json_object("src");
+				 } else {
+				       print_nl();
+				       print_null(PRINT_FP, NULL, "  match IP dst ", NULL);
+				       open_json_object("dst");
+				 }
+				 addr = inet_ntop(AF_INET, &key->val, abuf, sizeof(abuf));
+				 print_string(PRINT_ANY, "address", "%s", addr);
+				 print_int(PRINT_ANY, "prefixlen", "/%d", bits);
+				 close_json_object();
 				return;
 			}
 		}
@@ -862,45 +875,52 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 	case 20:
 		switch (ntohl(key->mask)) {
 		case 0x0000ffff:
-			fprintf(f, "\n  match dport %u",
-				ntohl(key->val) & 0xffff);
+			print_uint(PRINT_ANY, "dport", "match dport %u",
+						ntohl(key->val) & 0xffff);
 			return;
 		case 0xffff0000:
-			fprintf(f, "\n  match sport %u",
-				ntohl(key->val) >> 16);
+			print_nl();
+			print_uint(PRINT_ANY, "sport", "  match sport %u",
+						ntohl(key->val) >> 16);
 			return;
 		case 0xffffffff:
-			fprintf(f, "\n  match dport %u, match sport %u",
-				ntohl(key->val) & 0xffff,
-				ntohl(key->val) >> 16);
-
+			print_nl();
+			print_uint(PRINT_ANY, "dport", "  match dport %u, ",
+						ntohl(key->val) & 0xffff);
+			print_uint(PRINT_ANY, "sport", "match sport %u",
+						ntohl(key->val) >> 16);
 			return;
 		}
 		/* XXX: Default print_raw */
 	}
+	close_json_object();
 }
 
 static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 {
 	char abuf[256];
 
+	open_json_object("match");
 	switch (key->off) {
 	case 0:
 		switch (ntohl(key->mask)) {
 		case 0x0f000000:
-			fprintf(f, "\n  match IP ihl %u",
-				ntohl(key->val) >> 24);
+			print_nl();
+			print_uint(PRINT_ANY, "ip_ihl", "  match IP ihl %u",
+						ntohl(key->val) >> 24);
 			return;
 		case 0x00ff0000:
-			fprintf(f, "\n  match IP dsfield %#x",
-				ntohl(key->val) >> 16);
+			print_nl();
+			print_0xhex(PRINT_ANY, "ip_dsfield", "  match IP dsfield %#x",
+						ntohl(key->val) >> 16);
 			return;
 		}
 		break;
 	case 8:
 		if (ntohl(key->mask) == 0x00ff0000) {
-			fprintf(f, "\n  match IP protocol %d",
-				ntohl(key->val) >> 16);
+			print_nl();
+			print_int(PRINT_ANY, "ip_protocol", "  match IP protocol %d",
+						ntohl(key->val) >> 16);
 			return;
 		}
 		break;
@@ -909,11 +929,20 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 			int bits = mask2bits(key->mask);
 
 			if (bits >= 0) {
-				fprintf(f, "\n  %s %s/%d",
-					key->off == 12 ? "match IP src" : "match IP dst",
-					inet_ntop(AF_INET, &key->val,
-						  abuf, sizeof(abuf)),
-					bits);
+				const char *addr;
+				if (key->off == 12) {
+			              print_nl();
+				      print_null(PRINT_FP, NULL, "  match IP src ", NULL);
+				      open_json_object("src");
+				} else {
+			              print_nl();
+				      print_null(PRINT_FP, NULL, "  match IP dst ", NULL);
+				      open_json_object("dst");
+				}
+				addr = inet_ntop(AF_INET, &key->val, abuf, sizeof(abuf));
+				print_string(PRINT_ANY, "address", "%s", addr);
+				print_int(PRINT_ANY, "prefixlen", "/%d", bits);
+				close_json_object();
 				return;
 			}
 		}
@@ -922,31 +951,37 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 	case 20:
 		switch (ntohl(key->mask)) {
 		case 0x0000ffff:
-			fprintf(f, "\n  match sport %u",
-				ntohl(key->val) & 0xffff);
+			print_nl();
+			print_uint(PRINT_ANY, "sport", "  match sport %u",
+						ntohl(key->val) & 0xffff);
 			return;
 		case 0xffff0000:
-			fprintf(f, "\n  match dport %u",
-				ntohl(key->val) >> 16);
+			print_uint(PRINT_ANY, "dport", "match dport %u",
+						ntohl(key->val) >> 16);
 			return;
 		case 0xffffffff:
-			fprintf(f, "\n  match sport %u, match dport %u",
-				ntohl(key->val) & 0xffff,
-				ntohl(key->val) >> 16);
+			print_nl();
+			print_uint(PRINT_ANY, "sport", "  match sport %u, ",
+						ntohl(key->val) & 0xffff);
+			print_uint(PRINT_ANY, "dport", "match dport %u",
+						ntohl(key->val) >> 16);
 
 			return;
 		}
 		/* XXX: Default print_raw */
 	}
+	close_json_object();
 }
 
 static void print_raw(FILE *f, const struct tc_u32_key *key)
 {
-	fprintf(f, "\n  match %08x/%08x at %s%d",
-		(unsigned int)ntohl(key->val),
-		(unsigned int)ntohl(key->mask),
-		key->offmask ? "nexthdr+" : "",
-		key->off);
+	open_json_object("match");
+	print_nl();
+	print_hex(PRINT_ANY, "value", "  match %08x", (unsigned int)ntohl(key->val));
+	print_hex(PRINT_ANY, "mask", "/%08x ", (unsigned int)ntohl(key->mask));
+	print_string(PRINT_ANY, "offmask", "at %s", key->offmask ? "nexthdr+" : "");
+	print_int(PRINT_ANY, "off", "%d", key->off);
+	close_json_object();
 }
 
 static const struct {
-- 
2.26.3

