Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BB2357864
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhDGXUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhDGXU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:26 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E70C061761
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:16 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 7so52349plb.7
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8Opzu0fD3XrLOvEra0X4fvAiqEviWMSZ9l4nBgHHiEs=;
        b=y8r9Hcw7cmspRn7jer2UxeGBO5NO3zbM9CnO1/hDcNkvsdFu0NH5DkaECKJl4Z3QUL
         o7XWr3bSGibC45fBngGH/nqkFeUaD0fR7HZZfMaBHgRgq8893gsBqsvTn/g8DNLLi2oh
         vHxIfpqqk/R40z0NXOTeMS3SOhzVZA+d+s8f8ssYDNl6poQDOHRIohUlvVL2vPjUYlA7
         m4W6PTLBYnYoS2ogqTiEATGHItWfWm5vNuNoB1n8aUPuYGSomOrmzgh4roC1IRSI92Lf
         JBjcX/LGSO/tpwCBDLIhlB9vPrtHV7fHSrDEvmpE/ZfNJYhCyH+NQ82x/YOERScDB/zf
         6Mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8Opzu0fD3XrLOvEra0X4fvAiqEviWMSZ9l4nBgHHiEs=;
        b=IrdkxczdSnD8H3o4PYkYeTA6Czc4EWjdsZ2HCmoxSqkoL9c/CIohpxIQ2d8Psw/ta4
         EGEt5KMT/thUwQ7lk73JVLo8WB6iitjExnDrBdJElhVG3LoC3P8ViFWTu/klDCnvSatQ
         5GauXojffdh4UMV7xnMWGk0g8bNAsgNrtxSuH66rpAdI5YVXeH1XkjVPY4X1hyEGxzhs
         O78l8jg0V8YAAZSH1ibriyipowPuzhOhemyqdZOvL61XzQgq9xWZ4hMbdyp/hCgIqB9c
         4WprTFyPQW7ZQLVLVsTjw0KfOjSYZW/YBjgIljUKUYmU2ufB+JDe2wdcubWxdsel6WUy
         UXNw==
X-Gm-Message-State: AOAM5304T++VKb7HJJ/2nnPw0xbUkdcuib9L/aMscCOHOU4SS9m/HBgb
        YGxwBdrkgBqeAFKDMRPohI4GrPRWqdWtyA==
X-Google-Smtp-Source: ABdhPJzZEeX/2NWIc/EhpQwaNd9SlGd7G1Kzf1GwRhdrWYtFOoJQW8H+oRjgPILi7T29do48ycrT/w==
X-Received: by 2002:a17:90a:6e47:: with SMTP id s7mr5633955pjm.229.1617837615717;
        Wed, 07 Apr 2021 16:20:15 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:15 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/8] ionic: add SKBTX_IN_PROGRESS
Date:   Wed,  7 Apr 2021 16:19:57 -0700
Message-Id: <20210407232001.16670-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
References: <20210407232001.16670-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the SKBTX_IN_PROGRESS when offloading the Tx timestamp.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 765050a5f7a8..08934888575c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -1203,6 +1203,7 @@ static netdev_tx_t ionic_start_hwstamp_xmit(struct sk_buff *skb,
 	if (unlikely(!ionic_q_has_space(q, ndescs)))
 		goto err_out_drop;
 
+	skb_shinfo(skb)->tx_flags |= SKBTX_HW_TSTAMP;
 	if (skb_is_gso(skb))
 		err = ionic_tx_tso(q, skb);
 	else
-- 
2.17.1

