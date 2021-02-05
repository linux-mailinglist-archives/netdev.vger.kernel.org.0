Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4DD3119AB
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhBFDP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbhBFCzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:55:19 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0E9C0611C2
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:24 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id sa23so14511834ejb.0
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I0fStImX6Rzxzw2BiXqbA+G9P9WGsBPjitXdFpg5VKs=;
        b=TtCgMGVoMfaFxGBxixcDxuZNF5n0uhmyaXAKmOvNrl+V5sWknbKeZb3VoYSxDrlb2O
         4jrHlRs8nebAoOk3aHoVMs+JBs2sQcwnTwyU19bcIyCxPLwXyqtzVbldX6kPG2JF/dgh
         13nz8QnKjQS8NXUp9/CIWzbjdhEnOaJWCCPgj0o7ti/nmMU14kCYH/x/LaMHTy7DrAiT
         IyEz07jEtYFGEjIAQAYBeEDrbv/FjoduzEk6JkrDHYFSU2/dLMoc2QTb4Rv2WhWtPHfW
         Uz9ronE1Z+8ebpG/IT4pWiV1FwrVHISHDjG4akOuD55LhocjkkHmHWTTGrowKzPpFx5l
         tp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I0fStImX6Rzxzw2BiXqbA+G9P9WGsBPjitXdFpg5VKs=;
        b=uCABQjqep19t1OEMsiuHMSHinUzdAEmpF8p7SXWYw0VrtkfTVXAlFlF3ss/JJ1cjm5
         LQVeEMNIvimch2wgbgbvSPf6uzogoow1r18dMK+/LMiQOR7ut2zpfUeMmFcD8SVLGTix
         POZ+jrRq6v5t/OA6Ki0a18Qe9B9yeRwI0U7Kg50fjW47QCNJvCOMVp7FWc09xJJcorDL
         bwbhnNW7rRggLIL/lRQD3bu9Sj0QGQ0+VcoF/f7F8RT6cPrimRZoMl0WotZZZfI07a+6
         CSBJuLm8yHnJdJOiNKBtMa/squFRPFTG2cLW6m7O6SBIzxn4HjIrPsskYhEiXlKrY9n4
         Uj9w==
X-Gm-Message-State: AOAM5314NiwBL/FTFEz/J89JCfzd7oBsDItGSZQ/ht2ODVOTZwKt1iHu
        iDwnjMQyccSUh50DunC+WTc=
X-Google-Smtp-Source: ABdhPJzFXAbssa1fzqoxTdaxe5AToXzhIC6LVw4DI+bweplOc+Uopo4rsH5j6iAvvMB2UaNgJUPTng==
X-Received: by 2002:a17:907:7347:: with SMTP id dq7mr6128879ejc.385.1612562603449;
        Fri, 05 Feb 2021 14:03:23 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:22 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 11/12] net: dsa: make assisted_learning_on_cpu_port bypass offloaded LAG interfaces
Date:   Sat,  6 Feb 2021 00:02:20 +0200
Message-Id: <20210205220221.255646-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Given the following topology, and focusing only on Box A:

         Box A
         +----------------------------------+
         | Board 1         br0              |
         |             +---------+          |
         |            /           \         |
         |            |           |         |
         |            |         bond0       |
         |            |        +-----+      |
         |192.168.1.1 |       /       \     |
         |  eno0     swp0    swp1    swp2   |
         +---|--------|-------|-------|-----+
             |        |       |       |
             +--------+       |       |
               Cable          |       |
                         Cable|       |Cable
               Cable          |       |
             +--------+       |       |
             |        |       |       |
         +---|--------|-------|-------|-----+
         |  eno0     swp0    swp1    swp2   |
         |192.168.1.2 |       \       /     |
         |            |        +-----+      |
         |            |         bond0       |
         |            |           |         |
         |            \           /         |
         |             +---------+          |
         | Board 2         br0              |
         +----------------------------------+
         Box B

The assisted_learning_on_cpu_port logic will see that swp0 is bridged
with a "foreign interface" (bond0) and will therefore install all
addresses learnt by the software bridge towards bond0 (including the
address of eno0 on Box B) as static addresses towards the CPU port.

But that's not what we want - bond0 is not really a "foreign interface"
but one we can offload including L2 forwarding from/towards it. So we
need to refine our logic for assisted learning such that, whenever we
see an address learnt on a non-DSA interface, we search through the tree
for any port that offloads that non-DSA interface.

Some confusion might arise as to why we search through the whole tree
instead of just the local switch returned by dsa_slave_dev_lower_find.
Or a different angle of the same confusion: why does
dsa_slave_dev_lower_find(br_dev) return a single dp that's under br_dev
instead of the whole list of bridged DSA ports?

To answer the second question, it should be enough to install the static
FDB entry on the CPU port of a single switch in the tree, because
dsa_port_fdb_add uses DSA_NOTIFIER_FDB_ADD which ensures that all other
switches in the tree get notified of that address, and add the entry
themselves using dsa_towards_port().

This should help understand the answer to the first question: the port
returned by dsa_slave_dev_lower_find may not be on the same switch as
the ports that offload the LAG. Nonetheless, if the driver implements
.crosschip_lag_join and .crosschip_bridge_join as mv88e6xxx does, there
still isn't any reason for trapping addresses learnt on the remote LAG
towards the CPU, and we should prevent that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Patch is new and necessary due to the recent introduction of assisted
learning on the CPU port.

 net/dsa/dsa_priv.h | 13 +++++++++++++
 net/dsa/slave.c    |  8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 263593ce94a8..8a1bcb2b4208 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -209,6 +209,19 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 	return false;
 }
 
+/* Returns true if any port of this tree offloads the given net_device */
+static inline bool dsa_tree_offloads_netdev(struct dsa_switch_tree *dst,
+					    struct net_device *dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_netdev(dp, dev))
+			return true;
+
+	return false;
+}
+
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b0571ab4e5a7..e5c227e19b4a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2215,6 +2215,14 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 			if (!dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
+
+			/* When the bridge learns an address on an offloaded
+			 * LAG we don't want to send traffic to the CPU, the
+			 * other ports bridged with the LAG should be able to
+			 * autonomously forward towards it.
+			 */
+			if (dsa_tree_offloads_netdev(dp->ds->dst, dev))
+				return NOTIFY_DONE;
 		}
 
 		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
-- 
2.25.1

