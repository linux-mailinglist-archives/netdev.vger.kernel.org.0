Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3160B62CDE2
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbiKPWkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbiKPWkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:40:16 -0500
X-Greylist: delayed 918 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Nov 2022 14:40:13 PST
Received: from mx0a-003ede02.pphosted.com (mx0a-003ede02.pphosted.com [205.220.169.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C27B764B
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:40:13 -0800 (PST)
Received: from pps.filterd (m0286617.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AGI9WcR031366
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:24:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=ppemail; bh=pniGg+mo8JPAEel9b7ySkPiN8PnbhsCZHkgUclenK5M=;
 b=KdVP2bvV6w8IibRTbd/HQRmzPtgrUlWEoXmalrLoOTBY9fwdlONk3g09bKKAl3gqHLDI
 VQKk+4UAdfmAllczXPd/BLLRtO8Vsa8Vx0RJNqE0FJqstbH7N9a6/scPKbasQhmbyQrY
 MkyyEw9EcwOxC+sFWH+x4HFjrIbudGTvs74nhXkW3bwwnd+o0RlJePJZrYdHW55hXYCF
 xOzvQnR95YE/PQ9yidDfV/13BhTnHwug5dvV4uftSO5DgrQ0NLG3ZqZ7OsFd2UZocmmU
 IJ1iK9fDHajjkCp+3TFl9R1Jp1phoJBRzJFnu5SfYAbPD81/5GclzQ5sCGUnMQ0erXYs ew== 
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3kvrjtgrsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:24:54 -0800
Received: by mail-pl1-f197.google.com with SMTP id n12-20020a170902e54c00b00188515e81a6so14935634plf.23
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pniGg+mo8JPAEel9b7ySkPiN8PnbhsCZHkgUclenK5M=;
        b=pCBaa+kxr+OHG02ZwJ2znEP+cNZEI/vTrHyh8C2rkgNfK657RT85FzirQPiqvRyiuH
         MkbvDwGlg0CExc6IYbMFCReuT6zFV+oDEy2UduSMu1P8hZpbUb+thkV3Y+giSkpCWzxm
         Lgkl2bEtm5k3VlipLipik0+dsEVbNiDKmWKceC7t1wEPHvMqcebooRWv9b2XABC8WO9U
         wdGng7UZ7dHu73GEJVDLXb0RSt7FcMSzxs8/qZPZe8KBvtGmJSTHX2nUyQOyViDG4d32
         DtLwVb5FY4y2r1F85YpC95qxzlVKsPNS6KkAawnaXJwHO44PpNIO4KbQPuHcKXlp+kb8
         qLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pniGg+mo8JPAEel9b7ySkPiN8PnbhsCZHkgUclenK5M=;
        b=ZcOP6feVxpBW8wkKBS7XImlQ5KFQiefPlI6Nc/JUNq0GwdrYhCjU69ZgNhETWOfcYi
         L70cZqf7nAMg+4VkmKopyKXNGah/rdIFUV9TQZj1Z+acZPsNGi2rshhCAatcGujskz/g
         bxb44K8kzU98mnICuOi/KMN9UKW62XkQTQ89nguJ/8gfNabQWqxhN+i4GeM2HblWU+72
         vpC4t/v6NfAHbVegr1oWFzx0tmKCiTJe18tcjbwBLcYzDCoo2mJMTBsYZoA1cYIeURAz
         jEfANVKmycrepmIzHenkJnpZ+yohA4f5jJFQim6gwISFrAl1PZIXkb2iYbiz27QhJgyl
         UhEQ==
X-Gm-Message-State: ANoB5pnb1yFDg5L2s0/dAyeb0Op9RWzYBMD8u8Z6XprLeN6KmUw2XPA6
        7AZafmC9hZa0oRxUEJKybSQf9PMC6LbvqYMKIGBuDKWfUgq6zenO/S+Feqz69mNpOceU/bLACWa
        MG4t8/SlsQWK6chxH
X-Received: by 2002:a63:134e:0:b0:452:86db:3e04 with SMTP id 14-20020a63134e000000b0045286db3e04mr22148377pgt.175.1668637493004;
        Wed, 16 Nov 2022 14:24:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf68oJW2icuPoTGYQDXgdxgiMhJh5EZRkMqv6FJ6qBR3QesxSbw/cwEz1+xUVH64hJZ6v0DduQ==
X-Received: by 2002:a63:134e:0:b0:452:86db:3e04 with SMTP id 14-20020a63134e000000b0045286db3e04mr22148322pgt.175.1668637492074;
        Wed, 16 Nov 2022 14:24:52 -0800 (PST)
Received: from 9RTVDW2-DT.corp.robot.car ([128.177.102.6])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902e54f00b001873aa85e1fsm12899651plf.305.2022.11.16.14.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 14:24:51 -0800 (PST)
From:   Steve Williams <steve.williams@getcruise.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Williams <steve.williams@getcruise.com>
Subject: [PATCH net-next] sandlan: Add the sandlan virtual network interface
Date:   Wed, 16 Nov 2022 14:24:29 -0800
Message-Id: <20221116222429.7466-1-steve.williams@getcruise.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: GSvVWai8ceR3m6OdjzOH2io8GrTdwNFo
X-Proofpoint-GUID: GSvVWai8ceR3m6OdjzOH2io8GrTdwNFo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1011 lowpriorityscore=0 adultscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160153
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Williams <steve.williams@getcruise.com>

This is a virtual driver that is useful for testing network protocols
or other complex networking without real ethernet hardware. Arbitrarily
complex networks can be created and simulated by creating virtual network
devices and assigning them to named broadcast domains, and all the usual
ethernet-aware tools can operate on that network.

This is different from e.g. the tun/tap device driver in that it is not
point-to-point. Virtual lans can be created that support broadcast,
multicast, and unicast traffic. The sandlan nics are not tied to a
process, but are instead persistent, have a mac address, can be queried
by iproute2 tools, etc., as if they are physical ethernet devices. This
provides a platform where, combined with netns support, distributed
systems can be emulated. These nics can also be opened in raw mode, or
even bound to other drivers that expect ethernet devices (vlans, etc),
as a way to test and develop ethernet based network protocols.

A sandlan lan is not a tunnel. Packets are dispatched from a source
nic to destination nics as would be done on a physical lan. If you
want to create a nic to tunnel into an emulation, or to wrap packets
up and forward them elsewhere, then you don't want sandlan, you want
to use tun/tap or other tunneling support.

Signed-off-by: Stephen Williams <steve.williams@getcruise.com>
---
 Documentation/networking/index.rst     |   1 +
 Documentation/networking/sandlan.rst   | 136 ++++++++++++
 MAINTAINERS                            |   6 +
 drivers/net/Kconfig                    |  12 ++
 drivers/net/Makefile                   |   1 +
 drivers/net/sandlan/Makefile           |  10 +
 drivers/net/sandlan/sandlan_dev.c      | 287 +++++++++++++++++++++++++
 drivers/net/sandlan/sandlan_dispatch.c | 156 ++++++++++++++
 drivers/net/sandlan/sandlan_domain.c   | 203 +++++++++++++++++
 drivers/net/sandlan/sandlan_main.c     |  55 +++++
 drivers/net/sandlan/sandlan_netns.c    |  63 ++++++
 drivers/net/sandlan/sandlan_priv.h     |  97 +++++++++
 drivers/net/sandlan/sandlan_sysfs.c    | 219 +++++++++++++++++++
 13 files changed, 1246 insertions(+)
 create mode 100644 Documentation/networking/sandlan.rst
 create mode 100644 drivers/net/sandlan/Makefile
 create mode 100644 drivers/net/sandlan/sandlan_dev.c
 create mode 100644 drivers/net/sandlan/sandlan_dispatch.c
 create mode 100644 drivers/net/sandlan/sandlan_domain.c
 create mode 100644 drivers/net/sandlan/sandlan_main.c
 create mode 100644 drivers/net/sandlan/sandlan_netns.c
 create mode 100644 drivers/net/sandlan/sandlan_priv.h
 create mode 100644 drivers/net/sandlan/sandlan_sysfs.c

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4f2d1f682a18..918ba3fd84af 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -94,6 +94,7 @@ Contents:
    regulatory
    representors
    rxrpc
+   sandlan
    sctp
    secid
    seg6-sysctl
diff --git a/Documentation/networking/sandlan.rst b/Documentation/networking/sandlan.rst
new file mode 100644
index 000000000000..2164d4d7f632
--- /dev/null
+++ b/Documentation/networking/sandlan.rst
@@ -0,0 +1,136 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========================
+SANDLAN VIRTUAL LAN DRIVER
+==========================
+
+Copyright |copy| 2022 Cruise LLC
+
+OVERVIEW
+========
+
+The sandlan NIC is a pseudo-network interface that can be used to test
+or experiment with LAN protocols. All the sandlan NICs connect to an
+abstract LAN, and the devices act like ethernet devices. That means
+that the NICs have MAC addresses, packets sent out are given Ethernet
+headers, and NICs receive packets based on the NIC addressing.
+
+Sandlan NICs work with all the usual ifconfig and ip commands, meaning
+you can set/get addresses, bind protocols, open as sockets, etc. It is
+even possible to set a NIC to promiscuous mode and open with tools
+like wireshark and tcpdump.
+
+Besides the virtual NICs, the sandlan driver also provides virtual
+LANs, called domains. NICs in a domain can communicate with each other
+as if they were physically connected, and broadcasts in a domain are
+received by all the NICs in a domain. Every NIC is in a default domain
+(called "-") if not explicitly placed in any other domain.
+
+EXAMPLE
+=======
+
+In this example, we create two NICs in a shared domain, and also create
+a 3rd in the sae domain that wireshark can use to snoop on the network
+traffic.
+
+First, make sure the interfaces exist::
+
+  echo +sandlan0 > /sys/class/net/sandlan_interfaces
+  echo +sandlan1 > /sys/class/net/sandlan_interfaces
+  echo +sandlan2 > /sys/class/net/sandlan_interfaces
+
+While we're at it, demonstrate sandlan domains. Create a domain and
+put all the interfaces in that domain. Note that this is a
+connectivity domain, and not the same as netns namespaces::
+
+  echo +side > /sys/class/net/sandlan_domains
+  echo side > /sys/class/net/sandlan0/sandlan/domain
+  echo side > /sys/class/net/sandlan1/sandlan/domain
+  echo side > /sys/class/net/sandlan2/sandlan/domain
+
+Configure the new interfaces, and put them in netns namespaces::
+
+  host0=192.168.10.1
+  host1=192.168.10.2
+  host2=192.168.10.3
+
+  ip netns add host0
+  ip link set sandlan0 netns host0
+  ip netns exec host0 ifconfig sandlan0 $host0 up
+
+  ip netns add host1
+  ip link set sandlan1 netns host1
+  ip netns exec host1 ifconfig sandlan1 $host1 up
+
+  ip netns add host2
+  ip link set sandlan2 netns host2
+  ip netns exec host2 ifconfig sandlan2 $host2 up
+
+Finally, start up some processes in the netns namespaces so that
+each process can see the network in action::
+
+  ip netns exec host0 konsole &
+  ip netns exec host1 konsole &
+  ip netns exec host2 wireshark -i sandlan2
+
+Notice that the two konsole processes are now in netns namespaces
+so they can see their respective sandlan nics, and can communicate
+through them as if they are any other ethernet nic. The wireshark
+process is in a 3rd netns namespace and is setup to connect to sandlan2.
+Wireshark sets the sandlan2 NIC to promiscuous mode, so it can see all
+of the traffic in the "side" domain. Networks can be made arbitrarily
+complex with these tools.
+
+
+THE SYSFS INTERFACE
+===================
+
+This is a summary of the sysfs interface for creating sandlan nics
+and LANs.
+
+* /sys/class/net/sandlan_interfaces [r/w]
+
+On read, this file returns the names of the interfaces, one interface
+per line.
+
+On write, the file interprets data written to it as commands, one
+command at a time. The commands are formatted simply:
+
+     [+-]<name format>
+
+If the first character is "+", the command creates a new interface
+with the name given by the name format string. So for example, the
+command:
+
+  $ echo +sandlan0 > /sys/class/net/sandlan_interfaces
+
+creates a single interface, "sandlan0". The format may include a "%d",
+and the driver will replace it with a unique number, i.e.:
+
+  $ echo '+sandlan%d' > /sys/class/net/sandlan_interfaces
+
+Newly created sandlan NICs have default MAC addresses, but "ip" tools
+are able to set the addresses as desired.
+
+* /sys/class/net/sandlan_domains [r/w]
+
+On read, this file returns the names of the domains (not including
+default) one domain per line. Initially, this file may be empty.
+
+On write, the file interprets data written to it as commands, one
+command at a time. The commands are formatted simply:
+
+     [+-]<name>
+
+If the first character is "+", the command creates a new domain with
+the name given, and if the first character is "-" the named domain is
+deleted. The default domain cannot be deleted.
+
+* /sys/class/net/<nic>/sandlan/domain [r/w]
+
+This interface is used to place a nic into a domain. The contents of
+this file is the name of the domain that the nic is in, or "-" if it
+is in the default. Write into this file the name of the domain to
+join, and the nic will be detached from its current domain and moved
+to the new domain. If the domain is removed, then the nic is moved to
+the default domain.
diff --git a/MAINTAINERS b/MAINTAINERS
index 14ee1c72d01a..93d4e1e9808e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18322,6 +18322,12 @@ R:	Marc Murphy <marc.murphy@sancloud.com>
 S:	Supported
 F:	arch/arm/boot/dts/am335x-sancloud*
 
+SANDLAN NET DEVICE
+M:	Steve Williams <steve.williams@getcruise.com>
+S:	Maintained
+F:	Documentation/networking/sandlan.rst
+F:	drivers/net/sandlan/
+
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwanem@gmail.com>
 S:	Maintained
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9e63b8c43f3e..bbb9632bac6e 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -631,4 +631,16 @@ config NETDEV_LEGACY_INIT
 	  Drivers that call netdev_boot_setup_check() should select this
 	  symbol, everything else no longer needs it.
 
+config SANDLAN
+	tristate "Sandlan virtual lan driver"
+	help
+	  This is a driver that allows creation of virtual ethernet LANs
+	  for testing protocols, higher level drivers, etc. The sandlan devices
+	  can be created freely, and act like ethernet devices, complete with
+	  mac addresses and other ethernet device properties. The devices
+	  can also be put into netns scopes, for some degree of virtualization.
+
+	  If you don't know what this is, then you don't need it and set
+	  this to "n".
+
 endif # NETDEVICES
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 6ce076462dbf..e0669b978922 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -89,3 +89,4 @@ thunderbolt-net-y += thunderbolt.o
 obj-$(CONFIG_USB4_NET) += thunderbolt-net.o
 obj-$(CONFIG_NETDEVSIM) += netdevsim/
 obj-$(CONFIG_NET_FAILOVER) += net_failover.o
+obj-$(CONFIG_SANDLAN) += sandlan/
diff --git a/drivers/net/sandlan/Makefile b/drivers/net/sandlan/Makefile
new file mode 100644
index 000000000000..1737bd01bc1e
--- /dev/null
+++ b/drivers/net/sandlan/Makefile
@@ -0,0 +1,10 @@
+
+
+obj-$(CONFIG_SANDLAN) += sandlan.o
+
+sandlan-objs := sandlan_main.o \
+	sandlan_dev.o \
+	sandlan_dispatch.o \
+	sandlan_domain.o \
+	sandlan_netns.o \
+	sandlan_sysfs.o
diff --git a/drivers/net/sandlan/sandlan_dev.c b/drivers/net/sandlan/sandlan_dev.c
new file mode 100644
index 000000000000..9c5b6f19c0ac
--- /dev/null
+++ b/drivers/net/sandlan/sandlan_dev.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2022 Cruise LLC
+ * Stephen Williams <steve.williams@getcruise.com>
+ *
+ * Sandlan abstract ethernet LAN/device
+ */
+
+# include  "sandlan_priv.h"
+# include  <linux/netdevice.h>
+# include  <linux/etherdevice.h>
+# include  <linux/list.h>
+# include  <linux/printk.h>
+
+/* This is a table of all the sandlan interfaces that exist.
+ *
+ * There is also a lock here. Any function that manipulates the list
+ * of devices (including the domain configuration of a device) must
+ * hold this lock for write in order to protect the access from normal
+ * operation. And functions that merely follow the list of devices
+ * (again including domain configurations) must hold the lock for read
+ * to protect it from the device list changing.
+ */
+static LIST_HEAD(sandlan_devs_list);
+struct rw_semaphore sandlan_devs_mutex;
+
+/* This instance counter is only used for assigning all the devices an
+ * initial unique MAC id. It does not necessarily count the number if
+ * devices in existence.
+ */
+static u32 instance_counter;
+
+/* Add the device to a global table of sandlan devices.
+ */
+static int add_dev_to_list(struct sandlan_priv *xsp)
+{
+	down_write(&sandlan_devs_mutex);
+	list_add_tail(&xsp->devs_list, &sandlan_devs_list);
+	up_write(&sandlan_devs_mutex);
+	return 0;
+}
+
+static int sandlan_open(struct net_device *dev)
+{
+	struct sandlan_priv *xsp = netdev_priv(dev);
+
+	xsp->rx_packets = 0;
+	xsp->tx_packets = 0;
+	xsp->rx_bytes = 0;
+	xsp->tx_bytes = 0;
+	xsp->rx_dropped = 0;
+	xsp->tx_dropped = 0;
+
+	netif_tx_start_all_queues(dev);
+	return 0;
+}
+
+static int sandlan_stop(struct net_device *dev)
+{
+	netif_tx_stop_all_queues(dev);
+	return 0;
+}
+
+/* Start transmit -- The skb already contains a fully formatted
+ * packet, we just need to deliver it to the "wire", which in this
+ * case means dispatching it to other devices that may receive it.
+ */
+static netdev_tx_t sandlan_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	int len;
+	unsigned char *data, shortest_packet[ETH_ZLEN];
+	struct sandlan_priv *xsp = netdev_priv(dev);
+
+	/* Get the data from the skb. */
+	data = skb->data;
+	len = skb->len;
+
+	/* If the packet is shorter then the shortest packet, then
+	 * make the packet longer. This doesn't really need to be done
+	 * for software nics, but better simulates ethernet behavior.
+	 */
+	if (len < sizeof(shortest_packet)) {
+		memset(shortest_packet, 0, sizeof(shortest_packet));
+		memcpy(shortest_packet, data, len);
+		data = shortest_packet;
+		len = sizeof(shortest_packet);
+	}
+
+	/* Transmit statistics. */
+	xsp->tx_packets += 1;
+	xsp->tx_bytes += len;
+
+	/* Send the packet. */
+	sandlan_dispatch(dev, data, len);
+
+	/* No longer need the skb. */
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
+
+static void sandlan_get_stats64(struct net_device *dev,
+				struct rtnl_link_stats64 *storage)
+{
+	struct sandlan_priv *xsp = netdev_priv(dev);
+
+	storage->rx_packets = xsp->rx_packets;
+	storage->tx_packets = xsp->tx_packets;
+	storage->rx_bytes = xsp->rx_bytes;
+	storage->tx_bytes = xsp->tx_bytes;
+	storage->rx_dropped = xsp->rx_dropped;
+	storage->tx_dropped = xsp->tx_dropped;
+}
+
+static const struct net_device_ops sandlan_netdev_ops = {
+	.ndo_open       = sandlan_open,
+	.ndo_stop       = sandlan_stop,
+	.ndo_start_xmit = sandlan_start_xmit,
+	.ndo_set_mac_address = eth_mac_addr,
+	.ndo_get_stats64 = sandlan_get_stats64
+};
+
+/* The kernel calls this to initialize each device. This is a basic
+ * initialization, where I set up the common properties of the device.
+ *
+ * This function does not need rtnl_lock() since it is called within
+ * the alloc_netdev, before the device is registered. It is protected
+ * from concurrency by being unregistered.
+ */
+static void sandlan_init(struct net_device *dev)
+{
+	struct sandlan_priv *xsp;
+	/* Basic setup. This device is kinda like ethernet. */
+	ether_setup(dev);
+
+	dev->netdev_ops = &sandlan_netdev_ops;
+
+	/* Set the default MAC address for this device. Pick a number
+	 * that is guaranteed to be unique within the scope of this
+	 * LAN. The user may set the addresses to whatever, but this
+	 * is a good and safe starting point.
+	 */
+	{
+		struct sockaddr use_addr;
+		u32 unique_number = instance_counter++;
+
+		use_addr.sa_family = AF_PACKET;
+		use_addr.sa_data[0] = 0x22; /* Locally administered / Unicast */
+		use_addr.sa_data[1] = 0xaa;
+		use_addr.sa_data[2] = (unique_number >> 24) & 0xff;
+		use_addr.sa_data[3] = (unique_number >> 16) & 0xff;
+		use_addr.sa_data[4] = (unique_number >>  8) & 0xff;
+		use_addr.sa_data[5] = (unique_number >>  0) & 0xff;
+		dev->netdev_ops->ndo_set_mac_address(dev, &use_addr);
+	}
+
+	xsp = netdev_priv(dev);
+	xsp->dev = dev;
+	/* Put the interface into the default domain */
+	INIT_LIST_HEAD(&xsp->nodes_list);
+	xsp->domain = 0;
+	sandlan_dom_add_node(0, xsp);
+
+	/* Setup the sysfs API. */
+	sandlan_device_sysfs(xsp);
+}
+
+int sandlan_dev_alloc(const char *name_pattern)
+{
+	int rc;
+	struct net_device *dev;
+	struct sandlan_priv *xsp;
+
+	dev = alloc_netdev(sizeof(struct sandlan_priv), name_pattern,
+			   NET_NAME_ENUM, sandlan_init);
+	if (dev == 0) {
+		pr_warn("sandlan: Unable to allocate sandlan device.\n");
+		return -ENOMEM;
+	}
+
+	/* Initialize some key parts of the priv structure. */
+	xsp = netdev_priv(dev);
+	INIT_LIST_HEAD(&xsp->devs_list);
+
+	/* Now add the device to the list of sandlan devices. */
+	rc = add_dev_to_list(xsp);
+	if (rc < 0) {
+		netdev_info(dev, "Unable to list new sandlan device.\n");
+		free_netdev(dev);
+		return rc;
+	}
+
+	/* Ready. Register the device. (Need not be rtnl_lock()'ed) */
+	rc = register_netdev(dev);
+	if (rc < 0) {
+		free_netdev(dev);
+		return rc;
+	}
+
+	return 0;
+}
+
+/* Linear scan for the device with the given name, and remove it.
+ */
+static int do_dev_free_byname(const char *name)
+{
+	struct net_device *dev;
+	struct list_head *cur, *tmp;
+	struct sandlan_priv *xsp;
+
+	list_for_each_safe(cur, tmp, &sandlan_devs_list) {
+		xsp = list_entry(cur, struct sandlan_priv, devs_list);
+		dev = xsp->dev;
+		if (dev == 0)
+			continue;
+		if (strcmp(dev->name, name) != 0)
+			continue;
+
+		list_del(&xsp->devs_list);
+		do_sandlan_dom_release_node(xsp);
+		unregister_netdev(dev);
+		free_netdev(dev);
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
+int sandlan_dev_free_byname(const char *name)
+{
+	int rc;
+
+	down_write(&sandlan_devs_mutex);
+	rc = do_dev_free_byname(name);
+	up_write(&sandlan_devs_mutex);
+	return rc;
+}
+
+int sandlan_dev_init(void)
+{
+	init_rwsem(&sandlan_devs_mutex);
+	return 0;
+}
+
+void sandlan_dev_release_all(void)
+{
+	struct list_head *cur, *tmp;
+	struct net_device *dev;
+	struct sandlan_priv *xsp;
+
+	down_write(&sandlan_devs_mutex);
+	list_for_each_safe(cur, tmp, &sandlan_devs_list) {
+		list_del(cur);
+		xsp = list_entry(cur, struct sandlan_priv, devs_list);
+		dev = xsp->dev;
+		do_sandlan_dom_release_node(xsp);
+		unregister_netdev(dev);
+		free_netdev(dev);
+	}
+	up_write(&sandlan_devs_mutex);
+}
+
+ssize_t sandlan_dev_show_interfaces(char *buf, size_t len)
+{
+	struct list_head *cur;
+	ssize_t res = 0;
+	int rc;
+
+	down_read(&sandlan_devs_mutex);
+	list_for_each(cur, &sandlan_devs_list) {
+		struct sandlan_priv *xsp = list_entry(cur, struct sandlan_priv, devs_list);
+		struct net_device *dev = xsp->dev;
+
+		rc = snprintf(buf, len, "%s\n", dev->name);
+		if (rc >= len) {
+			buf += len;
+			res += len;
+			len = 0;
+			break;
+		}
+		buf += rc;
+		res += rc;
+		len -= rc;
+	}
+	up_read(&sandlan_devs_mutex);
+
+	return res;
+}
diff --git a/drivers/net/sandlan/sandlan_dispatch.c b/drivers/net/sandlan/sandlan_dispatch.c
new file mode 100644
index 000000000000..3c27256411b4
--- /dev/null
+++ b/drivers/net/sandlan/sandlan_dispatch.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2022 Cruise LLC
+ * Stephen Williams <steve.williams@getcruise.com>
+ *
+ * Sandlan abstract ethernet LAN/device
+ */
+
+# include  "sandlan_priv.h"
+
+# include  <linux/netdevice.h>
+# include  <linux/etherdevice.h>
+# include  <linux/printk.h>
+
+/* The sandlan_dispatch() function sends a packet out the passed
+ * sandlan NIC device. The dispatcher uses the domain of the NIC to
+ * find all the other nodes that are connected and that may receive
+ * the packet.
+ */
+
+/* Deliver a packet from the specified source to the given target
+ * device. Allocate an skb, copy the data in, and bind the sdb to the target.
+ */
+static void deliver(struct net_device *src, unsigned char *data, int len,
+		    struct net_device *dev)
+{
+	struct sandlan_priv *xsp = netdev_priv(dev);
+	struct sk_buff *skb;
+	int rc;
+
+	skb = netdev_alloc_skb(dev, len + 2);
+	if (!skb) {
+		xsp->rx_dropped += 1;
+		return;
+	}
+
+	xsp->rx_packets += 1;
+	xsp->rx_bytes += len;
+
+	/* Put the data into the skb, and bind the skb to the
+	 * receiving dev.
+	 */
+	skb_put_data(skb, data, len);
+	skb->protocol = eth_type_trans(skb, dev);
+	rc = netif_receive_skb(skb);
+	if (rc == NET_RX_DROP) {
+		xsp->rx_dropped += 1;
+	}
+}
+
+static void dispatch_broadcast(struct net_device *src, unsigned char *data, int len)
+{
+	struct sandlan_priv *xsp = netdev_priv(src);
+	struct sandlan_domain *domain = xsp->domain;
+	struct list_head *cur;
+
+	down_read(&sandlan_devs_mutex);
+	list_for_each(cur, &domain->nodes_list) {
+		struct sandlan_priv *dst_xsp;
+
+		dst_xsp = list_entry(cur, struct sandlan_priv, nodes_list);
+		if (dst_xsp == xsp)
+			continue;
+		deliver(src, data, len, dst_xsp->dev);
+	}
+	up_read(&sandlan_devs_mutex);
+}
+
+static void dispatch_multicast(struct net_device *src, unsigned char *data, int len)
+{
+	struct sandlan_priv *xsp = netdev_priv(src);
+	struct sandlan_domain *domain = xsp->domain;
+	struct list_head *cur;
+	struct netdev_hw_addr *ha;
+
+	down_read(&sandlan_devs_mutex);
+	list_for_each(cur, &domain->nodes_list) {
+		struct sandlan_priv *dst_xsp;
+
+		dst_xsp = list_entry(cur, struct sandlan_priv, nodes_list);
+		if (dst_xsp == xsp)
+			continue;
+		/* If the dst device is in promiscuous mode, deliver. */
+		if (dst_xsp->dev->flags & IFF_PROMISC) {
+			deliver(src, data, len, dst_xsp->dev);
+			continue;
+		}
+		/* If the dst device is receiving all multicast, deliver. */
+		if (dst_xsp->dev->flags & IFF_ALLMULTI) {
+			deliver(src, data, len, dst_xsp->dev);
+			continue;
+		}
+		/* Check multicast filter list. */
+		netdev_for_each_mc_addr(ha, dst_xsp->dev) {
+			if (memcmp(ha->addr, data, 6) == 0) {
+				deliver(src, data, len, dst_xsp->dev);
+				break;
+			}
+		}
+	}
+	up_read(&sandlan_devs_mutex);
+}
+
+static void dispatch_unicast(struct net_device *src, unsigned char *data, int len)
+{
+	struct sandlan_priv *xsp = netdev_priv(src);
+	struct sandlan_domain *domain = xsp->domain;
+	struct list_head *cur;
+
+	down_read(&sandlan_devs_mutex);
+	list_for_each(cur, &domain->nodes_list) {
+		struct sandlan_priv *dst_xsp;
+
+		dst_xsp = list_entry(cur, struct sandlan_priv, nodes_list);
+		if (dst_xsp == xsp)
+			continue;
+		/* If the dst address matches the target, deliver. */
+		if (memcmp(dst_xsp->dev->dev_addr, data, 6) == 0) {
+			deliver(src, data, len, dst_xsp->dev);
+			continue;
+		}
+		/* If the dst device is in promiscuous mode, deliver. */
+		if (dst_xsp->dev->flags & IFF_PROMISC) {
+			deliver(src, data, len, dst_xsp->dev);
+			continue;
+		}
+	}
+	up_read(&sandlan_devs_mutex);
+}
+
+void sandlan_dispatch(struct net_device *src, unsigned char *data, int len)
+{
+	static const unsigned char broadcast_addr[6] = { 0xff, 0xff, 0xff,
+							 0xff, 0xff, 0xff };
+
+	/* If the dst address (the 1st 6 bytes) is the broadcast
+	 * address, then broadcast.
+	 */
+	if (memcmp(broadcast_addr, data, sizeof(broadcast_addr)) == 0) {
+		dispatch_broadcast(src, data, len);
+		return;
+	}
+
+	/* If the LSB of the first octet of the destination address is
+	 * set to 1, then the address is multicast, and is delivered
+	 * to all the NICs who are interested. (Broadcast packets are
+	 * already handled.)
+	 */
+	if (data[0] & 0x01) {
+		dispatch_multicast(src, data, len);
+		return;
+	}
+
+	/* Otherwise, handle the packet as a unicast packet. */
+	dispatch_unicast(src, data, len);
+}
diff --git a/drivers/net/sandlan/sandlan_domain.c b/drivers/net/sandlan/sandlan_domain.c
new file mode 100644
index 000000000000..13ca62a0b07c
--- /dev/null
+++ b/drivers/net/sandlan/sandlan_domain.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2022 Cruise LLC
+ * Stephen Williams <steve.williams@getcruise.com>
+ *
+ * Sandlan abstract ethernet LAN/device
+ */
+
+# include  "sandlan_priv.h"
+
+# include  <linux/netdevice.h>
+# include  <linux/slab.h>
+# include  <linux/printk.h>
+
+/* Keep a list of domains. Domains contain nodes. Also create a special
+ * default domain that cannot be allocated or deallocated, and holds
+ * nodes that are not in any other domains. (A node can only be in
+ * exactly one domain.)
+ */
+static LIST_HEAD(sandlan_domains);
+static struct sandlan_domain default_domain;
+
+/* Add the interface node to the domain node. If it is already in
+ * another domain, then remove it first.
+ */
+static void do_dom_add_node(struct sandlan_domain *domain,
+			    struct sandlan_priv *xsp)
+{
+	if (domain == 0)
+		domain = &default_domain;
+
+	if (xsp->domain)
+		list_del_init(&xsp->nodes_list);
+
+	list_add(&xsp->nodes_list, &domain->nodes_list);
+	xsp->domain = domain;
+}
+
+static struct sandlan_domain *do_find_dom_name(const char *name)
+{
+	struct sandlan_domain *domain = 0;
+	struct list_head *cur;
+
+	if (name == 0)
+		return &default_domain;
+
+	list_for_each(cur, &sandlan_domains) {
+		domain = list_entry(cur, struct sandlan_domain, domains_list);
+		if (strcmp(domain->name, name) == 0)
+			return domain;
+	}
+
+	return 0;
+}
+
+int sandlan_dom_add_node(const char *dom_name, struct sandlan_priv *xsp)
+{
+	struct sandlan_domain *domain;
+
+	down_write(&sandlan_devs_mutex);
+	domain = do_find_dom_name(dom_name);
+	if (domain == 0) {
+		up_write(&sandlan_devs_mutex);
+		return -ENODEV;
+	}
+	do_dom_add_node(domain, xsp);
+	up_write(&sandlan_devs_mutex);
+
+	return 0;
+}
+
+/* Release the node from the domain it is in. This is only used when
+ * the device is about to be delete. Nornally, you just add the device
+ * to whatever new domain you want to be in.
+ *
+ * NOTE: Lock must be held by caller.
+ */
+void do_sandlan_dom_release_node(struct sandlan_priv *xsp)
+{
+	if (xsp->domain == 0) {
+		netdev_warn(xsp->dev, "No domain to release from\n");
+		return;
+	}
+	list_del_init(&xsp->nodes_list);
+	xsp->domain = 0;
+}
+
+static void do_init_domain(struct sandlan_domain *domain, const char *name)
+{
+	INIT_LIST_HEAD(&domain->domains_list);
+	strncpy(domain->name, name, sizeof(domain->name));
+	INIT_LIST_HEAD(&domain->nodes_list);
+}
+
+/* Allocate a new domain by name.
+ * If the name already exists, then do not allocate the domain.
+ */
+int sandlan_dom_alloc(const char *name)
+{
+	struct sandlan_domain *domain;
+
+	if (name == 0)
+		return -EINVAL;
+
+	domain = kmalloc(sizeof(*domain), GFP_KERNEL);
+	do_init_domain(domain, name);
+
+	down_write(&sandlan_devs_mutex);
+	if (do_find_dom_name(name)) {
+		up_write(&sandlan_devs_mutex);
+		kfree(domain);
+		return -EBUSY;
+	}
+
+	list_add(&domain->domains_list, &sandlan_domains);
+	up_write(&sandlan_devs_mutex);
+
+	return 0;
+}
+
+static void do_free_domain(struct sandlan_domain *domain)
+{
+	struct list_head *cur, *tmp;
+	struct sandlan_priv *xsp;
+
+	/* Drop any interfaces into the default domain */
+	list_for_each_safe(cur, tmp, &domain->nodes_list) {
+		xsp = list_entry(cur, struct sandlan_priv, nodes_list);
+		do_dom_add_node(&default_domain, xsp);
+	}
+
+	list_del(&domain->domains_list);
+	kfree(domain);
+}
+
+int sandlan_dom_free_byname(const char *name)
+{
+	struct sandlan_domain *domain;
+
+	if (name == 0)
+		return -EINVAL;
+
+	down_write(&sandlan_devs_mutex);
+	domain = do_find_dom_name(name);
+	if (domain == 0) {
+		up_write(&sandlan_devs_mutex);
+		return -ENODEV;
+	}
+
+	do_free_domain(domain);
+	up_write(&sandlan_devs_mutex);
+
+	return 0;
+}
+
+void sandlan_dom_release_all(void)
+{
+	struct list_head *cur, *tmp;
+	struct sandlan_domain *domain;
+
+	down_write(&sandlan_devs_mutex);
+	list_for_each_safe(cur, tmp, &sandlan_domains) {
+		domain = list_entry(cur, struct sandlan_domain, domains_list);
+		do_free_domain(domain);
+	}
+	up_write(&sandlan_devs_mutex);
+}
+
+/* This is called during initialization or module loading, so does not
+ * need to be locked.
+ */
+int sandlan_dom_init(void)
+{
+	do_init_domain(&default_domain, SANDLAN_DOM_DEFAULT);
+	return 0;
+}
+
+/* This function is used by the sysfs interface. */
+ssize_t sandlan_dom_show_domains(char *buf, size_t len)
+{
+	struct list_head *cur;
+	ssize_t res = 0;
+
+	down_read(&sandlan_devs_mutex);
+	list_for_each(cur, &sandlan_domains) {
+		int rc;
+		struct sandlan_domain *domain;
+
+		domain = list_entry(cur, struct sandlan_domain, domains_list);
+		rc = snprintf(buf, len, "%s\n", domain->name);
+		if (rc >= len) {
+			res += len;
+			break;
+		}
+
+		buf += rc;
+		len -= rc;
+		res += rc;
+	}
+	up_read(&sandlan_devs_mutex);
+
+	return res;
+}
diff --git a/drivers/net/sandlan/sandlan_main.c b/drivers/net/sandlan/sandlan_main.c
new file mode 100644
index 000000000000..a298b24f1574
--- /dev/null
+++ b/drivers/net/sandlan/sandlan_main.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2022 Cruise LLC
+ * Stephen Williams <steve.williams@getcruise.com>
+ *
+ * Sandlan abstract ethernet LAN/device
+ */
+
+/* Sandlan is a LAN in a sandbox. All the devices connect to an
+ * abstract LAN. All the devices have an 802.1 MAC address and
+ * otherwise act as ethernet devices connected to a single bus. So
+ * everying ethernet should work here, even including ARP.
+ */
+# include  "sandlan_priv.h"
+
+# include  <linux/init.h>
+# include  <linux/module.h>
+# include  <linux/netdevice.h>
+# include  <linux/etherdevice.h>
+# include  <linux/printk.h>
+
+MODULE_LICENSE("GPL");
+
+/* Called by the kernel to initialize the driver.
+ */
+static int sandlan_init_module(void)
+{
+	int rc;
+
+	rc = sandlan_dom_init();
+	if (rc < 0)
+		return rc;
+
+	rc = sandlan_dev_init();
+	if (rc < 0)
+		return rc;
+
+	rc = sandlan_init_netns();
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+/* Remove the mess that is (was) the device driver. Leave no trace.
+ */
+static void sandlan_remove_module(void)
+{
+	sandlan_dev_release_all();
+	sandlan_dom_release_all();
+	sandlan_remove_netns();
+}
+
+module_init(sandlan_init_module);
+module_exit(sandlan_remove_module);
diff --git a/drivers/net/sandlan/sandlan_netns.c b/drivers/net/sandlan/sandlan_netns.c
new file mode 100644
index 000000000000..3f160588675c
--- /dev/null
+++ b/drivers/net/sandlan/sandlan_netns.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2022 Cruise LLC
+ * Stephen Williams <steve.williams@getcruise.com>
+ *
+ * Sandlan abstract ethernet LAN/device
+ */
+
+/* These functions handle the netns aspects of the sandlan device[s]. */
+
+# include  "sandlan_priv.h"
+
+# include  <net/net_namespace.h>
+# include  <net/netns/generic.h>
+
+unsigned int sandlan_net_id __read_mostly;
+
+/* These are operations that control the sandlan presence within net
+ * scopes.
+ */
+
+static int __net_init sandlan_net_init(struct net *net)
+{
+	int rc;
+	struct sandlan_netns *xnp = net_generic(net, sandlan_net_id);
+
+	xnp->net = net;
+
+	rc = sandlan_init_sysfs(xnp);
+	return rc;
+}
+
+static void __net_exit sandlan_net_exit(struct net *net)
+{
+	struct sandlan_netns *xnp = net_generic(net, sandlan_net_id);
+
+	sandlan_remove_sysfs(xnp);
+}
+
+static struct pernet_operations sandlan_net_ops = {
+	.init = sandlan_net_init,
+	.exit = sandlan_net_exit,
+	.id   = &sandlan_net_id,
+	.size = sizeof(struct sandlan_netns),
+};
+
+int sandlan_init_netns(void)
+{
+	int rc;
+
+	rc = register_pernet_subsys(&sandlan_net_ops);
+	if (rc) {
+		pr_info("sandlan: Unable to register pernet subsystem.\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+void sandlan_remove_netns(void)
+{
+	unregister_pernet_subsys(&sandlan_net_ops);
+}
diff --git a/drivers/net/sandlan/sandlan_priv.h b/drivers/net/sandlan/sandlan_priv.h
new file mode 100644
index 000000000000..16518d65d798
--- /dev/null
+++ b/drivers/net/sandlan/sandlan_priv.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright 2022 Cruise LLC
+ * Stephen Williams <steve.williams@getcruise.com>
+ *
+ * Sandlan abstract ethernet LAN/device
+ */
+#ifndef __sandlan_priv_H
+#define __sandlan_priv_H
+
+# include  <linux/device.h>
+# include  <linux/rwsem.h>
+
+/* Name of the default domain. */
+# define SANDLAN_DOM_DEFAULT "-"
+
+struct sandlan_priv;
+struct sandlan_domain;
+
+/* Device creation/deletion/configuration is locked by this
+ * semaphore. This also includes domain creation and
+ * deletion. Functions that need to follow sandlan_domain and
+ * sandlan_priv data scructures can get read locks. Keep the lock
+ * global because the network shouldn't be all that dynamic.
+ */
+extern struct rw_semaphore sandlan_devs_mutex;
+
+/* Describe a domain, including the domain name, and all the nodes in
+ * the domain.
+ */
+# define SANDLAN_DOM_NAMELEN 31
+struct sandlan_domain {
+	struct list_head domains_list;
+	char name[SANDLAN_DOM_NAMELEN + 1];
+	/* Nodes in the domain */
+	struct list_head nodes_list;
+};
+
+/* Sandlan-specific parts of the net device structure. This is a NIC,
+ * and must be inexactly one domain (even if that domain is "default").
+ */
+struct sandlan_priv {
+	struct list_head devs_list;
+	struct net_device *dev;
+	/* Mark the domain where this interface lives */
+	struct sandlan_domain *domain;
+	struct list_head nodes_list;
+	/* Statistics */
+	unsigned long rx_packets;
+	unsigned long rx_bytes;
+	unsigned long rx_dropped;
+	unsigned long tx_packets;
+	unsigned long tx_bytes;
+	unsigned long tx_dropped;
+};
+
+int sandlan_dom_init(void);
+int sandlan_dom_alloc(const char *name);
+int sandlan_dom_free_byname(const char *name);
+void sandlan_dom_release_all(void);
+
+int sandlan_dom_add_node(const char *dom_name, struct sandlan_priv *xsp);
+void do_sandlan_dom_release_node(struct sandlan_priv *xsp);
+ssize_t sandlan_dom_show_domains(char *buf, size_t len);
+
+/* Per-namespace aspects of the sandlan driver. The sysfs interface
+ * uses this.
+ */
+struct sandlan_netns {
+	struct net *net;
+	struct class_attribute class_attr_sandlan_interfaces;
+	struct class_attribute class_attr_sandlan_domains;
+};
+
+/* Take a packet being transmitted and dispatch it to all the various
+ * nodes that might receive it.
+ */
+void sandlan_dispatch(struct net_device *dev, unsigned char *data, int len);
+
+/* Create device. */
+int sandlan_dev_init(void);
+int sandlan_dev_alloc(const char *name_pattern);
+int sandlan_dev_free_byname(const char *name);
+void sandlan_dev_release_all(void);
+
+ssize_t sandlan_dev_show_interfaces(char *buf, size_t len);
+
+/* Namespace specific functions. */
+int sandlan_init_netns(void);
+void sandlan_remove_netns(void);
+
+/* sysfs functions */
+int sandlan_init_sysfs(struct sandlan_netns *xnp);
+void sandlan_remove_sysfs(struct sandlan_netns *xnp);
+void sandlan_device_sysfs(struct sandlan_priv *xsp);
+
+#endif
diff --git a/drivers/net/sandlan/sandlan_sysfs.c b/drivers/net/sandlan/sandlan_sysfs.c
new file mode 100644
index 000000000000..6fcb2f26412d
--- /dev/null
+++ b/drivers/net/sandlan/sandlan_sysfs.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2022 Cruise LLC
+ * Stephen Williams <steve.williams@getcruise.com>
+ *
+ * Sandlan abstract ethernet LAN/device
+ */
+
+# include  "sandlan_priv.h"
+
+# include  <linux/netdevice.h>
+# include  <linux/sysfs.h>
+
+/* Show a list of all the interfaces that exist.
+ */
+static ssize_t sandlan_show_interfaces(struct class *cls,
+				       struct class_attribute *attr,
+				       char *buf)
+{
+	return sandlan_dev_show_interfaces(buf, PAGE_SIZE);
+}
+
+# define str_of(x) #x
+# define str_of_value(x) str_of(x)
+
+/* Add/delete interfaces as requested by the user. The command format
+ * is super simple:
+ *
+ *   +<name-pattern> to create an interface
+ *   -<name> to delete an interface
+ *
+ * The <name-pattern> make include an %d which will receive an
+ * interface number or some such, but it doesn't have to.
+ */
+static ssize_t sandlan_store_interfaces(struct class *cls,
+					struct class_attribute *attr,
+					const char *buffer, size_t count)
+{
+	int rc;
+	char command_code;
+	char ifname[IFNAMSIZ + 1];
+
+	rc = sscanf(buffer, "%c%" str_of_value(IFNAMSIZ) "s", &command_code, ifname);
+	if (rc < 2) {
+		pr_info("sandlan: Command format: [+-]<ifname>\n");
+		return -ENODEV;
+	}
+
+	switch (command_code) {
+	case '+':
+		rc = sandlan_dev_alloc(ifname);
+		if (rc < 0)
+			return rc;
+		break;
+
+	case '-':
+		rc = sandlan_dev_free_byname(ifname);
+		break;
+
+	default:
+		pr_info("sandlan: command_code=%c, ifname=%s\n", command_code, ifname);
+		break;
+	}
+
+	return count;
+}
+
+/* class attribute for sandlan_interfaces file.  This ends up in /sys/class/net */
+static const struct class_attribute class_attr_sandlan_interfaces = {
+	.attr = {
+		.name = "sandlan_interfaces",
+		.mode = 0644,
+	},
+	.show = sandlan_show_interfaces,
+	.store = sandlan_store_interfaces,
+};
+
+static ssize_t sandlan_show_domains(struct class *cls,
+				    struct class_attribute *attr,
+				    char *buf)
+{
+	return sandlan_dom_show_domains(buf, PAGE_SIZE);
+}
+
+/* Add/delete domains as requested by the user. The command format
+ * is super simple:
+ *
+ *   +<name> to create a domain
+ *   -<name> to delete a domain
+ */
+static ssize_t sandlan_store_domains(struct class *cls,
+				     struct class_attribute *attr,
+				     const char *buffer, size_t count)
+{
+	int rc;
+	char command_code;
+	char name[SANDLAN_DOM_NAMELEN + 1];
+
+	rc = sscanf(buffer, "%c%" str_of_value(SANDLAN_DOM_NAMELEN) "s", &command_code, name);
+	if (rc < 2) {
+		pr_info("sandlan domains: Command format: [+-]<name>\n");
+		return -ENODEV;
+	}
+
+	if (strcmp(name, SANDLAN_DOM_DEFAULT) == 0) {
+		pr_info("sandlan_domains: Domain name %s is reserved.\n", name);
+		return -EINVAL;
+	}
+
+	switch (command_code) {
+	case '+':
+		rc = sandlan_dom_alloc(name);
+		if (rc < 0)
+			return rc;
+		break;
+
+	case '-':
+		rc = sandlan_dom_free_byname(name);
+		break;
+
+	default:
+		pr_info("sandlan domains: command_code=%c, name=%s\n", command_code, name);
+		break;
+	}
+
+	return count;
+}
+
+/* class attribute for sandlan_interfaces file.  This ends up in /sys/class/net */
+static const struct class_attribute class_attr_sandlan_domains = {
+	.attr = {
+		.name = "sandlan_domains",
+		.mode = 0644,
+	},
+	.show = sandlan_show_domains,
+	.store = sandlan_store_domains,
+};
+
+int sandlan_init_sysfs(struct sandlan_netns *xns)
+{
+	int rc;
+
+	xns->class_attr_sandlan_interfaces = class_attr_sandlan_interfaces;
+	sysfs_attr_init(&xns->class_attr_sandlan_interfaces.attr);
+
+	rc = netdev_class_create_file_ns(&xns->class_attr_sandlan_interfaces, xns->net);
+	if (rc < 0)
+		pr_info("sandlan_create_sysfs: Unable to create interfaces class file.\n");
+
+	xns->class_attr_sandlan_domains = class_attr_sandlan_domains;
+	sysfs_attr_init(&xns->class_attr_sandlan_domains.attr);
+
+	rc = netdev_class_create_file_ns(&xns->class_attr_sandlan_domains, xns->net);
+	if (rc < 0)
+		pr_info("sandlan_create_sysfs: Unable to create domains class file.\n");
+
+	return rc;
+}
+
+void sandlan_remove_sysfs(struct sandlan_netns *xns)
+{
+	netdev_class_remove_file_ns(&xns->class_attr_sandlan_interfaces, xns->net);
+	netdev_class_remove_file_ns(&xns->class_attr_sandlan_domains, xns->net);
+}
+
+/* PER DEVICE SYSFS NODES
+ */
+
+static ssize_t domain_show(struct device *d, struct device_attribute *attr, char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct sandlan_priv *xsp = netdev_priv(dev);
+	int res = 0;
+
+	res += snprintf(buf + res, PAGE_SIZE, "%s\n", xsp->domain->name);
+	return res;
+}
+
+static ssize_t domain_store(struct device *d, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct sandlan_priv *xsp = netdev_priv(dev);
+	char name[SANDLAN_DOM_NAMELEN + 1];
+	int rc;
+
+	rc = sscanf(buf, " %" str_of_value(SANDLAN_DOM_NAMELEN) "s ", name);
+	if (rc != 1)
+		return count;
+
+	/* The - domain is special, meaning "remove" to the default. */
+	if (strcmp(name, "-") == 0) {
+		sandlan_dom_add_node(0, xsp);
+		return count;
+	}
+
+	rc = sandlan_dom_add_node(name, xsp);
+	if (rc < 0)
+		netdev_info(dev, "Error (%d) setting domain %s\n", -rc, name);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(domain);
+
+static struct attribute *per_sandlan_attrs[] = {
+	&dev_attr_domain.attr,
+	NULL
+};
+
+static const struct attribute_group sandlan_group = {
+	.name = "sandlan",
+	.attrs = per_sandlan_attrs,
+};
+
+void sandlan_device_sysfs(struct sandlan_priv *xsp)
+{
+	xsp->dev->sysfs_groups[0] = &sandlan_group;
+}
-- 
2.38.1

