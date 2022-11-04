Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02377618F10
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKDD1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiKDD0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:35 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E56C25
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:59 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c10-20020a17090aa60a00b00212e91df6acso1696744pjq.5
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uQ6JlR5MuJ+4TNT/9F0XUiWRUVg6v0604de78bhCMH0=;
        b=e95nTNyu1/zqYk594Wc2lEyKkIdbtwOKjh9caLsaCAaRuH9Dc6FetzenTjkT1Ud+2m
         7hetwgd/CHvIWjr5pMDXS848OuGsVBvWeSi3si8WVYmY9BYbAyA/06KZer6peqFwMwwC
         yv0AKBrq+xOi3xXMGygdVXCudkOUZnIHThJ3B0/XuV78jWQpnWBT+m/dc7OYF8rdShgU
         MmcDnsYE8ToJS7DPQ935kHR7rlO+93sKESXrHOehd7hDxkHqPmua2TFOQ0rxAQ7oaqH+
         UF19V1roe/y+TgOUwdX9vzD2DfoU9BMDAEfyLjxXA9vK1ik07qeIFXjoj+kH1a0ir1Uz
         vClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uQ6JlR5MuJ+4TNT/9F0XUiWRUVg6v0604de78bhCMH0=;
        b=oHBtYBJlooIIWMEMGlWMdZJvQ7osavUbU1vJ/gAhqniInpMqiYyNmmTbWuAn2No8km
         gY4QDrJVKs+U5ouq8HBM76yarPi0qFilIu6CM+SopIvhdZoTJJSsqJB6qXjRRw6A6BVr
         c92mvKArnuJfhPuWFF9bbtYEc3zj8kyo+iPZnG97NZv7b7f2/ELrOtBq27S5fcBIaK+3
         I5Yt/x232I9g729/fGMIEsOzxFU9wswAdnMKtHaNXJe5U6dT5uFsLz2tMOSD6IxlLxEP
         cJuOWggA9JFTKSmdVbiL8jKHT8IXHZkOnoISvnlygZC21xxn7tdrmo/ojbzpHSXtgc0f
         Mb8w==
X-Gm-Message-State: ACrzQf2uDr3YRvFYxozvpvYADWnfTwXbepAU7sbu8E2/K8L3Qjo0G5hJ
        pbWx/1raJOl9RvM7NEE+FyG+u7Y=
X-Google-Smtp-Source: AMsMyM5KfIChbdj/RzkOJbzKK0JWi/IItAP2XkKFHFa0ViMAPEtrpdpDFmxFkThxRo8fGBWfxcRTA4A=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:2496:b0:213:e03d:bc30 with SMTP id
 nt22-20020a17090b249600b00213e03dbc30mr25753722pjb.109.1667532359345; Thu, 03
 Nov 2022 20:25:59 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:32 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-15-sdf@google.com>
Subject: [RFC bpf-next v2 14/14] bnxt: Support rx timestamp metadata for xdp
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 55 +++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b2e0607a6400..968266844f49 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -37,6 +37,7 @@
 #include <linux/if_bridge.h>
 #include <linux/rtc.h>
 #include <linux/bpf.h>
+#include <linux/bpf_patch.h>
 #include <net/gro.h>
 #include <net/ip.h>
 #include <net/tcp.h>
@@ -1791,8 +1792,53 @@ static void bnxt_deliver_skb(struct bnxt *bp, struct bnxt_napi *bnapi,
 
 struct bnxt_xdp_buff {
 	struct xdp_buff xdp;
+	struct rx_cmp_ext *rxcmp1;
+	struct bnxt *bp;
+	u64 r0;
 };
 
+struct bnxt_xdp_buff *bnxt_xdp_rx_timestamp(struct bnxt_xdp_buff *ctx)
+{
+	struct bnxt_ptp_cfg *ptp;
+	u32 cmpl_ts;
+	u64 ns, ts;
+
+	if (!ctx->rxcmp1) {
+		ctx->r0 = 0;
+		return ctx;
+	}
+
+	cmpl_ts = le32_to_cpu(ctx->rxcmp1->rx_cmp_timestamp);
+	if (bnxt_get_rx_ts_p5(ctx->bp, &ts, cmpl_ts) < 0) {
+		ctx->r0 = 0;
+		return ctx;
+	}
+
+	ptp = ctx->bp->ptp_cfg;
+
+	spin_lock_bh(&ptp->ptp_lock);
+	ns = timecounter_cyc2time(&ptp->tc, ts);
+	spin_unlock_bh(&ptp->ptp_lock);
+
+	ctx->r0 = (u64)ns_to_ktime(ns);
+	return ctx;
+}
+
+void bnxt_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
+		       struct bpf_patch *patch)
+{
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
+		return xdp_metadata_export_to_skb(prog, patch);
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
+		/* return true; */
+		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
+		xdp_kfunc_call_preserving_r1(patch,
+					     offsetof(struct bnxt_xdp_buff, r0),
+					     bnxt_xdp_rx_timestamp);
+	}
+}
+
 /* returns the following:
  * 1       - 1 packet successfully received
  * 0       - successful TPA_START, packet not completed yet
@@ -1941,6 +1987,14 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	}
 
 	if (xdp_active) {
+		if (unlikely((flags & RX_CMP_FLAGS_ITYPES_MASK) ==
+			     RX_CMP_FLAGS_ITYPE_PTP_W_TS) || bp->ptp_all_rx_tstamp) {
+			if (bp->flags & BNXT_FLAG_CHIP_P5) {
+				bxbuf.rxcmp1 = rxcmp1;
+				bxbuf.bp = bp;
+			}
+		}
+
 		if (bnxt_rx_xdp(bp, rxr, cons, bxbuf.xdp, data, &len, event)) {
 			rc = 1;
 			goto next_rx;
@@ -13116,6 +13170,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_bridge_getlink	= bnxt_bridge_getlink,
 	.ndo_bridge_setlink	= bnxt_bridge_setlink,
 	.ndo_get_devlink_port	= bnxt_get_devlink_port,
+	.ndo_unroll_kfunc	= bnxt_unroll_kfunc,
 };
 
 static void bnxt_remove_one(struct pci_dev *pdev)
-- 
2.38.1.431.g37b22c650d-goog

