Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF8505ADF
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiDRPV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbiDRPUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:20:52 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B3EC6F09;
        Mon, 18 Apr 2022 07:18:17 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id k29so19094202pgm.12;
        Mon, 18 Apr 2022 07:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwBQWoszPE0WyBmS8eEzNdPIlmwnL6neVdJfMqZdeYs=;
        b=fjCzVFXPD9OAxM7+2jsCqxQ4PEfquLRnb9QTjwSjnrdwevPE9rfwvUUjggapYNp35g
         QAOMgxgQX/YW/gRIkBW9KcXuOSOhdGlaLFaf3L8SCkewDRw9Eo0MAWW9Ee0ud8XcU0+i
         DAjcuCXPnzUMb4zaB0yN2r/AuTVX3UoabyBxrjQN3ILYXuttMs8z2Tts2KmQjAEGdYj8
         gCby6L4hbsCLE+NNwUxxY9Z4iV52gFxw1i8VWclmzDenqDi4fSrB6373Ua9NmD1+jtES
         RyCny3yCVu4HDdetIrVUvznYdcNYg4e5ko9/Oer4DktpMBEXxfkCYB/PKgFEo1lVsvpk
         8rZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwBQWoszPE0WyBmS8eEzNdPIlmwnL6neVdJfMqZdeYs=;
        b=54+PFQP12pi0ChshNua3Xiav23e7VXJ2znsaM3gL76T8lBXOQQns9fhcgsUliUNxG1
         m88B2dfoaI1XHmVGCCNO8C4RZqwplVeC7KDSRZnw3EqJZ00jqRBiwxm8M4VEGW8d8sAm
         2pIzboa9rNduLInK9955IsA16LZbYlfRtEZ09VO01/1cqcTjVxhnas2sshfnWuapwwqg
         Fl+DyV6/V1MJcxdSHzDCMvxfajWdttHbMK4wwgsXZb0CwPSjjozpN5cH3cNCNbgSGxWF
         lfh27cXg3+0WVzlwBvGAA+6An+EUMggBq53Rilb+EW///WqiETFtlRz2QOwUXhJcpy+b
         v43Q==
X-Gm-Message-State: AOAM5331AS3xDfdXXje1qbKd0SGWGt0yn6w8nx1XONn5WIFId9ClYV3a
        01uKmgOBbAPSNvfTuW7oiyg=
X-Google-Smtp-Source: ABdhPJyclV+Mcqdo47GuHlkPNpUunZsBuvzLTCkjM4VHFjbJlQBd3Tq5rdfTbOgaRdONkgckNqzgxQ==
X-Received: by 2002:a05:6a00:c8d:b0:50a:62e5:6d30 with SMTP id a13-20020a056a000c8d00b0050a62e56d30mr8676119pfv.47.1650291497089;
        Mon, 18 Apr 2022 07:18:17 -0700 (PDT)
Received: from localhost ([58.251.76.82])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b004f140515d56sm12703148pfh.46.2022.04.18.07.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 07:18:16 -0700 (PDT)
From:   Yunbo Yu <yuyunbo519@gmail.com>
To:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunbo Yu <yuyunbo519@gmail.com>
Subject: [PATCH] net: cdc-ncm:  Move spin_lock_bh() to spin_lock()
Date:   Mon, 18 Apr 2022 22:18:12 +0800
Message-Id: <20220418141812.1241307-1-yuyunbo519@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is unnecessary to call spin_lock_bh() for you are already in a tasklet.

Signed-off-by: Yunbo Yu <yuyunbo519@gmail.com>
---
 drivers/net/usb/cdc_ncm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 15f91d691bba..cdca00c0dc1f 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1492,19 +1492,19 @@ static void cdc_ncm_txpath_bh(struct tasklet_struct *t)
 	struct cdc_ncm_ctx *ctx = from_tasklet(ctx, t, bh);
 	struct usbnet *dev = ctx->dev;
 
-	spin_lock_bh(&ctx->mtx);
+	spin_lock(&ctx->mtx);
 	if (ctx->tx_timer_pending != 0) {
 		ctx->tx_timer_pending--;
 		cdc_ncm_tx_timeout_start(ctx);
-		spin_unlock_bh(&ctx->mtx);
+		spin_unlock(&ctx->mtx);
 	} else if (dev->net != NULL) {
 		ctx->tx_reason_timeout++;	/* count reason for transmitting */
-		spin_unlock_bh(&ctx->mtx);
+		spin_unlock(&ctx->mtx);
 		netif_tx_lock_bh(dev->net);
 		usbnet_start_xmit(NULL, dev->net);
 		netif_tx_unlock_bh(dev->net);
 	} else {
-		spin_unlock_bh(&ctx->mtx);
+		spin_unlock(&ctx->mtx);
 	}
 }
 
-- 
2.25.1

