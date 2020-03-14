Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610F71856C3
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCOB3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:29:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbgCOB3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6n5gjuQAVbjV35E7L6+IaNiUyjI6NYNG8jBpfy+Vhr4=; b=H0p35LPVpTd+ovaQCQ0bi8zcnA
        ND+8GLV82by+kWygvwXKJ99+GamIfldlPccIYFWS7RmezA91vAJ8f1h/XQpscDGz3WyNwryxNcmaY
        NqK/+6u4uPkH8CjVlV4akeWb+3kktLoC7gMeQQ6qc89s/QW2X1UFTGCe7fDuGAn13owRtuNQX+SMD
        rnEMVmXkHNY3y5sNbfdAGXx6CvsaM0eoASqPs440gnKGlgTxc8T5RHg/++poomn3rkHlWyLXKurUV
        XLVokOSgckPYKOHgt9APYO1eCe+uoRXujETyS1OFVuiAuTfjG1QotlIvZyVBVTtSGe0DlMDF/0vpb
        IF3uYwuQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:41718 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3po-0006CD-Fa; Sat, 14 Mar 2020 10:16:00 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3pm-0006Dx-Sz; Sat, 14 Mar 2020 10:15:58 +0000
In-Reply-To: <20200314101431.GF25745@shell.armlinux.org.uk>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 7/8] net: dsa: mv88e6xxx: remove port_link_state
 functions
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD3pm-0006Dx-Sz@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:15:58 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port_link_state method is only used by mv88e6xxx_port_setup_mac(),
which is now only called during port setup, rather than also being
called via phylink's mac_config method.

