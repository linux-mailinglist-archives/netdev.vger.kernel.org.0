Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4105692C1
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392215AbfGOOiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392109AbfGOOiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:38:54 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54A892086C;
        Mon, 15 Jul 2019 14:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201533;
        bh=gMYCMlIE9JhAmkeJS4THrWdhMpnJObwv71M4jlxwzgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnqwdXCsz3QjrP8XfVDrZcV90yUh4RGLO9ucpRh9FN0AQ3rpRjdhq/PhhHNFtSK4X
         Z7yv2UYelcREXzaCe87cRzsKE9tyzsh6nupRFol1v6DRQvr7cLAvYHu/+YFxzJSMbi
         A5fux5555aop6ituxdo3POfWxGIeG09WaEDAnljk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 36/73] bpf: silence warning messages in core
Date:   Mon, 15 Jul 2019 10:35:52 -0400
Message-Id: <20190715143629.10893-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715143629.10893-1-sashal@kernel.org>
References: <20190715143629.10893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valdis Klētnieks <valdis.kletnieks@vt.edu>

[ Upstream commit aee450cbe482a8c2f6fa5b05b178ef8b8ff107ca ]

Compiling kernel/bpf/core.c with W=1 causes a flood of warnings:

kernel/bpf/core.c:1198:65: warning: initialized field overwritten [-Woverride-init]
 1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
      |                                                                 ^~~~
kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
 1087 |  INSN_3(ALU, ADD,  X),   \
      |  ^~~~~~
kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
 1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
      |   ^~~~~~~~~~~~
kernel/bpf/core.c:1198:65: note: (near initialization for 'public_insntable[12]')
 1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
      |                                                                 ^~~~
kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
 1087 |  INSN_3(ALU, ADD,  X),   \
      |  ^~~~~~
kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
 1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
      |   ^~~~~~~~~~~~

98 copies of the above.

The attached patch silences the warnings, because we *know* we're overwriting
the default initializer. That leaves bpf/core.c with only 6 other warnings,
which become more visible in comparison.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index eed911d091da..5a590f22b4d4 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -1,4 +1,5 @@
 obj-y := core.o
+CFLAGS_core.o += $(call cc-disable-warning, override-init)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o
-- 
2.20.1

