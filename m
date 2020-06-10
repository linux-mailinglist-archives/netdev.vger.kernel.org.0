Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F691F5066
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 10:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgFJIiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 04:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgFJIiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 04:38:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D7EC03E96F
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 01:38:03 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jiwF5-0000Il-SU; Wed, 10 Jun 2020 10:37:51 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jiwF2-0003Ir-R7; Wed, 10 Jun 2020 10:37:48 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH v4 3/3] netlink: add LINKSTATE SQI support
Date:   Wed, 10 Jun 2020 10:37:44 +0200
Message-Id: <20200610083744.21322-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200610083744.21322-1-o.rempel@pengutronix.de>
References: <20200610083744.21322-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs provide Signal Quality Index (SQI) if the link is in active
state. This information can help to diagnose cable and system design
related issues.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/desc-ethtool.c |  2 ++
 netlink/settings.c     | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 00e6982..98b898e 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -93,6 +93,8 @@ static const struct pretty_nla_desc __linkstate_desc[] = {
 	NLATTR_DESC_INVALID(ETHTOOL_A_LINKSTATE_UNSPEC),
 	NLATTR_DESC_NESTED(ETHTOOL_A_LINKSTATE_HEADER, header),
 	NLATTR_DESC_BOOL(ETHTOOL_A_LINKSTATE_LINK),
+	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI),
+	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI_MAX),
 };
 
 static const struct pretty_nla_desc __debug_desc[] = {
diff --git a/netlink/settings.c b/netlink/settings.c
index 60e2c41..35ba2f5 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -627,6 +627,22 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		printf("\tLink detected: %s\n", val ? "yes" : "no");
 	}
 
+	if (tb[ETHTOOL_A_LINKSTATE_SQI]) {
+		uint32_t val = mnl_attr_get_u32(tb[ETHTOOL_A_LINKSTATE_SQI]);
+
+		print_banner(nlctx);
+		printf("\tSQI: %u", val);
+
+		if (tb[ETHTOOL_A_LINKSTATE_SQI_MAX]) {
+			uint32_t max;
+
+			max = mnl_attr_get_u32(tb[ETHTOOL_A_LINKSTATE_SQI_MAX]);
+			printf("/%u\n", max);
+		} else {
+			printf("\n");
+		}
+	}
+
 	return MNL_CB_OK;
 }
 
-- 
2.27.0