Remove this now unnecessary optimisation, which allows us to remove the
port_link_state methods as well.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  46 --------
 drivers/net/dsa/mv88e6xxx/chip.h |   3 -
 drivers/net/dsa/mv88e6xxx/port.c | 177 -------------------------------
 drivers/net/dsa/mv88e6xxx/port.h |   6 --
 4 files changed, 232 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 34c7f3e588ec..03bc15a97591 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -423,30 +423,11 @@ static int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port,
 				    int link, int speed, int duplex, int pause,
 				    phy_interface_t mode)
 {
-	struct phylink_link_state state;
 	int err;
 
 	if (!chip->info->ops->port_set_link)
 		return 0;
 
-	if (!chip->info->ops->port_link_state)
-		return 0;
-
-	err = chip->info->ops->port_link_state(chip, port, &state);
-	if (err)
-		return err;
-
-	/* Has anything actually changed? We don't expect the
-	 * interface mode to change without one of the other
-	 * parameters also changing
-	 */
-	if (state.link == link &&
-	    state.speed == speed &&
-	    state.duplex == duplex &&
-	    (state.interface == mode ||
-	     state.interface == PHY_INTERFACE_MODE_NA))
-		return 0;
-
 	/* Port's MAC control must not be changed unless the link is down */
 	err = chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
 	if (err)
@@ -3411,7 +3392,6 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3445,7 +3425,6 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
-	.port_link_state = mv88e6185_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3481,7 +3460,6 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3515,7 +3493,6 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3554,7 +3531,6 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_set_pause = mv88e6185_port_set_pause,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3598,7 +3574,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -3648,7 +3623,6 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3683,7 +3657,6 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3726,7 +3699,6 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3770,7 +3742,6 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3821,7 +3792,6 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3865,7 +3835,6 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3913,7 +3882,6 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_set_pause = mv88e6185_port_set_pause,
-	.port_link_state = mv88e6185_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3955,7 +3923,6 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4015,7 +3982,6 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390x_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4074,7 +4040,6 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4137,7 +4102,6 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4193,7 +4157,6 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6250_port_link_state,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6250_stats_get_sset_count,
@@ -4233,7 +4196,6 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4295,7 +4257,6 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4338,7 +4299,6 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4381,7 +4341,6 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4434,7 +4393,6 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4475,7 +4433,6 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4521,7 +4478,6 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4583,7 +4539,6 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4647,7 +4602,6 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390x_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 72214c4bb2ab..e5430cf2ad71 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -458,9 +458,6 @@ struct mv88e6xxx_ops {
 	 */
 	int (*port_set_upstream_port)(struct mv88e6xxx_chip *chip, int port,
 				      int upstream_port);
-	/* Return the port link state, as required by phylink */
-	int (*port_link_state)(struct mv88e6xxx_chip *chip, int port,
-			       struct phylink_link_state *state);
 
 	/* Snapshot the statistics for a port. The statistics can then
 	 * be read back a leisure but still with a consistent view.
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 442abb719cdc..8128dc607cf4 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -584,183 +584,6 @@ int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode)
 	return 0;
 }
 
-int mv88e6250_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state)
-{
-	int err;
-	u16 reg;
-
-	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
-	if (err)
-		return err;
-
-	if (port < 5) {
-		switch (reg & MV88E6250_PORT_STS_PORTMODE_MASK) {
-		case MV88E6250_PORT_STS_PORTMODE_PHY_10_HALF:
-			state->speed = SPEED_10;
-			state->duplex = DUPLEX_HALF;
-			break;
-		case MV88E6250_PORT_STS_PORTMODE_PHY_100_HALF:
-			state->speed = SPEED_100;
-			state->duplex = DUPLEX_HALF;
-			break;
-		case MV88E6250_PORT_STS_PORTMODE_PHY_10_FULL:
-			state->speed = SPEED_10;
-			state->duplex = DUPLEX_FULL;
-			break;
-		case MV88E6250_PORT_STS_PORTMODE_PHY_100_FULL:
-			state->speed = SPEED_100;
-			state->duplex = DUPLEX_FULL;
-			break;
-		default:
-			state->speed = SPEED_UNKNOWN;
-			state->duplex = DUPLEX_UNKNOWN;
-			break;
-		}
-	} else {
-		switch (reg & MV88E6250_PORT_STS_PORTMODE_MASK) {
-		case MV88E6250_PORT_STS_PORTMODE_MII_10_HALF:
-			state->speed = SPEED_10;
-			state->duplex = DUPLEX_HALF;
-			break;
-		case MV88E6250_PORT_STS_PORTMODE_MII_100_HALF:
-			state->speed = SPEED_100;
-			state->duplex = DUPLEX_HALF;
-			break;
-		case MV88E6250_PORT_STS_PORTMODE_MII_10_FULL:
-			state->speed = SPEED_10;
-			state->duplex = DUPLEX_FULL;
-			break;
-		case MV88E6250_PORT_STS_PORTMODE_MII_100_FULL:
-			state->speed = SPEED_100;
-			state->duplex = DUPLEX_FULL;
-			break;
-		default:
-			state->speed = SPEED_UNKNOWN;
-			state->duplex = DUPLEX_UNKNOWN;
-			break;
-		}
-	}
-
-	state->link = !!(reg & MV88E6250_PORT_STS_LINK);
-	state->an_enabled = 1;
-	state->an_complete = state->link;
-	state->interface = PHY_INTERFACE_MODE_NA;
-
-	return 0;
-}
-
-int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state)
-{
-	int err;
-	u16 reg;
-
-	switch (chip->ports[port].cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_RGMII:
-		err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL,
-					  &reg);
-		if (err)
-			return err;
-
-		if ((reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_RXCLK) &&
-		    (reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_TXCLK))
-			state->interface = PHY_INTERFACE_MODE_RGMII_ID;
-		else if (reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_RXCLK)
-			state->interface = PHY_INTERFACE_MODE_RGMII_RXID;
-		else if (reg & MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_TXCLK)
-			state->interface = PHY_INTERFACE_MODE_RGMII_TXID;
-		else
-			state->interface = PHY_INTERFACE_MODE_RGMII;
-		break;
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-		state->interface = PHY_INTERFACE_MODE_1000BASEX;
-		break;
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-		state->interface = PHY_INTERFACE_MODE_SGMII;
-		break;
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		state->interface = PHY_INTERFACE_MODE_2500BASEX;
-		break;
-	case MV88E6XXX_PORT_STS_CMODE_XAUI:
-		state->interface = PHY_INTERFACE_MODE_XAUI;
-		break;
-	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
-		state->interface = PHY_INTERFACE_MODE_RXAUI;
-		break;
-	default:
-		/* we do not support other cmode values here */
-		state->interface = PHY_INTERFACE_MODE_NA;
-	}
-
-	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
-	if (err)
-		return err;
-
-	switch (reg & MV88E6XXX_PORT_STS_SPEED_MASK) {
-	case MV88E6XXX_PORT_STS_SPEED_10:
-		state->speed = SPEED_10;
-		break;
-	case MV88E6XXX_PORT_STS_SPEED_100:
-		state->speed = SPEED_100;
-		break;
-	case MV88E6XXX_PORT_STS_SPEED_1000:
-		state->speed = SPEED_1000;
-		break;
-	case MV88E6XXX_PORT_STS_SPEED_10000:
-		if ((reg & MV88E6XXX_PORT_STS_CMODE_MASK) ==
-		    MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			state->speed = SPEED_2500;
-		else
-			state->speed = SPEED_10000;
-		break;
-	}
-
-	state->duplex = reg & MV88E6XXX_PORT_STS_DUPLEX ?
-			DUPLEX_FULL : DUPLEX_HALF;
-	state->link = !!(reg & MV88E6XXX_PORT_STS_LINK);
-	state->an_enabled = 1;
-	state->an_complete = state->link;
-
-	return 0;
-}
-
-int mv88e6185_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state)
-{
-	if (state->interface == PHY_INTERFACE_MODE_1000BASEX) {
-		u8 cmode = chip->ports[port].cmode;
-
-		/* When a port is in "Cross-chip serdes" mode, it uses
-		 * 1000Base-X full duplex mode, but there is no automatic
-		 * link detection. Use the sync OK status for link (as it
-		 * would do for 1000Base-X mode.)
-		 */
-		if (cmode == MV88E6185_PORT_STS_CMODE_SERDES) {
-			u16 mac;
-			int err;
-
-			err = mv88e6xxx_port_read(chip, port,
-						  MV88E6XXX_PORT_MAC_CTL, &mac);
-			if (err)
-				return err;
-
-			state->link = !!(mac & MV88E6185_PORT_MAC_CTL_SYNC_OK);
-			state->an_enabled = 1;
-			state->an_complete =
-				!!(mac & MV88E6185_PORT_MAC_CTL_AN_DONE);
-			state->duplex =
-				state->link ? DUPLEX_FULL : DUPLEX_UNKNOWN;
-			state->speed =
-				state->link ? SPEED_1000 : SPEED_UNKNOWN;
-
-			return 0;
-		}
-	}
-
-	return mv88e6352_port_link_state(chip, port, state);
-}
-
 /* Offset 0x02: Jamming Control
  *
  * Do not limit the period of time that this port can be paused for by
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 1d18426b7ff6..44d76ac973f6 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -364,12 +364,6 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode);
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
 int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
-int mv88e6185_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state);
-int mv88e6250_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state);
-int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
-			      struct phylink_link_state *state);
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
 int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				     int upstream_port);
-- 
2.20.1

