Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E0C42F1D4
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhJONMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239325AbhJONML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECD5B6115C;
        Fri, 15 Oct 2021 13:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634303405;
        bh=R8RyBi0uePgkvvXeqZrMO8W2ppBK4FFT2+r3rhbar/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U699sXqIsfzge8jlSDsGGNzmRYaB1vn66hx+eIb2htdRr77vnGD6IbeHQGetwNBQP
         8HuZNJdY22RxP9t5s68novtPigC28l+kuPTQcolkApOjwFdkxfuhIcXHg1WCSZOlEF
         a1+ZXXPczkaxNhV0yu+7SX8RpbjNV7xXG8puhH4AvOqpY1fdu2/z/xTVceA2jc+sSR
         sJPPK0YlgneKtC0aZSkOrGdJuAbAHXNqLUe9dbE8+eSC4NMvggX7DL5BF8J87m2hBj
         VPwKrdNMSwxz7+Zz5fcIBNWX7V2U+cEQuRhHPds8RMXNkNVIeZ2FUYQYlqDnm16/N3
         8xZT9ikwXD7iw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v16 bpf-next 09/20] bpf: introduce BPF_F_XDP_MB flag in prog_flags loading the ebpf program
Date:   Fri, 15 Oct 2021 15:08:46 +0200
Message-Id: <0a48666cfb23d1ceef8d529506e7ad2da90079de.1634301224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634301224.git.lorenzo@kernel.org>
References: <cover.1634301224.git.lorenzo@kernel.org>
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
index d604c8251d88..1d199501031e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -868,6 +868,7 @@ struct bpf_prog_aux {
 	bool func_proto_unreliable;
 	bool sleepable;
 	bool tail_call_reachable;
+	bool xdp_mb;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..87c10a90c243 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1110,6 +1110,11 @@ enum bpf_link_type {
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
index 4e50c0bfdb7d..48e4eda2abd5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2174,7 +2174,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_ANY_ALIGNMENT |
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
-				 BPF_F_TEST_RND_HI32))
+				 BPF_F_TEST_RND_HI32 |
+				 BPF_F_XDP_MB))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2260,6 +2261,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->dst_prog = dst_prog;
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
+	prog->aux->xdp_mb = attr->prog_flags & BPF_F_XDP_MB;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6fc59d61937a..87c10a90c243 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1110,6 +1110,11 @@ enum bpf_link_type {
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

