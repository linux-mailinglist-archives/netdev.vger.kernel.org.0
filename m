Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537B0418A67
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 19:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhIZR7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 13:59:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhIZR7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 13:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iFwDZjKfJ/i9kTestJUWtHZZhtHNJ+x3peYwzJvxxxc=; b=xTnQL+TpzxT2xTcXEqz58pkUsA
        z0XNtt3RI8/nnXaSf7mHWYmcnJAz5saAd+Bc8pLjsOYZDapDhbYyu3kdd5NEanGTJ61PdZ8Qdw8MY
        j203lRzxqwpMeN0blIDuLQ8masdMXzotZondj0alxnYkLF+eCqHmH9Lt8WQaCrMLEzTY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUY9i-008L0z-73; Sun, 26 Sep 2021 19:41:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     cao88yu@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 1/3] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
Date:   Sun, 26 Sep 2021 19:41:24 +0200
Message-Id: <20210926174126.1987355-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210926174126.1987355-1-andrew@lunn.ch>
References: <20210926174126.1987355-1-andrew@lunn.ch>
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
index 8ab0be793811..86d3cab6ceef 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3725,7 +3725,6 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
-	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3750,6 +3749,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
 	.phylink_validate = mv88e6185_phylink_validate,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6165_ops = {
-- 
2.33.0

