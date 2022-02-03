Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABED4A8239
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350076AbiBCKRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350038AbiBCKRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:17:12 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72222C061748
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 02:17:09 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id l25so3946764wrb.13
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 02:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ZsqgiQg4DyhZMtFGcYBtOqIcmksimVJQ+wXhCf+F5q4=;
        b=xUj7JCe9ysvCQUikBJ2xTtpoghZRMuYJFNZE95fX39aRhfJQT1mv6mhVJEXzl5Y1mV
         LLyIQTWPRvabw3gjz61FBWHSHBSdfpvwKOcknu1595Qa0VJlXI0fdC+LkZLY39own3co
         2Kw8emOunrD+fiUUZNGgDY9HP1hFsAKbvrxq4sHjOUtwvYKIPAt3sGnNjbRiSl13K+NT
         ddJXSYcIavO2Cx1L956LqKVIM36KEKhio2tulAGlVL/TW8ozupWSb0RP9TZV9jZBSU4Q
         jAsJxc+Ep33zIkc/7RlCbVKl4pE320v9agP3B46UfdHz4M3jumn76L/husAQeGPL/0QL
         zH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ZsqgiQg4DyhZMtFGcYBtOqIcmksimVJQ+wXhCf+F5q4=;
        b=S6xRKV06JBg8zWExty+yzPmlniSgSkbbOPHZFpKDYWYofl7ES5ERTz9gHxDQj10uFu
         3zo/dqTdF9JOuO++tIYgB3/RwLbaM3F7zW1aNj9s/qmLTZfrlGISS+NfKDSgAF5SFAnI
         mM1pHGitxW0VbPk66cVnHZGOE9bBQZayvcG+BXrglUcL/5JieI7Fwl6Q+ORfzZw8C7t/
         RLkcCmf8bF+48WoBVh5OGSLLIXxoSYNRneBoT06hyDpgU4r1u5RPptUGSIrUJDxBCRrf
         O6AUX8tvYX667Z/hnkUn0AjSTRBsDe1tzl1Wfxj7qZ+Pez7H4BF2X2UwwAL17tVg+Hv3
         AlLw==
X-Gm-Message-State: AOAM531ADnXOj87rHrzY4tKF5q7GsOuqYE2TPz55/sVFM2diXuRXDvxZ
        7WVEAIijL3GC1oBTs/Ec9azbZQ==
X-Google-Smtp-Source: ABdhPJzwvfI8/AwHGgdy1d+CRsBzphC4aUVbBj569q6n//0yr0OScSgNddemwuqkzFN/I1uqmd3A2Q==
X-Received: by 2002:a5d:64a1:: with SMTP id m1mr27938714wrp.358.1643883427991;
        Thu, 03 Feb 2022 02:17:07 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g6sm19017148wrq.97.2022.02.03.02.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 02:17:07 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 4/5] net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
Date:   Thu,  3 Feb 2022 11:16:56 +0100
Message-Id: <20220203101657.990241-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203101657.990241-1-tobias@waldekranz.com>
References: <20220203101657.990241-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that standalone ports are now configured to bypass the ATU and
forward all frames towards the upstream port, extend the ATU bypass to
multichip systems.

Load VID 0 (standalone) into the VTU with the policy bit set. Since
VID 4095 (bridged) is already loaded, we now know that all VIDs in use
are always available in all VTUs. Therefore, we can safely enable
802.1Q on DSA ports.

Setting the DSA ports' VTU policy to TRAP means that all incoming
frames on VID 0 will be classified as MGMT - as a result, the ATU is
bypassed on all subsequent switches.

With this isolation in place, we are able to support configurations
that are simultaneously very quirky and very useful. Quirky because it
involves looping cables between local switchports like in this
example:

   CPU
    |     .------.
.---0---. | .----0----.
|  sw0  | | |   sw1   |
'-1-2-3-' | '-1-2-3-4-'
  $ @ '---'   $ @ % %

We have three physically looped pairs ($, @, and %).

