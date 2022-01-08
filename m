Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9A2488363
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 12:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiAHLyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 06:54:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51608 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbiAHLyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 06:54:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D042B80860;
        Sat,  8 Jan 2022 11:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8BEC36AF4;
        Sat,  8 Jan 2022 11:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641642870;
        bh=xJ0IeXID4MPjyqsZ7TVX93lfiby1LCW+qSbYqkzLK5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQ+i7pErUnWpLIWPAmo6l13riNuAQ8xaQ8/ooAJL3ZnnJXvuBfOMedavgGy9xkGBw
         5QDdUrZk8viKkZ+tZ2/mtJ1l5QehyfAd5E8xwSs3wyEFZ9Pay7YBGkt1EurunjRx1b
         5dsUR4vHezysQplS1Pmlq4vmKeKbmoy7YB7golSwMmtiQcn01dHZ7Gc2GvdMr63FO2
         2Oq0CjHuYlezFIDubYDsXbQe9dkxWJmTxndHpGB/n1j9QH4kw3suMKKveWPs3+4+5Z
         SS549PrhU3xej/vikeEn2WMmAbhyagowjmXz2irvoS03t4oJUgqLIk3ZL2GkvQujk4
         we+fNqi1lJ0KQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v21 bpf-next 09/23] bpf: introduce BPF_F_XDP_MB flag in prog_flags loading the ebpf program
Date:   Sat,  8 Jan 2022 12:53:12 +0100
Message-Id: <716b5ceac6cc8ab900b3e25386ae0d45ebf23479.1641641663.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641641663.git.lorenzo@kernel.org>
References: <cover.1641641663.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce BPF_F_XDP_MB and the related field in bpf_prog_aux in order to
notify the driver the loaded program support xdp multi-buffer.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/bpf.h            | 1 +
 include/uapi/linux/bpf.h       | 5 +++++
 kernel/bpf/syscall.c           | 4 +++-
 tools/include/uapi/linux/bpf.h | 5 +++++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6e947cd91152..8e5ec0839138 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -934,6 +934,7 @@ struct bpf_prog_aux {
 	bool func_proto_unreliable;
 	bool sleepable;
 	bool tail_call_reachable;
+	bool xdp_mb;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..4a4f46ffd31d 100644
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
index fa4505f9b611..f2d870888ded 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2217,7 +2217,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_ANY_ALIGNMENT |
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
-				 BPF_F_TEST_RND_HI32))
+				 BPF_F_TEST_RND_HI32 |
+				 BPF_F_XDP_MB))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2303,6 +2304,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->dst_prog = dst_prog;
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
+	prog->aux->xdp_mb = attr->prog_flags & BPF_F_XDP_MB;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b0383d371b9a..4a4f46ffd31d 100644
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
2.33.1

