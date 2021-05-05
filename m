Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F75374255
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbhEEQqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235879AbhEEQpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 880A361436;
        Wed,  5 May 2021 16:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232554;
        bh=JghHOZ/QVxtM6PX80Rval0YJBlOJPo9HT4NMQynXkL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOzbbJgFrD2XQtM9ZKs3EQdLjbNHd+pdoEWQQM5JVONI9vh6JIBWhXYSRzNiWjqKv
         bfDyaLB9Kj5tX5uVkSdceYzJZpvevC5NiUgwqn97otxe6PD7kRMpQmhkRw9dlkb4Vq
         o2R6IXZ2+xVMcSYvZhXgmsyu47vSoRwVjK7e10mUrwJgI95IqwtG6IDY9/srtOhVpZ
         cpOepsbtMiXllfG6qNejlZvJQgax8eCwL/V0/e6YJlIH0zWt+NrZ5vgkRIzGM6EzZ+
         vbuUIu4u1m7ovIQT97fMq4u8NR6Y79gAdkdILzImg1gs73njMbeSCk9gNjKjiACsJ8
         u8S+w9LDZfOZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.11 069/104] selftests: Set CC to clang in lib.mk if LLVM is set
Date:   Wed,  5 May 2021 12:33:38 -0400
Message-Id: <20210505163413.3461611-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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

