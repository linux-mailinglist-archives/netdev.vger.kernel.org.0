Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032D224105F
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgHJTKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728979AbgHJTKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 15:10:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D79822BEA;
        Mon, 10 Aug 2020 19:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086633;
        bh=xp8fR2OKUFXRlr+6s/FcMOYwBSGf6MkuK1Q1vuw4SxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J62EZ0W9kkpA+AJHJSWpCZQxloZzCDLzpiq9CFULKxHYlkTpwTypmVccQx3haWiP/
         B42gOZ7uvg+3wEtdxedb2R80LeUxe1W8AJ05n0GKsDirX5g0LJwFcnu1qkVx/noHR8
         phQYZYmGTnL8RLb2qnPP33NdwXvoSnPeHsF8pTcE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 03/60] net: mscc: ocelot: fix encoding destination ports into multicast IPv4 address
Date:   Mon, 10 Aug 2020 15:09:31 -0400
Message-Id: <20200810191028.3793884-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0897ecf7532577bda3dbcb043ce046a96948889d ]

The ocelot hardware designers have made some hacks to support multicast
IPv4 and IPv6 addresses. Normally, the MAC table matches on MAC
addresses and the destination ports are selected through the DEST_IDX
field of the respective MAC table entry. The DEST_IDX points to a Port
Group ID (PGID) which contains the bit mask of ports that frames should
be forwarded to. But there aren't a lot of PGIDs (only 80 or so) and
there are clearly many more IP multicast addresses than that, so it
doesn't scale to use this PGID mechanism, so something else was done.
Since the first portion of the MAC address is known, the hack they did
was to use a single PGID for _flooding_ unknown IPv4 multicast
(PGID_MCIPV4 == 62), but for known IP multicast, embed the destination
ports into the first 3 bytes of the MAC address recorded in the MAC
table.

The VSC7514 datasheet explains it like this:

    3.9.1.5 IPv4 Multicast Entries

    MAC table entries with the ENTRY_TYPE = 2 settings are interpreted
    as IPv4 multicast entries.
    IPv4 multicasts entries match IPv4 frames, which are classified to
    the specified VID, and which have DMAC = 0x01005Exxxxxx, where
    xxxxxx is the lower 24 bits of the MAC address in the entry.
    Instead of a lookup in the destination mask table (PGID), the
    destination set is programmed as part of the entry MAC address. This
    is shown in the following table.

    Table 78: IPv4 Multicast Destination Mask

        Destination Ports            Record Bit Field
        ---------------------------------------------
        Ports 10-0                   MAC[34-24]

    Example: All IPv4 multicast frames in VLAN 12 with MAC 01005E112233 are
    to be forwarded to ports 3, 8, and 9. This is done by inserting the
    following entry in the MAC table entry:
    VALID = 1
    VID = 12
    MAC = 0x000308112233
    ENTRY_TYPE = 2
    DEST_IDX = 0

But this procedure is not at all what's going on in the driver. In fact,
the code that embeds the ports into the MAC address looks like it hasn't
actually been tested. This patch applies the procedure described in the
datasheet.

Since there are many other fixes to be made around multicast forwarding
until it works properly, there is no real reason for this patch to be
backported to stable trees, or considered a real fix of something that
should have worked.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index efb3965a3e42b..b687e1caa0e17 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1599,14 +1599,14 @@ static int ocelot_port_obj_add_mdb(struct net_device *dev,
 	addr[0] = 0;
 
 	if (!new) {
-		addr[2] = mc->ports << 0;
-		addr[1] = mc->ports << 8;
+		addr[1] = mc->ports >> 8;
+		addr[2] = mc->ports & 0xff;
 		ocelot_mact_forget(ocelot, addr, vid);
 	}
 
 	mc->ports |= BIT(port);
-	addr[2] = mc->ports << 0;
-	addr[1] = mc->ports << 8;
+	addr[1] = mc->ports >> 8;
+	addr[2] = mc->ports & 0xff;
 
 	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
 }
@@ -1630,9 +1630,9 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 		return -ENOENT;
 
 	memcpy(addr, mc->addr, ETH_ALEN);
-	addr[2] = mc->ports << 0;
-	addr[1] = mc->ports << 8;
 	addr[0] = 0;
+	addr[1] = mc->ports >> 8;
+	addr[2] = mc->ports & 0xff;
 	ocelot_mact_forget(ocelot, addr, vid);
 
 	mc->ports &= ~BIT(port);
@@ -1642,8 +1642,8 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 		return 0;
 	}
 
-	addr[2] = mc->ports << 0;
-	addr[1] = mc->ports << 8;
+	addr[1] = mc->ports >> 8;
+	addr[2] = mc->ports & 0xff;
 
 	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
 }
-- 
2.25.1

