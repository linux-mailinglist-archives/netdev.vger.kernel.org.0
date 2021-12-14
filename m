Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6989474D00
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbhLNVKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237791AbhLNVKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:32 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A007C061574;
        Tue, 14 Dec 2021 13:10:32 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o20so67926799eds.10;
        Tue, 14 Dec 2021 13:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dfo2Z28c0nUHb7GY/2itHROe1c/3b/U6k/gdflVih/g=;
        b=ghy+0SA/R59GejuEKwPCqO20D6SVPizFFxQPNqLUQdLI2PPf6UwW1tUA04Vay1w13G
         LkwKaez9v5KjQfPEMynmEztswW8o9CfcSNn4e4OJVT7aaZpbl1HYKp+PEYNzold2dm/O
         qffgC/YKoWS/ra04SEyouqCD2fO+qW4DmCPU14cfh7zSWbMsSbIFcIB/g9AjrEVYKQln
         dNQ7dTufndi3ZtqG2qrf+5t8hpPVzsVJI+7wc3732P+++aMHfyeb25DWGxflrMoqR+ua
         31IBjs4WXpNb0ZLaQbOTtIxkwBTnXwEpQP7L2QsCViAisDzizw0mfQDrWI7mTG84Ke8N
         5xNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfo2Z28c0nUHb7GY/2itHROe1c/3b/U6k/gdflVih/g=;
        b=c+1mgOHIZCRvo/o8y7u3us4FMkHDa+CiinJpOSPDInqg9/o1sYZjWYH8ZAK0qmV20l
         iEvxLLEWJSBJXw2keUIcXjr7t5aZ3fsuVPcsKikd05/iQMY7yDUc9J1ht16JSPxtU0Wu
         flB0VpAm/nzepHwdg49pBDp4I99rjpxMntugZrUULkvb3Pq89tKenTGqlo7ykx/XsCj8
         eyVbvDGB3qwzJxs4VvDPxujbwAUNH4DDyljDPrV/XV4VPNufPMJ015N5kvymsuOL8Ygy
         oDnWrfu/MhSjR22gYVvHPn0yr4VleHBivtUu3X/2v5RNpLn7W1pcQ5LUreRGQy4yMOGI
         4Arg==
X-Gm-Message-State: AOAM532sgCcDDcQRRUXL55R0ZsaVaLXR9aa8sr0sxZrSgrabHu3nxqFv
        ybqbWbXXqANv/de+tAiLAWywfQPZimIZvA==
X-Google-Smtp-Source: ABdhPJy2zUb7/UUhJIXgTsE1Z0DDT2YuIZXVHHznoQ3Q8rTguJyroqeynM0rWjrLCWAldxyBEox71g==
X-Received: by 2002:a17:906:4fc9:: with SMTP id i9mr1217515ejw.673.1639516230543;
        Tue, 14 Dec 2021 13:10:30 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:30 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 04/16] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
Date:   Tue, 14 Dec 2021 22:09:59 +0100
Message-Id: <20211214211011.24850-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In order for switch driver to be able to make simple and reliable use of
the master tracking operations, they must also be notified of the
initial state of the DSA master, not just of the changes. This is
because they might enable certain features only during the time when
they know that the DSA master is up and running.

Therefore, this change explicitly checks the state of the DSA master
under the same rtnl_mutex as we were holding during the
dsa_master_setup() and dsa_master_teardown() call. The idea being that
if the DSA master became operational in between the moment in which it
became a DSA master (dsa_master_setup set dev->dsa_ptr) and the moment
when we checked for the master being up, there is a chance that we
would emit a ->master_state_change() call with no actual state change.
We need to avoid that by serializing the concurrent netdevice event with
us. If the netdevice event started before, we force it to finish before
we begin, because we take rtnl_lock before making netdev_uses_dsa()
return true. So we also handle that early event and do nothing on it.
Similarly, if the dev_open() attempt is concurrent with us, it will
attempt to take the rtnl_mutex, but we're holding it. We'll see that
the master flag IFF_UP isn't set, then when we release the rtnl_mutex
we'll process the NETDEV_UP notifier.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/dsa2.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e8b56c84a417..4ab6d1df2b19 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1042,9 +1042,18 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
-			err = dsa_master_setup(dp->master, dp);
+			struct net_device *master = dp->master;
+			bool admin_up = (master->flags & IFF_UP) &&
+					!qdisc_tx_is_noop(master);
+
+			err = dsa_master_setup(master, dp);
 			if (err)
 				return err;
+
+			/* Replay master state event */
+			dsa_tree_master_admin_state_change(dst, master, admin_up);
+			dsa_tree_master_oper_state_change(dst, master,
+							  netif_oper_up(master));
 		}
 	}
 
@@ -1059,9 +1068,19 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_is_cpu(dp))
-			dsa_master_teardown(dp->master);
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dsa_port_is_cpu(dp)) {
+			struct net_device *master = dp->master;
+
+			/* Synthesizing an "admin down" state is sufficient for
+			 * the switches to get a notification if the master is
+			 * currently up and running.
+			 */
+			dsa_tree_master_admin_state_change(dst, master, false);
+
+			dsa_master_teardown(master);
+		}
+	}
 
 	rtnl_unlock();
 }
-- 
2.33.1

