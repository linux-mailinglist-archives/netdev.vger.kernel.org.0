Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90FA195A75
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgC0P7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:59:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:50956 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbgC0P7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 11:59:17 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHrO7-0007nm-6w; Fri, 27 Mar 2020 16:59:15 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     m@lambda.lt, joe@wand.net.nz, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 7/7] bpf: add selftest cases for ctx_or_null argument type
Date:   Fri, 27 Mar 2020 16:58:56 +0100
Message-Id: <c74758d07b1b678036465ef7f068a49e9efd3548.1585323121.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1585323121.git.daniel@iogearbox.net>
References: <cover.1585323121.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add various tests to make sure the verifier keeps catching them:

  # ./test_verifier
  [...]
  #230/p pass ctx or null check, 1: ctx OK
  #231/p pass ctx or null check, 2: null OK
  #232/p pass ctx or null check, 3: 1 OK
  #233/p pass ctx or null check, 4: ctx - const OK
  #234/p pass ctx or null check, 5: null (connect) OK
  #235/p pass ctx or null check, 6: null (bind) OK
  #236/p pass ctx or null check, 7: ctx (bind) OK
  #237/p pass ctx or null check, 8: null (bind) OK
  [...]
  Summary: 1595 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/testing/selftests/bpf/verifier/ctx.c | 105 +++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/ctx.c b/tools/testing/selftests/bpf/verifier/ctx.c
index 92762c08f5e3..93d6b1641481 100644
--- a/tools/testing/selftests/bpf/verifier/ctx.c
+++ b/tools/testing/selftests/bpf/verifier/ctx.c
@@ -91,3 +91,108 @@
 	.result = REJECT,
 	.errstr = "variable ctx access var_off=(0x0; 0x4)",
 },
+{
+	"pass ctx or null check, 1: ctx",
+	.insns = {
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_netns_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG,
+	.result = ACCEPT,
+},
+{
+	"pass ctx or null check, 2: null",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_netns_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG,
+	.result = ACCEPT,
+},
+{
+	"pass ctx or null check, 3: 1",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 1),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_netns_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG,
+	.result = REJECT,
+	.errstr = "R1 type=inv expected=ctx",
+},
+{
+	"pass ctx or null check, 4: ctx - const",
+	.insns = {
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -612),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_netns_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG,
+	.result = REJECT,
+	.errstr = "dereference of modified ctx ptr",
+},
+{
+	"pass ctx or null check, 5: null (connect)",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_netns_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	.expected_attach_type = BPF_CGROUP_INET4_CONNECT,
+	.result = ACCEPT,
+},
+{
+	"pass ctx or null check, 6: null (bind)",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_netns_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK,
+	.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+	.result = ACCEPT,
+},
+{
+	"pass ctx or null check, 7: ctx (bind)",
+	.insns = {
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_socket_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK,
+	.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+	.result = ACCEPT,
+},
+{
+	"pass ctx or null check, 8: null (bind)",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_socket_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK,
+	.expected_attach_type = BPF_CGROUP_INET4_POST_BIND,
+	.result = REJECT,
+	.errstr = "R1 type=inv expected=ctx",
+},
-- 
2.21.0

