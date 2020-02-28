Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D015F1735AC
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgB1Kyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:54:41 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:55246 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgB1Kyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 05:54:41 -0500
Received: by mail-pg1-f202.google.com with SMTP id l17so1530972pgh.21
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 02:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tdQUdS7x2rCx1v8FEB8YDbTZb5Bh+jYuKbWwAYyw4WQ=;
        b=uyA+4LzoUf+htbphfAJGGjZNowcHtlIYcCb1h9czIGbE2qb6Tz6eXbY73v3BbogaXY
         iYeidB88Z06KBrgMfWUaYHfQZOTcPtBf+ZeZHjum0w5n4QjCr3Kx17RgYuXuCOTVu77O
         swmEPuElqezEngAnVpoi7/Z0oMH7/3lDie0G6dhpH49HSmqXKfBkcD1ao5Y8VJlAp20C
         QTbtwrgO1479T4zWxhC7T1MBPBihwcdRZhRbhD4s2wogdH/LFfH8oTeeVQicecE5zPtF
         VeoqiJvwhOPB4H3M2m0RR2MNL09Zorvbfc6lXvJkh2/tuZ7aouOwUCSTJST7qMPsbjl+
         y/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tdQUdS7x2rCx1v8FEB8YDbTZb5Bh+jYuKbWwAYyw4WQ=;
        b=poDnvW95fEVmn9Ys3W/9jRf9d0IpdM5wsexF6zMuzRLiraQqdo83M1+68gp0HwVYOr
         idkTOxEF7P09fiP1wpgDX1zb1LfoL8MKzlP1L6fLbWFK+YhZwnVQF+BjCG47ybNc0SPJ
         rh8HVkf4RSywG1Ud6tl8KalCm/gp52FVL1fTRP9gHfi56lDFA5jm9gm0iDa5RxMXlwyG
         eYFT/tZc7H4n+D4f5+85rJpXhxRY0HkpxumKBzVD6wKL1AdSnOm1l0/odzL0HYkQDEPJ
         ItaKMjRLJ+O7n2NQOZdt7RWh9HFKtWP8RNfUA2w27e/VUIM+TnBgatNYBc4dRP52znPf
         xnog==
X-Gm-Message-State: APjAAAV0+LJk0HODcke+1d3rMwRyXCfTvVvdkWY80VoLalA3fqMIBeVu
        9nOyE635iqA8cdmf5+TMrAL8k5gy9/MymK22SUhSvrOpitNRHIGD9se9QQEDHVBhfB0zRqBEOoy
        gP7tmUhS36pjhgwzinywspx8bw5aRNsq9UJpOXTRJKs5wVgiWjV9CX17PPfey8w==
X-Google-Smtp-Source: APXvYqzs8rTfDq1Hk2frUPLv63r3Iw8gfTmPaVF3Ujj8M5jCR5uXO3iJ19AA/oWn3Vtc3WzMjALLZfnb3Rg=
X-Received: by 2002:a63:fb04:: with SMTP id o4mr4081186pgh.423.1582887279503;
 Fri, 28 Feb 2020 02:54:39 -0800 (PST)
Date:   Fri, 28 Feb 2020 02:54:35 -0800
Message-Id: <20200228105435.75298-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v4] netdev attribute to control xdpgeneric skb linearization
From:   Luigi Rizzo <lrizzo@google.com>
To:     netdev@vger.kernel.org, toke@redhat.com, davem@davemloft.net,
        hawk@kernel.org, sameehj@amazon.com
Cc:     linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a netdevice flag to control skb linearization in generic xdp mode.

The attribute can be modified through
	/sys/class/net/<DEVICE>/xdpgeneric_linearize
The default is 1 (on)

Motivation: xdp expects linear skbs with some minimum headroom, and
generic xdp calls skb_linearize() if needed. The linearization is
expensive, and may be unnecessary e.g. when the xdp program does
not need access to the whole payload.
This sysfs entry allows users to opt out of linearization on a
per-device basis (linearization is still performed on cloned skbs).

On a kernel instrumented to grab timestamps around the linearization
code in netif_receive_generic_xdp, and heavy netperf traffic with 1500b
mtu, I see the following times (nanoseconds/pkt)

The receiver generally sees larger packets so the difference is more
significant.

ns/pkt                   RECEIVER                 SENDER

                    p50     p90     p99       p50   p90    p99

LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns

v1 --> v2 : added Documentation
v2 --> v3 : adjusted for skb_cloned
v3 --> v4 : renamed to xdpgeneric_linearize, documentation

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 Documentation/ABI/testing/sysfs-class-net | 10 ++++++++++
 include/linux/netdevice.h                 |  3 ++-
 net/core/dev.c                            |  8 ++++++--
 net/core/net-sysfs.c                      | 16 ++++++++++++++++
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index 664a8f6a634f..d5531bf223d7 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -301,3 +301,13 @@ Contact:	netdev@vger.kernel.org
 Description:
 		32-bit unsigned integer counting the number of times the link has
 		been down
+
+What:		/sys/class/net/<iface>/xdpgeneric_linearize
+Date:		Feb 2020
+KernelVersion:	5.6
+Contact:	netdev@vger.kernel.org
+Description:
+		boolean controlling whether skbs should be linearized in
+		generic XDP. Defaults to true. Turning this off can increase
+		the performance of generic XDP at the cost of making the XDP
+		program unable to access packet fragments after the first one.
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6c3f7032e8d9..f06294b2e8bb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1985,7 +1985,8 @@ struct net_device {
 
 	struct netdev_rx_queue	*_rx;
 	unsigned int		num_rx_queues;
-	unsigned int		real_num_rx_queues;
+	unsigned int		real_num_rx_queues:31;
+	unsigned int		xdpgeneric_linearize : 1;
 
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
diff --git a/net/core/dev.c b/net/core/dev.c
index dbbfff123196..c539489d3166 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4520,9 +4520,12 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* XDP packets must be linear and must have sufficient headroom
 	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
 	 * native XDP provides, thus we need to do it here as well.
+	 * For non shared skbs, xdpgeneric_linearize controls linearization.
 	 */
-	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+	if (skb_cloned(skb) ||
+	    (skb->dev->xdpgeneric_linearize &&
+	     (skb_is_nonlinear(skb) ||
+	      skb_headroom(skb) < XDP_PACKET_HEADROOM))) {
 		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
 		int troom = skb->tail + skb->data_len - skb->end;
 
@@ -9806,6 +9809,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->upper_level = 1;
 	dev->lower_level = 1;
+	dev->xdpgeneric_linearize = 1;
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index cf0215734ceb..eab06a427d90 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -442,6 +442,21 @@ static ssize_t proto_down_store(struct device *dev,
 }
 NETDEVICE_SHOW_RW(proto_down, fmt_dec);
 
+static int change_xdpgeneric_linearize(struct net_device *dev,
+				       unsigned long val)
+{
+	dev->xdpgeneric_linearize = !!val;
+	return 0;
+}
+
+static ssize_t xdpgeneric_linearize_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	return netdev_store(dev, attr, buf, len, change_xdpgeneric_linearize);
+}
+NETDEVICE_SHOW_RW(xdpgeneric_linearize, fmt_dec);
+
 static ssize_t phys_port_id_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -536,6 +551,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_phys_port_name.attr,
 	&dev_attr_phys_switch_id.attr,
 	&dev_attr_proto_down.attr,
+	&dev_attr_xdpgeneric_linearize.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
 	NULL,
-- 
2.25.1.481.gfbce0eb801-goog

