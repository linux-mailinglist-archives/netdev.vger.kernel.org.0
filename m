Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78D41CDA37
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgEKMkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:40:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23836 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728084AbgEKMkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589200834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hfjikQ9p1CZNbHLDaNQ5BqLvccZnhPT1ZB3ciPyyTvU=;
        b=MA4pkNDfrv86SI79F3A/pbR4kAfAu/lQphd0LlthEdy2tfd5wXvea/tFBQtwgCuNt6kyp0
        jeGy9K4Ias0XdEWi6ju3KeJDop3QPgKKvGfgOgbXdvYN5xMW8fvIvn6S6W23oBimky/ZVi
        BafiA0zehcsJJlZFRXdsZxHUx0vWz6w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-Tjp6mZU4NUO83RNPbf5WdQ-1; Mon, 11 May 2020 08:40:30 -0400
X-MC-Unique: Tjp6mZU4NUO83RNPbf5WdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2065107ACCD;
        Mon, 11 May 2020 12:40:28 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-115-161.ams2.redhat.com [10.36.115.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECA8D610FD;
        Mon, 11 May 2020 12:40:23 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v3] libbpf: fix probe code to return EPERM if encountered
Date:   Mon, 11 May 2020 14:40:18 +0200
Message-Id: <158920079637.7533.5703299045869368435.stgit@ebuild>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the probe code was failing for any reason ENOTSUP was returned, even
if this was due to no having enough lock space. This patch fixes this by
returning EPERM to the user application, so it can respond and increase
the RLIMIT_MEMLOCK size.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
v3: Updated error message to be more specific as suggested by Andrii
v2: Split bpf_object__probe_name() in two functions as suggested by Andrii

 tools/lib/bpf/libbpf.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..ad3043c5db13 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3149,7 +3149,7 @@ int bpf_map__resize(struct bpf_map *map, __u32 max_entries)
 }
 
 static int
-bpf_object__probe_name(struct bpf_object *obj)
+bpf_object__probe_loading(struct bpf_object *obj)
 {
 	struct bpf_load_program_attr attr;
 	char *cp, errmsg[STRERR_BUFSIZE];
@@ -3170,14 +3170,34 @@ bpf_object__probe_name(struct bpf_object *obj)
 	ret = bpf_load_program_xattr(&attr, NULL, 0);
 	if (ret < 0) {
 		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
-		pr_warn("Error in %s():%s(%d). Couldn't load basic 'r0 = 0' BPF program.\n",
-			__func__, cp, errno);
+		pr_warn("Error in %s():%s(%d). Couldn't load trivial BPF "
+			"program. Make sure your kernel supports BPF "
+			"(CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is "
+			"set to big enough value.\n", __func__, cp, errno);
 		return -errno;
 	}
 	close(ret);
 
-	/* now try the same program, but with the name */
+	return 0;
+}
+
+static int
+bpf_object__probe_name(struct bpf_object *obj)
+{
+	struct bpf_load_program_attr attr;
+	struct bpf_insn insns[] = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	int ret;
+
+	/* make sure loading with name works */
 
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
+	attr.insns = insns;
+	attr.insns_cnt = ARRAY_SIZE(insns);
+	attr.license = "GPL";
 	attr.name = "test";
 	ret = bpf_load_program_xattr(&attr, NULL, 0);
 	if (ret >= 0) {
@@ -5386,7 +5406,8 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 
 	obj->loaded = true;
 
-	err = bpf_object__probe_caps(obj);
+	err = bpf_object__probe_loading(obj);
+	err = err ? : bpf_object__probe_caps(obj);
 	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);

