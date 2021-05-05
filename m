Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD51E37417C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbhEEQif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234718AbhEEQgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:36:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9636D6144A;
        Wed,  5 May 2021 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232395;
        bh=JghHOZ/QVxtM6PX80Rval0YJBlOJPo9HT4NMQynXkL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Um4iOvozxvAyqHY1FCd8UYseM/3VbCapDhesj6JyY9DwFzHowu5rh198Dr6elHZbk
         MA8LlI3BdrabVZYzunoN4HSV0+cRO0XMMrQ/VEflmQtVLsOLl+0EPHc9ThjunC93Mk
         dgzMec8de1NPEUSFoNuH920RzR5XSjWxvBkmOGQW1aLR5cygvI21YWaPI/V3nYg82b
         RFoI0hplkbc7zTsFt3ReiJF1A2DG58mJ7llEeOqZX98RvQr5JOkKJIqsZsmbJ/mJkk
         ueYSPtPjMqozjdebH83X+L8B7qHOsnREHqxsqe9IFc2Y/xoalzZyQe3S60Px8VdiJu
         JpwUC6q34vUGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.12 078/116] selftests: Set CC to clang in lib.mk if LLVM is set
Date:   Wed,  5 May 2021 12:30:46 -0400
Message-Id: <20210505163125.3460440-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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

