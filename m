Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBD32FC4B4
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbhASXWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbhASXJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:05 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DDEC061798
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:17 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id dj23so20990926edb.13
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iwCUNqLglIYcGVNIfzZGfQ5CfFXZV0rXFfVSZHPsXNc=;
        b=OsUuytmAk91454sP37H8sKX9ONiNQaQ0WwYxPOh5IfmGBN5SzbfMgp3BImxdL9zoHJ
         e3R9/ARS858ouAHoW6qv0xLLccTanK3lozA3KuZ5h8gb6zs+iTMKIibPr1EqSKxdV8gm
         zEDMVzt5T8xXyMkFN2DHZOXSv3ATQloYHO6hqgqtTAdhCBLfMz7k+sg6uNTk87lLpmyG
         QkO01pAU75usHYFN3mfAkNrWU0ASHeYQWuRjykirHoXtNrUVEHZdeCfbIWtgAhqeYkzW
         u2SO90HWfc0V1NekhNPj68wDDBKUwl+mBadbJhqjVaB8AH+0DRwtyM7NhF06n/s0vHk/
         VYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iwCUNqLglIYcGVNIfzZGfQ5CfFXZV0rXFfVSZHPsXNc=;
        b=YkM5XxqwyXxK83C40Vihr1rMNeH16QmGnWJBpmUBpOPCSO+3w0zarygqOy7KfLDuED
         tKQpCEkqg2IEqdTnFtaRX60q7JCMB2kbzlgXlkr7QK32mQrw7MpfJYbM3LstvaXdpkXH
         lJLRcHlknL5NrjeSl75qb3iCM/XIvrr1nHNAZ+W47UBUe3d0qLBkBuVUz9j2QzoXzoTF
         186UBISPLpqhevvqETBRf7AV85Q7gz+lmgMWf5CD2uDOuLHyrDpYGXujyEF7wfbMoNZA
         PRTrrVlM7vUhVabzjfUCIkkq/jLeS/WaOyXoIVS5MMaUjSGX3OBmgoTZHfxnoF4+e7DW
         jhHw==
X-Gm-Message-State: AOAM533wuTbqByCwoKThJm1y8OIjLuvoXIXJG4xk6aqpSmZTXv9klrZ6
        8R3vtKXOtDOCA7kIQEwSk1k=
X-Google-Smtp-Source: ABdhPJxhNKGe9dSXrXY2n5cp66gHi7rpW+HLplJdlyp0Yhme1FSV+/+tiiOBCH77H0B9pZEakJHP4Q==
X-Received: by 2002:a50:e0c1:: with SMTP id j1mr5028835edl.253.1611097696362;
        Tue, 19 Jan 2021 15:08:16 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 11/16] net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
Date:   Wed, 20 Jan 2021 01:07:44 +0200
Message-Id: <20210119230749.1178874-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This looks a bit nicer than the open-coded "(x + 3) % 4" idiom.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9535a75b1c84..55847d2a83e1 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -563,7 +563,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
 				 QS_INJ_WR, grp);
 
-	count = (skb->len + 3) / 4;
+	count = DIV_ROUND_UP(skb->len, 4);
 	last = skb->len % 4;
 	for (i = 0; i < count; i++)
 		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
-- 
2.25.1

