Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153FC2FF5CC
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbhAUUZM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Jan 2021 15:25:12 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:44801 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727312AbhAUUXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 15:23:36 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-349FNIZ9NPWCxBresCrdnA-1; Thu, 21 Jan 2021 15:22:42 -0500
X-MC-Unique: 349FNIZ9NPWCxBresCrdnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EB64802B40;
        Thu, 21 Jan 2021 20:22:40 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2916A61F55;
        Thu, 21 Jan 2021 20:22:31 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     dwarves@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: [PATCH bpf-next 3/3] libbpf: Use string table index from index table if needed
Date:   Thu, 21 Jan 2021 21:22:03 +0100
Message-Id: <20210121202203.9346-4-jolsa@kernel.org>
In-Reply-To: <20210121202203.9346-1-jolsa@kernel.org>
References: <20210121202203.9346-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For very large ELF objects (with many sections), we could
get special value SHN_XINDEX (65535) for elf object's string
table index - e_shstrndx.

Call elf_getshdrstrndx to get the proper string table index,
instead of reading it directly from ELF header.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/btf.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 9970a288dda5..d9c10830d749 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -858,6 +858,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 	Elf_Scn *scn = NULL;
 	Elf *elf = NULL;
 	GElf_Ehdr ehdr;
+	size_t shstrndx;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
 		pr_warn("failed to init libelf for %s\n", path);
@@ -882,7 +883,14 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 		pr_warn("failed to get EHDR from %s\n", path);
 		goto done;
 	}
-	if (!elf_rawdata(elf_getscn(elf, ehdr.e_shstrndx), NULL)) {
+
+	if (elf_getshdrstrndx(elf, &shstrndx)) {
+		pr_warn("failed to get section names section index for %s\n",
+			path);
+		goto done;
+	}
+
+	if (!elf_rawdata(elf_getscn(elf, shstrndx), NULL)) {
 		pr_warn("failed to get e_shstrndx from %s\n", path);
 		goto done;
 	}
@@ -897,7 +905,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 				idx, path);
 			goto done;
 		}
-		name = elf_strptr(elf, ehdr.e_shstrndx, sh.sh_name);
+		name = elf_strptr(elf, shstrndx, sh.sh_name);
 		if (!name) {
 			pr_warn("failed to get section(%d) name from %s\n",
 				idx, path);
-- 
2.27.0

