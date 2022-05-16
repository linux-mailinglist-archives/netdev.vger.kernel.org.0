Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2BE527E87
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 09:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240940AbiEPH0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 03:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiEPH0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 03:26:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF411C934;
        Mon, 16 May 2022 00:26:51 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l14so2740480pjk.2;
        Mon, 16 May 2022 00:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/7eHT2rOQfZHGIULaWlpNvkjsCcPddNP76slYQLYB18=;
        b=pJFYKcG9ZeZoYP5T+tlCgtsCzFIcguwB/ocZBFYxV7I/EFGhVm1BEgVGp5AJMGevt7
         GK8d86zZr/g/TVpDAmUjoeSupRNN6dcWn4xxFc6mBwZYSxVsMKN7I8ySwLz5DFoOtFpt
         2SOy38Ai0u+MXx97rXnda/8HMvWGtoMVffl5VTBEiKHvK7p5rwlpVQBYTd03SH55MDDP
         Cw22gNnlQT0tD0b7Up+VimD/NGkUBM/x7mY4/Rmo+j789RRGsdrFv05/QJ8f8tMpDsux
         WPnQLyE+RCkMWcZ9rMQ82ox2+JgoTqtzHAlqD2G+2b3hQOBeSEvsPftc8nDaBH7ZBK8L
         3VTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/7eHT2rOQfZHGIULaWlpNvkjsCcPddNP76slYQLYB18=;
        b=AQv2th3pRqpwAUNG8UwCYViwXW6OSe5K3bI36F57C96CGbTP/4nERSNr9v1666ps8o
         LeWCzweYrma4dZAgCx0LaDSc1OAzBYTgiN1QzUJqzV8oeIVuigGSRxlCTBFViCEo8cRR
         GykEvJOAZPDw2YJTHqxsg8JuH+e/5szYRTiZ8aSwMRZNoshkHU0OGIsVEos3294mdnjQ
         NG4vOY3/LQgHEcA2aUOYgzpCy1DSMaMtZPs69smcMzUk6y3dJuE2IUlmPf4mIARn0vu9
         BipXh13rA/5Y+OKaRej2oKXZIdDlnZPzYuWZ5k5anVt1Z2TwVgGmhGJjyhYQIe/DAR/+
         4qNw==
X-Gm-Message-State: AOAM532yqsdrLdGM6LDoCIRN/aS16BItmMPCyMt6U7tkKZjV1zuZsCmL
        SPquNg6h+mDW+TA5vMpTZjo=
X-Google-Smtp-Source: ABdhPJzw8zVwYJuY89aYMI1nFC92JPz25s8Fz5BnVo60UzyEd9mUGxHtGHNrX1bg6KyGQ9/rlMXctg==
X-Received: by 2002:a17:902:b906:b0:158:3120:3b69 with SMTP id bf6-20020a170902b90600b0015831203b69mr16022156plb.33.1652686011322;
        Mon, 16 May 2022 00:26:51 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090add4500b001d92e2e5694sm7951944pjv.1.2022.05.16.00.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 00:26:50 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     aelior@marvell.com
Cc:     manishc@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] qed: Remove unnecessary synchronize_irq() before free_irq()
Date:   Mon, 16 May 2022 07:26:46 +0000
Message-Id: <20220516072646.1651109-1-chi.minghao@zte.com.cn>
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
 drivers/net/ethernet/qlogic/qed/qed_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index c5003fa1a25e..c91898be7c03 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -823,7 +823,6 @@ static void qed_slowpath_irq_free(struct qed_dev *cdev)
 		for_each_hwfn(cdev, i) {
 			if (!cdev->hwfns[i].b_int_requested)
 				break;
-			synchronize_irq(cdev->int_params.msix_table[i].vector);
 			free_irq(cdev->int_params.msix_table[i].vector,
 				 &cdev->hwfns[i].sp_dpc);
 		}
--
2.25.1


