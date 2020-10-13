Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAF928CB98
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbgJMK1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730814AbgJMK1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:27:12 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139A4C0613D8
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:27:11 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f5so269231pgb.1
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FN+YKdDgSUjsd9TeDWmG2gdywodGyUIcs86hwY2qLts=;
        b=Lg3pcwQuVQjOIHBSXSzVayFy/A1GDWBwmja6ZrcbnXD3jVL+TmdqYedBPHFS7PRWAO
         lwqqx1235itn8zsPrnzLS/d42EVhXas3hvag/uuS84OtjEBEDiHWg/bXDMd36GCX5Zok
         Xyp78HEKl+H4/khPo1kyyRqdqWzy5A71dBUihPXMIRy1FgAPrLdl9fS6+YYKOs1hzfv1
         IhTs4cbrP8S1I6oRXKaVsg6mZc5glKlXIqP5EgRTGoDJemDpNVbcNesZ0qOzLp4XV9/b
         FKAic3VK6I9YxexhCxoYw97rG+dJT49lCa9ioIOTVpDjG/Zl00CUmYukJkOplMqig9il
         Z02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FN+YKdDgSUjsd9TeDWmG2gdywodGyUIcs86hwY2qLts=;
        b=ZA5462+kLQMRffMplGX1gDV+yQheFs3nHjS1jQKuzndH+l+ub869Gs+XRjdXofmIlo
         ce9pJgAurp6ZUvwwGsKkMEVhKLXD/7PmQm59s7oLBnFx3nmrqJ1W3s1rfTrGohV2DXCs
         t0fCU3W2rYzYSdW2DViZJsSGt74rYCehn5rwBOh+N7jWdhkOeElhOM9rhgPHvJ43f2ba
         fDvzDZ57Ewz00V+wuRyYUbqnGqEK9aVEBEh1G2H2jUhMgpVMqT9uh8/NyFOj5glJUDWJ
         VJQctwDqYFeIaJh5YvJ+Vw7RhGBkVqb6VswSRAZR8jW0u0h/c4xV0VxVetb9LkdROL1k
         REtQ==
X-Gm-Message-State: AOAM531ofbQt62MDUVtq3KjJ55zOBU7U+E8O1mcFZ1tnmlj2trBVFmKL
        2gCejfP9XbmzA7vLVFeaQAD4AB+WnFqWig==
X-Google-Smtp-Source: ABdhPJwhHixu2iBKmlUqp3f7MlPaS3KJKEjeWaSwQcRyGK3fL0LeGAwWW6CUW28FPXT6pRX8YzhDIA==
X-Received: by 2002:a62:3815:0:b029:152:80d4:2a6f with SMTP id f21-20020a6238150000b029015280d42a6fmr26113601pfa.72.1602584830652;
        Tue, 13 Oct 2020 03:27:10 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id g4sm22034444pgj.15.2020.10.13.03.27.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 03:27:10 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 08/10] octeontx2-pf: Calculate LBK link instead of hardcoding
Date:   Tue, 13 Oct 2020 15:56:30 +0530
Message-Id: <1602584792-22274-9-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

CGX links are followed by LBK links but number of
CGX and LBK links varies between platforms. Hence
get the number of links present in hardware from
AF and use it to calculate LBK link number.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 8 ++++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index d258109..fc765e8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -531,8 +531,10 @@ static int otx2_get_link(struct otx2_nic *pfvf)
 		link = 4 * ((map >> 8) & 0xF) + ((map >> 4) & 0xF);
 	}
 	/* LBK channel */
-	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE)
-		link = 12;
+	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE) {
+		map = pfvf->hw.tx_chan_base & 0x7FF;
+		link = pfvf->hw.cgx_links | ((map >> 8) & 0xF);
+	}
 
 	return link;
 }
@@ -1503,6 +1505,8 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.tx_chan_base = rsp->tx_chan_base;
 	pfvf->hw.lso_tsov4_idx = rsp->lso_tsov4_idx;
 	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
+	pfvf->hw.cgx_links = rsp->cgx_links;
+	pfvf->hw.lbk_links = rsp->lbk_links;
 }
 EXPORT_SYMBOL(mbox_handler_nix_lf_alloc);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index d6253f2..386cb08 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -197,6 +197,8 @@ struct otx2_hw {
 	struct otx2_drv_stats	drv_stats;
 	u64			cgx_rx_stats[CGX_RX_STATS_COUNT];
 	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
+	u8			cgx_links;  /* No. of CGX links present in HW */
+	u8			lbk_links;  /* No. of LBK links present in HW */
 };
 
 struct otx2_vf_config {
-- 
2.7.4

