Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB07187762
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733151AbgCQBQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:16:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38713 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbgCQBQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 21:16:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id w3so8840229plz.5
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 18:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=I6cJtFY7hJqIXMiYqUICiIaIcWOpJ+YQ+ECPyBPa2wE=;
        b=qF4LpAOHQN7tV5w1vxq0S6m4vFWtxrINpF1GqnoNLygPAR+w6fIrvbgNnBFcPZxlyG
         qzODdDvvh/EqJBsBWiIFnWigbF+0Kfmd4Rlil/RH6jhIwVW4mDYshdORPpyPyeklv8rO
         H6WlJIdGolzKm3hBLHyacFemnw5WguCfjctt2WppCDAUtbzz5bVlO8IVBmbiI9TdwKcc
         AQ5CnT7KQieTFkO6xCfBMfXrYmhk40DcNLKLcLgY61IZKThWuEz/EMfsEQSrxzWu/fAC
         VzWb6wREEYvUbN4xaPuzseMYJmWAuJffWqc6s11kmdT5WCQMZsdcJIfbUrxx6PtUqT2c
         iopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=I6cJtFY7hJqIXMiYqUICiIaIcWOpJ+YQ+ECPyBPa2wE=;
        b=F7KkhPIt0vjz0Zc69Y7lUeAYwl8NDTRQi1Hn8SHBm5D9xi6yNOJvDkooPy2rxXqxzW
         vNfHvFw2OPEAZ+MK6EImlXVydoTycBAFwWmqIhDXFFx8z1VPybw27PT1RfFz+AyXujSX
         Dz60uuk2+TMgdFrhhaFVGts8LYTui3qqFott1/8NZ52Qwm1MFMHsFdXq1rnsUvNOUfFc
         s6P3SZLnHYnK9yBC5czyHHNo/1O8QcAgLWVMtvlvRQ0eyta4duiXxQnd/B1Aowiaoa7R
         B9lpnUXaN8lkk6irNJWoq1UMN9tQqpXdLDahxNUL6qMTto72xssxi0AluXEvHfjEX64F
         SGhg==
X-Gm-Message-State: ANhLgQ0FU887DvslJ5nJJln9ohw9sGLVjZnAAtQWVyLicmxkfd5WrkoK
        YRpwrfKJupokxT0NOxE36iqZwg==
X-Google-Smtp-Source: ADFU+vvGv1cNBCN2udI5vdsCW+KdUNx4wY5wxFh3hPWrzoY2njnyN91VG8NxGe2uapQjnmBkNz0YCg==
X-Received: by 2002:a17:902:7441:: with SMTP id e1mr1829956plt.291.1584407817721;
        Mon, 16 Mar 2020 18:16:57 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:9efe:9f1:9267:2b27])
        by smtp.gmail.com with ESMTPSA id c11sm1027287pfc.216.2020.03.16.18.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 18:16:56 -0700 (PDT)
Date:   Mon, 16 Mar 2020 18:16:54 -0700
From:   Fangrui Song <maskray@google.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>, davem@davemloft.net,
        ast@kernel.org
Subject: [PATCH bpf] bpf: Support llvm-objcopy and llvm-objdump for vmlinux
 BTF
Message-ID: <20200317011654.zkx5r7so53skowlc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify gen_btf logic to make it work with llvm-objcopy and
llvm-objdump.  We just need to retain one section .BTF. To do so, we can
use a simple objcopy --only-section=.BTF instead of jumping all the
hoops via an architecture-less binary file.

We use a dd comment to change the e_type field in the ELF header from
ET_EXEC to ET_REL so that .btf.vmlinux.bin.o will be accepted by lld.

Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/871
Signed-off-by: Fangrui Song <maskray@google.com>
---
 scripts/link-vmlinux.sh | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index dd484e92752e..84be8d7c361d 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -120,18 +120,9 @@ gen_btf()
 
 	info "BTF" ${2}
 	vmlinux_link ${1}
-	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
 
-	# dump .BTF section into raw binary file to link with final vmlinux
-	bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
-		cut -d, -f1 | cut -d' ' -f2)
-	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
-		awk '{print $4}')
-	${OBJCOPY} --change-section-address .BTF=0 \
-		--set-section-flags .BTF=alloc -O binary \
-		--only-section=.BTF ${1} .btf.vmlinux.bin
-	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
-		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
+	# Extract .BTF section, change e_type to ET_REL, to link with final vmlinux
+	${OBJCOPY} --only-section=.BTF ${1} ${2} && printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16
 }
 
 # Create ${2} .o file with all symbols from the ${1} object file
-- 
2.25.1.481.gfbce0eb801-goog
