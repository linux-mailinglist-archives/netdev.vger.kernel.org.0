Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7CEC180DDF
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 03:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgCKCMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 22:12:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33748 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbgCKCMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 22:12:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id r7so2087760wmg.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 19:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u3fV4GJZtcSb2sQMglSsUz56vJfyXq9KJXAU1tEwCic=;
        b=Zyai6AlecnZcpv78v2Dneo+BXmEfCkV7MhMbUZjlMoLY/NJfApbSamSSxrIlk/C2I4
         OJmTNApd7zSsjM/HK6E03TJS78j4o6f9HNwXFM9K5vgZD+uwEJmch+4XRu4TLLA98U3l
         //0ilB9ZteSjV4zrqaokylhIUI1SM5LcOkQ73SMyx9kwJq55DlUJCBslU65Iyq/IH6g8
         tYQrFMik3gryb7CERKD7xjnzs7xV7bEG+5+KJRlB/MzHk6d0mTRFzG0a3u8Z718C96F4
         j3usKN5aWudZcmjkpHt3ulQSR2Jf/6mx1O1L65r5RKXRZJyyNLmu6I1V/I6Pe7w/3V8U
         xQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u3fV4GJZtcSb2sQMglSsUz56vJfyXq9KJXAU1tEwCic=;
        b=bgCG1otCyfK9Vd20Wjs5GahSpFswWf1zOBfAbKdwg0j+F1AeOT9hW16gJ9hL6ucHnX
         YWNi8b4+5J+OMRUkQJCARI197zPHYfHFsRgkzxiQfVcE4LuV0KGFMl5Lu7hJ8SjW5g9j
         jGeOP43Gbx5pHAGbgjxW4m9rrFdt/h4Mo2DAhx3KYjuZTOKuQ5MfOgXvBymplaUHWhKH
         /wO0aXIkow0zDns6N1Tpbnmv1XBPU8vitXU/zH+2bogo1xs2qjxqNAMUGmH2AUJCOI3g
         Y6FHLuP3301HpDNMkivvMFxnWCqVS47GGRv147nGnzlbSyA6inypY+cU1jH8epY1tW/0
         M16w==
X-Gm-Message-State: ANhLgQ1oomYsy6pCmwzIapEcli6gacicXcIM3bjSNiHK/dZL2hd/VBOh
        ogoR0uuzkFgoGD64wxXJlry5hQ==
X-Google-Smtp-Source: ADFU+vu/OnD5YoOF/g98giyycp/IGgcQDSW2aISBYcRiNG6GNLNLakMxsUyl05P6Mg7F94QQ35Hrag==
X-Received: by 2002:a1c:a750:: with SMTP id q77mr722420wme.120.1583892757537;
        Tue, 10 Mar 2020 19:12:37 -0700 (PDT)
Received: from localhost.localdomain ([194.35.118.214])
        by smtp.gmail.com with ESMTPSA id x17sm6120635wmi.28.2020.03.10.19.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 19:12:37 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next] tools: bpftool: restore message on failure to guess program type
Date:   Wed, 11 Mar 2020 02:12:05 +0000
Message-Id: <20200311021205.9755-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 4a3d6c6a6e4d ("libbpf: Reduce log level for custom section
names"), log level for messages for libbpf_attach_type_by_name() and
libbpf_prog_type_by_name() was downgraded from "info" to "debug". The
latter function, in particular, is used by bpftool when attempting to
load programs, and this change caused bpftool to exit with no hint or
error message when it fails to detect the type of the program to load
(unless "-d" option was provided).

To help users understand why bpftool fails to load the program, let's do
a second run of the function with log level in "debug" mode in case of
failure.

Before:

    # bpftool prog load sample_ret0.o /sys/fs/bpf/sample_ret0
    # echo $?
    255

Or really verbose with -d flag:

    # bpftool -d prog load sample_ret0.o /sys/fs/bpf/sample_ret0
    libbpf: loading sample_ret0.o
    libbpf: section(1) .strtab, size 134, link 0, flags 0, type=3
    libbpf: skip section(1) .strtab
    libbpf: section(2) .text, size 16, link 0, flags 6, type=1
    libbpf: found program .text
    libbpf: section(3) .debug_abbrev, size 55, link 0, flags 0, type=1
    libbpf: skip section(3) .debug_abbrev
    libbpf: section(4) .debug_info, size 75, link 0, flags 0, type=1
    libbpf: skip section(4) .debug_info
    libbpf: section(5) .rel.debug_info, size 32, link 14, flags 0, type=9
    libbpf: skip relo .rel.debug_info(5) for section(4)
    libbpf: section(6) .debug_str, size 150, link 0, flags 30, type=1
    libbpf: skip section(6) .debug_str
    libbpf: section(7) .BTF, size 155, link 0, flags 0, type=1
    libbpf: section(8) .BTF.ext, size 80, link 0, flags 0, type=1
    libbpf: section(9) .rel.BTF.ext, size 32, link 14, flags 0, type=9
    libbpf: skip relo .rel.BTF.ext(9) for section(8)
    libbpf: section(10) .debug_frame, size 40, link 0, flags 0, type=1
    libbpf: skip section(10) .debug_frame
    libbpf: section(11) .rel.debug_frame, size 16, link 14, flags 0, type=9
    libbpf: skip relo .rel.debug_frame(11) for section(10)
    libbpf: section(12) .debug_line, size 74, link 0, flags 0, type=1
    libbpf: skip section(12) .debug_line
    libbpf: section(13) .rel.debug_line, size 16, link 14, flags 0, type=9
    libbpf: skip relo .rel.debug_line(13) for section(12)
    libbpf: section(14) .symtab, size 96, link 1, flags 0, type=2
    libbpf: looking for externs among 4 symbols...
    libbpf: collected 0 externs total
    libbpf: failed to guess program type from ELF section '.text'
    libbpf: supported section(type) names are: socket sk_reuseport kprobe/ [...]

After:

    # bpftool prog load sample_ret0.o /sys/fs/bpf/sample_ret0
    libbpf: failed to guess program type from ELF section '.text'
    libbpf: supported section(type) names are: socket sk_reuseport kprobe/ [...]

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/common.c |  7 +++++++
 tools/bpf/bpftool/main.c   |  7 -------
 tools/bpf/bpftool/main.h   |  5 +++++
 tools/bpf/bpftool/prog.c   | 27 +++++++++++++++++++++++----
 4 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index b75b8ec5469c..4512f7fb9adb 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -597,3 +597,10 @@ int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what)
 
 	return 0;
 }
