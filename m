Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916763F9F4A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhH0S4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhH0S4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:56:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DA4C061796
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:24 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g184so6679631pgc.6
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nySngVUTww6UW7BGlhAtc2/QKSILuAYZFWa6WE0dRx0=;
        b=xuheY/IOcr9hL6C1wQMLB5BZwatOAM/30YysX8482n7vG2/f9vpMmVBrM307MtHtjt
         QJGkz/20dPFMKt66j9MTeWTDD0eYWE3pDc8J/7zEFUWWQTpwiHq2xg8Ro+PWB4MzAdQX
         UX4CpRHaF1IykesUsQ+fA62jhLntYpvNSsMZQC4VXyMVjSUizUmp6hsDXZ8B7pwEli9T
         8ObVvJ99T8VGTtYWUUGlo/zfB4pVAi5/3ZbZr2qPFz5r6k9claW+4FoYRXv2v9r6Y9gR
         lV9J+LamlUjViA5NubF+fbmyRrxM0aJwv3tm16w4k69tLbW3YzyrKYZyjSU0qFu2GZ4c
         7Pmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nySngVUTww6UW7BGlhAtc2/QKSILuAYZFWa6WE0dRx0=;
        b=BctFkabBYPuThCWsiHT3QSNFxgLCHC4Xp01IH/NELAtzw+X1PxIUmmypH+C1hStC1m
         xIWsHlJx1HeQMZ+adNull/kvohhFwGKAqm0irqfstOriMlHMMWwOMcegIkDZmOEP741c
         +2NVueWbUhkcOL+yIYh4o9BdHYxXcq4gzrhlObnJ1OqSC7ZJx+4ALyUX9sBinqM9mZvJ
         OFQ+C2na30TYRWGiZwFW+iAeJAVyWoQYoCMmp+BN2gD1CiTz09oprAnH1FjWbExhmfuv
         7DCP4C8bcMA+vYLM97wzULblsG7y0G6ciqwxdhDgb33bFph4arw9vSoGYZ4UpM+u+oYS
         OpgA==
X-Gm-Message-State: AOAM531rqG99+XFeC1bBdRj5IIyPpnF20V7CcQRhTKq8IWtGyrag2Pug
        +QhSzXZm2GKV/B3xlK6Z1ErY9ozy2e0JTow8
X-Google-Smtp-Source: ABdhPJzSrT7334ZbGcwW/Xnf0yZyhJgyOTUakO99UYInvfi+5skY9l/pJWSsxq+kchVnbqAhikWY0Q==
X-Received: by 2002:a62:cf86:0:b029:3e0:7cef:9e03 with SMTP id b128-20020a62cf860000b02903e07cef9e03mr10704085pfg.0.1630090524565;
        Fri, 27 Aug 2021 11:55:24 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f10sm7565975pgm.77.2021.08.27.11.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:55:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/6] ionic: squelch unnecessary fw halted message
Date:   Fri, 27 Aug 2021 11:55:08 -0700
Message-Id: <20210827185512.50206-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210827185512.50206-1-snelson@pensando.io>
References: <20210827185512.50206-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the heartbeat check will already have complained about
the firmware status, don't bother complaining about the
DEVCMD failing.  We'll keep the print message but demote it
to a debug messages so that we normally no longer see it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 5f1e5b6e85c3..6f07bf509efe 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -375,8 +375,8 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		 * heartbeat check but is still alive and will process this
 		 * request, so don't clean the dev_cmd in this case.
 		 */
-		dev_warn(ionic->dev, "DEVCMD %s (%d) failed - FW halted\n",
-			 ionic_opcode_to_str(opcode), opcode);
+		dev_dbg(ionic->dev, "DEVCMD %s (%d) failed - FW halted\n",
+			ionic_opcode_to_str(opcode), opcode);
 		return -ENXIO;
 	}
 
-- 
2.17.1