This is very useful because it allows us to run the kernel's
kselftests for the bridge on mv88e6xxx hardware.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 64 ++++++++++++++++++++++----------
 include/net/dsa.h                |  6 +++
 2 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 99151ba6f545..22391f8d4169 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1630,21 +1630,11 @@ static int mv88e6xxx_fid_map_vlan(struct mv88e6xxx_chip *chip,
 
 int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
 {
-	int i, err;
-	u16 fid;
-
 	bitmap_zero(fid_bitmap, MV88E6XXX_N_FID);
 
-	/* Set every FID bit used by the (un)bridged ports */
-	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
-		err = mv88e6xxx_port_get_fid(chip, i, &fid);
-		if (err)
-			return err;
-
-		set_bit(fid, fid_bitmap);
-	}
-
-	/* Set every FID bit used by the VLAN entries */
+	/* Every FID has an associated VID, so walking the VTU
+	 * will discover the full set of FIDs in use.
+	 */
 	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_fid_map_vlan, fid_bitmap);
 }
 
@@ -1657,10 +1647,7 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 	if (err)
 		return err;
 
-	/* The reset value 0x000 is used to indicate that multiple address
-	 * databases are not needed. Return the next positive available.
-	 */
-	*fid = find_next_zero_bit(fid_bitmap, MV88E6XXX_N_FID, 1);
+	*fid = find_first_zero_bit(fid_bitmap, MV88E6XXX_N_FID);
 	if (unlikely(*fid >= mv88e6xxx_num_databases(chip)))
 		return -ENOSPC;
 
@@ -2152,6 +2139,9 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 	if (!vlan.valid) {
 		memset(&vlan, 0, sizeof(vlan));
 
+		if (vid == MV88E6XXX_VID_STANDALONE)
+			vlan.policy = true;
+
 		err = mv88e6xxx_atu_new(chip, &vlan.fid);
 		if (err)
 			return err;
@@ -2949,8 +2939,44 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
+	/* On chips that support it, set all downstream DSA ports'
+	 * VLAN policy to TRAP. In combination with loading
+	 * MV88E6XXX_VID_STANDALONE as a policy entry in the VTU, this
+	 * provides a better isolation barrier between standalone
+	 * ports, as the ATU is bypassed on any intermediate switches
+	 * between the incoming port and the CPU.
+	 */
+	if (dsa_is_downstream_port(ds, port) &&
+	    chip->info->ops->port_set_policy) {
+		err = chip->info->ops->port_set_policy(chip, port,
+						MV88E6XXX_POLICY_MAPPING_VTU,
+						MV88E6XXX_POLICY_ACTION_TRAP);
+		if (err)
+			return err;
+	}
+
+	/* User ports start out in standalone mode and 802.1Q is
+	 * therefore disabled. On DSA ports, all valid VIDs are always
+	 * loaded in the VTU - therefore, enable 802.1Q in order to take
+	 * advantage of VLAN policy on chips that supports it.
+	 */
 	err = mv88e6xxx_port_set_8021q_mode(chip, port,
-				MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED);
+				dsa_is_user_port(ds, port) ?
+				MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED :
+				MV88E6XXX_PORT_CTL2_8021Q_MODE_SECURE);
+	if (err)
+		return err;
+
+	/* Bind MV88E6XXX_VID_STANDALONE to MV88E6XXX_FID_STANDALONE by
+	 * virtue of the fact that mv88e6xxx_atu_new() will pick it as
+	 * the first free FID. This will be used as the private PVID for
+	 * unbridged ports. Shared (DSA and CPU) ports must also be
+	 * members of this VID, in order to trap all frames assigned to
+	 * it to the CPU.
+	 */
+	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_STANDALONE,
+				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED,
+				       false);
 	if (err)
 		return err;
 
@@ -2963,7 +2989,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * relying on their port default FID.
 	 */
 	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_BRIDGED,
-				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED,
+				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED,
 				       false);
 	if (err)
 		return err;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6e5ef62a7dce..ca8c14b547b4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -591,6 +591,12 @@ static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
 	return port == dsa_upstream_port(ds, port);
 }
 
+/* Return true if this is a DSA port leading away from the CPU */
+static inline bool dsa_is_downstream_port(struct dsa_switch *ds, int port)
+{
+	return dsa_is_dsa_port(ds, port) && !dsa_is_upstream_port(ds, port);
+}
+
 /* Return the local port used to reach the CPU port */
 static inline unsigned int dsa_switch_upstream_port(struct dsa_switch *ds)
 {
-- 
2.25.1

