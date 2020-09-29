Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A2527DB90
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgI2WUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbgI2WUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 18:20:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34CDC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:20:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 197so5087807pge.8
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3btRs2kj3XYpMXiTF0+2va+upFL4/opojo+Cy3TopUE=;
        b=MlkNNxJC+7jtwAUSFOXdOfzRccKW+Djfp4y5lEqas5vPNWmUNvk9NQ1UTGOH9bA+rq
         yGL5X+whnQ0IiUmwjU7Q4AfT71fVGlzVhAkIgvpQkcamqmMY3VmVqlXilfX8wpX45g8E
         OrX2OgtApdARIZ+D0xbzimQBR///tMoK5gaqRBi9JusIfzGXbY2C5D1Vf+yH5VQdvqkY
         ryCg3VuQ0IcPd1X9zRlguoWCECF+7xsF9h3RXqhAZ3mvJYv3Wvsg+JapQCBJoo682mwE
         vkkUvpbM70O6jY+b/rkt4Q+y8kaFMDvYibgci1AS6sBmd5aOYXRqIJbNP523GcsaFetO
         FXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3btRs2kj3XYpMXiTF0+2va+upFL4/opojo+Cy3TopUE=;
        b=mdNW3VQPsmxgOro2AmOWvrLOah7Tc5NtFxxoYoeKnv8q1f5Nl4Hq2/Jd7NAIaOOFak
         jmZfImhpA/yozq2YJYeYeZAMI/nhQ5zhthrm39Cja7JO1vcHD0ymYPX5bvDKd09BYbmp
         7mBWzQsdhCTKtzTr1rdfaWlP7C1P6jqPNR7w0MCi2dP+DZ6KH55dsCGTlvxOWX10Bpg4
         T70++0jd0DZkL3FPg+4ycaQ32lHUDqBpm7uQWdH2UadSMEfPq8sZbHHih+JVwPNRLvdQ
         ZMDfgiDaABUFX4IM9nljxIOskjs4tPMItya6YRYPULUIMHP2D5ofL9Jhgx3dRkCaiqGr
         vxGA==
X-Gm-Message-State: AOAM532u/4QnL8SE9Sr+AnyYr/nqtvLitXeV4JCiMImFxf7vUiZUxwLf
        oJYB/2JoQmalUi/aVvo0lHlCmHw4fH8kNg==
X-Google-Smtp-Source: ABdhPJyK8YDa6Lq2FtZed34GMmk7+h6UUtxdF9hahUjFYCQzfFhg+nE2EmX1Zhk0Ncr1CaKUZEwBKw==
X-Received: by 2002:a17:902:9a84:b029:d2:9390:5e6 with SMTP id w4-20020a1709029a84b02900d2939005e6mr5978474plp.37.1601418006833;
        Tue, 29 Sep 2020 15:20:06 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id e27sm6756428pfj.62.2020.09.29.15.20.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 15:20:06 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/2] ionic: prevent early watchdog check
Date:   Tue, 29 Sep 2020 15:19:56 -0700
Message-Id: <20200929221956.3521-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929221956.3521-1-snelson@pensando.io>
References: <20200929221956.3521-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In one corner case scenario, the driver device lif setup can
get delayed such that the ionic_watchdog_cb() timer goes off
before the ionic->lif is set, thus causing a NULL pointer panic.
We catch the problem by checking for a NULL lif just a little
earlier in the callback.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 306e9401b09b..f90322ec3e18 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -19,9 +19,12 @@ static void ionic_watchdog_cb(struct timer_list *t)
 	mod_timer(&ionic->watchdog_timer,
 		  round_jiffies(jiffies + ionic->watchdog_period));
 
+	if (!ionic->lif)
+		return;
+
 	hb = ionic_heartbeat_check(ionic);
 
-	if (hb >= 0 && ionic->lif)
+	if (hb >= 0)
 		ionic_link_status_check_request(ionic->lif);
 }
 
-- 
2.17.1

