Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B122CC059
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgLBPI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgLBPI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 10:08:26 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3131CC0617A7
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 07:07:46 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q10so1436887pfn.0
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 07:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oVUxlFzvG0YeZ7OkR1qvNOs6zaHHh9gvJZg4hCR2xvQ=;
        b=IpoqE5R1/KO4eIB1irQiNBUHh+Cf6DHXFh9d0k80o0IRJGSNBJA2G5lnPFDV92IPxz
         yYumX2Bj9tqLIUJ15xTSpI4+sjxS+/qE0CLzEm316ic5zxs2wt1n24eNilU+LBR7KjH5
         j6kyiV4+x+InCWJ70out41tBtCOzVmF01RhayR+t+esMo4JTpfgzg3h3hk2PrpEDQIgq
         sBtVsfNQ/oe85vqSFxHLwQ+Q5fRPdc2h1fh4uzaO2lqQXD7Y7LplP0gHlTSsbWx/7v2W
         FuJVq2mRwvsR/98hHfd/tQnNgtlBS4SgP8UeWjbxq08DZPpMqcQ+dac/XZS+n1VzfsIW
         pJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oVUxlFzvG0YeZ7OkR1qvNOs6zaHHh9gvJZg4hCR2xvQ=;
        b=egeAt4Q0Z8V0Dc8tatLhGjL9Z0K0yZNi+7uug2BOD0IjTRf+CPcRTm6enuj1DAKWoP
         xCJxToD6Etzxl1A433UlHUzSIljT+SGND7CwXJJQ6Qn//LzrZKrGcNBfVRSNp47w04+9
         6Crt+oGbiVI/Hi08HCiuEPBPsYw28g2UJeBe6mb6wFkcyx2O9V+i/rsTg6sz74p0TVje
         6ZVz+XYAP3DPcJInMM0KGvW/6o6QmL8aHYw92sVBPnj7gXmiVSLy3CcvXuK48rXZQEOi
         eRnzha0RItlBv2Xy2SGPa4le3Cc88LpXLWHOSLZyFcGRHD4jYJIE6K5IW+Jz4aDybejc
         lblw==
X-Gm-Message-State: AOAM532sdMZ3gYWRXNJUgTHWah6GbYFTxIIlEIr0/paZC8IaDINLpfsB
        M0FEVBOSW7uIykEXWKX1214=
X-Google-Smtp-Source: ABdhPJyVqKylIIgWwX4bFqUPOpm3v1ZXtYI/7pXnEGQEgCAEpFQlGhF+/6wjHxKhsHJIT2T93P6cjA==
X-Received: by 2002:a63:f03:: with SMTP id e3mr273635pgl.316.1606921665773;
        Wed, 02 Dec 2020 07:07:45 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id p21sm148537pfn.87.2020.12.02.07.07.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 07:07:45 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH net-next 3/3] ice: optimize for XDP_REDIRECT in xsk path
Date:   Wed,  2 Dec 2020 16:07:24 +0100
Message-Id: <20201202150724.31439-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201202150724.31439-1-magnus.karlsson@gmail.com>
References: <20201202150724.31439-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Optimize ice_run_xdp_zc() for the XDP program verdict being
XDP_REDIRECT in the zsk zero-copy path. This path is only used when
having AF_XDP zero-copy on and in that case most packets will be
directed to user space. This provides a little over 100k extra packets
in throughput on my server when running l2fwd in xdpsock.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 797886524054..3b180e52112f 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -521,6 +521,14 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 	}
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
+
+	if (likely(act == XDP_REDIRECT)) {
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
+		rcu_read_unlock();
+		return result;
+	}
+
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -528,10 +536,6 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
 		result = ice_xmit_xdp_buff(xdp, xdp_ring);
 		break;
-	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
-		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
-- 
2.29.0

