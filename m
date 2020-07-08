Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B662191C6
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGHUpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgGHUpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:45:09 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6227EC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 13:45:09 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 9so55741549ljv.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 13:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CYN4ZPTRRLmikf2AfGJfBSOfESO1vZ7Kmrp2kg16ins=;
        b=lj2fY8b5b+/T0hqmF94GXmba3uJdPM5GXqZZPv419BtMmn7WoPmKxltsvm/W1ZWPbt
         2ptHrAuBxDBvQ+hiYY/1AegpNnX/SfnKabmpB/0sWErzE6e7B6KkKR1QBSfiLfKvqpur
         /Lx9wFvxwMXXWzYGvbz1QT3SPHcbNPg0vvZxy/95M6hOB8GfWJYfJ+exgTpZnpJz05co
         iMjeSlWVLs/HUvqB4B+P8VXmHeSfcsTalFOObGN8L9AdHManuTIkho5iiCTJB0YqFt5z
         t5bP097C8cBvdag5FTd32dwliu0ThZQ2NrBOtmMPdrTbAExgUIHPF+G6wK68d0xpgiwW
         69VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CYN4ZPTRRLmikf2AfGJfBSOfESO1vZ7Kmrp2kg16ins=;
        b=TDuI54/2Yskn20NdH8YTy5s65ccvg1Qd2VVs2Fa1RQpu9MDwpQyj0XZhhEhNtYooGp
         s5LUM6LxoAC86VDKEIfiNZ2DY9qWGAdKeWv1fBkoCaUY0n2LG9gqaptLsX5hdyKrAOxU
         MIyFyW1Qh8YL7mQSiLYSXTrZcUig10/LFaE80LhHyUcw8jQknzoahwCdCfrWcJZfrOJ0
         BU/WW5y4igYMr4DbBf0yCt+s2mPzIkDg/bFRhewHuWDvkmTcchcu5J7lWjGy24G7Zpcy
         CZFcGQgWjTZ3BmKOgJBnuHQlxe0u5l41wEFTzWYiAGofeNeNhSazZqt1r8t48Y3L2aFY
         7JXA==
X-Gm-Message-State: AOAM530GRXKYiRr9Bcm/dDT4hwRIweK1rdImz3Vr/McGmOWIzSSEKR2/
        bKd2vtNYiosJrZFymNgLRKFlwQ==
X-Google-Smtp-Source: ABdhPJxrQ6X5/yifvlr0eRHTOtRUGsFC3V0M8GqJV5CrT08Ad+5HEb0Pkng93r81ts/d9eZ4gbTTXQ==
X-Received: by 2002:a2e:3e15:: with SMTP id l21mr12753883lja.43.1594241107826;
        Wed, 08 Jul 2020 13:45:07 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id i10sm206688ljg.80.2020.07.08.13.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 13:45:06 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [net-next PATCH 3/3 v1] net: dsa: rtl8366: Use DSA core to set up VLAN
Date:   Wed,  8 Jul 2020 22:44:56 +0200
Message-Id: <20200708204456.1365855-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708204456.1365855-1-linus.walleij@linaro.org>
References: <20200708204456.1365855-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code in the RTL8366 VLAN handling code
initializes the default VLANs like this:

Ingress packets:

 port 0   ---> VLAN 1 ---> CPU port (5)
 port 1   ---> VLAN 2 ---> CPU port (5)
 port 2   ---> VLAN 3 ---> CPU port (5)
 port 3   ---> VLAN 4 ---> CPU port (5)
 port 4   ---> VLAN 5 ---> CPU port (5)

Egress packets:
 port 5 (CPU) ---> VLAN 6 ---> port 0, 1, 2, 3, 4

So 5 VLANs for ingress packets and one VLAN for
egress packets. Further it sets the PVID
for each port to further restrict the packets to
this VLAN only, and sets them as untagged.

This is a neat set-up in a way and a leftover
from the OpenWrt driver and the vendor code drop.

However the DSA core can be instructed to assign
all ports to a default VLAN, which will be
VLAN 1. This patch will change the above picture to
this:

Ingress packets:

 port 0   ---> VLAN 1 ---> CPU port (5)
 port 1   ---> VLAN 1 ---> CPU port (5)
 port 2   ---> VLAN 1 ---> CPU port (5)
 port 3   ---> VLAN 1 ---> CPU port (5)
 port 4   ---> VLAN 1 ---> CPU port (5)

Egress packets:
 port 5 (CPU) ---> VLAN 1 ---> port 0, 1, 2, 3, 4

So all traffic in the switch will by default pass
on VLAN 1. No PVID is set for ports by the DSA
core in this case.

This might have performance impact since the switch
hardware probably can sort packets into VLANs as
they pass through the fabric, but it is better
to fix the above set-up using generic code in that
case so that it can be reused by other switches.

The tested scenarios sure work fine with this
set-up including video streaming from a NAS device.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c   | 35 -----------------------------------
 drivers/net/dsa/rtl8366rb.c |  3 +++
 2 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 8f40fbf70a82..e549b1167ddc 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -275,41 +275,6 @@ int rtl8366_init_vlan(struct realtek_smi *smi)
 	if (ret)
 		return ret;
 
-	/* Loop over the available ports, for each port, associate
-	 * it with the VLAN (port+1)
-	 */
-	for (port = 0; port < smi->num_ports; port++) {
-		u32 mask;
-
-		if (port == smi->cpu_port)
-			/* For the CPU port, make all ports members of this
-			 * VLAN.
-			 */
-			mask = GENMASK((int)smi->num_ports - 1, 0);
-		else
-			/* For all other ports, enable itself plus the
-			 * CPU port.
-			 */
-			mask = BIT(port) | BIT(smi->cpu_port);
-
-		/* For each port, set the port as member of VLAN (port+1)
-		 * and untagged, except for the CPU port: the CPU port (5) is
-		 * member of VLAN 6 and so are ALL the other ports as well.
-		 * Use filter 0 (no filter).
-		 */
-		dev_info(smi->dev, "VLAN%d port mask for port %d, %08x\n",
-			 (port + 1), port, mask);
-		ret = rtl8366_set_vlan(smi, (port + 1), mask, mask, 0);
-		if (ret)
-			return ret;
-
-		dev_info(smi->dev, "VLAN%d port %d, PVID set to %d\n",
-			 (port + 1), port, (port + 1));
-		ret = rtl8366_set_pvid(smi, port, (port + 1));
-		if (ret)
-			return ret;
-	}
-
 	return rtl8366_enable_vlan(smi, true);
 }
 EXPORT_SYMBOL_GPL(rtl8366_init_vlan);
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 48f1ff746799..226851e57c1b 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -743,6 +743,9 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	dev_info(smi->dev, "RTL%04x ver %u chip found\n",
 		 chip_id, chip_ver & RTL8366RB_CHIP_VERSION_MASK);
 
+	/* This chip requires that a VLAN be set up for each port */
+	ds->configure_vlan_while_not_filtering = true;
+
 	/* Do the init dance using the right jam table */
 	switch (chip_ver) {
 	case 0:
-- 
2.26.2

