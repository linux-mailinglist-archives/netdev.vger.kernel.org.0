Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2223026ABCB
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgIOSYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgIOSXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:23:31 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40153C06178C
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id w1so4027641edr.3
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r4dmHhQhCwQ9a+IkrFWfHN7MHRZFD0JOIVYiWHLHOK4=;
        b=CTOr3ayYfuI3EuHshnimLdbGxz5vu1qtiHCbd5LyZGCSnXRC6hg0ZvuHe3scbuPt0D
         A+82vjnJxXZcNNa4lGwd8W67jaYZaBZZGIqsk3zfE0yeyUiKJ75GLw80FG2QcU4qSIzO
         7DguK8i6qGytTb35sXF8AQl63wb9yqW/ns+r5wLDo1RnR8A1vbBtaC3xgepgvW34Co88
         5801VCvNsawXCSLfuXLa7HiVsvBBCDU9UTM7EA0B66be3WU7ITJWgjFQ6HsxE4/G9Z2Y
         8D5TM14vd5HulyfNA6ESLZPeNpBRrnOVmbyzcwTAi+ga1WKTfXlc/sduAKWCIikQtPIf
         cl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r4dmHhQhCwQ9a+IkrFWfHN7MHRZFD0JOIVYiWHLHOK4=;
        b=mb7Wg+J1gfrTsZwC8qKTN+ewug8gZi13NBWQWsfGMlinlAtbfc94aXFe7NAMf6WdjL
         QHijzxP3MbkPYaCophdwa7MRGWyiB4VJOSecKIay3jY4E+fw+ywcd6uOX4qGDlfhdBtO
         NbxI6aFOFBNlYShs8UXcpYFD1rm9lq3PB2sa+NxBvXCyqcRXl+rdgfvvZYd2NNhVtRe3
         /Moj4adXQFwRhFnY538Ivuuds4WNW3GeeKkTHqBkfLzDf+UA9qXRo4RO2RIvC986R8jm
         sBpqfpZpzneVMJYnpuHOgoxVjgzY6Cep5jcWUT2UJiBULXydl5iO8OtMX4+eKEjOxEgT
         CRuQ==
X-Gm-Message-State: AOAM532VH+WR2WIg/pZc+GQekyCiaSqOXCFsOhsEUicvAieQhr9NtYSX
        0N5B+Ls+QpbjZA3F7TODYxY=
X-Google-Smtp-Source: ABdhPJw2U/LWrJ7jZm+UwPg4p35h7oqE92psnpt/DDqGLrKm5PHGbEga99IviIfI9H+YpCEOVpjJsg==
X-Received: by 2002:aa7:d29a:: with SMTP id w26mr23467938edq.106.1600194173992;
        Tue, 15 Sep 2020 11:22:53 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q11sm11860481eds.16.2020.09.15.11.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:22:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 4/7] net: mscc: ocelot: check for errors on memory allocation of ports
Date:   Tue, 15 Sep 2020 21:22:26 +0300
Message-Id: <20200915182229.69529-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915182229.69529-1-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Do not proceed probing if we couldn't allocate memory for the ports
array, just error out.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 65408bc994c4..99872f1b7460 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -993,6 +993,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
+	if (!ocelot->ports)
+		return -ENOMEM;
 
 	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
 	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
-- 
2.25.1

