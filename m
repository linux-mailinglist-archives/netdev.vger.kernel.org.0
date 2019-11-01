Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F31EC0D5
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 10:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfKAJxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 05:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbfKAJxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 05:53:03 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C02E81105
        for <netdev@vger.kernel.org>; Fri,  1 Nov 2019 09:53:03 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id g28so1654030ljl.10
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 02:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9a3/goG98IKkbA6Zt7zLzrgcFHb9x1nP73Y0D8/2iQA=;
        b=Vdvry8A57CGcr5EygB+t0YYoQIA2ilFCIdNiyDTgI0usLdaEVEQAjQcRIlYTj1ooQZ
         7ERZgjq6HPvZFLdc+BAv2GgtVfCfunzL6rvhQvBz+TeMSwO7KRSYUuhIi1EzIjhOOgJS
         V0bZ1Zk+GjsKS/Cp4FFgRO72XFycAy4ESFsUulw1eob3Hy6T2dBnrIB9gBr7bRY0aal/
         dhWrR2SnGsRzLRu0WBoyRJ9QiMcY0SYUWzjsqWWWC3elzsZGd0OaA2nO3ncAyCT4jZ93
         NRFfUDxcLaMtRW71vsTBkdpzHiboQcFC7yMep4OF5utn4z3h5c1mIOjArDlpZOReEGUh
         7ifg==
X-Gm-Message-State: APjAAAU7pKCKZOL2C01jkaibCpZDL5F3NAptlRXL42S4pnSTDapZn4ws
        +HUYCe3xm0X6xetkaZ7t1x4BJd+h4drICtrCp7dXczVbLdgG97Kyh7+Anctmop7V9DZtMudDXo+
        cmp2JxQHc4pAbj/EM
X-Received: by 2002:ac2:420a:: with SMTP id y10mr6571670lfh.65.1572601981586;
        Fri, 01 Nov 2019 02:53:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz/LEN241ScHBfT7jH5hm0N5wrZLdiBiIY4iXbovbPcXwbNZVr5COMruFonmjbhnIO65UGz/w==
X-Received: by 2002:ac2:420a:: with SMTP id y10mr6571658lfh.65.1572601981380;
        Fri, 01 Nov 2019 02:53:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id g7sm2387377lfb.4.2019.11.01.02.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 02:53:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0270F1818B6; Fri,  1 Nov 2019 10:52:59 +0100 (CET)
Subject: [PATCH bpf-next v5 3/5] libbpf: Move directory creation into _pin()
 functions
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 01 Nov 2019 10:52:59 +0100
Message-ID: <157260197987.335202.3234179306306983855.stgit@toke.dk>
In-Reply-To: <157260197645.335202.2393286837980792460.stgit@toke.dk>
References: <157260197645.335202.2393286837980792460.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The existing pin_*() functions all try to create the parent directory
before pinning. Move this check into the per-object _pin() functions
instead. This ensures consistent behaviour when auto-pinning is
added (which doesn't go through the top-level pin_maps() function), at the
cost of a few more calls to mkdir().

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c |   61 +++++++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index af40905a9280..0f1ebecad4d4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3805,6 +3805,28 @@ int bpf_object__load(struct bpf_object *obj)
 	return bpf_object__load_xattr(&attr);
 }
 
+static int make_parent_dir(const char *path)
+{
+	char *cp, errmsg[STRERR_BUFSIZE];
+	char *dname, *dir;
+	int err = 0;
+
+	dname = strdup(path);
+	if (dname == NULL)
+		return -ENOMEM;
+
+	dir = dirname(dname);
+	if (mkdir(dir, 0700) && errno != EEXIST)
+		err = -errno;
+
+	free(dname);
+	if (err) {
+		cp = libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
+		pr_warn("failed to mkdir %s: %s\n", path, cp);
+	}
+	return err;
+}
+
 static int check_path(const char *path)
 {
 	char *cp, errmsg[STRERR_BUFSIZE];
@@ -3841,6 +3863,10 @@ int bpf_program__pin_instance(struct bpf_program *prog, const char *path,
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err;
 
+	err = make_parent_dir(path);
+	if (err)
+		return err;
+
 	err = check_path(path);
 	if (err)
 		return err;
@@ -3894,25 +3920,14 @@ int bpf_program__unpin_instance(struct bpf_program *prog, const char *path,
 	return 0;
 }
 
-static int make_dir(const char *path)
-{
-	char *cp, errmsg[STRERR_BUFSIZE];
-	int err = 0;
-
-	if (mkdir(path, 0700) && errno != EEXIST)
-		err = -errno;
-
-	if (err) {
-		cp = libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
-		pr_warn("failed to mkdir %s: %s\n", path, cp);
-	}
-	return err;
-}
-
 int bpf_program__pin(struct bpf_program *prog, const char *path)
 {
 	int i, err;
 
+	err = make_parent_dir(path);
+	if (err)
+		return err;
+
 	err = check_path(path);
 	if (err)
 		return err;
@@ -3933,10 +3948,6 @@ int bpf_program__pin(struct bpf_program *prog, const char *path)
 		return bpf_program__pin_instance(prog, path, 0);
 	}
 
-	err = make_dir(path);
-	if (err)
-		return err;
-
 	for (i = 0; i < prog->instances.nr; i++) {
 		char buf[PATH_MAX];
 		int len;
@@ -4059,6 +4070,10 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
 		}
 	}
 
+	err = make_parent_dir(map->pin_path);
+	if (err)
+		return err;
+
 	err = check_path(map->pin_path);
 	if (err)
 		return err;
@@ -4153,10 +4168,6 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 		return -ENOENT;
 	}
 
-	err = make_dir(path);
-	if (err)
-		return err;
-
 	bpf_object__for_each_map(map, obj) {
 		char *pin_path = NULL;
 		char buf[PATH_MAX];
@@ -4243,10 +4254,6 @@ int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
 		return -ENOENT;
 	}
 
-	err = make_dir(path);
-	if (err)
-		return err;
-
 	bpf_object__for_each_program(prog, obj) {
 		char buf[PATH_MAX];
 		int len;

