Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D1C2ED59E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbhAGR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbhAGR26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:28:58 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E977C0612FA
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:27:43 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id b9so10878251ejy.0
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4TCGpKXqQUc0ViJ9zupXNDQY8HxSwaMhWc4+rEUUj4k=;
        b=nsndqbkITP0ZNdjoZtbjniOfbPOvrt+1ufAkY2N0WWpONK6ntIUtPjAByp3nJY8mU2
         UsSmsxxff3hnCA56WT0pgOqbKAoT7KPnT5Ydo/+t23xFIUC9Pu3Wi2VK6z0YcYdgixai
         4E1X2XK/Gtn7DKBWs6jUoQFWrAcC4cb71Ofc6VXgV9J/X2am7sq/ZfV8AckTl6FsKuVY
         yh7Q3bpPCLxL8M1ztIufSqTPedQZKg0IV5DOizvAzteSI46qf6IrgJ7xpSLB82H4vmHF
         OOWdld7lK5tJNI3n9wYoh7LgFG8cOd5h/+tddBtjfz6Q+ar7pSt/9aIQdwlhnMIYyzMG
         GvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4TCGpKXqQUc0ViJ9zupXNDQY8HxSwaMhWc4+rEUUj4k=;
        b=cbCsGrKQ+NFDtnnz12TEsI/ItmxOX+7lfRztKlLeNHm+KErDrX4hUytllD2hfbgtTl
         l37hkEgoOuZf/oZ21Tfmv9+DH2PLTSkJftOSBvknlTJFKLA8rln021+QrV5Rxs0c7J5m
         8UMGotM2H0s4eFxqN3p4WfB6JJkBfjEuhb5qqyIKUYzL0zAtcKokJJYthAaG0de4zR6v
         JllWxg70uuiIesRQurmOyPiG4wwqY+gO8EjFMWWojA504R1cNnguI/2peSu+LLFbUdWX
         o3TFJ9cWyOA8IWPXa8/x0/51L1tEsSR/8XvGX8PcsWUFcXvfTn+OU/sHJOnU/EP3a1aK
         fQRg==
X-Gm-Message-State: AOAM5301i2DyLK6EWbalOVXFpJalueJ12wNiwSplUaXOTUgvu/Kp3Md/
        XGhB5uUTFnuRcFX2MSRZyLh1P3o4I/g=
X-Google-Smtp-Source: ABdhPJziJlICdSu8JXtn3uARwyh78t3v6aoom24jRKheGkQZBXe9yb8vM7wrV8TGnxr775wLMNLHVg==
X-Received: by 2002:a17:906:68d1:: with SMTP id y17mr7092156ejr.447.1610040461740;
        Thu, 07 Jan 2021 09:27:41 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id y14sm2643351eju.115.2021.01.07.09.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:27:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 05/10] net: dsa: felix: perform teardown in reverse order of setup
Date:   Thu,  7 Jan 2021 19:27:21 +0200
Message-Id: <20210107172726.2420292-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107172726.2420292-1-olteanv@gmail.com>
References: <20210107172726.2420292-1-olteanv@gmail.com>
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
Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 74f3334ed6f8..a9bf8ea7bbce 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -638,14 +638,13 @@ static void felix_teardown(struct dsa_switch *ds)
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

