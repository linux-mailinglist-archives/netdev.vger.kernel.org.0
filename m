Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73C12B0C80
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgKLSWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgKLSWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:18 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD42C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:18 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b63so1696192pfg.12
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0uFKKPP21W4f38gGzSvB1Dje7yKdzrgayh7PC7t67mk=;
        b=zl90gMj8S76LJMqIM5zXWFlHGPpQ4FPKnPyHPlSAxOsBZAuzEZXqurXWEXrN0ER/xD
         8FusUTUzhlD3aZ1xy9JGZjIyGpS9ElUtkNlD66+dkYUaNqWf5gygsg5HgEkDFXJI/cGU
         9rKkrHUc6+X3UbIRY2sM5doWgaw6mFlXrkha52KjsnFSHgvqOmZsUBMCiq99eNFFf3Mf
         P36tniXYb0teJg96jtiOGQa6tc0ZJRdetrSe7Kv+oz8Yn/uftGnzND5hNeHdvxJp5k5l
         ENxcG22NN3+42dg/b+b9Wwn9kKDcq5lOdVrua1/0fDXJxZy7sr+6U6MGWpF7sYEhnX4P
         WxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0uFKKPP21W4f38gGzSvB1Dje7yKdzrgayh7PC7t67mk=;
        b=Ya8qgqAo8Y6J6ggj+CV9heU03t6fvj4mpBMS015RGpiqF84RNCxFLXagkzPaoAGJJz
         Sua4QVx0HLEtvr2lVUQ9tqU5ivj49By2zQ1H/LUs8wBCJk0Zvl/UiUPv3rKKjHq+zyWX
         4PEhffJ/4/ZYtZlZyNlmomMORcaVrHICy3OtIY1YALgXZ1900vhkipUy5eqDCmGZw8Tv
         +ooRxDStO/Avav+UU4OEiMRJnTrNrhCnsfjpRAjgqgtF6wkXELaU4SeDHIT5Go5rOGmR
         wN8ld8LUrT517LfGAImw7ZgczO0AnA4nS6f7sREdj8o6p76XzspeKIGO3TQLQYL928bW
         7fng==
X-Gm-Message-State: AOAM531I4YmLkCCuBKal81bsXxTmqYFBHjVaGi1tibMbIT7IZjMAj4eV
        MjYHAEjyGIS7rGC5VIZ4tsTNLwA1nsqmxw==
X-Google-Smtp-Source: ABdhPJxVFgs0DoUweQfwV4OidhYjxjZIvqBNTlhsM3we2iA3qkY0cY7fyNWX9XhGYOqstAiwUJC+3A==
X-Received: by 2002:a62:f94d:0:b029:15c:f1a3:cd47 with SMTP id g13-20020a62f94d0000b029015cf1a3cd47mr657160pfm.81.1605205337462;
        Thu, 12 Nov 2020 10:22:17 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:17 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 1/8] ionic: start queues before announcing link up
Date:   Thu, 12 Nov 2020 10:22:01 -0800
Message-Id: <20201112182208.46770-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the order of operations in the link_up handling to be
sure that the queues are up and ready before we announce that
the link is up.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
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

