Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3594C8828
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiCAJhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiCAJhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:37:13 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD788BF1E;
        Tue,  1 Mar 2022 01:36:31 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id bx9-20020a17090af48900b001bc64ee7d3cso1715740pjb.4;
        Tue, 01 Mar 2022 01:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9PitZ8nos2JLpD1cvo3wp1YCaRCWvKUI1RHgpAgRhjo=;
        b=YKN7t0gbX/W3dYuoCr8j7HyWdARzIb6Qe6ouXZkiqfV/vbBnbvwJE2l3jcfR4UWOYe
         xTs5o35w+rSNFQ+ln8XGFPrnRjZOhs91evaJvTOUH7hUyQRynltdZaMmf7J1lJT6AzVk
         kk9Wv5Sz2MHddl0f77kMy8PEz0e39hvJTJvMHvzieOnJZo7nUNVTQOYzeZ9zBMWSh+Lz
         HJ9h8nPUDmKUD0BRQ5USUJPdFa5NMlC/XnFOK1fM8cjeoZZIrrSRchibs2QJRaLcknUa
         sFY8nCVp19F6CJdViRqmG6+dsTp0miQKCZ6f4hLUqCxI7INl0G/riPM5dUOWI0OVeRd+
         TzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9PitZ8nos2JLpD1cvo3wp1YCaRCWvKUI1RHgpAgRhjo=;
        b=osAMXeuGWn4e8QnP0OuexxrAHm7mG77LEmzgrc4a32cu2u7vdF0yWuTsAbkrNDNNSf
         AQhizrbNjaVB+bBjKErXhNahEpxuNp9Ht/j2rfn7x4pIklfvfhLSJ8YE7UxwnuKMON+2
         nO78DLOnc/SK0auEDSVTe/ihE9x70oZpd/V3A07r0cncvcgjDG/xrE9elYLY5bPJDfb7
         6/GBGvmifG0aLI7HpTOV911l20doKDg2T6PYd6p5t8bXHlUHB6mUqMPA+x/DoU80+gOn
         EEJhQ7bnOgrLHQv732UFCoxXU4qzolGE40dSS5sTUcl9G7fOY1E7ofVo1XBhFWafhUQ3
         +kGQ==
X-Gm-Message-State: AOAM532WuGgC6R7C2SctHLiep0vqXLzZ8viYpIGGTTTirVmmFURWaLNk
        qpXyJESGCPh5IVAefQpsSZc=
X-Google-Smtp-Source: ABdhPJwTTYFuiYBrqBydgj/V0cOnJIGBMEyWGzsapumS+QqM4wTdxTNnQYJvAfI6JYCPjLYUAIc3cg==
X-Received: by 2002:a17:902:c403:b0:14f:ecc9:bc82 with SMTP id k3-20020a170902c40300b0014fecc9bc82mr24354108plk.27.1646127391117;
        Tue, 01 Mar 2022 01:36:31 -0800 (PST)
Received: from localhost.localdomain ([115.27.208.93])
        by smtp.gmail.com with ESMTPSA id bh3-20020a056a02020300b00378b62df320sm4131779pgb.73.2022.03.01.01.36.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 01:36:30 -0800 (PST)
From:   Q1IQ <fufuyqqqqqq@gmail.com>
To:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lyz_cs@pku.edu.cn, Q1IQ <fufuyqqqqqq@gmail.com>
Subject: [PATCH] dpaa2 ethernet switch driver: Fix memory leak in dpaa2_switch_acl_entry_add()
Date:   Tue,  1 Mar 2022 17:34:44 +0800
Message-Id: <20220301093444.66863-1-fufuyqqqqqq@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[why]
The error handling branch did not properly free the memory of cmd_buf
before return, which would cause memory leak.

[how]
Fix this by adding kfree to the error handling branch.

Signed-off-by: Q1IQ <fufuyqqqqqq@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index cacd454ac696..4d07aee07f4c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
-- 
2.30.1 (Apple Git-130)

