Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4741E4ADE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgE0QsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbgE0QsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:48:08 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04EBC03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:48:08 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id e10so20823632edq.0
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KHSSGSYFMhLn2TxJeu4ikhApcAsJ0J/jhGYOtcoeCzo=;
        b=uyud49XArDbrnEeWpLkLxAMJ+cOjEhVeetmYyeLPE4Lgkt51ojsUiG+zKKM2bsS3pc
         XzO0rxOf5Pt/JVSFYD5b4/Eox6VrZd1CdJ+NT2rJHQax42JL0rRN3Hq8OXDJNVHpzgr7
         oxrRuClLY/MwVVPR2Y+69Z/H2/33/42AhQMy0/RmenRU26ZRIdwis8018YvAPatyHe79
         PtpTEttDwu9vIKTvsSZqnVa/W42nDG/+z4eEou0PVIL8JQiKB6g5nCrpL2gS5ldDiqx8
         V8201WuZP/WXvIAH7W3k0cChiKag0Qtrl2sr45v9EskfrSQXjPYwf/i3zn47DGNamaMU
         GOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KHSSGSYFMhLn2TxJeu4ikhApcAsJ0J/jhGYOtcoeCzo=;
        b=tq7bz+U92n5a/CSgvbD0Dn+IR+s5CJNjw07xeCKJpczfTUoAnZAJmhWLmg2CpvwSds
         8ePCKRiD5/vwO+futbmL9ChUu7Ek1rANBvUWYVRfq1dHX6a8nAOmYZaSz9+pIyJbRMuq
         QKODgFTDa7FGrp5Vbz7NwvZ2iG9+hhGV3UGsgucXS5na7jUrwHJnm3B9n46yKqnKxUd8
         5mYKRdDJfn+6jrkBjedU6NLJSs9uu4zxCtiJSx2I0Ast6QRvFjRlWb1aZKaGTtJv+OBR
         wkTWVehyvl3IUzFUj4wFtko1nDVlx9t1JKUPxZv/GlzGxwC1ADA5K9w9TVCS5QbZl8z1
         7q5w==
X-Gm-Message-State: AOAM531KDgEGghmzbKU0d6PixtqZxfw8ATe/GyUa+WyWJxBhMxkc4aK3
        CQT3ZpNoq60ppcxHZ1uyyRY=
X-Google-Smtp-Source: ABdhPJzeYRxNmXpAavQCtQabGmcs25TNwSPhaD1J8B5VN9B9oJ0f7tPFn7zYEKmGXjo1xZXGMO+Kow==
X-Received: by 2002:a50:de03:: with SMTP id z3mr23963693edk.50.1590598087406;
        Wed, 27 May 2020 09:48:07 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id dn15sm3525080ejc.26.2020.05.27.09.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:48:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: felix: send VLANs on CPU port as egress-tagged
Date:   Wed, 27 May 2020 19:48:03 +0300
Message-Id: <20200527164803.1083420-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As explained in other commits before (b9cd75e66895 and 87b0f983f66f),
ocelot switches have a single egress-untagged VLAN per port, and the
driver would deny adding a second one while an egress-untagged VLAN
already exists.

But on the CPU port (where the VLAN configuration is implicit, because
there is no net device for the bridge to control), the DSA core attempts
to add a VLAN using the same flags as were used for the front-panel
port. This would make adding any untagged VLAN fail due to the CPU port
rejecting the configuration:

bridge vlan add dev swp0 vid 100 pvid untagged
[ 1865.854253] mscc_felix 0000:00:00.5: Port already has a native VLAN: 1
[ 1865.860824] mscc_felix 0000:00:00.5: Failed to add VLAN 100 to port 5: -16

(note that port 5 is the CPU port and not the front-panel swp0).

So this hardware will send all VLANs as tagged towards the CPU.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a6e272d2110d..66648986e6e3 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -103,13 +103,17 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
+	u16 flags = vlan->flags;
 	u16 vid;
 	int err;
 
+	if (dsa_is_cpu_port(ds, port))
+		flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
+
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		err = ocelot_vlan_add(ocelot, port, vid,
-				      vlan->flags & BRIDGE_VLAN_INFO_PVID,
-				      vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+				      flags & BRIDGE_VLAN_INFO_PVID,
+				      flags & BRIDGE_VLAN_INFO_UNTAGGED);
 		if (err) {
 			dev_err(ds->dev, "Failed to add VLAN %d to port %d: %d\n",
 				vid, port, err);
-- 
2.25.1

