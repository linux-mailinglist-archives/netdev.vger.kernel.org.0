Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F662D5A52
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgLJMUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 07:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbgLJMUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 07:20:14 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627BAC0613CF;
        Thu, 10 Dec 2020 04:19:34 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id bj5so2683265plb.4;
        Thu, 10 Dec 2020 04:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euIMWqXmb35zpjlHIisHFKgDZZP7z0+WRl9qw72DjtA=;
        b=FdiJ6B2Q0xa2wOJ2qvjoH8EDGRT+MYF/tXY9LAPkMSKTWUSwPtNXkdppnItTtzcOIP
         52rrJMDnHaBhKDAoVvWRKPQK692txMvbb024AaAPy2JZzxy2UF2RqTs2FPRYQfRc4WDx
         SCwphnAYXTPQ2VPxU+hSCEhMc2Lpc4L2F5uou2ICoKyWJCtS8Yat8U5fj37IUkCeNx35
         sXYHMCD5P1rgvl+FDB5F0xFfwBCcnYgaXGWyI7DArr8RFT0GkUAAU+rh9mQj8z7vD348
         WefOTHo0Z5YyV52mXkEH2BbOPqMStCi7nxESf3jaIl8vnbI0KsDm3GARLylfdiSrrf23
         MWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euIMWqXmb35zpjlHIisHFKgDZZP7z0+WRl9qw72DjtA=;
        b=nZ3tIxMB+5xJ/e4HitBkqVpy8PI9Og/XYtcj4JTr9svSQl3x0yogOD2eTd65hKPHeq
         bS4nvg+DH6+AMq34lZl/GsqlYnqupGDDxuu+5YD7VPd/rNVKh4yERoRVe/f1YoZSNgtv
         Ui73GOi9UH2YX0cPJAhJdMmzawRhjXdGbplWTGN9cAS9vWxSDmbg/KDTuImllTaXjamh
         UlzHLDllUDDl3nouKMCdR4x7tzr1yXI/J8y+prrRds8MfdbBS9fZaWF9y4MlCiQiwJGC
         0JOJjfFgOJ8ECdoFBJ5RCuksZoIvpMqeY5k4cNNrsxLS8QN90G+nXBOkJoU3ymBdDFYk
         Sm3Q==
X-Gm-Message-State: AOAM5338zQNRr66hy473aGAkVqZjbwUuRpVSMb/2rv+tX6SSZSlbJ00M
        JSQ1BaIDpkEhmlhR1rnumEke1l/9FE08qlSk
X-Google-Smtp-Source: ABdhPJxxXJ66n/tteNPghYVge4G9CwAIkXxi+Ru706CyI0rH6S2aSkipg4KIA3FBiHEV9qS/TyKUUg==
X-Received: by 2002:a17:902:bf03:b029:da:fcd1:b10 with SMTP id bi3-20020a170902bf03b02900dafcd10b10mr6050373plb.0.1607602773962;
        Thu, 10 Dec 2020 04:19:33 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id i123sm6411666pfb.28.2020.12.10.04.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 04:19:32 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Subject: [PATCH net-next] ice, xsk: Move Rx alloction out of while-loop
Date:   Thu, 10 Dec 2020 13:19:15 +0100
Message-Id: <20201210121915.14412-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Instead of trying to allocate for each packet, move it outside the
while loop and try to allocate once every NAPI loop.

This change boosts the xdpsock rxdrop scenario with 15% more
packets-per-second.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
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
 

base-commit: a7105e3472bf6bb3099d1293ea7d70e7783aa582
-- 
2.27.0

