Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B18C17475E
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgB2Ob1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:31:27 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35452 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgB2Ob0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:31:26 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so6451678wmi.0
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8Mh4PQPP+VV5YeRnyWKmF2p6NFmwDw0hvASb4H+WdEk=;
        b=mWDo1WG/QXQ4SkPzQgTP6yq5HkNT00OXjyFlIOgyrbCWkyn/FHJAPtrKXOkSIOdglR
         R+0X8Eb9g4sfmvJNwosBQPbO0GnqZurOBgTpau/KgfLccziC/cOReJocr2AfPRxT4+5b
         MLMIq8ZQFGmoFJETjXJwbU8e6HuWf2p20PF36syI4yYPKa0eH7EoWMhvx5mQZXI1CzZl
         eHO3qr+QzSXh0W2CwYELPqonIDDc1KUN18t1Np8Z/A/tIXqCkwtVV3ZB1uQiX4riHsz2
         34F4OKswYM9qIKurmCHCCrhgyotANlKBQEKOkcmRgVdCPK/FNwsG7/Iv0XCFP6hT9AvM
         1vWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8Mh4PQPP+VV5YeRnyWKmF2p6NFmwDw0hvASb4H+WdEk=;
        b=MSwrSco9SISH+CRzX1kIZfqK/n3SHvQWBGOhVJx95LpEu65U/5cs9yXm7xtXDfoDs/
         m5r2MU1CwOFTWs8/VZcfyA3vxfk8B12CMbno6dG27Jd7WdGDM/2sqvVOp3XmPRpl2nJO
         4Y7zy3PiUPht7FVqmk5xSrkg9YzzwoA0FBkFKeADfa/kI6lNdhTdN5QSeoXfxF3gJ+gI
         wAltKiNjLxgwSRTnBS2SYCxSn7HOuQSlcdaeyeU5H5a9YTlmvw+8VlU4+wQdKKOXpKne
         Zh0KOTDRIwY2Jke0/0XENfFMDDQOIavU9Pu7sXCLI9hxZpvdnm3lQZZE+8xH1M5hotZ+
         7qNg==
X-Gm-Message-State: APjAAAUO2+E3/7ZsUoJxo3jRaiP1fRMxjgrHuPhktRleOSaHKeftk27J
        O/Y+BGDGTxEQJCCtFF0S108=
X-Google-Smtp-Source: APXvYqxIAoRzR1t0fWJsV2Ea1xuozSSmKH2hji1eVhY/nv93ch/p8jHkqaRkAb0X+aj2zBtd9dbIrg==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr9906452wmk.131.1582986684344;
        Sat, 29 Feb 2020 06:31:24 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id d7sm7573528wmc.6.2020.02.29.06.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:31:23 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH v2 net-next 04/10] net: mscc: ocelot: return directly in ocelot_cls_flower_{replace,destroy}
Date:   Sat, 29 Feb 2020 16:31:08 +0200
Message-Id: <20200229143114.10656-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229143114.10656-1-olteanv@gmail.com>
References: <20200229143114.10656-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no need to check the "ret" variable, one can just return the
function result back to the caller.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 698e9fee6b1a..8993dadf063c 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -192,11 +192,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 		return ret;
 	}
 
-	ret = ocelot_ace_rule_offload_add(ocelot, ace);
-	if (ret)
-		return ret;
-
-	return 0;
+	return ocelot_ace_rule_offload_add(ocelot, ace);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 
@@ -204,16 +200,11 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
 	struct ocelot_ace_rule ace;
-	int ret;
 
 	ace.prio = f->common.prio;
 	ace.id = f->cookie;
 
-	ret = ocelot_ace_rule_offload_del(ocelot, &ace);
-	if (ret)
-		return ret;
-
-	return 0;
+	return ocelot_ace_rule_offload_del(ocelot, &ace);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 
-- 
2.17.1

