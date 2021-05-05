Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E4B374570
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbhEERFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237783AbhEERBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A58F7619D4;
        Wed,  5 May 2021 16:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232833;
        bh=BL17qdYNvhRbXc2x+eIW3WQXHQEb1ZqoUWBm5fXP+Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOQmoaUoHwMaaMs5MnyoCBOoILJC6G1rBTEVzuL8gPCnDNXW1lvbn1Ld417HWWEZN
         eXwFT0sXvYUwYcwx/CUlTuyZ7hPZ9vGOiYITYVz8N669XmSWnR8W+vScZKSJkSD0Kw
         myHj4KwBFTYFAEYGNjHnZ4iN36k1BRVEaLeMTUlmGt5mwF8p+R70yrwmpzETXODKtr
         oSWDUQ9WsZWGz7ISrOmR8xAbzgCy2UkVlSrsvEfsBfMYCrGpXdhHIZfG9vWWMVdycC
         C4s3O4DMieesMiMCwCeVzh1QglIM/0r1fTRfl6oxK00HlDcon4x1xM8scq3H1rS6/J
         r1IN/F0fczRgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 20/32] selftests: Set CC to clang in lib.mk if LLVM is set
Date:   Wed,  5 May 2021 12:39:52 -0400
Message-Id: <20210505164004.3463707-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index 0ef203ec59fd..a5d40653a921 100644
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
 
 ifeq (0,$(MAKELEVEL))
 OUTPUT := $(shell pwd)
-- 
2.30.2

