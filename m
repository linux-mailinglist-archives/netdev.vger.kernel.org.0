Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C821B2ED8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgDUSOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbgDUSOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 14:14:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE55C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:14:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so8434203wrr.0
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9UHo9oFB8AakcphI/4xpbVE0Kx+Z8R+yY/90MyFs7wY=;
        b=VNdCbXJkKPQZ2TLF1Nrxnzgdprdd25VcAfUwOqS792XL0DCFAdsUVXSlx+IoMUvVgf
         TELTJlIhZ8hT4iacJziPGSVFnmiNJTRru0THqsGYNAaDf+/MLSfYTmjfQ5UFDgJWgDac
         6zw50GACcsoao7bRsXqO94aiLp8D7qMKKV7+xOdwc1ef0cBgRMTvPEr/PQzOU7T5oMbH
         nYDO8WmgROHNZQ/HS4uHujF/6TCpEgXNnpMunrKQwO68lWGTSSANfuxp6BOJ6que2HkZ
         UjwmdXl5fCVRV7TWKzdjvjUuSt3kSCQiF3gv3qOLHquPaeegYq+FjpjbPpppl81iLyiU
         e9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9UHo9oFB8AakcphI/4xpbVE0Kx+Z8R+yY/90MyFs7wY=;
        b=pGN8BGAN6bmXbDwXoydOJcAiZNKfIlkTWNr8kHDo8YCF/O442e3FRKi5C7CSnSFtxS
         fypH9QomLJy7Zhjs660B6W1mBXwkTpJeEYvWuNQU9pDX2GXpSM9w0Px0VhAgdZEWPgIM
         X5BOiDyZQUVG3ygN0AzKaQJmMZ88sJo28KkZ1z9tiH33EXSSjzGrTnb3Msvi3OBAMCnN
         AvUD4v7DEYKU6K517JEA3WKBMTVr+fjgoe8XSS9ufN3vcXn1awUMUB/gEJYRFwCPDi2W
         cQ6t/QthmRFuierkkJVBj9NvxtRF7kTWV1IJ7aldypNGQe+fFqR12vvNWF/wC8Iu/e6A
         yicw==
X-Gm-Message-State: AGi0PuZmWIyNJLlohNlAo6Rq712WG5x0OByYvoHwHFAW7J+oJO3usDJZ
        KeKM0RD1siuF9xA5i1xQM1o=
X-Google-Smtp-Source: APiQypJYOupvgfheCMxLqs0iYVJ7U9OX9Bgx6EnvvfraHnTWX7FJtmDRI8NLLicbjCh0f3m1g9otpg==
X-Received: by 2002:adf:f986:: with SMTP id f6mr25039886wrr.221.1587492846922;
        Tue, 21 Apr 2020 11:14:06 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id h13sm4653876wrs.22.2020.04.21.11.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 11:14:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com
Subject: [PATCH net-next] net: dsa: felix: allow flooding for all traffic classes
Date:   Tue, 21 Apr 2020 21:13:47 +0300
Message-Id: <20200421181347.14261-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Right now it can be seen that the VSC9959 (Felix) switch will not flood
frames if they have a VLAN tag with a PCP of 1-7 (nonzero).

It turns out that Felix is quite different from its cousin, Ocelot, in
that frame flooding can be allowed/denied per traffic class. Where
Ocelot has 1 instance of the ANA_FLOODING register, Felix has 8.

The approach that this driver is going to take is "thanks, but no
thanks". We have no use case of limiting the flooding domain based on
traffic class, so we just want to allow packets to be flooded, no matter
what traffic class they have.

So we copy the line of code from ocelot.c which does the one-shot
initialization of the flooding PGIDs, and we add it to felix.c as well -
except replicated 8 times.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 7 +++++++
 drivers/net/dsa/ocelot/felix.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a312a236a606..83bfb0548fbe 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -506,6 +506,7 @@ static int felix_setup(struct dsa_switch *ds)
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port, err;
+	int tc;
 
 	err = felix_init_structs(felix, ds->num_ports);
 	if (err)
@@ -531,6 +532,12 @@ static int felix_setup(struct dsa_switch *ds)
 	ocelot_write_rix(ocelot,
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_UC);
+	/* Setup the per-traffic class flooding PGIDs */
+	for (tc = 0; tc < FELIX_NUM_TC; tc++)
+		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
+				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
+				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
+				 ANA_FLOODING, tc);
 
 	ds->mtu_enforcement_ingress = true;
 	/* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index a609a946cbd7..c4303e7c4164 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -5,6 +5,7 @@
 #define _MSCC_FELIX_H
 
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
+#define FELIX_NUM_TC			8
 
 /* Platform-specific information */
 struct felix_info {
-- 
2.17.1

