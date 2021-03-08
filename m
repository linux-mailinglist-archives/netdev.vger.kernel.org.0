Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA7E3311A1
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 16:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhCHPFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 10:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhCHPFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 10:05:17 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B904BC06175F
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 07:05:16 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id d3so21423061lfg.10
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 07:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=SCn1ePxBlfmDhRSXEliosEM6x87FZAygSIS1Ou6HoJM=;
        b=HNtq86TYDTnZhyiFvBrBScTdp6XP5GjH7vONWAY+Id2f1fCWt1AG5/HHzRNl2YZwZN
         Ys4JILU9otdZW5ZyVjAH1WyvKkj8rDPuaUYmdgxFovnLdXifRg3tRPSr5HwLcLHdnUlt
         7bo4JG45Q01Sn7+quo8IRQar+IZ2BYZIeLwWLAB6BAc7WRCz+d7wUNJf+BsgiIxKxN6V
         P+3qitlPsjYRQXIrZvSgFOV3Wd7kffRtyyxi5FTR7CvmpbouvGIPrQoGwDiMAQmlrBiE
         Cpzdg28Th1PgsOA7hcMr/KWpUioiA55WO8DarKQSIIKE+VUfuMyFeVl4aT/rFYTdQQTF
         rqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=SCn1ePxBlfmDhRSXEliosEM6x87FZAygSIS1Ou6HoJM=;
        b=hi++qEYiAj6O8JVC6hTi/f54eoMMiW5sz61W1C+kq6F0YaS3ylK8BAEdtt0wmYU7Ho
         iF7aCPreMBCMItj1Rt/Loo9a1SvRAxRU/JJKGFtCWk8UUA9topoJOFw0s2xxg1Udp3bM
         XGtoQqfNoZuwI2iq9WuPEqfFkRSpWu3bfMe0UwS+spZ3avxWDtogd8DbQjJvteOpTPe0
         PvECn0dCtU1bDbzRc+kVlDViJ77FzdCCWUHOcvsTsRjZ7AbOk6KxV2EEWs1cnB95dt81
         plKELjIgU0mAnRNkzYAs3uuuYCCrEt35eDOLxsQNHWYcmrTMZB1sarowRQ17/v4qy/ig
         W8Gw==
X-Gm-Message-State: AOAM531Cq1WNPVYfb5h5s8VrsnbvimARWdJS7SZKtrAALagYHRhPD3Ii
        vFzLfxMLHv0Mv0wTqDJwHvgL4Q==
X-Google-Smtp-Source: ABdhPJx9VQxz53L17ixe8hpQrCGLvm8wcSjfrS1lazELALJ7jo4KgiafOM1y88zv2R21LYGYho2F8w==
X-Received: by 2002:a19:4d6:: with SMTP id 205mr15312643lfe.50.1615215915146;
        Mon, 08 Mar 2021 07:05:15 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id i184sm1385696lfd.205.2021.03.08.07.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:05:14 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net 2/2] net: dsa: mv88e6xxx: Never apply VLANs on standalone ports to VTU
Date:   Mon,  8 Mar 2021 16:04:05 +0100
Message-Id: <20210308150405.3694678-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210308150405.3694678-1-tobias@waldekranz.com>
References: <20210308150405.3694678-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Standalone ports always have VLAN filtering (Port Control 2, 802.1Q
Mode) disabled. So adding VIDs for any VLAN uppers to the VTU does not
make one bit of difference on the ingress filtering, the CPU will
still receive traffic from all VLANs.

It does however needlessly consume a precious global resource, namely
a VID. Therefore, we refine the requirement for accepting a VLAN on a
port by mandating that the port must be offloading a bridge, in which
case the device will actually make use of the filtering.

Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 40 ++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 903d619e08ed..0ba44bcac7da 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1618,6 +1618,38 @@ static int mv88e6xxx_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static bool mv88e6xxx_port_offloads_vlans(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	if (!mv88e6xxx_max_vid(chip))
+		return false;
+
+	/* There are roughly two scenarios in which VLANs may be added
+	 * to a non-bridged port:
+	 *  (a)        (b)     br0
+	 *                     /
+	 *      vlan1       bond0
+	 *       /          /   \
+	 *     swp0       swp0  swp1
+	 *
+	 * Either (a) a VLAN upper is added to a non-bridged port; or
+	 * (b) a port is an indirect lower to a bridge via some
+	 * stacked interface that is not offloaded, e.g. a bond in
+	 * broadcast mode.
+	 *
+	 * We still get a callback in these cases as there are other
+	 * DSA devices which cannot control VLAN filtering per
+	 * port. mv88e6xxx is not one of those, so we can safely
+	 * fallback to software VLANs.
+	 */
+	if (dsa_is_user_port(ds, port) && !dp->bridge_dev)
+		return false;
+
+	return true;
+}
+
 static int
 mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
 			    const struct switchdev_obj_port_vlan *vlan)
@@ -1625,9 +1657,6 @@ mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!mv88e6xxx_max_vid(chip))
-		return -EOPNOTSUPP;
-
 	/* If the requested port doesn't belong to the same bridge as the VLAN
 	 * members, do not support it (yet) and fallback to software VLAN.
 	 */
@@ -1993,6 +2022,9 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	u8 member;
 	int err;
 
+	if (!mv88e6xxx_port_offloads_vlans(ds, port))
+		return -EOPNOTSUPP;
+
 	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
 	if (err)
 		return err;
@@ -2081,7 +2113,7 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	int err = 0;
 	u16 pvid;
 
-	if (!mv88e6xxx_max_vid(chip))
+	if (!mv88e6xxx_port_offloads_vlans(ds, port))
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
-- 
2.25.1

