Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A492631D915
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhBQMDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:03:48 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:14358 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbhBQMC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:02:26 -0500
Date:   Wed, 17 Feb 2021 12:01:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613563276; bh=6DL4KLQOQC3zKbOQ+sDV/WMzc6ub+ldnNzx24Bfbo8c=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=cERpgKPIoX8HUR9e8LXW7Tj0GZ3D1maFvT1wfGzcyQ8RnTvB/evnZg4jXQOHLMUFe
         oBc0QxAqUfgt4wFGSSQZoa6qKK1I8lY2neXTWd9MJIAX0d6DEu7zgFoJ0XWWEIIj7X
         dXITrQoqVjATrTjUpARuXR4WqU62IMJSKSZCQprqFyd4TlhVqMcqULX5zRN4bwxAuR
         Ccp7cMUPf9tL1b4VUJU/asvhPDHLn+OYBPUUZ230Xl+FnklsyAtWHWNieZVUjs2YiG
         D1NJItf0vUz56NULOCBlj77SGh5ZYqf8WZ5LlmRAVlw4MvfZGPXuR53Refu0D2LzSs
         JUOXK6H6eO1yw==
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Alexander Lobakin <alobakin@pm.me>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v7 bpf-next 2/6] netdevice: check for net_device::priv_flags bitfield overflow
Message-ID: <20210217120003.7938-3-alobakin@pm.me>
In-Reply-To: <20210217120003.7938-1-alobakin@pm.me>
References: <20210217120003.7938-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.4 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UPPERCASE_50_75 shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We almost ran out of unsigned int bitwidth. Define priv flags and
check for potential overflow in the fashion of netdev_features_t.
Defined this way, priv_flags can be easily expanded later with
just changing its typedef.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reported-by: kernel test robot <lkp@intel.com> # Inverted assert condition
---
 include/linux/netdevice.h | 199 ++++++++++++++++++++------------------
 1 file changed, 105 insertions(+), 94 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3b6f82c2c271..2c1a642ecdc0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1483,107 +1483,118 @@ struct net_device_ops {
  *
  * You should have a pretty good reason to be extending these flags.
  *
- * @IFF_802_1Q_VLAN: 802.1Q VLAN device
- * @IFF_EBRIDGE: Ethernet bridging device
- * @IFF_BONDING: bonding master or slave
- * @IFF_ISATAP: ISATAP interface (RFC4214)
- * @IFF_WAN_HDLC: WAN HDLC device
- * @IFF_XMIT_DST_RELEASE: dev_hard_start_xmit() is allowed to
+ * @IFF_802_1Q_VLAN_BIT: 802.1Q VLAN device
+ * @IFF_EBRIDGE_BIT: Ethernet bridging device
+ * @IFF_BONDING_BIT: bonding master or slave
+ * @IFF_ISATAP_BIT: ISATAP interface (RFC4214)
+ * @IFF_WAN_HDLC_BIT: WAN HDLC device
+ * @IFF_XMIT_DST_RELEASE_BIT: dev_hard_start_xmit() is allowed to
  *=09release skb->dst
- * @IFF_DONT_BRIDGE: disallow bridging this ether dev
- * @IFF_DISABLE_NETPOLL: disable netpoll at run-time
- * @IFF_MACVLAN_PORT: device used as macvlan port
- * @IFF_BRIDGE_PORT: device used as bridge port
- * @IFF_OVS_DATAPATH: device used as Open vSwitch datapath port
- * @IFF_TX_SKB_SHARING: The interface supports sharing skbs on transmit
- * @IFF_UNICAST_FLT: Supports unicast filtering
- * @IFF_TEAM_PORT: device used as team port
- * @IFF_SUPP_NOFCS: device supports sending custom FCS
- * @IFF_LIVE_ADDR_CHANGE: device supports hardware address
+ * @IFF_DONT_BRIDGE_BIT: disallow bridging this ether dev
+ * @IFF_DISABLE_NETPOLL_BIT: disable netpoll at run-time
+ * @IFF_MACVLAN_PORT_BIT: device used as macvlan port
+ * @IFF_BRIDGE_PORT_BIT: device used as bridge port
+ * @IFF_OVS_DATAPATH_BIT: device used as Open vSwitch datapath port
+ * @IFF_TX_SKB_SHARING_BIT: The interface supports sharing skbs on transmi=
t
+ * @IFF_UNICAST_FLT_BIT: Supports unicast filtering
+ * @IFF_TEAM_PORT_BIT: device used as team port
+ * @IFF_SUPP_NOFCS_BIT: device supports sending custom FCS
+ * @IFF_LIVE_ADDR_CHANGE_BIT: device supports hardware address
  *=09change when it's running
- * @IFF_MACVLAN: Macvlan device
- * @IFF_XMIT_DST_RELEASE_PERM: IFF_XMIT_DST_RELEASE not taking into accoun=
t
+ * @IFF_MACVLAN_BIT: Macvlan device
+ * @IFF_XMIT_DST_RELEASE_PERM_BIT: IFF_XMIT_DST_RELEASE not taking into ac=
count
  *=09underlying stacked devices
- * @IFF_L3MDEV_MASTER: device is an L3 master device
- * @IFF_NO_QUEUE: device can run without qdisc attached
- * @IFF_OPENVSWITCH: device is a Open vSwitch master
- * @IFF_L3MDEV_SLAVE: device is enslaved to an L3 master device
- * @IFF_TEAM: device is a team device
- * @IFF_RXFH_CONFIGURED: device has had Rx Flow indirection table configur=
ed
- * @IFF_PHONY_HEADROOM: the headroom value is controlled by an external
+ * @IFF_L3MDEV_MASTER_BIT: device is an L3 master device
+ * @IFF_NO_QUEUE_BIT: device can run without qdisc attached
+ * @IFF_OPENVSWITCH_BIT: device is a Open vSwitch master
+ * @IFF_L3MDEV_SLAVE_BIT: device is enslaved to an L3 master device
+ * @IFF_TEAM_BIT: device is a team device
+ * @IFF_RXFH_CONFIGURED_BIT: device has had Rx Flow indirection table conf=
igured
+ * @IFF_PHONY_HEADROOM_BIT: the headroom value is controlled by an externa=
l
  *=09entity (i.e. the master device for bridged veth)
- * @IFF_MACSEC: device is a MACsec device
- * @IFF_NO_RX_HANDLER: device doesn't support the rx_handler hook
- * @IFF_FAILOVER: device is a failover master device
- * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
- * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
- * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
+ * @IFF_MACSEC_BIT: device is a MACsec device
+ * @IFF_NO_RX_HANDLER_BIT: device doesn't support the rx_handler hook
+ * @IFF_FAILOVER_BIT: device is a failover master device
+ * @IFF_FAILOVER_SLAVE_BIT: device is lower dev of a failover master devic=
e
+ * @IFF_L3MDEV_RX_HANDLER_BIT: only invoke the rx handler of L3 master dev=
ice
+ * @IFF_LIVE_RENAME_OK_BIT: rename is allowed while device is up and runni=
ng
+ *
+ * @NETDEV_PRIV_FLAG_COUNT: total priv flags count
  */
 enum netdev_priv_flags {
-=09IFF_802_1Q_VLAN=09=09=09=3D 1<<0,
-=09IFF_EBRIDGE=09=09=09=3D 1<<1,
-=09IFF_BONDING=09=09=09=3D 1<<2,
-=09IFF_ISATAP=09=09=09=3D 1<<3,
-=09IFF_WAN_HDLC=09=09=09=3D 1<<4,
-=09IFF_XMIT_DST_RELEASE=09=09=3D 1<<5,
-=09IFF_DONT_BRIDGE=09=09=09=3D 1<<6,
-=09IFF_DISABLE_NETPOLL=09=09=3D 1<<7,
-=09IFF_MACVLAN_PORT=09=09=3D 1<<8,
-=09IFF_BRIDGE_PORT=09=09=09=3D 1<<9,
-=09IFF_OVS_DATAPATH=09=09=3D 1<<10,
-=09IFF_TX_SKB_SHARING=09=09=3D 1<<11,
-=09IFF_UNICAST_FLT=09=09=09=3D 1<<12,
-=09IFF_TEAM_PORT=09=09=09=3D 1<<13,
-=09IFF_SUPP_NOFCS=09=09=09=3D 1<<14,
-=09IFF_LIVE_ADDR_CHANGE=09=09=3D 1<<15,
-=09IFF_MACVLAN=09=09=09=3D 1<<16,
-=09IFF_XMIT_DST_RELEASE_PERM=09=3D 1<<17,
-=09IFF_L3MDEV_MASTER=09=09=3D 1<<18,
-=09IFF_NO_QUEUE=09=09=09=3D 1<<19,
-=09IFF_OPENVSWITCH=09=09=09=3D 1<<20,
-=09IFF_L3MDEV_SLAVE=09=09=3D 1<<21,
-=09IFF_TEAM=09=09=09=3D 1<<22,
-=09IFF_RXFH_CONFIGURED=09=09=3D 1<<23,
-=09IFF_PHONY_HEADROOM=09=09=3D 1<<24,
-=09IFF_MACSEC=09=09=09=3D 1<<25,
-=09IFF_NO_RX_HANDLER=09=09=3D 1<<26,
-=09IFF_FAILOVER=09=09=09=3D 1<<27,
-=09IFF_FAILOVER_SLAVE=09=09=3D 1<<28,
-=09IFF_L3MDEV_RX_HANDLER=09=09=3D 1<<29,
-=09IFF_LIVE_RENAME_OK=09=09=3D 1<<30,
+=09IFF_802_1Q_VLAN_BIT,
+=09IFF_EBRIDGE_BIT,
+=09IFF_BONDING_BIT,
+=09IFF_ISATAP_BIT,
+=09IFF_WAN_HDLC_BIT,
+=09IFF_XMIT_DST_RELEASE_BIT,
+=09IFF_DONT_BRIDGE_BIT,
+=09IFF_DISABLE_NETPOLL_BIT,
+=09IFF_MACVLAN_PORT_BIT,
+=09IFF_BRIDGE_PORT_BIT,
+=09IFF_OVS_DATAPATH_BIT,
+=09IFF_TX_SKB_SHARING_BIT,
+=09IFF_UNICAST_FLT_BIT,
+=09IFF_TEAM_PORT_BIT,
+=09IFF_SUPP_NOFCS_BIT,
+=09IFF_LIVE_ADDR_CHANGE_BIT,
+=09IFF_MACVLAN_BIT,
+=09IFF_XMIT_DST_RELEASE_PERM_BIT,
+=09IFF_L3MDEV_MASTER_BIT,
+=09IFF_NO_QUEUE_BIT,
+=09IFF_OPENVSWITCH_BIT,
+=09IFF_L3MDEV_SLAVE_BIT,
+=09IFF_TEAM_BIT,
+=09IFF_RXFH_CONFIGURED_BIT,
+=09IFF_PHONY_HEADROOM_BIT,
+=09IFF_MACSEC_BIT,
+=09IFF_NO_RX_HANDLER_BIT,
+=09IFF_FAILOVER_BIT,
+=09IFF_FAILOVER_SLAVE_BIT,
+=09IFF_L3MDEV_RX_HANDLER_BIT,
+=09IFF_LIVE_RENAME_OK_BIT,
+
+=09NETDEV_PRIV_FLAG_COUNT,
 };
=20
-#define IFF_802_1Q_VLAN=09=09=09IFF_802_1Q_VLAN
-#define IFF_EBRIDGE=09=09=09IFF_EBRIDGE
-#define IFF_BONDING=09=09=09IFF_BONDING
-#define IFF_ISATAP=09=09=09IFF_ISATAP
-#define IFF_WAN_HDLC=09=09=09IFF_WAN_HDLC
-#define IFF_XMIT_DST_RELEASE=09=09IFF_XMIT_DST_RELEASE
-#define IFF_DONT_BRIDGE=09=09=09IFF_DONT_BRIDGE
-#define IFF_DISABLE_NETPOLL=09=09IFF_DISABLE_NETPOLL
-#define IFF_MACVLAN_PORT=09=09IFF_MACVLAN_PORT
-#define IFF_BRIDGE_PORT=09=09=09IFF_BRIDGE_PORT
-#define IFF_OVS_DATAPATH=09=09IFF_OVS_DATAPATH
-#define IFF_TX_SKB_SHARING=09=09IFF_TX_SKB_SHARING
-#define IFF_UNICAST_FLT=09=09=09IFF_UNICAST_FLT
-#define IFF_TEAM_PORT=09=09=09IFF_TEAM_PORT
-#define IFF_SUPP_NOFCS=09=09=09IFF_SUPP_NOFCS
-#define IFF_LIVE_ADDR_CHANGE=09=09IFF_LIVE_ADDR_CHANGE
-#define IFF_MACVLAN=09=09=09IFF_MACVLAN
-#define IFF_XMIT_DST_RELEASE_PERM=09IFF_XMIT_DST_RELEASE_PERM
-#define IFF_L3MDEV_MASTER=09=09IFF_L3MDEV_MASTER
-#define IFF_NO_QUEUE=09=09=09IFF_NO_QUEUE
-#define IFF_OPENVSWITCH=09=09=09IFF_OPENVSWITCH
-#define IFF_L3MDEV_SLAVE=09=09IFF_L3MDEV_SLAVE
-#define IFF_TEAM=09=09=09IFF_TEAM
-#define IFF_RXFH_CONFIGURED=09=09IFF_RXFH_CONFIGURED
-#define IFF_PHONY_HEADROOM=09=09IFF_PHONY_HEADROOM
-#define IFF_MACSEC=09=09=09IFF_MACSEC
-#define IFF_NO_RX_HANDLER=09=09IFF_NO_RX_HANDLER
-#define IFF_FAILOVER=09=09=09IFF_FAILOVER
-#define IFF_FAILOVER_SLAVE=09=09IFF_FAILOVER_SLAVE
-#define IFF_L3MDEV_RX_HANDLER=09=09IFF_L3MDEV_RX_HANDLER
-#define IFF_LIVE_RENAME_OK=09=09IFF_LIVE_RENAME_OK
+typedef u32 netdev_priv_flags_t;
+static_assert(sizeof(netdev_priv_flags_t) * BITS_PER_BYTE >=3D
+=09      NETDEV_PRIV_FLAG_COUNT);
+
+#define __IFF_BIT(bit)=09=09=09((netdev_priv_flags_t)1 << (bit))
+#define __IFF(name)=09=09=09__IFF_BIT(IFF_##name##_BIT)
+
+#define IFF_802_1Q_VLAN=09=09=09__IFF(802_1Q_VLAN)
+#define IFF_EBRIDGE=09=09=09__IFF(EBRIDGE)
+#define IFF_BONDING=09=09=09__IFF(BONDING)
+#define IFF_ISATAP=09=09=09__IFF(ISATAP)
+#define IFF_WAN_HDLC=09=09=09__IFF(WAN_HDLC)
+#define IFF_XMIT_DST_RELEASE=09=09__IFF(XMIT_DST_RELEASE)
+#define IFF_DONT_BRIDGE=09=09=09__IFF(DONT_BRIDGE)
+#define IFF_DISABLE_NETPOLL=09=09__IFF(DISABLE_NETPOLL)
+#define IFF_MACVLAN_PORT=09=09__IFF(MACVLAN_PORT)
+#define IFF_BRIDGE_PORT=09=09=09__IFF(BRIDGE_PORT)
+#define IFF_OVS_DATAPATH=09=09__IFF(OVS_DATAPATH)
+#define IFF_TX_SKB_SHARING=09=09__IFF(TX_SKB_SHARING)
+#define IFF_UNICAST_FLT=09=09=09__IFF(UNICAST_FLT)
+#define IFF_TEAM_PORT=09=09=09__IFF(TEAM_PORT)
+#define IFF_SUPP_NOFCS=09=09=09__IFF(SUPP_NOFCS)
+#define IFF_LIVE_ADDR_CHANGE=09=09__IFF(LIVE_ADDR_CHANGE)
+#define IFF_MACVLAN=09=09=09__IFF(MACVLAN)
+#define IFF_XMIT_DST_RELEASE_PERM=09__IFF(XMIT_DST_RELEASE_PERM)
+#define IFF_L3MDEV_MASTER=09=09__IFF(L3MDEV_MASTER)
+#define IFF_NO_QUEUE=09=09=09__IFF(NO_QUEUE)
+#define IFF_OPENVSWITCH=09=09=09__IFF(OPENVSWITCH)
+#define IFF_L3MDEV_SLAVE=09=09__IFF(L3MDEV_SLAVE)
+#define IFF_TEAM=09=09=09__IFF(TEAM)
+#define IFF_RXFH_CONFIGURED=09=09__IFF(RXFH_CONFIGURED)
+#define IFF_PHONY_HEADROOM=09=09__IFF(PHONY_HEADROOM)
+#define IFF_MACSEC=09=09=09__IFF(MACSEC)
+#define IFF_NO_RX_HANDLER=09=09__IFF(NO_RX_HANDLER)
+#define IFF_FAILOVER=09=09=09__IFF(FAILOVER)
+#define IFF_FAILOVER_SLAVE=09=09__IFF(FAILOVER_SLAVE)
+#define IFF_L3MDEV_RX_HANDLER=09=09__IFF(L3MDEV_RX_HANDLER)
+#define IFF_LIVE_RENAME_OK=09=09__IFF(LIVE_RENAME_OK)
=20
 /**
  *=09struct net_device - The DEVICE structure.
@@ -1876,7 +1887,7 @@ struct net_device {
=20
 =09/* Read-mostly cache-line for fast-path access */
 =09unsigned int=09=09flags;
-=09unsigned int=09=09priv_flags;
+=09netdev_priv_flags_t=09priv_flags;
 =09const struct net_device_ops *netdev_ops;
 =09int=09=09=09ifindex;
 =09unsigned short=09=09gflags;
--=20
2.30.1


