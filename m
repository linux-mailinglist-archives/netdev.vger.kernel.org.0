Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB0476719
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhLPArJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhLPArJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:09 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E503CC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:08 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b8-20020a17090a10c800b001a61dff6c9dso12950503pje.5
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4hgswiItr2SQTMaY8m1rgHLpszklWZ6dae36OJa0w8E=;
        b=HjtFfQGzV5DVNcv+qrL4zpE9AuwTVOdozsnJTVZ3Ju4Y9on6FW/xZB1JeXlYFdgh2Z
         nrRVj4ruBNsi+UXCkVY9OuQZClTYyv70OX/MxcEFy2I7EqzGNDSAoHHlZd8UZkVHE/pI
         RcoRqMsYdOY4+oB1w3NuVZHFfSwedJTa980HmKNrGepkascmmVpZrffsXzR8T9pkqOF7
         sK6ka+sRTRL2XtyTYAT/18hKd0UYA8Lm/jvmEHbyqQoffhQeqov9oOUatyKH+Z9C/WgL
         rzF4PXe05yBdUlquoGZ5GZFGBy6S6fGlSMQRK4Df7faJpdGVQLdZpVrYZ1Pol41gEh7J
         k08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4hgswiItr2SQTMaY8m1rgHLpszklWZ6dae36OJa0w8E=;
        b=Vc9ClhHXi88WEEP+uQrc7uWfHkuUEduZO+U/tKEQ81R+h6WTPZfsSDD24iqwrg1QLY
         3gnXXkq+8asLUL2LD7GCvksuXsQ4hv9d/RRxsjS1mCH4as5HpFSrcqDEmJdoCCrEHdvP
         IUuDWP1uPgqGn0Y3ayw0GDCzbOWnexsNo7gB2n49eiEn3pqX5tE+GjncztrGUxORx8ze
         REkRB8xrtPxxQmOt3ofAW7u5ijQmxbzb862QVF2Bnpg2ldCzrZVxxUsjRrhxPiu4T8VT
         2GiUvmR2AgEJgdGP+rm5fNmxdO4IcolKZasTOXvmqGARJlMOH7GAFF+Bnpo2YBTW2fOI
         cZSw==
X-Gm-Message-State: AOAM530GuDb8cMGa/baDRvBz5HLDJS2xNleMQrUouXaDz+0jl9rG6HA9
        z+FIRY3GaRjgMfcm/D1afjIqn7Ni65GHxeodPBDLzVmga4JS0MuWfW1ryZV/8RPYbueqK6Wlm7H
        LSfxXYWbSSkhG6G56LPM5fr2aIh3Os/k3TgVw+WqhePkzRPlZHCpEh2S1LvhR7gitgoY=
X-Google-Smtp-Source: ABdhPJwsoRTZn6c9+8kw/8kZoPdmMW/wN11LyD5igQGY9DlBXdpmhfscnYNp/4mBWHdEUIDJCdWyhPDJVkLfHA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a17:902:6b45:b0:148:a30e:5219 with SMTP
 id g5-20020a1709026b4500b00148a30e5219mr6926214plt.10.1639615628296; Wed, 15
 Dec 2021 16:47:08 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:45 -0800
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
Message-Id: <20211216004652.1021911-2-jeroendb@google.com>
Mime-Version: 1.0
References: <20211216004652.1021911-1-jeroendb@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 1/8] gve: Correct order of processing device options
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy raw addressing device option was processed before the
new RDA queue format option.  This caused the supported features mask,
which is provided only on the RDA queue format option, not to be set.

This disabled jumbo-frame support when using raw adressing.

Fixes: 255489f5b33c ("gve: Add a jumbo-frame device option")
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 83ae56c310d3..326b56b49216 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -738,10 +738,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	 * is not set to GqiRda, choose the queue format in a priority order:
 	 * DqoRda, GqiRda, GqiQpl. Use GqiQpl as default.
 	 */
-	if (priv->queue_format == GVE_GQI_RDA_FORMAT) {
-		dev_info(&priv->pdev->dev,
-			 "Driver is running with GQI RDA queue format.\n");
-	} else if (dev_op_dqo_rda) {
+	if (dev_op_dqo_rda) {
 		priv->queue_format = GVE_DQO_RDA_FORMAT;
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with DQO RDA queue format.\n");
@@ -753,6 +750,9 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 			 "Driver is running with GQI RDA queue format.\n");
 		supported_features_mask =
 			be32_to_cpu(dev_op_gqi_rda->supported_features_mask);
+	} else if (priv->queue_format == GVE_GQI_RDA_FORMAT) {
+		dev_info(&priv->pdev->dev,
+			 "Driver is running with GQI RDA queue format.\n");
 	} else {
 		priv->queue_format = GVE_GQI_QPL_FORMAT;
 		if (dev_op_gqi_qpl)
-- 
2.34.1.173.g76aa8bc2d0-goog

