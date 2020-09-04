Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123DF25DAA1
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgIDNzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730606AbgIDNyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:54:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EFEC061244;
        Fri,  4 Sep 2020 06:54:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u128so4643108pfb.6;
        Fri, 04 Sep 2020 06:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CJi+EkzTJVtrdukKQRD3YbRAKR4DiANTw+RCP7poH4U=;
        b=QxrCXwLX360vUP9Kvsxo+bukkSWUCqiex301/++ROFdWJDaxvjxvttG78X9cRc19KT
         VmG1qYGEEcHvigEsLhSu90Y+XhklxmvQFfcf8h93d4g+F9qd9yV8r/wGLBPgOxriPjbI
         680b6F9b2Ln9D3sx6zy0z5SnVmlQxbwE6iaQ4N0DQL5pW6tcnX+Uvd8TGy5MxitXz364
         8d2qWpyFmjjLAUZEQhIX2vn7TAcMSgjdnpbRRljzNAqD/lBRTG1T52aX6nVC2+4al9sH
         /YtmyOiA3U66/4GhEgQzn/CqDKRJyM4EnZ0QbLRVIwmCnGimaetCbJOpEKTe6CgwdDoM
         7gtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CJi+EkzTJVtrdukKQRD3YbRAKR4DiANTw+RCP7poH4U=;
        b=owuB75/9yNPpqUmhJvmSv6ttR6b2YTkQPY2hqbWYPzi45aWzklhDycMETb39cM1zVJ
         28tVs+2YlXyt9Unq6E27zblBpCmWPmDJRTpIwTiQdU+0rmMMytqSev98YtjPDMKZEVuu
         W9OCB1RoMSS8H2J+WtZnGpf65MzUsjpGrLLbNR+LuL4gqOdtnNtP5A0w2TEH76KZoXPC
         OAqRlXxbU2LQpViHpgHXIsWUyve3aX5pDWuRjZxOqE2RKB51yV2Ae1BU+LfKdOV+07N8
         qzBOCSj7EQzs5ERPsVmhVdu9yfsqkkYeW6cyezXIDepYOi3lpC4TCGLE7NhTzJYK7zEb
         vJAQ==
X-Gm-Message-State: AOAM532YVhRXhai0U9wsEV88btxKtaELRTdoLnT/Q2yDmvfSAHaP29aw
        qw1y8EWEkQomrRXhSWkYx94=
X-Google-Smtp-Source: ABdhPJy/nQhhEvXFOw5z1ThFseXe9AUccyxj5amHrf+Q0FPN3Ei2V+6LoD93g//7dqLVidUG6qx6yQ==
X-Received: by 2002:a63:5f8b:: with SMTP id t133mr7522134pgb.238.1599227669730;
        Fri, 04 Sep 2020 06:54:29 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id g9sm6931239pfr.172.2020.09.04.06.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 06:54:29 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 4/6] i40e, xsk: finish napi loop if AF_XDP Rx queue is full
Date:   Fri,  4 Sep 2020 15:53:29 +0200
Message-Id: <20200904135332.60259-5-bjorn.topel@gmail.com>
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
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 23 +++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 2a1153d8957b..3ac803ee8d51 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -142,13 +142,15 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
  * i40e_run_xdp_zc - Executes an XDP program on an xdp_buff
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
+ * @early_exit: true means that the napi loop should exit early
  *
  * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR}
  **/
-static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
+static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp, bool *early_exit)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
+	enum bpf_map_type map_type;
 	struct bpf_prog *xdp_prog;
 	u32 act;
 
@@ -167,8 +169,13 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
 		break;
 	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		err = xdp_do_redirect_ext(rx_ring->netdev, xdp, xdp_prog, &map_type);
+		if (err) {
+			*early_exit = xsk_do_redirect_rx_full(err, map_type);
+			result = I40E_XDP_CONSUMED;
+		} else {
+			result = I40E_XDP_REDIR;
+		}
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -268,8 +275,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
+	bool early_exit = false, failure = false;
 	unsigned int xdp_res, xdp_xmit = 0;
-	bool failure = false;
 	struct sk_buff *skb;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
@@ -316,7 +323,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		(*bi)->data_end = (*bi)->data + size;
 		xsk_buff_dma_sync_for_cpu(*bi, rx_ring->xsk_pool);
 
-		xdp_res = i40e_run_xdp_zc(rx_ring, *bi);
+		xdp_res = i40e_run_xdp_zc(rx_ring, *bi, &early_exit);
 		if (xdp_res) {
 			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR))
 				xdp_xmit |= xdp_res;
@@ -329,6 +336,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 
 			cleaned_count++;
 			i40e_inc_ntc(rx_ring);
+			if (early_exit)
+				break;
 			continue;
 		}
 
@@ -363,12 +372,12 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
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
 }
-- 
2.25.1

