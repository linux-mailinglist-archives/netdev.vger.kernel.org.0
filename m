Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70BE3B1234
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFWDcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhFWDcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:32:03 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AE5C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:29:47 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id p9so602088pgb.1
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=60XQsMd92Sa0BwHkSN6e2HLScKheGrl/4tQBqgRYzXE=;
        b=E3TGIyZv13qZZUX3TdwtqYP1wuLVPcqrFFrjW+B3M2l135qXpsJKjy0tvSEZIwkstk
         0BA9sT7dmIA0/x7YcCHB6ymzJzUECuV+zKiYeAXeKpqoo4tyMZD+cJfsimyZvjWjrDzm
         Mg5IbT5znb9w5LgV7/NrvpaRk4akStOMeYOnrxPg3/r8kAa0v0LswXrPfiSZFNrvnMsf
         CKQKVFnLfes83jXaxjbR9MDrDTOuXhKKDpdxcLI8C4M8X55XjbpZyIF11UZfT5FUC+EX
         AYk8SF4OWnPglqvVVs1wTjK4BhotbM6mhtY9Y0Qv21uSENeV/CHQj+ugLwJUxkqpzHOW
         NvvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=60XQsMd92Sa0BwHkSN6e2HLScKheGrl/4tQBqgRYzXE=;
        b=gJkHwtdD5tL3gtS1tuD2j+8pt0YrnhQfxkReobRC3cuqfVX/tHlgK2WujxcKzSNjK9
         xS22l+7qRtD+RX/I3VXGsjPW2yunTlMctW0PZX6e+tPjqIk3n/M4tcj8QiDJ2JIsjiw/
         WrOwZ5g6jUDCFNWv1Z19K6mAHNWRa/ovctXfYQAFAciXF1/tqkbZJNgEuqrO/tqGlp2k
         e0/CGDfuWzk9BwL/aiwbUJypTSM0FO7DOVDfMrUAWByXWvMC43OCG6sb0kqQOmFCYiUR
         /hch9hbip4OfrzHbvfYwOKnRVb+7hwEliAWubIk+cpLZ5nkyGpYMZQLHovQ1q1mzijJ8
         7ohg==
X-Gm-Message-State: AOAM532WMgejjztWHlQaRpF5WjAvvTh1WEmwxwl4/X3iiALHe54YRKBB
        GVxEc28GiWh9ZkdujWx7QMJ5kQ==
X-Google-Smtp-Source: ABdhPJy+kLYVbXCJ+NO3WLa9mcTlACGysOXc67ReAbE9g5INS0hMKEPe9hu8xRVcs3Zgrb5gIHEx5w==
X-Received: by 2002:a63:2546:: with SMTP id l67mr1787408pgl.148.1624418986782;
        Tue, 22 Jun 2021 20:29:46 -0700 (PDT)
Received: from starnight.local ([150.116.242.79])
        by smtp.googlemail.com with ESMTPSA id z9sm658546pfa.2.2021.06.22.20.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 20:29:46 -0700 (PDT)
From:   Jian-Hong Pan <jhp@endlessos.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Doug Berger <opendmb@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        linux-rpi-kernel@lists.infradead.org,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
Date:   Wed, 23 Jun 2021 11:28:03 +0800
Message-Id: <20210623032802.3377-1-jhp@endlessos.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <CAPpJ_ecJxUjvxEb+3GLmtQyxhAZ3Tqk+hoUbSowG1bi+739u-g@mail.gmail.com>
References: <CAPpJ_ecJxUjvxEb+3GLmtQyxhAZ3Tqk+hoUbSowG1bi+739u-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too late.
So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This leads
GENET fail to attach the PHY as following log:

bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
...
could not attach to PHY
bcmgenet fd580000.ethernet eth0: failed to connect to PHY
uart-pl011 fe201000.serial: no DMA platform data
libphy: bcmgenet MII bus: probed
...
unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus

This patch adds the soft dependency to load mdio-bcm-unimac module
before genet module to avoid the issue.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=213485
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
---
v2: Load mdio-bcm-unimac before genet module instead of trying to
    connect the PHY in a loop.

 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023f22e5..41f7f078cd27 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4296,3 +4296,4 @@ MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom GENET Ethernet controller driver");
 MODULE_ALIAS("platform:bcmgenet");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: mdio-bcm-unimac");
-- 
2.32.0

