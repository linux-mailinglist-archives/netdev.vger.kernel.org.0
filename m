Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABEB368FF2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbhDWKAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhDWKAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:00:46 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287C9C061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:00:08 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k128so25656495wmk.4
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZtqQ/fIkMXnlZlanfCmzb1tC9yrRL/luQiVuBdOzdFM=;
        b=NqM4bPpUOvdfwmVITdWymYy9HXL3KF45WsVkLA5Y8OXd7H96ME50+YB22M4Ldn73Y2
         WImCXmtwUIfV+z0UY75hfbNeordkoEK5it9VK1MgPJdLkJ3SXWA59VO0QAXTyClcVeTO
         n6HP+4jZv8J5spzm2UrewFRLadNNEsJJoh/KR75oxDRAJXaV5b1cpoaYBA82EXeJ4Nn7
         EW/3FgEqpbUNg1I9JeuAYI/KGkEEJqHF8PfcrBFaSM55xdt+JH/R12Dgatv2GHFh7MDx
         YTb6AajCP2NHws2O6YpetKzcrkoN4cduJ/QbJgsYscM/qWxo93tfq2Z+y18YEwI6+6kw
         HeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZtqQ/fIkMXnlZlanfCmzb1tC9yrRL/luQiVuBdOzdFM=;
        b=IcOMU+EbtTMYDJDS18aGic1zMBxGHWWFgH8tEaXKy53NDyOEdv1oDy942BKfNBp79t
         In8hm2SC8q+Kcu/85DDCVQ7psOVOR2cPbCHlTeIi+EngpkGhBQqc+2u7esDhKUOxpjrG
         VEFup7KxkP9Y2yidDphPgPR8mTP5Pu9MDhZSnyD6yTWNNUR04+ZqXHTgrjqQ/TntUKF0
         aG+sBjbHRDaxq9h+jFuuoYcvAEdsUZhUNy/jSU1MxTIyLUYiZe+dlfubIcQmSYhgggfJ
         pYEl40XFf1cldRTuwhMtBG97jbOR7zsyPEaHw6my3Nmrf8LCwwyM6s66HO9pSifA9vrc
         +nQQ==
X-Gm-Message-State: AOAM532jBcfsF38GwnFTZe4YLaE8YKf3bjlCvodLmz0iWFVK6sYunoXj
        +q9Hv0G8h5SdzhlVkR5qNuc=
X-Google-Smtp-Source: ABdhPJy98xK/2/EqIg1cNP1EzFamSR4COceu6JYV1Cgt3O9GiBfMBqML4+QxR30Ilz5sN1gbgRGnPA==
X-Received: by 2002:a1c:1dd0:: with SMTP id d199mr3319739wmd.54.1619172006911;
        Fri, 23 Apr 2021 03:00:06 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e10sm8317114wrw.20.2021.04.23.03.00.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:00:06 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH intel-net] i40e: fix broken XDP support
Date:   Fri, 23 Apr 2021 11:59:55 +0200
Message-Id: <20210423095955.15207-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Commit 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c") broke
XDP support in the i40e driver. That commit was fixing a sparse error
in the code by introducing a new variable xdp_res instead of
overloading this into the skb pointer. The problem is that the code
later uses the skb pointer in if statements and these where not
extended to also test for the new xdp_res variable. Fix this by adding
the correct tests for xdp_res in these places.

Fixes: 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 06b4271219b1..46355c6bdc8f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1961,10 +1961,6 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
 				 union i40e_rx_desc *rx_desc)
 
 {
-	/* XDP packets use error pointer so abort at this point */
-	if (IS_ERR(skb))
-		return true;
-
 	/* ERR_MASK will only have valid bits if EOP set, and
 	 * what we are doing here is actually checking
 	 * I40E_RX_DESC_ERROR_RXE_SHIFT, since it is the zeroth bit in
@@ -2447,7 +2443,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
 	struct xdp_buff xdp;
-	int xdp_res = 0;
 
 #if (PAGE_SIZE < 8192)
 	frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
@@ -2459,6 +2454,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		union i40e_rx_desc *rx_desc;
 		int rx_buffer_pgcnt;
 		unsigned int size;
+		int xdp_res = 0;
 		u64 qword;
 
 		/* return some buffers to hardware, one at a time is too slow */
@@ -2534,7 +2530,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		}
 
 		/* exit if we failed to retrieve a buffer */
-		if (!skb) {
+		if (!xdp_res && !skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
 			rx_buffer->pagecnt_bias++;
 			break;
@@ -2547,7 +2543,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		if (i40e_is_non_eop(rx_ring, rx_desc))
 			continue;
 
-		if (i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
+		if (xdp_res || i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
 			skb = NULL;
 			continue;
 		}

base-commit: bb556de79f0a9e647e8febe15786ee68483fa67b
-- 
2.29.0

