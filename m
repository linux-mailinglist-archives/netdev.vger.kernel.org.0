Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0154B8C960
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfHNCL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbfHNCL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2092420843;
        Wed, 14 Aug 2019 02:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748718;
        bh=zcslmXbDP2/EosiPFy6ZMtnFs4fJr2gbROyEuLHFzO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uss+oxM/u2+X2i4+E5OIsaIodUnvgyN+qf8OTGbfLzmq+pZ4hdGb7wopWvSwgLwco
         CffXjvAicp4+l3MTDIcJwd5jJaSvAjHB6AeT7d/JPiyoWdqmmQft72e0qZw0+ohSaV
         XCVE9oyCN2RBUFALpTUsJ6IABXVxzHtCgrbKRttQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 035/123] selftests/bpf: add another gso_segs access
Date:   Tue, 13 Aug 2019 22:09:19 -0400
Message-Id: <20190814021047.14828-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit be69483bf4f3abaaca5d5ba460dbb50239463552 ]

Use BPF_REG_1 for source and destination of gso_segs read,
to exercise "bpf: fix access to skb_shared_info->gso_segs" fix.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/verifier/ctx_skb.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/ctx_skb.c b/tools/testing/selftests/bpf/verifier/ctx_skb.c
index b0fda2877119c..d438193804b21 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_skb.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_skb.c
@@ -974,6 +974,17 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
 },
+{
+	"read gso_segs from CGROUP_SKB",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1,
+		    offsetof(struct __sk_buff, gso_segs)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
 {
 	"write gso_segs from CGROUP_SKB",
 	.insns = {
-- 
2.20.1

