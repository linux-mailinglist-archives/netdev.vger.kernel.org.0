Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42AA261AC0
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbgIHSj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731599AbgIHSj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:39:29 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653A8C061756
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:39:29 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id a14so125135qtp.15
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ywEd646xHCuC/J7kOO3reXUQxQqKgXP6+iKxrjPbtnY=;
        b=qbmNeOLk2mDpLKkMXF7iXCIKlda3B0PZrC3Y9gSM4/jmfp19v2oQ6n6y2LmpZux7YT
         6V/P5gvNEu4JiKI7cKUiBr5CXnkcH1tAK3wZFGCFezGg9Fx0C+yIbed8nbkONjqUdZuo
         xPDbS3XODE0dP0//tz3OSGIZBOMVaMV+8DGRcwnUBWc00MA+zjgtON1E0iWKRxytWIcL
         FBYDfMoe5HoUeKGllBkOjunf59oJah53DhvJdDZ0+3ZGy1uTbIcY/XxJyo08rJtuj2r5
         5xXMP5t5J7P0xG8vA39MwJHJjwyrZUZbPspuU3m4lAdnFodGyI+iU+lWHC10T96gD+xJ
         sbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ywEd646xHCuC/J7kOO3reXUQxQqKgXP6+iKxrjPbtnY=;
        b=XfbPQTncPK4w8EvyFThQr1STOCJg/P9M6AP61tAKonQtirqStKDrXYszL9Jr7s5ojU
         sdSQJ9UhfbwuYqYcU3y8kGsUKNumZUjoK6mjxffTS51huazQSJ/hTYIDcria2pB1BrCS
         bGCSHNezTJFbaGo15EDJ7Cin0f+NtfuVnJF+RRHzBxk0MLM0KK7zMuCyeEe6+aOrcbIb
         hmm4q57bLH7eIfvL9CnQ+NJwXdmiohh7Di/rMfmqdQnbk7HNEas/8lzPluR8XycNTcve
         2o56Mov4U2DleUdcfCtvVe0eyZeq4dxLA4+ApKeNBRVDH1re9v1MGvgj0so+WSAiXfCI
         JNVQ==
X-Gm-Message-State: AOAM533rXePFaa+nLo7mr13KxhO5o5AZRoeVcFcN3ZUZ+k3y7o6oEdWw
        uahi//JYoviJXWGOox6vp/xUnb2kPA4Ga2SHdByfYVk93inp10FNSuDb8T2BF6NLl24pWZZjfrb
        LbCnX8PvdY9ZebhBerMdnI+DP0u4cr/l3GL449sXrUNhSamTAcHo5mP2F66FLo3w1d7SPTGKb
X-Google-Smtp-Source: ABdhPJwMrqAsie9F4J34kIPKfvkyhBY1GJ8WgSaHWhhPwooNezcf19LDxInvPYbMgHumGcfiAcMOId1XrgSrkkHv
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:ad4:5146:: with SMTP id
 g6mr527210qvq.22.1599590368310; Tue, 08 Sep 2020 11:39:28 -0700 (PDT)
Date:   Tue,  8 Sep 2020 11:39:08 -0700
In-Reply-To: <20200908183909.4156744-1-awogbemila@google.com>
Message-Id: <20200908183909.4156744-9-awogbemila@google.com>
Mime-Version: 1.0
References: <20200908183909.4156744-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next v3 8/9] gve: Use link status register to report link status
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
index ea35589ac0d6..271252d936dc 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -767,7 +767,7 @@ static int gve_open(struct net_device *dev)
 	gve_set_device_rings_ok(priv);
 
 	gve_turnup(priv);
-	netif_carrier_on(dev);
+	queue_work(priv->gve_wq, &priv->service_task);
 	priv->interface_up_cnt++;
 	return 0;
 
@@ -1024,16 +1024,34 @@ void gve_handle_report_stats(struct gve_priv *priv)
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
+		dev_info(&priv->pdev->dev, "Device link is up.\n");
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
2.28.0.526.ge36021eeef-goog

