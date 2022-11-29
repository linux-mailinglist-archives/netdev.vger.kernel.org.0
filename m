Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA963BBEC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiK2Inz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiK2Ins (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:43:48 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEF6209B6;
        Tue, 29 Nov 2022 00:43:47 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o12so4172661pjo.4;
        Tue, 29 Nov 2022 00:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C8hpJ+dhKLwcq6yGKXl9JYCXBoLbIiY9R+toMXs7xSY=;
        b=Wn34m7pMHKu6xKX53fvwxU5LRDQO6C7CFeyqdkMEcUFpDIoGxu5z/PT+zprrv2yBDM
         Iur2TvUMe3TzMqsQk7tuM+HbfbQeB75yrTY7neVOR63rb14hapYpEiaOeQx5m7FW37i5
         iy5N74gAONSDkaaSiH7NcamTyyC/Y8p9GNbqnB+otKAW1zRi0gZaOBCOZVvZF7kE4x4b
         3By19zZKLeB3d441YtofIeOozwFOFFarkUeDIEmOGtqWovaa1eZ4o5+NcyGMVwdgj11o
         LFXo25fnU7zHPGwZF3TfE0BFOedsbNWIEp2zy6Ver2MLoPg1PX2v0/TWgIPcqFlIfnAS
         iX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C8hpJ+dhKLwcq6yGKXl9JYCXBoLbIiY9R+toMXs7xSY=;
        b=8FqTABRr1guTgcsgCjomwNS32MjdSNZ+JgmsB3R7WLm/jFxXN6vnSruy6e+MEr3ZZ4
         zIGbnGvb9/Z2Rauny5Ge6ncJiNXrxv7fRh4qnKpIY4CJcxs42K1c4fjSgmLbgT8+klM1
         iaUYMoFWSvPHvb0aPdfmCTmSB/VvT4vSYg6G0DmNiEJYijiofhzfCRP/FtFwJekVZJm+
         yCwjTujJAsDJwCHfaZD86OkD0lr9lZb1eX4wsqHmoqfAQs64XizYvDdCK3aftrCDrdBz
         +kp95EqG7g9PVRGK4lRU3HUUn5j5YPu6L9CDn3tx8wihzKDxrCTrNywW2NeLoFNhUpQz
         EEpA==
X-Gm-Message-State: ANoB5plZTYFvlzp77tlh6uD6zmKtap4ugOVKDGgtzJ6YHHtpspM6ZafS
        dA6rkMTELrI8RdGooYkD3eY=
X-Google-Smtp-Source: AA0mqf4jqFiqmVg6w14Kqk0A/bl7NMFjtgntTfVej4tvGa7DrK3EfOLfMRzWYigDRZnzg481zuwgdw==
X-Received: by 2002:a17:90a:db52:b0:212:d2c2:8e1a with SMTP id u18-20020a17090adb5200b00212d2c28e1amr65321764pjx.54.1669711427518;
        Tue, 29 Nov 2022 00:43:47 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id o6-20020a62f906000000b00574345ee12csm9387640pfh.23.2022.11.29.00.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:43:46 -0800 (PST)
From:   zys.zljxml@gmail.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yushan Zhou <katrinzhou@tencent.com>
Subject: [PATCH] net: tun: Remove redundant null checks before kfree
Date:   Tue, 29 Nov 2022 16:43:29 +0800
Message-Id: <20221129084329.92345-1-zys.zljxml@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yushan Zhou <katrinzhou@tencent.com>

Fix the following coccicheck warning:
./drivers/gpu/host1x/fence.c:97:2-7: WARNING:
NULL check before some freeing functions is not needed.

Signed-off-by: Yushan Zhou <katrinzhou@tencent.com>
---
 drivers/gpu/host1x/fence.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/fence.c b/drivers/gpu/host1x/fence.c
index ecab72882192..05b36bfc8b74 100644
--- a/drivers/gpu/host1x/fence.c
+++ b/drivers/gpu/host1x/fence.c
@@ -93,8 +93,7 @@ static void host1x_syncpt_fence_release(struct dma_fence *f)
 {
 	struct host1x_syncpt_fence *sf = to_host1x_fence(f);
 
-	if (sf->waiter)
-		kfree(sf->waiter);
+	kfree(sf->waiter);
 
 	dma_fence_free(f);
 }
-- 
2.27.0

