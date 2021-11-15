Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E4C4517E2
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349508AbhKOWtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353536AbhKOWjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 17:39:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E6B66324D;
        Mon, 15 Nov 2021 22:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637015665;
        bh=fKn8nl4xMokijsaqlH5e4iD92f9ISlML84Gu26Ft1MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0VtsbWimr4t6f1n7/8goqBcsnUNEHQd2HPJe6Svs056CYE0lVGbePphZJCMQbXSi
         3XwGW4GBYcBiZDST389+BTEKEaym+oTq1ZCN+5Pk360qvsBJ/DMEAqblJRQDV8d32r
         ia6FOsMUneEMeEByeGUsbp91f6QlZUh26opAI4dkOI6pF4N+nbl24C4zoLTbRBcCBj
         nS5pyyM/faEX6vqsRyvh4yebiNUgPdBCKooo5wz0rvA5h+ajiMK2aB+nrofSF/huf9
         MI6LrJUYXgmKa4QX0N4r0nmodvy/nZl00uaKmVIX/jmJOx+JYQaAxhzslI024H2Jpi
         9VLGICBCGqfJg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v18 bpf-next 09/23] bpf: introduce BPF_F_XDP_MB flag in prog_flags loading the ebpf program
Date:   Mon, 15 Nov 2021 23:33:03 +0100
Message-Id: <a529aaef48486deb1dac2ce0f058fdefea4c411a.1637013639.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce BPF_F_XDP_MB and the related field in bpf_prog_aux in order to
notify the driver the loaded program support xdp multi-buffer.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/bpf.h            | 1 +
 include/uapi/linux/bpf.h       | 5 +++++
 kernel/bpf/syscall.c           | 4 +++-
 tools/include/uapi/linux/bpf.h | 5 +++++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index df3410bff4b0..c1b5d3ec57e7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -869,6 +869,7 @@ struct bpf_prog_aux {
 	bool func_proto_unreliable;
 	bool sleepable;
 	bool tail_call_reachable;
+	bool xdp_mb;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6297eafdc40f..875ae723eb6b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1111,6 +1111,11 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* If BPF_F_XDP_MB is used in BPF_PROG_LOAD command, the loaded program
+ * fully support xdp multi-buffer
+ */
+#define BPF_F_XDP_MB		(1U << 5)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 50f96ea4452a..fbae37d5b329 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2202,7 +2202,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_ANY_ALIGNMENT |
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
-				 BPF_F_TEST_RND_HI32))
+				 BPF_F_TEST_RND_HI32 |
+				 BPF_F_XDP_MB))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2288,6 +2289,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->dst_prog = dst_prog;
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
+	prog->aux->xdp_mb = attr->prog_flags & BPF_F_XDP_MB;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6297eafdc40f..875ae723eb6b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1111,6 +1111,11 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* If BPF_F_XDP_MB is used in BPF_PROG_LOAD command, the loaded program
+ * fully support xdp multi-buffer
+ */
+#define BPF_F_XDP_MB		(1U << 5)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
-- 
2.31.1

