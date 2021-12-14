Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D81474E10
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhLNWof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbhLNWo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:27 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1B6C06173F;
        Tue, 14 Dec 2021 14:44:27 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z7so7059857edc.11;
        Tue, 14 Dec 2021 14:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dfo2Z28c0nUHb7GY/2itHROe1c/3b/U6k/gdflVih/g=;
        b=eQJhItNfKrQiPUeX1ELNgLGAHHcXIkd114eTAA2bzzIVrfxjWOV7xiLy+wgHp7ey+n
         kz35SXhVLXxR9RChbzoH2PlxwDZmzYmOTjhz3i2Q6RBXdda4WH1F90TNdxTOEsjTcPDe
         ptS3O+MAdNz12bNYGD+ZSl4PUPDDC6MbdZZfYAboqKjj3WsgyvgSDJvK3/RWV3MgJTR+
         YkHUFsVnvDGW8poIqTcqnXhRQiVKIAP3WfyuRQUZClMyKmeD80XznK2ZdAGy++8sKvy2
         z6LV7xfsvevsNzD5bf3foFd+qQnlbQHjDU+B4UFpIzpDkK7BIJ2OOPGRngiGNvDWB28K
         0bAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfo2Z28c0nUHb7GY/2itHROe1c/3b/U6k/gdflVih/g=;
        b=FGmVitYP3T/X932LeanV7QUaNj5b3Nvf+ytrhHsMYutYpZkBS6nx1au4oOXgzSDT2y
         4PbbziA5tfViMLgIs8ml+WGupLN8GPFVJfyxrTsZ6rBED0swvk+AwxIB+kKQtd0O8gCb
         Ej0AV4YDqL45o4UIlTVqCDXR6KLpMg7WBOBj1Q3NxfTR7MBb3PuZOFKRcUIyVpNOCBDb
         uM/BPlV/qLjBoESz+Tt+YIop8VQoaXMeaARHWKxMMbBL4mdIALRF0h6uL8glgiHJm2nm
         4U1Q5n2PFYb8r0x/RY0FhRVauVODs2j6KXO+MZ0MvrLXlQbhd0BfceNVMB1jBKCXWo0z
         cb9g==
X-Gm-Message-State: AOAM532ipOgAWV5MeopaPZAXX/xPvrCqZ29W37KlSrLurDOOjMTnYYqa
        uY/cazImBFowoGaO+SxQnEkF2x7WEGeLTQ==
X-Google-Smtp-Source: ABdhPJzrM6giJ5DgBtTgxUZO/Q1O6vFwIsDhEofqQ2aehe8zE/OVSjmZ7e5N1vLsiUXzqdR7zRrsiA==
X-Received: by 2002:a17:906:6c96:: with SMTP id s22mr3096ejr.756.1639521865603;
        Tue, 14 Dec 2021 14:44:25 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:25 -0800 (PST)
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
Subject: [net-next PATCH RFC v6 04/16] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
Date:   Tue, 14 Dec 2021 23:43:57 +0100
Message-Id: <20211214224409.5770-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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

