Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4169F377F84
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhEJJk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhEJJkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:40:23 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16460C061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:19 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z6so15881212wrm.4
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUYE8uhwJ5aoRnKQOShutBC+Cl1nbGcNA8ZVeVX77ro=;
        b=g6VAjI18Lug5NcuzobpmsdpjILQ2lxpBmOJUpRwhUHQY+xI8gLTxoq5L7sSrvLrwxy
         WS6i0J7xjBsz36UdipReASh4l5FBMbQ8Ilv8H9HYZJIxHrNOOTXuob1S1zdgooRhkxWV
         lHTOx9ZNADFpbtaw135iFb2mAOe8P6KT3UqY6yZNBSO08nLyZz7peAQ3xfvms01ySAuP
         I3qU6FsedXsL+lZZWDv09C0nni3mHGep2ilXF0GIkhMP85Gq5Hn36axO5n7vW4e9qnCk
         R588ESAM2rYsxOp3IFXiQJv+hgOkuEsKDbIKVIc4I0yornrSwBKUfjOdP4v+geVA4bvt
         7gtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUYE8uhwJ5aoRnKQOShutBC+Cl1nbGcNA8ZVeVX77ro=;
        b=OwAR9mT5lCGmTXZO66bWMS3IK4UpD1mfE++wx2h6gf+2e/uGSN5TDLANPuvXqVhGyZ
         UjINcuB1n/6bKhOyzB/L0dyrRQywWEtMTvShPnjKjRIPGTAmglGtpPmABE/zLrxh2hIK
         YhpdH5zOF3BITQf6TsvVO+SmZ3BLPoy5B3+SgMyqM4X6AfRK6AEcc5m9G94HmM7/FhCP
         jmCrvPoBQUw6e53O6O4I+sQoX9yUHGFHKtCumrFBxDRrUJkrGQTv3A+PS4WinBh3zZMU
         wbkyHAGtJNsA0y7kKX3GD3FdQZ+06BKPX6jzpEHWTys4xII3Ffr4qf3YDRUHJ5Jzrbt/
         7/cw==
X-Gm-Message-State: AOAM531+iz7jo5GOBFAx5LAFgAtUZ8xck+mBwPX8M3vcWox/ssmucr7L
        EFVoEEMSmQuLx6gnL+hPwEyYQKEWZEkkBQ==
X-Google-Smtp-Source: ABdhPJxpY8ooez7lOvBhPv0kqt2ownholonszizPwCfgQoTwG1Y4eWCQ4FeqfLhCkEHfkl5xR/LG/A==
X-Received: by 2002:a05:6000:110c:: with SMTP id z12mr28866989wrw.188.1620639557856;
        Mon, 10 May 2021 02:39:17 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i2sm25892933wro.0.2021.05.10.02.39.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 May 2021 02:39:17 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net v2 1/6] i40e: add correct exception tracing for XDP
Date:   Mon, 10 May 2021 11:38:49 +0200
Message-Id: <20210510093854.31652-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210510093854.31652-1-magnus.karlsson@gmail.com>
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different errors
can occur. The support was only partial. Several errors where not
logged which would confuse the user quite a lot not knowing where and
why the packets disappeared.

Fixes: 74608d17fe29 ("i40e: add support for XDP_TX action")
Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 7 ++++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 8 ++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index de70c16ef619..b883ab809df3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2313,15 +2313,20 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
+		if (result == I40E_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = I40E_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 46d884417c63..68f177a86403 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -162,9 +162,10 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
 		rcu_read_unlock();
-		return result;
+		return I40E_XDP_REDIR;
 	}
 
 	switch (act) {
@@ -173,11 +174,14 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
+		if (result == I40E_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
-- 
2.29.0

