Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E781618EFC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiKDD10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiKDD0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA25137
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-368e6c449f2so35783897b3.5
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OCCgxbTVge/6IILt05Wsg/+KZJkjj0dhtDZEa8P1RhM=;
        b=fPcnLbYP2Vz1k8K5iokHm8DjUtShAMal+AwffWSwfc3qkX8LY2oTllmEirmO+TThQ7
         SV3I4kgyOXiyPY4K4sEBRo0luzBxKmMaq6eRNo1sbDHNo/AmuSkLwc7Ts4/OzOR8VzEJ
         /lfHJD4UgUmzMLLZpEGhEHdFtpcNyB/R2ugVBzt/p/yodp6/s/dB224eyR7LxwL/PWQS
         Sjk2ct14H7QA5Iju8k4lOPveepGFIIo7/akjt/E9iHoVOdbbaHR82lx2mjsQZVrDngTo
         JncLWsOsatZJBCpmq8VTrRr4Kee8dUa58mHK2vdKzupXyxWBcn8iHLeQ7YABgqqCXu6D
         utOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCCgxbTVge/6IILt05Wsg/+KZJkjj0dhtDZEa8P1RhM=;
        b=m+93+vx46lU+BHbCEp+OHg6Wb3jMreqmz1W7Ll3pHm9AvuTrUYQiBVhA3rOXp5AjKT
         /9+fnCfwG8wO4PhQQhCA3qfYbBG/fMWMQh3HwgJzuVJxWrjjUQePlaqpvXOF64bA3gc9
         u+rI9zJttlxLNJxQBUxC0PC/U7toKUsrnpc8a8bc0Zrlei4iOkqaXU3xLls2Z/s87nvg
         2Q1Y6uw/upuDdWphvES/YLoTuL18YarjOAY6dIeyCFnQrMAXIqHqaRa2lUYnXr1ETyZf
         aJXh0AUKGGw4ac5IfTCGrlxhufsE4AJTDChVKev4d24lzvHowaVGoyThleLB4U4fQLfB
         kcLQ==
X-Gm-Message-State: ACrzQf1qVDYsZcieP15Bo3/MCvmbqWczKe7lbzLQu5fepSbsqJqNX/CA
        9rzB/8KMDH9G39Wb5ZT2mvDJpP0=
X-Google-Smtp-Source: AMsMyM5hULLNnXmCgtXNIAvHt43WTGt0K7Anj0qbolVVBOnPVRMfsXgsVkc/qJrLcSztj4Srn1M9p3o=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a5b:a07:0:b0:6c5:513b:387c with SMTP id
 k7-20020a5b0a07000000b006c5513b387cmr32440032ybq.234.1667532340850; Thu, 03
 Nov 2022 20:25:40 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:22 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-5-sdf@google.com>
Subject: [RFC bpf-next v2 04/14] veth: Support rx timestamp metadata for xdp
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

xskxceiver conveniently setups up veth pairs so it seems logical
to use veth as an example for some of the metadata handling.

We timestamp skb right when we "receive" it, store its
pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
reach it from the BPF program.

This largely follows the idea of "store some queue context in
the xdp_buff/xdp_frame so the metadata can be reached out
from the BPF program".

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
 drivers/net/veth.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 917ba57453c1..0e629ceb087b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -25,6 +25,7 @@
 #include <linux/filter.h>
 #include <linux/ptr_ring.h>
 #include <linux/bpf_trace.h>
+#include <linux/bpf_patch.h>
 #include <linux/net_tstamp.h>
 
 #define DRV_NAME	"veth"
@@ -118,6 +119,7 @@ static struct {
 
 struct veth_xdp_buff {
 	struct xdp_buff xdp;
+	struct sk_buff *skb;
 };
 
 static int veth_get_link_ksettings(struct net_device *dev,
@@ -602,6 +604,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 
 		xdp_convert_frame_to_buff(frame, xdp);
 		xdp->rxq = &rq->xdp_rxq;
+		vxbuf.skb = NULL;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 
@@ -826,6 +829,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 
 	orig_data = xdp->data;
 	orig_data_end = xdp->data_end;
+	vxbuf.skb = skb;
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
@@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			struct sk_buff *skb = ptr;
 
 			stats->xdp_bytes += skb->len;
+			__net_timestamp(skb);
 			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
 			if (skb) {
 				if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
@@ -1665,6 +1670,31 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
+			      struct bpf_patch *patch)
+{
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
+		/* return true; */
+		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
+		bpf_patch_append(patch,
+			/* r5 = ((struct veth_xdp_buff *)r1)->skb; */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_5, BPF_REG_1,
+				    offsetof(struct veth_xdp_buff, skb)),
+			/* if (r5 == NULL) { */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_5, 0, 2),
+			/*	return 0; */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_A(1),
+			/* } else { */
+			/*	return ((struct sk_buff *)r5)->tstamp; */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_5,
+				    offsetof(struct sk_buff, tstamp)),
+			/* } */
+		);
+	}
+}
+
 static const struct net_device_ops veth_netdev_ops = {
 	.ndo_init            = veth_dev_init,
 	.ndo_open            = veth_open,
@@ -1684,6 +1714,7 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_bpf		= veth_xdp,
 	.ndo_xdp_xmit		= veth_ndo_xdp_xmit,
 	.ndo_get_peer_dev	= veth_peer_dev,
+	.ndo_unroll_kfunc       = veth_unroll_kfunc,
 };
 
 #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
-- 
2.38.1.431.g37b22c650d-goog

