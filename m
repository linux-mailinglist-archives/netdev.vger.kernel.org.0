Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A7E248EE9
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHRTo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgHRTot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408C6C061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e12so23333651ybc.18
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RWjqrTdIak+5ou+pVThsfOSG1kAHjXujv1R5A1DCKfg=;
        b=AJFYyc2YJMTzUid6wCbi+iwoJ1er3R0zjqS/IDwYZWuLSoVO5lHY/m3AfF9Z6PmuTL
         8TzmH82r1FvsWPFBQ4RYztL/x5UoPusjZ9g5g2ZWG1vjeuoan++hfvK74b5lU3PPbxaH
         8dV2nMVFwrQitrMHp8MB1PRTbZCxcxwLtmQdQlQg1Q9VNYedgqf6oUuiuOq8s0xrR5ag
         sIGabENCYnZ5zSB+x4eGdIhMIwTbRWhhjb629Ts7lVQJ4udrxJP44rLQSAZEnqM6ulRv
         lMSP8x+IBa7fXzlLaqoYO/Kwyybuq/vOiTc0SmeBLDeGD7tk3XVnc6vugsYHea0njRXu
         XSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RWjqrTdIak+5ou+pVThsfOSG1kAHjXujv1R5A1DCKfg=;
        b=SDYQQ/GMa+5bWXQId8r7NJyEP5u2LFjfXvT4Azl1l8WANsBr5IybsZIww1IQMRsy/T
         Qizuk7JOLpvDx+dLRVksnHhaBUFdm2I45EYfTJYEwTOoRD1HEr+oY55mUl45LLS9fSrY
         cxQW0lq93uHqMe5WBembsSll140RA//KV/8AF+GjY+kQ8YYFOO4UBTLRtbmvqBZZhIBU
         FY4A0/s1pIPfm1p3hiB6JUVCB0RVEba3AMku8YnSQNCAdy7o8SHuc/o3CSVsSYuWf/SY
         C6FtAO+AGp+zAUhhBjH3lzmHLWRNYq3yikn0cxnZ/Irl870z3tkoIfo9+/cKxJDbQxRr
         UN2w==
X-Gm-Message-State: AOAM531Ng+qa2E5gsSkKMuQ9/I1kC+HgZivm9e/7pIKkrRhgdYV3/Z0f
        VzxqIbyD6CXdKDEO3TWklZxfw73P49CrUOAXzACdHcdnRJ2NTCiotVFUbusUPxwJQxi34DCf9ds
        5izu5C7S2i0qKBQW/Uo8Yu9EJYn1Oh5Z2imIRzvlREOUw/dDn+puA8/Ddm7/WNqfy89dlAgNd
X-Google-Smtp-Source: ABdhPJw5tZ8i8LVXRbREcPT5RqmsNgLxcm1+xnazWOCutczIUodLOOGEE/21lYuyAp+aX0hRu2HFcCxWNwTs3+h1
X-Received: by 2002:a25:5094:: with SMTP id e142mr28418608ybb.99.1597779886988;
 Tue, 18 Aug 2020 12:44:46 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:06 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-8-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 07/18] gve: Use link status register to report link status
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
 drivers/net/ethernet/google/gve/gve_main.c | 23 +++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 885943d745aa..685f18697fc1 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -769,7 +769,7 @@ static int gve_open(struct net_device *dev)
 	gve_set_device_rings_ok(priv);
 
 	gve_turnup(priv);
-	netif_carrier_on(dev);
+	queue_work(priv->gve_wq, &priv->service_task);
 	priv->interface_up_cnt++;
 	return 0;
 
@@ -1026,16 +1026,33 @@ void gve_handle_report_stats(struct gve_priv *priv)
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
+		netif_carrier_on(priv->dev);
+	} else {
+		dev_info(&priv->pdev->dev, "Device link is down.\n");
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
 	if (gve_get_do_report_stats(priv)) {
 		gve_handle_report_stats(priv);
 		gve_clear_do_report_stats(priv);
-- 
2.28.0.220.ged08abb693-goog

