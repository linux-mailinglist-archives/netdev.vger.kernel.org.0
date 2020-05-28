Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440721E5EBF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 13:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388576AbgE1Lyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388563AbgE1Lyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 07:54:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BC4C08C5C5
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 04:54:31 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jeH77-0003bQ-PA; Thu, 28 May 2020 13:54:21 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jeH74-00031C-8Z; Thu, 28 May 2020 13:54:18 +0200
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
Subject: [PATCH v2 3/3] netlink: add LINKSTATE SQI support
Date:   Thu, 28 May 2020 13:54:14 +0200
Message-Id: <20200528115414.11516-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528115414.11516-1-o.rempel@pengutronix.de>
References: <20200528115414.11516-1-o.rempel@pengutronix.de>
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
---
 netlink/desc-ethtool.c |  2 ++
 netlink/settings.c     | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index b0a793c..8f4c36b 100644
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
index 851de15..cd4b9a7 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -638,6 +638,22 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
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
2.26.2

