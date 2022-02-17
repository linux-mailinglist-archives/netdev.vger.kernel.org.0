Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B734BAC39
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343759AbiBQWDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:03:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343755AbiBQWDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:03:17 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D049255488
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:03:02 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id k60-20020a17090a4cc200b001b932781f3eso7071171pjh.0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9efb25S9TOVCfzp6gKYKn5qGYCYbeJHo3Eb9jSUYesU=;
        b=bSic3ysthZkvwx24bYP7r5oK5rBAoJbbPe7ekuSM7YA1S6T6haT7MIyAOptf3ENfRE
         5xL4+Dsr8thQqcFjBN6NqjVRw2dmBdEYfcULMZF50l7wzvDknbFOLqxxdBzyt/7/Msmj
         o+h1YeOrpDgNiL9purAi7ZsXM3b1xJyQ20UcvOGS7rjFE7v+KVgBQ/Uif+HIJ4t2bHf5
         dzSgv81ApeG+qwMSpIp48MrW67kZ5VyH7f0a0+ehtCs2HwkH6Q33nxK2SeaXK6YL1N7g
         TGGTHl2IWa1bOrZ12bUvLq17blzyD240YrCvtPaDA3wGtT/IhdLCHynB06hLJcnYltun
         iBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9efb25S9TOVCfzp6gKYKn5qGYCYbeJHo3Eb9jSUYesU=;
        b=wO0a/q6p4Btns6YGbcBXSmiM63JXHsPWVX0j54ZIZilHyVxVVL3v0UC4zLasTtBJXu
         jr07bBkWwLpgWjvml79kes1bVb2JZFsH6YnAUDIMyAf/QVLjW8gkABP2tkRgFW7QI0AW
         pg9k0mk3vQcn++Nc83jRLhW/NXAHMlyvfilM9jFy7FDifI7m18sWcF6vGm+CznGZSykD
         C/UU46Of8GSUbRu8jFBZbWtCRFZCov+pR76FBzmg3ASRpdXAP6o41KP6ohNxfalzjoYi
         aVRO06ysL0CuSaQntdBn9e3IiYk4L9Sf5SgkkpBhuaeLrL7HWTNR13i+G311foDlh9yK
         3mRQ==
X-Gm-Message-State: AOAM532EcLaUx9M3m8ByMnBhI1DjtTxGc/p8g7M9rU/17dx9bKBXYuLi
        BSkfPhgHhgSH2iG9JiGHiMoUzQ==
X-Google-Smtp-Source: ABdhPJxeM6Uy9RVgLEKl5/8NwFS6ePUTrd0QM1TzTdgprwiKHC5MsCFVq15nJjFIPj7yj7eeJhBqyA==
X-Received: by 2002:a17:90b:3907:b0:1b8:c6d2:5376 with SMTP id ob7-20020a17090b390700b001b8c6d25376mr9339044pjb.29.1645135382374;
        Thu, 17 Feb 2022 14:03:02 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 16sm516119pfm.200.2022.02.17.14.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 14:03:02 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/4] ionic: prefer strscpy over strlcpy
Date:   Thu, 17 Feb 2022 14:02:51 -0800
Message-Id: <20220217220252.52293-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220217220252.52293-1-snelson@pensando.io>
References: <20220217220252.52293-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace strlcpy with strscpy to clean up a checkpatch complaint.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 6 +++---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 386a5cf1e224..01c22701482d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -74,10 +74,10 @@ static void ionic_get_drvinfo(struct net_device *netdev,
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
 
-	strlcpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
+	strscpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
 		sizeof(drvinfo->fw_version));
-	strlcpy(drvinfo->bus_info, ionic_bus_info(ionic),
+	strscpy(drvinfo->bus_info, ionic_bus_info(ionic),
 		sizeof(drvinfo->bus_info));
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4101529c300b..d19d977e5ee6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3301,7 +3301,7 @@ static void ionic_lif_set_netdev_info(struct ionic_lif *lif)
 		},
 	};
 
-	strlcpy(ctx.cmd.lif_setattr.name, lif->netdev->name,
+	strscpy(ctx.cmd.lif_setattr.name, lif->netdev->name,
 		sizeof(ctx.cmd.lif_setattr.name));
 
 	ionic_adminq_post_wait(lif, &ctx);
-- 
2.17.1

