Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3102E1CF0F7
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 11:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgELJFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 05:05:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728085AbgELJFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 05:05:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589274299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3Sso1iUkgQX6w4z+ijcZNlkTUoEucQ4uWlkPM6EYSYo=;
        b=Yc8Rtj73qwoLQ23BGnXN5TY2SYB9PmCVt/MVdWctj4UZFkXOvoxnhGLs9Wh3YgWZT6kTTk
        rk1MiamKl0fRHZDsE80rrUeZbp5TpQ6LzULWQ9hjUgp0CNzFXbkKgvDRStK40SeLpIWx+f
        mVPSGSH5Q5rRjgBucWOiM4YShm9Kdyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-KpnCG7NTPPy9YVwZP670Nw-1; Tue, 12 May 2020 05:04:55 -0400
X-MC-Unique: KpnCG7NTPPy9YVwZP670Nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 985F8800687;
        Tue, 12 May 2020 09:04:53 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-115-103.ams2.redhat.com [10.36.115.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCC546A949;
        Tue, 12 May 2020 09:04:48 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v4] libbpf: fix probe code to return EPERM if encountered
Date:   Tue, 12 May 2020 11:04:40 +0200
Message-Id: <158927424896.2342.10402475603585742943.stgit@ebuild>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
v4: Preserve errno on return
v3: Updated error message to be more specific as suggested by Andrii
v2: Split bpf_object__probe_name() in two functions as suggested by Andrii

 tools/lib/bpf/libbpf.c |   36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..a83dad3e0e90 100644
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
@@ -3169,15 +3169,36 @@ bpf_object__probe_name(struct bpf_object *obj)
 
 	ret = bpf_load_program_xattr(&attr, NULL, 0);
 	if (ret < 0) {
-		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
-		pr_warn("Error in %s():%s(%d). Couldn't load basic 'r0 = 0' BPF program.\n",
-			__func__, cp, errno);
-		return -errno;
+		ret = errno;
+		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
+		pr_warn("Error in %s():%s(%d). Couldn't load trivial BPF "
+			"program. Make sure your kernel supports BPF "
+			"(CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is "
+			"set to big enough value.\n", __func__, cp, ret);
+		return -ret;
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
@@ -5386,7 +5407,8 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 
 	obj->loaded = true;
 
-	err = bpf_object__probe_caps(obj);
+	err = bpf_object__probe_loading(obj);
+	err = err ? : bpf_object__probe_caps(obj);
 	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);

