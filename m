Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD60A2D725D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437208AbgLKIzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437210AbgLKIzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:55:07 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18268C0613CF;
        Fri, 11 Dec 2020 00:54:27 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id b5so494863pjk.2;
        Fri, 11 Dec 2020 00:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yZ75xyIkYY2oyliGKy/kPO2HTdwqgp5NO/99uf86ec=;
        b=ROw0UA02ywsGkPn7kSSwHAVdvp9wDbW+JhgIK7liM/qSUq6Zt9eoNGXw7QCHlfn/Ng
         S33J/zlVQ7Q/SwOFt+RZDVcw1FSBFI8bcCX8/ZTv4O/TGWskCz+gVUgXYbA4pSe/z7bw
         928HhUPMSAhKBRVbbfWvoJJ/Hk+iMBiJdml9fUMVuEpFMG94KJBaQ+MF2BLBe2iZ4FO3
         1zEmjED0Sj8y0MSsdtOiP2wZ89gJunMzDD4srONGN7w2YLFVNGLLKu4BOYtYJNn0RVlF
         bu97PNUR9aqIqEpfYMwZR4v/M87Mb1K4tUAHJhqTIxx3f7vTmoDIjjq4+nCrUDIN3qIs
         r1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yZ75xyIkYY2oyliGKy/kPO2HTdwqgp5NO/99uf86ec=;
        b=VGH7iPVU68a2cYCpBHHFifva06yxE13Q3s3z7bWxEkTmHYk5TuqieXclSFCHSKuK8q
         xFqbOEWtrPCSNmnl6MbbIi0aC83NOI57kb6NQ0mKqlOd9K7u9Y3IxIYiNzmv9zQ6Z02V
         KDHY31SjKDeHZekXkFpsY8ETmmJbc70PWLP3ltNASadEMWvT5uDoeQK3P2g81bAAI+Aq
         1egKb0hUvvYuyjPOiC64daBmJLqI7GO7CixuVp12Za3CTuFLddLR7A3k0OJhImRzOFpL
         dp6ME0uzMWB84Cx7UQKBvkJzgCdXvTco7I6x05olSBS1DNG2xCqSznruEKl8Oa2MfR5m
         gzEw==
X-Gm-Message-State: AOAM530epRz4HLHWptN/QRBSFcbtwUJqOD6B4O+ejD4NdzzN3f0FMTrv
        7MslOCFeS2kRy6n5EEWE1cCOv7eppoXw2Z0/
X-Google-Smtp-Source: ABdhPJzZiNk+nx5/VXgGKYZCOtoEmFWZAg7nFAqxzz+uOiw+rPtJJInQWIGXvqzHeV0BDXfczIdFNQ==
X-Received: by 2002:a17:902:900a:b029:d7:d966:1a44 with SMTP id a10-20020a170902900ab02900d7d9661a44mr10296006plp.8.1607676866585;
        Fri, 11 Dec 2020 00:54:26 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id x6sm10509408pfq.57.2020.12.11.00.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 00:54:25 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Subject: [PATCH v2 net-next] ice, xsk: Move Rx allocation out of while-loop
Date:   Fri, 11 Dec 2020 09:54:10 +0100
Message-Id: <20201211085410.59350-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Instead doing the check for allocation in each loop, move it outside
the while loop and do it every NAPI loop.

This change boosts the xdpsock rxdrop scenario with 15% more
packets-per-second.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
v2: Fixed spelling and reworked the commit message. (Maciej)
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 797886524054..39757b4cf8f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -570,12 +570,6 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		u16 vlan_tag = 0;
 		u8 rx_ptype;
 
-		if (cleaned_count >= ICE_RX_BUF_WRITE) {
-			failure |= ice_alloc_rx_bufs_zc(rx_ring,
-							cleaned_count);
-			cleaned_count = 0;
-		}
-
 		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
 
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S);
@@ -642,6 +636,9 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		ice_receive_skb(rx_ring, skb, vlan_tag);
 	}
 
+	if (cleaned_count >= ICE_RX_BUF_WRITE)
+		failure = !ice_alloc_rx_bufs_zc(rx_ring, cleaned_count);
+
 	ice_finalize_xdp_rx(rx_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
 

base-commit: d9838b1d39283c1200c13f9076474c7624b8ec34
-- 
2.27.0

