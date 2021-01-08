Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4182EF6E8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbhAHSDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbhAHSDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:03:54 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F86C0612FF
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:02:39 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id q22so15734162eja.2
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ib0uaWDINGMGCys32NkHPElpClnDIVBeWgczTXiJSa8=;
        b=R4+0v/zkzQIyNg/B9iTXGXd+dukJ6Mwpy8I5yYhgDUMUXAn+guOAoA/viQ4p0DM3E5
         nY1MMrWGnjuM4Y7b5514Rz1SALH/RrgHsHDOA5HHTZz1UvKOQC/VSVtOOc+f54dhbCOt
         MeCOnQGuaeCz2C/bk+FHMri+cu5VpI1xLGuCwMYkiKn88W38E2VvVsAaoE41flxj8ILQ
         XY6eSzuTgX5d/hSy1MDjztlKPe1R76p7cKt7qXmMDt/q+QwK1GBw36l8rxdUREOCdL9o
         CFHB12Y+y3gxhPPneHFCk+Yoo2UgDWc6yE16eUBoCCH8X1Z2LulhvxHaxg9f3h+n3S4W
         smag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ib0uaWDINGMGCys32NkHPElpClnDIVBeWgczTXiJSa8=;
        b=fXqBKNdka42ykFkJXN2KqnsJpi4d5XdwBIgqk6IN0LObcKh59CW6OUrF+ByMM6KyCT
         bO/NjRoKf4tbzqNBFV7PRwXwOrSlG+9PDjwWLGVmtd6d4/0yxNK/d2tXEI7sOCI5Xjrh
         tM1Y2YVZukSPk7BYfoDZVTuwDMxEJ6ovU6IbaCnE+GhC2TYEI4NdAu5ufBc45k9Jg6ez
         kL6THUwda4K5Sx1VxM+KFtVjv2GVG7TtwIbwkzfoeAqY7j/qmT5pZH0bD5lFRrwHuY2n
         75OjVZN9wFXJYbVEThGUcJ7+0SRi/u7m0TSLrQOh4ztr61OwVLZQSVgazInh+0WbjRNT
         5gDw==
X-Gm-Message-State: AOAM532JyBdNHYQgXyuGh5dpk5rUvokT1dpbI7H321dFkUjIoEfjRQ3y
        +R7xaMOjjCxaram3ee0FwyhsmbzKZzs=
X-Google-Smtp-Source: ABdhPJwVMlyqF9wMe0+uAdM+DQu5u0i8Q00mQhj1dC4Q6qyujGOxtrD72jv1kLXlhmoo3mb7pu0tvA==
X-Received: by 2002:a17:906:f949:: with SMTP id ld9mr3473278ejb.401.1610128957544;
        Fri, 08 Jan 2021 10:02:37 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b19sm4059713edx.47.2021.01.08.10.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 10:02:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 05/10] net: dsa: felix: perform teardown in reverse order of setup
Date:   Fri,  8 Jan 2021 19:59:45 +0200
Message-Id: <20210108175950.484854-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108175950.484854-1-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In general it is desirable that cleanup is the reverse process of setup.
In this case I am not seeing any particular issue, but with the
introduction of devlink-sb for felix, a non-obvious decision had to be
made as to where to put its cleanup method. When there's a convention in
place, that decision becomes obvious.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 79d0508e5910..42770a86e871 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -639,14 +639,13 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	if (felix->info->mdio_bus_free)
-		felix->info->mdio_bus_free(ocelot);
-
+	if (ocelot->ptp)
+		ocelot_deinit_timestamp(ocelot);
+	ocelot_deinit(ocelot);
 	for (port = 0; port < ocelot->num_phys_ports; port++)
 		ocelot_deinit_port(ocelot, port);
-	ocelot_deinit_timestamp(ocelot);
-	/* stop workqueue thread */
-	ocelot_deinit(ocelot);
+	if (felix->info->mdio_bus_free)
+		felix->info->mdio_bus_free(ocelot);
 }
 
 static int felix_hwtstamp_get(struct dsa_switch *ds, int port,
-- 
2.25.1

