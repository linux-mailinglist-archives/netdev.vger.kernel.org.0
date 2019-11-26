Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB4B109BEE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfKZKJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:55 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:41234 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfKZKJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:52 -0500
Received: by mail-pj1-f67.google.com with SMTP id gc1so8062977pjb.8;
        Tue, 26 Nov 2019 02:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vjhBcNZlvW0lMvmwhzAhIEHJGNVVbcL/eLdp//zF+fg=;
        b=hfC8Y0GlPj/uXQPu3A2bgAU/XKe+wQFyKu/9eLipQh61lukaue4hfFzl2ix7VClJjZ
         eqSqR/bDgLg7pVcqACj11DMCuCv0gwXL7+xHhsNh5NwgCfARRwd9PlFnobWiTzP9n90N
         Cad2Cf8SKecEWov8eZLUH408k+NDKtsw7byKo/MzSxyDe560t1bn8KA8Nw44LvCzF9vm
         USGyVrg3TbYALODisuOSe3Ve8xKDQg/MXtM9pDiIBi8Zs54oRtnKLNOLXzCEtbzwdMLf
         iPJ/eSOXkY0IEK3bI3VUv0V9mmMlT1OQKz3zMG/tabHlx5zqAMJowhWzs1hYAg70KyV9
         hpug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vjhBcNZlvW0lMvmwhzAhIEHJGNVVbcL/eLdp//zF+fg=;
        b=ANvlYWuBw57gqMne1aUVRRkDCxOm0XizLVOJAU2A/G+bqEN+lNP60fMKUFrZCUbCAZ
         /BgBYOHO6q59zyQA2Az0Q/ZN2MNWGi3/+afX7U+k1V5ZjJewFWFyxFiQ5uBwtBmI8MO1
         +MYkdqZVrsIYml3vA8YRtv47XGKD4BldMIeTEVjUlKzcEB+oDa46ABBHF4McNI5NGlZL
         +4Wx0UMqqxhOOZJTl/5+SAqSIlnwHKdYsYh5skM74cTNFckgADFMX/OHf/49DyMuigC6
         pk45g5fx4q0pnEN82Ri1C768JIKjRjmoaY0I1aIenmLEcUunKPsi8bSVbm863ZO+9Q9E
         W/7w==
X-Gm-Message-State: APjAAAXKO9bccptlr4DhPUNkDyCciRwtvlb7eAG8c+wGLLC0+/ckIPC0
        03e3U9o1KGtTX10oXQLUQkM=
X-Google-Smtp-Source: APXvYqzqJGhF3OWpPSeJBTojUttgXbH4VXymhLmS8Ad3+dmUNyuhjPT2iweDPV8n33fEjuC8F6+rjQ==
X-Received: by 2002:a17:90a:a612:: with SMTP id c18mr5725937pjq.49.1574762991777;
        Tue, 26 Nov 2019 02:09:51 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:51 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC net-next 18/18] virtio_net: restrict bpf helper calls from offloaded program
Date:   Tue, 26 Nov 2019 19:07:44 +0900
Message-Id: <20191126100744.5083-19-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we are offloading this program to the host, some of the helper
calls will not make sense. For example get_numa_node_id. Some helpers
can not be used because we don't handle them yet.

So let's allow a small set of helper calls for now.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/virtio_net.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 91a94b787c64..ab5be6b95bbd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2549,6 +2549,25 @@ static struct virtnet_bpf_map *virtnet_get_bpf_map(struct virtnet_info *vi,
 	return NULL;
 }
 
+static int virtnet_bpf_check_helper_call(struct bpf_insn *insn)
+{
+	switch (insn->imm) {
+	case BPF_FUNC_map_lookup_elem:
+	case BPF_FUNC_map_update_elem:
+	case BPF_FUNC_map_delete_elem:
+	case BPF_FUNC_ktime_get_ns:
+	case BPF_FUNC_get_prandom_u32:
+	case BPF_FUNC_csum_update:
+	case BPF_FUNC_xdp_adjust_head:
+	case BPF_FUNC_xdp_adjust_meta:
+	case BPF_FUNC_xdp_adjust_tail:
+	case BPF_FUNC_strtol:
+	case BPF_FUNC_strtoul:
+		return 0;
+	}
+	return -EOPNOTSUPP;
+}
+
 static int virtnet_bpf_verify_insn(struct bpf_verifier_env *env, int insn_idx,
 				   int prev_insn)
 {
@@ -2830,6 +2849,7 @@ static int virtnet_bpf_verifier_setup(struct bpf_prog *prog)
 	struct virtnet_bpf_bound_prog *state;
 	struct virtnet_bpf_map *virtnet_map;
 	struct bpf_map *map;
+	u8 opcode, class;
 	struct fd mapfd;
 	int i, err = 0;
 
@@ -2846,6 +2866,16 @@ static int virtnet_bpf_verifier_setup(struct bpf_prog *prog)
 	for (i = 0; i < state->len; i++) {
 		struct bpf_insn *insn = &state->insnsi[i];
 
+		opcode = BPF_OP(insn->code);
+		class = BPF_CLASS(insn->code);
+
+		if ((class == BPF_JMP || class == BPF_JMP32) &&
+		    opcode == BPF_CALL && insn->src_reg != BPF_PSEUDO_CALL) {
+			if (virtnet_bpf_check_helper_call(insn))
+				return -EOPNOTSUPP;
+			continue;
+		}
+
 		if (insn->code != (BPF_LD | BPF_IMM | BPF_DW))
 			continue;
 
-- 
2.20.1

