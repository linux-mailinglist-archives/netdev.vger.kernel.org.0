Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF07252670
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHZFJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgHZFJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:08 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8630C061757
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u18so448247wmc.3
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H/dopKxvhfi6bFovgPH6TA4CbFSDphMxDNj9s6UVnO4=;
        b=gKO3czjfXTiDVw8Q3urP4vBkpw8bnBWx+m97TNWiUdNRtbZyh1TPbNP74SFbGKjaaJ
         DpkxJayOlTXDmvmZy9xKZXlqT3ngUWjwusvdv11oHfNLt3j+a/eAPNiOSQbM4kAv48Ag
         hvS2czx8jlOSGKlEVYTts0lEmSAtRr/scXxG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H/dopKxvhfi6bFovgPH6TA4CbFSDphMxDNj9s6UVnO4=;
        b=m5x+PrWMY5kdzhT1wbZEMuxmv33vM9o8w1JaH5q49dMmjNUOSpdpHa9wKAgRl7IDFa
         knjt65gVryZgUUs+vU/ShlfNBHG4f9WRRc82Dy867BAzXH6uOYs+i4LYRSARlnbsVhJW
         fdzyO1+beP/UjQOx8Tz9MGETjo3G5roNAulZ1y1R+3ADLLL0i/hlCVESPEnqiEOeUgj0
         8k/NNfuF9LmQfm+i6/6WAt/awpX6DXiZYbnKmMkcVY4GGmwKyHo4tbCWaZvinhd3slvN
         TWTS/f2ClTXw494eRSAcAiK9UzGIiRAFlabetEAnkDnsN+ijerHN/c4mVPdRlhwX0RlB
         tpeQ==
X-Gm-Message-State: AOAM5325SNmxXx4fvIERgfXP2dyIgIRN5jMt6yZMd0jnOYMuK6ZqCLl/
        HnkTKN9RWEbGtDwa4xy838a/JYikb+Nb1g==
X-Google-Smtp-Source: ABdhPJyzvIexkdpAXqcdGRporOWEdchtkw2upZuR/ULu33U2AikchNMyeQtn9mp7xbcno/TXXu5Q5A==
X-Received: by 2002:a7b:c941:: with SMTP id i1mr5048809wml.73.1598418546091;
        Tue, 25 Aug 2020 22:09:06 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.09.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:09:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/8] bnxt_en: Fix ethtool -S statitics with XDP or TCs enabled.
Date:   Wed, 26 Aug 2020 01:08:34 -0400
Message-Id: <1598418519-20168-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
References: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are returning the wrong count for ETH_SS_STATS in get_sset_count()
when XDP or TCs are enabled.  In a recent commit, we got rid of
irrelevant counters when the ring is RX only or TX only, but we
did not make the proper adjustments for the count.  As a result,
when we have XDP or TCs enabled, we are returning an excess count
because some of the rings are TX only.  This causes ethtool -S to
display extra counters with no counter names.

Fix bnxt_get_num_ring_stats() by not assuming that all rings will
always have RX and TX counters in combined mode.

Fixes: 125592fbf467 ("bnxt_en: show only relevant ethtool stats for a TX or RX ring")
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 5d1a0cd..1bc5130 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -472,20 +472,13 @@ static int bnxt_get_num_tpa_ring_stats(struct bnxt *bp)
 static int bnxt_get_num_ring_stats(struct bnxt *bp)
 {
 	int rx, tx, cmn;
-	bool sh = false;
-
-	if (bp->flags & BNXT_FLAG_SHARED_RINGS)
-		sh = true;
 
 	rx = NUM_RING_RX_HW_STATS + NUM_RING_RX_SW_STATS +
 	     bnxt_get_num_tpa_ring_stats(bp);
 	tx = NUM_RING_TX_HW_STATS;
 	cmn = NUM_RING_CMN_SW_STATS;
-	if (sh)
-		return (rx + tx + cmn) * bp->cp_nr_rings;
-	else
-		return rx * bp->rx_nr_rings + tx * bp->tx_nr_rings +
-		       cmn * bp->cp_nr_rings;
+	return rx * bp->rx_nr_rings + tx * bp->tx_nr_rings +
+	       cmn * bp->cp_nr_rings;
 }
 
 static int bnxt_get_num_stats(struct bnxt *bp)
-- 
1.8.3.1

