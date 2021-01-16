Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE132F8A74
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbhAPB1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbhAPB1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:27:13 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA10C061799
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:55 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id v67so15915396lfa.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=YgILgnfGDXDr3Bs2noKI3QGJ52/I6ya9VHtgK0INKrc=;
        b=cVLdWT8THBRWHKWVeDmNkGTAE+33Yx5BfLFjd2hoGpZcV5lZ3VoYcrJVjCXLgnMyi+
         zDuorD76jgOywJQ1VbEVo1Y5ycVjpfqUbsZVT4Ed/lo5fdLqu0BbvoKdwc5EwsoglXWB
         7gb1nii5b5+2zTXVITbix5UK3BgHrxRDGTZJIUURMbPoJDwlidkkMsNF39rblMiLvKad
         PBKc39LHf4lSwWVnXrvYB+GhJF0ApLbVtuFjjm5XVX9WxtcoMfg/mE/udm8hxKn613ua
         gsEDYt2Zrwy8a4/DsSW/pSdcW2u1uP7kG/rY6OeOG19DVWMIqzTQ+7ZUYM44NwjDJ0cG
         nUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=YgILgnfGDXDr3Bs2noKI3QGJ52/I6ya9VHtgK0INKrc=;
        b=OLRVILbkWAK/6nNNbYxHNc21PacursPET9814/XKSLYGa+MF846AFipcNR4oonrTJi
         /qoktKAzgevQtbW1zA9qicUskXDh9qWZ9LT+87jLohhHQqowZ1LaYDZG2tjr8bKptKdF
         5sKPjXkn6DWVbTMV7AgpnMe1yftBq2kVuE02hVHqoCYSV9TZ4cj9ydgEwGP8Z+nFUItn
         4+VlVgTmvNmPjoclOjUu9iofsYuXwCW+vXNyh7rcas9aw0UOB5LsGC9vLWJfeYF+H7yl
         pl4oeNEQLY07V7+xaZYFSoImoLi4VhrPv7JLuESH6KSkkwazXTHHpWlXcN1rWQ/XLN4p
         0uuA==
X-Gm-Message-State: AOAM532fO296hiAhIhdalep1DH6dWNkSQF/TlOBPyLHYPhEdkUFdScoO
        PdhqeVMGtrrDqpokzzd61xZWrA==
X-Google-Smtp-Source: ABdhPJy+825u06x4iRA9xOMt7MEfSea9Q6eYth4MIMAaK4761a2DGEE3q9PERdYOMmrzQ+M7PNtpYw==
X-Received: by 2002:a05:6512:21d:: with SMTP id a29mr6731931lfo.444.1610760353603;
        Fri, 15 Jan 2021 17:25:53 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 198sm1085686lfn.51.2021.01.15.17.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:25:53 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next 7/7] net: dsa: mv88e6xxx: Request assisted learning on CPU port
Date:   Sat, 16 Jan 2021 02:25:15 +0100
Message-Id: <20210116012515.3152-8-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116012515.3152-1-tobias@waldekranz.com>
References: <20210116012515.3152-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the hardware is capable of performing learning on the CPU port,
it requires alot of additions to the bridge's forwarding path in order
to handle multi-destination traffic correctly.

Until that is in place, opt for the next best thing and let DSA sync
the relevant addresses down to the hardware FDB.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 91286d7b12c7..398f3cc8d2f3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5726,6 +5726,7 @@ static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
 	ds->ops = &mv88e6xxx_switch_ops;
 	ds->ageing_time_min = chip->info->age_time_coeff;
 	ds->ageing_time_max = chip->info->age_time_coeff * U8_MAX;
+	ds->assisted_learning_on_cpu_port = true;
 
 	/* Some chips support up to 32, but that requires enabling the
 	 * 5-bit port mode, which we do not support. 640k^W16 ought to
-- 
2.17.1

