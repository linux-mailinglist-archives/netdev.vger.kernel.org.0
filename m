Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2826A40222E
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 04:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbhIGB7K convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Sep 2021 21:59:10 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:57921 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242371AbhIGB7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 21:59:08 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-hR0JNUt1OJiAGKgd5KSpSA-1; Mon, 06 Sep 2021 21:57:59 -0400
X-MC-Unique: hR0JNUt1OJiAGKgd5KSpSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BC84512C;
        Tue,  7 Sep 2021 01:57:58 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.8.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D92E5C1CF;
        Tue,  7 Sep 2021 01:57:58 +0000 (UTC)
From:   Wen Liang <liangwen12year@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: [PATCH iproute2 2/2] tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`
Date:   Mon,  6 Sep 2021 21:57:51 -0400
Message-Id: <2b9f656b2864a1310d6239a32c57b2d84077b903.1630978600.git.liangwen12year@gmail.com>
In-Reply-To: <cover.1630978600.git.liangwen12year@gmail.com>
References: <cover.1630978600.git.liangwen12year@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=liangwen12year@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Wen Liang <liangwen12year@gmail.com>
---
 tc/f_u32.c | 72 +++++++++++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 42 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index 136fb740..8558ab6d 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -828,19 +828,16 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 	case 0:
 		switch (ntohl(key->mask)) {
 		case 0x0f000000:
-			fprintf(f, "\n  match IP ihl %u",
-				ntohl(key->val) >> 24);
+			print_uint(PRINT_ANY, "match IP ihl", "\n  match IP ihl %u", ntohl(key->val) >> 24);
 			return;
 		case 0x00ff0000:
-			fprintf(f, "\n  match IP dsfield %#x",
-				ntohl(key->val) >> 16);
+			print_0xhex(PRINT_ANY, "match IP dsfield", "\n  match IP dsfield %#x", ntohl(key->val) >> 16);
 			return;
 		}
 		break;
 	case 8:
 		if (ntohl(key->mask) == 0x00ff0000) {
-			fprintf(f, "\n  match IP protocol %d",
-				ntohl(key->val) >> 16);
+			print_int(PRINT_ANY, "match IP protocol", "\n  match IP protocol %d", ntohl(key->val) >> 16);
 			return;
 		}
 		break;
@@ -849,11 +846,12 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 			int bits = mask2bits(key->mask);
 
 			if (bits >= 0) {
-				fprintf(f, "\n  %s %s/%d",
-					key->off == 12 ? "match IP src" : "match IP dst",
-					inet_ntop(AF_INET, &key->val,
-						  abuf, sizeof(abuf)),
-					bits);
+				if (key->off == 12)
+					print_string(PRINT_ANY, "match IP", "\n  %s ", "src");
+				else
+					print_string(PRINT_ANY, "match IP", "\n  %s ", "dst");
+				print_string(PRINT_ANY, "IP Addr", "%s", inet_ntop(AF_INET, &key->val, abuf, sizeof(abuf)));
+				print_int(PRINT_ANY, "IP Addr prefix", "/%d", bits);
 				return;
 			}
 		}
@@ -862,18 +860,14 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 	case 20:
 		switch (ntohl(key->mask)) {
 		case 0x0000ffff:
-			fprintf(f, "\n  match dport %u",
-				ntohl(key->val) & 0xffff);
+			print_uint(PRINT_ANY, "match dport", "match dport %u", ntohl(key->val) & 0xffff);
 			return;
 		case 0xffff0000:
-			fprintf(f, "\n  match sport %u",
-				ntohl(key->val) >> 16);
+			print_uint(PRINT_ANY, "match sport", "\n  match sport %u", ntohl(key->val) >> 16);
 			return;
 		case 0xffffffff:
-			fprintf(f, "\n  match dport %u, match sport %u",
-				ntohl(key->val) & 0xffff,
-				ntohl(key->val) >> 16);
-
+			print_uint(PRINT_ANY, "match dport", "\n  match dport %u, ", ntohl(key->val) & 0xffff);
+			print_uint(PRINT_ANY, "match sport", "match sport %u", ntohl(key->val) >> 16);
 			return;
 		}
 		/* XXX: Default print_raw */
@@ -888,19 +882,16 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 	case 0:
 		switch (ntohl(key->mask)) {
 		case 0x0f000000:
-			fprintf(f, "\n  match IP ihl %u",
-				ntohl(key->val) >> 24);
+			print_uint(PRINT_ANY, "match IP ihl", "\n  match IP ihl %u", ntohl(key->val) >> 24);
 			return;
 		case 0x00ff0000:
-			fprintf(f, "\n  match IP dsfield %#x",
-				ntohl(key->val) >> 16);
+			print_0xhex(PRINT_ANY, "match IP dsfield", "\n  match IP dsfield %#x", ntohl(key->val) >> 16);
 			return;
 		}
 		break;
 	case 8:
 		if (ntohl(key->mask) == 0x00ff0000) {
-			fprintf(f, "\n  match IP protocol %d",
-				ntohl(key->val) >> 16);
+			print_int(PRINT_ANY, "match IP protocol", "\n  match IP protocol %d", ntohl(key->val) >> 16);
 			return;
 		}
 		break;
@@ -909,11 +900,12 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 			int bits = mask2bits(key->mask);
 
 			if (bits >= 0) {
-				fprintf(f, "\n  %s %s/%d",
-					key->off == 12 ? "match IP src" : "match IP dst",
-					inet_ntop(AF_INET, &key->val,
-						  abuf, sizeof(abuf)),
-					bits);
+				if (key->off == 12)
+					print_string(PRINT_ANY, "match IP", "\n  %s ", "src");
+				else
+					print_string(PRINT_ANY, "match IP", "\n  %s ", "dst");
+				print_string(PRINT_ANY, "IP Addr", "%s", inet_ntop(AF_INET, &key->val, abuf, sizeof(abuf)));
+				print_int(PRINT_ANY, "IP Addr prefix", "/%d", bits);
 				return;
 			}
 		}
@@ -922,17 +914,14 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 	case 20:
 		switch (ntohl(key->mask)) {
 		case 0x0000ffff:
-			fprintf(f, "\n  match sport %u",
-				ntohl(key->val) & 0xffff);
+			print_uint(PRINT_ANY, "match sport", "\n  match sport %u", ntohl(key->val) & 0xffff);
 			return;
 		case 0xffff0000:
-			fprintf(f, "\n  match dport %u",
-				ntohl(key->val) >> 16);
+			print_uint(PRINT_ANY, "match dport", "match dport %u", ntohl(key->val) >> 16);
 			return;
 		case 0xffffffff:
-			fprintf(f, "\n  match sport %u, match dport %u",
-				ntohl(key->val) & 0xffff,
-				ntohl(key->val) >> 16);
+			print_uint(PRINT_ANY, "match sport", "\n  match sport %u, ", ntohl(key->val) & 0xffff);
+			print_uint(PRINT_ANY, "match dport", "match dport %u", ntohl(key->val) >> 16);
 
 			return;
 		}
@@ -942,11 +931,10 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 
 static void print_raw(FILE *f, const struct tc_u32_key *key)
 {
-	fprintf(f, "\n  match %08x/%08x at %s%d",
-		(unsigned int)ntohl(key->val),
-		(unsigned int)ntohl(key->mask),
-		key->offmask ? "nexthdr+" : "",
-		key->off);
+	print_hex(PRINT_ANY, "match value", "\n  match %08x", (unsigned int)ntohl(key->val));
+	print_hex(PRINT_ANY, "match mask", "/%08x ", (unsigned int)ntohl(key->mask));
+	print_string(PRINT_ANY, "match offmask", "at %s", key->offmask ? "nexthdr+" : "");
+	print_int(PRINT_ANY, "match off", "%d", key->off);
 }
 
 static const struct {
-- 
2.26.3

