Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC9F346EDD
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhCXBcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbhCXBbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8B0AC061763;
        Tue, 23 Mar 2021 18:31:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8954B62C0E;
        Wed, 24 Mar 2021 02:31:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 20/24] dsa: slave: add support for TC_SETUP_FT
Date:   Wed, 24 Mar 2021 02:30:51 +0100
Message-Id: <20210324013055.5619-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa infrastructure provides a well-defined hierarchy of devices,
pass up the call to set up the flow block to the master device. From the
software dataplane, the netfilter infrastructure uses the dsa slave
devices to refer to the input and output device for the given skbuff.
Similarly, the flowtable definition in the ruleset refers to the dsa
slave port devices.

This patch adds the glue code to call ndo_setup_tc with TC_SETUP_FT
with the master device via the dsa slave devices.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 net/dsa/slave.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index df7d789236fe..d84162fe028a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1278,14 +1278,32 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 	}
 }
 
+static int dsa_slave_setup_ft_block(struct dsa_switch *ds, int port,
+				    void *type_data)
+{
+	struct dsa_port *cpu_dp = dsa_to_port(ds, port)->cpu_dp;
+	struct net_device *master = cpu_dp->master;
+
+	if (!master->netdev_ops->ndo_setup_tc)
+		return -EOPNOTSUPP;
+
+	return master->netdev_ops->ndo_setup_tc(master, TC_SETUP_FT, type_data);
+}
+
 static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct dsa_switch *ds = dp->ds;
 
-	if (type == TC_SETUP_BLOCK)
+	switch (type) {
+	case TC_SETUP_BLOCK:
 		return dsa_slave_setup_tc_block(dev, type_data);
+	case TC_SETUP_FT:
+		return dsa_slave_setup_ft_block(ds, dp->index, type_data);
+	default:
+		break;
+	}
 
 	if (!ds->ops->port_setup_tc)
 		return -EOPNOTSUPP;
-- 
2.20.1

