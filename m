Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EAA6A53B7
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 08:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjB1HcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 02:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjB1HcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 02:32:01 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975B9525F
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 23:32:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so12760689pjb.1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 23:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1xxP2YAFXjVm5rAYwUQGViAU+F6oywqIXjVt3cS8MPc=;
        b=AjI4FfuXPsdBjCv0j+BKd/s/yy3+/CdPB845MDXQBAYWdlt6wwyqes4FgaooaO02UU
         BCEF4fkl5Te/DfzYy1eckWf3oR/GgYGw2fvTC8m/shYNeGEVdu6VXZl6CR8sp5PMOCeW
         omA0eWZtUAbfSKiOCwvgFreakkzljJZ6R69Uj1b1hD3QO6jrHtrbE7389wGFCUKa6yGz
         UI3Qwq/64M/ib6efGPdJYrqPzQsOtG13bnPV9c2VJMoZTZrjN1eOpfbyOgZSSFq1XtRV
         i1+xWvWBIjFQBjzV/UWhA+tTlGwjjKQZ9bfOPbnkxz+bGMBhE6X9rHr/bqFdTvgG8oSK
         wMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1xxP2YAFXjVm5rAYwUQGViAU+F6oywqIXjVt3cS8MPc=;
        b=X5sHgHK/2N2cyYBRAj+Pl97PgTcx1uLK9iApi63JyWAPdgh1xEeeclpxHTff6PG6SA
         fPmBLQUnTsM5/WI11u8rQFLQ/Q0RPrARWvsh7EGtCcXpzJ3nJSmDFvC4M64f09nggzFe
         W0w4aCCVscPZzddZBOPAUU8NsncQdnOmH9xe3TWVld9o/sPLJgZ4NBxGKcRqU7VWJ+HD
         QX7RDvzwCVCg7LgwQhStNmLgX9Uo3qVZAQBD5PiEviGoj59mH8qSyf4QbNuJ5yNccJ37
         ZPghKdsxXFFNl7Gi8EAqdsBJ2RzdgeEm7yDBrEDdjRyoIuRaWBHYEjtYdPOJAbTVN86f
         VmmA==
X-Gm-Message-State: AO0yUKWclUs0ynOQxX2LgCf1cLK2ScYwWVA3ZjcptTro2wjotegbDUt0
        i3BCifrpJyA5rXbEOCXXNLWwoIrzUCuGaGol
X-Google-Smtp-Source: AK7set8jUmrJnXhypNv3vbAWyBF2wszCmyZrPr7Neb5Cf+1LeRYejMVFnt+Ixmr6Yh2Uow2KJmxSlQ==
X-Received: by 2002:a17:90b:30c5:b0:239:e70c:b96f with SMTP id hi5-20020a17090b30c500b00239e70cb96fmr740851pjb.41.1677569519519;
        Mon, 27 Feb 2023 23:31:59 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j8-20020a17090a588800b0022bf4d0f912sm7309565pji.22.2023.02.27.23.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 23:31:58 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Wen Liang <liangwen12year@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2] tc: f_u32: fix json object leak
Date:   Tue, 28 Feb 2023 15:31:46 +0800
Message-Id: <20230228073146.1224311-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, the code returned directly within the switch statement in
the functions print_{ipv4, ipv6}. While this approach was functional,
after the commit 721435dc, we can no longer return directly because we
need to close the match object. To resolve this issue, replace the return
statement with break.

Fixes: 721435dcfd92 ("tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tc/f_u32.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index de2d0c9e..936dbd65 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -828,12 +828,12 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 			print_nl();
 			print_uint(PRINT_ANY, "ip_ihl", "  match IP ihl %u",
 				   ntohl(key->val) >> 24);
-			return;
+			break;
 		case 0x00ff0000:
 			print_nl();
 			print_0xhex(PRINT_ANY, "ip_dsfield", "  match IP dsfield %#x",
 				    ntohl(key->val) >> 16);
-			return;
+			break;
 		}
 		break;
 	case 8:
@@ -841,7 +841,6 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 			print_nl();
 			print_int(PRINT_ANY, "ip_protocol", "  match IP protocol %d",
 				  ntohl(key->val) >> 16);
-			return;
 		}
 		break;
 	case 12:
@@ -864,7 +863,6 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 				print_string(PRINT_ANY, "address", "%s", addr);
 				print_int(PRINT_ANY, "prefixlen", "/%d", bits);
 				close_json_object();
-				return;
 			}
 		}
 		break;
@@ -874,19 +872,19 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 		case 0x0000ffff:
 			print_uint(PRINT_ANY, "dport", "match dport %u",
 				   ntohl(key->val) & 0xffff);
-			return;
+			break;
 		case 0xffff0000:
 			print_nl();
 			print_uint(PRINT_ANY, "sport", "  match sport %u",
 				   ntohl(key->val) >> 16);
-			return;
+			break;
 		case 0xffffffff:
 			print_nl();
 			print_uint(PRINT_ANY, "dport", "  match dport %u, ",
 				   ntohl(key->val) & 0xffff);
 			print_uint(PRINT_ANY, "sport", "match sport %u",
 				   ntohl(key->val) >> 16);
-			return;
+			break;
 		}
 		/* XXX: Default print_raw */
 	}
@@ -905,12 +903,12 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 			print_nl();
 			print_uint(PRINT_ANY, "ip_ihl", "  match IP ihl %u",
 				   ntohl(key->val) >> 24);
-			return;
+			break;
 		case 0x00ff0000:
 			print_nl();
 			print_0xhex(PRINT_ANY, "ip_dsfield", "  match IP dsfield %#x",
 				    ntohl(key->val) >> 16);
-			return;
+			break;
 		}
 		break;
 	case 8:
@@ -918,7 +916,6 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 			print_nl();
 			print_int(PRINT_ANY, "ip_protocol", "  match IP protocol %d",
 				  ntohl(key->val) >> 16);
-			return;
 		}
 		break;
 	case 12:
@@ -941,7 +938,6 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 				print_string(PRINT_ANY, "address", "%s", addr);
 				print_int(PRINT_ANY, "prefixlen", "/%d", bits);
 				close_json_object();
-				return;
 			}
 		}
 		break;
@@ -952,11 +948,11 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 			print_nl();
 			print_uint(PRINT_ANY, "sport", "  match sport %u",
 				   ntohl(key->val) & 0xffff);
-			return;
+			break;
 		case 0xffff0000:
 			print_uint(PRINT_ANY, "dport", "match dport %u",
 				   ntohl(key->val) >> 16);
-			return;
+			break;
 		case 0xffffffff:
 			print_nl();
 			print_uint(PRINT_ANY, "sport", "  match sport %u, ",
@@ -964,7 +960,7 @@ static void print_ipv6(FILE *f, const struct tc_u32_key *key)
 			print_uint(PRINT_ANY, "dport", "match dport %u",
 				   ntohl(key->val) >> 16);
 
-			return;
+			break;
 		}
 		/* XXX: Default print_raw */
 	}
-- 
2.38.1

