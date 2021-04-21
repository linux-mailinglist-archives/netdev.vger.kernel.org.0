Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3123672C0
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244825AbhDUSpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhDUSpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:45:19 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5058C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 11:44:45 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id j7so21337533pgi.3
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 11:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hmDaabGWp0ttp9pxTYH3OJJsh68hCp1NN8uFsOzUlSQ=;
        b=nd1BehaWw5XT9mLa9edLT+lH8Iwi+QPf+P3RHI2c9NPgad4xYpQsu0awmxjth7wgYK
         wmuQptkuoHQcEGjKd3QnL0Z4QEsFJ9Zc1HrnWQGgxMoM3SmBz49oNur3AdY7AIbCGKVT
         rkzvtGCd15iQEUPmKBKrDMfkFCJVYUxK5xBtlh3JEBkzlcndEHMFEMikojThNWAJ3TWN
         KjyC8AEPEpXeMa6+GSVYeZHPNWLIEGOKXL+kF2UeSWHtq2NejZwYssbQ4CpGgoDtFC0G
         4dZAcnO94fVG7jEVzhC0Tl4xKfBO6Na1MKol0y6VDzHNMRbqZLwVX1B+vTK4AO8jEiwa
         lKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hmDaabGWp0ttp9pxTYH3OJJsh68hCp1NN8uFsOzUlSQ=;
        b=fn0lDm4WJBcE+JFxGyirAwt6aau+8FCq04/yI0rNfwMKn1IuxwLYyDQRs/ZlIAGEDh
         bJ1a6lqe84KxUnpL2YfOg7GcvVJgKtWZdkr+iVs+VOiHDUo9Mt3NuqS/vBnwA5QaAFzt
         rOr+UD34EFf6LZmZPk3O/ghn2tuNPLAzBXKtUA5D9A4KhPjlkb52V472EuFXTUWZf9Ta
         YgOb0KxL/q7/rlNysTm4dPgTytkUq85FGEIFDICpUS1BgsaktRlUBwB4gzY01ex674Dw
         7LKafzQpe0UETgJ8eMcvso75R9jsePI4fMtGGRFUD3PNyO0a7R0adwNmh5oth4z+ZLY+
         dvdw==
X-Gm-Message-State: AOAM530cwp6qQI9c4NpCxRl5PHUcAkPOckAMHE6MuCCQMSWkuMfvnzMI
        VfNCm2VNlDynuQ/uEP8lT7A=
X-Google-Smtp-Source: ABdhPJxl0EGvUrvf/OCfB64+IYv97QB9RuXKUePHjiNBmONLNzA0YTlqxz8u2Oxbs+6xB5KxANtezg==
X-Received: by 2002:a63:f008:: with SMTP id k8mr22894788pgh.15.1619030685359;
        Wed, 21 Apr 2021 11:44:45 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w1sm130128pgp.31.2021.04.21.11.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 11:44:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: bridge: fix error in br_multicast_add_port when CONFIG_NET_SWITCHDEV=n
Date:   Wed, 21 Apr 2021 21:44:20 +0300
Message-Id: <20210421184420.1584100-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When CONFIG_NET_SWITCHDEV is disabled, the shim for switchdev_port_attr_set
inside br_mc_disabled_update returns -EOPNOTSUPP. This is not caught,
and propagated to the caller of br_multicast_add_port, preventing ports
from joining the bridge.

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Fixes: ae1ea84b33da ("net: bridge: propagate error code and extack from br_mc_disabled_update")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4daa95c913d0..2883601d5c8b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1625,7 +1625,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
 				    br_opt_get(port->br,
 					       BROPT_MULTICAST_ENABLED),
 				    NULL);
-	if (err)
+	if (err && err != -EOPNOTSUPP)
 		return err;
 
 	port->mcast_stats = netdev_alloc_pcpu_stats(struct bridge_mcast_stats);
-- 
2.25.1

