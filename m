Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C3D59FFCF
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiHXQvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbiHXQvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:51:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0C54199C
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:51:02 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id c13-20020a17090a4d0d00b001fb6921b42aso2077697pjg.2
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=oWLOzygyjS5rpLDBH1FgOXuMSnkjtkocd2Vk8iqi6eM=;
        b=vJI7S/bhMd7ZU1Enud0sIpp0y/jvUb7Y8HCRFLLELNImECSnJGKKWifX6BIKNthx8D
         J8Tec35vw6CPt0afWgUM8OUIgPaa33ncJT0VZ/nUA5KinoZLroGPP5dd75Ohb3Njwac3
         BUyIJwB3xelunEmEhNd2P1To7LPT+OcP72ptBrMvJZQf8NsVA466jTNWWEZK1Lo3rMEr
         VvHlZc5JNEIG+sOckz+j4vaE7cx98YgFxE/Z7GwsbtwHx94bQYTBrSJmkxDWG9T6nBNA
         AVGI/Z1TkL8wBtl1r2kmHzjVG+6ZepsPjhKKCQ6QtIZ/+Dr5bBJGYSpF5Jf8/cQTcSlt
         H31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=oWLOzygyjS5rpLDBH1FgOXuMSnkjtkocd2Vk8iqi6eM=;
        b=HzORzwQQ8SrfsG38zplbhnQJcPorv7c9wIpI5NHOY++l2Phzl6QKdAKjytqajrd7SU
         dbqistjIwneyoII1hYAx8VAI3HQqquhSf00ogHGcO//A/tziTu+LtqgQtO4mSHDuiGAN
         JKn3jd7vQNp4kG4eqt2bokPT1ekcBSiUV7GDAuXaHl7/KbnESwc6b5JHanz09KUQzhXp
         0sDrX8SSNHmuxBFl+ItJxjbDScgVsr3g604YpBqp7m+uvGoo9UUGAKg1QOfmoloGeAxE
         lIiR3bmcHNqEmMQSTS3FJyRC10sBF7mwHcIfuDBl3hCFlcsM/b2/U69tmzTWOqU0/FFo
         cmbA==
X-Gm-Message-State: ACgBeo3cXjy16rC8zr39g5Lg3VKxpb8BMu5AdWCHzhwW2GY94wnhmFkK
        /BHRZfS7gmWKpATTY40PFX3qDQ==
X-Google-Smtp-Source: AA6agR6n4soFKu5WugOR+8jhPGCRhO4hGCpDfC7gKMUhIg8lLZxLPrtkXRQerL6yIeNMywJNR3lmZQ==
X-Received: by 2002:a17:90a:4801:b0:1fa:98ec:fa2 with SMTP id a1-20020a17090a480100b001fa98ec0fa2mr35714pjh.41.1661359861774;
        Wed, 24 Aug 2022 09:51:01 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a68-20020a621a47000000b005366280c39fsm8960349pfa.140.2022.08.24.09.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:51:01 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, mohamed@pensando.io,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 2/3] ionic: fix up issues with handling EAGAIN on FW cmds
Date:   Wed, 24 Aug 2022 09:50:50 -0700
Message-Id: <20220824165051.6185-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220824165051.6185-1-snelson@pensando.io>
References: <20220824165051.6185-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In looping on FW update tests we occasionally see the
FW_ACTIVATE_STATUS command fail while it is in its EAGAIN loop
waiting for the FW activate step to finsh inside the FW.  The
firmware is complaining that the done bit is set when a new
dev_cmd is going to be processed.

Doing a clean on the cmd registers and doorbell before exiting
the wait-for-done and cleaning the done bit before the sleep
prevents this from occurring.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 4029b4e021f8..56f93b030551 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -474,8 +474,8 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 				ionic_opcode_to_str(opcode), opcode,
 				ionic_error_to_str(err), err);
 
-			msleep(1000);
 			iowrite32(0, &idev->dev_cmd_regs->done);
+			msleep(1000);
 			iowrite32(1, &idev->dev_cmd_regs->doorbell);
 			goto try_again;
 		}
@@ -488,6 +488,8 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 		return ionic_error_to_errno(err);
 	}
 
+	ionic_dev_cmd_clean(ionic);
+
 	return 0;
 }
 
-- 
2.17.1

