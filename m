Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A008377F85
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhEJJk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhEJJkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:40:24 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AD6C061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:20 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t18so15880915wry.1
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gJ24jMtfVd96yK7jKT2cYd+nQBdfHaBQjl52YeItdPE=;
        b=JlbZHLXkDCy4bzK91k18C4VTTUPUIcwMxego4GZjrjdtAMqZQFdiLY00HdIval+Tig
         vcp4roeukpCq4j9KSu7X+2FBN8oolg+AUpgBsSM0O0Kxw7/STyCfZyNTKraF4Zz2vTXP
         sYPWH49c/bNUm+S+YwulH9Pd+pZ9GfMaibTkepjgB87N2uQoGou0kQO3M9vRGWfqDXAL
         RPk7mmh30CNjXRpu1hhbHAlRgBYskQChJTAx2jF/c1cvnjP3MScMgTFSelZCEl0dEI7m
         k7AwgK+b6jHItqNbOsFpUkeiPD930oe3mBnqxoFAAqoCFIViYNx/ud/EYZ0pTXnZNJfq
         6hOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gJ24jMtfVd96yK7jKT2cYd+nQBdfHaBQjl52YeItdPE=;
        b=PyWZ414PFhCeQzbaPGHC/5uGQZNIbOm3vz1DJ8GSOudS95DS2I/wBGfiVeE1vHAr1a
         mqKPaX6NfAFzROf4o8zV8eqjEwUya9r2DBSFG+i/q5OJQCiNuQkEuiWpUcZJSWhJEvTo
         vlrOcOiA51ncZPY33BHvcwIuQND4gOnZLKlL5vL1TOp8QR799FdMfiRTeK8r7LccWmYo
         NnpB4wYweKqfUqTs13ysWv76kd/2mrAsWI3QfOv/csAxYJuHgMsKlJrYpucbvM3pzCro
         oqoXEbcuOPY6IgZWhmhCbBU2DiGLqt3hOr9pNcUFrbkYUYEBIAG+z/XPere7bKBl+3jq
         1gTA==
X-Gm-Message-State: AOAM533UTfrxhlJ2ZWL1nBphUaCI3p7LC0jT1ZIYztghJ63VUud10IIz
        6O16tFxkg+5QCJ7ZyT2onnrrIc3OYX+xrg==
X-Google-Smtp-Source: ABdhPJxnpIiD0k4t+3U3jRK+IdwKX8g/C+ai+VmERwyYWvoENT7g+7O77KjOQqcxa0NdpLJMoQon6A==
X-Received: by 2002:a05:6000:144f:: with SMTP id v15mr28720897wrx.182.1620639559046;
        Mon, 10 May 2021 02:39:19 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i2sm25892933wro.0.2021.05.10.02.39.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 May 2021 02:39:18 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net v2 2/6] ice: add correct exception tracing for XDP
Date:   Mon, 10 May 2021 11:38:50 +0200
Message-Id: <20210510093854.31652-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210510093854.31652-1-magnus.karlsson@gmail.com>
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 12 +++++++++---
 drivers/net/ethernet/intel/ice/ice_xsk.c  |  8 ++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e2b4b29ea207..93e5d9ebfd74 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -523,7 +523,7 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 	    struct bpf_prog *xdp_prog)
 {
 	struct ice_ring *xdp_ring;
-	int err;
+	int err, result;
 	u32 act;
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
@@ -532,14 +532,20 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 		return ICE_XDP_PASS;
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
-		return ice_xmit_xdp_buff(xdp, xdp_ring);
+		result = ice_xmit_xdp_buff(xdp, xdp_ring);
+		if (result == ICE_XDP_CONSUMED)
+			goto out_failure;
+		return result;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		return !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		return ICE_XDP_REDIR;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index faa7b8d96adb..7228e4d427bc 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -473,9 +473,10 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
 		rcu_read_unlock();
-		return result;
+		return ICE_XDP_REDIR;
 	}
 
 	switch (act) {
@@ -484,11 +485,14 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
 		result = ice_xmit_xdp_buff(xdp, xdp_ring);
+		if (result == ICE_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-- 
2.29.0

