Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC5D3368DC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCKAgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:47 -0500
Received: from correo.us.es ([193.147.175.20]:50066 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhCKAgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B77512E831
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D4D3DA78C
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 523E7DA789; Thu, 11 Mar 2021 01:36:18 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B667DA722;
        Thu, 11 Mar 2021 01:36:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CCCEA42DC6E2;
        Thu, 11 Mar 2021 01:36:15 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 06/23] net: dsa: resolve forwarding path for dsa slave ports
Date:   Thu, 11 Mar 2021 01:35:47 +0100
Message-Id: <20210311003604.22199-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Add .ndo_fill_forward_path for dsa slave port devices

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h |  5 +++++
 net/dsa/slave.c           | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c8917eb1adac..d9c88962fa13 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -836,6 +836,7 @@ enum net_device_path_type {
 	DEV_PATH_VLAN,
 	DEV_PATH_BRIDGE,
 	DEV_PATH_PPPOE,
+	DEV_PATH_DSA,
 };
 
 struct net_device_path {
@@ -856,6 +857,10 @@ struct net_device_path {
 			u16		vlan_id;
 			__be16		vlan_proto;
 		} bridge;
+		struct {
+			int port;
+			u16 proto;
+		} dsa;
 	};
 };
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..df7d789236fe 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1654,6 +1654,21 @@ static void dsa_slave_get_stats64(struct net_device *dev,
 		dev_get_tstats64(dev, s);
 }
 
+static int dsa_slave_fill_forward_path(struct net_device_path_ctx *ctx,
+				       struct net_device_path *path)
+{
+	struct dsa_port *dp = dsa_slave_to_port(ctx->dev);
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+
+	path->dev = ctx->dev;
+	path->type = DEV_PATH_DSA;
+	path->dsa.proto = cpu_dp->tag_ops->proto;
+	path->dsa.port = dp->index;
+	ctx->dev = cpu_dp->master;
+
+	return 0;
+}
+
 static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_open	 	= dsa_slave_open,
 	.ndo_stop		= dsa_slave_close,
@@ -1679,6 +1694,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
 	.ndo_get_devlink_port	= dsa_slave_get_devlink_port,
 	.ndo_change_mtu		= dsa_slave_change_mtu,
+	.ndo_fill_forward_path	= dsa_slave_fill_forward_path,
 };
 
 static struct device_type dsa_type = {
-- 
2.20.1

