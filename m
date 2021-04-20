Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDDD364F81
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 02:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhDTAbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 20:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhDTAbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 20:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 625EF613AE;
        Tue, 20 Apr 2021 00:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618878676;
        bh=vEgjPMtOy94tyc/fzcF7/13s6+VdePTIJsmZnBRhse4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQynq+JIFumQesqnPWI5UabKGHcVTuL0zq9kEUeEdoNr+r6GP+6h/cvvh9KJ2RDI+
         hYa6VHjGkCEGqXILyKQXdhLHJQdyuHDMeA+Nlto1EGKJkWb4WVePw/hFTddI7MmS7I
         lw2c4T0BE+1b4Ib974Cy5VtJ5G1TV6je7tIFrTr3y/5fIUby+sNmRM9jBJbEOT2w2h
         qXROBC4ACmbDRXiImq7QS+qXI1yVGQ6qCCw2JQqI7wBsXXDgM0YGy0zAm1gAslY7tt
         GizkpHk8W/mGhmJUCeGzdllp1OYruol+XGxeTzD85YqBcu0RxhWoGcjQXV+xQs2Us7
         ISNAycventdLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next 2/7] json: improve array print API
Date:   Mon, 19 Apr 2021 17:31:07 -0700
Message-Id: <20210420003112.3175038-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420003112.3175038-1-kuba@kernel.org>
References: <20210420003112.3175038-1-kuba@kernel.org>
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
2.30.2

