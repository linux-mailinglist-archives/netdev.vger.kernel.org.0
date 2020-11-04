Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164032A708B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgKDWeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKDWeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:34:04 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401A7C0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:34:04 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 62so46494pgg.12
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2aWkMqo1r20Pi2OEYli1mBai8fEL99UyV8cr7SGRY3c=;
        b=zN25aHG8qzPSs09dSEr9A7pFvBy5+CmvGFlDUD63Qlk+qZ3VvZ/JYNh7uuL+5p8sqn
         AiOztMvWh+6wybyfoLfxfDGbtoqmNXwGTW1ZFV32F2A1u1vKa9Gbnsd3pihRcKsPx8YA
         BM5UZ/sKRedMGj6xEVOitw5vTy2ISmXOuikQZWMLtggts0tek3Eotz46uA2w4G2B2qVu
         0fkerOZo6LTB0parWWtUdue3veQNj+zAkFAxx9ipHHlSWf/i6Sd9NsldTkCql/MUNqvG
         IaI7Cq34xMK2d9E+l2xNUOVb+274mZXOn2v72+QZpy3WJMtewi7pmV0IJH++Dri1MnXm
         PyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2aWkMqo1r20Pi2OEYli1mBai8fEL99UyV8cr7SGRY3c=;
        b=FOxDMKq6sJL5iWm2bUF0/WRHfWQKvhKTrjJZoQZ+7RcNe6d9SqE0ewBSEvsZd2M9Mb
         tTLKwxRgPR5HT7wnceItHs64+E1YHvkmVVNiTcQuVbED1vdPQQWVEOsbnj3Glgcn9S1G
         ea80v+CK8DyhiK6flAUma/EsiGVD8YomZYBslm2iSPCY7bcFIgkfLtgE8uCAf0BTyoes
         ITnbF1e313V04addQv5S/BbmhlvuwEq0m6HY8KjT6g99nB7E0xiILf6pRHL1ua0O+Bwe
         lzg/pCFctNAGB989WCCJMggsPqU5NUyR8WQdEyGnAmZXZusni5mxE4GF6NaGtvE8GLo2
         RbAg==
X-Gm-Message-State: AOAM532vnQjmR4H5ETJH4HrbcVXX28hJknDlEPeTVhEeY9sSRda0SOSn
        S6f9VKjO7982a9e+wCSn91ClUbbzbX05cA==
X-Google-Smtp-Source: ABdhPJwIi4Y4TVDsWiQmKBcEDrDuKDwKyaOlHLJTU6vKmxStBL5goBbGkw1OaZJqukxZtJLHDYJ+uA==
X-Received: by 2002:a63:9d8d:: with SMTP id i135mr150846pgd.213.1604529243603;
        Wed, 04 Nov 2020 14:34:03 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z10sm3284559pff.218.2020.11.04.14.34.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 14:34:03 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/6] ionic: start queues before announcing link up
Date:   Wed,  4 Nov 2020 14:33:49 -0800
Message-Id: <20201104223354.63856-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104223354.63856-1-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the order of operations in the link_up handling to be
sure that the queues are up and ready before we announce that
the link is up.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a12df3946a07..5457fb5d69ed 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -123,6 +123,12 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
 
 	if (link_up) {
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
+			mutex_lock(&lif->queue_lock);
+			ionic_start_queues(lif);
+			mutex_unlock(&lif->queue_lock);
+		}
+
 		if (!netif_carrier_ok(netdev)) {
 			u32 link_speed;
 
@@ -132,12 +138,6 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 				    link_speed / 1000);
 			netif_carrier_on(netdev);
 		}
-
-		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
-			mutex_lock(&lif->queue_lock);
-			ionic_start_queues(lif);
-			mutex_unlock(&lif->queue_lock);
-		}
 	} else {
 		if (netif_carrier_ok(netdev)) {
 			netdev_info(netdev, "Link down\n");
-- 
2.17.1

