Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB317224D70
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 20:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgGRSEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 14:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgGRSEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 14:04:30 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C1C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 11:04:29 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id by13so10027041edb.11
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 11:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uHctHcdFVUIiHBUjUg+99B0uMZplSViClu/YmvfI/yY=;
        b=WKAExDELAk/K93cvx5Z00s0Em1lWNkt4oconvihAH9QXdPxhndy6B3qhlAWRx0imrS
         JFSOivXBuQBrIanlc6Qf8ejGeLXPZIk8O9r2QDiZDzqoM8s6BYjdJ5e1fxY3RcBpl5Xh
         p2jXpvdOUT1rWdqGwghpnOPSAjpHXWtioJZGXjxlDJ1l60z3zQ8hktvaDdBqhaE3YX/A
         zSB30mWC8U9huvvrt1Gnff8ARTZKth8BY1M++HWhacNzAs+Q/fLg2QkyrKooEo9cCHL+
         PDl5K+y6SpoIeP23s20SOPLV2pnzIkjejdPDtMC06lOPprn3Y8efDonBKYY+jTXRxZJO
         g+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uHctHcdFVUIiHBUjUg+99B0uMZplSViClu/YmvfI/yY=;
        b=pHaK1tPK+WfYDg85EM3mmlO4tdH02YLv6GaWe+dGptx14t5WKTIvC5cgtDOw7n7lIb
         HmvzGFy5oLwBRXeaAZDbyoFKRyH9GjkN0yT2VebymeRr90PRg6owW3Zb8pYKe7GDBSUT
         ZRyCNP1GbOsp9B0vMDJ/mR1ogYtgfdFclX5CAjEqmE2PfmOzjELQQTcKQB9ZsIrsAQVV
         /nTqnvEHKzyea0ksAmplPqpWcgvHKmV2qOPCjs+2kAkk7tXTIRwXp2CvtsD+uQ7nRq+D
         ZK4ufrFVrx7F38WQqKEQMucGrm6bgS3gfBEKWiinY4ec0DoKzSBVmjzKdG80CvBydwKq
         UqUw==
X-Gm-Message-State: AOAM533VIvEI2fWc70GLodlC+gBDYVz5tWiwvuVDtpc0T/cRRAC307D2
        BwD2N6FoQFRSgfuxDvZRLYA=
X-Google-Smtp-Source: ABdhPJxSSC+FQAq6T3sE/vVesbdc4eMICkFn17zRgWO54YTVD89tPVVyrVVtBaOh9FZoPLqULPxIfw==
X-Received: by 2002:aa7:c3d8:: with SMTP id l24mr14150437edr.97.1595095468521;
        Sat, 18 Jul 2020 11:04:28 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id d24sm11132818eje.21.2020.07.18.11.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 11:04:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        noodles@earth.li, mnhagan88@gmail.com
Subject: [PATCH net-next] net: dsa: use the ETH_MIN_MTU and ETH_DATA_LEN default values
Date:   Sat, 18 Jul 2020 21:04:18 +0300
Message-Id: <20200718180418.255098-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that DSA supports MTU configuration, undo the effects of commit
8b1efc0f83f1 ("net: remove MTU limits on a few ether_setup callers") and
let DSA interfaces use the default min_mtu and max_mtu specified by
ether_setup(). This is more important for min_mtu: since DSA is
Ethernet, the minimum MTU is the same as of any other Ethernet
interface, and definitely not zero. For the max_mtu, we have a callback
through which drivers can override that, if they want to.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3856a5788e39..58412a664b98 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1940,11 +1940,8 @@ int dsa_slave_create(struct dsa_port *port)
 	if (ds->ops->port_fdb_add && ds->ops->port_egress_floods)
 		slave_dev->priv_flags |= IFF_UNICAST_FLT;
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
-	slave_dev->min_mtu = 0;
 	if (ds->ops->port_max_mtu)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
-	else
-		slave_dev->max_mtu = ETH_MAX_MTU;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 	vlan_dev_ivdf_set(slave_dev, true);
 
-- 
2.25.1

