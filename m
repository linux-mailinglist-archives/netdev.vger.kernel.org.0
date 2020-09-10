Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B87226440E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgIJK2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730991AbgIJK1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 06:27:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C2EC0613ED
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 03:27:04 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so6103084wrx.7
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 03:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w1o8W2B7Zhme6wXQ+MUTOwcBEeetzzjkb46yP9OL+9Y=;
        b=KdYK2Oxt1h4+ACT1cPmZWuxvLWU1dPULmiAsH9Hh5La9CTcyvPkRvXPxEPuWV5kJR7
         J3q0XCVJ8hif7mQVTkOJAp1FljvgPABeo4F9yEPbYM0qsouXFMq+PiQfIEjMp0rWH4RI
         UDMqrJ2rSWmmTN51JifcBCWuckUxSiUgZMKvxxLer/71bwEc7BED+t1Z+QMilzDKu2sA
         P8546KHXFXNjn0U+KW147iU/WCA0K7NZ/HS2ERtTsSL4KuGGE9yADXAP/raQImSOCN5E
         VUq4dgapJ7v2RzC2TBO6/egAhmK6zuGJCgHfd4rAmzYm8SH1xFoTnGdUwcrObRGETOgT
         zEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w1o8W2B7Zhme6wXQ+MUTOwcBEeetzzjkb46yP9OL+9Y=;
        b=MiNTehjLXh1AYfagwKSLnVFJ86FkofrR1aUptNlR5bH/JiKqUylo7Dm+t3s7FJGMBG
         UKU17Ayp+2ZQAb3NyDbTYaLPCZpuMYFLfTctlbySkXmLkGeWiowDKFQFB76StTUWYKQX
         qv79FuGDEkjQeFY5DiChsMIjNDuv3v8wa0PjnvxpZkbJS/E5o1wDzghyIlj2bC3M8fc3
         pPPf9BEFB/SBuvS78DPzg3ZxV4e6ZDBlveHKmZMFkmDaP7zv8dNO2OUiMxLwP+y3fAv1
         iiaRsNnXoR28UKB8fIYXHVoLicrzW9h8AFiyIJplnRRxFIYH7jo74NWeTIcWLyZR12O7
         BJ3Q==
X-Gm-Message-State: AOAM533E7Zt0lQEZQitH8JqoUNK+d+RC9Aco7L6rn1HKzglimDHuViIg
        F+T6dyVn4WU6fK1Ofd96nKA0Hg==
X-Google-Smtp-Source: ABdhPJy9BQ2zrfLV4lMTWPOxPrm440OzkJ0MK03+7D2nC92I9zy97CLW2R0drFrxQ79yYiO/nRlpwQ==
X-Received: by 2002:a5d:69c9:: with SMTP id s9mr8173797wrw.348.1599733623420;
        Thu, 10 Sep 2020 03:27:03 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.178])
        by smtp.gmail.com with ESMTPSA id h186sm3039494wmf.24.2020.09.10.03.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 03:27:03 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 1/3] tools: bpftool: clean up function to dump map entry
Date:   Thu, 10 Sep 2020 11:26:50 +0100
Message-Id: <20200910102652.10509-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200910102652.10509-1-quentin@isovalent.com>
References: <20200910102652.10509-1-quentin@isovalent.com>
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

