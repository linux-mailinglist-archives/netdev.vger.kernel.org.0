Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3245EECFD
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiI2FEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbiI2FEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:04:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121BFEE2B;
        Wed, 28 Sep 2022 22:04:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id r8-20020a17090a560800b00205eaaba073so306534pjf.1;
        Wed, 28 Sep 2022 22:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=MC+eI3i/t3K9Sg+2EGrsVaTd5iJWGGfd3bEqBpabEg8=;
        b=NfU5l7/HjCD7GuH1ULRdff8ER+2hDIJ6pqibCeYUZb+zXyJX5Y+ScIP3OMkflrllJ/
         kWe7puQbTcdwmzBxkUjDqrKzCPBAuCwmIo3d62G0mQp2HKP+QKZ4JjWuSsZWobCB0C2v
         QCSlOkU87NGhwR4A25RD+DU+6jpKGIvytxevXgSn91IVokNPNK+c3vtdQwidLOcn9b1i
         1gEAqgBNI/Ko3nipmGGTIifiEi0KZLZgRYtedVs8WS0/ihfKg4sZhqznF6S7l7n5BeNV
         OIIbJrZ2C5ueFZIU2i4Q7BWk5tBChtU6oX/gK5DF7U6sjhsaxP+VPc389puuLWTtdPat
         F3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=MC+eI3i/t3K9Sg+2EGrsVaTd5iJWGGfd3bEqBpabEg8=;
        b=Pc17IPs6k4hglLMT2eYfMI4ZZqWtkY/Zej/bYFVWuXdI8j7jOhb0IkKfHYUJK3tNGL
         HNxXTCCWR357VzrfYPdvsswF/fx2IDW5WNhCeKQm0wn3Sk3iRNGDAEqPhzneomFPvzsU
         ffyxK9NF5N+VdeHtCewO3yK4uuj9Op2Sz/rCyTBzvdvZF5f35+DlCeuNW466jJOau/BT
         69epSY/UVBCgQH9G2NfRfXvZ4Mj2QiM9YmqazBN5U6IshfeFi45btHaNRjpknUwibM9j
         6VNBMhGNRQIcnt3XIOyPyyG2vEuQcsDOytj7NSDnQUrrNmyAL96JyUJvOZ1JoPubtBsy
         F4Cw==
X-Gm-Message-State: ACrzQf2HBUOWjB5JltnSWUA1diGR7PMUGC8JjCir2jDJXnydepCCpinD
        cYSPhfG9on/dGE4tLxRWDwY=
X-Google-Smtp-Source: AMsMyM5rOVFb4ynre9HopT1jJsgN4ddXCwc8yTdodHFoxR+3Veih0rzdqSYyGBwPBfLZsFC7iQ9iWg==
X-Received: by 2002:a17:90a:6887:b0:203:5861:fc5d with SMTP id a7-20020a17090a688700b002035861fc5dmr14561604pjd.132.1664427870380;
        Wed, 28 Sep 2022 22:04:30 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:637c:7f23:f348:a9e6])
        by smtp.gmail.com with ESMTPSA id ij25-20020a170902ab5900b00179f370dbe7sm4314330plb.287.2022.09.28.22.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 22:04:29 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] nfc: s3fwrn5: fix order of freeing resources
Date:   Wed, 28 Sep 2022 22:04:25 -0700
Message-Id: <20220929050426.955139-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Caution needs to be exercised when mixing together regular and managed
resources. In case of this driver devm_request_threaded_irq() should
not be used, because it will result in the interrupt being freed too
late, and there being a chance that it fires up at an inopportune
moment and reference already freed data structures.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index f824dc7099ce..fb36860df81c 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -231,9 +231,9 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto disable_clk;
 
-	ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
-		s3fwrn5_i2c_irq_thread_fn, IRQF_ONESHOT,
-		S3FWRN5_I2C_DRIVER_NAME, phy);
+	ret = request_threaded_irq(phy->i2c_dev->irq,
+				   NULL, s3fwrn5_i2c_irq_thread_fn,
+				   IRQF_ONESHOT, S3FWRN5_I2C_DRIVER_NAME, phy);
 	if (ret)
 		goto s3fwrn5_remove;
 
@@ -250,6 +250,7 @@ static void s3fwrn5_i2c_remove(struct i2c_client *client)
 {
 	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
 
+	free_irq(phy->i2c_dev->irq, phy);
 	s3fwrn5_remove(phy->common.ndev);
 	clk_disable_unprepare(phy->clk);
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

