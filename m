Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5B2E1768
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbgLWDJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgLWCSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B159823331;
        Wed, 23 Dec 2020 02:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689822;
        bh=slLvqsqHnC8JapO+m9u5I9+dSWBpjs/s0tl4hUefA+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCvQXCxSRLFtJt0eClQKGtrn89NF7m9FzKaTQURQeAgLJmQQGeV1Te6oqHY2xyI+g
         0eIEhCN061EsPSFW0I0Yw/vUoz6nb5U7tOHQlT7XJXeKW6bccXl7kOm7Idw8yW4w5e
         keUYba1J2xEvJun6SQMxRNuBpmz7WyK5naK0pGlkblEEBoKBcHSq2FNv4GLc6g3V+1
         WZ+ktFmqo4sAWV62FUEnzFGMWvAva69sCzPQLZiL5S2EadAHkLffKYTDKR2s2PMSLO
         orCWcpIYr09S8wFWUnBX1G36UeDe2gwENlJ8wCi2KkoYgw5U7Rc7xkuxrIJURByVSp
         p90wCotIk7Gxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 027/217] net: mscc: ocelot: don't reset the pvid to 0 when deleting it
Date:   Tue, 22 Dec 2020 21:13:16 -0500
Message-Id: <20201223021626.2790791-27-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 110e847ca7d5e712cabc8cb866a66b629832f4a2 ]

I have no idea why this code is here, but I have 2 hypotheses:

1.
A desperate attempt to keep untagged traffic working when the bridge
deletes the pvid on a port.

There was a fairly okay discussion here:
https://lore.kernel.org/netdev/CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com/#t
which established that in vlan_filtering=1 mode, the absence of a pvid
should denote that the ingress port should drop untagged and priority
tagged traffic. While in vlan_filtering=0 mode, nothing should change.

So in vlan_filtering=1 mode, we should simply let things happen, and not
attempt to save the day. And in vlan_filtering=0 mode, the pvid is 0
anyway, no need to do anything.

2.
The driver encodes the native VLAN (ocelot_port->vid) value of 0 as
special, meaning "not valid". There are checks based on that. But there
are no such checks for the ocelot_port->pvid value of 0. In fact, that's
a perfectly valid value, which is used in standalone mode. Maybe there
was some confusion and the author thought that 0 means "invalid" here as
well.

In conclusion, delete the code*.

*in fact we'll add it back later, in a slightly different form, but for
an entirely different reason than the one for which this exists now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a53bd36b11c60..ba17cd64c352e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -289,10 +289,6 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 	if (ret)
 		return ret;
 
-	/* Ingress */
-	if (ocelot_port->pvid == vid)
-		ocelot_port_set_pvid(ocelot, port, 0);
-
 	/* Egress */
 	if (ocelot_port->vid == vid)
 		ocelot_port_set_native_vlan(ocelot, port, 0);
-- 
2.27.0

