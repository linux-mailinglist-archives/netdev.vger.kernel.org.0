Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32C01DD97D
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbgEUVbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:31:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AC7C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:31:37 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id se13so10586800ejb.9
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pDSebOsxzL18KqcUiTLY9RMe0a7LGyf6LkoA3RrZLDo=;
        b=HNKweX1kG+n+CB7szED+Zgl0ceyMkEKCJDsw9vz+WHbz/CGMiXcFa0Ca6Eo1r7dHS2
         nv2bfcZFMtgh8Ei/eRqCdTbJgx9Wry8WsYhMpAWakNQf97rEq76GQMlgjacx9CEum+2n
         qJjlqo+icXwx6ljS2/lgKubPC8JaLY2cwhfPx17vBQPUfEW86vCgrPgUbql88G1RxDiN
         7iI8vMDCfw7rroNClOmaHwJq2vjBZqUQDZ71II7xX9HjQ5UbYFi2EPpAXrpm+VcATNBn
         Di0OwfwIojzpMV/aPfGnB52JQocJtNTcuJcb7RLYwdxQ4EofWVR4cyiABSU4YbFwWkqw
         rGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pDSebOsxzL18KqcUiTLY9RMe0a7LGyf6LkoA3RrZLDo=;
        b=uK7SjvR5l1DkVa+0JKh8IiifgZSuaRZkBRvXnYsDUSVZ1NLS94ierwEIYo0yef7hZC
         7kqZHtVLTZdZe5YXGXTi/F3VY8I2Qu5eiMDJeNrXtVuAzmN1hxfHU4WFHrdjwMSIADZj
         JLbkitfZg52xG3xXeIeZE2SKUmy7aNmjuQkctXVryNfToMpGvOkLxRujOIJH/JzSqBAd
         AbknZVHEipni2AWwq8y6R6BkR1lbAGlVIjvrVHLxVNtxALAxFsxAr88vuxZ4cPBW3dSr
         jEKQjJNJRYord8loXd+i3qmPRiyxTIR98LY3tx9l9V8V2fIAICuP9HjGkP+lLYOlYEQ6
         K/zg==
X-Gm-Message-State: AOAM5316VbQ9wrOcQ6i3Vjj/HAoJKcQKM7lmxHXR/oyRVXbMYcHvbeA+
        Sh2Y/nqa541Q5fLUH8gfUaA=
X-Google-Smtp-Source: ABdhPJxi3mfaAUn8E1628gONIMYNHmgeyXT/eeUeY66tVzF5DmpbP05ZwUe5WXzPzr092PCPgq4OOg==
X-Received: by 2002:a17:906:4e87:: with SMTP id v7mr5007958eju.431.1590096695919;
        Thu, 21 May 2020 14:31:35 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id u26sm5794318eje.35.2020.05.21.14.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:31:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com
Subject: [PATCH net] net: mscc: ocelot: fix address ageing time (again)
Date:   Fri, 22 May 2020 00:31:23 +0300
Message-Id: <20200521213123.672163-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ocelot_set_ageing_time has 2 callers:
 - felix_set_ageing_time: from drivers/net/dsa/ocelot/felix.c
 - ocelot_port_attr_ageing_set: from drivers/net/ethernet/mscc/ocelot.c

The issue described in the fixed commit below actually happened for the
felix_set_ageing_time code path only, since ocelot_port_attr_ageing_set
was already dividing by 1000. So to make both paths symmetrical (and to
fix addresses getting aged way too fast on Ocelot), stop dividing by
1000 at caller side altogether.

Fixes: c0d7eccbc761 ("net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e200af736b10..468c83a4c557 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1478,7 +1478,7 @@ static void ocelot_port_attr_ageing_set(struct ocelot *ocelot, int port,
 					unsigned long ageing_clock_t)
 {
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
-	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies);
 
 	ocelot_set_ageing_time(ocelot, ageing_time);
 }
-- 
2.25.1

