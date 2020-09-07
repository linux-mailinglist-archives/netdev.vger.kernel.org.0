Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F29260004
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgIGQmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730909AbgIGQgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:36:43 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1631DC061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:36:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id m6so16452585wrn.0
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w1o8W2B7Zhme6wXQ+MUTOwcBEeetzzjkb46yP9OL+9Y=;
        b=Fk8rzZu74dzkud4w0RH5Tq8dgt5syuBgJ0kA77yLP2SixiisbRuNRjUk45JBTd5v5G
         CLGr5Q4XC4pMMXQIAyhiaGdT/eWrEKRI2GTYCF9ACIklsxlw9fPHZgPhtKyvLQxmAPDt
         V1q5IKg8HvrMrX57Rns5CPXbWavAPn6a69nAmOmKZgnY5IW/s+56XQz/HDEwlb2RgQC2
         4Byth4ZekzJneVL+6I1KZUPoBHZTtrIPt7+MzYX6GNcqGT/bn0DqHwCIbYi0aSkgC5xk
         bBKG7OpFwxUhkAO8th0nH+ZWoJh1I8PAlxykD3+6jKRSWfFzNA1fAPxFrXTEOqb5Rx7t
         GrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w1o8W2B7Zhme6wXQ+MUTOwcBEeetzzjkb46yP9OL+9Y=;
        b=Xk2aNWp15gfHjgzyROftP4ooienOHPw7fnzUW8n6M8wzOUjLbRTRbIDKv97GDO4iEc
         9P6R0Od0nM+DeBwDaptmoenZLqwToEnkSbQEwgll+1LCqlsYGaLQiTIsbdW1AyQy8328
         0IYt+hmpDz+0RFk+vdGIsE3AGLva1S1ClsZokDLa7F418wUbCh77vv/EO8Bk0LfxJtYS
         ihy0nZBG82Eu5sZfFfgAbh+RigpV2k/wZpbofULpmYiAwBuZCr1QUWEIPMQ1hn8rMmjv
         ts3Bcfv1+nU5n+Oaz5zWnKjsqY5gtXvTqaB1O0hMBtLXCCePq5/PG/C358YBBx0NjthS
         KkoA==
X-Gm-Message-State: AOAM530JPMV6YlQq4CwXMX+nbLUd/9APfO58bjGvRkVPJsFiQ0kXcgtC
        STzfIihIdQYCpunOrsVaxFlTUA==
X-Google-Smtp-Source: ABdhPJx/YhoGx9+d1gk+CLtrXEOer35LvJlBjS9IhQXG+fqw3H36DLFpDYSzCbtWr8BrBfgOJTg3nA==
X-Received: by 2002:a5d:668b:: with SMTP id l11mr18448771wru.89.1599496601559;
        Mon, 07 Sep 2020 09:36:41 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.17])
        by smtp.gmail.com with ESMTPSA id p11sm26443677wma.11.2020.09.07.09.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:36:40 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 1/2] tools: bpftool: clean up function to dump map entry
Date:   Mon,  7 Sep 2020 17:36:33 +0100
Message-Id: <20200907163634.27469-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200907163634.27469-1-quentin@isovalent.com>
References: <20200907163634.27469-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function used to dump a map entry in bpftool is a bit difficult to
follow, as a consequence to earlier refactorings. There is a variable
("num_elems") which does not appear to be necessary, and the error
handling would look cleaner if moved to its own function. Let's clean it
up. No functional change.

v2:
- v1 was erroneously removing the check on fd maps in an attempt to get
  support for outer map dumps. This is already working. Instead, v2
  focuses on cleaning up the dump_map_elem() function, to avoid
  similar confusion in the future.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/map.c | 101 +++++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 49 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index bc0071228f88..c8159cb4fb1e 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -213,8 +213,9 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
 	jsonw_end_object(json_wtr);
 }
 
-static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
-			      const char *error_msg)
+static void
+print_entry_error_msg(struct bpf_map_info *info, unsigned char *key,
+		      const char *error_msg)
 {
 	int msg_size = strlen(error_msg);
 	bool single_line, break_names;
@@ -232,6 +233,40 @@ static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
 	printf("\n");
 }
 
