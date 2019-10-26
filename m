Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D391E5E5F
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfJZSEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:04:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38836 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbfJZSEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:04:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so5009342wms.3
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 11:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=76hfUmZ7nVB8iHUZwOQChUi8zfxthPIrrRKmqb2tzFk=;
        b=U8oSy1EJXevn6Nv8pEMEXw5VljSOKMa9zouCxIofeXwDzrtwFS8fGpG1A/WGssAqhs
         ZxHeXeRdeSeNQsx7CqGETg6nYzzMd/NdJUnv+kQF8dq1UsyIZ1o/nN5AcQdN+Hri4k6r
         pA2OMD5APCKKDUu41fZzLdbOv+BNQq4W5HZZTZVxu64oNSHHNmfNXS1sZarnCkqkSOrJ
         w1HS1paKbgIIhwmitRGY33ycQ2urIQyOBrZgfi/K/A+Aiv9BKV2tjkEhXAtcusHhQpfj
         KJK9jWXd/L6pkuY9sV84lFFjynG/F5qr8fmV59vNyq4mcRFT2aUSZ15wdsqyfgbSz0tz
         y9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=76hfUmZ7nVB8iHUZwOQChUi8zfxthPIrrRKmqb2tzFk=;
        b=e/a3J7cn7jzH1xgxF2KSPt8cxlMWx03LruvA/jQ3r5UUyJOWlQtoI3b8y3LRytNxX0
         LQMq8fo0RVg87IA40ic46OPwZumCB1Nb+CsnxrGyJUkQ7u3cGvlnhJnLKrHbAu+Bl5kl
         7eb1Je3gG+1nsHQR/YlenIGv7QhR2tZwNsHyNz7XbfVjGrSPxJqUwsEc2LUZz11ysV8j
         yIk/s0kwIamNdXrYZgnGZIqbPlUmMIZeNk0IkWnZlkouJCHG09XX6R6/WCKApNJOaNvc
         TexUBdO8+3Oens/LLmxIseWxTT93eV4N5cGCVJ3B0yH1kXz3laYdV2L/jPRCx6J44aGC
         ejpQ==
X-Gm-Message-State: APjAAAVDvcSQILRkYxNfqwhrd4A8VbUq8Nv+NLZkPZzjR5uiRI9EzdCn
        Ln7/Zofp5hY6jGyoRqP8GEc=
X-Google-Smtp-Source: APXvYqz6p12os8ySeevHvYEIycb8aekU0nPAhy4C5G1uBfImPJyEuXmEgvqrvRPAO/2OH2YLTIAM3g==
X-Received: by 2002:a1c:3c43:: with SMTP id j64mr7062813wma.13.1572113091021;
        Sat, 26 Oct 2019 11:04:51 -0700 (PDT)
Received: from localhost.localdomain ([188.25.218.57])
        by smtp.gmail.com with ESMTPSA id 1sm5568036wrr.16.2019.10.26.11.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2019 11:04:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 2/2] net: mscc: ocelot: refuse to overwrite the port's native vlan
Date:   Sat, 26 Oct 2019 21:04:27 +0300
Message-Id: <20191026180427.14039-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191026180427.14039-1-olteanv@gmail.com>
References: <20191026180427.14039-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch driver keeps a "vid" variable per port, which signifies _the_
VLAN ID that is stripped on that port's egress (aka the native VLAN on a
trunk port).

That is the way the hardware is designed (mostly). The port->vid is
programmed into REW:PORT:PORT_VLAN_CFG:PORT_VID and the rewriter is told
to send all traffic as tagged except the one having port->vid.

There exists a possibility of finer-grained egress untagging decisions:
using the VCAP IS1 engine, one rule can be added to match every
VLAN-tagged frame whose VLAN should be untagged, and set POP_CNT=1 as
action. However, the IS1 can hold at most 512 entries, and the VLANs are
in the order of 6 * 4096.

So the code is fine for now. But this sequence of commands:

$ bridge vlan add dev swp0 vid 1 pvid untagged
$ bridge vlan add dev swp0 vid 2 untagged

makes untagged and pvid-tagged traffic be sent out of swp0 as tagged
with VID 1, despite user's request.

Prevent that from happening. The user should temporarily remove the
existing untagged VLAN (1 in this case), add it back as tagged, and then
add the new untagged VLAN (2 in this case).

Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 552252331e55..18d7ba033d05 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -262,8 +262,15 @@ static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 		port->pvid = vid;
 
 	/* Untagged egress vlan clasification */
-	if (untagged)
+	if (untagged && port->vid != vid) {
+		if (port->vid) {
+			dev_err(ocelot->dev,
+				"Port already has a native VLAN: %d\n",
+				port->vid);
+			return -EBUSY;
+		}
 		port->vid = vid;
+	}
 
 	ocelot_vlan_port_apply(ocelot, port);
 
-- 
2.17.1

