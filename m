Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766164A4AE0
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379816AbiAaPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379810AbiAaPrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:47:09 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28600C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:09 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t9so19946368lji.12
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=J8azPKw6fGS+HND9Kjsz3s+Jgbh9IVkU4laM4Xl6KxI=;
        b=MPrALNL1pv0pz1YMPRz04EYCNwsgmMrmhYUkkSHFURKw3MnC/7Nd/Cga3BIVetBnGR
         GW+ZtDoNdlLTeMfTeqUKKf8S72GrZ+81m/KHgwMWSobK525gnY8qDaN3w4eBm/wlC00w
         XV2Dmxcy39LXMapfA47N55Fyj6V2xpmgNobIvvfibWmK+x1QseFAY7UK2gg4mDNqiMzv
         AXRNMfzK2lmIUma9TGVaEGB28q5WwDqGptVyfPaNn3YQdhs4vf+RbfqsLdxe0TCYWWul
         B6bNy2Um6fHbFgO0KpPwusRjb5Fc7OZM8VtEwRFWcSHVxicOjzcb+wmnjFMF/pI3ZXff
         dnxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=J8azPKw6fGS+HND9Kjsz3s+Jgbh9IVkU4laM4Xl6KxI=;
        b=BRmXOygiG64fI0H8s/uworsuRZePlRj44SkzI9FfnynpqiAbz3danv97KSRCTpcGoR
         Qy5Tu2EPXvMOslRxWkSolm6ydo6lN309yHgdca0R+IAz0XS/bYU9BYtgfdYJ7hf7LATF
         /eOwIgmkq/YwIn6Ps3qbxyEQ0qjwxc3G/Vj5lHNmrBeBNB6CiZCfc5gSGQFVPFeW4Kg0
         UB1QSQtSzFI/diu2XSiU7Bp0sD5l5bRlQA1ZrS97D2NElsBLmaDlqQ0kRZKewYCDUR4l
         8RZ3XjjmktesItk911d/aZq3lqXvv3nUCioSeRivGclaXXCdwvY7XmkDYiQUyaWYxDGw
         LVFQ==
X-Gm-Message-State: AOAM533fRbqQm1TFTjAL8EjLJpQ4JxfY/RkBaragxMJ3KE+tsihg8Zri
        kzORrOh3gdeyi1fsnWesC++MkQ==
X-Google-Smtp-Source: ABdhPJzxef0rNjIQJ7dy6S5Dn6MgpCjUMBQxFhoKa0uZLPdThEoS3LtY6fOJqBz2XBOwkpaMHrhFBg==
X-Received: by 2002:a2e:88da:: with SMTP id a26mr13206527ljk.256.1643644027465;
        Mon, 31 Jan 2022 07:47:07 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y36sm3374769lfa.82.2022.01.31.07.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:47:07 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
Date:   Mon, 31 Jan 2022 16:46:54 +0100
Message-Id: <20220131154655.1614770-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131154655.1614770-1-tobias@waldekranz.com>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c | 63 ++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8896709b9103..d0d766354669 100644
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
@@ -2949,8 +2939,43 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
+	/* On chips that support it, set all DSA ports' VLAN policy to
+	 * TRAP. In combination with loading MV88E6XXX_VID_STANDALONE
+	 * as a policy entry in the VTU, this provides a better
+	 * isolation barrier between standalone ports, as the ATU is
+	 * bypassed on any intermediate switches between the incoming
+	 * port and the CPU.
+	 */
+	if (!dsa_is_user_port(ds, port) && chip->info->ops->port_set_policy) {
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
 
@@ -2963,7 +2988,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * relying on their port default FID.
 	 */
 	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_BRIDGED,
-				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED,
+				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED,
 				       false);
 	if (err)
 		return err;
-- 
2.25.1

