Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCAA189035
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCQVQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:16:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38744 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgCQVQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 17:16:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id z5so12654754pfn.5
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 14:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=KBl7oV3oQ7bIla5SSC487wlydUV4JIjyK9cn0JCM0zM=;
        b=JqkaALJ5ig5SpZprmcPOWV/HzvyvZTRi6a3ZeKp7zKhJU+cbUo63qPBmHSU/wevc49
         nFJhEyabS5LydOwARKdfr1WvsJ38kJ7xStj5DY4kwmLia2+Mp2Sv1XATNHnvl1IcHyF+
         wqt2vvL4OHuifKwdM0ufORzL9/HUy7YmiyWVNOz4yKMJnjLenxOtJx/WW+LPV7d8N8z5
         2WXAjvt+dAtxTP/IiCT/uYUxNoCBNeiTwFRbhGLZcY4cAvvnF0jtE3LVHV84rb21xEQk
         dE+9VdLUE3RALVZl24U8+EQ8AKKu3YXEr1qhrwr8Uvt8TMR0YE01O7ooD0hoHA1WW0cp
         HN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=KBl7oV3oQ7bIla5SSC487wlydUV4JIjyK9cn0JCM0zM=;
        b=E6fgCV0ptvBWbqXtkm1QEkZEw+Hz6uyYvAMyieKop1ihojlB4dxbZtIsU34VC7OD0s
         egKPssjJZmY4kjB9I4Pr1OFiNxfC3Iagt3/yQf7Z5cNU10pbcvYg1+zjYz7plL5L6gUy
         lKcZCnfAoRvtNORqDIub/qlDJgerYL1TVJNJUq+GKB6nLdYrnHOZxjol2ksEoqJT2iov
         AxstsX+/PVzYXihyhvH5pKWpAWy/cytu8EeutVqOYegDupbu4uzwAZvJ+x4i9j5TJ16b
         WZ2pGeMn0op/7LhT+JAUsfVEAkAd4fhZCvvNwILDNXqFei0CZQ/BJDBu6cADeLOR8dTy
         qrQA==
X-Gm-Message-State: ANhLgQ2Iux3WXUA2g0UxY+Fweul2u/7JEMOryfOt2d2GZRAt4yrDE6HA
        id1J83t38ML9Nmg3EoygCe8iqg==
X-Google-Smtp-Source: ADFU+vv9D8BsY6opdwAvslQPLg74KLY6ckni9rdbSiEb4zahP4dbHlButCdoQkWBZV5NaF1QA7+aAg==
X-Received: by 2002:a63:3fce:: with SMTP id m197mr1144365pga.38.1584479812827;
        Tue, 17 Mar 2020 14:16:52 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:9efe:9f1:9267:2b27])
        by smtp.gmail.com with ESMTPSA id l67sm282646pjb.23.2020.03.17.14.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 14:16:52 -0700 (PDT)
Date:   Tue, 17 Mar 2020 14:16:49 -0700
From:   Fangrui Song <maskray@google.com>
To:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH bpf-next v5] bpf: Support llvm-objcopy and llvm-objdump for
 vmlinux BTF
Message-ID: <20200317211649.o4fzaxrzy6qxvz4f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify gen_btf logic to make it work with llvm-objcopy and llvm-objdump.
The existing 'file format' and 'architecture' parsing logic is brittle
and does not work with llvm-objcopy/llvm-objdump.

.BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag and
rename .BTF to BTF so that C code can reference the section via linker
synthesized __start_BTF and __stop_BTF. This fixes a small problem that
previous .BTF had the SHF_WRITE flag. Additionally, `objcopy -I binary`
synthesized symbols _binary__btf_vmlinux_bin_start and
_binary__btf_vmlinux_bin_start (not used elsewhere) are replaced with
more common __start_BTF and __stop_BTF.

Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
"empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"

We use a dd command to change the e_type field in the ELF header from
ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
ET_EXEC as an input file is an extremely rare GNU ld feature that lld
does not intend to support, because this is error-prone.

Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/871
Signed-off-by: Fangrui Song <maskray@google.com>
---
  kernel/bpf/btf.c        |  9 ++++-----
  kernel/bpf/sysfs_btf.c  | 11 +++++------
  scripts/link-vmlinux.sh | 17 ++++++-----------
  3 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 50080add2ab9..6f397c4da05e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3477,8 +3477,8 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
  	return ERR_PTR(err);
  }
  
-extern char __weak _binary__btf_vmlinux_bin_start[];
-extern char __weak _binary__btf_vmlinux_bin_end[];
+extern char __weak __start_BTF[];
+extern char __weak __stop_BTF[];
  extern struct btf *btf_vmlinux;
  
  #define BPF_MAP_TYPE(_id, _ops)
@@ -3605,9 +3605,8 @@ struct btf *btf_parse_vmlinux(void)
  	}
  	env->btf = btf;
  
-	btf->data = _binary__btf_vmlinux_bin_start;
-	btf->data_size = _binary__btf_vmlinux_bin_end -
-		_binary__btf_vmlinux_bin_start;
+	btf->data = __start_BTF;
+	btf->data_size = __stop_BTF - __start_BTF;
  
  	err = btf_parse_hdr(env);
  	if (err)
diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
index 7ae5dddd1fe6..3b495773de5a 100644
--- a/kernel/bpf/sysfs_btf.c
+++ b/kernel/bpf/sysfs_btf.c
@@ -9,15 +9,15 @@
  #include <linux/sysfs.h>
  
  /* See scripts/link-vmlinux.sh, gen_btf() func for details */
-extern char __weak _binary__btf_vmlinux_bin_start[];
-extern char __weak _binary__btf_vmlinux_bin_end[];
+extern char __weak __start_BTF[];
+extern char __weak __stop_BTF[];
  
  static ssize_t
  btf_vmlinux_read(struct file *file, struct kobject *kobj,
  		 struct bin_attribute *bin_attr,
  		 char *buf, loff_t off, size_t len)
  {
-	memcpy(buf, _binary__btf_vmlinux_bin_start + off, len);
+	memcpy(buf, __start_BTF + off, len);
  	return len;
  }
  
@@ -30,15 +30,14 @@ static struct kobject *btf_kobj;
  
  static int __init btf_vmlinux_init(void)
  {
-	if (!_binary__btf_vmlinux_bin_start)
+	if (!__start_BTF)
  		return 0;
  
  	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
  	if (!btf_kobj)
  		return -ENOMEM;
  
-	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
-				    _binary__btf_vmlinux_bin_start;
+	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
  
  	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
  }
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index ac569e197bfa..ae2048625f1e 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -133,17 +133,12 @@ gen_btf()
  	info "BTF" ${2}
  	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
  
-	# dump .BTF section into raw binary file to link with final vmlinux
-	bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
-		cut -d, -f1 | cut -d' ' -f2)
-	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
-		awk '{print $4}')
-	bin_file=.btf.vmlinux.bin
-	${OBJCOPY} --change-section-address .BTF=0 \
-		--set-section-flags .BTF=alloc -O binary \
-		--only-section=.BTF ${1} $bin_file
-	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
-		--rename-section .data=.BTF $bin_file ${2}
+	# Extract .BTF, add SHF_ALLOC, rename to BTF so that we can reference
+	# it via linker synthesized __start_BTF and __stop_BTF. Change e_type
+	# to ET_REL so that it can be used to link final vmlinux.
+	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
+		--rename-section .BTF=BTF ${1} ${2} 2>/dev/null && \
+		printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
  }
  
  # Create ${2} .o file with all symbols from the ${1} object file
-- 
2.25.1.481.gfbce0eb801-goog
