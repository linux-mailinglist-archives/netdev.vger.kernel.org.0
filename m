Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076BC323B79
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbhBXLtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhBXLqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:46:48 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46595C061221
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:21 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id cf12so1257559edb.8
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HQkwNThB5BeeMrrVMwihs6Hz2oUsXRz+N8B9BmewocY=;
        b=RwTlGI862OnKvrf/WOh1L3TWqjal8eCOF0PJN4bV6HspV+Zmy2RqdrmNfrDy/4QXJZ
         AeqP7urq8/lR7EwhOQOICt/Vypl/rs+QZLQ4rorxSxqaB8xyxNFT8fbsrhpMI+gJRR/4
         W9vTaAUtmg8VTLMktWnp7wSELY8UpCMBEv6HdT/V6P+ffFXqBFptF7RB/DrsofoXBLRy
         HQ7MAHLKm1EkYsEikP62lpwA01q0aW7GliMQsJAjRRuqGiiEFGynOMz6SXO7DN7Y1WBH
         4WqC8iX29KC3j+/Ksb/rebf+rnYIR5V04jKST7CJ3x2ZOwEEafjufGJvqVy2e2q3s90p
         3PpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HQkwNThB5BeeMrrVMwihs6Hz2oUsXRz+N8B9BmewocY=;
        b=UFO8W1rawG7CHORZa/voVvxSEyZmj4iN7INzohGTlScAU3y9gnTcraG3K9olW6iEiR
         3RKVV2lYUGDm90L8hiXDHb3oggKKe7Vk2C1bQLn4dZIyDfz2NQPUXeq4CxJ3A+0eD3ln
         bBi/uuMzbCxmc2ntDWWKiMtQEm8E7JYifLCa2lzWlQpwSjd5K7Fatv+UanSeX/6VjNWO
         3SVbVHjp8l5CQuOMX4oFhc1M9tup91B6I0FOzNcidPVxlPRG6EKKVPDHQO6DXzZ2J8Un
         8GoTM2lWXWt+6/UIOJh9MRZn/JecPuFou91MbZkaRMvMTDTY78op9BsgF+PeByoBXKrl
         zLzw==
X-Gm-Message-State: AOAM533tC+uQbSl/jfzJidZJ9laK397E4qszhM231gUwRBlw5JoBX6yT
        UJUdOpc2Bhzplzbsj7fO7Qvn5N0CmWM=
X-Google-Smtp-Source: ABdhPJzWQoemeYVM9OuVHp7q+VyYPiPdwYC886tu8eNLCzjQ/p2EBqb9Zf3Lol+Xl4esTlnIS3XQdQ==
X-Received: by 2002:aa7:d2c4:: with SMTP id k4mr15363095edr.237.1614167059780;
        Wed, 24 Feb 2021 03:44:19 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 17/17] net: bridge: offloaded ports are always promiscuous
Date:   Wed, 24 Feb 2021 13:43:50 +0200
Message-Id: <20210224114350.2791260-18-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Automatic bridge ports are ones with source address learning or unicast
flooding enabled (corollary: non-automatic ports have learning and
flooding disabled).

The bridge driver has an optimization which says that if all ports are
non-automatic, they don't need to operate in promiscuous mode (i.e. they
don't need to receive all packets). Instead, if a non-automatic port
supports unicast filtering, it can be made to receive only the packets
which have a static FDB entry towards another port in the same forwarding
domain. The logic is that, if a packet is received and does not have a
static FDB entry for routing, it would be dropped anyway because all the
other ports have flooding disabled. So it makes sense to not accept the
packet on RX in the first place.

When a non-automatic port switches to non-promiscuous mode, the static
FDB entries towards the other bridge ports are synced to the RX filtering
list of this ingress port using dev_uc_add.

However, this optimization doesn't bring any benefit for switchdev ports
that offload the bridge. Their hardware data path is promiscuous by its
very definition, i.e. they accept packets regardless of destination MAC
address, because they need to forward them towards the correct station.

Not only is the optimization not necessary, it is also detrimential.
The promise of switchdev is that it looks just like a regular interface
to user space, and it offers extra offloading functionality for stacked
virtual interfaces that can benefit from it. Therefore, it is imaginable
that a switchdev driver might want to implement IFF_UNICAST_FLT too.
When not offloading the bridge, a switchdev interface should really be
indistinguishable from a normal port from user space's perspective,
which means that addresses installed with dev_uc_add and dev_mc_add
should be accepted, and those which aren't should be dropped.

So a switchdev driver might implement dev_uc_add and dev_mc_add by
extracting these addresses from the hardware data path and delivering
them to the CPU, and drop the rest by disabling flooding to the CPU,
and this makes perfect sense when there is no bridge involved on top.

However, things get complicated when the bridge ports are non-automatic
and enter non-promiscuous mode. The bridge will then panic 'oh no, I
need to do something in order for my packets to not get dropped', and
will do the dev_uc_add procedure mentioned above. This will result in
the undesirable behavior that the switchdev driver will extract those
MAC addresses to the CPU, when in fact all that the bridge wanted was
for the packets to not be dropped.

To avoid this situation, the switchdev driver would need to conditionally
accept an address added through dev_uc_add and extract it to the CPU
only if it wasn't added by the bridge, which is both complicated,
strange and counterproductive. It is already unfortunate enough that the
bridge uses its own notification mechanisms for addresses which need to
be extracted (SWITCHDEV_OBJ_ID_HOST_MDB, SWITCHDEV_FDB_ADD_TO_DEVICE
with dev=br0). It shouldn't monopolize the switchdev driver's
functionality and instead it should allow it to offer its services to
other layers which are unaware of switchdev.

So this patch's premise is that the bridge, which is fully aware of
switchdev anyway, is the one that needs to compromise, and must not do
something which isn't needed if switchdev is being used to offload a
port. This way, dev_uc_add and dev_mc_add can be used as a valid mechanism
for address filtering towards the CPU requested by switchdev-unaware
layers ('towards the CPU' because switchdev-unaware will not benefit
from the hardware offload datapath anyway, that's effectively the only
destination which is relevant for them).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 680fc3bed549..fc32066bbfdc 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -111,9 +111,13 @@ static void br_port_clear_promisc(struct net_bridge_port *p)
 	/* Check if the port is already non-promisc or if it doesn't
 	 * support UNICAST filtering.  Without unicast filtering support
 	 * we'll end up re-enabling promisc mode anyway, so just check for
-	 * it here.
+	 * it here. Also, a switchdev offloading this port needs to be
+	 * promiscuous by definition, so don't even attempt to get it out of
+	 * promiscuous mode or sync unicast FDB entries to it, since that is
+	 * pointless and not necessary.
 	 */
-	if (!br_promisc_port(p) || !(p->dev->priv_flags & IFF_UNICAST_FLT))
+	if (!br_promisc_port(p) || !(p->dev->priv_flags & IFF_UNICAST_FLT) ||
+	    p->offloaded)
 		return;
 
 	/* Since we'll be clearing the promisc mode, program the port
-- 
2.25.1

