Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000ED240CE2
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 20:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHJSV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 14:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgHJSVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 14:21:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2B7C061787
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 11:21:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l13so7836994ybf.5
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 11:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2vXzz9RZaTLHmklPgeZMZ7n+eXaXAJl2SzN+35Zb3vY=;
        b=Xc3Mu/6Iaucr66ZiIbk5IiFY/YxYzRde0HoOqvoidqKKocQZcmyMNmHCUD1yGmMEHv
         0i+rKIt8gIXiN+GnbFrGOXdGmqRJ4EU/G5Um9yCIx0xBi1LMsThGy/KDS7ZoeREN4w2W
         2+NejrEwtMLxzu8CUtDmP3kK7KMXYF8aqTFJFjx4asUQSwWsoryPQVtk8lP3bMabFSVY
         s//DEUkbRWUVZjkzLtOvvfWZbz9H9FyWtL8ol114FD1gJtb4hiSUUYtLv7COxHMQc+mX
         y8RXSck/OQbIjVlobdxOml68XXLlNO423sWlcMOpcf6UrHnnrZ0LnI9St6JB5Ja/TMG4
         7a4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2vXzz9RZaTLHmklPgeZMZ7n+eXaXAJl2SzN+35Zb3vY=;
        b=l6lx5ggZFKZ6x4uNNRwfiLldGlQ0XbhFVjcCIM/JJtD4ejsE3ZOEGvYesDJTKP4sym
         NFW0bYj5VeolYZiXJ/wtyQEkw5BCLwLSJEVERonAKTyc72L/FRFd93I3B40P9jkE+PgW
         MIlrxQowIcCvQDAoNI7KuFJBk9+9345nijZ8sPaCIhYBxL7P3aeGPceVJGcl/uv59Feg
         r4VxMdxFNCwioNVZv56ojH8SHhxVduOgeTFKsuNUnFy7auColPbVPIoKQIW0+XwsABqe
         U+6/upIlNNuYyhRoMI0GHR/azj7iwf0agMhYRCmycDFNbUpvAPrHGbxjgTHGgtdbWCfN
         1qwQ==
X-Gm-Message-State: AOAM533P3SJnJuTD0sno2kQu98anxIRzv2//j6RP8D4WM/IeqwE0/Kow
        5xdP6j3HG37E1g3zelkAGE+DPmWuSNh2B9CauQ0=
X-Google-Smtp-Source: ABdhPJxSruMwwAUl3EcPl4M3H+GVaFfbBao26VCJwXIrm/O/ZLItnCovpcssixNNvTuPahlTJbao0/kgLAD9nNECAS0=
X-Received: by 2002:a5b:b45:: with SMTP id b5mr41549839ybr.294.1597083682134;
 Mon, 10 Aug 2020 11:21:22 -0700 (PDT)
Date:   Mon, 10 Aug 2020 11:21:11 -0700
Message-Id: <20200810182112.2221964-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 net] bitfield.h: don't compile-time validate _val in FIELD_FIT
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Alex Elder <elder@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

When ur_load_imm_any() is inlined into jeq_imm(), it's possible for the
compiler to deduce a case where _val can only have the value of -1 at
compile time. Specifically,

/* struct bpf_insn: _s32 imm */
u64 imm = insn->imm; /* sign extend */
if (imm >> 32) { /* non-zero only if insn->imm is negative */
  /* inlined from ur_load_imm_any */
  u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
  if (__builtin_constant_p(__imm) && __imm > 255)
    compiletime_assert_XXX()

This can result in tripping a BUILD_BUG_ON() in __BF_FIELD_CHECK() that
checks that a given value is representable in one byte (interpreted as
unsigned).

FIELD_FIT() should return true or false at runtime for whether a value
can fit for not. Don't break the build over a value that's too large for
the mask. We'd prefer to keep the inlining and compiler optimizations
though we know this case will always return false.

Cc: stable@vger.kernel.org
Fixes: 1697599ee301a ("bitfield.h: add FIELD_FIT() helper")
Link: https://lore.kernel.org/kernel-hardening/CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com/
Reported-by: Masahiro Yamada <masahiroy@kernel.org>
Debugged-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V1->V2:
* add Fixes tag.

 include/linux/bitfield.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 48ea093ff04c..4e035aca6f7e 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -77,7 +77,7 @@
  */
 #define FIELD_FIT(_mask, _val)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");	\
+		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");	\
 		!((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
 	})
 
-- 
2.28.0.236.gb10cc79966-goog

