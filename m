Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B92B0C79
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgKLSWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgKLSWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:20 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF778C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:20 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f18so4874447pgi.8
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SIWQj6ZMSR+KKITnxdKuhNmX5pr7EdvD4xOgq62BLCI=;
        b=PXQH0flDoNeSUtOvSGz0mnYsTuSnUymCDkhWGJRiwzcBbcNhufX5ehWhrLD3w+iXrb
         uK7vp7Px9l8vHBxIltyo+y7nYcS79izyKFSjMPiCYg/9DrC/AQ9uhmlPn5mZIhoGT568
         NYjqEsKSN26b4Wtr4W5i5RV54xLq9+W2PqhrZ3LSOaPrlC0dFQwzI3zoILyd9590R+fa
         qUw7J/0HtP9yqU3o6hFSeEBtQ6X7uZWnQ26FhP4I2fX9CQukog+EsQNE6MDPfBbVH8+X
         6Pc0P5VEsiaLS1OyECmGwI1z5kg6AB/0aE+W49SgvMb31FTqiWbs3IQSZXv7N+ac+sjS
         6lcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SIWQj6ZMSR+KKITnxdKuhNmX5pr7EdvD4xOgq62BLCI=;
        b=siIqE9H5u8zSqy4J0rXIjuEmQc04KlYDiOstFTSRD4gr8d5EASBWf437xsXajOJDWy
         1BeLJnlpYLGYcWHh217rPe2VlKz97QfNF8zezxLyxaAwGIgY0BWyG5+Tpabc1HnF7W+T
         zuHGjw7rk1ls83u6ld9bumuJVbLKlM4NYR3bCsZeFnlkuD3GVmu+T7dkrbUmDErXYawN
         op6MZNUGez6AzZj6FgBlPc6zBWy9DyewFW+RP0Nsz4xH7fV0W1b7/nyMq17MFWJgCnyU
         9OmbquS+lHgCXeHJh1XsqzLiVF4v9dN6M59Hk+bWm/DwbJNLQyEm+WJPBWw9y3ufYYOO
         Px5w==
X-Gm-Message-State: AOAM532b5Od82ZOu55PtsU7asITrhciZqwrCcgtQDueMbHNeQlwJFzGO
        8M39gXxQ10zls4wgbjnSezpA8iTY8ihDvg==
X-Google-Smtp-Source: ABdhPJxZ/YP30UxCNrVpVtlp7GV01WMuxxHZJpaKR7Ixf1VQqjnf3OICtbcvF/bNsTK1bslM1a4lyA==
X-Received: by 2002:a62:254:0:b029:18b:fcea:8b7c with SMTP id 81-20020a6202540000b029018bfcea8b7cmr663319pfc.69.1605205340009;
        Thu, 12 Nov 2020 10:22:20 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:19 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 3/8] ionic: add lif quiesce
Date:   Thu, 12 Nov 2020 10:22:03 -0800
Message-Id: <20201112182208.46770-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the queues are stopped, expressly quiesce the lif.
This assures that even if the queues were in an odd state,
the firmware will close up everything cleanly.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 519d544821af..e5ed8231317a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1625,6 +1625,24 @@ static void ionic_lif_rss_deinit(struct ionic_lif *lif)
 	ionic_lif_rss_config(lif, 0x0, NULL, NULL);
 }
 
+static void ionic_lif_quiesce(struct ionic_lif *lif)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_STATE,
+			.state = IONIC_LIF_QUIESCE,
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		netdev_err(lif->netdev, "lif quiesce failed %d\n", err);
+}
+
 static void ionic_txrx_disable(struct ionic_lif *lif)
 {
 	unsigned int i;
@@ -1639,6 +1657,8 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 		for (i = 0; i < lif->nxqs; i++)
 			err = ionic_qcq_disable(lif->rxqcqs[i], (err != -ETIMEDOUT));
 	}
+
+	ionic_lif_quiesce(lif);
 }
 
 static void ionic_txrx_deinit(struct ionic_lif *lif)
-- 
2.17.1

