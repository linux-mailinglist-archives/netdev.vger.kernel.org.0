Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD2B3F9F4C
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhH0S4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhH0S4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:56:16 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C2CC0613CF
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:27 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id u6so5810881pfi.0
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pJ8GFZx7XOL6yF08w/X1W+vpgdS0xQQNLQv88RdbUj0=;
        b=kGNm3YMGR/erX0lA8oLgJHrqwRHUiFZyqAteRD1SmbdKQKaU/e8JcZtZfHCh0Lbl7Q
         PEQ51isGpyh6By24FEvId6fFLl3dgln4v9ZC0N5azJzwDJvvj0eX9U34aMFYoIBg5iAQ
         Jv48KXuuo5UH76V8ZD13rr6698ckOKWJOb8gFcUYNfJt5aDIhGkeW5IGe9CmJvfVR4Jf
         llFfRBzqCQb3QRKBJGR56LDT6YxlZwthPFGCM2hTWzkGmpV4y9yF7ykVlnakIx0M1S1J
         SgeeB5N/+7jiuAtn+E4kEGiVe+oeLCryuziXhipSoe3AXJR28BhtBiUcBhNqS2F6LiqA
         EQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pJ8GFZx7XOL6yF08w/X1W+vpgdS0xQQNLQv88RdbUj0=;
        b=XO83pvCPPQRltpCh2WdUOCkl5E1mm+Owewl5AuElTp1YAHTNb+9drkv9V3nRS2Uvzq
         7i9i2rnBMMbpIqkDtDKK2sGaygTQ0tA7ThjJJDGdgz+q0lfdlNGRwQt62cMXNgNPISmq
         N0cHHjHSmboDX9rPl/M4oIFl18EDipfhYW+MD8BoBxn00/SU0OcUYMGKnz+AA5MlIpx+
         UjgPkQyzaAOK/vSIkLzqaJ2pF3NmUMnVsNDT7eTg9jf3HWz/CkKaBY/0rFjhZKVh8E/b
         c8ds4QZF2QCf+e8tX0Q5n+XiGfS3cHjBiD3K3Dx3qmpBsBtJuJjRM7/DHO/BJpTYumYO
         0fqA==
X-Gm-Message-State: AOAM530TgwBiOx8vC7k23x0AagxQzcf/EHiXdbCNXDriQzLlrXiKjGU7
        mwn5hDVC8vJu6IkHl4y7Au18Rw==
X-Google-Smtp-Source: ABdhPJx0L03x8XVAj5387Tp0GREX+wC+U7eo8cJFjYPuKKzMiG2vrCQ9ga7wCW13Gh7icb/nif/Fpw==
X-Received: by 2002:a65:62d5:: with SMTP id m21mr8988105pgv.124.1630090526942;
        Fri, 27 Aug 2021 11:55:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f10sm7565975pgm.77.2021.08.27.11.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:55:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/6] ionic: add queue lock around open and stop
Date:   Fri, 27 Aug 2021 11:55:10 -0700
Message-Id: <20210827185512.50206-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210827185512.50206-1-snelson@pensando.io>
References: <20210827185512.50206-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the queue configuration lock to ionic_open() and
ionic_stop() so that they don't collide with other in parallel
queue configuration actions such as MTU changes as can be
demonstrated with a tight loop of ifup/change-mtu/ifdown.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d69c80c3eaa2..1d31b9385849 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2233,9 +2233,11 @@ static int ionic_open(struct net_device *netdev)
 	if (test_and_clear_bit(IONIC_LIF_F_BROKEN, lif->state))
 		netdev_info(netdev, "clearing broken state\n");
 
+	mutex_lock(&lif->queue_lock);
+
 	err = ionic_txrx_alloc(lif);
 	if (err)
-		return err;
+		goto err_unlock;
 
 	err = ionic_txrx_init(lif);
 	if (err)
@@ -2256,12 +2258,15 @@ static int ionic_open(struct net_device *netdev)
 			goto err_txrx_deinit;
 	}
 
+	mutex_unlock(&lif->queue_lock);
 	return 0;
 
 err_txrx_deinit:
 	ionic_txrx_deinit(lif);
 err_txrx_free:
 	ionic_txrx_free(lif);
+err_unlock:
+	mutex_unlock(&lif->queue_lock);
 	return err;
 }
 
@@ -2281,9 +2286,11 @@ static int ionic_stop(struct net_device *netdev)
 	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 		return 0;
 
+	mutex_lock(&lif->queue_lock);
 	ionic_stop_queues(lif);
 	ionic_txrx_deinit(lif);
 	ionic_txrx_free(lif);
+	mutex_unlock(&lif->queue_lock);
 
 	return 0;
 }
-- 
2.17.1

