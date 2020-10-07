Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4842856A4
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 04:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgJGC3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 22:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgJGC3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 22:29:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994F9C0613D3
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 19:29:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k3so979188ybk.16
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 19:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=JsnyKWrbECrfBzXkqNc7AuN/S85GdnYe4agNLqwli20=;
        b=UxRcy5CAZ82sxkQRn6UmD30seYN1cnIRmTD+GibYAjnx3BSnWBWRZnltZy0EfS3aQN
         CxgB3iK33Z9SiHflnTbpwnsDx2t1tnSfm+pgxenQ4D4sztbbSppVHQx57c0pXs3MdT7w
         jUhKG7jsEkv+iIkdJU4RPKbD75wqy8viGDdkDcrTF4+d1RWDG3LwcB7cG/qRrs8kFN6Z
         k3QIcRJOtWyAEX54ZnwF2/6epGb3SFPaiZ+UCMNkLY933pBgeBK+4tcfp9rsg/pi/aRi
         ZeHKvtjxnGxa7CZBzllQDFws6DXPE6DQm4ge219mEUBX8IfduPMx1EJPCulMGH6p1WEk
         Ehhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=JsnyKWrbECrfBzXkqNc7AuN/S85GdnYe4agNLqwli20=;
        b=dHI7H93izxFzrHNyLv6i+R1T6UYfpx7zsjSqKIkamVE+U3l+31FSmi6C8bbZsuTAD1
         maaqV80b3E86Ujgvx83W9vIyWlULqrjgqAPiloJlmrtsw4iJ30b648YY00sAcxBEy7EK
         DjDuYnDz+28yk7Wv3OcTG0KZRUC8D8hrVa126G3SVTIeXaj94+Rbxm0wg79Xn+U5AHQ/
         3PBv/Yr6KOHlV+/0CbfxxMUTd8hhiGbrbxhcvsCsHvIt6+z9NNCUl8njt+Fi763QIIjX
         Sh4VuJtZLmTcs/b+HLkFCfiuugBGeXnPRrY0FQxIV60AwDIzTPZ9D78Dbkiojl5mLjWV
         MyPg==
X-Gm-Message-State: AOAM533GUEKO5eUB4lYEXUTj55keqo899U2DBOFcpnxAOSUBkyLHDRCl
        tDMLDhrlu4hJPhTKLPHEXd4OFlfXa45YuuIz37K9URZaWS1cjXVT4IpNw8eFEyC99SSksHC9IHP
        HddmEheVEcyB3+w/ipRIC390QkUxq4x4Qcl0g+43gAJXdlrorGR70x6SXy8WxNg==
X-Google-Smtp-Source: ABdhPJxtAXVnX5DVi19z61yuLvPzy8HDauToLRlzql2Attti0KIu+POudPPRkMApD1XiYo/CKFZXn4oGy90=
Sender: "haoluo via sendgmr" <haoluo@haoluo.svl.corp.google.com>
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:241:: with SMTP id 62mr1451366ybc.244.1602037740608;
 Tue, 06 Oct 2020 19:29:00 -0700 (PDT)
Date:   Tue,  6 Oct 2020 19:28:57 -0700
Message-Id: <20201007022857.2791884-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH v3] selftests/bpf: Fix test_verifier after introducing resolve_pseudo_ldimm64
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched
the order of check_subprogs() and resolve_pseudo_ldimm() in
the verifier. Now an empty prog expects to see the error "last
insn is not an the prog of a single invalid ldimm exit or jmp"
instead, because the check for subprogs comes first. It's now
pointless to validate that half of ldimm64 won't be the last
instruction.

Tested:
 # ./test_verifier
 Summary: 1129 PASSED, 537 SKIPPED, 0 FAILED
 and the full set of bpf selftests.

Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
Signed-off-by: Hao Luo <haoluo@google.com>
---
Changelog in v3:
 - Remove without renaming the rest

Changelog in v2:
 - Remove the test instead of modifying the err msg.

 tools/testing/selftests/bpf/verifier/basic.c    | 2 +-
 tools/testing/selftests/bpf/verifier/ld_imm64.c | 8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/basic.c b/tools/testing/selftests/bpf/verifier/basic.c
index b8d18642653a..de84f0d57082 100644
--- a/tools/testing/selftests/bpf/verifier/basic.c
+++ b/tools/testing/selftests/bpf/verifier/basic.c
@@ -2,7 +2,7 @@
 	"empty prog",
 	.insns = {
 	},
-	.errstr = "unknown opcode 00",
+	.errstr = "last insn is not an exit or jmp",
 	.result = REJECT,
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
index 3856dba733e9..f9297900cea6 100644
--- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
+++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
@@ -50,14 +50,6 @@
 	.errstr = "invalid bpf_ld_imm64 insn",
 	.result = REJECT,
 },
-{
-	"test5 ld_imm64",
-	.insns = {
-	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
-	},
-	.errstr = "invalid bpf_ld_imm64 insn",
-	.result = REJECT,
-},
 {
 	"test6 ld_imm64",
 	.insns = {
-- 
2.28.0.806.g8561365e88-goog

