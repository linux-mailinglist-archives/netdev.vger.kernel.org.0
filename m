Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D036172530
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgB0Ref (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:34:35 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:51618 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729678AbgB0Ref (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:34:35 -0500
Received: by mail-pl1-f202.google.com with SMTP id 71so2402462plb.18
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 09:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=69CLbJ0NNAdwBPQxwWiGjKtl0m0UdtiwySOm+Lzujp4=;
        b=lMsHm0XCosZdF0aBLl/mNHY7TjcgO7y94PzXfZm+6IcgAGLNH6oc2NglC+CyULP0AK
         RtEbWmszUumtRxifTzmTdXI7oxkhT+8D+TRinkxWfK64VRwjNrE/lOcpsfLNxIlI2QC4
         bQBCswJtcln1t9ZtB0F1YdASyw0Ew3Hx9QmnbhYCr8aP7s5nMfO/uWN0tTzzJwmeHG23
         1IZXYfRR2AcZbw0eAxEBhzv9AT1PIsXEFDjXB5MSYTbidFclJ4GNdCkaiBp/O/yOxWJ/
         u0J8EWDeYBLK3IAlxHlOeSCJWLBSdwM3dRNasLwbBSQdWRtxU8QQo6O85yEKC5in0OKl
         WxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=69CLbJ0NNAdwBPQxwWiGjKtl0m0UdtiwySOm+Lzujp4=;
        b=Gup58XMmd/dP1sxwXbE/2u/ghc8LnmrnqSAJlKcJaFhpGWzmYsa0bFq4PqIRreNzEy
         cf/T9qAlqIiJ6PmOnnHWjqrxGETPd74tOG/RLyj+NT5m/rMrh/39t0WhLqVopuDiZ/98
         /4tLqUM3cfJ7D90dJIwmhNYDq4UN0Io8kQSS4gmYNI8/N5SXWSqPidXVk04xxEtnzzJh
         CjCGmJmDAbayQnNWxDY4WK6FHxJdmtTE21ZxpM1xCgXuOn5GDHYRc1i10P1d4bBHKrMD
         MD+tNguyL5PL+ygWIqR5y5g+Rp8wofGIw/Q90+pBDAdTI0Aox246cJEFW2jVS+td5AAP
         ncdg==
X-Gm-Message-State: APjAAAWLKTrvu3jRJ42OOc1dqRwOd2jvZO1CFJs7Qc+tPaUIHougNMHq
        aHD0PGNIXY8iZN5zRAK8Gcs8TSSUfBR90QZK8T8nZD9XV21XgU/BIYjJCmP+MiNzxVL83hZ6y9z
        ZhpATWQcp1HqA/1KwXTuRsO0NM1ZdRj/rbbRO4y6Q2BRaYWZ3Mf7URnSO9bEubQ==
X-Google-Smtp-Source: APXvYqw6n15b9D8jhfUn22zGjE8I1E2xR/dzbv+GbtqXmG+J1k7YCfkA+cdAwK1TbzJD0LpMwtDpKrJ5ABg=
X-Received: by 2002:a63:f501:: with SMTP id w1mr469236pgh.61.1582824873182;
 Thu, 27 Feb 2020 09:34:33 -0800 (PST)
Date:   Thu, 27 Feb 2020 09:34:28 -0800
Message-Id: <20200227173428.5298-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v3 net-next] netdev attribute to control xdpgeneric skb linearization
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
	/sys/class/net/<DEVICE>/xdp_linearize
The default is 1 (on)

Motivation: xdp expects linear skbs with some minimum headroom, and
generic xdp calls skb_linearize() if needed. The linearizatio is
expensive though, and may be unnecessary e.g. when the xdp program does
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

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 Documentation/ABI/testing/sysfs-class-net |  8 ++++++++
 include/linux/netdevice.h                 |  3 ++-
 net/core/dev.c                            |  8 ++++++--
 net/core/net-sysfs.c                      | 15 +++++++++++++++
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index 664a8f6a634f3..5917af789c53c 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -301,3 +301,11 @@ Contact:	netdev@vger.kernel.org
 Description:
 		32-bit unsigned integer counting the number of times the link has
 		been down
+
+What:		/sys/class/net/<iface>/xdp_linearize
+Date:		Jan 2020
+KernelVersion:	5.6
+Contact:	netdev@vger.kernel.org
+Description:
+		boolean controlling whether skb should be linearized in
+		generic xdp. Defaults to true.
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6c3f7032e8d9d..66fe80d9b5d09 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1985,7 +1985,8 @@ struct net_device {
 
 	struct netdev_rx_queue	*_rx;
 	unsigned int		num_rx_queues;
-	unsigned int		real_num_rx_queues;
+	unsigned int		real_num_rx_queues:31;
+	unsigned int		xdp_linearize : 1;
 
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
diff --git a/net/core/dev.c b/net/core/dev.c
index dbbfff123196a..ef54c33de3492 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4520,9 +4520,12 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* XDP packets must be linear and must have sufficient headroom
 	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
 	 * native XDP provides, thus we need to do it here as well.
+	 * For non shared skbs linearization is controlled by xdp_linearize.
 	 */
-	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+	if (skb_cloned(skb) ||
+	    (skb->dev->xdp_linearize &&
+	     (skb_is_nonlinear(skb) ||
+	      skb_headroom(skb) < XDP_PACKET_HEADROOM))) {
 		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
 		int troom = skb->tail + skb->data_len - skb->end;
 
@@ -9806,6 +9809,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->upper_level = 1;
 	dev->lower_level = 1;
+	dev->xdp_linearize = 1;
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index cf0215734ceb0..bcd45e9a20668 100644
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
2.25.0.265.gbab2e86ba0-goog

