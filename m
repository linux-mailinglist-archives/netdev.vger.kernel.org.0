Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEDE299881
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgJZVDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729508AbgJZVDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:03:42 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18EE72076D;
        Mon, 26 Oct 2020 21:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603746221;
        bh=OZnv8+PjDr0EFxf38kgdpGPhhv077FnV6tC8I5FI3EI=;
        h=From:To:Cc:Subject:Date:From;
        b=zPARCHdA9ue578l2WNv3HF5JQC66D+2G1czAaiUWHuljt43wVHu9Ag64RWvezDW5S
         96QhQmAsHFlZfscCcGj7/BKu6q28YWewp7nWSScDPjVBtaxMkKtwKLm6knI2CKKcAt
         nMNlKljZpXWPhqWmn7Ho1uzZPEqQmeLNMj50ILXk=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: suppress -Wcast-function-type warning
Date:   Mon, 26 Oct 2020 22:03:20 +0100
Message-Id: <20201026210332.3885166-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building with -Wextra shows lots of warnings in the bpf
code such as

kernel/bpf/verifier.c: In function ‘jit_subprogs’:
include/linux/filter.h:345:4: warning: cast between incompatible function types from ‘unsigned int (*)(const void *, const struct bpf_insn *)’ to ‘u64 (*)(u64,  u64,  u64,  u64,  u64)’ {aka ‘long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)’} [-Wcast-function-type]
  345 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
      |    ^
kernel/bpf/verifier.c:10706:16: note: in expansion of macro ‘BPF_CAST_CALL’
10706 |    insn->imm = BPF_CAST_CALL(func[subprog]->bpf_func) -
      |                ^~~~~~~~~~~~~

This appears to be intentional, so change the cast in a way that
suppresses the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/filter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1b62397bd124..20ba04583eaa 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -342,7 +342,7 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
 /* Function call */
 
 #define BPF_CAST_CALL(x)					\
-		((u64 (*)(u64, u64, u64, u64, u64))(x))
+		((u64 (*)(u64, u64, u64, u64, u64))(uintptr_t)(x))
 
 #define BPF_EMIT_CALL(FUNC)					\
 	((struct bpf_insn) {					\
-- 
2.27.0

