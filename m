Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752881ED7F1
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 23:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgFCVPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 17:15:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40996 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgFCVPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 17:15:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id j10so3860101wrw.8;
        Wed, 03 Jun 2020 14:15:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1AAqNWRyI08l0kT8Gtp4hoHt7qUcLSvra3ne0ZubVvo=;
        b=SwhWGVEp0YIMknwlFxG2RBQTeAm+gF5HnkjFWvSXDiNrNbpHJE+sAQJscQlFKY86Iy
         xAzqx7V89T0/UrVEDa/TT868bo7iDohDguQUYb5FzsbPTqL9ZkKAjefSrdORH8VglhNE
         TWWusueEb0TFzfjxfrQEaGNip+YmLtOqBLgtpKXCr+9CwM7BJHHs0wywV8yNUbfdBayH
         23U2slK243XKiElPddSx+xYhdJdkHy/DwdcmHnD59zQX2y9AVgnFRDo0emBTeyXNGseL
         jHmTqkCHsQz+Lw+S3uwxIRCO6bhRjrYWUNT7Jncce33ZBGcK4LyzHh6RJnDJu7TZCr+8
         sndQ==
X-Gm-Message-State: AOAM533sp6n8UYsM7MwaZsxfNiNMEWMtOJR7ttqDm1NEC5KCZTH3JLQ+
        PUJX/Po/voaoRTulB8RhPBIgWURxT3Tnu7RP
X-Google-Smtp-Source: ABdhPJy8zdQIFQVZHiWJsowk8ZuBbdYOzWhiQnw15NbX0eTerIZwdIvyh15YOt2pFkxcaOkHLEzKkw==
X-Received: by 2002:adf:9ccf:: with SMTP id h15mr1206044wre.275.1591218950249;
        Wed, 03 Jun 2020 14:15:50 -0700 (PDT)
Received: from zenbook-val.localdomain (bbcs-65-74.pub.wingo.ch. [144.2.65.74])
        by smtp.gmail.com with ESMTPSA id s8sm5291668wrg.50.2020.06.03.14.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 14:15:49 -0700 (PDT)
From:   Valentin Longchamp <valentin@longchamp.me>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        Valentin Longchamp <valentin@longchamp.me>,
        stable@vger.kernel.org
Subject: [PATCH] net: sched: export __netdev_watchdog_up()
Date:   Wed,  3 Jun 2020 23:15:27 +0200
Message-Id: <20200603211527.11389-1-valentin@longchamp.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the quiesce/activate rework, __netdev_watchdog_up() is directly
called in the ucc_geth driver.

Unfortunately, this function is not available for modules and thus
ucc_geth cannot be built as a module anymore. Fix it by exporting
__netdev_watchdog_up().

Since the commit introducing the regression was backported to stable
branches, this one should ideally be as well.

Fixes: 79dde73cf9bc ("net/ethernet/freescale: rework quiesce/activate for ucc_geth")
Cc: <stable@vger.kernel.org>
Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
---
 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 2efd5b61acef..f1816516f638 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -464,6 +464,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 			dev_hold(dev);
 	}
 }
+EXPORT_SYMBOL(__netdev_watchdog_up);
 
 static void dev_watchdog_up(struct net_device *dev)
 {
-- 
2.25.1

