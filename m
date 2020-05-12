Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B9A1D0337
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 01:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbgELXvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 19:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELXvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 19:51:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3392C061A0C;
        Tue, 12 May 2020 16:51:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i15so18334477wrx.10;
        Tue, 12 May 2020 16:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yQwyquwrh1Ay02Bi+4bOgGNuAqeE8rJprnl/lt5dApU=;
        b=f/+R4VuzqaR/sV5OZugw90bbQeQJ0fLijy+oFvMvTWe6yaziLrwi1uBpnAZaX4+wKU
         RSAfYwpaBW4Yz8mb5A7GtxrMtG1cdV5UWsMkYNh2xBr0vwAzs/83oaVJzjAaf8eFMxEi
         3Rtx6LpS6YRzSxl+fA3tmzwgn2HEyjvQ2h09JppYI4bP+6Y3gElUYZf9wg8gi9Cd7m44
         GWGzd7rWWTawBGDhKFy5HSXWnhNxLyEHEEQIn9LWaazbuNMVFJrFGfmYC0QolHvksz2x
         LGdqwEMr7pb8b3nH5xcxJKL4yoUY5IdPN8FtDW/ovezAF4ejBho1JLIY6HEwkMlN6C0X
         skYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yQwyquwrh1Ay02Bi+4bOgGNuAqeE8rJprnl/lt5dApU=;
        b=cHqngKkCZkMk2LCNk6F6nMlSWRU16SUuqm/jvL9nUcLsYLOmed9JREOrt6xEVw6uNL
         wvShhDI3YhkXWBRZ0lhH17fvlnb7KqU6kvstsjHcrH9JCToLtIEJLBTM78ZlHM1QhPHn
         EFcucZ0egfM5WFVOWs2DlLE50RR+hKlrQ6UPAXISAn7MZU5BDEMvAtbwyfbt9t5Z4D0h
         pcMlvC644nHacYddFjRnvtYhh+873gOb4iCd4y4aHeTyDm0S9Wp+Xsb/gO6PjuwDlqL9
         Z1utvI0ISu23hQBDhhgcKyUwp+Ig0f+fDDuVBMkn1cY4KHOOasMApNroZn+whNnq1yPq
         hhOA==
X-Gm-Message-State: AGi0PubqcO77/c6QS6QLXDXKI0cUIa2PbissAmyY+AOD90Qn6wUL9qkz
        Vk+mhp7Mlwem8F/gqmf/haQ=
X-Google-Smtp-Source: APiQypJE5qbRal0NG7Hdro55EnmS5tmwQr4jonfAGQUx0kE3lkJ2GvNrNVB+z8GVi67bbW+O2DZ5Fg==
X-Received: by 2002:adf:81e4:: with SMTP id 91mr28912335wra.143.1589327476321;
        Tue, 12 May 2020 16:51:16 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id q144sm1106156wme.0.2020.05.12.16.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 16:51:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, eric.dumazet@gmail.com,
        jiri@mellanox.com, idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: dsa: sja1105: disable rxvlan offload for the DSA master
Date:   Wed, 13 May 2020 02:49:21 +0300
Message-Id: <20200512234921.25460-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On sja1105 operating in best_effort_vlan_filtering mode (when the TPID
of the DSA tags is 0x8100), it can be seen that __netif_receive_skb_core
calls __vlan_hwaccel_clear_tag right before passing the skb to the DSA
packet_type handler.

This means that the tagger does not see the VLAN tag in the skb, nor in
the skb meta data.

