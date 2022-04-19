Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B327B5066AD
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349876AbiDSIS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349947AbiDSISN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:18:13 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0169632C;
        Tue, 19 Apr 2022 01:14:56 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id x24so3235388qtq.11;
        Tue, 19 Apr 2022 01:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mj8GBm7fHLra8a9Wmaa9qaJw0tz/2aEtzPHOqJEgUyw=;
        b=VZj+g5TEqFwrOt3e8foNXSoqon431CGXfIpFC2WjAx05e6oe8RlRGadnEsb0PWHPx8
         MExUVIDkXpJueV34Xf1xPNG04WaULeWZOhIRE7V4+qlpGLxLdX5wMA+qx6vluFhlXlhL
         2Od7e732KvQev7rInDsV6I5rw/cOFchzCqAGcfMmUlPPZDa1W/mimfN6Pe+8URTj25ws
         sLZBDQoSx3AIYLtDamiAB5RolOjud+Gv7wDgw7DeozCnXMJKbSzpI+c861CIsxreMApc
         gMb/CsOni2dy0F6OVYLTJpoex/nMDly2mseAFFpuJxj/Kftfr3l9HC3k6J2ShjMYDZyJ
         Ov6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mj8GBm7fHLra8a9Wmaa9qaJw0tz/2aEtzPHOqJEgUyw=;
        b=3Q/43VgmhOMzKl0baMqF2EB+x1HCveFKCHeOo8DoR0ilaIxS7lB3KCZMKGFVCuMg6k
         aKcUCGqXl0YNNXiWJz+w8/+dlygUaNIi711KgNgYjYXkvL5BpY+cwD9O6ZVQeO0X36IX
         5JCH74JEy8P8NA0qDiqVGgEPuqJ4fPFiDrWGIHM4bWsfu0Zn0dGpjmlhcXHKtldgoxRS
         aOBJhWFeyM7vpLiisIno5MlMYuTN23juaqqc1RPO33+cwJFzYwu535WbxQjb6CwkI/0Q
         IO56rvkmNVrUCiMAqaSb0R/Zn5H7sa6NFtuMOam9PIaqATPvSVpXaYKpALhILzP4XcGn
         VUKA==
X-Gm-Message-State: AOAM532tCQqxkcm8c7iCtwPSLhazwZjKn9J55umGIWJfOajc4HAn5dyc
        5/zAmnmw9+jgHYXfmPY420M=
X-Google-Smtp-Source: ABdhPJx+JlotR1kfZlhHiYV5w5lFiOs6ai3kGB9qZ/ssBH8h1S8SzII4+Qjcat7pYOKsIVSbMUO/Yw==
X-Received: by 2002:ac8:7c46:0:b0:2e1:d6c2:2b15 with SMTP id o6-20020ac87c46000000b002e1d6c22b15mr9491744qtv.405.1650356095930;
        Tue, 19 Apr 2022 01:14:55 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p5-20020a378d05000000b0069beaffd5b3sm8061423qkd.4.2022.04.19.01.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 01:14:55 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     wg@grandegger.com
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] can: flexcan: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Tue, 19 Apr 2022 08:14:49 +0000
Message-Id: <20220419081449.2574026-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Using pm_runtime_resume_and_get is more appropriate
for simplifing code

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/can/flexcan/flexcan-core.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 74d7fcbfd065..459e8aecabd5 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -723,11 +723,9 @@ static int flexcan_get_berr_counter(const struct net_device *dev,
 	const struct flexcan_priv *priv = netdev_priv(dev);
 	int err;
 
-	err = pm_runtime_get_sync(priv->dev);
-	if (err < 0) {
-		pm_runtime_put_noidle(priv->dev);
+	err = pm_runtime_resume_and_get(priv->dev);
+	if (err < 0)
 		return err;
-	}
 
 	err = __flexcan_get_berr_counter(dev, bec);
 
@@ -1700,11 +1698,9 @@ static int flexcan_open(struct net_device *dev)
 		return -EINVAL;
 	}
 
-	err = pm_runtime_get_sync(priv->dev);
-	if (err < 0) {
-		pm_runtime_put_noidle(priv->dev);
+	err = pm_runtime_resume_and_get(priv->dev);
+	if (err < 0)
 		return err;
-	}
 
 	err = open_candev(dev);
 	if (err)
-- 
2.25.1

