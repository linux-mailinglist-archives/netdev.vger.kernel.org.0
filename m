Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A6E527F8F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 10:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241596AbiEPIXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 04:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241640AbiEPIW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 04:22:57 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE08536E23;
        Mon, 16 May 2022 01:22:56 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x23so13387718pff.9;
        Mon, 16 May 2022 01:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+bSaI8+EI0dfOI3Aer2Hoi7m3c1d964/k77ZGGtERDI=;
        b=NgoDKcu5iRK9Gn+pad3Kc6BB5m9B8PP8Fmtge1dr3QfoCjfk1nJjPca3O5n08Jo00A
         wnPP/O+eei7VivqGXtUNiCEZazH4rvTj43bjyuGCPAeVG218C+q3supJWe/ttbRNOYpI
         zirCTnGS2Jl1sgYr1wMEOm7uZaAa9y8pPRkCMbzrGmkxxOkZ5hhE+T5V2yNh9YTXvcLM
         DP+JexYTVCR4rCYNjVLsGTqDcM58ddre05ORaMspvpuUX4ANU+pzoS1Ju0XG1YviNPCB
         T3zUbZucOq64s1QlEleSFF78tMf+1tjJLi9p2FsA5pT/BW1RR1WLJAOMWNE5hdAXAEjr
         2Aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+bSaI8+EI0dfOI3Aer2Hoi7m3c1d964/k77ZGGtERDI=;
        b=NJjBPn6dACAUukHSdf4SQgJ8gQV/rewnVtPixXlPacL1k3OyVr0+u89UGoq9HePTnB
         6HyMLKQF9zDSvkDAAtRisQ4nFBWu5e/i7MGt4tSPGYcR2H+xNfk/sGOuP1FZbBeauL8k
         pCtaLQupPbPJYDHUxTPqTNhQJqaw0i4bnfNNQxxbvwZCsYEEJUzt//VsvT/XoOOFdWN+
         Z7IYxLwxqHOW0t4/n8PJ3x2wO2ZUxotl0i26jnUb32f/9el9Zv/eS2roH5muz7Z1bZvC
         xlyClrjLkgDV1c2vdQTolpayzJ4mycrv0x2LfqhE+rQXRU1FdcK3hdqCEL5pqFRxgyYR
         sb0Q==
X-Gm-Message-State: AOAM532rr/VHZhvoMMy+zH+Gfn0KPlEzN4f1f8RjMgAQV6sw1bFqfv8z
        eLJmeAwEgA8dfwM/Fpum0hc=
X-Google-Smtp-Source: ABdhPJzEdaqHUBSPDSixGZaw86d1w3v/f7fIwSaGdgI4HHnX9fkYPoC144Ox1MSRDcDZSA4f5W7zmQ==
X-Received: by 2002:a05:6a00:16d2:b0:512:c652:a2f7 with SMTP id l18-20020a056a0016d200b00512c652a2f7mr16529365pfc.9.1652689376369;
        Mon, 16 May 2022 01:22:56 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m11-20020a62f20b000000b00517c84fd24asm4221035pfh.172.2022.05.16.01.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 01:22:56 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     aelior@marvell.com
Cc:     manishc@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: qede: Remove unnecessary synchronize_irq() before free_irq()
Date:   Mon, 16 May 2022 08:22:51 +0000
Message-Id: <20220516082251.1651350-1-chi.minghao@zte.com.cn>
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
 drivers/net/ethernet/qlogic/qede/qede_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index b4e5a15e308b..f56b679adb4b 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1916,7 +1916,6 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 
 	for (i = 0; i < edev->int_info.used_cnt; i++) {
 		if (edev->int_info.msix_cnt) {
-			synchronize_irq(edev->int_info.msix[i].vector);
 			free_irq(edev->int_info.msix[i].vector,
 				 &edev->fp_array[i]);
 		} else {
-- 
2.25.1


