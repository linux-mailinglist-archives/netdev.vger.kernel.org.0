Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F5F187357
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 20:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732443AbgCPTbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 15:31:45 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55700 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732385AbgCPTbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 15:31:44 -0400
Received: by mail-pj1-f66.google.com with SMTP id mj6so8717289pjb.5
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 12:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aOHArtyyCSR0pXyrFJ4sZvmpPZLW125U9f5d+4rorm8=;
        b=roHInm26NGUxGjRoh4ZYM0OoElihxZ+QRGvCiCknvIm5IHnncJvrT+skBw0LetOiXu
         kH6+2cG5he0z33F2Nx62GEzdPQfmCn7hnJpQq3ICI8X+dk3fFnyczPFJaxzzQ4TOivqq
         Zk6rRJFA/lj9mQO2zb6B6EcYaPKrG0ZaCh5xC73wXOwLrguEc2MR4w3w3CgA782lJkdS
         0N0aIsUgKSGhgbts4Czpd1N0qEaXWp25nlDFuYhCrhbnbxOlAOEhUBxo2hUGpJeKp68z
         6vPOqscSkaK5PHw5OYlrR4B8O0dpi6vMRNZbLOXbuQl4mn0yDTSCeSpB5YePj3d2VhfE
         rG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aOHArtyyCSR0pXyrFJ4sZvmpPZLW125U9f5d+4rorm8=;
        b=ASBmBwYUV4bV4sjtTIuaIi0gaY32Btg3WlxmSeIDYndud8yhdDNACfbUM9MgoNiq74
         PWyHim7VDIILM3u7x/WYDMsdgcoCC5D9/HbCQuNWPxMALxuFyiGj22+aX81ALIXhs9EU
         aAxq2jIRIfS03b/SIQI1F8xmCw299nTs/OSlWqSdWVYvShnVp2MPM93KjkTPE/AnoBhb
         XO5gaDepFxxqlL/Va1qrctUhdi3uSnfzfhRc+AGUQwFiQ2/wT3eJI1crnrSPMLSqJ9zY
         8vf/vfLPeV3SBcDe3OVkR4Fc5T/zXOHfLQcclnbwLhnMNXQQX65s5uYgcWOyv/iCCI7X
         9b1Q==
X-Gm-Message-State: ANhLgQ0ZH42WY5oDyc4BZB57IttOBwncXPQWQY+IAbWf4aONNSSk9Otp
        FwNq2OzxORaPBFYwu3TjncytcLJkHEE=
X-Google-Smtp-Source: ADFU+vtXPwzL+E0ohY1qEr0UARDXgIj3DwEB4A0uv6pCPMcs0w+RaewoQoCXyz5yPm2H7GRZAHTAQw==
X-Received: by 2002:a17:90a:1b22:: with SMTP id q31mr1112099pjq.109.1584387103398;
        Mon, 16 Mar 2020 12:31:43 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w17sm656413pfi.59.2020.03.16.12.31.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:31:42 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/5] ionic: deinit rss only if selected
Date:   Mon, 16 Mar 2020 12:31:31 -0700
Message-Id: <20200316193134.56820-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316193134.56820-1-snelson@pensando.io>
References: <20200316193134.56820-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't bother de-initing RSS if it wasn't selected.

Fixes: aa3198819bea ("ionic: Add RSS support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b903016193df..19fd7cc36f28 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2066,7 +2066,8 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	clear_bit(IONIC_LIF_F_INITED, lif->state);
 
 	ionic_rx_filters_deinit(lif);
-	ionic_lif_rss_deinit(lif);
+	if (lif->netdev->features & NETIF_F_RXHASH)
+		ionic_lif_rss_deinit(lif);
 
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
-- 
2.17.1

