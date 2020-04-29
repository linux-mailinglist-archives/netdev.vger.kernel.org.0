Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08D81BE657
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgD2Shv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2Shu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:37:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D2EC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:37:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d3so1421198pgj.6
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EiAsF6GrLwFYrKI7R7bDzaYV7LQLkwmCmZukG7pI1x0=;
        b=mEmSfKevQZKiD3hbZgXN6UfQ/NFihMCbV+lT9x5DTy9S05rrGmMi97OiTlKzNIq4at
         jYbib7/vD1Jp2v9lh0+Nk1eeil3tACoBS7aKqFVOOT1FTp9dJU9ZbCBuOe2KhpCRabKK
         EKkhPa800C1D96sa5uSrQM4sqHNKi2QwYKRObhNwusQQL2kSPkY7mWmXp5gphYxNh6ao
         wodaYEIhbElL1LSimwMgSJ92dM2hjaQ+6Ym1ufnf6hFWTqP8tFpj9rSz70uTOmHUfX1C
         pUBH4QvSjWbJ9OWwsw86TxjXGkmInOJkpJFP2h0nhkyF1OTl6jI1/TIxhhCywHaON4jL
         qhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EiAsF6GrLwFYrKI7R7bDzaYV7LQLkwmCmZukG7pI1x0=;
        b=KzBQI+HK+M68lV6Z+NNpHfTRBwCHiUHeggfUdgN6RLka+9nlvuelH6nTKNtNl47aBH
         PuNLb7DsoOs9a1vTzxfmpui3DZQJu8A0kqL7D/M2EcEOBGm7z2gq/BGTnoqYorTQE23b
         s+FblnceZBPkDH9C2pqoJv/xszGZuu1hYn7lGOeOu26dO1rtJuh1zCCymwSL+JUW/aZV
         SqwZxGV83/VLW0Whf98xpx3/Vo2isqxnV4Y4+gXmrvyZjz1jKTCG4VodCjz/HlgX5nt0
         so12BjKgl7y6lpEEEWRU+qWZnTBTaoWWhUtaPQJZgoGxOXPEIyVSifl7lyrpB26DJh+M
         WdCQ==
X-Gm-Message-State: AGi0PuYf0UAkr1T/aqShkXf2kiuotb9Z+zd6eyqUgGzm62wqs9T/m7+2
        ifV0OfKL3XNHqh/Y6+3fF/2adWy5ALw=
X-Google-Smtp-Source: APiQypId3fYIeyb2I+1xN5uNbWXO/ug24g2Gq+xLNAUNeBw5sx+YNKYByo/5q/wX4kHw8sLkw0yAmA==
X-Received: by 2002:a63:555c:: with SMTP id f28mr18186164pgm.80.1588185470011;
        Wed, 29 Apr 2020 11:37:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g27sm1511190pgn.52.2020.04.29.11.37.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 11:37:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 2/2] ionic: refresh devinfo after fw-upgrade
Date:   Wed, 29 Apr 2020 11:37:39 -0700
Message-Id: <20200429183739.56540-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429183739.56540-1-snelson@pensando.io>
References: <20200429183739.56540-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we can report the new FW version after a
fw-upgrade has finished by re-reading the device's
fw version information.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 2dc513f43fd4..2a87bfc50cc6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2122,6 +2122,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 
 	dev_info(ionic->dev, "FW Up: restarting LIFs\n");
 
+	ionic_init_devinfo(ionic);
 	err = ionic_qcqs_alloc(lif);
 	if (err)
 		goto err_out;
-- 
2.17.1

