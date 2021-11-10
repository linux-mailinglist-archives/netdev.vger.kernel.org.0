Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54CF44C047
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 12:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhKJLtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 06:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhKJLtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 06:49:24 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7887CC061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:37 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id v127so1874361wme.5
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K9FibD2+vxFCyU9lOfqbGOey2cIbsrO6jDFWOa35ijw=;
        b=c77sbtiNTfU6sYUC1ctTYHdiIxAZKv7yGifdUfhGLI4O/1ESqx+7wAvFyOdzrs221k
         qk1hcAHbg2T1v0boLzTzF3evRgLmfixAvNIMbkugp06gD6og5HRa3Yd8JC6K6PMYLbxB
         8znU5WHl1DM93w0Bz0BIVXHriep9gv/qOM/qki4P2WQeWbGPKbL8FTTxF/VEAxeSKjd6
         c7F/aksV5i7dsbZEX1RdxrzlKsAYT/zopYLwU8vYk9EmAyPAN0dAhJhj5aecV6l3Agxk
         Ukv+CD/M/ouhpvearutlioxFuebmDkreVSLfF7W7k0Fqmfq7LjZtcjGOTkbLb+1E83tt
         RUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K9FibD2+vxFCyU9lOfqbGOey2cIbsrO6jDFWOa35ijw=;
        b=60YsOXbOaHpnt0clQtjgLgj69VT0tNGzJDZZLJEcCfXszMJ1Y94wZVNWqNJqL8oY60
         WRM7v9A2MqUW2Y0BS0N6MM1fkpEEvayPJXxe29BaiKG8jb+CS7MyiPMuZPtN4Il9szVi
         b7iB9cOXTd26oq+bgqbcdvvx5nRVQHeTc3O1D7dKC3LEVtoWscOnRtj+UKeAsIxTtLLj
         uW2vuQvJSAVedKUdiCvFfpcuHx/+ey/CZES7OZs+LFSWKEulAlXaT9BhZuwjOPBXv+Ci
         8BD94AlokzKBIqmtjZ/cJZRKkSG9qE6wns4ou5M5c4TZbAD5PT3TOCxdkQ4R/UTEIN9R
         JtxQ==
X-Gm-Message-State: AOAM53279hNiVfo+YfZzQ1zgmTGHph7lMKZeXVS8cZNkk953Icu9HVGK
        l5wKsYlMAbEF9CBUq3iuTwHpBw==
X-Google-Smtp-Source: ABdhPJyygoY1jioNWfGmWgo4I2cdWNmrOxwSLOmOO59qV9FsIBCV5aRxkmFAh+zRtNCLiKDosuT8sQ==
X-Received: by 2002:a05:600c:1d01:: with SMTP id l1mr16066389wms.44.1636544796018;
        Wed, 10 Nov 2021 03:46:36 -0800 (PST)
Received: from localhost.localdomain ([149.86.79.190])
        by smtp.gmail.com with ESMTPSA id i15sm6241152wmq.18.2021.11.10.03.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:46:35 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/6] bpftool: Fix memory leak in prog_dump()
Date:   Wed, 10 Nov 2021 11:46:27 +0000
Message-Id: <20211110114632.24537-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211110114632.24537-1-quentin@isovalent.com>
References: <20211110114632.24537-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the extraction of prog_dump() from do_dump(), the struct btf
allocated in prog_dump() is no longer freed on error; the struct
bpf_prog_linfo is not freed at all. Make sure we release them before
exiting the function.

Fixes: ec2025095cf6 ("bpftool: Match several programs with same tag")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/prog.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index dea7a49ec26e..d5fcbb02cf91 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -709,8 +709,8 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 	char func_sig[1024];
 	unsigned char *buf;
 	__u32 member_len;
+	int fd, err = -1;
 	ssize_t n;
-	int fd;
 
 	if (mode == DUMP_JITED) {
 		if (info->jited_prog_len == 0 || !info->jited_prog_insns) {
@@ -749,7 +749,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		if (fd < 0) {
 			p_err("can't open file %s: %s", filepath,
 			      strerror(errno));
-			return -1;
+			goto exit_free;
 		}
 
 		n = write(fd, buf, member_len);
@@ -757,7 +757,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		if (n != (ssize_t)member_len) {
 			p_err("error writing output file: %s",
 			      n < 0 ? strerror(errno) : "short write");
-			return -1;
+			goto exit_free;
 		}
 
 		if (json_output)
@@ -771,7 +771,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 						     info->netns_ino,
 						     &disasm_opt);
 			if (!name)
-				return -1;
+				goto exit_free;
 		}
 
 		if (info->nr_jited_func_lens && info->jited_func_lens) {
@@ -866,9 +866,12 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		kernel_syms_destroy(&dd);
 	}
 
-	btf__free(btf);
+	err = 0;
 
-	return 0;
+exit_free:
+	btf__free(btf);
+	bpf_prog_linfo__free(prog_linfo);
+	return err;
 }
 
 static int do_dump(int argc, char **argv)
-- 
2.32.0

