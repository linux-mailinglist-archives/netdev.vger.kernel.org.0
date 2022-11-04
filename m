Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E07618F0B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiKDD1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiKDD0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA6A280
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:52 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u63-20020a638542000000b004701a0aa835so1168788pgd.15
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zmaQvtYLsF9TKtg/u36OM0LhcEYMaV9waLpFb4MnS1Q=;
        b=EIrTEzpC8kZmxoComMULXSMr5kl6knLvkr/D1iegqzP0gJ4OnFl3H2XunCuW5lcAtv
         S27IgOFxZIaHbAgjmox69AMpTnhy0/qg3qTTdRproJE0WfLdAGVsv4iwsfgBKTg9g+1t
         ireXoSYPjWIpzxVMFYvL93yoiC+OaZxakfk/+/B9R4HAcpTSmXJXgr1iwjfEhr57xiQB
         7/JWMuDJ60+KbCNg/WYP+D58vKiQaQdm2ucoqos+Qy9l55qC/x6L4bHDav7lzYAH7GNR
         M+ZMh3MgD2bWZ29lKna28omiu/IPSbzriNJeiCuMi9mwIzVWmdutiXLn4+Bywq82ahB2
         kpug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zmaQvtYLsF9TKtg/u36OM0LhcEYMaV9waLpFb4MnS1Q=;
        b=qHxNbFlOr2OKSZ/GrZ4Gny+NRiw+inpo6Kv0LSVI0OBCg0pwiKKOm4xLWbpuIsd5xS
         nynoZB8NXgdClXV+4/Xmak6/6Rq2So4MA48eAxj4bONHi5i/Rnaq9yOTx0X8wM0aWJpD
         4dSNXhJ7mBQluLNkOo6L9fjxNCdfXaDA0IynrAf2nEALKIwP5QnqNd/8fc5yrCv6qHRB
         PtAuEH+wSHPPTBzIcaoZ3ETGNaPI7OfrBQrnimMjTJl0s/g+2cwOdfXJmgVYnh71ewa7
         rrhcluf6ceG+qxfKdwmI/uPL+Ng6LpGYewc9/Z8fxmPY7vHOy/JPZevdCHOipFeHw9RN
         BUdQ==
X-Gm-Message-State: ACrzQf0gET5dsmn86m4mFHPpsXiUrh5KPinF07GGU7A7EN0dOKXOCSDM
        DUwcu4hix5RlCfJFq2VUZW+Kzjk=
X-Google-Smtp-Source: AMsMyM7RzevfVCfpk+v3vHhvFphBW61C6xlIKEHis1h+1wQyUVW4C0FrBXHcsgtDMcGjz6TIwnaxeoQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:c40a:b0:186:ba20:76fa with SMTP id
 k10-20020a170902c40a00b00186ba2076famr33267866plk.55.1667532351618; Thu, 03
 Nov 2022 20:25:51 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:28 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-11-sdf@google.com>
Subject: [RFC bpf-next v2 10/14] ice: Support rx timestamp metadata for xdp
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

