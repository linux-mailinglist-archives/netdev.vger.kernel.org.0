Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EC936B224
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 13:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhDZLO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 07:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhDZLOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 07:14:54 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4114C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 04:14:10 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n3-20020a05600c4f83b02901425630b2c2so583628wmq.1
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 04:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kdhNnKDdgoIaQXXShKVt9ASG9VusPLEivumubGkDQnE=;
        b=Kui77ir32sgq2Abir6W8MW0kVChFzbBaBBfE4OSzM9zzdoubx3HW50UGOpAp2igBhT
         wjyEJL6Q8k18drCca6DWr/sgIz9ezPs94OD+W15SJ8q+N68IRle8LqvRJ5KT+SnpA7ih
         wFBkEyp1CXy0zbYMoe9XGLmqmlcZMXZ3LkeGXsfIwH7SzY1A+L8K3RBbnq4M2HUWPXm9
         qSpKZ+UVlyIBNapVxE90gHSt++hbZKj5fmFfRDcgH1RYH7Hh7lcuCsJjRXZfwnEAuck8
         Cakqw2qsI/HXl0U1t5kAwCkmBxzzMGWmd2dwEMhigjVH3HcKpP8MCiAs0gXmywv7BX+y
         Fhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kdhNnKDdgoIaQXXShKVt9ASG9VusPLEivumubGkDQnE=;
        b=LwrRWCCXCs0MA95BJBse6rn/QUSwom2U0RiYFCrDeGYGQPfVUk/IlOlFvXJsqKJm3x
         5m9ERq5tOftKRPb0/1PQe3ubJO+r9um+y72J7dpmfzPGj2M7NQKEMEjsxrmBr0NlyCWD
         VTH1+dHJzks328mZAfgsEGGW+fk+WtpjWpsh8xV5yl3ncX1yjTGVFlgeoDnBIM7qLXWn
         O+YMBr1cn3kT937QUKn3aAaJcDkmL5LBJMZm+ywjDetomN2YaGMswEb7VadILuVLO5GH
         zzmUjmefKejPqNpOtyGHT+8YU24p8sI8a9T6UJXnu14NGfuvN1Cm/gNIVlYv7YbiNSiq
         ywfw==
X-Gm-Message-State: AOAM533mFIdXVsNontoMddS0cJTMAuOCLH3qPGkjvTyI1mgJT3kF/mRM
        sgo0Z9MF9weFBCMybhJAMwc=
X-Google-Smtp-Source: ABdhPJxy0CXQ1Nd25BAJbHtaIFQ0eXR8IScaqEOODqifCTThs7SCPfP9AE7rwy2HKziSd61qMFgadg==
X-Received: by 2002:a7b:c3c6:: with SMTP id t6mr19619895wmj.42.1619435649657;
        Mon, 26 Apr 2021 04:14:09 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id m184sm5118600wme.40.2021.04.26.04.14.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Apr 2021 04:14:09 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH intel-net] i40e: fix broken XDP support
Date:   Mon, 26 Apr 2021 13:14:01 +0200
Message-Id: <20210426111401.28369-1-magnus.karlsson@gmail.com>
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

The skb pointer was used to store the result of the XDP program by
overloading the results in the errror pointer
ERR_PTR(-result). Therefore, the allocation failure test that used to
only test for !skb now need to be extended to also consider !xdp_res.

i40e_cleanup_headers() had a check that based on the skb value being
an error pointer, i.e. a result from the XDP program != XDP_PASS, and
if so start to process a new packet immediately, instead of populating
skb fields and sending the skb to the stack. This check is not needed
anymore, since we have added an explicit test for xdp_res being set
and if so just do continue to pick the next packet from the NIC.

v1 -> v2:

* Improved commit message.

* Restored the xdp_res = 0 initialization to its original place
  outside the per-packet loop. The original reason to move it inside
  the loop was that it was only initialized inside the loop code if
  skb was not set. But as skb can only be non-null if we have packets
  consisting of multiple frames (skb is set for all frames except the
  last one in a packet) and when this is true XDP cannot be active, so
  this does not matter. xdp_res == 0 is the same as I40E_XDP_PASS
  which is the default action if XDP is not active and it is then true
  for every single packet in this case.

Fixes: 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c")
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 06b4271219b1..70b515049540 100644
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

base-commit: bbd6f0a948139970f4a615dff189d9a503681a39
-- 
2.29.0

