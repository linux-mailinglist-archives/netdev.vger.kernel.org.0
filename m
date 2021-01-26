Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C91530438A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 17:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392775AbhAZQPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 11:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391938AbhAZQOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 11:14:06 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A649AC061A2E
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 08:13:25 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ox12so23797466ejb.2
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 08:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uYjhI9Zs729gEk72NbctUgKe2hbWHlrBlwkbt1TwJow=;
        b=W+h7X+uus9hJKu8qXg9P1U4DIto5ByGHdTbf+NTfA4ES20D2WbTr0MWpYbi2vzIX+6
         fVnxPcEM72PL5UuketJW8f5NbFOWvju6O0aerbXl+6TIgKOCRFp0GonoDuaHVEZizve/
         j1gMnJ2pTGwfUoUVA3pv2F+aB6yreT3NNTamEFDzwkQqjFI7HtXv9s6hsn2oWDlcYpkr
         0R+SnR+7RCzdaEbZ9q6aa433uBvaa3RfSsL0NAVDYKysQ1u/dwin9gS9ruuYbTWmlhmQ
         Vw37iCZ0co4Brc6Elcf2qyfr+oU5OQflhOBIeeSB9J8FIfeDKgHM5AnJTzb5iRm5etB+
         0aqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uYjhI9Zs729gEk72NbctUgKe2hbWHlrBlwkbt1TwJow=;
        b=nrTAlXcKzDNCDXybOSxgHyJvQuKMht936+FV9eE/Qa7SpPVUk1mUS3Je2706mVa7SW
         6kG7CUdOClYiKD/QRYyKL2pk3BhFP19fFB6hUIiJ78/6hez/rLDnXeER12YUtFRqcpDo
         +tqqlg3LoW/z/EJkXKvOdU53A/5s+eLVs0YOmzcSyTlo1Pt9HdwXsIw8DDr7ob4thASl
         mfYLcqnMUYLMXiiBUJ4e58Qi4BaeIN379BibtrIReKDFVDvirD1T2u/C8OJiXhRqLrCK
         5uhL/tom6ulm87Pbal+CADzAShLKKOFJbmG5MaPsuu2SvfBCx4oywGFBpVGb0yl1/zb6
         bp+A==
X-Gm-Message-State: AOAM532XSVXCpRG+WMaJY7SopxFRTf4z92tYTDvP59lp+lVY1R+d8EtZ
        qk9aGyEZ5NOqrXxqCbXqAt8U4A==
X-Google-Smtp-Source: ABdhPJznhk70RsoMMkEfODd7T5VGUlA0+gOKPb2sl0nJ4IT0dMXY9P0b8jHPqT3GEnXmc2xpBNhclw==
X-Received: by 2002:a17:906:48f:: with SMTP id f15mr3991893eja.392.1611677604418;
        Tue, 26 Jan 2021 08:13:24 -0800 (PST)
Received: from localhost.localdomain ([194.35.116.76])
        by smtp.gmail.com with ESMTPSA id dd27sm12804927edb.23.2021.01.26.08.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 08:13:23 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        David Gow <davidgow@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH bpf v2] bpf: fix build for BPF preload when $(O) points to a relative path
Date:   Tue, 26 Jan 2021 16:13:20 +0000
Message-Id: <20210126161320.24561-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building the kernel with CONFIG_BPF_PRELOAD, and by providing a relative
path for the output directory, may fail with the following error:

  $ make O=build bindeb-pkg
  ...
  /.../linux/tools/scripts/Makefile.include:5: *** O=build does not exist.  Stop.
  make[7]: *** [/.../linux/kernel/bpf/preload/Makefile:9: kernel/bpf/preload/libbpf.a] Error 2
  make[6]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf/preload] Error 2
  make[5]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf] Error 2
  make[4]: *** [/.../linux/Makefile:1799: kernel] Error 2
  make[4]: *** Waiting for unfinished jobs....

In the case above, for the "bindeb-pkg" target, the error is produced by
the "dummy" check in Makefile.include, called from libbpf's Makefile.
This check changes directory to $(PWD) before checking for the existence
of $(O). But at this step we have $(PWD) pointing to "/.../linux/build",
and $(O) pointing to "build". So the Makefile.include tries in fact to
assert the existence of a directory named "/.../linux/build/build",
which does not exist.

Note that the error does not occur for all make targets and
architectures combinations. This was observed on x86 for "bindeb-pkg",
or for a regular build for UML [0].

Here are some details. The root Makefile recursively calls itself once,
after changing directory to $(O). The content for the variable $(PWD) is
preserved across recursive calls to make, so it is unchanged at this
step. For "bindeb-pkg", $(PWD) is eventually updated because the target
writes a new Makefile (as debian/rules) and calls it indirectly through
dpkg-buildpackage. This script does not preserve $(PWD), which is reset
to the current working directory when the target in debian/rules is
called.

Although not investigated, it seems likely that something similar causes
UML to change its value for $(PWD).

Non-trivial fixes could be to remove the use of $(PWD) from the "dummy"
check, or to make sure that $(PWD) and $(O) are preserved or updated to
always play well and form a valid $(PWD)/$(O) path across the different
targets and architectures. Instead, we take a simpler approach and just
update $(O) when calling libbpf's Makefile, so it points to an absolute
path which should always resolve for the "dummy" check run (through
includes) by that Makefile.

David Gow previously posted a slightly different version of this patch
as a RFC [0], two months ago or so.

[0] https://lore.kernel.org/bpf/20201119085022.3606135-1-davidgow@google.com/t/#u

v2: Use $(LIBBPF_OUT) instead of $(abspath .), and improve commit log

Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Reported-by: David Gow <davidgow@google.com>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 kernel/bpf/preload/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
index 23ee310b6eb4..1951332dd15f 100644
--- a/kernel/bpf/preload/Makefile
+++ b/kernel/bpf/preload/Makefile
@@ -4,8 +4,11 @@ LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
 LIBBPF_A = $(obj)/libbpf.a
 LIBBPF_OUT = $(abspath $(obj))
 
+# Although not in use by libbpf's Makefile, set $(O) so that the "dummy" test
+# in tools/scripts/Makefile.include always succeeds when building the kernel
+# with $(O) pointing to a relative path, as in "make O=build bindeb-pkg".
 $(LIBBPF_A):
-	$(Q)$(MAKE) -C $(LIBBPF_SRCS) OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
+	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
 
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
 	-I $(srctree)/tools/lib/ -Wno-unused-result
-- 
2.25.1

