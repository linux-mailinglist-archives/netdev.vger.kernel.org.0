Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C207650CFC1
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 07:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbiDXFN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 01:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238229AbiDXFNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 01:13:44 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AA2F5A;
        Sat, 23 Apr 2022 22:10:44 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id C8438C024; Sun, 24 Apr 2022 07:10:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777042; bh=JjK2qZC6PYh0WxsLxO/AP8NF3SuTpsFKmckJsckwiLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uniNiW3L0wGZ72WLOCJ83RLybJVknlSpeP4TvmO3yDYv+dqBTJmarYYqfrDXmC7XA
         e0p4jdpudAU0xE+RNoHlce8VzbZNL3BD/Rg7kmPNEUR9/3UeVXUbu8mODCyT75pSVX
         FzNJmAgHSPe5C7Qva7JrF7e+ESwCfVYNwK5Aae55JiZMHq58tD47PrBeqYWJAO+QRY
         HWGyMG0cCuYI3DWpvPnuU3oYh5O2oXi/aw4JY8xsYx89kumb/JByzhEX3LLSQIEHpb
         wsaozj5e62pKFtK6wOw6b+3faOsY8OIwCMYBTF59Abp2HPut9b92hfB21RV9YwacRX
         i3Vs6Kz0LDG2g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 3B5BFC01E;
        Sun, 24 Apr 2022 07:10:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777042; bh=JjK2qZC6PYh0WxsLxO/AP8NF3SuTpsFKmckJsckwiLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uniNiW3L0wGZ72WLOCJ83RLybJVknlSpeP4TvmO3yDYv+dqBTJmarYYqfrDXmC7XA
         e0p4jdpudAU0xE+RNoHlce8VzbZNL3BD/Rg7kmPNEUR9/3UeVXUbu8mODCyT75pSVX
         FzNJmAgHSPe5C7Qva7JrF7e+ESwCfVYNwK5Aae55JiZMHq58tD47PrBeqYWJAO+QRY
         HWGyMG0cCuYI3DWpvPnuU3oYh5O2oXi/aw4JY8xsYx89kumb/JByzhEX3LLSQIEHpb
         wsaozj5e62pKFtK6wOw6b+3faOsY8OIwCMYBTF59Abp2HPut9b92hfB21RV9YwacRX
         i3Vs6Kz0LDG2g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c4a5b06b;
        Sun, 24 Apr 2022 05:10:26 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 2/4] tools/bpf: musl compat: do not use DEFFILEMODE
Date:   Sun, 24 Apr 2022 14:10:20 +0900
Message-Id: <20220424051022.2619648-3-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220424051022.2619648-1-asmadeus@codewreck.org>
References: <20220424051022.2619648-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFFILEMODE is not defined on musl libc.

Linus has expressed preference towards using explicit octal value in
the past over combinaisons of S_Ix{USR,GRP,OTH}, so just replace it
with 0666 directly

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---

I wanted to link to the Linus mail that said this, but it turns out
there weren't any list in Cc... I could be making this up but here's the
relevant part of his mail, which I hope is acceptable to forward as
there's nothing personal in it:
----
Date: Sat, 27 Feb 2021 11:29:31 -0800
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCHSET] inode type bits fixes
Message-ID: <CAHk-=whRkLinjW3gRJQ=fWHZcFP5iy37+4VVr38TzSXEwZrZGg@mail.gmail.com>

[...]

Finally, I absolutely _abhor_ the crazy "S_%&^%&^$" macros. They are
completely illegible garbage, imnsho. I'm looking at that

+                       mode = stat->st_mode & S_IALLUGO;
+                       mode |= inode->i_mode & ~S_IALLUGO;

and I'm like "WTF is that random character sequence again".

In this case, it's everything but the format.  I think it would be
more legible written the other way around, ie

+                       mode = stat->st_mode & ~S_IFMT;
+                       mode |= inode->i_mode & S_IFMT;

because at least that one has _less_ of the stupid random-generated letters.

Every single one of the "UGO" things are pure and utter crap. The
octal representation of the actual permissions masks are _way_ more
legible than the insane "standard" names for them.
----


 tools/bpf/bpf_jit_disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpf_jit_disasm.c b/tools/bpf/bpf_jit_disasm.c
index c8ae95804728..f748863e294c 100644
--- a/tools/bpf/bpf_jit_disasm.c
+++ b/tools/bpf/bpf_jit_disasm.c
@@ -303,7 +303,7 @@ int main(int argc, char **argv)
 		goto done;
 	}
 
-	ofd = open(ofile, O_WRONLY | O_CREAT | O_TRUNC, DEFFILEMODE);
+	ofd = open(ofile, O_WRONLY | O_CREAT | O_TRUNC, 0666);
 	if (ofd < 0) {
 		fprintf(stderr, "Could not open file %s for writing: ", ofile);
 		perror(NULL);
-- 
2.35.1

