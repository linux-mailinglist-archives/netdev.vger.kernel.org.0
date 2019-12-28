Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1012BDA5
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 14:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfL1NcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 08:32:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51434 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfL1Nb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 08:31:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so10314954wmd.1
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 05:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5+hUPHn2+S1TN3/6dycA1Nc7w1xDPkRvv4S87+4kB+s=;
        b=XPAPhu3HrTdDsAB9PKr7JieO5eVtNcCErY875CxeJH5yE/xHHnrP8TRM6Jvfx4foAd
         H7SdFjhonQIFyfuz3panNQaBwEHyDFZhOKxrLYIOiJ0K9RhibbfJ7NW3XUB/m3d135o5
         4PXEwswJ+PuG6qXBMgELONbfx09JIZrS5+T74n8o/GD2aD/w0K94kpAFGkvtDGczy6Lf
         kQ1Cor2XbpJ71AH0GftUSSamtXjPg4+ix7AObKkHRXXFckxFquFxAEhs0k9eEukKvfLh
         1AxiuMEdPoM8FjxLZSlUZnPifkb7+F5a3IMqcu0/IPwdUfV14KonxxJKBiAx4hT4MzNs
         WB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5+hUPHn2+S1TN3/6dycA1Nc7w1xDPkRvv4S87+4kB+s=;
        b=eRbfIGcZXpoeTmIlSJ+E7OqV8S6dKcWHYrv4UboidhoArmu5GL3hDheY6fIghty8Q0
         +C08AxOSobw6s4xYuRRn/f6Gp8/TI52FPKkbtlj7jfU96XEpkf4KduLBL5RPKEj9qVne
         IuAdbr38ye/9T+7vCqcW7UXxOWWbe6p91t/e4GcY3cvJlPYFhQjw/2FpHDT7MYEgmc7w
         pAD/mWaS7pM9HPo/Y1JildwU50eOUK10CLygZ3v5VtLQBHosE+V1M51diGKIiigpQKpN
         3SpuieqeS7YOZk/xFHV98lhc3yJqQO4z3aeXKLLGEnrnEPZLi2V4i7rqLA2k2PP1vG1N
         fiSA==
X-Gm-Message-State: APjAAAUd1fcTVM9/DoMe0eqEsMWP/tNDCKiEPgRS+GpcC1Q4qyqHACJT
        Ng32s1naT/GdnN0QaBb7MjE=
X-Google-Smtp-Source: APXvYqwCAS0+XeIunhwKHTxik5/JW3jcNCXVcwO7Q+q9RVUf3LXwWP+dyRpKQ1aFinxGD5gQafqITw==
X-Received: by 2002:a1c:2dcd:: with SMTP id t196mr23766281wmt.22.1577539917315;
        Sat, 28 Dec 2019 05:31:57 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id a1sm37846199wrr.80.2019.12.28.05.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 05:31:56 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, claudiu.manoil@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 2/2] net: dsa: Deny PTP on master if switch supports it
Date:   Sat, 28 Dec 2019 15:30:46 +0200
Message-Id: <20191228133046.9406-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191228133046.9406-1-olteanv@gmail.com>
References: <20191228133046.9406-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to kill PTP on a DSA switch completely and absolutely,
until a reboot, with a simple command:

tcpdump -i eth2 -j adapter_unsynced

where eth2 is the switch's DSA master.

