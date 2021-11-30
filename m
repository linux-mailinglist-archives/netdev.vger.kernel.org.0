Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4F9463380
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhK3L55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:57:57 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58744 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhK3L5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:57:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A46DCCE189B;
        Tue, 30 Nov 2021 11:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068FEC53FD2;
        Tue, 30 Nov 2021 11:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273268;
        bh=tGF61zKzsJAmGIzu8WAVdTjf/JcZYu53bNTYV4vdUY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3C/6JvB+wQeNJ5dVpllTDuJ9SA4LuIibGRYwlvXfEnjL4CZLcMhURcVfOc9mnVMK
         lca05GYIh+D6FFzclnRBS1nwtZelNm26KdEfc7nONCvMJQwy3CK+T0EG8VMDNPQTK8
         428ssPT8iTdgegTKii9AZkMBLWB5GW0D+qrqk5yKrp4ond70XZsV6QecQj6cXnCh6i
         tWGuh+UQCozm6B4SwuQVEUnV7KBBwTeTAbSCg9KL85ARankgrj9gFgsxeruPPGaX+L
         T1SwRswxPsOieRH/+PPyvthUCr9p6dG+rnBkzZ5oPm/0K/A7sZ0xGo72UCslfK5B0+
         uk1szg7FCOJ9A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 09/23] bpf: introduce BPF_F_XDP_MB flag in prog_flags loading the ebpf program
Date:   Tue, 30 Nov 2021 12:52:53 +0100
Message-Id: <910d9f4270cea155f6283a99b697f89cbc39009f.1638272238.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
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
index cc7a0c36e7df..25f383f3ebc5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -875,6 +875,7 @@ struct bpf_prog_aux {
 	bool func_proto_unreliable;
 	bool sleepable;
 	bool tail_call_reachable;
+	bool xdp_mb;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a69e4b04ffeb..be07a2f65e3f 100644
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
index a69e4b04ffeb..be07a2f65e3f 100644
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

