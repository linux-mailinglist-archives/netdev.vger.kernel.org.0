Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58FA4A66A5
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242659AbiBAU5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:57:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58506 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241127AbiBAU5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:57:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36C1561756;
        Tue,  1 Feb 2022 20:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03855C340ED;
        Tue,  1 Feb 2022 20:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643749030;
        bh=QXd5q+7zbc3jx1Mm3Y3j3sEp6a7kDTxU4zMgI1M/2kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRveCCTFfiTH8rbyrskvMn7zEKvijdY2AWxXS8Oa0tcVHJl7jkEh4CftPLCtfL33H
         509+ho2uYbQttMIcdNcZ8pWKHdnBQc5NC+E1XXTcG3m1z+aQemyE7WRJ+4Y21LEeAh
         yJx3YcLpcmS+k+sHDkazhBTz80lCJ02l0a/eQ84VsRdVXzMtkblhyOVaNJG+EUaA+g
         Q8567O1/cFJVLH5kCu6alN86VTReQ2XCscOuy64FJR4I2tdUPiyOzjXea6JK4vQQ8T
         6RWZWTXDGkPQY2CP3EZ91XxgusRAwc8SQm0BHyemWHkrx+ChCTXnw0FuR+YEzeT9xe
         pNliHc4SyE9vw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH bpf-next 5/5] lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+
Date:   Tue,  1 Feb 2022 13:56:24 -0700
Message-Id: <20220201205624.652313-6-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
References: <20220201205624.652313-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 98cd6f521f10 ("Kconfig: allow explicit opt in to DWARF v5")
prevented CONFIG_DEBUG_INFO_DWARF5 from being selected when
CONFIG_DEBUG_INFO_BTF is enabled because pahole had issues with clang's
DWARF5 info. This was resolved by [1], which is in pahole v1.21.

Allow DEBUG_INFO_DWARF5 to be selected with DEBUG_INFO_BTF when using
pahole v1.21 or newer.

[1]: https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=7d8e829f636f47aba2e1b6eda57e74d8e31f733c

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index bd487d480902..1555da672275 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -296,7 +296,7 @@ config DEBUG_INFO_DWARF4
 config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
 	depends on !CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)))
-	depends on !DEBUG_INFO_BTF
+	depends on !DEBUG_INFO_BTF || PAHOLE_VERSION >= 121
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
 	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some
-- 
2.35.1

