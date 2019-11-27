Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53710B307
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfK0QOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:14:15 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:45606 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0QOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:14:14 -0500
Received: by mail-pg1-f201.google.com with SMTP id m13so12987965pgk.12
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 08:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=umdggYl7nSb+s7tapAIsZ3nsMjbadAOU71y7PSMRIfo=;
        b=lZ35bKmVwM8leqtmBzT52xV7P3VO0VSwnJLi35tRYZT6cQ+zoBb/Xy6350yqTNNilW
         dqj+wfI3nDCDNK24QreQeg/yAD5IT9LanJXEwxh6hDlE+V4IIuyZlpHsSUjBSNOT8n2f
         jXC+fa8omtX1ohCggeY4ZHZqY5KP6tMRvAt4Zx6/RM6Wqzz1ZXO3N04qzhPuLGKmVTD2
         30x9W4ZSvDuQvumjW/GRvZQ5aCy5WDz5qupGUqXTwpzLupDuyUP247hd/+vhxvizkvsR
         K2Br7fF7PlJNg/2jqfVnqFgHflHxn8rTmSYeL5zrPPgq53U0pTrY9x4qwxUeIFKylbkU
         9qsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=umdggYl7nSb+s7tapAIsZ3nsMjbadAOU71y7PSMRIfo=;
        b=LMRFT0sBArP/7DujzggIH7uUrH4Pjm2OSpG4kts/B8RUrpyulcIv9jL0XMqjFk/ZCo
         sxUfverqmYzNfcMgpVgH1Eg0GN79EfQXUDFTFtdoSNZwmtg4i8YBo4r016Hszb9GCZw0
         Py1Vbk6r46n2wCCRVfBq7LxD1nCfnmeOEMbNT+a2kojjQFnSS73vrrEcH9KBJomEWkv7
         4FCy2zEP7MLukFgblYq3MsSYSGWtO8HCs/JoFtFR+Su1cyU2BHsYVWTbBaHYh/zesv6a
         rFSFTUbVKAn0c7m/GNmKnBmT8ItWCc+1iVz1VYCuxXihzWjkED44i7cC0W0BShIyDgfh
         kRyQ==
X-Gm-Message-State: APjAAAWFqFDubeZDS1wny1Zmc2TZIir3ip9YtssZBKTXR88zS4A5PFMH
        nXoMvyrc8no1ZinSAEmwQb9TvS6grg2yvrxRPz53dDFggAG72RwY0ikERqCEqveS4DGSds7oT2j
        oOIQAzPVyzX7uqZAPyj6E41tRkF905J1PkV0oKlKRp5K1dCesQCXGCg==
X-Google-Smtp-Source: APXvYqyZKiAbGmboqXakOu/syfSt8e7hqJt4rMZegSNpW/VLgi+01QEORoqBdF47ET/yFl18+h3DNDY=
X-Received: by 2002:a63:4562:: with SMTP id u34mr5665255pgk.399.1574871252365;
 Wed, 27 Nov 2019 08:14:12 -0800 (PST)
Date:   Wed, 27 Nov 2019 08:14:10 -0800
Message-Id: <20191127161410.57327-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH bpf v3] bpf: support pre-2.25-binutils objcopy for vmlinux BTF
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

v3:
* resend with Andrii's Acked-by/Tested-by tags

Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Tested-by: Andrii Nakryiko <andriin@fb.com>
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