+
+int __printf(2, 0)
+print_all_levels(__maybe_unused enum libbpf_print_level level,
+		 const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 6d41bbfc6459..06449e846e4b 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -79,13 +79,6 @@ static int do_version(int argc, char **argv)
 	return 0;
 }
 
-static int __printf(2, 0)
-print_all_levels(__maybe_unused enum libbpf_print_level level,
-		 const char *format, va_list args)
-{
-	return vfprintf(stderr, format, args);
-}
-
 int cmd_select(const struct cmd *cmds, int argc, char **argv,
 	       int (*help)(int argc, char **argv))
 {
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 724ef9d941d3..555e822203c5 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -14,6 +14,8 @@
 #include <linux/hashtable.h>
 #include <tools/libc_compat.h>
 
+#include <bpf/libbpf.h>
+
 #include "json_writer.h"
 
 #define ptr_to_u64(ptr)	((__u64)(unsigned long)(ptr))
@@ -229,4 +231,7 @@ struct tcmsg;
 int do_xdp_dump(struct ifinfomsg *ifinfo, struct nlattr **tb);
 int do_filter_dump(struct tcmsg *ifinfo, struct nlattr **tb, const char *kind,
 		   const char *devname, int ifindex);
+
+int print_all_levels(__maybe_unused enum libbpf_print_level level,
+		     const char *format, va_list args);
 #endif
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 576ddd82bc96..9faf4efd36d4 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1247,6 +1247,25 @@ static int do_run(int argc, char **argv)
 	return err;
 }
 
+static int
+get_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
+		      enum bpf_attach_type *expected_attach_type)
+{
+	libbpf_print_fn_t print_backup;
+	int ret;
+
+	ret = libbpf_prog_type_by_name(name, prog_type, expected_attach_type);
+	if (!ret)
+		return ret;
+
+	/* libbpf_prog_type_by_name() failed, let's re-run with debug level */
+	print_backup = libbpf_set_print(print_all_levels);
+	ret = libbpf_prog_type_by_name(name, prog_type, expected_attach_type);
+	libbpf_set_print(print_backup);
+
+	return ret;
+}
+
 static int load_with_options(int argc, char **argv, bool first_prog_only)
 {
 	enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
@@ -1296,8 +1315,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			strcat(type, *argv);
 			strcat(type, "/");
 
-			err = libbpf_prog_type_by_name(type, &common_prog_type,
-						       &expected_attach_type);
+			err = get_prog_type_by_name(type, &common_prog_type,
+						    &expected_attach_type);
 			free(type);
 			if (err < 0)
 				goto err_free_reuse_maps;
@@ -1396,8 +1415,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		if (prog_type == BPF_PROG_TYPE_UNSPEC) {
 			const char *sec_name = bpf_program__title(pos, false);
 
-			err = libbpf_prog_type_by_name(sec_name, &prog_type,
-						       &expected_attach_type);
+			err = get_prog_type_by_name(sec_name, &prog_type,
+						    &expected_attach_type);
 			if (err < 0)
 				goto err_close_obj;
 		}
-- 
2.25.1

