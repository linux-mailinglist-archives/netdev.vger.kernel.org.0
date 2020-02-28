Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6350172E79
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 03:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbgB1CGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 21:06:17 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37059 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgB1CGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 21:06:17 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so856736pfn.4;
        Thu, 27 Feb 2020 18:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v4cW/g3fUQ91WwKvWZgmCpE4Uu5W0M0pWvBhsguMerc=;
        b=OkFr7WdwskVqohIbd4HRcgQv2Ym3y3Vd7MN+9P4GDcECeFy42oV6Kl3iBL1iITlnlY
         2wPQezDgruBZSwDFwbeHNOH8uhEdL3BfBCZUAvItv9tXF4CVvuTn4nVx3aX2KHWkUbXm
         V0dhYRtVEmWCIXt7MpQk3P+JHGCoTxcOEyeXUYTDo9Xx2W5/KfrvRe6y7wJVT1XS4zjT
         ZtKstqtqnwZyzDyu4Kg3jsIuPG3XPnbgxWp7m2nbxPrXTU4sptmPOHVcLDJA4OkQHD8j
         UTB+ZpnSgMn6XMLDAIhj4dzCt4NIqKhBABlEhy51qg4XJP3cxgHRmIqCtcJqHHoqzryM
         gudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v4cW/g3fUQ91WwKvWZgmCpE4Uu5W0M0pWvBhsguMerc=;
        b=INOtpCk+ByfbHZRF7STXFuyjspflvdnlrBdFsfwX3kTF72YW5u1QwBERtHTdOe6VTf
         abJ3bSvvp8sLiC2lnENlxwK34Sj05+U0IquKRDAH6J6J6d16vKUIz1VGuncEsXWMVtS3
         ZDx8YJHHw/+pujUn3bhA8+uMa1hhVNXLp2L22c8DFxVnJQJ46SqenRdWf0J0JcHISEGm
         weFHcymViPBs23DkwTq9cdHsBF7MAAZuqUOmtoeRkzER4+gOPi0+vPFS7qOAKalu4Oj4
         8T2XBH6vHrM4V1RBt13hr+T0v9vuiex1Nk5YUo7W6fQFmBoaH8DrHdPtE8L/3F0hJJKx
         nh8Q==
X-Gm-Message-State: APjAAAVSspEqTNsFTEr4ZaAWbL27zVkMIKyn5sLj4Zl6e1EiXraVc00f
        zWJBOSC8YsxJ1QB1TQqfTW8=
X-Google-Smtp-Source: APXvYqwgdyo6WXIrdhbbJVgTMnvQNyrnMA7SFaJ3vEvG46q6qIUupMhVHTjiaVlluvrQ+9OuLqRkQw==
X-Received: by 2002:a63:4e4a:: with SMTP id o10mr2302846pgl.212.1582855575406;
        Thu, 27 Feb 2020 18:06:15 -0800 (PST)
Received: from hpg8-3.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id f1sm7533007pjq.31.2020.02.27.18.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 18:06:14 -0800 (PST)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] bpf: btf: Fix BTF verification of the enum size in struct/union
Date:   Fri, 28 Feb 2020 11:02:12 +0900
Message-Id: <20200228020212.16183-1-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_enum_check_member() checked if the size of "enum" as a struct
member exceeded struct_size or not. Then, the function definitely
compared it with the size of "int" now. Therefore, errors could occur
when the size of the "enum" type was changed.

Although the size of "enum" is 4-byte by default, users can change it
as needed (e.g., the size of the following test variable is not 4-byte
but 1-byte). It can be used as a struct member as below:

enum test : char {
	X,
	Y,
	Z,
};

struct {
	char a;
	enum test b;
	char c;
} tmp;

With the setup above, when I tried to load BTF, the error was given
as below:

------------------------------------------------------------------

[58] STRUCT (anon) size=3 vlen=3
	a type_id=55 bits_offset=0
	b type_id=59 bits_offset=8
	c type_id=55 bits_offset=16
[59] ENUM test size=1 vlen=3
	X val=0
	Y val=1
	Z val=2

[58] STRUCT (anon) size=3 vlen=3
	b type_id=59 bits_offset=8 Member exceeds struct_size

libbpf: Error loading .BTF into kernel: -22.

------------------------------------------------------------------

The related issue was previously fixed by the commit 9eea98497951 ("bpf:
fix BTF verification of enums"). On the other hand, this patch fixes
my explained issue by using the correct size of "enum" declared in
BPF programs.

Fixes: 179cde8cef7e ("bpf: btf: Check members of struct/union")
Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7871400..32ab922 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2418,7 +2418,7 @@ static int btf_enum_check_member(struct btf_verifier_env *env,
 
 	struct_size = struct_type->size;
 	bytes_offset = BITS_ROUNDDOWN_BYTES(struct_bits_off);
-	if (struct_size - bytes_offset < sizeof(int)) {
+	if (struct_size - bytes_offset < member_type->size) {
 		btf_verifier_log_member(env, struct_type, member,
 					"Member exceeds struct_size");
 		return -EINVAL;
-- 
1.8.3.1

