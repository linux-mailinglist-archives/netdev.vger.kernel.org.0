Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A966404D1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbiLBKgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiLBKgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:36:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676E9C4CDE;
        Fri,  2 Dec 2022 02:36:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 047A362245;
        Fri,  2 Dec 2022 10:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C92C433D6;
        Fri,  2 Dec 2022 10:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669977391;
        bh=WbzKkJ3I8UX3YvCZ/mmSVTcsBOZOo1tFhfKena2T4u8=;
        h=From:To:Cc:Subject:Date:From;
        b=NQUt8fnFYTodVrDYc3t+2RuYihYGjJKlCQCJYou1AhplRu+EReCEX/TpOa0QJ9KVe
         oKcJ/VL5nKryt2MsgvUCFlyPK/ATO9OOhKOea9dbRgcwsmZU0AwjU159xV+bL66JDe
         9mQ6TjGAntnj6Dqst9mhhfqJZXl9geH/s4I6hRBDH+z567B2B3kUuaF8nALQYOiJo3
         ESKuXmWWzJmcCbTH4QG1jydPwyjDcC9SP7mz09VEObloNG0pwkdutY49N6ZZPHstTO
         S4b9vedK4hgC47ZXhi72cuwe/+elKdwRA9L0gu/7bo8oAC3ahL0uBa+x1AUHHDhORx
         8HsWVaLyLkMWw==
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Brendan Jackman <jackmanb@google.com>
Subject: [PATCH bpf] bpf: Proper R0 zero-extension for BPF_CALL instructions
Date:   Fri,  2 Dec 2022 11:36:20 +0100
Message-Id: <20221202103620.1915679-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn@rivosinc.com>

A BPF call instruction can be, correctly, marked with zext_dst set to
true. An example of this can be found in the BPF selftests
progs/bpf_cubic.c:

  ...
  extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;

  __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
  {
          return tcp_reno_undo_cwnd(sk);
  }
  ...

which compiles to:
  0:  r1 = *(u64 *)(r1 + 0x0)
  1:  call -0x1
  2:  exit

The call will be marked as zext_dst set to true, and for some backends
(bpf_jit_needs_zext() returns true) expanded to:
  0:  r1 = *(u64 *)(r1 + 0x0)
  1:  call -0x1
  2:  w0 = w0
  3:  exit

The opt_subreg_zext_lo32_rnd_hi32() function which is responsible for
the zext patching, relies on insn_def_regno() to fetch the register to
zero-extend. However, this function does not handle call instructions
correctly, and opt_subreg_zext_lo32_rnd_hi32() fails the verification.

Make sure that R0 is correctly resolved for (BPF_JMP | BPF_CALL)
instructions.

Fixes: 83a2881903f3 ("bpf: Account for BPF_FETCH in insn_has_def32()")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
I'm not super happy about the additional special case -- first
cmpxchg, and now call. :-( A more elegant/generic solution is welcome!
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 264b3dc714cc..4f9660eafc72 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13386,6 +13386,9 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 		if (!bpf_jit_needs_zext() && !is_cmpxchg_insn(&insn))
 			continue;
 
+		if (insn.code == (BPF_JMP | BPF_CALL))
+			load_reg = BPF_REG_0;
+
 		if (WARN_ON(load_reg == -1)) {
 			verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
 			return -EFAULT;

base-commit: 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1
-- 
2.37.2

