Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23853304D35
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 00:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731708AbhAZXEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:04:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392968AbhAZRlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611682791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IFp7XUFQoexvLrbCvUTVH11jM+Rk85sANRL4Qy6Bv6Q=;
        b=drSC6w2eQ5kSry2exq7fxyMyXlvFNXRrX1gaAaprY0VwogFZ38C6t2Qe+uuL/lADIbndy0
        iHvBcyTK3yWx2i0AX/DsqT+kcSDxYX6M823rXFv3Jtch8L8qaoJDOEpjglGFKx0HjY9pif
        574lppL6E5Zrwu+mh2tx8pLyfm8XRhU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-hxHZCvQ3PWikHu4CPHGlfQ-1; Tue, 26 Jan 2021 12:39:46 -0500
X-MC-Unique: hxHZCvQ3PWikHu4CPHGlfQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A37241922963;
        Tue, 26 Jan 2021 17:39:44 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A01C6B8D4;
        Tue, 26 Jan 2021 17:39:41 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E1AF93217DA48;
        Tue, 26 Jan 2021 18:39:39 +0100 (CET)
Subject: [PATCH net-next V1] net: adjust net_device layout for cacheline usage
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 26 Jan 2021 18:39:39 +0100
Message-ID: <161168277983.410784.12401225493601624417.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current layout of net_device is not optimal for cacheline usage.

The member adj_list.lower linked list is split between cacheline 2 and 3.
The ifindex is placed together with stats (struct net_device_stats),
although most modern drivers don't update this stats member.

The members netdev_ops, mtu and hard_header_len are placed on three
different cachelines. These members are accessed for XDP redirect into
devmap, which were noticeably with perf tool. When not using the map
redirect variant (like TC-BPF does), then ifindex is also used, which is
placed on a separate fourth cacheline. These members are also accessed
during forwarding with regular network stack. The members priv_flags and
flags are on fast-path for network stack transmit path in __dev_queue_xmit
(currently located together with mtu cacheline).

This patch creates a read mostly cacheline, with the purpose of keeping the
above mentioned members on the same cacheline.

Some netdev_features_t members also becomes part of this cacheline, which is
on purpose, as function netif_skb_features() is on fast-path via
validate_xmit_skb().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/netdevice.h |   53 +++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b7915484369c..2645f114de54 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1855,7 +1855,6 @@ struct net_device {
 	unsigned long		mem_end;
 	unsigned long		mem_start;
 	unsigned long		base_addr;
-	int			irq;
 
 	/*
 	 *	Some hardware also needs these fields (state,dev_list,
@@ -1877,6 +1876,23 @@ struct net_device {
 		struct list_head lower;
 	} adj_list;
 
+	/* Read-mostly cache-line for fast-path access */
+	unsigned int		flags;
+	unsigned int		priv_flags;
+	const struct net_device_ops *netdev_ops;
+	int			ifindex;
+	unsigned short		gflags;
+	unsigned short		hard_header_len;
+
+	/* Note : dev->mtu is often read without holding a lock.
+	 * Writers usually hold RTNL.
+	 * It is recommended to use READ_ONCE() to annotate the reads,
+	 * and to use WRITE_ONCE() to annotate the writes.
+	 */
+	unsigned int		mtu;
+	unsigned short		needed_headroom;
+	unsigned short		needed_tailroom;
+
 	netdev_features_t	features;
 	netdev_features_t	hw_features;
 	netdev_features_t	wanted_features;
@@ -1885,10 +1901,15 @@ struct net_device {
 	netdev_features_t	mpls_features;
 	netdev_features_t	gso_partial_features;
 
-	int			ifindex;
+	unsigned int		min_mtu;
+	unsigned int		max_mtu;
+	unsigned short		type;
+	unsigned char		min_header_len;
+	unsigned char		name_assign_type;
+
 	int			group;
 
-	struct net_device_stats	stats;
+	struct net_device_stats	stats; /* not used by modern drivers */
 
 	atomic_long_t		rx_dropped;
 	atomic_long_t		tx_dropped;
@@ -1902,7 +1923,6 @@ struct net_device {
 	const struct iw_handler_def *wireless_handlers;
 	struct iw_public_data	*wireless_data;
 #endif
-	const struct net_device_ops *netdev_ops;
 	const struct ethtool_ops *ethtool_ops;
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	const struct l3mdev_ops	*l3mdev_ops;
@@ -1921,34 +1941,12 @@ struct net_device {
 
 	const struct header_ops *header_ops;
 
-	unsigned int		flags;
-	unsigned int		priv_flags;
-
-	unsigned short		gflags;
-	unsigned short		padded;
-
 	unsigned char		operstate;
 	unsigned char		link_mode;
 
 	unsigned char		if_port;
 	unsigned char		dma;
 
-	/* Note : dev->mtu is often read without holding a lock.
-	 * Writers usually hold RTNL.
-	 * It is recommended to use READ_ONCE() to annotate the reads,
-	 * and to use WRITE_ONCE() to annotate the writes.
-	 */
-	unsigned int		mtu;
-	unsigned int		min_mtu;
-	unsigned int		max_mtu;
-	unsigned short		type;
-	unsigned short		hard_header_len;
-	unsigned char		min_header_len;
-	unsigned char		name_assign_type;
-
-	unsigned short		needed_headroom;
-	unsigned short		needed_tailroom;
-
 	/* Interface address info. */
 	unsigned char		perm_addr[MAX_ADDR_LEN];
 	unsigned char		addr_assign_type;
@@ -1959,7 +1957,10 @@ struct net_device {
 	unsigned short		neigh_priv_len;
 	unsigned short          dev_id;
 	unsigned short          dev_port;
+	unsigned short		padded;
+
 	spinlock_t		addr_list_lock;
+	int			irq;
 
 	struct netdev_hw_addr_list	uc;
 	struct netdev_hw_addr_list	mc;


