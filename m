Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA67490F7F
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239098AbiAQRaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238857AbiAQR3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:29:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A102C06173E;
        Mon, 17 Jan 2022 09:29:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AD7760B50;
        Mon, 17 Jan 2022 17:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FEFC36AF2;
        Mon, 17 Jan 2022 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440590;
        bh=b+ziL6p9dYaFKif8rxc45qb7LEI9mnp78I4qZlE/k44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyZP/AMlCC53tfinmlbPxBKlrqRv26M08QmE5N5QObjSRcFIDVoonc2eTIg8bHfWz
         UWHE2GfaBNP6C5gaIUvLLCUrCn51tk/Ov/rr+SkgifBi0aiGifcWRVsfnIYUMPExJ4
         mqOHb3GmQzIp7QxryFQ32tXpGx2RB0W/LJHfFyxy52yA+5vOXSLxmeQEIkWTyyYBX4
         6uofr7punPS8WbKbIdlkCPrFK+tW009Uuo0h0+66rogH5NcSxqxQxK3ZIFgletFkX6
         yT4anwU0E72vC8TScEI42BBnrSJrYswYLmHyAA1DwPBaZmVHpUlY8gX7vDIDDpoO/N
         UgVjwlZDoFZfA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 09/23] bpf: introduce BPF_F_XDP_HAS_FRAGS flag in prog_flags loading the ebpf program
Date:   Mon, 17 Jan 2022 18:28:21 +0100
Message-Id: <e9873972c3334048144efe070a3f73424f5d9b77.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce BPF_F_XDP_HAS_FRAGS and the related field in bpf_prog_aux
in order to notify the driver the loaded program support xdp
multi-frags.

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
index 6e947cd91152..909fa29981fd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -934,6 +934,7 @@ struct bpf_prog_aux {
 	bool func_proto_unreliable;
 	bool sleepable;
 	bool tail_call_reachable;
+	bool xdp_has_frags;
 	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..35e95d56f858 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1111,6 +1111,11 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* If BPF_F_XDP_HAS_FRAGS is used in BPF_PROG_LOAD command, the loaded program
+ * fully support xdp multi-frags.
+ */
+#define BPF_F_XDP_HAS_FRAGS	(1U << 5)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fa4505f9b611..e3c9deb7e25f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2217,7 +2217,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_ANY_ALIGNMENT |
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
-				 BPF_F_TEST_RND_HI32))
+				 BPF_F_TEST_RND_HI32 |
+				 BPF_F_XDP_HAS_FRAGS))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2303,6 +2304,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->dst_prog = dst_prog;
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
+	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b0383d371b9a..35e95d56f858 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1111,6 +1111,11 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* If BPF_F_XDP_HAS_FRAGS is used in BPF_PROG_LOAD command, the loaded program
+ * fully support xdp multi-frags.
+ */
+#define BPF_F_XDP_HAS_FRAGS	(1U << 5)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
-- 
2.34.1

