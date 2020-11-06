Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D7D2A8B2E
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732430AbgKFAMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732297AbgKFAMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:33 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869CC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:31 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id z24so2545251pgk.3
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2aWkMqo1r20Pi2OEYli1mBai8fEL99UyV8cr7SGRY3c=;
        b=rrBqewTbbfqlC/E5syt/9ob8WMyDRhwxGpLYggCRgwM9wRdtFQKUdgdGaQlunLccoL
         2aQOCfMqDIbT8Gzy808wIPhUygWfqRKSAOvt0Bg1PFmKjSVv6oY/inluNeSplwxCa5OM
         J6Ihcbv0bh8Igr/bu570UaOj3CTqCCBcVGOJBXSDSS1jvjZ9zD6uoZ2mAVCHDXkOYaIm
         m0SVbBv76ZcYe+tuwF25KS7BYpy8GA5ZNfa8L+/vdZhsRwPjpiP55rME/yJj3zgmKMwV
         w/hKqYI3DOeUjAK+knXGCZg+abNW2tfKexcIV5zNQQgoabOat62EvDd01k4QTEV8hq0L
         iFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2aWkMqo1r20Pi2OEYli1mBai8fEL99UyV8cr7SGRY3c=;
        b=A+vV3lJZDHVCAyEj7NxBsOWN5rrMzZY7+1oTXZm1U0xJs29FQq4zjvIF8vi/4GXovk
         enBUKVlxo4JMQ91cKbRFQGiWt1FbD8xJqUHSdiMl+i2ge8D5jxS6LHV/DVwIHmJrI2OM
         TcpemieoOmF/QeS3wFwnJHeiCaHvCFtNC64kprrxx27LDPhoBHn4N/ig5pEizzhy6NB1
         P5TbaJTeP5e17UIUk3ckkTmTzZjwJye1osEJfOgtvEKjvSP21J3RtoU0ugYU7z7wMW9O
         27HmoF9Upsipru7agUmrLTyjj8NlYGok0zOew1xkqrwDNq52BfDwCe/dBQqjojESCNaS
         9JWw==
X-Gm-Message-State: AOAM531jVoiqlOOk5s9Je4oNwoltNZ5/U37XGM3z2HNUVZjvQ3+TZuqa
        N1ZBrOv3Uxqx5bKpnnnf4AnwR9QUkuKlcA==
X-Google-Smtp-Source: ABdhPJysc8RPAv+mFUTx6Tna1os6cT2boik9TlSs+X5/csKP2C8GTEHoCym4kbdmiB2Tm+Pql4tf4Q==
X-Received: by 2002:a05:6a00:1744:b029:18b:a1cc:536a with SMTP id j4-20020a056a001744b029018ba1cc536amr1485318pfc.74.1604621551141;
        Thu, 05 Nov 2020 16:12:31 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:30 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/8] ionic: start queues before announcing link up
Date:   Thu,  5 Nov 2020 16:12:13 -0800
Message-Id: <20201106001220.68130-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
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

