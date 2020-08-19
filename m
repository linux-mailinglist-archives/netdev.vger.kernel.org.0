Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0253249423
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgHSEca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgHSEc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:32:26 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D782C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 21:32:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so10202906plk.13
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 21:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u8zxbkXKQrK7PLbmkqGs/ldvreyOjXdSk44gW177D5s=;
        b=UMlxEZzB11jxnMriMmykbbPcfYvGaCTETuZTtfljHwVZICPRNxOpTh8LgfayZHfzez
         kEdtLwux0m5UCKpBy+s2QkEYOphAIJJCDcuutNanKuPbFkmEnSqAdXka7A1QIcLYKpHE
         kSQm1YpVfPLOx0Wboj6ZZ9aVftGvSXeTa7aCbcImx3ohWP/NY0qJau2sUNuzjD2KJahM
         asKl2Sg9NNXL6ug5f1Iuv8YSORWurdZDVafNYqpGzK4Vr8wUCu0caXWXO04eBIsD9COx
         XaFDwR6LEZYp55NScpK9oTE1WpGYBPE5Lj2pe6S2kjYJn9MDfvaBSZacDVbpE3cvzWMS
         DBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u8zxbkXKQrK7PLbmkqGs/ldvreyOjXdSk44gW177D5s=;
        b=UWdTw/PZuCuVZhu3offJAZ4BD7bDha7BdBj/o9pRMiZiQRZg1Fc5vu4NmEA7b2V1bg
         0SZf9iJ14XOob1BOP06T9GWBAcFUach7fOMO5lT4IxzS/A8Zee2MCfXPB3gOHJ19e7zW
         VINWtZOZtRO+3pNSUftdeTzT5m77+vyu4hyN9lWV6QoYUALpP8sxrm+GxNxt77aNbJib
         CDVwz35ounFT4I9ee466NFGTsDg8+2YzOaLc6o06s7/g1J6GRuQepFH2x6feb/DefTfZ
         LImUtZZrn2F1Z9FeNagU5vyvPQaGDkQ+D7bb88BnN7Hi+GBSoH+bTlkUcAHWVKmYIKZI
         bnjA==
X-Gm-Message-State: AOAM532SZ2cDB60WjgZiTr2jWtantVb2nVoewxsJmleLzThJmH3zBoQs
        jTn61OgmIb+7KSkoOWWcgdVupByMHb4=
X-Google-Smtp-Source: ABdhPJwHJvJDnTcv3o+iR7RMWLzOn/2daGDNYShTY9ZnollK2Gto97q2R1D/GiiywH2JEJYJc3jSKA==
X-Received: by 2002:a17:902:bb8d:: with SMTP id m13mr7704901pls.11.1597811545710;
        Tue, 18 Aug 2020 21:32:25 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y65sm25942468pfb.155.2020.08.18.21.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 21:32:24 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/2] net: dsa: loop: Configure VLANs while not filtering
Date:   Tue, 18 Aug 2020 21:32:17 -0700
Message-Id: <20200819043218.19285-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819043218.19285-1-f.fainelli@gmail.com>
References: <20200819043218.19285-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this is a mock-up driver with no real data path for now, but we
will have one at some point, enable VLANs while not filtering.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index eb600b3dbf26..e6fc4fec9cfc 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -290,6 +290,7 @@ static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
 	ds->dev = &mdiodev->dev;
 	ds->ops = &dsa_loop_driver;
 	ds->priv = ps;
+	ds->configure_vlan_while_not_filtering = true;
 	ps->bus = mdiodev->bus;
 
 	dev_set_drvdata(&mdiodev->dev, ds);
-- 
2.25.1

