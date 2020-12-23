Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48592E206B
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgLWS1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgLWS1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:44 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D07CC0611C5
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:48 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4D1M9946gMzQlKg;
        Wed, 23 Dec 2020 19:26:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ulAgP4m5yUHMlat9is9a10UiokbZdfd5E67W2hw6nME=;
        b=dS+QhYJK3SPq4gjzEhEq1fAgD5zjd63tpHSGRUGysebX7NAlkE4uVdowrC7g9YPaVHHoDD
        kANnM8r2Nqf2dnaxJRK7NuLode5UP846Fq90zD5kXlWLxn19YaUDXoCXhdAryPawnPo/FV
        ZOqZvWa5XHaA9+A7g1055q14SE9iG5AoAjY2KeR3CD2lnqSxDKzPozgl+WXZHDwpp+Ca+k
        vEBhn/0TRmjYEUUwH85qFv+0LvhSPshlgIWttoG9m53RA/zVmjZkhHz1cunGudV0CZOip6
        TgEx/ZMqucVv0RLTAvLyYM4UIgCSCTkxo5ubM9y+AiXHt/E8fDhL+oKL1xT8fg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id Hucv65g9YsMN; Wed, 23 Dec 2020 19:26:18 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 4/9] lib: Generalize parse_mapping()
Date:   Wed, 23 Dec 2020 19:25:42 +0100
Message-Id: <c4a47b7cb2afa735843bcee6027a8176513651e5.1608746691.git.me@pmachata.org>
In-Reply-To: <cover.1608746691.git.me@pmachata.org>
References: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.47 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9003217E2
X-Rspamd-UID: 93315d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function parse_mapping() assumes the key is a number, with a single
configurable exception, which is using "all" to mean "all possible keys".
If a caller wishes to use symbolic names instead of numbers, they cannot
reuse this function.

To facilitate reuse in these situations, convert parse_mapping() into a
helper, parse_mapping_gen(), which instead of an allow-all boolean takes a
generic key-parsing callback. Rewrite parse_mapping() in terms of this
newly-added helper and add a pair of key parsers, one for just numbers,
another for numbers and the keyword "all". Publish the latter as well.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h |  5 +++++
 lib/utils.c     | 37 +++++++++++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 1704392525a2..f1403f7306a0 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -331,6 +331,11 @@ int parse_one_of(const char *msg, const char *realval, const char * const *list,
 		 size_t len, int *p_err);
 bool parse_on_off(const char *msg, const char *realval, int *p_err);
 
+int parse_mapping_num_all(__u32 *keyp, const char *key);
+int parse_mapping_gen(int *argcp, char ***argvp,
+		      int (*key_cb)(__u32 *keyp, const char *key),
+		      int (*mapping_cb)(__u32 key, char *value, void *data),
+		      void *mapping_cb_data);
 int parse_mapping(int *argcp, char ***argvp, bool allow_all,
 		  int (*mapping_cb)(__u32 key, char *value, void *data),
 		  void *mapping_cb_data);
diff --git a/lib/utils.c b/lib/utils.c
index de875639c608..90e58fa309d5 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1878,9 +1878,10 @@ bool parse_on_off(const char *msg, const char *realval, int *p_err)
 	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
 }
 
-int parse_mapping(int *argcp, char ***argvp, bool allow_all,
-		  int (*mapping_cb)(__u32 key, char *value, void *data),
-		  void *mapping_cb_data)
+int parse_mapping_gen(int *argcp, char ***argvp,
+		      int (*key_cb)(__u32 *keyp, const char *key),
+		      int (*mapping_cb)(__u32 key, char *value, void *data),
+		      void *mapping_cb_data)
 {
 	int argc = *argcp;
 	char **argv = *argvp;
@@ -1894,9 +1895,7 @@ int parse_mapping(int *argcp, char ***argvp, bool allow_all,
 			break;
 		*colon = '\0';
 
-		if (allow_all && matches(*argv, "all") == 0) {
-			key = (__u32) -1;
-		} else if (get_u32(&key, *argv, 0)) {
+		if (key_cb(&key, *argv)) {
 			ret = 1;
 			break;
 		}
@@ -1912,3 +1911,29 @@ int parse_mapping(int *argcp, char ***argvp, bool allow_all,
 	*argvp = argv;
 	return ret;
 }
+
+static int parse_mapping_num(__u32 *keyp, const char *key)
+{
+	return get_u32(keyp, key, 0);
+}
+
+int parse_mapping_num_all(__u32 *keyp, const char *key)
+{
+	if (matches(key, "all") == 0) {
+		*keyp = (__u32) -1;
+		return 0;
+	}
+	return parse_mapping_num(keyp, key);
+}
+
+int parse_mapping(int *argcp, char ***argvp, bool allow_all,
+		  int (*mapping_cb)(__u32 key, char *value, void *data),
+		  void *mapping_cb_data)
+{
+	if (allow_all)
+		return parse_mapping_gen(argcp, argvp, parse_mapping_num_all,
+					 mapping_cb, mapping_cb_data);
+	else
+		return parse_mapping_gen(argcp, argvp, parse_mapping_num,
+					 mapping_cb, mapping_cb_data);
+}
-- 
2.25.1

