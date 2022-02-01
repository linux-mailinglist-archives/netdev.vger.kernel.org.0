Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910A14A670A
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiBAV0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:26:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45992 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBAV0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 16:26:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86B096178A;
        Tue,  1 Feb 2022 21:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AFEC340EB;
        Tue,  1 Feb 2022 21:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643750762;
        bh=6rnbOLJWBXVcGSJXTpu5MBi3+thi4vJ8d5VSjUdberY=;
        h=From:To:Cc:Subject:Date:From;
        b=Dhhd/MEA9V36isB/2df/xB+n7aVMViQshGcJ809iMiNksJYNOM25MGq1Rjcvea6hS
         MDnGkplsw4bHHiimDBeTaK8F1iQLAx400U9OWtG1iggxrwBu6hEKKlLvIMFu5PPcPH
         HxNzWTOeR8kR98kFxKzxdLm1Gi3snkwL5ySOEhyLIeeiZQM3anwFcfopWk/CfDiloL
         GlW5F4qHDt8x4xAlQDs1EselJlOjS+gzEX8YAiJXYaTXkEQ2iEDxAcppHH7m/bR5vN
         tTIIaq/mJC4jkTYfi+CoDXt4EAAT3K+IqsPcJkyFc19cfEFQhQ87+yJMFO/U0GXXzD
         6gzs5j2h1aGPg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] tools/resolve_btfids: Do not print any commands when building silently
Date:   Tue,  1 Feb 2022 14:25:04 -0700
Message-Id: <20220201212503.731732-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with 'make -s', there is some output from resolve_btfids:

$ make -sj"$(nproc)" oldconfig prepare
  MKDIR     .../tools/bpf/resolve_btfids/libbpf/
  MKDIR     .../tools/bpf/resolve_btfids//libsubcmd
  LINK     resolve_btfids

Silent mode means that no information should be emitted about what is
currently being done. Use the $(silent) variable from Makefile.include
to avoid defining the msg macro so that there is no information printed.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

This should apply to either bpf or bpf-next so no subject prefix. I
would prefer it goes in sooner rather than later but I'll leave that up
to you all.

 tools/bpf/resolve_btfids/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 9ddeca947635..320a88ac28c9 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -9,7 +9,11 @@ ifeq ($(V),1)
   msg =
 else
   Q = @
-  msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+  ifeq ($(silent),1)
+    msg =
+  else
+    msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+  endif
   MAKEFLAGS=--no-print-directory
 endif
 

base-commit: 26291c54e111ff6ba87a164d85d4a4e134b7315c
-- 
2.35.1