Why? Well, in short, the PTP API in place today is a bit rudimentary and
relies on applications to retrieve the TX timestamps by polling the
error queue and looking at the cmsg structure. But there is no timestamp
identification of any sorts (except whether it's HW or SW), you don't
know how many more timestamps are there to come, which one is this one,
from whom it is, etc. In other words, the SO_TIMESTAMPING API is
fundamentally limited in that you can get a single HW timestamp from the
stack.

And the "-j adapter_unsynced" flag of tcpdump enables hardware
timestamping.

So let's imagine what happens when the DSA master decides it wants to
deliver TX timestamps to the skb's socket too:
- The timestamp that the user space sees is taken by the DSA master.
  Whereas the RX timestamp will eventually be overwritten by the DSA
  switch. So the RX and TX timestamps will be in different time bases
  (aka garbage).
- The user space applications have no way to deal with the second (real)
  TX timestamp finally delivered by the DSA switch, or even to know to
  wait for it.

Take ptp4l from the linuxptp project, for example. This is its behavior
after running tcpdump, before the patch:

ptp4l[172]: [6469.594] Unexpected data on socket err queue:
ptp4l[172]: [6469.693] rms    8 max   16 freq -21257 +/-  11 delay   748 +/-   0
ptp4l[172]: [6469.711] Unexpected data on socket err queue:
ptp4l[172]: 0020 00 00 00 1f 7b ff fe 63 02 48 00 03 aa 05 00 fd
ptp4l[172]: 0030 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: [6469.721] Unexpected data on socket err queue:
ptp4l[172]: 0000 01 80 c2 00 00 0e 00 1f 7b 63 02 48 88 f7 10 02
ptp4l[172]: 0010 00 2c 00 00 02 00 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: 0020 00 00 00 1f 7b ff fe 63 02 48 00 01 c6 b1 00 fd
ptp4l[172]: 0030 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: [6469.838] Unexpected data on socket err queue:
ptp4l[172]: 0000 01 80 c2 00 00 0e 00 1f 7b 63 02 48 88 f7 10 02
ptp4l[172]: 0010 00 2c 00 00 02 00 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: 0020 00 00 00 1f 7b ff fe 63 02 48 00 03 aa 06 00 fd
ptp4l[172]: 0030 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: [6469.848] Unexpected data on socket err queue:
ptp4l[172]: 0000 01 80 c2 00 00 0e 00 1f 7b 63 02 48 88 f7 13 02
ptp4l[172]: 0010 00 36 00 00 02 00 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: 0020 00 00 00 1f 7b ff fe 63 02 48 00 04 1a 45 05 7f
ptp4l[172]: 0030 00 00 5e 05 41 32 27 c2 1a 68 00 04 9f ff fe 05
ptp4l[172]: 0040 de 06 00 01
ptp4l[172]: [6469.855] Unexpected data on socket err queue:
ptp4l[172]: 0000 01 80 c2 00 00 0e 00 1f 7b 63 02 48 88 f7 10 02
ptp4l[172]: 0010 00 2c 00 00 02 00 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: 0020 00 00 00 1f 7b ff fe 63 02 48 00 01 c6 b2 00 fd
ptp4l[172]: 0030 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: [6469.974] Unexpected data on socket err queue:
ptp4l[172]: 0000 01 80 c2 00 00 0e 00 1f 7b 63 02 48 88 f7 10 02
ptp4l[172]: 0010 00 2c 00 00 02 00 00 00 00 00 00 00 00 00 00 00
ptp4l[172]: 0020 00 00 00 1f 7b ff fe 63 02 48 00 03 aa 07 00 fd
ptp4l[172]: 0030 00 00 00 00 00 00 00 00 00 00

The ptp4l program itself is heavily patched to show this (more details
here [0]). Otherwise, by default it just hangs.

On the other hand, with the DSA patch to disallow HW timestamping
applied:

tcpdump -i eth2 -j adapter_unsynced
tcpdump: SIOCSHWTSTAMP failed: Device or resource busy

So it is a fact of life that PTP timestamping on the DSA master is
incompatible with timestamping on the switch MAC, at least with the
current API. And if the switch supports PTP, taking the timestamps from
the switch MAC is highly preferable anyway, due to the fact that those
don't contain the queuing latencies of the switch. So just disallow PTP
on the DSA master if there is any PTP-capable switch attached.

[0]: https://sourceforge.net/p/linuxptp/mailman/message/36880648/

Fixes: 0336369d3a4d ("net: dsa: forward hardware timestamping ioctls to switch driver")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
Changes in v2:
- Reworded the commit description, added some of Richard's
  clarifications.

 net/dsa/master.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 3255dfc97f86..bd44bde272f4 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -197,6 +197,35 @@ static int dsa_master_get_phys_port_name(struct net_device *dev,
 	return 0;
 }
 
+static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	struct dsa_switch *ds = cpu_dp->ds;
+	struct dsa_switch_tree *dst;
+	int err = -EOPNOTSUPP;
+	struct dsa_port *dp;
+
+	dst = ds->dst;
+
+	switch (cmd) {
+	case SIOCGHWTSTAMP:
+	case SIOCSHWTSTAMP:
+		/* Deny PTP operations on master if there is at least one
+		 * switch in the tree that is PTP capable.
+		 */
+		list_for_each_entry(dp, &dst->ports, list)
+			if (dp->ds->ops->port_hwtstamp_get ||
+			    dp->ds->ops->port_hwtstamp_set)
+				return -EBUSY;
+		break;
+	}
+
+	if (cpu_dp->orig_ndo_ops && cpu_dp->orig_ndo_ops->ndo_do_ioctl)
+		err = cpu_dp->orig_ndo_ops->ndo_do_ioctl(dev, ifr, cmd);
+
+	return err;
+}
+
 static int dsa_master_ethtool_setup(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
@@ -249,6 +278,7 @@ static int dsa_master_ndo_setup(struct net_device *dev)
 		memcpy(ops, cpu_dp->orig_ndo_ops, sizeof(*ops));
 
 	ops->ndo_get_phys_port_name = dsa_master_get_phys_port_name;
+	ops->ndo_do_ioctl = dsa_master_ioctl;
 
 	dev->netdev_ops  = ops;
 
-- 
2.17.1

