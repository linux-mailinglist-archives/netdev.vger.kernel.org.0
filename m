Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC24B26490E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbgIJPvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 11:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731349AbgIJPtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 11:49:17 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AA9C061345
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 08:07:43 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g4so6697956edk.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 08:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=P9Lo7yQxpL4GZn+0SsUWqRwczg9U1nOWAmjeDRkXVz8=;
        b=NGIzDZYOzeQoJdRX9AYMZY18LQB6u1/RemChkbgBentec33vxFv/0VLTgldSRI3rP9
         pO6fGn24uga+nfR2UjP3si08VLR2p69d4aNZdBQzrmAPs9H8e85L1vnGcMYhqYdUVVeK
         TeInYJbZZ1YsKyjm78A8r0DaSXj517kN7ePL+elJSdvtezPfaga7I3AX/5vOwDnVN7WR
         wR/6lv40TdgoSl0+8XIMVw8lfS4ysXK6X8oWRnMEp8nOVbRzpMGb5ulBjyILzBT87mhe
         Xddqt0Mw5qju1wcsIHAGLkZBauuO0raRxUb+3JfeCoj+l3r5GJ0J/HSVzYMVrYjEVB+z
         tkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=P9Lo7yQxpL4GZn+0SsUWqRwczg9U1nOWAmjeDRkXVz8=;
        b=HIs794qoRcMGPyvlP7t+MRlfJkkk8XUQ04med/bulzKyp5iqEphlifirkqlujrKmwM
         JpQnNcLA0hwDau+JVRozfdDl4qcVxye7Gd1eLMTburWLcjNb/O3PaVDlanLktAKUMmkN
         FCW/nKd4PgeXQvLKGks859H1WIaPv6vJYXRgdySiX2zNe5gyaSSq39Bhf3W3EeIVAwWm
         bldqhr2d7Go+cj66Ctg81owmt10FnwZGXpDExRiMd3NcR5SywmDdNaAce73m8UjZrLkH
         Z6o/EY+qnKHNEwdehq9Tj+hpgl3NiWN8gkatYk7Bb36lpCvKsX7sJ90PORniyMSLhLqu
         6hOA==
X-Gm-Message-State: AOAM530rhiGACRj9DY6mdpMTzVdZ+jZEevl31L/QrIENGgSi7V4P8wUQ
        YwwSGk5qrgNWSWtf4Et6auDdVa6JvLM=
X-Google-Smtp-Source: ABdhPJw5bwXsv+tVlF2hC/WwJSz51xbLW0jtiqIgck8IMi10n89ZG6DB6Q9lwyc7iilq+I+XIsp+Ig==
X-Received: by 2002:a50:cd5e:: with SMTP id d30mr9540495edj.190.1599750461248;
        Thu, 10 Sep 2020 08:07:41 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id v6sm7883828edj.59.2020.09.10.08.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 08:07:40 -0700 (PDT)
Date:   Thu, 10 Sep 2020 18:07:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: VLAN filtering with DSA
Message-ID: <20200910150738.mwhh2i6j2qgacqev@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Problem background:

Most DSA switch tags shift the EtherType to the right, causing the
master to not parse the VLAN as VLAN.
However, not all switches do that (example: tail tags), and if the DSA
master has "rx-vlan-filter: on" in ethtool -k, then we have a problem.
Therefore, I was thinking we could populate the VLAN table of the
master, just in case, so that it can work with a VLAN filtering master.
It would look something like this:

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 19b98a7231ec..b8aca2301c59 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -307,9 +307,10 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 			      const struct switchdev_obj *obj,
 			      struct switchdev_trans *trans)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan;
-	int err;
+	int vid, err;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
@@ -336,6 +337,12 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (err)
 		return err;
 
+	for (vid = vlan.vid_begin; vid <= vlan.vid_end; vid++) {
+		err = vlan_vid_add(master, htons(ETH_P_8021Q), vid);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -379,8 +386,10 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 static int dsa_slave_vlan_del(struct net_device *dev,
 			      const struct switchdev_obj *obj)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan *vlan;
+	int vid, err;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
@@ -396,7 +405,14 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vlan_del(dp, vlan);
+	err = dsa_port_vlan_del(dp, vlan);
+	if (err)
+		return err;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
+		vlan_vid_del(master, htons(ETH_P_8021Q), vid);
+
+	return 0;
 }
 
 static int dsa_slave_port_obj_del(struct net_device *dev,
@@ -1241,6 +1257,7 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
@@ -1294,12 +1311,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	if (ret)
 		return ret;
 
-	return 0;
+	return vlan_vid_add(master, proto, vid);
 }
 
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.vid_begin = vid,
@@ -1332,7 +1350,13 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vlan_del(dp, &vlan);
+	ret = dsa_port_vlan_del(dp, &vlan);
+	if (ret)
+		return ret;
+
+	vlan_vid_del(master, proto, vid);
+
+	return 0;
 }
 
 struct dsa_hw_port {
-- 
2.25.1


Ok, now the problem.
This works, except when the master is another DSA switch.
You see, I hit this -EBUSY condition:

static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
				     u16 vid)
{
	...

	/* Check for a possible bridge VLAN entry now since there is no
	 * need to emulate the switchdev prepare + commit phase.
	 */
	if (dp->bridge_dev) {
		...
		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
		 * device, respectively the VID is not found, returning
		 * 0 means success, which is a failure for us here.
		 */
		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
		if (ret == 0)
			return -EBUSY;
	}
}

Introduced by:

commit 061f6a505ac33659eab007731c0f6374df39ab55
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed Feb 20 14:35:39 2019 -0800

    net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation

    In order to properly support VLAN filtering being enabled/disabled on a
    bridge, while having other ports being non bridge port members, we need
    to support the ndo_vlan_rx_{add,kill}_vid callbacks in order to make
    sure the non-bridge ports can continue receiving VLAN tags, even when
    the switch is globally configured to do ingress/egress VID checking.

    Since we can call dsa_port_vlan_{add,del} with a bridge_dev pointer
    NULL, we now need to check that in these two functions.

    We specifically deal with two possibly problematic cases:

    - creating a bridge VLAN entry while there is an existing VLAN device
      claiming that same VID

    - creating a VLAN device while there is an existing bridge VLAN entry
      with that VID

    Those are both resolved with returning -EBUSY back to user-space.

    Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Florian, can you please reiterate what is the problem with calling
vlan_vid_add() with a VLAN that is installed by the bridge?

The effect of vlan_vid_add(), to my knowledge, is that the network
interface should add this VLAN to its filtering table, and not drop it.
So why return -EBUSY?

Thanks,
-Vladimir
