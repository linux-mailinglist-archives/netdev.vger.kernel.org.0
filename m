Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91881493E82
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 17:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356212AbiASQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 11:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiASQpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 11:45:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D03C061574;
        Wed, 19 Jan 2022 08:45:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2057DB819A7;
        Wed, 19 Jan 2022 16:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FBAC004E1;
        Wed, 19 Jan 2022 16:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642610700;
        bh=eh6y5B9q6FX57v8HHKlT0unobKvzhzmWzWVnc3CQgZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=hp9frS6yq+bfymbf5LVj1/0AiVOlwhPJzK+qhCTFOfT/gGw5+0hb5ewMnXdOBcq/X
         BNOWhDICw1Alain36y+NdSq6TC4n9jqX7hA09IYGoOntEHXmLSYPS/XFDAqNiG5Wjv
         Yx9nhhO217aco5pOloaTGNRMycvXZRXMxHuliaK0ILxww7yVUYApi5+VMgdjyH7R9O
         y1ayaetuW8J5n8iZD+uG3vc52D1Mfq836vtN18BMMDrCPYwriaoAvqwHgj5UADtl14
         VVhmEaajnIBgDFqRVHpIZO39L4WqUbJ5i+CsiO0paoWpj71Ht5psrJnOQ19dp8DKFP
         RTyg01xoe8auQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH net] net: sfp: ignore disabled SFP node
Date:   Wed, 19 Jan 2022 17:44:55 +0100
Message-Id: <20220119164455.1397-1-kabel@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices
and sfp cages") added code which finds SFP bus DT node even if the node
is disabled with status = "disabled". Because of this, when phylink is
created, it ends with non-null .sfp_bus member, even though the SFP
module is not probed (because the node is disabled).

We need to ignore disabled SFP bus node.

Fixes: ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices and sfp cages")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
---
 drivers/net/phy/sfp-bus.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 0c6c0d1843bc..c1512c9925a6 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -651,6 +651,11 @@ struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
 	else if (ret < 0)
 		return ERR_PTR(ret);
 
+	if (!fwnode_device_is_available(ref.fwnode)) {
+		fwnode_handle_put(ref.fwnode);
+		return NULL;
+	}
+
 	bus = sfp_bus_get(ref.fwnode);
 	fwnode_handle_put(ref.fwnode);
 	if (!bus)
-- 
2.34.1

