Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513CB527E89
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 09:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240989AbiEPH1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 03:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiEPH1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 03:27:22 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229D81CFD9;
        Mon, 16 May 2022 00:27:22 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l11so13283048pgt.13;
        Mon, 16 May 2022 00:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u+W9UG3urbjXC8PxMREWcyEMwSpmJo1lO2QpcyV4GJA=;
        b=bUwN9FJ1tvzObWLZhKZyhk05Mv5aWPx7Rrz2U3JzJD76QnZ8VASQCrcA/uYYSFFB/G
         HAu4eS2x0W6htIcEeFH4z07Tnraij70WIWPR/EvZ3QlD7HtOicNZATmG6AJRfROPhT9L
         m2kJPRwPG9ElapEjIhV9ZX+P2aO/YByO1GEArt4FCLEaE3h6O9N9+eEKkXBMTWLoVKYQ
         KwH31w/JJRLFDCHcU+zIkPEADzytK9ginM/OaeELkOzKicFgLBfkR12sssPVL+1g7u3g
         5LncGuzkPAo3TBEWPC04mLGC7bKhdwM+uaXbngNyxPIu58UQfsMBtzihiFv2sTY3pYTw
         jhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u+W9UG3urbjXC8PxMREWcyEMwSpmJo1lO2QpcyV4GJA=;
        b=tahHv2rh+yTq5FasMtWHxMO/6Ut4ioOYcp0HM6MCGT+1xBv0Yk3BFEL0jdkdIsiEbP
         ODjBhc3rQwuI9tHMEIVPAvRi1e0HE9SzWeZMl95R/tPDb2IYYfCcUrs5IEwYMkt9N4wz
         CttPOgzIo0JoTCy5RPLTLOKjEC++1LihehLpM2nmwOOJs1DklDC5PCGyfWB8K/Y3NxaC
         Jm4LRWLtg18140v6p2Qq0fzVR2/g1t1Iw5sPKH5TtSWRzSq0lwGoaC5PCY7E15ThU+u4
         SIe9CAxrVaF8zTUWj7Zf3jTFclDUjxCdBmZYNBFyvxAc9NiBV7rSuFDAMJu68T9q7K/3
         zh/Q==
X-Gm-Message-State: AOAM533EPOzmtyuCdrAoDlYJHz0sIH7clb/diKdvpPv8IQPkUs3uWVim
        Cw9fsuHQkZc81OkAMZNH8BM=
X-Google-Smtp-Source: ABdhPJwDFhCAO1aZWNa+FCSEiVvYi70Z0JfWXHcUmqy1lHX0hkU2Hxy5x90O+JKL8MQDfHzVZrqYDA==
X-Received: by 2002:a63:1519:0:b0:3f2:5439:b0fc with SMTP id v25-20020a631519000000b003f25439b0fcmr6614341pgl.52.1652686041726;
        Mon, 16 May 2022 00:27:21 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b0015e8d4eb27csm6331750plg.198.2022.05.16.00.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 00:27:21 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     jesse.brandeburg@intel.com
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] i40e: Remove unnecessary synchronize_irq() before free_irq()
Date:   Mon, 16 May 2022 07:27:17 +0000
Message-Id: <20220516072717.1651178-1-chi.minghao@zte.com.cn>
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
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 332a608dbaa6..2b654a53a3f0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4037,7 +4037,6 @@ static void i40e_free_misc_vector(struct i40e_pf *pf)
 	i40e_flush(&pf->hw);
 
 	if (pf->flags & I40E_FLAG_MSIX_ENABLED && pf->msix_entries) {
-		synchronize_irq(pf->msix_entries[0].vector);
 		free_irq(pf->msix_entries[0].vector, pf);
 		clear_bit(__I40E_MISC_IRQ_REQUESTED, pf->state);
 	}
@@ -4776,7 +4775,6 @@ static void i40e_vsi_free_irq(struct i40e_vsi *vsi)
 			irq_set_affinity_notifier(irq_num, NULL);
 			/* remove our suggested affinity mask for this IRQ */
 			irq_update_affinity_hint(irq_num, NULL);
-			synchronize_irq(irq_num);
 			free_irq(irq_num, vsi->q_vectors[i]);
 
 			/* Tear down the interrupt queue link list
-- 
2.25.1


