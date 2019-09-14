Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428F5B2989
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 06:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfINECA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 00:02:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42117 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfINECA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 00:02:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id w22so19278647pfi.9
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 21:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YgcHG1IRqaLBbLPUZAPJS7Pg0IrSQJTxzdC0A+kiCTY=;
        b=OHnrDk5v27wRwEP/3T1HaK7Qs05qzdJVuulpTVs/R94lDdT6WEcMT0n98oTfXsue/W
         /DfLRLZ615AQqPbsD8/ktDORRO4lRXswXmH9VT6ilYjB8cV9HCstbnpXHkGBMs7uYKzY
         MMlygwQVG8/+CNBEA/bz77sVJjHNLl/5dFZwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YgcHG1IRqaLBbLPUZAPJS7Pg0IrSQJTxzdC0A+kiCTY=;
        b=QIaxPMqN4Llv8FXDwGHchnpIqQqRg4tjalpNtQyCD/I/XWPgsVIaayBb3CsjJqgInT
         sDgxuz2H3dGNQ2ZIuN8FD7tKPEwW83YOSmx/bfMsLGPWD2t5U7WIGOFU2E1eShjdft3K
         Bfp1T1ISFmkGka4LImHzUgGbt6emSRvMwuLMONxRWgQReT78gnpaRdHk2Xiri27ylcw1
         KX+0z1QJlWdNBLE8JKlXoX/AT0XG0Ow/A3O0O4zmvMgmH95NRdAYbTU/dn8Dx7UYNFyb
         Be3F5IKrDgNd/mE9DonRg5m/9V1qciUA/zYaOZhLZ6e9EpZm9GloWKvOlT0LhkqzRJpK
         cBlA==
X-Gm-Message-State: APjAAAXjcLSLoztvp/bgb2h6tmy0+jfAC4wbhybEc2sWAiUoqNeT1R2r
        y+G3XVH8e4B4obhKD2Tsh0T8zhVUjog=
X-Google-Smtp-Source: APXvYqwN0foToTe9wkpC92YkPqKqTO5UZqcvtgPH7gaUgi7RYzVdLmr9gohlE6pRlFlFSPB7JNoFIw==
X-Received: by 2002:a17:90a:db04:: with SMTP id g4mr1099616pjv.51.1568433718932;
        Fri, 13 Sep 2019 21:01:58 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a29sm52363908pfr.152.2019.09.13.21.01.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 21:01:58 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: [PATCH net-next 1/4] bnxt_en: Don't proceed in .ndo_set_rx_mode() when device is not in open state.
Date:   Sat, 14 Sep 2019 00:01:38 -0400
Message-Id: <1568433701-29000-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
References: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check the BNXT_STATE_OPEN flag instead of netif_running() in
bnxt_set_rx_mode().  If the driver is going through any reset, such
as firmware reset or even TX timeout, it may not be ready to set the RX
mode and may crash.  The new rx mode settings will be picked up when
the device is opened again later.

Fixes: 230d1f0de754 ("bnxt_en: Handle firmware reset.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 402d9f5..58831dd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9557,14 +9557,16 @@ static bool bnxt_uc_list_updated(struct bnxt *bp)
 static void bnxt_set_rx_mode(struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
-	struct bnxt_vnic_info *vnic = &bp->vnic_info[0];
-	u32 mask = vnic->rx_mask;
+	struct bnxt_vnic_info *vnic;
 	bool mc_update = false;
 	bool uc_update;
+	u32 mask;
 
-	if (!netif_running(dev))
+	if (!test_bit(BNXT_STATE_OPEN, &bp->state))
 		return;
 
+	vnic = &bp->vnic_info[0];
+	mask = vnic->rx_mask;
 	mask &= ~(CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS |
 		  CFA_L2_SET_RX_MASK_REQ_MASK_MCAST |
 		  CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST |
-- 
2.5.1

