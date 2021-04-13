Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185A935D5B8
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344331AbhDMDPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:15:51 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:48674 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241360AbhDMDPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:15:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UVPME45_1618283723;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVPME45_1618283723)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 11:15:23 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v4 01/10] netdevice: priv_flags extend to 64bit
Date:   Tue, 13 Apr 2021 11:15:14 +0800
Message-Id: <20210413031523.73507-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The size of priv_flags is 32 bits, and the number of flags currently
available has reached 32. It is time to expand the size of priv_flags to
64 bits.

Here the priv_flags is modified to 8 bytes, but the size of struct
net_device has not changed, it is still 2176 bytes. It is because _tx is
aligned based on the cache line. But there is a 4-byte hole left here.

Since the fields before and after priv_flags are read mostly, I did not
adjust the order of the fields here.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/linux/netdevice.h | 136 ++++++++++++++++++++------------------
 1 file changed, 71 insertions(+), 65 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f57b70fc251f..86e4bd08c2f1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1549,6 +1549,8 @@ struct net_device_ops {
                                                          struct net_device_path *path);
 };
 
+typedef u64 netdev_priv_flags_t;
+
 /**
  * enum netdev_priv_flags - &struct net_device priv_flags
  *
@@ -1598,72 +1600,75 @@ struct net_device_ops {
  *	skb_headlen(skb) == 0 (data starts from frag0)
  */
 enum netdev_priv_flags {
-	IFF_802_1Q_VLAN			= 1<<0,
-	IFF_EBRIDGE			= 1<<1,
-	IFF_BONDING			= 1<<2,
-	IFF_ISATAP			= 1<<3,
-	IFF_WAN_HDLC			= 1<<4,
-	IFF_XMIT_DST_RELEASE		= 1<<5,
-	IFF_DONT_BRIDGE			= 1<<6,
-	IFF_DISABLE_NETPOLL		= 1<<7,
-	IFF_MACVLAN_PORT		= 1<<8,
-	IFF_BRIDGE_PORT			= 1<<9,
-	IFF_OVS_DATAPATH		= 1<<10,
-	IFF_TX_SKB_SHARING		= 1<<11,
-	IFF_UNICAST_FLT			= 1<<12,
-	IFF_TEAM_PORT			= 1<<13,
-	IFF_SUPP_NOFCS			= 1<<14,
-	IFF_LIVE_ADDR_CHANGE		= 1<<15,
-	IFF_MACVLAN			= 1<<16,
-	IFF_XMIT_DST_RELEASE_PERM	= 1<<17,
-	IFF_L3MDEV_MASTER		= 1<<18,
-	IFF_NO_QUEUE			= 1<<19,
-	IFF_OPENVSWITCH			= 1<<20,
-	IFF_L3MDEV_SLAVE		= 1<<21,
-	IFF_TEAM			= 1<<22,
-	IFF_RXFH_CONFIGURED		= 1<<23,
-	IFF_PHONY_HEADROOM		= 1<<24,
-	IFF_MACSEC			= 1<<25,
-	IFF_NO_RX_HANDLER		= 1<<26,
-	IFF_FAILOVER			= 1<<27,
-	IFF_FAILOVER_SLAVE		= 1<<28,
-	IFF_L3MDEV_RX_HANDLER		= 1<<29,
-	IFF_LIVE_RENAME_OK		= 1<<30,
-	IFF_TX_SKB_NO_LINEAR		= 1<<31,
+	IFF_802_1Q_VLAN_BIT,
+	IFF_EBRIDGE_BIT,
+	IFF_BONDING_BIT,
+	IFF_ISATAP_BIT,
+	IFF_WAN_HDLC_BIT,
+	IFF_XMIT_DST_RELEASE_BIT,
+	IFF_DONT_BRIDGE_BIT,
+	IFF_DISABLE_NETPOLL_BIT,
+	IFF_MACVLAN_PORT_BIT,
+	IFF_BRIDGE_PORT_BIT,
+	IFF_OVS_DATAPATH_BIT,
+	IFF_TX_SKB_SHARING_BIT,
+	IFF_UNICAST_FLT_BIT,
+	IFF_TEAM_PORT_BIT,
+	IFF_SUPP_NOFCS_BIT,
+	IFF_LIVE_ADDR_CHANGE_BIT,
+	IFF_MACVLAN_BIT,
+	IFF_XMIT_DST_RELEASE_PERM_BIT,
+	IFF_L3MDEV_MASTER_BIT,
+	IFF_NO_QUEUE_BIT,
+	IFF_OPENVSWITCH_BIT,
+	IFF_L3MDEV_SLAVE_BIT,
+	IFF_TEAM_BIT,
+	IFF_RXFH_CONFIGURED_BIT,
+	IFF_PHONY_HEADROOM_BIT,
+	IFF_MACSEC_BIT,
+	IFF_NO_RX_HANDLER_BIT,
+	IFF_FAILOVER_BIT,
+	IFF_FAILOVER_SLAVE_BIT,
+	IFF_L3MDEV_RX_HANDLER_BIT,
+	IFF_LIVE_RENAME_OK_BIT,
+	IFF_TX_SKB_NO_LINEAR_BIT,
 };
 
