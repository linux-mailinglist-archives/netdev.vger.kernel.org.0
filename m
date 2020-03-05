Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFB617A57F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgCEMnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:43:10 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40032 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgCEMnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i/3JIQZBtiXaSlb+V1QcMGkCjQ4jDiiXjUPttZSvBE8=; b=cnK88tswTDM+ZX89tiO7X057+2
        sNBaXAmTZ8cdj7IKkwudVHu1PxZxn7X71ijq3DqGWNBM1odVTwbtWWy0QZKYr8PXk+eowjWoWUBnU
        Z6yE25nThYH5Zh4rxV7QfTZmSIqpznM9e8XxOqoOS0cNkOswnqt0lLOEnvzJ1H0KGG7caUZAJqvAl
        qCG7sgOX+vNuCytH3GvZwQTlm2HF+9jQpBtq3nDMiGdqSQScrdeA3qiWE2gXaN68oHU1XZFKl+9dU
        PvW//pL2KjKtSUkjiFsHrYRZQirHVPdDj9LATjUz+Fu3eE9pgMrgoHNVCzP6llwev6fzGsEaJKdar
        y8dtjxyg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:42998 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppx-0006Rv-Mc; Thu, 05 Mar 2020 12:42:50 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppv-00072i-1J; Thu, 05 Mar 2020 12:42:47 +0000
In-Reply-To: <20200305124139.GB25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 09/10] net: dsa: mv88e6xxx: remove port_link_state
 functions
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j9ppv-00072i-1J@rmk-PC.armlinux.org.uk>
Date:   Thu, 05 Mar 2020 12:42:47 +0000
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
index a8eb48976607..bdde20059c81 100644
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
@@ -3409,7 +3390,6 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3443,7 +3423,6 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
-	.port_link_state = mv88e6185_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3479,7 +3458,6 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3513,7 +3491,6 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3552,7 +3529,6 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_set_pause = mv88e6185_port_set_pause,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3596,7 +3572,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -3646,7 +3621,6 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3681,7 +3655,6 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3724,7 +3697,6 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3768,7 +3740,6 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3819,7 +3790,6 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3863,7 +3833,6 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -3911,7 +3880,6 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_set_pause = mv88e6185_port_set_pause,
-	.port_link_state = mv88e6185_port_link_state,
 	.port_get_cmode = mv88e6185_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
@@ -3953,7 +3921,6 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4013,7 +3980,6 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390x_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4072,7 +4038,6 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4135,7 +4100,6 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4191,7 +4155,6 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6250_port_link_state,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6250_stats_get_sset_count,
@@ -4231,7 +4194,6 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4293,7 +4255,6 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4336,7 +4297,6 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4379,7 +4339,6 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4432,7 +4391,6 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4473,7 +4431,6 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4519,7 +4476,6 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6320_g1_stats_snapshot,
@@ -4581,7 +4537,6 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
-	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_set_cmode = mv88e6390_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
@@ -4645,7 +4600,6 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
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

