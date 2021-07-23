Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643913D4024
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhGWRWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGWRWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:22:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083EEC0613CF
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:05 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mt6so3384614pjb.1
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B4gD6RkuFUXJmOd+al+n+k1dHsLJ7F2zQyNlG44Ayj4=;
        b=13eABjQX8XbDWFYywmnCH8lXy7YZCcOwrAkqivjFP4ryyOIrRUX4PhrDybyZWqvjcg
         c2s99xTypdbIDqsWdYY9QTVo22i8kyjlIZbZBy77WVjELLtzfqvUP5lfOUwtJUAz1OiS
         LS7jPqk8TX/zbQ/24YGngeXiK4QBOr7X5i1is5Z68uwg3iRvaU9mKn38+dkeK0p734lM
         J4pTwvhSounvBDyN/FIfYaxLoFhwFuY5pSzWB73MTVLqTttW9zjbxlqfrQl1DjGnGu92
         PUfLhiwFA3i0N9omWIgtqi3HZluhCi40nkwqzHWPIVsVKe/Bn5/p+LlUZT56V+tSr1+T
         g+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B4gD6RkuFUXJmOd+al+n+k1dHsLJ7F2zQyNlG44Ayj4=;
        b=CCUTffo6drThcweTooijUi2MWgvm6bLmokB6SOl/VVvw7gbjPo10ACYGblwfe1RLL9
         DaaQj5a1T9bzbqZAcAGeRDZ9ksogZsWn2aQbhiI3Jq2nCO56ltmhYxTaYh1mcKrnBhao
         VCKWiAN8oolxyrBgUgRLCMbCn7Ehm4vBiitALegnzQxWaxZSl0zSFzmT/g4sJtxqrNZ2
         q3C9IDs3Tdq3I00y/YgcX58SnNhphVMh22ZXM6znsSWt0UxIjEZwRlCcs00Pv3LsZr4Z
         X4fvKjkbEgcEqOLZh8Qaa0KJ/ZwUl2WAS6Wqr4nVfKg4H+9NM6feAN3ML780rdcyHUZ1
         dyDw==
X-Gm-Message-State: AOAM533P6NAHvxkC60HBuYZvGDIAsma/0LBYQIzAKNvInAoOJYpPJNhn
        OmwHK4h6uhe19cg4FzDKHdbBF61XNCRkgw==
X-Google-Smtp-Source: ABdhPJxgIa3RX/y3hhvdfVTZIsIhEOHhOLK65A1Z3ANJMpvSNnK5Ye4uLm0CVqZmDGNXq/0c5xg4aw==
X-Received: by 2002:a65:45c7:: with SMTP id m7mr6022415pgr.282.1627063384607;
        Fri, 23 Jul 2021 11:03:04 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c23sm19437934pfo.174.2021.07.23.11.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 11:03:04 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 5/5] ionic: count csum_none when offload enabled
Date:   Fri, 23 Jul 2021 11:02:49 -0700
Message-Id: <20210723180249.57599-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210723180249.57599-1-snelson@pensando.io>
References: <20210723180249.57599-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Be sure to count the csum_none cases when csum offload is
enabled.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 1c6e2b9fc96b..08870190e4d2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -274,12 +274,11 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		}
 	}
 
-	if (likely(netdev->features & NETIF_F_RXCSUM)) {
-		if (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC) {
-			skb->ip_summed = CHECKSUM_COMPLETE;
-			skb->csum = (__force __wsum)le16_to_cpu(comp->csum);
-			stats->csum_complete++;
-		}
+	if (likely(netdev->features & NETIF_F_RXCSUM) &&
+	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC)) {
+		skb->ip_summed = CHECKSUM_COMPLETE;
+		skb->csum = (__force __wsum)le16_to_cpu(comp->csum);
+		stats->csum_complete++;
 	} else {
 		stats->csum_none++;
 	}
-- 
2.17.1

