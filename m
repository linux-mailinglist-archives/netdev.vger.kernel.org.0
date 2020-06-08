Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BF91F2F73
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgFIAuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbgFHXKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102CA20B80;
        Mon,  8 Jun 2020 23:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657831;
        bh=eZBp0tsDujcrF4Qv8GoWmXbcnp4p9Qe7aDwVYZD6/yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0qSSwPM5IgKH3FNyWY8dE9U1ZF/8XvrKxJ0rtiohfV8syQpcnfZbzkHzlIg0MOIi
         Qs52tNU3de00EmHgsIOhH5sDwWo1zOE24giowPgQdt4t4vj5Lib5Kaq+Vd5qG5qNMV
         yMdY6Ej4LDfj853T/upz42t3wY5JYXD2c8JQv2VM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 201/274] net: dsa: mt7530: set CPU port to fallback mode
Date:   Mon,  8 Jun 2020 19:04:54 -0400
Message-Id: <20200608230607.3361041-201-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
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
index 34e4aadfa705..b75d09783a05 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -807,10 +807,15 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
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
index 82af4d2d406e..14de60d0b9ca 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -153,6 +153,12 @@ enum mt7530_port_mode {
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

