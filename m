Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C5F266733
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgIKRjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgIKRjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:39:09 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D7C061796
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:08 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c5so7130541qtd.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=U70BF05oxjr6sQoOIvH0cV1DcMgkH6fNJgwr+2ckd0k=;
        b=e31eqVRNME/CrIJaWHfW57cFBbp6qJsjwQdqc9r+7dmTLTSkEsQfTWgu6hXqxj0oLJ
         Yg8jv8DONegHQ+aWQ5VzhPFcFqhho6CcwzrjBqflwDMw4YnnYWYjAZ8SDBV5SUw3neAP
         hiLqFIMZpMRxwoACna0XUO85/TyUEgK1UVGAtaK5p597CHXb645IMCbvQuo+wnUnfiac
         0aSbhZyrQJKjpsKh9ZrNkx/rA3potdEgxHgnzfjZpyU5+pLei95XBA0LsjW3sUtyxbHM
         N4GstC2h5N9pSLNOFDpV05ueBPu2ESj0s23TnPe21Q23ZiF/mnKCEyWPdHkGawHl9sRA
         Q19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U70BF05oxjr6sQoOIvH0cV1DcMgkH6fNJgwr+2ckd0k=;
        b=nLVEIvvG/0PShhli7rzIyK1E5k0+QmR8Z8LL17fkDVcd6GtAeKWHNCW10TAZ1rWGOT
         UKMlJnne9Vtqpvrsx5k9UrmS6Up2NnSnWmw5MovAVfxFaZ7rTJNNh6scHKn+xSG0RkUf
         4UoRN5WINengL+2OrJr8TQO1Lk/7UspOM5iHov3ogz8ldWlVDEXN6bDNE2fX1lXSqbTp
         DA+KxHRa1i3Smqbaiiv3Kdddf5NDNGfIvP+QHFc9T8BILjVNRwt4FPTTcoWs9N/j3EFu
         o2/zOk4EEwCC1mM8C9EMPbi+ufjaqOdnN+Kr9zgNeELh+g1BViyrs8qz4SRZLRV4+Cij
         69jw==
X-Gm-Message-State: AOAM533dhDKwdloCSTvQQGCH51wDGOXiwqNlYB5UN91lA8rhRZq7bg+t
        Chl0LSyPmENOMn1EZ2uCvmW4A03QKcIeH6kJu4ZWVfoHiYGtdS4bCcvF1NsoifF4NPezRbz+3Ut
        1OjihE7LqrYcvJiUGSd+0s1TpVFpAURbChxWQCgv0TicdKw5zhRK0hbg8PjjBVKTldil4WvBV
X-Google-Smtp-Source: ABdhPJy4hhsHbtVEJGQCrcElK7Fcjz2W1lxf5H0nd/TCAmDV+QdquR6qGMKcQvTFLBWuM3o647zX6UL2WxrJHxnY
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a0c:eac5:: with SMTP id
 y5mr3036153qvp.2.1599845946770; Fri, 11 Sep 2020 10:39:06 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:38:50 -0700
In-Reply-To: <20200911173851.2149095-1-awogbemila@google.com>
Message-Id: <20200911173851.2149095-8-awogbemila@google.com>
Mime-Version: 1.0
References: <20200911173851.2149095-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next v4 7/8] gve: Use link status register to report link status
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Patricio Noyola <patricion@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patricio Noyola <patricion@google.com>

This makes the driver better aware of the connectivity status of the
device. Based on the device's status register, the driver can call
netif_carrier_{on,off}.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Patricio Noyola <patricion@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 24 +++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 28e5cc52410e..48a433154ce0 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -774,7 +774,7 @@ static int gve_open(struct net_device *dev)
 				msecs_to_jiffies(priv->stats_report_timer_period)));
 
 	gve_turnup(priv);
-	netif_carrier_on(dev);
+	queue_work(priv->gve_wq, &priv->service_task);
 	priv->interface_up_cnt++;
 	return 0;
 
@@ -1032,16 +1032,34 @@ void gve_handle_report_stats(struct gve_priv *priv)
 	}
 }
 
+static void gve_handle_link_status(struct gve_priv *priv, bool link_status)
+{
+	if (!gve_get_napi_enabled(priv))
+		return;
+
+	if (link_status == netif_carrier_ok(priv->dev))
+		return;
+
+	if (link_status) {
+		netdev_info(priv->dev, "Device link is up.\n");
+		netif_carrier_on(priv->dev);
+	} else {
+		netdev_info(priv->dev, "Device link is down.\n");
+		netif_carrier_off(priv->dev);
+	}
+}
+
 /* Handle NIC status register changes, reset requests and report stats */
 static void gve_service_task(struct work_struct *work)
 {
 	struct gve_priv *priv = container_of(work, struct gve_priv,
 					     service_task);
+	u32 status = ioread32be(&priv->reg_bar0->device_status);
 
-	gve_handle_status(priv,
-			  ioread32be(&priv->reg_bar0->device_status));
+	gve_handle_status(priv, status);
 
 	gve_handle_reset(priv);
+	gve_handle_link_status(priv, GVE_DEVICE_STATUS_LINK_STATUS_MASK & status);
 }
 
 static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
-- 
2.28.0.618.gf4bc123cb7-goog

