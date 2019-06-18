Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4454A15E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfFRNBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:01:06 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35885 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbfFRNBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:01:04 -0400
Received: by mail-lf1-f65.google.com with SMTP id q26so9224131lfc.3
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9AAPVRZAanCU7EFel9aSQ8UNAIvo6q29Z01mKf7ZdMg=;
        b=Bt3P2ZEhbuJFRkzllLb6z6rPZPNsaJi8MogpyIoyemQi+u25M5sfH6mXM4BCYnedNx
         6/3QqvBqRv69ihE2Y/pYmGTg5adkE2mPhkRhdM5bA32WeY5D1ifzKk2mpUs+feMfFFM0
         1gsNUaDu5U5ZvAPdAG2PXj+4bi3rc99TVYNzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9AAPVRZAanCU7EFel9aSQ8UNAIvo6q29Z01mKf7ZdMg=;
        b=VbjFam2mWoRvxttTzFoxhULDme5iouv7aEgbDG9+rqhDzCw7if/2N4nSqV/lZgHoc5
         blHLEiBfpUQEgnKVgeaFOQkFoZy5Sgl77/imtbfn8krzEXVewscQNiI/hpyq8L0OHN6s
         B12GJmsKKB0gBUtNPhWNPjLajVZr23TB0ovVDc9nD/ytm0ZSlUMx166wxE4PhQv5WfWk
         w6XpwZDAZLaoKVkYIJeH8ApyN7TExYGi3Z+VysGfLJBh6/HgePIntvh3H8Ny0Ivq0edp
         QGzlrOWiG10NT7O/qzWQWo7orJhb8sXyYq3TpHHVvEpqg+1v/H9f2c1JhwQ5IJpg+uJ3
         zGmw==
X-Gm-Message-State: APjAAAWp9xqQ23mAFb79TthDOgYjtUNlK5WvODCPEZdFmMTK9qpVKekK
        S1smI8M0ngeILtz39aoeXGhCHAaDjW16Dg==
X-Google-Smtp-Source: APXvYqwJqfhPsx5wJi3dL8C0H5y440ARKwjVUeuqUW5U2A8+ecFr7kPw18xc7XFn1EuHvtsRkgbgAg==
X-Received: by 2002:ac2:4185:: with SMTP id z5mr9093602lfh.162.1560862861474;
        Tue, 18 Jun 2019 06:01:01 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id u21sm2621533lju.2.2019.06.18.06.01.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:01:00 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com
Subject: [RFC bpf-next 7/7] bpf: Add verifier tests for inet_lookup context access
Date:   Tue, 18 Jun 2019 15:00:50 +0200
Message-Id: <20190618130050.8344-8-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618130050.8344-1-jakub@cloudflare.com>
References: <20190618130050.8344-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exercise verifier access checks for bpf_inet_lookup context object fields.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/verifier/ctx_inet_lookup.c  | 511 ++++++++++++++++++
 1 file changed, 511 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_inet_lookup.c

diff --git a/tools/testing/selftests/bpf/verifier/ctx_inet_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_inet_lookup.c
new file mode 100644
index 000000000000..b4555fb03e17
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/ctx_inet_lookup.c
@@ -0,0 +1,511 @@
+{
+	"valid 1,2,4-byte read bpf_inet_lookup remote_ip4",
+	.insns = {
+		/* 4-byte read */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip4)),
+		/* 2-byte read */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip4)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip4) + 2),
+		/* 1-byte read */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip4)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip4) + 3),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte read bpf_inet_lookup remote_ip4",
+	.insns = {
+		/* 8-byte read */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte write bpf_inet_lookup remote_ip4",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x7f000001U),
+		/* 4-byte write */
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 4-byte write bpf_inet_lookup remote_ip4",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x7f000001U),
+		/* 4-byte write */
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 2-byte write bpf_inet_lookup remote_ip4",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x7f000001U),
+		/* 2-byte write */
+		BPF_STX_MEM(BPF_H, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 1-byte write bpf_inet_lookup remote_ip4",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x7f000001U),
+		/* 1-byte write */
+		BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"valid 1,2,4-byte read bpf_inet_lookup local_ip4",
+	.insns = {
+		/* 4-byte read */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip4)),
+		/* 2-byte read */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip4)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip4) + 2),
+		/* 1-byte read */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip4)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip4) + 3),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte read bpf_inet_lookup local_ip4",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"valid 4-byte write bpf_inet_lookup local_ip4",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x7f000001U),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte write bpf_inet_lookup local_ip4",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x7f000001U),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 2-byte write bpf_inet_lookup local_ip4",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x7f000001U),
+		BPF_STX_MEM(BPF_H, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 1-byte write bpf_inet_lookup local_ip4",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x7f000001U),
+		BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_ip4)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"valid 1,2,4-byte read bpf_inet_lookup remote_ip6",
+	.insns = {
+		/* 4-byte read */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[0])),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[3])),
+		/* 2-byte read */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[0])),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup,
+				     remote_ip6[3]) + 2),
+		/* 1-byte read */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[0])),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup,
+				     remote_ip6[3]) + 3),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte read bpf_inet_lookup remote_ip6",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte write bpf_inet_lookup remote_ip6",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x00000001U),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 4-byte write bpf_inet_lookup remote_ip6",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x00000001U),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 2-byte write bpf_inet_lookup remote_ip6",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x00000001U),
+		BPF_STX_MEM(BPF_H, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 1-byte write bpf_inet_lookup remote_ip6",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x00000001U),
+		BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"valid 1,2,4-byte read bpf_inet_lookup local_ip6",
+	.insns = {
+		/* 4-byte read */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip6[0])),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip6[3])),
+		/* 2-byte read */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip6[0])),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip6[3]) + 2),
+		/* 1-byte read */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip6[0])),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip6[3]) + 3),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte read bpf_inet_lookup local_ip6",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte write bpf_inet_lookup local_ip6",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x00000001U),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"valid 4-byte write bpf_inet_lookup local_ip6",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x00000001U),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 2-byte write bpf_inet_lookup local_ip6",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x00000001U),
+		BPF_STX_MEM(BPF_H, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 1-byte write bpf_inet_lookup local_ip6",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0x00000001U),
+		BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_ip6[0])),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"valid 4-byte read bpf_inet_lookup remote_port",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_port)),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte read bpf_inet_lookup remote_port",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 2-byte read bpf_inet_lookup remote_port",
+	.insns = {
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 1-byte read bpf_inet_lookup remote_port",
+	.insns = {
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, remote_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte write bpf_inet_lookup remote_port",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 1234),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 4-byte write bpf_inet_lookup remote_port",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 1234),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 2-byte write bpf_inet_lookup remote_port",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 1234),
+		BPF_STX_MEM(BPF_H, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 1-byte write bpf_inet_lookup remote_port",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 1234),
+		BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, remote_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"valid 4-byte read bpf_inet_lookup local_port",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_port)),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte read bpf_inet_lookup local_port",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 2-byte read bpf_inet_lookup local_port",
+	.insns = {
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 1-byte read bpf_inet_lookup local_port",
+	.insns = {
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_inet_lookup, local_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"valid 4-byte write bpf_inet_lookup local_port",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 1234),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_port)),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 8-byte write bpf_inet_lookup local_port",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 1234),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 2-byte write bpf_inet_lookup local_port",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 1234),
+		BPF_STX_MEM(BPF_H, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
+{
+	"invalid 1-byte write bpf_inet_lookup local_port",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 1234),
+		BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+			    offsetof(struct bpf_inet_lookup, local_port)),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_INET_LOOKUP,
+},
-- 
2.20.1

