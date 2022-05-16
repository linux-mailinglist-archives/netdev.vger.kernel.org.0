Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D621527F87
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 10:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241601AbiEPIVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 04:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241645AbiEPIVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 04:21:52 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAFF3701D;
        Mon, 16 May 2022 01:21:47 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i24so13382554pfa.7;
        Mon, 16 May 2022 01:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O0TiBO73BII/MzrCAHzOpYtsDk7KXOAsa2LtIBAC5Gk=;
        b=IfOuW2vin7vUKjzYAtKuWx2/rWr6p3AXqn3rBg76roBvgX+1zBMK29EOlS1E3qiHpb
         xL5CL9VfcV5nWVMkLXSd881MjeEUjC41OB8vb8j9G8dmgaCoUpmb6V63mMs4v20nH/W0
         xP/Y3ue7XdZd5U6fmdg+sAUQlaEj5ihJY6wlmyBpdJz1kzCbRS61nJLJy6Q9STyAmoml
         0k+0rQrrKGC2M03sjPtB8Dz5z/WMgsWZ9pXHk235nsONG7EH25HcMEWis5XNTceZykXL
         Y23vqOH+xmahcOcset+zy28sJXNygyNKhD5wSdXCkk3Sxgm+1oyIUoWE4lKnNl5ux1Vx
         kwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O0TiBO73BII/MzrCAHzOpYtsDk7KXOAsa2LtIBAC5Gk=;
        b=l4ueP27tJyKDrhDWaEKLHfTG2eju5P6pvGR1/COmAASlY4qBL4IOBwM4r+j6FbTD4Z
         wPu33e6mYg12w8hd+ym567Lcre8S9gX3xw+JuaPqHfPDNxL0GDPdAwIiGWljJt1DSg5K
         EoJ1d4Ncn2+2LVW650eqxYQcINO0CtfAa+Vz3TrmsfQ3PtjALU9YAJeWiTUGRxX79nr+
         fOs/WZmEOLBNVDaGrKweIagL/rZTY6WI66Uwl4ve3tA6UzIOlhkpv6XTg0zvG6Gun/mr
         FCuEsFiKGPWurnsNjh1xYjnvspmFJRgNA+Sgq1E2IDiEoUDwQv3MXGxilYOs+depNJIu
         PzFg==
X-Gm-Message-State: AOAM530ar1NYokS9o5+SJRVwTFveI1OOqYkVDD2oINsDCGUKc9tzTAMz
        x0JVpuAs5l6dWvpCtMLvIiQ=
X-Google-Smtp-Source: ABdhPJwCdHCi69vYPF4Tu88drOWDnyUagdmB6DmuUma7AAp9Sjw9bPvMfiVYx7G0Sp02lxVPuq4FiA==
X-Received: by 2002:a05:6a00:1d8f:b0:510:9430:8021 with SMTP id z15-20020a056a001d8f00b0051094308021mr16421305pfw.55.1652689306559;
        Mon, 16 May 2022 01:21:46 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090a7f8900b001cd4989fee6sm7858711pjl.50.2022.05.16.01.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 01:21:46 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     jdmason@kudzu.us
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: vxge: Remove unnecessary synchronize_irq() before free_irq()
Date:   Mon, 16 May 2022 08:19:14 +0000
Message-Id: <20220516081914.1651281-1-chi.minghao@zte.com.cn>
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

Calling synchronize_irq() right before free_irq() is quite useless. On one
hand the IRQ can easily fire again before free_irq() is entered, on the
other hand free_irq() itself calls synchronize_irq() internally (in a race
condition free way), before any state associated with the IRQ is freed.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index d2de8ac44f72..fa5d4ddf429b 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2405,7 +2405,6 @@ static void vxge_rem_msix_isr(struct vxgedev *vdev)
 	for (intr_cnt = 0; intr_cnt < (vdev->no_of_vpath * 2 + 1);
 		intr_cnt++) {
 		if (vdev->vxge_entries[intr_cnt].in_use) {
-			synchronize_irq(vdev->entries[intr_cnt].vector);
 			free_irq(vdev->entries[intr_cnt].vector,
 				vdev->vxge_entries[intr_cnt].arg);
 			vdev->vxge_entries[intr_cnt].in_use = 0;
@@ -2427,7 +2426,6 @@ static void vxge_rem_isr(struct vxgedev *vdev)
 	    vdev->config.intr_type == MSI_X) {
 		vxge_rem_msix_isr(vdev);
 	} else if (vdev->config.intr_type == INTA) {
-			synchronize_irq(vdev->pdev->irq);
 			free_irq(vdev->pdev->irq, vdev);
 	}
 }
-- 
2.25.1


