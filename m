Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3C7369005
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241948AbhDWKFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241717AbhDWKFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:05:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89481C061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w4so44052748wrt.5
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ICila3w9bfvENDGrDK3/90N1VTO1RwjzN2ngo0a/tfI=;
        b=Ee4RHyuAuNRKDVyl9fGJ4NYG4bhrIL31yp8l+uV2/ERs2waDxP7tDvAs3HR5mSB69F
         xGaB6sRZc+EKI7Ifjy7WytBHFPPHujiQDmz/2LzuilJk5TfRySU3X/+pISrV8k1lnLOs
         YG3xVRl8YLVHNQnSJC+jnrxHHn3JH1KG+6IbWCuyID4h7C+r5CfaK29038K7vpIzvnpw
         rSmr7KFaMtvSOYKl8eSTb3xovJZPYbXl+JHnCYr7uEoENxUX8sb+v7gPZnaN/SFoPqk+
         jNgOMyUsVht1yuKfTevdSN1roUG8Ajob3tasqI1TTDMo4nYqf+92tWOv8GBf+cSc+Zyo
         dbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ICila3w9bfvENDGrDK3/90N1VTO1RwjzN2ngo0a/tfI=;
        b=fEWWBLwnX8zjmZhwAmvjsM+bcNIF2vh8gXxY0ZIhk6MAi2WHQF4nQkaK/4qXhnEwih
         xHvOfJgOZzA6eZO0qacvxjv+5F7cujoBippzm23H7nwQ1+IPUzOFuHX+RhZAlaAGtFHv
         dgpwUsABqx/md5iYi2+7FclDR8HBdstmuOq81v9FBbPAQj+i4gtIkOOadaruxA8gi8zh
         DzyvDnIbdo/a4eBto2pjGrTLAxM7tTa4Eqhr7MNgGTmb2zigSfbKyqL3felKCd1aExxe
         GI4ytLaV1IiqZf4KcRHqRK+SrgzblaabvKsGLsyoHK+XcX7Qz5GRlfA8JqR+f4LsK5qJ
         QcCw==
X-Gm-Message-State: AOAM533rV37340Msr1M6fl5/7fei2RGhU5mK55dBykduT54U1uQRxPcX
        Ixr/2RB7Ls7zeDgp7ncKHBQ=
X-Google-Smtp-Source: ABdhPJzufyqoI6Buar2H/VQ0xGkUoK7rmeMcyvMRqdF2BIqahSLtfxcLOYBK08DJBSzCXNBg41MiCg==
X-Received: by 2002:a5d:6b81:: with SMTP id n1mr3622036wrx.265.1619172306327;
        Fri, 23 Apr 2021 03:05:06 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id t12sm8599481wrs.42.2021.04.23.03.05.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:05:05 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net 2/5] ice: add correct exception tracing for XDP
Date:   Fri, 23 Apr 2021 12:04:43 +0200
Message-Id: <20210423100446.15412-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210423100446.15412-1-magnus.karlsson@gmail.com>
References: <20210423100446.15412-1-magnus.karlsson@gmail.com>
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
 drivers/net/ethernet/intel/ice/ice_xsk.c  |  7 ++++++-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index b91dcfd12727..b0a58d463441 100644
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
index 9f94d9159acd..ec8d590bccdd 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -479,15 +479,20 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
 		result = ice_xmit_xdp_buff(xdp, xdp_ring);
+		if (result == ICE_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = ICE_XDP_REDIR;
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

