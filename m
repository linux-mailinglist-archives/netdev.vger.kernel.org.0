Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB861F29E0
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731309AbgFIAEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731163AbgFHXV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F355208B3;
        Mon,  8 Jun 2020 23:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658489;
        bh=tyOuRkwJp1G90FdQ/5i4KlH0+MZ9GMyYjeuCimDVhCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J66IJh333aRAbh9x7vFq1iFdOF2WCQz4HZK+3vhqG3yKZRRbdQItyetSakdV3Rp5e
         q5Jl3Y+tDg8RMHLuepnQn2aaOv//rCxR5Z12VRsPbUgaX36s2pl3hcD5RFvUVKU0Ub
         AAQCdUd6yOlogJ+CgQ9SZ4+mR5tqFCR4cpTKlJ2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 123/175] net: dsa: mt7530: set CPU port to fallback mode
Date:   Mon,  8 Jun 2020 19:17:56 -0400
Message-Id: <20200608231848.3366970-123-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

[ Upstream commit 38152ea37d8bdaffa22603e0a5b5b86cfa8714c9 ]

Currently, setting a bridge's self PVID to other value and deleting
the default VID 1 renders untagged ports of that VLAN unable to talk to
the CPU port:

	bridge vlan add dev br0 vid 2 pvid untagged self
	bridge vlan del dev br0 vid 1 self
	bridge vlan add dev sw0p0 vid 2 pvid untagged
	bridge vlan del dev sw0p0 vid 1
	# br0 cannot send untagged frames out of sw0p0 anymore

That is because the CPU port is set to security mode and its PVID is
still 1, and untagged frames are dropped due to VLAN member violation.

Set the CPU port to fallback mode so untagged frames can pass through.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 11 ++++++++---
 drivers/net/dsa/mt7530.h |  6 ++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6027bb65f7f6..dc9a3bb24114 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -818,10 +818,15 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 		   PCR_MATRIX_MASK, PCR_MATRIX(MT7530_ALL_MEMBERS));
 
 	/* Trapped into security mode allows packet forwarding through VLAN
-	 * table lookup.
+	 * table lookup. CPU port is set to fallback mode to let untagged
+	 * frames pass through.
 	 */
-	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
-		   MT7530_PORT_SECURITY_MODE);
+	if (dsa_is_cpu_port(ds, port))
+		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+			   MT7530_PORT_FALLBACK_MODE);
+	else
+		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+			   MT7530_PORT_SECURITY_MODE);
 
 	/* Set the port as a user port which is to be able to recognize VID
 	 * from incoming packets before fetching entry within the VLAN table.
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 0e7e36d8f994..3ef7b5a6fc22 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -148,6 +148,12 @@ enum mt7530_port_mode {
 	/* Port Matrix Mode: Frames are forwarded by the PCR_MATRIX members. */
 	MT7530_PORT_MATRIX_MODE = PORT_VLAN(0),
 
+	/* Fallback Mode: Forward received frames with ingress ports that do
+	 * not belong to the VLAN member. Frames whose VID is not listed on
+	 * the VLAN table are forwarded by the PCR_MATRIX members.
+	 */
+	MT7530_PORT_FALLBACK_MODE = PORT_VLAN(1),
+
 	/* Security Mode: Discard any frame due to ingress membership
 	 * violation or VID missed on the VLAN table.
 	 */
-- 
2.25.1

