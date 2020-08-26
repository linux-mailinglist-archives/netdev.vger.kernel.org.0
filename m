Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550BA252671
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHZFJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgHZFJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:06 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64974C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:06 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id t14so444811wmi.3
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wJzfwh+I7Qkxo/PgUrftLIVDHNWDdDaKowVOP9U2PTQ=;
        b=Tx0YAM6SaRYTUpwQFDa+1dSRozhhvFh87DWGNUTSuC79Urd3AIuwAgJsP2KnTgfGpg
         FqThNSMUm/U5IR2VzkUxUnTRiszj+hlKSwAa4zyzkahAfRsEPWXN3CQxmyOp6VlgK2EK
         JgKXDpEtUUM8WZmaiDz3Q+9gfNUsQxIJlyJik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wJzfwh+I7Qkxo/PgUrftLIVDHNWDdDaKowVOP9U2PTQ=;
        b=o1OantJGRkexTYsKdP+6D6YWNQqArmvAC15Xue5z3Yy6xJm1ATMNGzPk1wEM5J8FTC
         e5tBQocAiHo9TEUSR6Yt9AJD+7FFgpz2L7/yWCw+bY6sX4ODx/vyiwq846SKFbbcXtFz
         HFzbAzfNVqM86AjbmWAe+gsSL+Q5eI/9nW8mNy2I4leU41eF/ydXXVbSqC2ONLVnxteI
         rSbke8GZwRWNNMKi2kVay7s8+1h2rUo732p0LaUdTOYuxpyWDeF5H5u4G3pyUDwcqygM
         Dhw3kEX5a6JlLQ78Oezv0ROKMCspTkCIjeU7HxrQpixZu7ttjRPVPAXg5nsl0PmKfks1
         Dxfw==
X-Gm-Message-State: AOAM533vjxgNAV0CnlNw3t0QOz5/p4NEY3HvdOUms0F+Yq3pT0D7jFWH
        ODHKBzpdT67Mhz2BWSvqVCZOJw==
X-Google-Smtp-Source: ABdhPJykWbOTvLJBe0CHzVrzyPOfVVg8hINZO9kZqFrfKn4UF/mDzsZaVbtSJriOJwBKkaXLGbVy8A==
X-Received: by 2002:a1c:a446:: with SMTP id n67mr4988654wme.174.1598418542435;
        Tue, 25 Aug 2020 22:09:02 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.09.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:09:01 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net 1/8] bnxt_en: Don't query FW when netif_running() is false.
Date:   Wed, 26 Aug 2020 01:08:32 -0400
Message-Id: <1598418519-20168-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
References: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

In rare conditions like two stage OS installation, the
ethtool's get_channels function may be called when the
device is in D3 state, leading to uncorrectable PCI error.
Check netif_running() first before making any query to FW
which involves writing to BAR.

Fixes: db4723b3cd2d ("bnxt_en: Check max_tx_scheduler_inputs value from firmware.")
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 64da654..3890c1a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -806,7 +806,7 @@ static void bnxt_get_channels(struct net_device *dev,
 	int max_tx_sch_inputs;
 
 	/* Get the most up-to-date max_tx_sch_inputs. */
-	if (BNXT_NEW_RM(bp))
+	if (netif_running(dev) && BNXT_NEW_RM(bp))
 		bnxt_hwrm_func_resc_qcaps(bp, false);
 	max_tx_sch_inputs = hw_resc->max_tx_sch_inputs;
 
-- 
1.8.3.1