+static void
+print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
+{
+	/* For prog_array maps or arrays of maps, failure to lookup the value
+	 * means there is no entry for that key. Do not print an error message
+	 * in that case.
+	 */
+	if (map_is_map_of_maps(map_info->type) ||
+	    map_is_map_of_progs(map_info->type))
+		return;
+
+	if (json_output) {
+		jsonw_start_object(json_wtr);	/* entry */
+		jsonw_name(json_wtr, "key");
+		print_hex_data_json(key, map_info->key_size);
+		jsonw_name(json_wtr, "value");
+		jsonw_start_object(json_wtr);	/* error */
+		jsonw_string_field(json_wtr, "error", strerror(lookup_errno));
+		jsonw_end_object(json_wtr);	/* error */
+		jsonw_end_object(json_wtr);	/* entry */
+	} else {
+		const char *msg = NULL;
+
+		if (lookup_errno == ENOENT)
+			msg = "<no entry>";
+		else if (lookup_errno == ENOSPC &&
+			 map_info->type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
+			msg = "<cannot read>";
+
+		print_entry_error_msg(map_info, key,
+				      msg ? : strerror(lookup_errno));
+	}
+}
+
 static void print_entry_plain(struct bpf_map_info *info, unsigned char *key,
 			      unsigned char *value)
 {
@@ -713,56 +748,23 @@ static int dump_map_elem(int fd, void *key, void *value,
 			 struct bpf_map_info *map_info, struct btf *btf,
 			 json_writer_t *btf_wtr)
 {
-	int num_elems = 0;
-	int lookup_errno;
-
-	if (!bpf_map_lookup_elem(fd, key, value)) {
-		if (json_output) {
-			print_entry_json(map_info, key, value, btf);
-		} else {
-			if (btf) {
-				struct btf_dumper d = {
-					.btf = btf,
-					.jw = btf_wtr,
-					.is_plain_text = true,
-				};
-
-				do_dump_btf(&d, map_info, key, value);
-			} else {
-				print_entry_plain(map_info, key, value);
-			}
-			num_elems++;
-		}
-		return num_elems;
+	if (bpf_map_lookup_elem(fd, key, value)) {
+		print_entry_error(map_info, key, errno);
+		return -1;
 	}
 
-	/* lookup error handling */
-	lookup_errno = errno;
-
-	if (map_is_map_of_maps(map_info->type) ||
-	    map_is_map_of_progs(map_info->type))
-		return 0;
-
 	if (json_output) {
-		jsonw_start_object(json_wtr);
-		jsonw_name(json_wtr, "key");
-		print_hex_data_json(key, map_info->key_size);
-		jsonw_name(json_wtr, "value");
-		jsonw_start_object(json_wtr);
-		jsonw_string_field(json_wtr, "error", strerror(lookup_errno));
-		jsonw_end_object(json_wtr);
-		jsonw_end_object(json_wtr);
-	} else {
-		const char *msg = NULL;
-
-		if (lookup_errno == ENOENT)
-			msg = "<no entry>";
-		else if (lookup_errno == ENOSPC &&
-			 map_info->type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
-			msg = "<cannot read>";
+		print_entry_json(map_info, key, value, btf);
+	} else if (btf) {
+		struct btf_dumper d = {
+			.btf = btf,
+			.jw = btf_wtr,
+			.is_plain_text = true,
+		};
 
-		print_entry_error(map_info, key,
-				  msg ? : strerror(lookup_errno));
+		do_dump_btf(&d, map_info, key, value);
+	} else {
+		print_entry_plain(map_info, key, value);
 	}
 
 	return 0;
@@ -873,7 +875,8 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 				err = 0;
 			break;
 		}
-		num_elems += dump_map_elem(fd, key, value, info, btf, wtr);
+		if (!dump_map_elem(fd, key, value, info, btf, wtr))
+			num_elems++;
 		prev_key = key;
 	}
 
-- 
2.25.1

