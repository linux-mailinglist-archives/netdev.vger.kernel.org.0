Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F2E37442A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbhEEQzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235931AbhEEQwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE62B6197C;
        Wed,  5 May 2021 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232687;
        bh=JghHOZ/QVxtM6PX80Rval0YJBlOJPo9HT4NMQynXkL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/QRNR5bAxxv2GtvEDM2SRlWxn2oo1ioU5UnrIlpm5QEnL7R+tmdkoNB+5uFRkPAM
         YBBh9TiSyAao8ZS1oWmq9A3ry2S2L2QF+t/dDw+DCS4mArYEpI+LGqbxylCVmzPc6s
         S0YBvvp8vADAt47nNr4irXUmo2r1GynYU4z0PBYuVYXfTDJQNl+T8Mmr27yXavmWoi
         qgV3/jKP9XyIaKHFubPDugV8Ij718fKMm+H4Wi9/QcHi7sfAWCIaIgOjs3TXBb3Kv2
         DiZmH0M4rryTOHsygYcDyKSs7eYrgsuvuMgyotqPotK414WhxfAuckMHBHAn97dV9J
         heVIKivYImi7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 53/85] selftests: Set CC to clang in lib.mk if LLVM is set
Date:   Wed,  5 May 2021 12:36:16 -0400
Message-Id: <20210505163648.3462507-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index a5ce26d548e4..9a41d8bb9ff1 100644
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
     ifeq ($(OUTPUT),)
-- 
2.30.2

