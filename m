Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756F93718E1
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 18:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhECQJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 12:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhECQJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 12:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D216135F;
        Mon,  3 May 2021 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620058116;
        bh=HItDpK1OnwmfOTCtQau1BbnqvTTMqZ7yBoEI91WHxq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9E7cY+3j9CYSZIjabgNdqm5qR+DxuW04K90E95w8aIcmBAfBvBfYShWVCYllSfrT
         arY4VRw4ELftm/S7gxqhhHcXJXchl3YCrB/K6TTEEJU8OLs07Vm1jwsQbGkCY6DjSu
         Amhs3AjBIiqDscjFbUgw0YV1aUFQBewHDlwx/+1azHomzZZlsVnbjzObS2N+ryIYn3
         51+DOxlTz0WuSLzxRpQ9g5uWXGUx9+LI3UBuCWJKtlmmOK/Icq3QVPsfXHw129Wewd
         Zr3nggmYkmqQpte3UzIEw7za+5oAGMbUyLhMAZNciH5IlqUTfDOETP8naLeKwqQLt8
         yD1MY0BOhGBlw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PACTH ethtool-next v3 2/7] json: improve array print API
Date:   Mon,  3 May 2021 09:08:25 -0700
Message-Id: <20210503160830.555241-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503160830.555241-1-kuba@kernel.org>
References: <20210503160830.555241-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ethtool when we print an array we usually have a label (non-JSON)
and a key (JSON), because arrays are most often printed entry-per-line
(unlike iproute2 where the output has multiple params on a line
to cater well to multi-interface dumps).

Use this knowledge in the json array API to make it simpler to use.

At the same time (similarly to open_json_object()) do not require
specifying output type. Users can pass an empty string if they
want nothing printed for non-JSON output.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 json_print.c | 20 ++++++++++----------
 json_print.h |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/json_print.c b/json_print.c
index 56d5b4337e49..4f62767bdbc9 100644
--- a/json_print.c
+++ b/json_print.c
@@ -73,15 +73,15 @@ void close_json_object(void)
 /*
  * Start json array or string array using
  * the provided string as json key (if not null)
- * or as array delimiter in non-json context.
+ * or array delimiter in non-json context.
  */
-void open_json_array(enum output_type type, const char *str)
+void open_json_array(const char *key, const char *str)
 {
-	if (_IS_JSON_CONTEXT(type)) {
-		if (str)
-			jsonw_name(_jw, str);
+	if (is_json_context()) {
+		if (key)
+			jsonw_name(_jw, key);
 		jsonw_start_array(_jw);
-	} else if (_IS_FP_CONTEXT(type)) {
+	} else {
 		printf("%s", str);
 	}
 }
@@ -89,12 +89,12 @@ void open_json_array(enum output_type type, const char *str)
 /*
  * End json array or string array
  */
-void close_json_array(enum output_type type, const char *str)
+void close_json_array(const char *delim)
 {
-	if (_IS_JSON_CONTEXT(type))
+	if (is_json_context())
 		jsonw_end_array(_jw);
-	else if (_IS_FP_CONTEXT(type))
-		printf("%s", str);
+	else
+		printf("%s", delim);
 }
 
 /*
diff --git a/json_print.h b/json_print.h
index cc0c2ea19b59..df15314bafe2 100644
--- a/json_print.h
+++ b/json_print.h
@@ -37,8 +37,8 @@ void fflush_fp(void);
 
 void open_json_object(const char *str);
 void close_json_object(void);
-void open_json_array(enum output_type type, const char *delim);
-void close_json_array(enum output_type type, const char *delim);
+void open_json_array(const char *key, const char *str);
+void close_json_array(const char *delim);
 
 void print_nl(void);
 
-- 
2.31.1

