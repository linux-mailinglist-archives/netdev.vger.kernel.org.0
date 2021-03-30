Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C4E34DFD7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhC3ECL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231145AbhC3EB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F087E6196C;
        Tue, 30 Mar 2021 04:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617076917;
        bh=n4sEnSDmhYKsaExK7os5FLh2G6mjLQTpU3+v8OcDH4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luZbY140k9rPB9hgobmXyzOaDrR/L1AVWyB2bNvQHzNwHPQMaMOLXMcSeEN/xEN/+
         PdS0uS4nz3FnxXhOkEqu7iHagS2SHgYo4AciEB8Ll0DRB+QEO5XHIbIOttfXIdKB/p
         Z38UxnAmefVXdcyDgCeM/kIFc65IXku/SNuS2JhSVcTCfi8p9KklGoZ0JuLueu1eRE
         jQpahMDnOSjNWSsKXyZPY6iyeTSvpFiSBFOcwL62EIyZPIpOQDeuKzEzKsLVsHkAW8
         Vsgdj90/YtCbX8Gbaqik9zV1mpbnzwsO/sMDF6I/4RSRKTKqkX1JBtaGQRaUA5sXWd
         PNxBWv7O5h2Zw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC ethtool-next 2/3] json: simplify array print API
Date:   Mon, 29 Mar 2021 21:01:53 -0700
Message-Id: <20210330040154.1218028-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330040154.1218028-1-kuba@kernel.org>
References: <20210330040154.1218028-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ethtool when we print an array we usually have a label (non-JSON)
and a key (JSON), because arrays are most often printed on a single
line (unlike iproute2 where the output has multiple params
on a line to cater to multi-interface dumps well).

Build this into the json array API.

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

