Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73E4525D44
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 10:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353337AbiEMIT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbiEMIT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:19:27 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C587124A3AE;
        Fri, 13 May 2022 01:19:26 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id x12so6850932pgj.7;
        Fri, 13 May 2022 01:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RaQ5jvW6YG9/p/J8NZH/KLIdrjG8pPYolCrBm6XpevI=;
        b=D/nTX6BNaeFx4jDxa+jNPvYO7SKQvXMsFZZNBS3EAMvaavNn6X5x4UnUTzaJTOdh7U
         J39kqYUSjyRtRBntoLQRrxZDPvimQKikfF2WY8PA0k8WpyhBTXcCcFyrRlKVdAyoiQhg
         tzc64Qcp4uVC59ep+dN7ZeAuPqaa5GK8dHUBeVNGhKzi7CrLMvcumknYRP6AJa1yEJYn
         RaHBs05HFVR38tbGRxyj9i8Sk9TOogu0VSnWLvS2KjrLtu6ygx/pZpenl8taoNLiltEh
         pzU5nL6wo7+JnbTkgM5QaNWKhdPsJeF53xGwLms4dJ8qLcvx9+k1kSJce6rukWeww0f6
         wqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RaQ5jvW6YG9/p/J8NZH/KLIdrjG8pPYolCrBm6XpevI=;
        b=4ViOYdPRMMb7MABouPTAbWsMY7mvRrTPnpiFa1aisTtbeZYa8bIzHZtXVJZeN/WRHI
         zkOt55a1/8xLzrY4sZdlCCTAIpb/BEVxWn6FrXeANQkzE0wMOp9+bwwFJqpBtytJmgmy
         uNs+O0rZ/Z5HOasTbzBlcyaZTT5j88jzkKEeqFiHNZzP73l8p9um8ZECmRHQxG8mIFf3
         GhbLQ4jtFZl7/mUioO+LtOYHJXNLBbl/QDhbDo16Kzbwm1+8ggCC1c/43l9liXVb0Zux
         vaitisN4L4djFlXUl2lv4JaZMtbmXDtR0e+sQ+q0PKJdR4ZOuRC1rZf1vITNTT8QjkAH
         bpkg==
X-Gm-Message-State: AOAM532BUs/6b+yVuGLsdEH2RrGUF2DvA7H5p/giRwYpEG+zqUvfVogo
        H2/U6Ie9az4CKKBwJFFacTrhJ6Korhc=
X-Google-Smtp-Source: ABdhPJwDSuH4iMDTVlh0jdDJhW+bqQYFnu5TU3kd6VVMvfF1+37+b3Ka/UjqUMMwG+t5Ow/wf1+ciw==
X-Received: by 2002:a05:6a00:228c:b0:50e:17ba:9f84 with SMTP id f12-20020a056a00228c00b0050e17ba9f84mr3329378pfe.62.1652429966304;
        Fri, 13 May 2022 01:19:26 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o22-20020a17090ac09600b001d9acbc3b4esm1020312pjs.47.2022.05.13.01.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 01:19:26 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     sgoutham@marvell.com
Cc:     gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] octeontx2-pf: Remove unnecessary synchronize_irq() before free_irq()
Date:   Fri, 13 May 2022 08:19:18 +0000
Message-Id: <20220513081918.1631351-1-chi.minghao@zte.com.cn>
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
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 2b204c1c23de..4fad951b94df 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1718,7 +1718,6 @@ int otx2_open(struct net_device *netdev)
 	vec = pci_irq_vector(pf->pdev,
 			     pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START);
 	otx2_write64(pf, NIX_LF_QINTX_ENA_W1C(0), BIT_ULL(0));
-	synchronize_irq(vec);
 	free_irq(vec, pf);
 err_disable_napi:
 	otx2_disable_napi(pf);
@@ -1762,7 +1761,6 @@ int otx2_stop(struct net_device *netdev)
 	vec = pci_irq_vector(pf->pdev,
 			     pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START);
 	otx2_write64(pf, NIX_LF_QINTX_ENA_W1C(0), BIT_ULL(0));
-	synchronize_irq(vec);
 	free_irq(vec, pf);
 
 	/* Cleanup CQ NAPI and IRQ */
--
2.25.1


