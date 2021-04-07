Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A03D357866
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhDGXUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhDGXU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:28 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9400FC061762
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:18 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id i4so133055pjk.1
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x/K6wJed0hbTMI3Iein/tFDJN8j04FfLnw2b+D/mh+E=;
        b=0OwH4cJzRymisNyO2E0OHyJ3pTHOmcbkl8tUTqW9QqtPAr6rDwaz2CnDOuTap+9a3C
         H8AWxC0GBVbdHA9aY/6N+KgJVQCk0Mk3lp5pwRU24o8wXoGtZPlOauJAjAiPydnrQ/k6
         ThO9cG3DfrwcGS14BWps808/R7j1rMK3LfoxH8W4xxmEbl0CulSAw/WE3e4ljwKHorDP
         tZUvTgJbN7jGNsTkOP6O5F3Fdn7d5bjAWZvHPCKjGhoiXLX8Dr01VRezy+6O9rSuzpXf
         xbxil11iJB26HMRUgaCe964bL7iZtD3uJVVIWjf8FHo4nTXnsnx6wFE1KO4Yfmdi+OTe
         U1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x/K6wJed0hbTMI3Iein/tFDJN8j04FfLnw2b+D/mh+E=;
        b=ptyWM1sgx+P6LG9p49cE0yuoyEAuYAvrfTfbhwkoz4y3o+rebKfPRxvWZAZi2W7J/a
         4Tg7hhM9KopqQDrMV+skFKx0QEC2vhWbwcHggLEunov1Zw91r2bO+qQWlOfGd7huZ61B
         invthDIVXwmduhYLRc8ZKN8vYBIZ7OdJ4LDXD6d8d4gYlFA+gJN47TXrx9V8dy4SmVAG
         8miKjoM5IGoqcmGR/zIHs39rX5SEC6axsDGvqcq1HzldRHiDiBiN5OFcirE1pw5fCu7r
         xjXslKKQMg6GBawAwQjk+SEpkfgfDYVO6/1Er137oY+sw6pjA5sKHnr04pO1Yuuxgpcu
         6UEg==
X-Gm-Message-State: AOAM530AoewOgFd+yqsA+ABjug1LHWbWK89JSMO1YszAbMunCLzRrJmq
        PpFRB2J6NoreNLZHLxr50CsfYtIhXMQH/w==
X-Google-Smtp-Source: ABdhPJz6T0/VyVqrUS8+OcrqjKVU28F0kKlE+mikLDsXqNUrUJnX65lIRGHVJLHyU1kfaO1eQ+GPYQ==
X-Received: by 2002:a17:90a:598e:: with SMTP id l14mr5323781pji.187.1617837617902;
        Wed, 07 Apr 2021 16:20:17 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:17 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/8] ionic: ignore EBUSY on queue start
Date:   Wed,  7 Apr 2021 16:19:59 -0700
Message-Id: <20210407232001.16670-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
References: <20210407232001.16670-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When starting the queues in the link-check, don't go into
the BROKEN state if the return was EBUSY.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8cf6477b9899..eae774c0a2d9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -135,7 +135,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 		if (netdev->flags & IFF_UP && netif_running(netdev)) {
 			mutex_lock(&lif->queue_lock);
 			err = ionic_start_queues(lif);
-			if (err) {
+			if (err && err != -EBUSY) {
 				netdev_err(lif->netdev,
 					   "Failed to start queues: %d\n", err);
 				set_bit(IONIC_LIF_F_BROKEN, lif->state);
-- 
2.17.1

