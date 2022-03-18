Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02D54DE1AB
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbiCRTVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbiCRTVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:21:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0C32EAF4B;
        Fri, 18 Mar 2022 12:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1991B821D9;
        Fri, 18 Mar 2022 19:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0027DC340E8;
        Fri, 18 Mar 2022 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647631223;
        bh=BcbMamWqB7X7hyYcrYu0goi4CGE0gY5RL3cSYirqkVU=;
        h=From:To:Cc:Subject:Date:From;
        b=CxgyXSCHfA+SKpSGg4BbQ502oE8N1bmLmQvu3boOjdvuYihM1pi8eEZeQx2Gf+Hwv
         oyFVKPv7ST5zZ8wn7jR+wflqiIToLOiUcZTZMq0TsFNQvY2FzDqSONcbCCNyzNOSrG
         f+yxuakkuqipT4cpdQ8eFeRQKNbWszB/UvzSLfLXKA4ROACLkrS82ixKnbng5TRhWJ
         YdIXXnbUKoAOmfMXRDDBVwxttZdecs2DMaHWCBJ5IAu1r3e+eZJ8c4BeCvqyMjiixk
         2ksKCjGezxCCHxan72BKIUlDXT/RxnyUZO+oJG2Kik+Qq1viaROLrBZ+SslFVViI6n
         TitxbsNr3ar5g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, pabeni@redhat.com,
        toke@redhat.com, lorenzo.bianconi@redhat.com, andrii@kernel.org,
        nbd@nbd.name
Subject: [PATCH bpf-next] net: xdp: introduce XDP_PACKET_HEADROOM_MIN for veth and generic-xdp
Date:   Fri, 18 Mar 2022 20:19:29 +0100
Message-Id: <039064e87f19f93e0d0347fc8e5c692c789774e6.1647630686.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce mandatory xdp headroom for generic-xdp and veth driver to 192B
(instead of 256B) in order to reduce unnecessary skb re-allocations in
both veth and generic-xdp code.
This patch has been tested running the xdp_redirect_map sample in
skb-mode on a ixgbe NIC and redirecting received traffic on a veth pair
where a simple XDP_DROP program is used to discard received packets:

  bpf-next master:
  ----------------
  xdp_redirect (ixgbe): ~ 1.38Mpps
  xdp_drop (veth):      ~ 1.38Mpps

  bpf-next master + reduced xdp headroom:
  ---------------------------------------
  xdp_redirect (ixgbe): ~ 2.82Mpps
  xdp_drop (veth):      ~ 2.82Mpps

  bpf-next master:
  ----------------
  5.16%  ksoftirqd/1   [kernel.vmlinux]   [k] page_frag_free
  4.42%  ksoftirqd/1   [kernel.vmlinux]   [k] ixgbe_poll
  4.19%  ksoftirqd/1   [kernel.vmlinux]   [k] check_preemption_disabled
  3.74%  ksoftirqd/1   [kernel.vmlinux]   [k] kmem_cache_free
  3.69%  ksoftirqd/1   [kernel.vmlinux]   [k] get_page_from_freelist
  3.36%  ksoftirqd/1   [kernel.vmlinux]   [k] veth_xdp_rcv_skb
  3.06%  ksoftirqd/1   [kernel.vmlinux]   [k] memcpy_erms
  3.01%  ksoftirqd/1   [kernel.vmlinux]   [k] pskb_expand_head
  2.80%  ksoftirqd/1   [kernel.vmlinux]   [k] __copy_skb_header
  2.50%  ksoftirqd/1   [kernel.vmlinux]   [k] bpf_prog_run_generic_xdp
  2.15%  ksoftirqd/1   [kernel.vmlinux]   [k] memcg_slab_free_hook
  2.03%  ksoftirqd/1   [kernel.vmlinux]   [k] __slab_free
  2.01%  ksoftirqd/1   [kernel.vmlinux]   [k] xdp_do_generic_redirect

  bpf-next master + reduced xdp headroom:
  ---------------------------------------
  8.24%  ksoftirqd/5   [ixgbe]            [k] ixgbe_poll
  5.65%  ksoftirqd/5   [kernel.vmlinux]   [k] check_preemption_disabled
  4.93%  ksoftirqd/5   [kernel.vmlinux]   [k] napi_build_skb
  4.16%  ksoftirqd/5   [kernel.vmlinux]   [k] xdp_do_generic_redirect
  3.69%  ksoftirqd/5   [veth]             [k] veth_xdp_rcv_skb
  3.48%  ksoftirqd/5   [veth]             [k] veth_xmit
  3.15%  ksoftirqd/5   [kernel.vmlinux]   [k] kmem_cache_free
  3.05%  ksoftirqd/5   [kernel.vmlinux]   [k] __dev_forward_skb2
  3.01%  ksoftirqd/5   [kernel.vmlinux]   [k] eth_type_trans
  2.96%  ksoftirqd/5   [kernel.vmlinux]   [k] bpf_prog_run_generic_xdp
  2.65%  ksoftirqd/5   [kernel.vmlinux]   [k] __netif_receive_skb_core
  2.32%  ksoftirqd/5   [veth]             [k] veth_xdp_rcv
  1.94%  ksoftirqd/5   [kernel.vmlinux]   [k] napi_gro_receive

Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c             | 2 +-
 include/uapi/linux/bpf.h       | 3 ++-
 net/core/dev.c                 | 2 +-
 tools/include/uapi/linux/bpf.h | 3 ++-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 1b5714926d81..c6ec57891708 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -766,7 +766,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 
 		consume_skb(skb);
 		skb = nskb;
-	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM &&
+	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM_MIN &&
 		   pskb_expand_head(skb, VETH_XDP_HEADROOM, 0, GFP_ATOMIC)) {
 		goto drop;
 	}
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7604e7d5438f..29fd4991cbcb 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5717,7 +5717,8 @@ struct bpf_xdp_sock {
 	__u32 queue_id;
 };
 
-#define XDP_PACKET_HEADROOM 256
+#define XDP_PACKET_HEADROOM	256
+#define XDP_PACKET_HEADROOM_MIN	192
 
 /* User return codes for XDP prog type.
  * A valid XDP program must return one of these defined values. All other
diff --git a/net/core/dev.c b/net/core/dev.c
index ba69ddf85af6..92d560e648ab 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4737,7 +4737,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	 * native XDP provides, thus we need to do it here as well.
 	 */
 	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+	    skb_headroom(skb) < XDP_PACKET_HEADROOM_MIN) {
 		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
 		int troom = skb->tail + skb->data_len - skb->end;
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7604e7d5438f..29fd4991cbcb 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5717,7 +5717,8 @@ struct bpf_xdp_sock {
 	__u32 queue_id;
 };
 
-#define XDP_PACKET_HEADROOM 256
+#define XDP_PACKET_HEADROOM	256
+#define XDP_PACKET_HEADROOM_MIN	192
 
 /* User return codes for XDP prog type.
  * A valid XDP program must return one of these defined values. All other
-- 
2.35.1

