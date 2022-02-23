Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50C34C06DF
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbiBWB34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236557AbiBWB3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:29:55 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F6049F81
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:29:26 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a22-20020aa79716000000b004e16e3cc5fcso8044673pfg.11
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=XJt7E+/TbSWO+R4K5yrVaKdlcnMjFDGRebGSqWZKoOM=;
        b=VUYknfLXL+unn/6VXtDwyrULYfWLDjOsZa0fJmThc66yI1NsTFLXS6HOfPxjE13UR0
         wfmwCx/GaDmK8g9Seq1lutlHlvAv2/YRiwYFbBvOXJw2ZEj/WB9DTgIoDA84dsTiF24A
         /6zLKmpQbnTLC4tgp3e6zNGrOFs9syvzaoDMq5miys2dfVDHVuNhilHNQDsMksd6p5pP
         9rSvP4TH5Ih9Nu9GwP0qxEdeCOVbDBSUbpgHqa7zjE/+PTlmyizMdoKp5f+kdjciUQXS
         h5sUUYrb2DvtR2As0ASss2/vfKVYUvuCWAOvppGcllXLKnyuYinNIAjYK1oVtKeRqYtc
         hTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=XJt7E+/TbSWO+R4K5yrVaKdlcnMjFDGRebGSqWZKoOM=;
        b=3JtQhv1gXWIncDTnynb5DVQAdwSR3y9KjBr1Fcx+SG7OHstdaD7ZThr1JPDvf5gEPW
         JN/5iDtiCAeD+G6u6up5Tu66ybZqg4b2tN9kES9rJbFe6rdjUXdgBgy34gtdRKKeg3xh
         tStzA+ARD2FzJYCzUWN2UeVNcWTw8nFoA13TSO/XMoApcz1D4ZtfkT8ABQjGmOhnG3N3
         NYxJ9BoBaz4mvY90MzEpFOgg/n6IqHSCCGLiwC1t5nbkfenoOMjecf+HaxPr2L3hDBZD
         vbJo8jPqF7lYJmr0bIYPlU2gV+lqwvryjE6Sz814Klbq2br6tziQRYCNKTV0ooJnRGAi
         D7eA==
X-Gm-Message-State: AOAM531lqIV5fdgHXZ1uR7Ny8mpF+6faQkgjKfwij5cw1rS3eh1zaXwn
        T0zse2rMu7wYhICbKFZKvE4skPQhcem8
X-Google-Smtp-Source: ABdhPJwok/zYeBv9iYgH5TNm6XOpbgEypuRH1+BE3TzucfcQU2CHSzz99Lv+LdxirpLHnB05kLsrDfGCDg4o
X-Received: from connoro.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:a99])
 (user=connoro job=sendgmr) by 2002:a17:902:e34b:b0:14f:af20:4b3c with SMTP id
 p11-20020a170902e34b00b0014faf204b3cmr12782893plc.56.1645579765763; Tue, 22
 Feb 2022 17:29:25 -0800 (PST)
Date:   Wed, 23 Feb 2022 01:28:14 +0000
Message-Id: <20220223012814.1898677-1-connoro@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH bpf-next] bpf: add config to allow loading modules with BTF mismatches
From:   "Connor O'Brien" <connoro@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Connor O'Brien" <connoro@google.com>,
        "=?UTF-8?q?Michal=20Such=C3=A1nek?=" <msuchanek@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF mismatch can occur for a separately-built module even when the ABI
is otherwise compatible and nothing else would prevent successfully
loading. Add a new config to control how mismatches are handled. By
default, preserve the current behavior of refusing to load the
module. If MODULE_ALLOW_BTF_MISMATCH is enabled, load the module but
ignore its BTF information.

Suggested-by: Yonghong Song <yhs@fb.com>
Suggested-by: Michal Such=C3=A1nek <msuchanek@suse.de>
Signed-off-by: Connor O'Brien <connoro@google.com>
---
Hello,

In the discussion regarding BTF compatibility & modules, there seemed
to be broad agreement that an option to ignore mismatches would be
reasonable. Currently the only option for handling this problem seems
to be to disable BTF entirely, so this would at least be an
incremental improvement.

Thanks,
Connor

 kernel/bpf/btf.c  |  3 ++-
 lib/Kconfig.debug | 10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 11740b300de9..1a21f24105b3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6397,7 +6397,8 @@ static int btf_module_notify(struct notifier_block *n=
b, unsigned long op,
 			pr_warn("failed to validate module [%s] BTF: %ld\n",
 				mod->name, PTR_ERR(btf));
 			kfree(btf_mod);
-			err =3D PTR_ERR(btf);
+			if (!IS_ENABLED(CONFIG_MODULE_ALLOW_BTF_MISMATCH))
+				err =3D PTR_ERR(btf);
 			goto out;
 		}
 		err =3D btf_alloc_id(btf);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1555da672275..ff857bb7d633 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -339,6 +339,16 @@ config DEBUG_INFO_BTF_MODULES
 	help
 	  Generate compact split BTF type information for kernel modules.
=20
+config MODULE_ALLOW_BTF_MISMATCH
+	bool "Allow loading modules with non-matching BTF type info"
+	depends on DEBUG_INFO_BTF_MODULES
+	help
+	  For modules whose split BTF does not match vmlinux, load without
+	  BTF rather than refusing to load. The default behavior with
+	  module BTF enabled is to reject modules with such mismatches;
+	  this option will still load module BTF where possible but ignore
+	  it when a mismatch is found.
+
 config GDB_SCRIPTS
 	bool "Provide GDB scripts for kernel debugging"
 	help
--=20
2.35.1.473.g83b2b277ed-goog

