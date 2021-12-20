Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8507D47B3B3
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240813AbhLTT1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbhLTT1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 14:27:54 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A0BC06173E
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 11:27:54 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id d27-20020a25addb000000b005c2355d9052so21167409ybe.3
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 11:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a4tP6mCJZgidogoAybVwgTcxZgJmZA+9XXOZlacKkLg=;
        b=fv2iNxr3n3NWlgMj87EvhFgEwLRyFWcDnmOgvGMsbdj65HKsuOmUNRurLxklSdnpQ8
         +zO4mnqTZDh+55gG/GxGauebRQwf5Pcq6ImPBkbSSqHY9SuugcHM7p3ZLj+/T4CsmEom
         8w+MiH4mnpoRFXEIpR/ap5KhIqrDl0mnlaIuh2lxnDUpWDIfrW2OJTgecdNDCuOCX57G
         8UmvMqcXQc6r2phfvQhFknaqXWWjkMpIUyd6IGE+7QUoP3/c2NaiYPTRZhy1IV39XwZx
         X1ElI7UHH/oGl2S/7zWAivBXXIHofiDoJkCS7ngEMB31t9lm/PZAWVmQsumSqYyYTuDG
         9iQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=a4tP6mCJZgidogoAybVwgTcxZgJmZA+9XXOZlacKkLg=;
        b=kJ8tEyynlueeQJnjWkoynSKxSESbjRCl330GYeOxVeUOy6EYcT8Q1G2bjTo3tRFco4
         cwqbAxFifBTz0vGYed4cU4nEhXye6oXLk2QkL0kQKOLGHAa8ETTD+eqTWFVOmhxUi3+I
         qbH5esGbULjzZvBHcfHOr7RrQUGG0om1zp2l9i700Ih3sArMauYZ726AbQpayBrX6fXt
         iJ6TPrQX87m1SizH0nwy2YK8VpXbgpPHMHH2cqPcrfDaUjz5GBO1cNN3Po6raTVgqjhV
         NGnbjV3sqtpSTng4yg+M/bdmKX9EQpAm9R2zOrCgbT0kmNrz619YsvVhefGAuJDFPA/0
         dLMA==
X-Gm-Message-State: AOAM530Qwg553TX/8uprngTo+9piXm31vHD0wMHvNB+oJqp5Ag2wTo31
        MpAvAHyogW3Dmft2SBylNPd67sXoaMXjkM47ca8HROXf/FlBHfNWeHdzEbCy6xuUSB7tAmO0o4F
        f/0LY5SWxMuMT2198LX9eqON/4NXV+rhCDyzm4rqLhZiBC4hfni8YEDSslwTs/41CuJA=
X-Google-Smtp-Source: ABdhPJz/pycuXtCxd8X+Fb5yh0Y+7g7YgrrE7iiyUhy+zur5x5A7PFweSzhyv2aGtQbvC1KI/6Ar4RtGfBf2ow==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:4b53:f3dd:919a:bd9a])
 (user=jeroendb job=sendgmr) by 2002:a25:d09:: with SMTP id
 9mr22951408ybn.401.1640028473287; Mon, 20 Dec 2021 11:27:53 -0800 (PST)
Date:   Mon, 20 Dec 2021 11:27:46 -0800
Message-Id: <20211220192746.2900594-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.307.g9b7440fafd-goog
Subject: [PATCH net] gve: Correct order of processing device options
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
2.34.1.307.g9b7440fafd-goog

