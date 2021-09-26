Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08544187F1
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 11:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhIZJ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 05:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhIZJ61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 05:58:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F4AC061570
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 02:56:51 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i24so26139295wrc.9
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 02:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCbQoTbdCnc9olL8antEdmb+iDGDQE5J6yRNY4SMBrk=;
        b=iaETaQXSrGEALMFNHIONxeI2JLztaI5Iq6K0fqO/wcKbAaGL0QJ6+p+OeIys9OrZdA
         T5C20VvqWmyINzOCCx5Ukx/cas9BDMulf+rPzX5FD9uVVQXohtgx97jSD3Kfa/PW9c+J
         BaYsZz1TFhMxDoQnfrK+fQkJxclieysMjmHBahO0KULEZXApsCG9ShSSm7qc+8tOvpyF
         VP89UOCqS+i9Z8FvSmWxs2hbTvISkAJU2aFAfFF4uvxppKQKqng3qQ7Ru11TDyhl0t8S
         Ss/IrUPFbACdrm+oaCOIbWK4e91Bpwf4FMDzxLph9Ixj+dYKtjinJIIULuxRB9pRkRtT
         ufSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCbQoTbdCnc9olL8antEdmb+iDGDQE5J6yRNY4SMBrk=;
        b=L+8vr0kGhOIOCfSUo5yhkYWpXqbcrtaLAHDfYSZPWRft6WTBvQJ5hIU/vtRTMPu5mL
         HRQh9P37pH6Bnt3wroHeja7RwhYrF2QfAeE7ndm6cOOU1qqHLrsTuyZg9fBOItW/4lJR
         t8CyywQ+8CjSWDDN7ys7xY4tbacm2cxLH2H+KcX4WY5ZUrrlZbgptirDqIE9gFvF8kdu
         Fe7oZfnR8AQ7qbs/d5I6MEHueo1OwmnrtcOfqwf7RR78ozL6uTMaTFP0o7RtHEeJL6t6
         9KRqxwcPfxVp8zKs9HQR1XBEpAZZwvhoVpzeKSPA9nj/JoeaOwhPaxBNdzjcBsqJxCKJ
         C1qA==
X-Gm-Message-State: AOAM530H8UqetnkLYstmOUzMu4mRV4QoCQZMf1IftA2tSvCvsI/DldL2
        bn6rE59DqDh0HRyZoKDfZvNcU9JavTA=
X-Google-Smtp-Source: ABdhPJx5hkxMKNQAnmRxBGLA4vorrDMlKO/iwDk2X1B2ZAjH/uxdPgHj+Js5oXjivaphBosC9gwAvg==
X-Received: by 2002:a7b:cbce:: with SMTP id n14mr10639269wmi.169.1632650209679;
        Sun, 26 Sep 2021 02:56:49 -0700 (PDT)
Received: from debian64.daheim (p200300d5ff444900d63d7efffebde96e.dip0.t-ipconnect.de. [2003:d5:ff44:4900:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id h18sm15781994wmq.23.2021.09.26.02.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 02:56:49 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.95-RC2)
        (envelope-from <chunkeey@gmail.com>)
        id 1mUQts-0011am-JE;
        Sun, 26 Sep 2021 11:56:48 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v1] net: ethernet: emac: utilize of_net's of_get_mac_address()
Date:   Sun, 26 Sep 2021 11:56:48 +0200
Message-Id: <20210926095648.244445-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_get_mac_address() reads the same "local-mac-address" property.
... But goes above and beyond by checking the MAC value properly.

printk+message seems outdated too,
so let's put dev_err in the queue.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/ethernet/ibm/emac/core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 3fae7f943df1..43a29c66d5cc 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2967,7 +2967,6 @@ static int emac_init_phy(struct emac_instance *dev)
 static int emac_init_config(struct emac_instance *dev)
 {
 	struct device_node *np = dev->ofdev->dev.of_node;
-	const void *p;
 	int err;
 
 	/* Read config from device-tree */
@@ -3099,13 +3098,12 @@ static int emac_init_config(struct emac_instance *dev)
 	}
 
 	/* Read MAC-address */
-	p = of_get_property(np, "local-mac-address", NULL);
-	if (p == NULL) {
-		printk(KERN_ERR "%pOF: Can't find local-mac-address property\n",
-		       np);
-		return -ENXIO;
+	err = of_get_mac_address(np, dev->ndev->dev_addr);
+	if (err) {
+		if (err != -EPROBE_DEFER)
+			dev_err(&dev->ofdev->dev, "Can't get valid [local-]mac-address from OF !\n");
+		return err;
 	}
-	memcpy(dev->ndev->dev_addr, p, ETH_ALEN);
 
 	/* IAHT and GAHT filter parameterization */
 	if (emac_has_feature(dev, EMAC_FTR_EMAC4SYNC)) {
-- 
2.33.0

