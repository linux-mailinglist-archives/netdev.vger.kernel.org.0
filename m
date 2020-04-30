Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CC01C096F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgD3Vdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728073AbgD3Vdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:33:52 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9135EC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:33:52 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a7so1468761pju.2
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AHCak8b57d5ZqzbWNkbXwgnBt215953siCNmduVJF0U=;
        b=cITdmPqZDinlWoL9ck8f4gG4wHh5+g090SaRTFRKpeuCfWxPbmexY9tf9L1XTxSKB4
         GQewzJ5OTddBBgOW41A9ufoSCa5dGFeNJLMip3afDdZRTHyih0kEq4DmKA2sukkSoju1
         eC5WM9UPQuPB06Upfh/y54NFJ402eFTp2qLtbch2kB5CiVDzgteBfuFQ841KfXXHDqVf
         KZCD5Y7c/AU27KUMCz+9lbDxhhuREV3xbYy2QrggiSyF+EV0bTgUSmL5lGk4PpMCJpl2
         mJe2vZF439Qbja4UzE7bMahSZON6tcjoYQSRjIPN/BeuE0kqRP6spWTW7CE6bcmPg02F
         mX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AHCak8b57d5ZqzbWNkbXwgnBt215953siCNmduVJF0U=;
        b=uX8+dOL36fgtMJRz2+xCU0uPlyvR4g5fm97SL1cScGSb/02ds6qhbrp2CzTy8FFxG0
         Wzrm/oW6gyFrP7761TmRSOXo/tw3PnZRR7wtnWFHQRd1GQF0vS6xYAQhWrd24dILpmt1
         Thn0D2hGtfaRauyAgtNLs+Lgnepj8l5a+NJkhgjBJvl0oBhUAISFJsvNORXh5tLU24ZB
         dvJl64xW2Fj+7n6dVkX0H0xoQv1r5UJpEWjO1kbKJFvLVQinlpJk8w1Ky6++LK3y1nWY
         CKvcZ4RaWIhP878c99U39aaXr0YTv+apxel9KPHbZ53N6Zr1x6mySsHhUDwXFdWdH95d
         ov9w==
X-Gm-Message-State: AGi0PuYp/d3dhhjauecLWuPcKfu8J3Ls9tRrkyiWLPCLUIBl8/1KngTe
        qq6vjBJgFQGZqpAzFp6or2stmmpwzcY=
X-Google-Smtp-Source: APiQypINL4wcIB8noMEwcaYySCNfvenghtm7fa+5zOQbsDQRWBOz7sSbd2cnKmPl0TxSUNMH0JM7AQ==
X-Received: by 2002:a17:90a:718c:: with SMTP id i12mr976827pjk.142.1588282431871;
        Thu, 30 Apr 2020 14:33:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f9sm579086pgj.2.2020.04.30.14.33.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Apr 2020 14:33:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 1/3] ionic: no link check until after probe
Date:   Thu, 30 Apr 2020 14:33:41 -0700
Message-Id: <20200430213343.44124-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430213343.44124-1-snelson@pensando.io>
References: <20200430213343.44124-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't bother with the link check during probe, let
the watchdog notice the first link-up.  This allows
probe to finish cleanly without any interruptions
from over excited user programs opening the device
as soon as it is registered.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5acf4f46c268..bbc6c79e0f04 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2549,8 +2549,6 @@ int ionic_lifs_register(struct ionic *ionic)
 		dev_err(ionic->dev, "Cannot register net device, aborting\n");
 		return err;
 	}
-
-	ionic_link_status_check_request(ionic->master_lif);
 	ionic->master_lif->registered = true;
 
 	return 0;
-- 
2.17.1

