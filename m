Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6EE31CF02
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhBPR22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:28:28 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:48642 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhBPR2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 12:28:10 -0500
Date:   Tue, 16 Feb 2021 17:27:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613496445; bh=F79GxxLFgGar0uDA252Y0utA5OPZJ+zP9u/t7cIgBJg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=U+AaaHNZclbjjTg3cviprd1ajTaCAzE9tfmK+uBpazvaAC6dCVKE7V+DFrjp3pgQG
         DUXGnRCFmonFsD2zI9rJHpGbALxWCRVESI85N7H9z+3Eb2XvB2Tx4IsvcqQgBxo/pz
         BpOQQgSKxi1KzRkNqk/XrOTG8qXGd1r++gBc/0XtAMr5ApgjXwe1xKJ/wBIBiTYPo0
         tukpi/Y9HRAn7kmMxkh5DpKvq8pneMPYKVlIcbPYj9umMGEYH1GeynZatSZUkvVj1+
         5uOcCo9B2TwSrZ4E1l0r2a47ri7Dpwg04X94U5Jvp1lxGa2Ep4WIBdyWIKSOyf7omZ
         iphQDi/miS+4w==
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: [PATCH v6 bpf-next 2/6] netdevice: check for net_device::priv_flags bitfield overflow
Message-ID: <20210216172640.374487-3-alobakin@pm.me>
In-Reply-To: <20210216172640.374487-1-alobakin@pm.me>
References: <20210216172640.374487-1-alobakin@pm.me>
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
 include/linux/netdevice.h | 135 ++++++++++++++++++++------------------
 1 file changed, 72 insertions(+), 63 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b895973390ee..0a9b2b31f411 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1527,70 +1527,79 @@ struct net_device_ops {
  * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
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
@@ -1925,7 +1934,7 @@ struct net_device {
 =09const struct header_ops *header_ops;
=20
 =09unsigned int=09=09flags;
-=09unsigned int=09=09priv_flags;
+=09netdev_priv_flags_t=09priv_flags;
=20
 =09unsigned short=09=09gflags;
 =09unsigned short=09=09padded;
--=20
2.30.1


