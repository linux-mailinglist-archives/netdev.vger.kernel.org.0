Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3734E47980A
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 02:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhLRBks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 20:40:48 -0500
Received: from mx1.riseup.net ([198.252.153.129]:45898 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhLRBks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 20:40:48 -0500
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4JG7pl5YVhzF4hM
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 17:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1639791647; bh=GNKr3g/eVpJjKDw/rl3ZNLOgSeogliyv2Yudh53qiOw=;
        h=From:To:Cc:Subject:Date:From;
        b=e7j4eapT57hGpmf3Vj7ENS9dgcNOBuuSxNJ6Tq9poJ8izlOVPqBzGmhRukXejtZuP
         7cynf5ebRejlL11eZcB3Kq8aYPC/dH+t9Yjw8UXER2dyPprvdr8OSDLoPCWSZD+iz6
         Y/jtX65GfwlOn7Jpf5E7mkm8lUREllo8PM6I2Wgk=
X-Riseup-User-ID: F79032C258D4BE08D403294FBAB6EE726CCAADF6207C9711E335882E0AABBF0A
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4JG7pk6r9qz5vks;
        Fri, 17 Dec 2021 17:40:46 -0800 (PST)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netdev@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH net v2] bonding: fix ad_actor_system option setting to default
Date:   Sat, 18 Dec 2021 02:40:26 +0100
Message-Id: <20211218014026.1530-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 802.3ad bond mode is configured the ad_actor_system option is set to
"00:00:00:00:00:00". But when trying to set the all-zeroes MAC as actors'
system address it was failing with EINVAL.

An all-zeroes ethernet address is valid, only multicast addresses are not valid
values.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v2: added documentation changes and modified commit message
---
 Documentation/networking/bonding.rst | 11 ++++++-----
 drivers/net/bonding/bond_options.c   |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 31cfd7d674a6..c0a789b00806 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -196,11 +196,12 @@ ad_actor_sys_prio
 ad_actor_system
 
 	In an AD system, this specifies the mac-address for the actor in
-	protocol packet exchanges (LACPDUs). The value cannot be NULL or
-	multicast. It is preferred to have the local-admin bit set for this
-	mac but driver does not enforce it. If the value is not given then
-	system defaults to using the masters' mac address as actors' system
-	address.
+	protocol packet exchanges (LACPDUs). The value cannot be a multicast
+	address. If the all-zeroes MAC is specified, bonding will internally
+	use the MAC of the bond itself. It is preferred to have the
+	local-admin bit set for this mac but driver does not enforce it. If
+	the value is not given then system defaults to using the masters'
+	mac address as actors' system address.
 
 	This parameter has effect only in 802.3ad mode and is available through
 	SysFs interface.
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a8fde3bc458f..b93337b5a721 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1526,7 +1526,7 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
 		mac = (u8 *)&newval->value;
 	}
 
-	if (!is_valid_ether_addr(mac))
+	if (is_multicast_ether_addr(mac))
 		goto err;
 
 	netdev_dbg(bond->dev, "Setting ad_actor_system to %pM\n", mac);
-- 
2.30.2

