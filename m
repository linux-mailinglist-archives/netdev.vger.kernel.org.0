Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3864B4C87CF
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiCAJ0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiCAJ0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:26:47 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3663C6B098;
        Tue,  1 Mar 2022 01:26:07 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id w37so13941938pga.7;
        Tue, 01 Mar 2022 01:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dpPfXCVIVic4IO/yNFowNfq6++iUgC1vjMlrqF3PzrY=;
        b=NTyQV3hnVA2m/a5GnW4m+f2vzbBMkM7OJONvGAM0Ixg5j51lwtu0kffCQDwWEtuByo
         dZQZpLdcH3dn3TBdUc/r00+YxTy/1vZ7Fv2u7vWRElxECLUoS/CsC29AU8nd3G6D5+to
         Lf6s6RIs6l/MzaE/WEOfbpy6+dekYeNRFdxsN4U5lm/HiplOw0x+h77sXwJmx2zce/cK
         NSwm/H3kp8Kkoc/zpaRkb5q9SAj3P+uaoaTEuw8TqPyJzzoS1BP0pQbOM44Ap3rj4gvi
         bjpOYtPcJ7/kY0A6OWGWm315OjueshDlA1cVgyElWzKVG5YgZKuU3QkC4TQUqU61aDnp
         yUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dpPfXCVIVic4IO/yNFowNfq6++iUgC1vjMlrqF3PzrY=;
        b=ZDe5g1CFfsNc5zi3wFrgs1STTwPA8Fvf1LovSkm8u4IyE3f0TRSiRxBXYyOa4ZPM7o
         MtYhyAMesfKqPl7Eb8/2vzDhWeXniGq9fl5gJqN377RxsUZsUUG2LszNy17CQKKmi9+r
         Hx0DMY73O8tBjf5Q8exJjbzwk844AxS2znytNH+W2jGOD5TTxCfR2bVH9hRSbRBsAf/1
         D1D5WyFc1NiuXFF3OZo2RoiO9MWdsw63+EtAALjnws/TnLuVrPvFYMFhhcUzmmoW6Ras
         LSo4dR3oiAfiJmiSQjlCiDyikIjRyI1Ln1vGRnaVdrxsd1iGVmDPJAZSSzbGzLlwt3L+
         rmnQ==
X-Gm-Message-State: AOAM530giBQIDoaBsBNd3BX6JWpUc2HHUddNEzpREVfP5vlJuqffDvtY
        6ZFk5OldnQ0YN8z21fsD/Ug=
X-Google-Smtp-Source: ABdhPJzkoE9aEYtxDhpmmFWQw+dSrzXoAxoeWgtaG1dOohildI7PQwpaEA43MpOz8Fgd7+tBbF7zgA==
X-Received: by 2002:a65:6803:0:b0:378:9366:3849 with SMTP id l3-20020a656803000000b0037893663849mr8437562pgt.484.1646126766624;
        Tue, 01 Mar 2022 01:26:06 -0800 (PST)
Received: from localhost.localdomain ([115.27.208.93])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b004e1bea9c582sm16570408pfj.43.2022.03.01.01.26.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 01:26:06 -0800 (PST)
From:   Q1IQ <fufuyqqqqqq@gmail.com>
To:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lyz_cs@pku.edu.cn, Q1IQ <fufuyqqqqqq@gmail.com>
Subject: [PATCH] dpaa2 ethernet switch driver: Fix memory leak in dpaa2_switch_acl_entry_remove()
Date:   Tue,  1 Mar 2022 17:24:50 +0800
Message-Id: <20220301092450.42523-1-fufuyqqqqqq@gmail.com>
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
index cacd454ac696..e85ca01718a9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -172,6 +172,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -182,6 +183,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
-- 
2.30.1 (Apple Git-130)

