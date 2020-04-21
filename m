Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A0F1B2E29
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgDURTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgDURTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:19:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D6DC061A41
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:19:04 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k11so17357899wrp.5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kTWUHRQKPKpzTlUIoCJ/NljuJvyMCXiL+APxJTG+Ccw=;
        b=nKkYt/CQ0KDdwoiynzFMSbkfaYqZ63koro8l8dONcdKcKgv/9nxrJEIOPOyp7M93tG
         V5afF6EUepMPypuYf7z3G4+we3Go5elpIHV5hhys7lhrFKmeyxppxSVDZrxdCXgq1/kL
         YG3fVuavrF8ubuea1CsBhzfg4J5pB6wV34LrzTZG9/7sxr8yh5eGBFjLAnkiFV3+lzO4
         T1f9Yl2p/Xpf/JSGWb0iXJUluY/VAuT9crvH4k1rdSawkXNDkwtBPV4TnKbmGdKEDrab
         dAqYQClPgU1i1QuhKEV6Rm1/CsU9VTac+zd3851KXxsdsCVCUdhFr91lK2+AKaFkS6vP
         yfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kTWUHRQKPKpzTlUIoCJ/NljuJvyMCXiL+APxJTG+Ccw=;
        b=luFFHjOH/8o+djN2gVw11r8W63MOqcje5iuPJfhl/9+R2YoZZSTb9l6/09o0h4imoo
         kGkW44n/SqlBRCh12RH1OJe+rkV5IQUGLPIw5vdenZqDV0ddhzjV/dVUxjj9TofTrqTB
         v4jMA/xpblxB2RCJN6Hz/Ot3B50s0JjGkd643gEhpe9Ik5zVVQefXsF7wUHolU9rcMHd
         notBiuWaHbpRPpW3SRT3XmD6vOamjAku8VfMBrA2eNtQ9w0/dBzaxoq+gT2ap8TAHDzR
         LbOk5SMHuw4loiQKazcX7zG6YObYKtYhXjBCHtVY2wRI2jEBEWsnGLiFLQ9AlQImO1yc
         73Zw==
X-Gm-Message-State: AGi0PuZkMNXGxGlEnBYHj7sTcg5vDDPw64jUXS4zHkyMaTtRuuKLD11d
        hIDazRSTe6jhLxHLTc6ogQo=
X-Google-Smtp-Source: APiQypJStz1y6ciLz19GhV44zAdM7fQp0vgSrPVuZJ1la9neYuia2BWHul1XAMy1JmYT3prFULWLJA==
X-Received: by 2002:a5d:6841:: with SMTP id o1mr24974158wrw.412.1587489543026;
        Tue, 21 Apr 2020 10:19:03 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id b12sm4921984wro.18.2020.04.21.10.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 10:19:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, o.rempel@pengutronix.de
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net] net: dsa: don't fail to probe if we couldn't set the MTU
Date:   Tue, 21 Apr 2020 20:18:53 +0300
Message-Id: <20200421171853.12572-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no reason to fail the probing of the switch if the MTU couldn't
be configured correctly (either the switch port itself, or the host
port) for whatever reason. MTU-sized traffic probably won't work, sure,
but we can still probably limp on and support some form of communication
anyway, which the users would probably appreciate more.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e94eb1aac602..d1068803cd11 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1770,11 +1770,9 @@ int dsa_slave_create(struct dsa_port *port)
 	rtnl_lock();
 	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
 	rtnl_unlock();
-	if (ret && ret != -EOPNOTSUPP) {
-		dev_err(ds->dev, "error %d setting MTU on port %d\n",
-			ret, port->index);
-		goto out_free;
-	}
+	if (ret)
+		dev_warn(ds->dev, "nonfatal error %d setting MTU on port %d\n",
+			 ret, port->index);
 
 	netif_carrier_off(slave_dev);
 
-- 
2.17.1

