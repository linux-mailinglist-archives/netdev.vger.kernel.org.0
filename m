Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB2E186178
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgCPCOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:14:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45498 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbgCPCOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:14:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id 2so9031068pfg.12
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 19:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r24pwLsqe4IL9cwD42vns1YbYLcwPM/Kba0AWXlRiXc=;
        b=sw2JLKKkPYBXonXI68pgbT2/biAOoSgpGInMu29YZTtQ484TtSl8zagJpxYpxG8CWA
         RSDlPbkH6soM3W3EPESjH0xKTjMz025v3mdbOG9BQeJiw6lqpqkiQ1yyw+MITwoOXLQ9
         HYxb6IEyC5zRV6Ow6kHCj+GH1jeQiJoCdG37EkwIci7xshn/Bu4NTeTJs7B8jTIvB3sL
         3DQdj6hRYv/itce4zWrcbryFFJgjIlC7wYDkRdbyaWIJDO2WmCn9K3gyWa3QlB6N4bm6
         nii8Ae3z56QaSot3lTacszWlknMc82/6ou5Jl0v5/YED10DMD7FcqhkZYKM9Vf1knNGL
         AUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r24pwLsqe4IL9cwD42vns1YbYLcwPM/Kba0AWXlRiXc=;
        b=W+rrTkK4EkUXf2bHMFMtK4/vi/oqAIBqRlZYMeoJQAzbV1s09ju+z23/8WRmMrjsY/
         U1xdQjFBb8NFvlJg2U05WkvahPjhTBjv/J8EyUk/9mJSzHqWsokmP6gF8H8LgZMAcMxO
         8kg7gowhLvw7Nuc1EK4p/Rn8ypEFTVUeNySjFug6nfPbqLRguuNQ0ctu0Wa7N+O1x8va
         dFc2ZX1Ds4t3XPO+tE3rxzSx1kC2PFvqIvlgnkxBFVd8BxttYYt9cTAJjIWRxs9QhUdB
         Kf++8D2w9iuGnkySjVoVbOoFMtaEejkfMWI4o87sCZh2/DgTbpRHV/CU2jcUAyfhArAP
         IDrQ==
X-Gm-Message-State: ANhLgQ05cO/PBSJgKumKqywzjzOcixMkg0SgC1TGEBfXi7UgBj5oqMh4
        myfXalo3wUhqOII/RgYrpi1r6X2WTqM=
X-Google-Smtp-Source: ADFU+vsl0KXgiB4+yG/27y82GTLClV72hwrRmJteQE6KWSpaH9Jy3LiI/NizdigO/k57ty2w5JQMnw==
X-Received: by 2002:a63:74b:: with SMTP id 72mr25300285pgh.320.1584324878539;
        Sun, 15 Mar 2020 19:14:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p4sm4386142pfg.163.2020.03.15.19.14.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 19:14:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/5] ionic: deinit rss only if selected
Date:   Sun, 15 Mar 2020 19:14:25 -0700
Message-Id: <20200316021428.48919-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316021428.48919-1-snelson@pensando.io>
References: <20200316021428.48919-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't bother de-initing RSS if it wasn't selected.

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

