Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FBD4715E4
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhLKT6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhLKT6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:21 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7B0C061714;
        Sat, 11 Dec 2021 11:58:20 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id t5so39681249edd.0;
        Sat, 11 Dec 2021 11:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MsFfAGLof3Dm9/LrR3eo50ukODDBjEJuAPZhIodAjb8=;
        b=Re+CyUucLI2B+iiJ3rdnbpMOnftYBU91S0EF1+hT+oJy9KixbmoMB0Z1L0nUkL/2a+
         tuKT6zWmh/BtVB9v7UksIZN7KO5iig3Bp29sxNhHL4goqhR6R+d4z/r8RiY69YC58CYP
         bVPHQfnEJcrXPkC0NdplKBygxDzwcO7A2Uflc+ibpG1F1wv1uzd7Cr7lmCWXNtha6mw9
         SykrxU8clWsXZVkDQvrUl37P44e++32e5QDYc2D+5/r+CQTlnhDzJ2BrtM0b4Q1E7x8o
         nTg8zxazK9cNB9Mjj24jaaTppjv3dnmB47/HLHTJKlhRpniePuBHuYEb7olqmRCJiXcW
         vf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MsFfAGLof3Dm9/LrR3eo50ukODDBjEJuAPZhIodAjb8=;
        b=mKQd75R3j90wKcXg8t3TMSpCrT7naQHw2+Bba8+xFh68TCtVO7MhHU6QWi7Bh37moT
         qsUpxucES3WJrd3K7bylCDD3VTClVJbW+GjxaJqTHioo3bjUzvITdxGU+r8DJ8AvkyaS
         nQm1Edcl8nyNH8RL6kG4zUxBiLpgFPZXg9yDMlma3eWCjqYGO3/oNIsH0N0d1a+DTgD7
         NJhqwzPTQgIuaqs81SR2dAaR4U20novFySsz0jzLnWBYZfsvjfhMlAoAzFWJrbgDPXLD
         NH2AxbVQ4rVZpQ6QFxxki/5TlvOLh+h/xGUWpPbPKKjOo4UP2BlFYp3k8qYMmvO1vkZT
         7p/A==
X-Gm-Message-State: AOAM531RrcaGR9PM6GFunAzNVPKSQbEGIr+0T0M7Z0+u5MOdc5E91HRE
        +OAhE/oStqRDK7GpaTkgqHo=
X-Google-Smtp-Source: ABdhPJxrka2bMCo4qWbLlvjnfUpfjcT4iCxh+LBcywyN5+pxf4e1wikk6ONoc7ROlLn40x/DdIEsTg==
X-Received: by 2002:a17:907:6eaa:: with SMTP id sh42mr32786789ejc.556.1639252698975;
        Sat, 11 Dec 2021 11:58:18 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:18 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 04/15] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
Date:   Sat, 11 Dec 2021 20:57:47 +0100
Message-Id: <20211211195758.28962-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
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
index 90e29dd42d3d..76cf9ee1153c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1034,9 +1034,18 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
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
 
@@ -1051,9 +1060,19 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 
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
2.32.0

