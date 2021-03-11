Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191DD3368F7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCKAg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:58 -0500
Received: from correo.us.es ([193.147.175.20]:50148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhCKAg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ABF4B12E82F
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FD9DDA791
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 952ACDA78D; Thu, 11 Mar 2021 01:36:28 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4ADEDDA72F;
        Thu, 11 Mar 2021 01:36:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1648642DC6E2;
        Thu, 11 Mar 2021 01:36:26 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 20/23] dsa: slave: add support for TC_SETUP_FT
Date:   Thu, 11 Mar 2021 01:36:01 +0100
Message-Id: <20210311003604.22199-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
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