The patch that started zeroing the skb VLAN tag is:

  commit d4b812dea4a236f729526facf97df1a9d18e191c
  Author: Eric Dumazet <edumazet@xxxxxxxxxx>
  Date:   Thu Jul 18 07:19:26 2013 -0700

      vlan: mask vlan prio bits

      In commit 48cc32d38a52d0b68f91a171a8d00531edc6a46e
      ("vlan: don't deliver frames for unknown vlans to protocols")
      Florian made sure we set pkt_type to PACKET_OTHERHOST
      if the vlan id is set and we could find a vlan device for this
      particular id.

      But we also have a problem if prio bits are set.

      Steinar reported an issue on a router receiving IPv6 frames with a
      vlan tag of 4000 (id 0, prio 2), and tunneled into a sit device,
      because skb->vlan_tci is set.

      Forwarded frame is completely corrupted : We can see (8100:4000)
      being inserted in the middle of IPv6 source address :

      16:48:00.780413 IP6 2001:16d8:8100:4000:ee1c:0:9d9:bc87 >
      9f94:4d95:2001:67c:29f4::: ICMP6, unknown icmp6 type (0), length 64
             0x0000:  0000 0029 8000 c7c3 7103 0001 a0ae e651
             0x0010:  0000 0000 ccce 0b00 0000 0000 1011 1213
             0x0020:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
             0x0030:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233

      It seems we are not really ready to properly cope with this right now.

      We can probably do better in future kernels :
      vlan_get_ingress_priority() should be a netdev property instead of
      a per vlan_dev one.

      For stable kernels, lets clear vlan_tci to fix the bugs.

      Reported-by: Steinar H. Gunderson <sesse@xxxxxxxxxx>
      Signed-off-by: Eric Dumazet <edumazet@xxxxxxxxxx>
      Signed-off-by: David S. Miller <davem@xxxxxxxxxxxxx>

The patch doesn't say why "we are not really ready to properly cope with
this right now", and hence why the best solution is to remove the VLAN
tag from skb's that don't have a local VLAN sub-interface interested in
them. And I have no idea either.

But the above patch has a loophole: if the VLAN tag is not
hw-accelerated, it isn't removed from the skb if there is no VLAN
sub-interface interested in it (our case). So we are hooking into the
.ndo_fix_features callback of the DSA master and clearing the rxvlan
offload feature, so the DSA tagger will always see the VLAN as part of
the skb data. This is symmetrical with the ETH_P_DSA_8021Q case and does
not need special treatment in the tagger.

If there was an API by which the dsa tag_8021q module would declare its
interest in servicing VLANs 1024-3071, such that the packets wouldn't be
classified as PACKET_OTHERHOST, and if that API wasn't as tightly
integrated with the 8021q module as vlan_find_dev/vlan_group_set_device
are, I would be interested in using it, but so far I couldn't find it.
With this patch, even though the frames still are PACKET_OTHERHOST, at
least the VLAN tag reaches far enough that the DSA packet_type handler
sees and consumes it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |  2 ++
 include/net/dsa.h                      |  3 +++
 net/dsa/master.c                       | 13 +++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 44ce7882dfb1..24757c8adfe7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2912,6 +2912,8 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
+	ds->disable_master_rxvlan = true;
+
 	ds->configure_vlan_while_not_filtering = true;
 
 	rc = sja1105_setup_devlink_params(ds);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 50389772c597..3938b20461de 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -299,6 +299,9 @@ struct dsa_switch {
 	 */
 	bool			pcs_poll;
 
+	/* Necessary for tagging protocols such as tag_8021q. */
+	bool			disable_master_rxvlan;
+
 	/* For switches that only have the MRU configurable. To ensure the
 	 * configured MTU is not exceeded, normalization of MRU on all bridged
 	 * interfaces is needed.
diff --git a/net/dsa/master.c b/net/dsa/master.c
index a621367c6e8c..12e8126bc29c 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -197,6 +197,18 @@ static int dsa_master_get_phys_port_name(struct net_device *dev,
 	return 0;
 }
 
+static netdev_features_t dsa_master_fix_features(struct net_device *dev,
+						 netdev_features_t features)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	struct dsa_switch *ds = cpu_dp->ds;
+
+	if (ds->disable_master_rxvlan)
+		features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+
+	return features;
+}
+
 static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
@@ -278,6 +290,7 @@ static int dsa_master_ndo_setup(struct net_device *dev)
 		memcpy(ops, cpu_dp->orig_ndo_ops, sizeof(*ops));
 
 	ops->ndo_get_phys_port_name = dsa_master_get_phys_port_name;
+	ops->ndo_fix_features = dsa_master_fix_features;
 	ops->ndo_do_ioctl = dsa_master_ioctl;
 
 	dev->netdev_ops  = ops;
-- 
2.17.1

