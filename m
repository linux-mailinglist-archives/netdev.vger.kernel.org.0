Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1980E3745F4
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238737AbhEERJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238308AbhEERFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC81961404;
        Wed,  5 May 2021 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232941;
        bh=dlOQSC78x4g5c0BLYLlpldav7b47UGfJuU1ricOzpn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJglDrdB7/xBpW6hBGVmPh3/b9ZlhiqzUIW5XpeWqJeD+eEgIcExSyf/xvu6BTOb3
         N4RUoVme3aBgbxOHzWd4thRq16WglGCLNc1hkU2cg7YJKCC2yxyC4aMBu9xjHXz4Pp
         L/F6O4aN0JnT12PWQ3kycou6E4JsipWOrHekBEyHt/ECz0O8olqobeBykdW3XnEWXh
         tezuXQ9zAdRPKHjClFBiRVHYUfeMlDNdTtluV7TVRA0qT4SEpAOwZfkwLhymz3OToz
         vLGimcEIpdieVTeZqegrYy6oN9euma6izSkCTSUtG+XpGzllC7xkL+RIscjmd9AEc1
         HtY1EFBDZQL5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.4 13/19] selftests: Set CC to clang in lib.mk if LLVM is set
Date:   Wed,  5 May 2021 12:41:56 -0400
Message-Id: <20210505164203.3464510-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164203.3464510-1-sashal@kernel.org>
References: <20210505164203.3464510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 26e6dd1072763cd5696b75994c03982dde952ad9 ]

selftests/bpf/Makefile includes lib.mk. With the following command
  make -j60 LLVM=1 LLVM_IAS=1  <=== compile kernel
  make -j60 -C tools/testing/selftests/bpf LLVM=1 LLVM_IAS=1 V=1
some files are still compiled with gcc. This patch
fixed lib.mk issue which sets CC to gcc in all cases.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210413153413.3027426-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 50a93f5f13d6..d8fa6c72b7ca 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -1,6 +1,10 @@
 # This mimics the top-level Makefile. We do it explicitly here so that this
 # Makefile can operate with or without the kbuild infrastructure.
+ifneq ($(LLVM),)
+CC := clang
+else
 CC := $(CROSS_COMPILE)gcc
+endif
 
 define RUN_TESTS
 	@for TEST in $(TEST_PROGS); do \
-- 
2.30.2

