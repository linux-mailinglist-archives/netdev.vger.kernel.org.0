Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E742924993C
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgHSJYE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Aug 2020 05:24:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54473 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726110AbgHSJYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:24:02 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-ej-EtbYGMuqQDUEaYLjZBw-1; Wed, 19 Aug 2020 05:23:57 -0400
X-MC-Unique: ej-EtbYGMuqQDUEaYLjZBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DB961005E63;
        Wed, 19 Aug 2020 09:23:55 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EB52100238C;
        Wed, 19 Aug 2020 09:23:43 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Mark Wielaard <mjw@redhat.com>, Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong alignment
Date:   Wed, 19 Aug 2020 11:23:42 +0200
Message-Id: <20200819092342.259004-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data of compressed section should be aligned to 4
(for 32bit) or 8 (for 64 bit) bytes.

The binutils ld sets sh_addralign to 1, which makes libelf
fail with misaligned section error during the update as
reported by Jesper:

   FAILED elf_update(WRITE): invalid section alignment

While waiting for ld fix, we can fix compressed sections
sh_addralign value manually.

Adding warning in -vv mode when the fix is triggered:

  $ ./tools/bpf/resolve_btfids/resolve_btfids -vv vmlinux
  ...
  section(36) .comment, size 44, link 0, flags 30, type=1
  section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
   - fixing wrong alignment sh_addralign 16, expected 8
  section(38) .debug_info, size 129104957, link 0, flags 800, type=1
   - fixing wrong alignment sh_addralign 1, expected 8
  section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
   - fixing wrong alignment sh_addralign 1, expected 8
  section(40) .debug_line, size 7374522, link 0, flags 800, type=1
   - fixing wrong alignment sh_addralign 1, expected 8
  section(41) .debug_frame, size 702463, link 0, flags 800, type=1
  section(42) .debug_str, size 1017571, link 0, flags 830, type=1
   - fixing wrong alignment sh_addralign 1, expected 8
  section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
   - fixing wrong alignment sh_addralign 1, expected 8
  section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
   - fixing wrong alignment sh_addralign 16, expected 8
  section(45) .symtab, size 2955888, link 46, flags 0, type=2
  section(46) .strtab, size 2613072, link 0, flags 0, type=3
  ...
  update ok for vmlinux

Another workaround is to disable compressed debug info data
CONFIG_DEBUG_INFO_COMPRESSED kernel option.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Cc: Mark Wielaard <mjw@redhat.com>
Cc: Nick Clifton <nickc@redhat.com>
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 36 +++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 4d9ecb975862..0def0bb1f783 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -233,6 +233,39 @@ static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
 	return btf_id__add(root, id, false);
 }
 
+/*
+ * The data of compressed section should be aligned to 4
+ * (for 32bit) or 8 (for 64 bit) bytes. The binutils ld
+ * sets sh_addralign to 1, which makes libelf fail with
+ * misaligned section error during the update:
+ *    FAILED elf_update(WRITE): invalid section alignment
+ *
+ * While waiting for ld fix, we fix the compressed sections
+ * sh_addralign value manualy.
+ */
+static int compressed_section_fix(Elf *elf, Elf_Scn *scn, GElf_Shdr *sh)
+{
+	int expected = gelf_getclass(elf) == ELFCLASS32 ? 4 : 8;
+
+	if (!(sh->sh_flags & SHF_COMPRESSED))
+		return 0;
+
+	if (sh->sh_addralign == expected)
+		return 0;
+
+	pr_debug2(" - fixing wrong alignment sh_addralign %u, expected %u\n",
+		  sh->sh_addralign, expected);
+
+	sh->sh_addralign = expected;
+
+	if (gelf_update_shdr(scn, sh) == 0) {
+		printf("FAILED cannot update section header: %s\n",
+			elf_errmsg(-1));
+		return -1;
+	}
+	return 0;
+}
+
 static int elf_collect(struct object *obj)
 {
 	Elf_Scn *scn = NULL;
@@ -309,6 +342,9 @@ static int elf_collect(struct object *obj)
 			obj->efile.idlist_shndx = idx;
 			obj->efile.idlist_addr  = sh.sh_addr;
 		}
+
+		if (compressed_section_fix(elf, scn, &sh))
+			return -1;
 	}
 
 	return 0;
-- 
2.25.4

