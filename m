Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048FE25DA9A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgIDNyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730712AbgIDNyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:54:39 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D65C061251;
        Fri,  4 Sep 2020 06:54:35 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id v15so4363382pgh.6;
        Fri, 04 Sep 2020 06:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Br4mU3YiIC4VRDX0+F3OpOlmSyiXlfba1PWnn12174=;
        b=eEtCcZfJUz2RsWJUBs5W2X/s5sEfMqXT4rlVpRRcCoJmiqFZPRb85GFIko7b/IbW9o
         gCz6V+k7YM0Bzo7A/sqeM/YUNVTmUimNxL9DQuu5S+y4PV8Y/r4bQrlr4kGsj55JMdjg
         5lwGPxhAIgKaGL/4OpmwbBt7yqDDBojMoJYXOFCdXbra5W5aAjCE9BKog3w8T55uAyAt
         9iL6r7s5sd8bsSwW2uESigaZAuY+gE1ZLnkkECL7dW5pIExz2bG/N54U2/XyQq5ReNB4
         /bwo5DD0ns2bQa3Z1ZKhdNyx5aw1TXwzwiTeRmHjlEtaSXzFb5AOmvcWmIGAEv1YBNln
         m0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Br4mU3YiIC4VRDX0+F3OpOlmSyiXlfba1PWnn12174=;
        b=PeUH7Pooobz5K4YctgVVWCRAHNJDmz9QVc6AHcnk47vD2l5v8eY1POuWzid43Os8n2
         +n+QkL8Y3rQQcZwRKmeix/gg3RY+lMJbnjk0VIA/oKHGkDITpvyBe6OLPH+tnT1/t1WZ
         VmrOvwn2kn+eO3VvMwIBIPYJ4csmJ6HrcQ5wBUuMOh1JQZYAiTZwoRg+1eHX7/NLq78W
         Lpw0riaNMi0d5QSwrmFDON0RZdfs2H22kXC3kxLOyDE45+vAHrXVKBKcSfnagLx5GWOj
         nghgC8oRp5inS/rK2MiI+GJRMBo89yeqhyO0rWXdlfD4DWVnEZycfEjUBbhI0Lm15Dpf
         cpZA==
X-Gm-Message-State: AOAM532oK1+gfv8qTZpYmy/KsmFKoJ4ygHahM4BD5zOL5ecuICxax9Pk
        wSw85rKyhAZa5/cdkMWdLPY=
X-Google-Smtp-Source: ABdhPJyi17LWympwfyGZ/fupgfwzB/WqdpEYgSTY9m58p2VgIMdE2I7itIooXJ3yJtNtKqvns2tY/A==
X-Received: by 2002:a63:2d42:: with SMTP id t63mr7458188pgt.450.1599227675061;
        Fri, 04 Sep 2020 06:54:35 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id g9sm6931239pfr.172.2020.09.04.06.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 06:54:34 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 5/6] ice, xsk: finish napi loop if AF_XDP Rx queue is full
Date:   Fri,  4 Sep 2020 15:53:30 +0200
Message-Id: <20200904135332.60259-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904135332.60259-1-bjorn.topel@gmail.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Make the AF_XDP zero-copy path aware that the reason for redirect
failure was due to full Rx queue. If so, exit the napi loop as soon as
possible (exit the softirq processing), so that the userspace AF_XDP
process can hopefully empty the Rx queue. This mainly helps the "one
core scenario", where the userland process and Rx softirq processing
is on the same core.

Note that the early exit can only be performed if the "need wakeup"
feature is enabled, because otherwise there is no notification
mechanism available from the kernel side.

This requires that the driver starts using the newly introduced
xdp_do_redirect_ext() and xsk_do_redirect_rx_full() functions.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 797886524054..f698d0199b0a 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -502,13 +502,15 @@ ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
  * ice_run_xdp_zc - Executes an XDP program in zero-copy path
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
+ * @early_exit: true means that the napi loop should exit early
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static int
-ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
+ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp, bool *early_exit)
 {
 	int err, result = ICE_XDP_PASS;
+	enum bpf_map_type map_type;
 	struct bpf_prog *xdp_prog;
 	struct ice_ring *xdp_ring;
 	u32 act;
@@ -529,8 +531,13 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 		result = ice_xmit_xdp_buff(xdp, xdp_ring);
 		break;
 	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
+		err = xdp_do_redirect_ext(rx_ring->netdev, xdp, xdp_prog, &map_type);
+		if (err) {
+			*early_exit = xsk_do_redirect_rx_full(err, map_type);
+			result = ICE_XDP_CONSUMED;
+		} else {
+			result = ICE_XDP_REDIR;
+		}
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -558,8 +565,8 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
+	bool early_exit = false, failure = false;
 	unsigned int xdp_xmit = 0;
-	bool failure = false;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
@@ -597,7 +604,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		rx_buf->xdp->data_end = rx_buf->xdp->data + size;
 		xsk_buff_dma_sync_for_cpu(rx_buf->xdp, rx_ring->xsk_pool);
 
-		xdp_res = ice_run_xdp_zc(rx_ring, rx_buf->xdp);
+		xdp_res = ice_run_xdp_zc(rx_ring, rx_buf->xdp, &early_exit);
 		if (xdp_res) {
 			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
 				xdp_xmit |= xdp_res;
@@ -610,6 +617,8 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 			cleaned_count++;
 
 			ice_bump_ntc(rx_ring);
+			if (early_exit)
+				break;
 			continue;
 		}
 
@@ -646,12 +655,12 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
 
 	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
-		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
+		if (early_exit || failure || rx_ring->next_to_clean == rx_ring->next_to_use)
 			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
 		else
 			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
 
-		return (int)total_rx_packets;
+		return early_exit ? 0 : (int)total_rx_packets;
 	}
 
 	return failure ? budget : (int)total_rx_packets;
-- 
2.25.1

