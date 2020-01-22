Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CB8145D27
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAVUc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:32:59 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:36242 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVUc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:32:59 -0500
Received: by mail-pl1-f202.google.com with SMTP id d4so213781pll.3
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 12:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=786oVqFM1vNXl5lNoTIaLWcA1Q1xTS09JT4dv7j0HYo=;
        b=Nzuq+1ItC6Q/Qxk+y88vI7g8GcHZzmetjw2Eox1PoPHhHY7nK367srSyXWvcq/lGP7
         1eV2aofwOExy2iDMlr5GBEI1/MYszuA3FoJGugQTj1CBAXLtZ26mhSX6qhe0uZ+kE6iC
         EnFID3kWtQQ7hTxANWWXbeOWBSMoRfv6jiuhWE3axHfAXl/Gu08kfsysQ17Jn01qE8mu
         k18YWtFxD4CmqlA+j/RnFuQ39QjGpLGxwqeqemncJFSJ1z2xPGL2hl0eITRGacGRdYfg
         OwynBFMahF/hQWt7cIS3OK4KLjYpJD84RqrQIZJeFqeu4vpn+szYVq45Q77QEADRiRXS
         Kj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=786oVqFM1vNXl5lNoTIaLWcA1Q1xTS09JT4dv7j0HYo=;
        b=W6112A3DPwpuZxCMkjWMWCXAm6QSLkjbvlL+ne1GOwhG96l+yu4exBitfiJINvvRCK
         Mwh1/qxi+Zor2Z6TsW5E5nBQJZhx05TRhJ02AFVnqlfKk+lRHTNeSOtyrOHGv/xB7QiK
         tTBwtgp3r2iwEtt4jQqsHq28/kEw4+sPX+T93jY647YmwYmglp/lwtsc/MhJs0GTngiL
         QxRBrod6MVtdB/yL8FGQWyKXulNSrU3LUlvRujrydFXJhDP91SVoI4xfK4eKwFAvtzug
         mpZOz/UjpvQ8r+rkwfZyTDtrz2E4RtIZfpCymtfxA/tQ1wq647nimM2e/0bz6Wj7LyHI
         7NnA==
X-Gm-Message-State: APjAAAUJDhtd5ONh+hTe6fpFp+slQ250RUbXrYoMvjl8DUTyDg2eR/FP
        uwYbSosOBIZi/xDlZ2G2xASgLrcfdiuMTVm0hW7Gqm4NZxjVJOC8g9IrT7w3kD2HieBqBFCMvqd
        xRCmgzTKMS+151zWVouP1DyWxFgBaNDK+b6MNIzc7rg+48lGnkkUYdS8Bc/JKTw==
X-Google-Smtp-Source: APXvYqwBb7xyBA1GbSIq2+eI/rYB6qX2AKcwiFY8fyuTTs63VzeowwJrBkAMFGTpnSUTw95Nzl4tBXYyxP8=
X-Received: by 2002:a63:4185:: with SMTP id o127mr68976pga.284.1579725178501;
 Wed, 22 Jan 2020 12:32:58 -0800 (PST)
Date:   Wed, 22 Jan 2020 12:32:53 -0800
Message-Id: <20200122203253.20652-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
From:   Luigi Rizzo <lrizzo@google.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a netdevice flag to control skb linearization in generic xdp mode.
Among the various mechanism to control the flag, the sysfs
interface seems sufficiently simple and self-contained.
The attribute can be modified through
	/sys/class/net/<DEVICE>/xdp_linearize
The default is 1 (on)

On a kernel instrumented to grab timestamps around the linearization
code in netif_receive_generic_xdp, and heavy netperf traffic with 1500b
mtu, I see the following times (nanoseconds/pkt)

The receiver generally sees larger packets so the difference is more
significant.

ns/pkt                   RECEIVER                 SENDER

                    p50     p90     p99       p50   p90    p99

LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns

Tested: run tests on an instrumented kernel
Change-Id: I69884661167ab86347c50bdece8cae1afa821956
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/netdevice.h |  3 ++-
 net/core/dev.c            |  5 +++--
 net/core/net-sysfs.c      | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2741aa35bec6..ae873fb5ec3c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1958,7 +1958,8 @@ struct net_device {
 
 	struct netdev_rx_queue	*_rx;
 	unsigned int		num_rx_queues;
-	unsigned int		real_num_rx_queues;
+	unsigned int		real_num_rx_queues:31;
+	unsigned int		xdp_linearize : 1;
 
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
diff --git a/net/core/dev.c b/net/core/dev.c
index 6368c94c9e0a..04c7c8ed1b4a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4484,8 +4484,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
 	 * native XDP provides, thus we need to do it here as well.
 	 */
-	if (skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+	if (skb->dev->xdp_linearize && (skb_is_nonlinear(skb) ||
+	    skb_headroom(skb) < XDP_PACKET_HEADROOM)) {
 		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
 		int troom = skb->tail + skb->data_len - skb->end;
 
@@ -9756,6 +9756,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->upper_level = 1;
 	dev->lower_level = 1;
+	dev->xdp_linearize = 1;
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4c826b8bf9b1..ec59aa296664 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -442,6 +442,20 @@ static ssize_t proto_down_store(struct device *dev,
 }
 NETDEVICE_SHOW_RW(proto_down, fmt_dec);
 
+static int change_xdp_linearize(struct net_device *dev, unsigned long val)
+{
+	dev->xdp_linearize = !!val;
+	return 0;
+}
+
+static ssize_t xdp_linearize_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	return netdev_store(dev, attr, buf, len, change_xdp_linearize);
+}
+NETDEVICE_SHOW_RW(xdp_linearize, fmt_dec);
+
 static ssize_t phys_port_id_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -536,6 +550,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_phys_port_name.attr,
 	&dev_attr_phys_switch_id.attr,
 	&dev_attr_proto_down.attr,
+	&dev_attr_xdp_linearize.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
 	NULL,
-- 
2.25.0.341.g760bfbb309-goog

