Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091603B53A3
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhF0ONI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbhF0ONA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:13:00 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6838FC061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:35 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r7so21173637edv.12
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cOcrEyVseqjoteqwx/PlBKbx2ck6ms2QqjNCJLmGW94=;
        b=l3MadUDTBvY9SxLpVvnPZ8uXYruwzwaheEIlvPu0r/+zHemFfbCB5XDLLkhk+OFqsk
         VvfrIsuEk4ayMD1KQ4uck6QxJTcyHM2lcPSCyNCMvwjdIefhTsMf8vrE1ue8kR0coZRH
         d2+SYwqJjE+fPzUpbxIHrLJNyYBsyaqRAwnt2S76ri6k+67SJFLgeFQogK/696GbA5Ka
         WzEgaSrBViKIB+gcR0AS+KVpYoC8jIHIPW429VjzA56GBrTx6i7QLdQdEHekVTp6VFO2
         gx8JqcBw1Uxtia8XtNvIL0JVZjqacJZXEssgIwHZeE1ePAPSsILJMnmDbRiQ4jD8XMXP
         pP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cOcrEyVseqjoteqwx/PlBKbx2ck6ms2QqjNCJLmGW94=;
        b=O7mZXZG8owld0aG6Vmh6LYOTbdSmqTtom5Z4D4UzQg3tc2V/akdcU0iVaEbSeiYPLu
         X7NcNMKvGltv6IdKPMLMfsC3cWgt9OQu3hIj7g9jj4UC855ZC/xxZ6BChHA72S9futXm
         XPFxPpsiJnTJO1ogR3fys5ZMk6O+QSXs4vZAOwaA6UvyW1Pcrcc+TufDRPuPrBLTI2vH
         uWF+vOIgOKPjLJUM5+qyLbmF+M+Gol/mQxUmBIfu6emy6mmifRALviIqiGvloHNU46mW
         WFbtG4jJi7FL412qcbXirwv6sXKXvV23YizwEAnsezxSJUfhtCFkh0SS86NIR2i3AdBv
         9DTQ==
X-Gm-Message-State: AOAM531EmFUwk0XNF0O/XlknPSguHkxDpvt3wNkjlyyBNbsMv7FAOUaQ
        wh0UZ0QUaIfv81X3kxCfRSfHoOgpMfM=
X-Google-Smtp-Source: ABdhPJwglX3r1WBgwoH6cnnKq5Rb/eyk3NAN/GPpq2XJByL0Z76esp7jtZXBmZ8nxg9WXSPTmQJrtA==
X-Received: by 2002:aa7:de90:: with SMTP id j16mr27346327edv.385.1624803033912;
        Sun, 27 Jun 2021 07:10:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v3 net-next 11/15] net: dsa: sync static FDB entries on foreign interfaces to hardware
Date:   Sun, 27 Jun 2021 17:10:09 +0300
Message-Id: <20210627141013.1273942-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Reuse the "assisted_learning_on_cpu_port" functionality to always add
entries for user-configured entries on foreign interfaces, even if
assisted_learning_on_cpu_port is not enabled. E.g. in this situation:

   br0
   / \
swp0 dummy0

$ bridge fdb add 02:00:de:ad:00:01 dev dummy0 vlan 1 master static

Results in DSA adding an entry in the hardware FDB, pointing this
address towards the CPU port.

The same is true for entries added to the bridge itself, e.g:

$ bridge fdb add 02:00:de:ad:00:01 dev br0 vlan 1 self local

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ac7f4f200ab1..ea9a7c1ce83e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2403,9 +2403,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 			dp = dsa_slave_to_port(dev);
 		} else {
-			/* Snoop addresses learnt on foreign interfaces
-			 * bridged with us, for switches that don't
-			 * automatically learn SA from CPU-injected traffic
+			/* Snoop addresses added to foreign interfaces
+			 * bridged with us, or the bridge
+			 * itself. Dynamically learned addresses can
+			 * also be added for switches that don't
+			 * automatically learn SA from CPU-injected
+			 * traffic.
 			 */
 			struct net_device *br_dev;
 			struct dsa_slave_priv *p;
@@ -2424,7 +2427,8 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			dp = p->dp;
 			host_addr = true;
 
-			if (!dp->ds->assisted_learning_on_cpu_port)
+			if (!fdb_info->added_by_user &&
+			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 
 			/* When the bridge learns an address on an offloaded
-- 
2.25.1

