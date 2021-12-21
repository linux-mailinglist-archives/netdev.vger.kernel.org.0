Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC2447BEAF
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 12:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhLULO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 06:14:28 -0500
Received: from mx1.riseup.net ([198.252.153.129]:56436 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236868AbhLULO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 06:14:27 -0500
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4JJDPH325mzF3M0;
        Tue, 21 Dec 2021 03:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1640085267; bh=Tj7iDTGSZ1xlUXWpqXU32Hng6QzgDXW5tIS0pS0Kbs4=;
        h=From:To:Cc:Subject:Date:From;
        b=XDR2T6O84QOGYQeNLU5wY9ClmTFM8QtzmIPJ6Xf/ilesCGkDKctltwaOVeow1WVJt
         7juy3fToPKNyutjw+HuI0ejd+Jo16MFo5P9fbhI57IYPfF6ch02hgFeyFXSqHgrP1D
         A8mMaoAEGHqC895qNm1DJDafI0y4doqkD4oLPnO0=
X-Riseup-User-ID: 74F20129CF832BA4FA580CC3FA543893C8361B0903A70FFC32D09A5EAD0041D6
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4JJDPD4ydKz1yT2;
        Tue, 21 Dec 2021 03:14:24 -0800 (PST)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netdev@vger.kernel.org
Cc:     j.vosburgh@gmail.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        andy@greyhouse.net,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH net v4] bonding: fix ad_actor_system option setting to default
Date:   Tue, 21 Dec 2021 12:13:45 +0100
Message-Id: <20211221111345.2462-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 802.3ad bond mode is configured the ad_actor_system option is set to
"00:00:00:00:00:00". But when trying to set the all-zeroes MAC as actors'
system address it was failing with EINVAL.

An all-zeroes ethernet address is valid, only multicast addresses are not
valid values.

Fixes: 171a42c38c6e ("bonding: add netlink support for sys prio, actor sys mac, and port key")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
v2: added documentation changes and modified commit message
v3: fixed format warning on commit message
v4: added fixes tag and ACK from Jay Vosburgh
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

