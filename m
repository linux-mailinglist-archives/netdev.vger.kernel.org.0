Return-Path: <netdev+bounces-5294-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8136C710A3A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BD0B2814ED
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40AC2D512;
	Thu, 25 May 2023 10:38:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DA5D2E8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:38:52 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA9812E
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wc/7JHDm87FkAn9cNhv/7hMjF8DCt2jZdFLhs6XMNFY=; b=uygSNQ9//y/SadNhvD/KbenNTl
	N5vK3XKhoNCqZG+/fStKniyMejM2LhDIZYUccI/s8AmhWeACYtzculmnht+/cn/BB4QYeLhI1yaD7
	8daDsxDgXQgGK+Cc823RrtP1SaEnMTBO8cSwx5UTygM4x+F1m70hW67eFki5bcEit0U/2LjBTVamU
	zOPUXQGZHHlVXUPiirCccjGV0H2EEiHbA3YV6lsk35jIiK7v3Gqpr6xZs55rjq2ZQ7w10jcclCx84
	QsHN3fAK8vFxriTD24dHbQXSHusKHCbQCn8nAgr8oNbIBjMgbl+auZ0ELWYlixUExSEfcvK5ObZ7F
	xtQWW+Kg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56188 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q28Mn-0003wC-IA; Thu, 25 May 2023 11:38:45 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q28Mm-007tpp-UF; Thu, 25 May 2023 11:38:44 +0100
In-Reply-To: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
References: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: dsa: add support for mac_prepare() and
 mac_finish() calls
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q28Mm-007tpp-UF@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Thu, 25 May 2023 11:38:44 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add DSA support for the phylink mac_prepare() and mac_finish() calls.
These were introduced as part of the PCS support to allow MACs to
perform preparatory steps prior to configuration, and finalisation
steps after the MAC and PCS has been configured.

Introducing phylink_pcs support to the mv88e6xxx DSA driver needs some
code moved out of its mac_config() stage into the mac_prepare() and
mac_finish() stages, and this commit facilitates such code in DSA
drivers.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/net/dsa.h |  6 ++++++
 net/dsa/port.c    | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8903053fa5aa..75022cf771cf 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -867,9 +867,15 @@ struct dsa_switch_ops {
 						      phy_interface_t iface);
 	int	(*phylink_mac_link_state)(struct dsa_switch *ds, int port,
 					  struct phylink_link_state *state);
+	int	(*phylink_mac_prepare)(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       phy_interface_t interface);
 	void	(*phylink_mac_config)(struct dsa_switch *ds, int port,
 				      unsigned int mode,
 				      const struct phylink_link_state *state);
+	int	(*phylink_mac_finish)(struct dsa_switch *ds, int port,
+				      unsigned int mode,
+				      phy_interface_t interface);
 	void	(*phylink_mac_an_restart)(struct dsa_switch *ds, int port);
 	void	(*phylink_mac_link_down)(struct dsa_switch *ds, int port,
 					 unsigned int mode,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 71ba30538411..0ce8fd311c78 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1603,6 +1603,21 @@ dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
 	return pcs;
 }
 
+static int dsa_port_phylink_mac_prepare(struct phylink_config *config,
+					unsigned int mode,
+					phy_interface_t interface)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+	int err = 0;
+
+	if (ds->ops->phylink_mac_prepare)
+		err = ds->ops->phylink_mac_prepare(ds, dp->index, mode,
+						   interface);
+
+	return err;
+}
+
 static void dsa_port_phylink_mac_config(struct phylink_config *config,
 					unsigned int mode,
 					const struct phylink_link_state *state)
@@ -1616,6 +1631,21 @@ static void dsa_port_phylink_mac_config(struct phylink_config *config,
 	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
 }
 
+static int dsa_port_phylink_mac_finish(struct phylink_config *config,
+				       unsigned int mode,
+				       phy_interface_t interface)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+	int err = 0;
+
+	if (ds->ops->phylink_mac_finish)
+		err = ds->ops->phylink_mac_finish(ds, dp->index, mode,
+						  interface);
+
+	return err;
+}
+
 static void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
@@ -1671,7 +1701,9 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.validate = dsa_port_phylink_validate,
 	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
 	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
+	.mac_prepare = dsa_port_phylink_mac_prepare,
 	.mac_config = dsa_port_phylink_mac_config,
+	.mac_finish = dsa_port_phylink_mac_finish,
 	.mac_an_restart = dsa_port_phylink_mac_an_restart,
 	.mac_link_down = dsa_port_phylink_mac_link_down,
 	.mac_link_up = dsa_port_phylink_mac_link_up,
-- 
2.30.2


