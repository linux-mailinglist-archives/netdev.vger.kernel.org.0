Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E021F4229
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 19:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgFIR0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 13:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgFIR0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 13:26:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12972C05BD1E;
        Tue,  9 Jun 2020 10:26:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r18so4318898pgk.11;
        Tue, 09 Jun 2020 10:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bL2979gbrbVOBW8YKdrznYz9+T/S2jMO+jy1PFJQ0G4=;
        b=VlxiEpM4wyiBp1Yv3uLk23W3Sa36G+oj8LZJMLwa+wzNOByjlQbrvDKBp9dwFa4beM
         qV0oLjyiBpBSHYqMsp/3megmOX7teYM8sLo/79cdIE7XlFTD3dKl5nMGY3OMyEyNm1ec
         baSbmlOvlQQVw4N0aP7i9vydkZAjqnOQl0jrmGt8ONNtzUbWlEpR/E55wzLzF5lJzqz2
         IfARyrxHVM7dfHAtWSumauDKpJySBnr9x5hzopMnyPn4y/I3MSW4jUDpUk8UR7Shq5Xo
         6omcsNAuaBqILWOtaBgM8KT5U3qcD0vjBcG0H0zuc1ucVWk7bURPlCHq7i2c0kUQ39d0
         9CXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bL2979gbrbVOBW8YKdrznYz9+T/S2jMO+jy1PFJQ0G4=;
        b=KAqH1hf/HIeATbry9ZHSE/DasySJXOOu6xyaRRIDDSZVyA9mRxswOqfjkflXOhmve4
         II0R2SmFZcPeb0FQYMUCkTElq7CCj1GzXt9WOvsqon4EcRlkxnSBYv8uZRxXPWBIAkgw
         Rymqji1RJ8cGQIVmRJ3TcPzI3CyRZhqYyzHrIF5b8aSqtMKRdkaCQgT+d3IXMm6PjXhD
         BRk6AROONwUBr+fcql8rO0cY2QN37gB3WRVXpmEljoR999JB4PslV67hRlP5BAkbopS6
         G4Jtd4ctKpNptBTL0MppUF2GLMXaj+PBbpNg63v6ZWWFyPFhThpigjbv5eafXs9bpHgP
         ufIQ==
X-Gm-Message-State: AOAM531VWkdrXTBbqKfZNLsEG1hgOpot0TdN1Y+ObGR/LuZkKFvh/2vr
        IEmd+6zVgYNDiT6yjU6FUKA=
X-Google-Smtp-Source: ABdhPJykY1H7+bK1nK8pg3FL2hhSWCt3PJa6hRvX7q51+XA2U0grz7LC1MW3Eq060R1hPQ2cM2CeTg==
X-Received: by 2002:a63:f305:: with SMTP id l5mr24255345pgh.387.1591723605637;
        Tue, 09 Jun 2020 10:26:45 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id w190sm10390387pfw.35.2020.06.09.10.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 10:26:44 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        john.fastabend@gmail.com, toke@redhat.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        brouer@redhat.com, maciej.fijalkowski@intel.com
Subject: [RFC PATCH bpf-next 2/2] i40e: avoid xdp_do_redirect() call when "redirect_tail_call" is set
Date:   Tue,  9 Jun 2020 19:26:22 +0200
Message-Id: <20200609172622.37990-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200609172622.37990-1-bjorn.topel@gmail.com>
References: <20200609172622.37990-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

If an XDP program, where all the bpf_redirect_map() calls are tail
calls (as defined by the previous commit), the driver does not need to
explicitly call xdp_do_redirect().

The driver checks the active XDP program, and notifies the BPF helper
indirectly via xdp_set_redirect_tailcall().

This is just a naive, as-simple-as-possible implementation, calling
xdp_set_redirect_tailcall() for each packet.

For the AF_XDP rxdrop benchmark the pps went from 21.5 to 23.2 Mpps.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 14 ++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 14 ++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f9555c847f73..0d8dbdc4f47e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2186,6 +2186,7 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
+	bool impl_redir = false;
 	u32 act;
 
 	rcu_read_lock();
@@ -2194,6 +2195,11 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 	if (!xdp_prog)
 		goto xdp_out;
 
+	if (xdp_prog->redirect_tail_call) {
+		impl_redir = true;
+		xdp_set_redirect_tailcall(rx_ring->xdp_prog, xdp,
+					  rx_ring->netdev);
+	}
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
@@ -2205,8 +2211,12 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
 		break;
 	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		if (impl_redir) {
+			result = I40E_XDP_REDIR;
+		} else {
+			err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+			result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		}
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 7276580cbe64..0826f551649f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -146,6 +146,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
+	bool impl_redir = false;
 	u32 act;
 
 	rcu_read_lock();
@@ -153,6 +154,11 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	 * this path is enabled by setting an XDP program.
 	 */
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+	if (xdp_prog->redirect_tail_call) {
+		impl_redir = true;
+		xdp_set_redirect_tailcall(rx_ring->xdp_prog, xdp,
+					  rx_ring->netdev);
+	}
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	switch (act) {
@@ -163,8 +169,12 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
 		break;
 	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		if (impl_redir) {
+			result = I40E_XDP_REDIR;
+		} else {
+			err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+			result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		}
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-- 
2.25.1

