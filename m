Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448D32D6B7F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388889AbgLJXEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387786AbgLJXDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:03:37 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAF1C06179C
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:02:56 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CsTwH430XzQlRP;
        Fri, 11 Dec 2020 00:02:55 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5vnNqE6x6mV0enZrSKQvkl8730qMnp5s4HZb5qFlhnQ=;
        b=qnfbyGV7fkL8VB/JMfQGx9aKpw/d9h5FCKZIe0ps/7sgegiDjEkOW0bHqT87RfHcWxmjzz
        hKBD7Vtpt8iNYYrraO4OzL/zTVDaJXL1rYsMISfPEHxSJ90MwAKa2hRg8XoZNfSD5TOYHH
        zukJBXETR1hf6p8YATRcZh0qXmGHdtQwal491TccooIyJeav9V0jpSvPnLBrvWVu5zS9J0
        /B/DEOPe66WofWvTxx1hUHfMRv1tRrqLLsDLtxO1kloWy0yEu1sVdL6SfO5RjTg9QYOlgd
        +SwV3pAX9Hppd6lZuIBtSvR0iaYYPek3GUt1lmeqxcHlQXIGMY6jWoj8adJjbg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id MsD5UzgIGVoL; Fri, 11 Dec 2020 00:02:52 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 05/10] dcb: Add dcb_set_u32(), dcb_set_u64()
Date:   Fri, 11 Dec 2020 00:02:19 +0100
Message-Id: <3cc56cf0415b035561885ae3d48986e248ec3c7e.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.53 / 15.00 / 15.00
X-Rspamd-Queue-Id: 922091778
X-Rspamd-UID: 206e14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DCB buffer object has a settable array of 32-bit quantities, and the
maxrate object of 64-bit ones. Adjust dcb_parse_mapping() and related
helpers to support 64-bit values in mappings, and add appropriate helpers.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c | 22 ++++++++++++++++++----
 dcb/dcb.h |  8 +++++---
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 217dd640d7e5..7c0beee43686 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -229,8 +229,8 @@ void dcb_print_named_array(const char *json_name, const char *fp_name,
 }
 
 int dcb_parse_mapping(const char *what_key, __u32 key, __u32 max_key,
-		      const char *what_value, __u32 value, __u32 max_value,
-		      void (*set_array)(__u32 index, __u32 value, void *data),
+		      const char *what_value, __u64 value, __u64 max_value,
+		      void (*set_array)(__u32 index, __u64 value, void *data),
 		      void *set_array_data)
 {
 	bool is_all = key == (__u32) -1;
@@ -242,7 +242,7 @@ int dcb_parse_mapping(const char *what_key, __u32 key, __u32 max_key,
 	}
 
 	if (value > max_value) {
-		fprintf(stderr, "In %s:%s mapping, %s is expected to be 0..%d\n",
+		fprintf(stderr, "In %s:%s mapping, %s is expected to be 0..%llu\n",
 			what_key, what_value, what_value, max_value);
 		return -EINVAL;
 	}
@@ -257,13 +257,27 @@ int dcb_parse_mapping(const char *what_key, __u32 key, __u32 max_key,
 	return 0;
 }
 
-void dcb_set_u8(__u32 key, __u32 value, void *data)
+void dcb_set_u8(__u32 key, __u64 value, void *data)
 {
 	__u8 *array = data;
 
 	array[key] = value;
 }
 
+void dcb_set_u32(__u32 key, __u64 value, void *data)
+{
+	__u32 *array = data;
+
+	array[key] = value;
+}
+
+void dcb_set_u64(__u32 key, __u64 value, void *data)
+{
+	__u64 *array = data;
+
+	array[key] = value;
+}
+
 int dcb_cmd_parse_dev(struct dcb *dcb, int argc, char **argv,
 		      int (*and_then)(struct dcb *dcb, const char *dev,
 				      int argc, char **argv),
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 6f135ed06b08..d22176888811 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -14,15 +14,17 @@ struct dcb {
 };
 
 int dcb_parse_mapping(const char *what_key, __u32 key, __u32 max_key,
-		      const char *what_value, __u32 value, __u32 max_value,
-		      void (*set_array)(__u32 index, __u32 value, void *data),
+		      const char *what_value, __u64 value, __u64 max_value,
+		      void (*set_array)(__u32 index, __u64 value, void *data),
 		      void *set_array_data);
 int dcb_cmd_parse_dev(struct dcb *dcb, int argc, char **argv,
 		      int (*and_then)(struct dcb *dcb, const char *dev,
 				      int argc, char **argv),
 		      void (*help)(void));
 
-void dcb_set_u8(__u32 key, __u32 value, void *data);
+void dcb_set_u8(__u32 key, __u64 value, void *data);
+void dcb_set_u32(__u32 key, __u64 value, void *data);
+void dcb_set_u64(__u32 key, __u64 value, void *data);
 
 int dcb_get_attribute(struct dcb *dcb, const char *dev, int attr,
 		      void *data, size_t data_len);
-- 
2.25.1

