Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3BC38F4FC
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhEXVfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:35:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233842AbhEXVfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dfikKytAvyUVSh8ZdDvtUgmiTaKRN4fTP7dHWQTgSAw=; b=HwxkJN9iuEpft17TzvJBXZuDJq
        KR8b5l4PwuOqn5+uG9Yd+1DNhlU4nYI8T60tT+8/tfqwNkIt5VFOAol/pnVti5olDnSfcXuOQ9a03
        RoywOBhE1sW2g5QhSrgDvc4lxT9z1Vg0nBlGqrGcNjEgFSdf59U5fbTrUVsLBwveNVRw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llICb-00624u-Er; Mon, 24 May 2021 23:33:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, cao88yu@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 1/3] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
Date:   Mon, 24 May 2021 23:33:11 +0200
Message-Id: <20210524213313.1437891-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524213313.1437891-1-andrew@lunn.ch>
References: <20210524213313.1437891-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The datasheets suggests the 6161 uses a per port setting for jumbo
frames. Testing has however shown this is not correct, it uses the old
style chip wide MTU control. Change the ops in the 6161 structure to
reflect this.

Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
Reported by: 曹煜 <cao88yu@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eca285aaf72f..cbedaee3cefd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3638,7 +3638,6 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
-	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3663,6 +3662,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
 	.phylink_validate = mv88e6185_phylink_validate,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6165_ops = {
-- 
2.31.1

