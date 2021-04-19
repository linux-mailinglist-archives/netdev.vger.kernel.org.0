Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B4B364C79
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243394AbhDSUvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243022AbhDSUtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4124613D3;
        Mon, 19 Apr 2021 20:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865167;
        bh=HGKoeYccslyDMJAjKQum+MqK9xLjwCuOgVCaBy/LkXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSdMQ8/1RN3G6kEEL7XXmK/+dYhedTQoUm+SOwybdbJArBV6DUSMayZGgQTXaBa8z
         UWIXPA8b07uynngeZJxjjLEUo/3wT5w2FuyYc8r5nhtJO3BwWZH+U8dJKUYrdhM583
         ZrUvbX//sCM7HKi3JmzcCeTFMLti8DnURXUTWk6zX8dZE8PZ7Wxqc6foa6drRUhqhE
         hEVK6cS4hayk8yXWi2jiq8OHfds+VJXxn5O6VH/W9vsgMyyak4ZQpwHRzSQiXiMJWn
         Xgsk3zyuxw9FS95A+YACq9SmIe/TUBnKr2Vy9hi7hBDSx5aNL365WCspvX6/7+szJ2
         PtUwHGcWLTfmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 8/8] ia64: tools: remove duplicate definition of ia64_mf() on ia64
Date:   Mon, 19 Apr 2021 16:45:54 -0400
Message-Id: <20210419204554.7071-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204554.7071-1-sashal@kernel.org>
References: <20210419204554.7071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

[ Upstream commit f4bf09dc3aaa4b07cd15630f2023f68cb2668809 ]

The ia64_mf() macro defined in tools/arch/ia64/include/asm/barrier.h is
already defined in <asm/gcc_intrin.h> on ia64 which causes libbpf
failing to build:

    CC       /usr/src/linux/tools/bpf/bpftool//libbpf/staticobjs/libbpf.o
  In file included from /usr/src/linux/tools/include/asm/barrier.h:24,
                   from /usr/src/linux/tools/include/linux/ring_buffer.h:4,
                   from libbpf.c:37:
  /usr/src/linux/tools/include/asm/../../arch/ia64/include/asm/barrier.h:43: error: "ia64_mf" redefined [-Werror]
     43 | #define ia64_mf()       asm volatile ("mf" ::: "memory")
        |
  In file included from /usr/include/ia64-linux-gnu/asm/intrinsics.h:20,
                   from /usr/include/ia64-linux-gnu/asm/swab.h:11,
                   from /usr/include/linux/swab.h:8,
                   from /usr/include/linux/byteorder/little_endian.h:13,
                   from /usr/include/ia64-linux-gnu/asm/byteorder.h:5,
                   from /usr/src/linux/tools/include/uapi/linux/perf_event.h:20,
                   from libbpf.c:36:
  /usr/include/ia64-linux-gnu/asm/gcc_intrin.h:382: note: this is the location of the previous definition
    382 | #define ia64_mf() __asm__ volatile ("mf" ::: "memory")
        |
  cc1: all warnings being treated as errors

Thus, remove the definition from tools/arch/ia64/include/asm/barrier.h.

Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/ia64/include/asm/barrier.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/arch/ia64/include/asm/barrier.h b/tools/arch/ia64/include/asm/barrier.h
index e4422b4b634e..94ae4a333a35 100644
--- a/tools/arch/ia64/include/asm/barrier.h
+++ b/tools/arch/ia64/include/asm/barrier.h
@@ -38,9 +38,6 @@
  * sequential memory pages only.
  */
 
-/* XXX From arch/ia64/include/uapi/asm/gcc_intrin.h */
-#define ia64_mf()       asm volatile ("mf" ::: "memory")
-
 #define mb()		ia64_mf()
 #define rmb()		mb()
 #define wmb()		mb()
-- 
2.30.2

