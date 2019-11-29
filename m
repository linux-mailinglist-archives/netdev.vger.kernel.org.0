Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE3510DB8D
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 23:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfK2Wxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 17:53:30 -0500
Received: from www62.your-server.de ([213.133.104.62]:59386 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfK2Wx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 17:53:29 -0500
Received: from 29.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.29] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iaolN-0004kn-7u; Fri, 29 Nov 2019 23:29:21 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     peterz@infradead.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when prog is jited
Date:   Fri, 29 Nov 2019 23:29:11 +0100
Message-Id: <20191129222911.3710-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25648/Fri Nov 29 10:44:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the case where the interpreter is compiled out or when the prog is jited
it is completely unnecessary to set the BPF insn pages as read-only. In fact,
on frequent churn of BPF programs, it could lead to performance degradation of
the system over time since it would break the direct map down to 4k pages when
calling set_memory_ro() for the insn buffer on x86-64 / arm64 and there is no
reverse operation. Thus, avoid breaking up large pages for data maps, and only
limit this to the module range used by the JIT where it is necessary to set
the image read-only and executable.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/filter.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1b1e8b8f88da..a141cb07e76a 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -776,8 +776,12 @@ bpf_ctx_narrow_access_offset(u32 off, u32 size, u32 size_default)
 
 static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 {
-	set_vm_flush_reset_perms(fp);
-	set_memory_ro((unsigned long)fp, fp->pages);
+#ifndef CONFIG_BPF_JIT_ALWAYS_ON
+	if (!fp->jited) {
+		set_vm_flush_reset_perms(fp);
+		set_memory_ro((unsigned long)fp, fp->pages);
+	}
+#endif
 }
 
 static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
-- 
2.17.1

