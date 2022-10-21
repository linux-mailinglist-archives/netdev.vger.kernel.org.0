Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246826078D1
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiJUNph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiJUNpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:45:34 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804D792CCE
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 06:45:28 -0700 (PDT)
Received: (qmail 18684 invoked from network); 21 Oct 2022 13:44:36 -0000
Received: from p200300cf07087500581cdcfffecf391f.dip0.t-ipconnect.de ([2003:cf:708:7500:581c:dcff:fecf:391f]:60600 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <tgraf@suug.ch>; Fri, 21 Oct 2022 15:44:36 +0200
From:   Rolf Eike Beer <eike@sf-mail.de>
To:     Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] rhashtable: make test actually random
Date:   Fri, 21 Oct 2022 15:45:23 +0200
Message-ID: <12102372.O9o76ZdvQC@eto.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "random rhlist add/delete operations" actually wasn't very random, as all
cases tested the same bit. Since the later parts of this loop depend on the
first case execute this unconditionally, and then test on different bits for the
remaining tests. While at it only request as much random bits as are actually
used.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 lib/test_rhashtable.c | 58 ++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 36 deletions(-)

diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index b358a74ed7ed..f2ba5787055a 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -369,18 +369,10 @@ static int __init test_rhltable(unsigned int entries)
 	pr_info("test %d random rhlist add/delete operations\n", entries);
 	for (j = 0; j < entries; j++) {
 		u32 i = prandom_u32_max(entries);
-		u32 prand = get_random_u32();
+		u32 prand = prandom_u32_max(4);
 
 		cond_resched();
 
-		if (prand == 0)
-			prand = get_random_u32();
-
-		if (prand & 1) {
-			prand >>= 1;
-			continue;
-		}
-
 		err = rhltable_remove(&rhlt, &rhl_test_objects[i].list_node, test_rht_params);
 		if (test_bit(i, obj_in_table)) {
 			clear_bit(i, obj_in_table);
@@ -393,35 +385,29 @@ static int __init test_rhltable(unsigned int entries)
 		}
 
 		if (prand & 1) {
-			prand >>= 1;
-			continue;
-		}
-
-		err = rhltable_insert(&rhlt, &rhl_test_objects[i].list_node, test_rht_params);
-		if (err == 0) {
-			if (WARN(test_and_set_bit(i, obj_in_table), "succeeded to insert same object %d", i))
-				continue;
-		} else {
-			if (WARN(!test_bit(i, obj_in_table), "failed to insert object %d", i))
-				continue;
-		}
-
-		if (prand & 1) {
-			prand >>= 1;
-			continue;
+			err = rhltable_insert(&rhlt, &rhl_test_objects[i].list_node, test_rht_params);
+			if (err == 0) {
+				if (WARN(test_and_set_bit(i, obj_in_table), "succeeded to insert same object %d", i))
+					continue;
+			} else {
+				if (WARN(!test_bit(i, obj_in_table), "failed to insert object %d", i))
+					continue;
+			}
 		}
 
-		i = prandom_u32_max(entries);
-		if (test_bit(i, obj_in_table)) {
-			err = rhltable_remove(&rhlt, &rhl_test_objects[i].list_node, test_rht_params);
-			WARN(err, "cannot remove element at slot %d", i);
-			if (err == 0)
-				clear_bit(i, obj_in_table);
-		} else {
-			err = rhltable_insert(&rhlt, &rhl_test_objects[i].list_node, test_rht_params);
-			WARN(err, "failed to insert object %d", i);
-			if (err == 0)
-				set_bit(i, obj_in_table);
+		if (prand & 2) {
+			i = prandom_u32_max(entries);
+			if (test_bit(i, obj_in_table)) {
+				err = rhltable_remove(&rhlt, &rhl_test_objects[i].list_node, test_rht_params);
+				WARN(err, "cannot remove element at slot %d", i);
+				if (err == 0)
+					clear_bit(i, obj_in_table);
+			} else {
+				err = rhltable_insert(&rhlt, &rhl_test_objects[i].list_node, test_rht_params);
+				WARN(err, "failed to insert object %d", i);
+				if (err == 0)
+					set_bit(i, obj_in_table);
+			}
 		}
 	}
 
-- 
2.35.3




