Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC04B4C44AC
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiBYMiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiBYMiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:38:12 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933BC18C796;
        Fri, 25 Feb 2022 04:37:40 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id j22so4247857wrb.13;
        Fri, 25 Feb 2022 04:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=CSTsw37uGTMQMmo2MPb/ZjTSAMq/D8OaWkRV6tZQV8M=;
        b=ivIdQlTKCxvIhun4vPEG6HJ8enjVHHPj5yIdImNQ3qzhYog/3B85H9dp4aV0AdOvZP
         z5pYubMRvzkqY2DfShjITa9QgKYYdKk3/DK2PvKmAF4+jbqCrA35lg5oO11gt1JYD70m
         WSHGU+1dETq0NTYw95G1C15lrj0MTp617MGRpYUH5bt2azHlJE135OK3iUOhouoyHOng
         gAzrb3i3ZVqeQy5zMDJDja3negugDQQQ+5viIzdvVlglRii2NKyuVC+DFZKnVj1fWGQe
         ZQYh2kbzd66JqziByAsUDBZQVmSC/X/S7quMMPNDt0sPe7fp0q9FilvOoft6ppFVMh3o
         ZFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CSTsw37uGTMQMmo2MPb/ZjTSAMq/D8OaWkRV6tZQV8M=;
        b=hozhtptKQZWbbnw86OG4xBG2pifvHSGSYl/mcCO5K3uGMacHTowu7bPs8+OpvgPYae
         dp1jgmzEV2FfAakHeZ3dIDTCVs2W/Tz4IlBgj3GPjFBmcKAc1NLHj7YWLsXpOhc9wGei
         IX9ckfwslIfRqPprzDe/du+Egoda0/j0kkHieWFChKxo3gNTUhCPOibL4tzHpx6mWxux
         56p7abV3ayrgQUvGLPArTsSj6RFwvjlj5BWGnJM9Ai/yrKqNf/DIFYu38xokWBSpr00a
         riJzY1eD5bxseh85wD4vsXk1Vdq57pv95r1pN75T/+Jdemg0n5dm6YsE9wSe3kwqN/FU
         C+DA==
X-Gm-Message-State: AOAM531xJyVJfZC89BSd7CeYMzY652WIvnvzZiaZ8GQtIFedxPw5rfW7
        lfAO5XKix89/L968CtfxK6DDAQ4oAxJnyQ==
X-Google-Smtp-Source: ABdhPJytxSl9UmCZOdztzcceE7YOkQFOPczDl6kdQofPeRp7bROi9WiZsNwMvOWr9ExIz4hTnWzCBA==
X-Received: by 2002:a5d:59ae:0:b0:1dd:66c3:c67b with SMTP id p14-20020a5d59ae000000b001dd66c3c67bmr5886991wrr.400.1645792659099;
        Fri, 25 Feb 2022 04:37:39 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.58])
        by smtp.gmail.com with ESMTPSA id k4-20020adfe8c4000000b001e68c92af35sm2200452wrn.30.2022.02.25.04.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 04:37:38 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: chelsio: cxgb3: check the return value of pci_find_capability()
Date:   Fri, 25 Feb 2022 04:37:27 -0800
Message-Id: <20220225123727.26194-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function pci_find_capability() in t3_prep_adapter() can fail, so its
return value should be checked.

Fixes: 4d22de3e6cc4 ("Add support for the latest 1G/10G Chelsio adapter, T3")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index da41eee2f25c..a06003bfa04b 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -3613,6 +3613,8 @@ int t3_prep_adapter(struct adapter *adapter, const struct adapter_info *ai,
 	    MAC_STATS_ACCUM_SECS : (MAC_STATS_ACCUM_SECS * 10);
 	adapter->params.pci.vpd_cap_addr =
 	    pci_find_capability(adapter->pdev, PCI_CAP_ID_VPD);
+	if (!adapter->params.pci.vpd_cap_addr)
+		return -ENODEV;
 	ret = get_vpd_params(adapter, &adapter->params.vpd);
 	if (ret < 0)
 		return ret;
-- 
2.17.1

