Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113B71C353B
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 11:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgEDJFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 05:05:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39015 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725928AbgEDJFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 05:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588583130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BUMYAgYVEbMnE9HCazZFtfj40ubk94x+JHLvAPGLttU=;
        b=fTTTdyCHvmUJoOTSuwIlYx4R0FlMDzWb2Yww+ORFsTqQ6K6wMB1Vcx22gXuQhY4ZwKqbiZ
        p7fyub/UB+UTNl3O2UwvaJR0+Lsv0pqV+SE5eVxzPKn0jq2A7aIB7E43vWUrMoqvhCvPoO
        qa3x/U3sSL6FSMVbmbR0nAyM0F6ovnI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-AJYe1ogYNwyt4figYBKPVw-1; Mon, 04 May 2020 05:05:26 -0400
X-MC-Unique: AJYe1ogYNwyt4figYBKPVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 950697BAC;
        Mon,  4 May 2020 09:05:24 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-115-25.ams2.redhat.com [10.36.115.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E74F55D9D5;
        Mon,  4 May 2020 09:05:19 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v2] libbpf: fix probe code to return EPERM if encountered
Date:   Mon,  4 May 2020 11:05:14 +0200
Message-Id: <158858309381.5053.12391080967642755711.stgit@ebuild>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
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
v2: Split bpf_object__probe_name() in two functions as suggested by Andri=
i

 tools/lib/bpf/libbpf.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..6838e6d431ce 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3149,7 +3149,7 @@ int bpf_map__resize(struct bpf_map *map, __u32 max_=
entries)
 }
=20
 static int
-bpf_object__probe_name(struct bpf_object *obj)
+bpf_object__probe_loading(struct bpf_object *obj)
 {
 	struct bpf_load_program_attr attr;
 	char *cp, errmsg[STRERR_BUFSIZE];
@@ -3176,8 +3176,26 @@ bpf_object__probe_name(struct bpf_object *obj)
 	}
 	close(ret);
=20
-	/* now try the same program, but with the name */
+	return 0;
+}
=20
+static int
+bpf_object__probe_name(struct bpf_object *obj)
+{
+	struct bpf_load_program_attr attr;
+	struct bpf_insn insns[] =3D {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	int ret;
+
+	/* make sure loading with name works */
+
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_type =3D BPF_PROG_TYPE_SOCKET_FILTER;
+	attr.insns =3D insns;
+	attr.insns_cnt =3D ARRAY_SIZE(insns);
+	attr.license =3D "GPL";
 	attr.name =3D "test";
 	ret =3D bpf_load_program_xattr(&attr, NULL, 0);
 	if (ret >=3D 0) {
@@ -5386,7 +5404,8 @@ int bpf_object__load_xattr(struct bpf_object_load_a=
ttr *attr)
=20
 	obj->loaded =3D true;
=20
-	err =3D bpf_object__probe_caps(obj);
+	err =3D bpf_object__probe_loading(obj);
+	err =3D err ? : bpf_object__probe_caps(obj);
 	err =3D err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err =3D err ? : bpf_object__sanitize_and_load_btf(obj);
 	err =3D err ? : bpf_object__sanitize_maps(obj);

