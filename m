Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3CA10A71B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKZX2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:28:23 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:54851 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKZX2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:28:23 -0500
Received: by mail-pl1-f202.google.com with SMTP id a11so8608342plp.21
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VDZqM1iojgFZUCYrHNzPRvpM2lTnxWFPVSbwolce2xQ=;
        b=D08ZOJIZtFfBsctfgxLgpWHDfInaQEqGQykJ8Uo8f9Fj3MY4yyPmFfbisQhlHtZNSW
         hsApKcsQ1fRYKV3RL0DiHFvFrv7wpwnL+gG6Ibu8DQpQzbUQbHXCR/LQdSEfYEgohxrC
         mS9g976WGt0Fy5RXHKwFAXwox3q5syPBta84MgzjXdRYALKPxRonqFG3lls9B4KdkATE
         4YZ2YVa5b+nT7CoN8k1PLPwIM72Ace39u6WH04ZEFHEqNVeUPIzulOC7oS7SbipgkOh/
         Wrf3amdEIC2JpshDWRpYGEtTu4oLbwmPqA0vzyNTT/DDvgBlbO08usr//RlsOHOzOVpn
         I0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VDZqM1iojgFZUCYrHNzPRvpM2lTnxWFPVSbwolce2xQ=;
        b=qoH4ByGG/mswbdet9Q8BjQcCeZC2IUWYccPoHWhc79lPTBpv0wscVJGohdr3yAieEG
         rui5pQXBeKKTyNcQAc5P12Zcx1IfImPyDe68ooq4PyQEbofl9wyj6i2kDX6mzyJh2fwR
         AzxuuPOLR4wz4OWJ4aIwfCm3j832DQJEE3bH21NAHMmTqgHTJ/AiOdfoc5AYzh/BvrYN
         ybdM1RY6eqOKkEXzgI4hYc41Mxh2/aYI/fRqDDnXq27VdMSsmqYPII+hvY3WT+eES261
         s1mICuykM4giTSp7GD0XixuHkMnGLNjNLqGcyqP4TpMCWvgw/HskVAHneeu6p6Inn+UX
         uJKg==
X-Gm-Message-State: APjAAAWR7KDvt0GK0twpStK//ZPlIQDI+880Nxoxi+SY+F7GUSN49Mkw
        zxW9wR3SsukMymfzh2AlApRCi9DP37kALjAyfGFM5qzI/4q66MhU/TDwl1Yjz89AbVQpP8Js/q5
        +7pao5dLMj0Z4QahFi9w/pz6x3bYLHksVTvybv7jfwDxQfXCOb/tqkA==
X-Google-Smtp-Source: APXvYqys17Q47p4LoALIoE05qH+lx+rls48bt8VihVQH0ktok1EKTIGLiiRn/o73BrloNEDrRUH5Nh0=
X-Received: by 2002:a63:ec4f:: with SMTP id r15mr1228739pgj.17.1574810901241;
 Tue, 26 Nov 2019 15:28:21 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:28:18 -0800
Message-Id: <20191126232818.226454-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH bpf v2] bpf: support pre-2.25-binutils objcopy for vmlinux BTF
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
.BTF section of vmlinux is empty and kernel will prohibit
BPF loading and return "in-kernel BTF is malformed".

--dump-section argument to binutils' objcopy was added in version 2.25.
When using pre-2.25 binutils, BTF generation silently fails. Convert
to --only-section which is present on pre-2.25 binutils.

Documentation/process/changes.rst states that binutils 2.21+
is supported, not sure those standards apply to BPF subsystem.

v2:
* exit and print an error if gen_btf fails (John Fastabend)

Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 scripts/link-vmlinux.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 06495379fcd8..2998ddb323e3 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -127,7 +127,8 @@ gen_btf()
 		cut -d, -f1 | cut -d' ' -f2)
 	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
 		awk '{print $4}')
-	${OBJCOPY} --dump-section .BTF=.btf.vmlinux.bin ${1} 2>/dev/null
+	${OBJCOPY} --set-section-flags .BTF=alloc -O binary \
+		--only-section=.BTF ${1} .btf.vmlinux.bin 2>/dev/null
 	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
 		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
 }
@@ -253,6 +254,10 @@ btf_vmlinux_bin_o=""
 if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
 	if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
 		btf_vmlinux_bin_o=.btf.vmlinux.bin.o
+	else
+		echo >&2 "Failed to generate BTF for vmlinux"
+		echo >&2 "Try to disable CONFIG_DEBUG_INFO_BTF"
+		exit 1
 	fi
 fi
 
-- 
2.24.0.432.g9d3f5f5b63-goog

