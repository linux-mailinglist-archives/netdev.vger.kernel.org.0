Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF904147493
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 00:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgAWXVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 18:21:04 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:44982 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAWXVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 18:21:03 -0500
Received: by mail-pl1-f201.google.com with SMTP id h8so112293plr.11
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 15:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8MxHEaqQsoNrwKU0X9Ot7ueJ/+uJZG7MLa+Pg3ZDjVA=;
        b=i2NLYO18r41TW48tf/298jvh6PdDKfmaHm/PcMJJWu2oick4eqEXVMMa886xLC/Yoq
         GTqp+6AG6dkj/si48CWrJONqZK9U8Ed64QteclSb7LPOJk/3PWvb01Yh3lEhV8KRO9jO
         IGS7yjOvAipFD5/TjgI3g8h/L+IrcjYdP6DQQXnhFGr7nxoSayz15lTQBGShM8M43Heq
         YqgVIQk3hI37wGv0Tm13btIktYZA6DYm+KxrO3HgzQdqzRpYftf9eKq9e2uNQxNR3Mwb
         2e1cAKdeaX15YEkLLrxoUWgJlXZUYJwU6w852KI0CafZbWPdzh7A1zn+ZJUXWoL1lway
         Y98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8MxHEaqQsoNrwKU0X9Ot7ueJ/+uJZG7MLa+Pg3ZDjVA=;
        b=asA4uckQPyGSY2Z6HvwlbblmhLM8yjJte9XWtSH2s2nTd6lZdqsm75icmNguC2PLad
         bD5O3402rriLmIxiXBQv3yxyNaeC8JDPjz6/0ZQdVWFL1E+mYDcbwCM+ZhdUPRKGK1bN
         JyJ4CzkBCgpK6ndtHlaTmviNgg7w3eAVokCIZRm5BsKgi5q45YYgqOUJxCIEJduW8VgD
         11C3v8gklA2PoEymNb0dooER9KYyHfrhTx6MWpJX7YJa7waN1SPU8zvK8bZ9yQWa/bTE
         kKNVn51flJbhDiMbRLd3OiZdBTOLBDSQuKaM8wKGUp2hmsoylNFVZ5k9sqz80TWySmWP
         pH2Q==
X-Gm-Message-State: APjAAAVwz/bnbpa7R5UdgbkW4sHHtDoTQKuoZ/ygK3pJXt8imU5TkngC
        BOKxOjuM2n5UYbYC+DTJMybR841k90nVdO/6p8KxB0wgDyRg8w//KczALrMe1Xye1THGu0MQRQx
        DVZ0RSKRysx5wC3nG0u/5Ewkxfo7Fm85Wp9RXK4A0K0Mr5dlyjE0iMORwqtjIig==
X-Google-Smtp-Source: APXvYqzYARSDRF8/pLWa5GqrjfnO9kySXGGeXwUMVYA4cSVkjCQfHJZ6JVHIXc3EPrf25CGctElJGfGzNzg=
X-Received: by 2002:a63:cf08:: with SMTP id j8mr851528pgg.292.1579821662989;
 Thu, 23 Jan 2020 15:21:02 -0800 (PST)
Date:   Thu, 23 Jan 2020 15:20:54 -0800
Message-Id: <20200123232054.183436-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net-next] v2 net-xdp: netdev attribute to control xdpgeneric
 skb linearization
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

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/netdevice.h |  3 ++-
 net/core/dev.c            |  5 +++--
 net/core/net-sysfs.c      | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5ec3537fbdb1..b182f3cb0bf0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1959,7 +1959,8 @@ struct net_device {
 
 	struct netdev_rx_queue	*_rx;
 	unsigned int		num_rx_queues;
-	unsigned int		real_num_rx_queues;
+	unsigned int		real_num_rx_queues:31;
+	unsigned int		xdp_linearize : 1;
 
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
diff --git a/net/core/dev.c b/net/core/dev.c
index 4dcc1b390667..13a671e45b61 100644
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

