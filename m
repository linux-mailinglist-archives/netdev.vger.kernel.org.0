Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20094440C71
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 02:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhJaBaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 21:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhJaBaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 21:30:06 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50E0C061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 18:27:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g10so51515090edj.1
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 18:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOELj/m7NAU1C7Zu3tFSaClvYw1ytr1Z7vBCXwXc184=;
        b=dj9ox8kCAYl/ktAD9BvtZrrRR0ziAjZ8AxLtURefd8APBXTa8SU7RmF25jMN2FfSRT
         mgQFwe/aSmLXy6lYOI5GABvZul4gnh3HvWeth7wWVvc4DsJXGyV39iZNCq5cNOIefrf/
         AKNHxB/ZPgMV2mdmdXE+luFiZNNLM0ns9BUY9kIMNzbHxQBq4hdKfKtbaNABqN0uUqIS
         cT3mD1thHD/QNmUDgQsv2MvDC6iFKmC/L9JzfnQil7POnK1gqy67DampkzmpOepsAb1k
         jRslaS9tCOYpNa++3m0wAJAzNOrlIoOM2dE9nY/Ml5rg8o9ch7DP4l15hVbZESfJUgtW
         aL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOELj/m7NAU1C7Zu3tFSaClvYw1ytr1Z7vBCXwXc184=;
        b=QUOq6BkmjrJHA061J5QJcIVRiHUVuyLIf9ExazoapG/JY44yOSmdDXHxNTc8duLfMB
         B0ts0ju+XDUniKvtl5RvuSf98IZxbtFwxQIREq6FRMhaU7MuIFYGZN5nKdaQk1trtMU0
         WDVAvIzP0wbGlQ6sBSMHo2ARm+uMxDbJ9oYSxoDUv1MqrnJtIH+Zklspze4NhXxQPfQa
         z/LV6st4/o8vKAg/g3seAW7LW1l1ENSTwwmyz1+kgKUFl6uVnQm1P4nViP2JF1SL6b/N
         QQZ2rIRG2VfZ0SeecFGYX13bz6ZR+aHcgU6gDuTeKrt5Cz+4m8uyHnbHU8UHmBAFlI3L
         mBXg==
X-Gm-Message-State: AOAM532BCNJ2l/deG6b1WqE555iiLAGM6YUeUVdRBGvo1lZN9ynJut54
        RTQBk9hXVx+QsdmJjIA9bhgf9caXDvQmGw==
X-Google-Smtp-Source: ABdhPJyOC1QXZSBU+KsK0DL6A+ChKSTNG/HcECwW0fMc7UhujF7/piLdqeHhk49O30QxVotOzRk3fA==
X-Received: by 2002:a17:906:a041:: with SMTP id bg1mr25349321ejb.470.1635643654256;
        Sat, 30 Oct 2021 18:27:34 -0700 (PDT)
Received: from localhost (tor-exit-34.for-privacy.net. [185.220.101.34])
        by smtp.gmail.com with ESMTPSA id m14sm2035096edv.9.2021.10.30.18.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 18:27:33 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: vmxnet3: remove multiple false checks in vmxnet3_ethtool.c
Date:   Sat, 30 Oct 2021 19:27:28 -0600
Message-Id: <20211031012728.8325-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

In one if branch, (ec->rx_coalesce_usecs != 0) is checked.  When it is
checked again in two more places, it is always false and has no effect
on the whole check expression.  We should remove it in both places.

In another if branch, (ec->use_adaptive_rx_coalesce != 0) is checked.
When it is checked again, it is always false.  We should remove the
entire branch with it.

In addition we might as well let C precedence dictate by getting rid of
two pairs of parentheses in the neighboring lines in order to keep
expressions on both sides of '||' in balance with checkpatch warning
silenced.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 5dd8360b21a0..16f3a2057b90 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1134,9 +1134,8 @@ static int vmxnet3_set_coalesce(struct net_device *netdev,
 	}
 
 	if (ec->use_adaptive_rx_coalesce != 0) {
-		if ((ec->rx_coalesce_usecs != 0) ||
-		    (ec->tx_max_coalesced_frames != 0) ||
-		    (ec->rx_max_coalesced_frames != 0)) {
+		if (ec->tx_max_coalesced_frames != 0 ||
+		    ec->rx_max_coalesced_frames != 0) {
 			return -EINVAL;
 		}
 		memset(adapter->coal_conf, 0, sizeof(*adapter->coal_conf));
@@ -1146,11 +1145,6 @@ static int vmxnet3_set_coalesce(struct net_device *netdev,
 
 	if ((ec->tx_max_coalesced_frames != 0) ||
 	    (ec->rx_max_coalesced_frames != 0)) {
-		if ((ec->rx_coalesce_usecs != 0) ||
-		    (ec->use_adaptive_rx_coalesce != 0)) {
-			return -EINVAL;
-		}
-
 		if ((ec->tx_max_coalesced_frames >
 		    VMXNET3_COAL_STATIC_MAX_DEPTH) ||
 		    (ec->rx_max_coalesced_frames >
