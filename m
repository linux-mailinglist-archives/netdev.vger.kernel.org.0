Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7894EF01D
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347256AbiDAOcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347323AbiDAObt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:31:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830F28CA9C;
        Fri,  1 Apr 2022 07:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0678B824FD;
        Fri,  1 Apr 2022 14:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFF6C2BBE4;
        Fri,  1 Apr 2022 14:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823273;
        bh=wdk/Jscln/9rXFA/A3zK1dslfarO0A7QtJ3dSbvKtIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P01fwDDbnmA8t5wFKSGCnk3evLWzRCK6NPmHYhlWPms4BeM9NcugfCPXWYoakgfwA
         //LLI+LjIFu8hTcc2IBNjq5WMepEXOPfll4vdNC9ng6OsgvTfZr7tZiGC/BN5Nbjug
         sDubxtyPAvJJxmBeoRR3cc6e6Hn9v/erQ9UQat4e6XbU70i0R+XyiHGJVbxsw8VIf+
         Bb4gZ4CtdwA35dFkGxRfeC1Su2H84J8hfZL1Q85wmfZAUd2J5AQvfcyEjBpAEW+j1E
         yh3u6W0OSGPxN8l2T5JSBsYdQqOE6AU2oKO0l3oC3pm6hls6bplK6y4w2SFr5yo0Fb
         iTIXbqbKnZ5dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Delyan Kratunov <delyank@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.17 043/149] libbpf: Fix build issue with llvm-readelf
Date:   Fri,  1 Apr 2022 10:23:50 -0400
Message-Id: <20220401142536.1948161-43-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 0908a66ad1124c1634c33847ac662106f7f2c198 ]

There are cases where clang compiler is packaged in a way
readelf is a symbolic link to llvm-readelf. In such cases,
llvm-readelf will be used instead of default binutils readelf,
and the following error will appear during libbpf build:

  Warning: Num of global symbols in
   /home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/sharedobjs/libbpf-in.o (367)
   does NOT match with num of versioned symbols in
   /home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/libbpf.so libbpf.map (383).
   Please make sure all LIBBPF_API symbols are versioned in libbpf.map.
  --- /home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/libbpf_global_syms.tmp ...
  +++ /home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/libbpf_versioned_syms.tmp ...
  @@ -324,6 +324,22 @@
   btf__str_by_offset
   btf__type_by_id
   btf__type_cnt
  +LIBBPF_0.0.1
  +LIBBPF_0.0.2
  +LIBBPF_0.0.3
  +LIBBPF_0.0.4
  +LIBBPF_0.0.5
  +LIBBPF_0.0.6
  +LIBBPF_0.0.7
  +LIBBPF_0.0.8
  +LIBBPF_0.0.9
  +LIBBPF_0.1.0
  +LIBBPF_0.2.0
  +LIBBPF_0.3.0
  +LIBBPF_0.4.0
  +LIBBPF_0.5.0
  +LIBBPF_0.6.0
  +LIBBPF_0.7.0
   libbpf_attach_type_by_name
   libbpf_find_kernel_btf
   libbpf_find_vmlinux_btf_id
  make[2]: *** [Makefile:184: check_abi] Error 1
  make[1]: *** [Makefile:140: all] Error 2

The above failure is due to different printouts for some ABS
versioned symbols. For example, with the same libbpf.so,
  $ /bin/readelf --dyn-syms --wide tools/lib/bpf/libbpf.so | grep "LIBBPF" | grep ABS
     134: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.5.0
     202: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.6.0
     ...
  $ /opt/llvm/bin/readelf --dyn-syms --wide tools/lib/bpf/libbpf.so | grep "LIBBPF" | grep ABS
     134: 0000000000000000     0 OBJECT  GLOBAL DEFAULT   ABS LIBBPF_0.5.0@@LIBBPF_0.5.0
     202: 0000000000000000     0 OBJECT  GLOBAL DEFAULT   ABS LIBBPF_0.6.0@@LIBBPF_0.6.0
     ...
The binutils readelf doesn't print out the symbol LIBBPF_* version and llvm-readelf does.
Such a difference caused libbpf build failure with llvm-readelf.

The proposed fix filters out all ABS symbols as they are not part of the comparison.
This works for both binutils readelf and llvm-readelf.

Reported-by: Delyan Kratunov <delyank@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220204214355.502108-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index f947b61b2107..b8b37fe76006 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -131,7 +131,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
 			      sed 's/\[.*\]//' | \
-			      awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
+			      awk '/GLOBAL/ && /DEFAULT/ && !/UND|ABS/ {print $$NF}' | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
 CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
@@ -194,7 +194,7 @@ check_abi: $(OUTPUT)libbpf.so $(VERSION_SCRIPT)
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf --dyn-syms --wide $(OUTPUT)libbpf.so |		 \
 		    sed 's/\[.*\]//' |					 \
-		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND|ABS/ {print $$NF}'|  \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
 		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
 		diff -u $(OUTPUT)libbpf_global_syms.tmp			 \
-- 
2.34.1