COMPILE-TESTED ONLY!

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  5 ++
 drivers/net/ethernet/intel/ice/ice_main.c |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c | 75 +++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index f88ee051e71c..c51a392d64a4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -925,6 +925,11 @@ int ice_open_internal(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
 
+struct bpf_insn;
+struct bpf_patch;
+void ice_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
+		      struct bpf_patch *patch);
+
 /**
  * ice_set_rdma_cap - enable RDMA support
  * @pf: PF struct
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1f27dc20b4f1..8ddc6851ef86 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9109,4 +9109,5 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
 	.ndo_get_devlink_port = ice_get_devlink_port,
+	.ndo_unroll_kfunc = ice_unroll_kfunc,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 1b6afa168501..e9b5e883753e 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -7,6 +7,7 @@
 #include <linux/netdevice.h>
 #include <linux/prefetch.h>
 #include <linux/bpf_trace.h>
+#include <linux/bpf_patch.h>
 #include <net/dsfield.h>
 #include <net/mpls.h>
 #include <net/xdp.h>
@@ -1098,8 +1099,80 @@ ice_is_non_eop(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
 
 struct ice_xdp_buff {
 	struct xdp_buff xdp;
+	struct ice_rx_ring *rx_ring;
+	union ice_32b_rx_flex_desc *rx_desc;
 };
 
+void ice_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
+		      struct bpf_patch *patch)
+{
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
+		return xdp_metadata_export_to_skb(prog, patch);
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
+		/* return true; */
+		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
+		bpf_patch_append(patch,
+			/* Loosely based on ice_ptp_rx_hwtstamp. */
+
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+
+			/* r5 = ((struct ice_xdp_buff *)r1)->rx_ring; */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_5, BPF_REG_1,
+				    offsetof(struct ice_xdp_buff, rx_ring)),
+			/* if (r5 == NULL) return; */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_5, 0, S16_MAX),
+
+			/* r5 = rx_ring->cached_phctime; */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_5, BPF_REG_5,
+				    offsetof(struct ice_rx_ring, cached_phctime)),
+			/* if (r5 == 0) return; */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_5, 0, S16_MAX),
+
+			/* r4 = ((struct ice_xdp_buff *)r1)->rx_desc; */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_4, BPF_REG_1,
+				    offsetof(struct ice_xdp_buff, rx_desc)),
+
+			/* r3 = rx_desc->wb.time_stamp_low; */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_4,
+				    offsetof(union ice_32b_rx_flex_desc, wb.time_stamp_low)),
+			/* r3 = r3 & ICE_PTP_TS_VALID; */
+			BPF_ALU64_IMM(BPF_AND, BPF_REG_3, 1),
+			/* if (r3 == 0) return; */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_3, 0, S16_MAX),
+
+			/* r3 = rx_desc->wb.flex_ts.ts_high; */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_4,
+				    offsetof(union ice_32b_rx_flex_desc, wb.flex_ts.ts_high)),
+
+			/* r5 == cached_phc_time; */
+			/* r3 == in_tstamp */
+
+			/* r4 = in_tstamp - pch_time_lo; (delta) */
+			BPF_MOV32_REG(BPF_REG_4, BPF_REG_3),
+			BPF_ALU32_REG(BPF_SUB, BPF_REG_4, BPF_REG_5),
+
+			/* if (delta <= U32_MAX / 2) { */
+			BPF_JMP_IMM(BPF_JGT, BPF_REG_4, U32_MAX / 2, 3),
+
+			/*	return cached_pch_time + delta */
+			BPF_MOV64_REG(BPF_REG_0, BPF_REG_4),
+			BPF_ALU32_REG(BPF_ADD, BPF_REG_0, BPF_REG_5),
+			BPF_JMP_A(4),
+
+			/* } else { */
+			/*	r4 = cached_phc_time_lo - in_tstamp; (delta) */
+			BPF_MOV64_REG(BPF_REG_4, BPF_REG_5),
+			BPF_ALU32_REG(BPF_SUB, BPF_REG_4, BPF_REG_3),
+
+			/*	return cached_pch_time - delta */
+			BPF_MOV64_REG(BPF_REG_0, BPF_REG_5),
+			BPF_ALU32_REG(BPF_SUB, BPF_REG_0, BPF_REG_4),
+			/* } */
+		);
+	}
+}
+
 /**
  * ice_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: Rx descriptor ring to transact packets on
@@ -1196,6 +1269,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		/* At larger PAGE_SIZE, frame_sz depend on len size */
 		ixbuf.xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
 #endif
+		ixbuf.rx_ring = rx_ring;
+		ixbuf.rx_desc = rx_desc;
 
 		if (!xdp_prog)
 			goto construct_skb;
-- 
2.38.1.431.g37b22c650d-goog

