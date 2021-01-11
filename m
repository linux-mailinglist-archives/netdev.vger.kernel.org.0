Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7776D2F24F2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405385AbhALAZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403816AbhAKXLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:11:02 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD9DC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:10:21 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r5so216970eda.12
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dWleEqDop0XlbBTZT54HF7wuYZEULwToDt6bF+/aLWI=;
        b=GZg2m5A3t2ylxVLQv6QsYGBMdD21NiXviZpT9Ddu8zyVgFb0uJ+6SsbVV79VG8n+Kf
         R3JXvub3Xgs3rwR4h/H+XE+8vEK/BMnUg6w7l8ebwxs3X8HRLSymBdTiJ89iygDjX0Th
         hhzRW4lJgiUAQd8Q0HTsD4vrScUgEYRQqao9jfYjNvaMhBk46OeOm2/srU6Uy+EcKskA
         u2vF6OQkbKs94pK1rnZDpDUPQcx1fVUBWAN6wojeNyGe+Y4tKFQ406fdlRkWHF7gQfWb
         R1EL38UZFCeqa+WDJL6utAVMUTphI0snQ2h5mwwsueA+HdYT1jpbRxnycjBShFe9kXZk
         HrTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dWleEqDop0XlbBTZT54HF7wuYZEULwToDt6bF+/aLWI=;
        b=gdUdIcl7Ygbt+B7GB31Isg1BEXCrVr4MvPspnTgbeqoZ6aTQoVuwabiOwpt/t6VmCd
         CYuYPY6F97cACkgImFtMH59t3uiyp1nUNl5yV/RSHRtJwWp46BDRwApwXB6T6XAWe4vA
         Kd4/U3OmyedmXu94GdSPRFMXOz6Tzbn9BgzCxdc3EWW5cMnPq4Dt2A5S2TJVC0XbjrdF
         a2wMzkkQV1ZkSl3tLVaws8C7JdMV/aNds/EJlnqkLNS40vAELcKch0Rn2hR8M3hQXetN
         pt7740X+HOxLxuBUdFqxtfZijPWHeJELd91KQJ1yu2hnMPfBcSke1v9CDTKnx9ruRYno
         Ufmg==
X-Gm-Message-State: AOAM5306P5wLwbQ3B/GiE6sIKmiBxjeizpjvE1xC2T9l2uJF8jG7LG29
        8x97KdDl4rSdyaFAQ0f5uBA=
X-Google-Smtp-Source: ABdhPJzpIeB6oRV93Djo/iCZBrqNhfevF/q/rr8sMaHkJRbep1Tr1uedI0Jnfb3e/iB59vOrdDv3LA==
X-Received: by 2002:a05:6402:1041:: with SMTP id e1mr1261275edu.54.1610406620028;
        Mon, 11 Jan 2021 15:10:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x9sm414374ejd.99.2021.01.11.15.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 15:10:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [PATCH net] net: dsa: unbind all switches from tree when DSA master unbinds
Date:   Tue, 12 Jan 2021 01:09:43 +0200
Message-Id: <20210111230943.3701806-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently the following happens when a DSA master driver unbinds while
there are DSA switches attached to it:

$ echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
------------[ cut here ]------------
WARNING: CPU: 0 PID: 392 at net/core/dev.c:9507
Call trace:
 rollback_registered_many+0x5fc/0x688
 unregister_netdevice_queue+0x98/0x120
 dsa_slave_destroy+0x4c/0x88
 dsa_port_teardown.part.16+0x78/0xb0
 dsa_tree_teardown_switches+0x58/0xc0
 dsa_unregister_switch+0x104/0x1b8
 felix_pci_remove+0x24/0x48
 pci_device_remove+0x48/0xf0
 device_release_driver_internal+0x118/0x1e8
 device_driver_detach+0x28/0x38
 unbind_store+0xd0/0x100

Located at the above location is this WARN_ON:

	/* Notifier chain MUST detach us all upper devices. */
	WARN_ON(netdev_has_any_upper_dev(dev));

Other stacked interfaces, like VLAN, do indeed listen for
NETDEV_UNREGISTER on the real_dev and also unregister themselves at that
time, which is clearly the behavior that rollback_registered_many
expects. But DSA interfaces are not VLAN. They have backing hardware
(platform devices, PCI devices, MDIO, SPI etc) which have a life cycle
of their own and we can't just trigger an unregister from the DSA
framework when we receive a netdev notifier that the master unregisters.

Luckily, there is something we can do, and that is to inform the driver
core that we have a runtime dependency to the DSA master interface's
device, and create a device link where that is the supplier and we are
the consumer. Having this device link will make the DSA switch unbind
before the DSA master unbinds, which is enough to avoid the WARN_ON from
rollback_registered_many.

Note that even before the blamed commit, DSA did nothing intelligent
when the master interface got unregistered either. See the discussion
here:
https://lore.kernel.org/netdev/20200505210253.20311-1-f.fainelli@gmail.com/
But this time, at least the WARN_ON is loud enough that the
upper_dev_link commit can be blamed.

The advantage with this approach vs dev_hold(master) in the attached
link is that the latter is not meant for long term reference counting.
With dev_hold, the only thing that will happen is that when the user
attempts an unbind of the DSA master, netdev_wait_allrefs will keep
waiting and waiting, due to DSA keeping the refcount forever. DSA would
not access freed memory corresponding to the master interface, but the
unbind would still result in a freeze. Whereas with device links,
graceful teardown is ensured. It even works with cascaded DSA trees.

$ echo 0000:00:00.2 > /sys/bus/pci/drivers/fsl_enetc/unbind
[ 1818.797546] device swp0 left promiscuous mode
[ 1819.301112] sja1105 spi2.0: Link is Down
[ 1819.307981] DSA: tree 1 torn down
[ 1819.312408] device eno2 left promiscuous mode
[ 1819.656803] mscc_felix 0000:00:00.5: Link is Down
[ 1819.667194] DSA: tree 0 torn down
[ 1819.711557] fsl_enetc 0000:00:00.2 eno2: Link is Down

This approach allows us to keep the DSA framework absolutely unchanged,
and the driver core will just know to unbind us first when the master
goes away - as opposed to the large (and probably impossible) rework
required if attempting to listen for NETDEV_UNREGISTER.

As per the documentation at Documentation/driver-api/device_link.rst,
specifying the DL_FLAG_AUTOREMOVE_CONSUMER flag causes the device link
to be automatically purged when the consumer fails to probe or later
unbinds. So we don't need to keep the consumer_link variable in struct
dsa_switch.

Fixes: 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA master to get rid of lockdep warnings")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 5a0f6fec4271..cb3a5cf99b25 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -309,8 +309,18 @@ static struct lock_class_key dsa_master_addr_list_lock_key;
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
 	int mtu = ETH_DATA_LEN + cpu_dp->tag_ops->overhead;
+	struct dsa_switch *ds = cpu_dp->ds;
+	struct device_link *consumer_link;
 	int ret;
 
+	/* The DSA master must use SET_NETDEV_DEV for this to work. */
+	consumer_link = device_link_add(ds->dev, dev->dev.parent,
+					DL_FLAG_AUTOREMOVE_CONSUMER);
+	if (!consumer_link)
+		netdev_err(dev,
+			   "Failed to create a device link to DSA switch %s\n",
+			   dev_name(ds->dev));
+
 	rtnl_lock();
 	ret = dev_set_mtu(dev, mtu);
 	rtnl_unlock();
-- 
2.25.1

