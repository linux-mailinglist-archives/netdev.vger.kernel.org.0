Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A12A4313A3
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhJRJms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhJRJmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:42:44 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12286C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:33 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d9so68293304edh.5
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SYW9s3lVZC5aslSNOtbi0Ys8bvQWIz/CC1qr0VatBQ8=;
        b=K/82oRz+IhhAG5QFa/4yLJrsdh50lrTFay7dQvzxHBqF0tOcpUznQS19WaAYvP+5/W
         JFBusAse6+hlhZgjn9jKCQ7NP8C4HLVxzdhIH015eHPVx3ZVJ2XIsWtyK+HBWuJKzfKH
         ShaioUGFdMYt3nGnmD+e1RAg4vtfCnJA1VAV4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SYW9s3lVZC5aslSNOtbi0Ys8bvQWIz/CC1qr0VatBQ8=;
        b=RVMXKMgVdPC1Qscev2wNPBr+oOxKXclL871ePZjPHFZEyDiX0IWi2OnifoMwKLtzQE
         zkyITrVISz8jMCoHdVRYoqShelNRk1HdPuinFLXa0VOn6vMlHW3w7Z4Rq33r+StwQi8s
         lq1pSLuE85WPXCXBgzQ1FOLPVv9LyYVPuSQzk8sq6AWTgkKZf12MwiYfAUWdo1/I5mJb
         Vqn7QjP/liNNP4IpU6+OBsqKMkvLLuDwm5FV0CbuCTyX1H6oM9ExIRh87WFNj8E3TayK
         b2tmMc9xp8VVpIBdeeMQwO4+jIkGAxOLF999NM/KMAM09wcsBBSpQ7D2B6YEHIIUUQPn
         O3cg==
X-Gm-Message-State: AOAM533ZSyE2e1Y9LmNWIzX5kXgmP4IuDX4ECRoNCjPjcXIBWJlEePeG
        uBODuyKriZ4tYPRGH0ebYxZZSw==
X-Google-Smtp-Source: ABdhPJzIRDsQVA+/fo9tOySnDd1zqUCmK0lHzjvm4QXY8Z1r2ejJIIdurxoVE1Gci7J6MGfhXxf6JQ==
X-Received: by 2002:a50:e041:: with SMTP id g1mr43184238edl.4.1634550030783;
        Mon, 18 Oct 2021 02:40:30 -0700 (PDT)
Received: from capella.. ([80.208.66.147])
        by smtp.gmail.com with ESMTPSA id z1sm10134566edc.68.2021.10.18.02.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:40:30 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     arinc.unal@arinc9.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 2/7] net: dsa: allow reporting of standard ethtool stats for slave devices
Date:   Mon, 18 Oct 2021 11:37:57 +0200
Message-Id: <20211018093804.3115191-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018093804.3115191-1-alvin@pqrs.dk>
References: <20211018093804.3115191-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Jakub pointed out that we have a new ethtool API for reporting device
statistics in a standardized way, via .get_eth_{phy,mac,ctrl}_stats.
Add a small amount of plumbing to allow DSA drivers to take advantage of
this when exposing statistics.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---

v3 -> v4: no change

v2 -> v3: this patch is new

 include/net/dsa.h |  6 ++++++
 net/dsa/slave.c   | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d784e76113b8..8fefd58ced8f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -645,6 +645,12 @@ struct dsa_switch_ops {
 	int	(*get_sset_count)(struct dsa_switch *ds, int port, int sset);
 	void	(*get_ethtool_phy_stats)(struct dsa_switch *ds,
 					 int port, uint64_t *data);
+	void	(*get_eth_phy_stats)(struct dsa_switch *ds, int port,
+				     struct ethtool_eth_phy_stats *phy_stats);
+	void	(*get_eth_mac_stats)(struct dsa_switch *ds, int port,
+				     struct ethtool_eth_mac_stats *mac_stats);
+	void	(*get_eth_ctrl_stats)(struct dsa_switch *ds, int port,
+				      struct ethtool_eth_ctrl_stats *ctrl_stats);
 	void	(*get_stats64)(struct dsa_switch *ds, int port,
 				   struct rtnl_link_stats64 *s);
 	void	(*self_test)(struct dsa_switch *ds, int port,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 11ec9e689589..499f8d18c76d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -789,6 +789,37 @@ static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
 	return -EOPNOTSUPP;
 }
 
+static void dsa_slave_get_eth_phy_stats(struct net_device *dev,
+					struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_eth_phy_stats)
+		ds->ops->get_eth_phy_stats(ds, dp->index, phy_stats);
+}
+
+static void dsa_slave_get_eth_mac_stats(struct net_device *dev,
+					struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_eth_mac_stats)
+		ds->ops->get_eth_mac_stats(ds, dp->index, mac_stats);
+}
+
+static void
+dsa_slave_get_eth_ctrl_stats(struct net_device *dev,
+			     struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_eth_ctrl_stats)
+		ds->ops->get_eth_ctrl_stats(ds, dp->index, ctrl_stats);
+}
+
 static void dsa_slave_net_selftest(struct net_device *ndev,
 				   struct ethtool_test *etest, u64 *buf)
 {
@@ -1695,6 +1726,9 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_strings		= dsa_slave_get_strings,
 	.get_ethtool_stats	= dsa_slave_get_ethtool_stats,
 	.get_sset_count		= dsa_slave_get_sset_count,
+	.get_eth_phy_stats	= dsa_slave_get_eth_phy_stats,
+	.get_eth_mac_stats	= dsa_slave_get_eth_mac_stats,
+	.get_eth_ctrl_stats	= dsa_slave_get_eth_ctrl_stats,
 	.set_wol		= dsa_slave_set_wol,
 	.get_wol		= dsa_slave_get_wol,
 	.set_eee		= dsa_slave_set_eee,
-- 
2.32.0

