Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E684BAC34
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343753AbiBQWDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:03:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbiBQWDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:03:15 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEB141FAF
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:03:00 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id p8so799592pfh.8
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CNTw7K+ZNV4HqVHbsbV+Nv600bXCU69KlzCgLh9rjN0=;
        b=1Zehp62/N7tX1y36b3+ETO5plqoSKwmFOpDwjTB5pMx4WzpZdp9g/VkWFwpA8EnX2J
         I66Uw1qppQznZDqmoafl+TQlPxWMWz43kdUst8BLsyoONM6W+Jhwz5Fpfj/z91Y6+XZF
         ScPYqV7T6tEpVk4wpqixrYGcw7uHThogkljnHsjIOFa9AmViPLFws4fIIdHQcrEbqVaF
         NX+RvzVXut4itDbnmrEHcJbilk8r3ozsWc2OxW1hlaBbAr+X9nSQB6owrB28E8f7pU4+
         zT8aH5b9t3cioY0zHVba5THbSsQyQ/h2rpiczR2CQiDDPgw+1xtuYcjZcU977gApkjm3
         3pkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CNTw7K+ZNV4HqVHbsbV+Nv600bXCU69KlzCgLh9rjN0=;
        b=qKc3d18pcLbAmExu17azjNigru50tWm3TciTUXwdBpDCKRH7HtDbpaz/hyjKzUbrpY
         F0bdtl8iA4wKfk2gHxK/Bnd2Z52n4FydC87LB8fYHnZmt8E8l+qfA2cHemc0wSoib+QX
         g2NQ5E8idb6tria0xYSRb3i09qhbvCog8jgvUaGFKyD5/HZxnXTnogAHnus8BUoltPso
         icOpm13SVYEMv3NOT5z2E/Zp4nzaEYnAwW6QxF0wxZUCneuuooB4Xxk+rG5infgmcJTB
         fF5NhEdYr2Cp62uF85gdHT2zvY+sN2uIc8PvB+Uo35+HCq/Y4gUPgcqAF/wKmKKv7U45
         dbrw==
X-Gm-Message-State: AOAM531eavgZ69iXuej9GbEcUvNBFMd8khJPqoHFbGgPZ3+L7Sli2Xdk
        uLJ6AHqe9Ic1imXV1lAk7WApdw==
X-Google-Smtp-Source: ABdhPJwV3W3ZTBGDoDVGjuvhIvhcPeEzUeoZQd01YYH9j5Fo8A4EhenPmsSITQHfeAwaFBoH69/iIw==
X-Received: by 2002:a05:6a00:8cc:b0:4cb:b981:2676 with SMTP id s12-20020a056a0008cc00b004cbb9812676mr4762464pfu.5.1645135380338;
        Thu, 17 Feb 2022 14:03:00 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 16sm516119pfm.200.2022.02.17.14.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 14:03:00 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/4] ionic: catch transition back to RUNNING with fw_generation 0
Date:   Thu, 17 Feb 2022 14:02:49 -0800
Message-Id: <20220217220252.52293-2-snelson@pensando.io>
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

In some graceful updates that get initially triggered by the
RESET event, especially with older firmware, the fw_generation
bits don't change but the fw_status is seen to go to 0 then back
to 1.  However, the driver didn't perform the restart, remained
waiting for fw_generation to change, and got left in limbo.

This is because the clearing of idev->fw_status_ready to 0
didn't happen correctly as it was buried in the transition
trigger: since the transition down was triggered not here
but in the RESET event handler, the clear to 0 didn't happen,
so the transition back to 1 wasn't detected.

Fix this particular case by bringing the setting of
idev->fw_status_ready back out to where it was before.

Fixes: 398d1e37f960 ("ionic: add FW_STOPPING state")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 52a1b5cfd8e7..faeedc8db6f4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -206,6 +206,8 @@ int ionic_heartbeat_check(struct ionic *ionic)
 	if (fw_status_ready != idev->fw_status_ready) {
 		bool trigger = false;
 
+		idev->fw_status_ready = fw_status_ready;
+
 		if (!fw_status_ready && lif &&
 		    !test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
 		    !test_and_set_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
@@ -222,8 +224,6 @@ int ionic_heartbeat_check(struct ionic *ionic)
 		if (trigger) {
 			struct ionic_deferred_work *work;
 
-			idev->fw_status_ready = fw_status_ready;
-
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (work) {
 				work->type = IONIC_DW_TYPE_LIF_RESET;
-- 
2.17.1

