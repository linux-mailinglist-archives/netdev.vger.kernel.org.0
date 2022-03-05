Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4A14CE541
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 15:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiCEOZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 09:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiCEOZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 09:25:47 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CC5A7748;
        Sat,  5 Mar 2022 06:24:56 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t19so6621110plr.5;
        Sat, 05 Mar 2022 06:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=V0+BPych17wtPc2qM6EJ5swnTMFGy4m1k60tybQ7bJ8=;
        b=S541tO/7BOECRkLObQ/ss88E0L5lW9NqwCtyPSw3nTGHljZZHO/1w+ZQc0jAaVlnj6
         HS5LW7+pVNKhIQHu7Zy+ujo5/Sml34pebkIhx6y2vf6v7GRc3bmhCFwyfJhtRybriztn
         M+anDplw+EGv8oPG0xeUS5mQncJ/ZYVLqqubhCO7nPARaCRC2JV4HcYkIiiQMa+Xw5kt
         azyq7xnXayNdLNYP3odh0HSo6FGstz+DAN0I+Ss/RxoaqIyH8VmwZ3QbUShDZlSk447y
         QdYj0sFrecg7toRUpkb8IY34lvAg19+4WlpTdbqDbFlR8l70M9v11pf+ixJ87TED+UCX
         l8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V0+BPych17wtPc2qM6EJ5swnTMFGy4m1k60tybQ7bJ8=;
        b=O0HscLV+1ES2BJlbdOorUTPK5RHYqNpsipQzqEoGnafL1IsPCO0L08EPeP1Oe8u1s9
         QqPaIt13h8uQO7NvWt3wM+yHqVR22Ogksc1L9kpgYpKNjdAlxQaPfZMbA3e0ucHMu9iL
         iRXMkylIJN6d3jZwIi9mx52GLQpmvLkmY4xcJ8hJs/NTQDrD2Axug1Wi/gb/aN74wmCA
         Lw++VK4FXEzmKEkpQEpGsfGavIToPcGkiI4wnHgSXBCrAMfAlGL22ojSQx1ts/eLYu0D
         ruo2XvcoXyeNbrYtw/MhlxhOrB0HgUejJkukW//j+RnnOyNQE03h1J5ULsrge5XbziMN
         IsmA==
X-Gm-Message-State: AOAM531BcZwgNbTIXjYwiIVMiS0gisbstUUZbH4rqvVqRS8qeYoC3eJP
        2mmhABWQ3dbrQmA1HsUOCg==
X-Google-Smtp-Source: ABdhPJy9LM8LD0Szs9UH11qFmWCM+7jwNJQ393lKOth1A/hR2oMDpmorF/tRORnbWEX3mtJicgnEgw==
X-Received: by 2002:a17:90b:1a81:b0:1bc:c3e5:27b2 with SMTP id ng1-20020a17090b1a8100b001bcc3e527b2mr16247200pjb.20.1646490296243;
        Sat, 05 Mar 2022 06:24:56 -0800 (PST)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090acd0500b001b9c05b075dsm13515189pju.44.2022.03.05.06.24.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 06:24:55 -0800 (PST)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] net: cxgb3: Fix an error code when probing the driver
Date:   Sat,  5 Mar 2022 14:24:44 +0000
Message-Id: <1646490284-22791-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the process of driver probing, probe function should return < 0
for failure, otherwise kernel will treat value >= 0 as success.

Therefore, the driver should set 'err' to -EINVAL when
'adapter->registered_device_map' is NULL. Otherwise kernel will assume
that the driver has been successfully probed and will cause unexpected
errors.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index bfffcaeee624..662af61fc723 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3346,6 +3346,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	if (!adapter->registered_device_map) {
 		dev_err(&pdev->dev, "could not register any net devices\n");
+		err = -EINVAL;
 		goto out_free_dev;
 	}
 
-- 
2.25.1

