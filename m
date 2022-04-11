Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5494FBCD7
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243841AbiDKNPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiDKNPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:15:16 -0400
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Apr 2022 06:12:58 PDT
Received: from mta-65-225.siemens.flowmailer.net (mta-65-225.siemens.flowmailer.net [185.136.65.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127E2377EA
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:12:57 -0700 (PDT)
Received: by mta-65-225.siemens.flowmailer.net with ESMTPSA id 202204111311538ed5875bd931299bb9
        for <netdev@vger.kernel.org>;
        Mon, 11 Apr 2022 15:11:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=erez.geva.ext@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=Jej9+340rXVhWy0o7hYptBIUCXOA6CDcx/KqAacyO64=;
 b=EGtaiJqorIyCJdZBNFxHSFDQKmOkdXRXo1ydme026pJ54OJzWII/M2J1MGkI8ibzr+ZyLH
 ZWf7NAeeXAoSw8d6wyE78PBLghBIpSmQwWUdLWuwwM9VBs/UTogIuoe0blPOiYbWz61eKq2g
 GEoK07+7cThcRJEVNfUO+/gXgY8PI=;
From:   Erez Geva <erez.geva.ext@siemens.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>
Subject: [PATCH 1/1] DSA Add callback to traffic control information
Date:   Mon, 11 Apr 2022 15:11:48 +0200
Message-Id: <20220411131148.532520-2-erez.geva.ext@siemens.com>
In-Reply-To: <20220411131148.532520-1-erez.geva.ext@siemens.com>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-118190:519-21489:flowmailer
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a callback for the DSA tag driver
 to fetch information regarding a traffic control.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 include/net/dsa.h  |  2 ++
 net/dsa/dsa_priv.h |  1 +
 net/dsa/slave.c    | 17 +++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 934958fda962..ab8f0988bcfc 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1036,6 +1036,8 @@ struct dsa_switch_ops {
 	void	(*port_policer_del)(struct dsa_switch *ds, int port);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
+	int	(*port_fetch_tc)(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type, void *type_data);
 
 	/*
 	 * Cross-chip operations
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 5d3f4a67dce1..d03c23680a50 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -320,6 +320,7 @@ void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
+int dsa_slave_fetch_tc(struct net_device *dev, enum tc_setup_type type, void *type_data);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 41c69a6e7854..0db7b99b06f9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1535,6 +1535,23 @@ static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
 }
 
+/* Allow TAG driver to retrieve TC information from a DSA switch driver.
+ * Some TC require the TAG driver to pass information from the SKB into the TAG
+ * depending on the TC configuratin set used with port_setup_tc() callback.
+ * Though only the driver can know the proper value.
+ */
+int dsa_slave_fetch_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_fetch_tc)
+		return -EOPNOTSUPP;
+
+	return ds->ops->port_fetch_tc(ds, dp->index, type, type_data);
+}
+EXPORT_SYMBOL_GPL(dsa_slave_fetch_tc);
+
 static int dsa_slave_get_rxnfc(struct net_device *dev,
 			       struct ethtool_rxnfc *nfc, u32 *rule_locs)
 {
-- 
2.30.2