-#define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
-#define IFF_EBRIDGE			IFF_EBRIDGE
-#define IFF_BONDING			IFF_BONDING
-#define IFF_ISATAP			IFF_ISATAP
-#define IFF_WAN_HDLC			IFF_WAN_HDLC
-#define IFF_XMIT_DST_RELEASE		IFF_XMIT_DST_RELEASE
-#define IFF_DONT_BRIDGE			IFF_DONT_BRIDGE
-#define IFF_DISABLE_NETPOLL		IFF_DISABLE_NETPOLL
-#define IFF_MACVLAN_PORT		IFF_MACVLAN_PORT
-#define IFF_BRIDGE_PORT			IFF_BRIDGE_PORT
-#define IFF_OVS_DATAPATH		IFF_OVS_DATAPATH
-#define IFF_TX_SKB_SHARING		IFF_TX_SKB_SHARING
-#define IFF_UNICAST_FLT			IFF_UNICAST_FLT
-#define IFF_TEAM_PORT			IFF_TEAM_PORT
-#define IFF_SUPP_NOFCS			IFF_SUPP_NOFCS
-#define IFF_LIVE_ADDR_CHANGE		IFF_LIVE_ADDR_CHANGE
-#define IFF_MACVLAN			IFF_MACVLAN
-#define IFF_XMIT_DST_RELEASE_PERM	IFF_XMIT_DST_RELEASE_PERM
-#define IFF_L3MDEV_MASTER		IFF_L3MDEV_MASTER
-#define IFF_NO_QUEUE			IFF_NO_QUEUE
-#define IFF_OPENVSWITCH			IFF_OPENVSWITCH
-#define IFF_L3MDEV_SLAVE		IFF_L3MDEV_SLAVE
-#define IFF_TEAM			IFF_TEAM
-#define IFF_RXFH_CONFIGURED		IFF_RXFH_CONFIGURED
-#define IFF_PHONY_HEADROOM		IFF_PHONY_HEADROOM
-#define IFF_MACSEC			IFF_MACSEC
-#define IFF_NO_RX_HANDLER		IFF_NO_RX_HANDLER
-#define IFF_FAILOVER			IFF_FAILOVER
-#define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
-#define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
-#define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
-#define IFF_TX_SKB_NO_LINEAR		IFF_TX_SKB_NO_LINEAR
+#define __IFF_BIT(bit)		((netdev_priv_flags_t)1 << (bit))
+#define __IFF(name)		__IFF_BIT(IFF_##name##_BIT)
+
+#define IFF_802_1Q_VLAN			__IFF(802_1Q_VLAN)
+#define IFF_EBRIDGE			__IFF(EBRIDGE)
+#define IFF_BONDING			__IFF(BONDING)
+#define IFF_ISATAP			__IFF(ISATAP)
+#define IFF_WAN_HDLC			__IFF(WAN_HDLC)
+#define IFF_XMIT_DST_RELEASE		__IFF(XMIT_DST_RELEASE)
+#define IFF_DONT_BRIDGE			__IFF(DONT_BRIDGE)
+#define IFF_DISABLE_NETPOLL		__IFF(DISABLE_NETPOLL)
+#define IFF_MACVLAN_PORT		__IFF(MACVLAN_PORT)
+#define IFF_BRIDGE_PORT			__IFF(BRIDGE_PORT)
+#define IFF_OVS_DATAPATH		__IFF(OVS_DATAPATH)
+#define IFF_TX_SKB_SHARING		__IFF(TX_SKB_SHARING)
+#define IFF_UNICAST_FLT			__IFF(UNICAST_FLT)
+#define IFF_TEAM_PORT			__IFF(TEAM_PORT)
+#define IFF_SUPP_NOFCS			__IFF(SUPP_NOFCS)
+#define IFF_LIVE_ADDR_CHANGE		__IFF(LIVE_ADDR_CHANGE)
+#define IFF_MACVLAN			__IFF(MACVLAN)
+#define IFF_XMIT_DST_RELEASE_PERM	__IFF(XMIT_DST_RELEASE_PERM)
+#define IFF_L3MDEV_MASTER		__IFF(L3MDEV_MASTER)
+#define IFF_NO_QUEUE			__IFF(NO_QUEUE)
+#define IFF_OPENVSWITCH			__IFF(OPENVSWITCH)
+#define IFF_L3MDEV_SLAVE		__IFF(L3MDEV_SLAVE)
+#define IFF_TEAM			__IFF(TEAM)
+#define IFF_RXFH_CONFIGURED		__IFF(RXFH_CONFIGURED)
+#define IFF_PHONY_HEADROOM		__IFF(PHONY_HEADROOM)
+#define IFF_MACSEC			__IFF(MACSEC)
+#define IFF_NO_RX_HANDLER		__IFF(NO_RX_HANDLER)
+#define IFF_FAILOVER			__IFF(FAILOVER)
+#define IFF_FAILOVER_SLAVE		__IFF(FAILOVER_SLAVE)
+#define IFF_L3MDEV_RX_HANDLER		__IFF(L3MDEV_RX_HANDLER)
+#define IFF_LIVE_RENAME_OK		__IFF(LIVE_RENAME_OK)
+#define IFF_TX_SKB_NO_LINEAR		__IFF(TX_SKB_NO_LINEAR)
 
 /* Specifies the type of the struct net_device::ml_priv pointer */
 enum netdev_ml_priv_type {
@@ -1963,7 +1968,8 @@ struct net_device {
 
 	/* Read-mostly cache-line for fast-path access */
 	unsigned int		flags;
-	unsigned int		priv_flags;
+	/* 4 byte hole */
+	netdev_priv_flags_t	priv_flags;
 	const struct net_device_ops *netdev_ops;
 	int			ifindex;
 	unsigned short		gflags;
-- 
2.31.0

