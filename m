Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD4D1C71BE
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgEFNaa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 09:30:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24262 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728667AbgEFNa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 09:30:29 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-zS2TPW_yOWuLS5FmjYNxNw-1; Wed, 06 May 2020 09:30:24 -0400
X-MC-Unique: zS2TPW_yOWuLS5FmjYNxNw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1A5FEC1A4;
        Wed,  6 May 2020 13:30:21 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 392B164430;
        Wed,  6 May 2020 13:30:18 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 7/9] bpf: Compile the BTF id whitelist data in vmlinux
Date:   Wed,  6 May 2020 15:29:44 +0200
Message-Id: <20200506132946.2164578-8-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-1-jolsa@kernel.org>
References: <20200506132946.2164578-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Squeezing in the BTF id whitelist data into vmlinux object
with BTF section compiled in, with following steps:

  - generate whitelist data with bpfwl
    $ bpfwl .tmp_vmlinux.btf kernel/bpf/helpers-whitelist > ${whitelist}.c

  - compile whitelist.c
    $ gcc -c -o ${whitelist}.o ${whitelist}.c

  - keep only the whitelist data in ${whitelist}.o using objcopy

  - link .tmp_vmlinux.btf and ${whitelist}.o into $btf_vmlinux_bin_o}
    $ ld -r -o ${btf_vmlinux_bin_o} .tmp_vmlinux.btf ${whitelist}.o

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Makefile                |  3 ++-
 scripts/link-vmlinux.sh | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index b0537af523dc..3bb995245592 100644
--- a/Makefile
+++ b/Makefile
@@ -437,6 +437,7 @@ OBJSIZE		= $(CROSS_COMPILE)size
 STRIP		= $(CROSS_COMPILE)strip
 endif
 PAHOLE		= pahole
+BPFWL		= $(srctree)/tools/bpf/bpfwl/bpfwl
 LEX		= flex
 YACC		= bison
 AWK		= awk
@@ -493,7 +494,7 @@ GCC_PLUGINS_CFLAGS :=
 CLANG_FLAGS :=
 
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE LEX YACC AWK INSTALLKERNEL
+export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE BPFWL LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
 export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index d09ab4afbda4..dee91c6bf450 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -130,16 +130,26 @@ gen_btf()
 	info "BTF" ${2}
 	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
 
-	# Create ${2} which contains just .BTF section but no symbols. Add
+	# Create object which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
 	# deletes all symbols including __start_BTF and __stop_BTF, which will
 	# be redefined in the linker script. Add 2>/dev/null to suppress GNU
 	# objcopy warnings: "empty loadable segment detected at ..."
 	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
-		--strip-all ${1} ${2} 2>/dev/null
-	# Change e_type to ET_REL so that it can be used to link final vmlinux.
-	# Unlike GNU ld, lld does not allow an ET_EXEC input.
-	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
+		--strip-all ${1} 2>/dev/null
+
+	# Create object that contains just .BTF_whitelist_* sections generated
+	# by bpfwl. Same as BTF section, BTF_whitelist_* data will be part of
+	# the vmlinux image, hence SHF_ALLOC.
+	whitelist=.btf.vmlinux.whitelist
+
+	${BPFWL} ${1} kernel/bpf/helpers-whitelist > ${whitelist}.c
+	${CC} -c -o ${whitelist}.o ${whitelist}.c
+	${OBJCOPY} --only-section=.BTF_whitelist* --set-section-flags .BTF=alloc,readonly \
+                --strip-all ${whitelist}.o 2>/dev/null
+
+	# Link BTF and BTF_whitelist objects together
+	${LD} -r -o ${2} ${1} ${whitelist}.o
 }
 
 # Create ${2} .o file with all symbols from the ${1} object file
-- 
2.25.4

