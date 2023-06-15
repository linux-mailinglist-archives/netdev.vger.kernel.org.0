Return-Path: <netdev+bounces-11126-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12CD4731991
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C4D328181D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0FDE15AE9;
	Thu, 15 Jun 2023 13:06:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFD5EED1
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:06:49 +0000 (UTC)
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5904E269D;
	Thu, 15 Jun 2023 06:06:44 -0700 (PDT)
Date: Thu, 15 Jun 2023 13:06:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=d7voxzpeo5gbdcsyjzfbvkr5y4.protonmail; t=1686834402; x=1687093602;
	bh=12JY0KTjpggY+SrifkNRAOBNuXcnk6nThh9d05nZkbU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=noksQHqLx2TX1MaKh4XBBNFdUgj8MuJKG1QBjj6lXjh7L+fp7l8E5zBc2Hfx4Ge7V
	 NpgFBqFUAiT9YOCdXsBSydMYTTQhdKBVG6zbxs1CB1dZcaLTzcIb97m/y8E18r0ltg
	 uyk3pjrxVIOaWE9uAerqyS+egahPHPOx3m/XkiLo2q3ljxkBdL4Y+X/hj1CgRBD/sO
	 0KodZuoZWPcuAGmUgkyEETQiPs5wN5SzShx1y0/Y82t5v8NB2fFgCT0rK7EI5bo8mD
	 fM2M8tRdojWrONuYkK9qyLvsDVUXxL0xHVoJ9BwVyW8pI8gWwRxR/XXZc4j0wB+MGx
	 jUq8Bl/8Vc2iA==
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, aliceryhl@google.com, andrew@lunn.ch, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 4/5] rust: add methods for configure net_device
Message-ID: <TR5j4CL3ot6FLTrhGWNFAn_yFZ3Rg4mp4nlDd_sk_ll_vC_3SwYn03RuRsGMg7ADZo8EiX0gEhfElQplgeFKko8HNvz3kII_H8ifV1yLjOM=@proton.me>
In-Reply-To: <20230613045326.3938283-5-fujita.tomonori@gmail.com>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com> <20230613045326.3938283-5-fujita.tomonori@gmail.com>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/13/23 06:53, FUJITA Tomonori wrote:
> adds methods to net::Device for the basic configurations of
> net_device.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/helpers.c         |   7 ++
>  rust/kernel/net/dev.rs | 183 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 190 insertions(+)
>=20
> diff --git a/rust/helpers.c b/rust/helpers.c
> index 70d50767ff4e..6c51deb18dc1 100644
> --- a/rust/helpers.c
> +++ b/rust/helpers.c
> @@ -22,6 +22,7 @@
>  #include <linux/build_bug.h>
>  #include <linux/err.h>
>  #include <linux/errname.h>
> +#include <linux/etherdevice.h>
>  #include <linux/refcount.h>
>  #include <linux/mutex.h>
>  #include <linux/netdevice.h>
> @@ -31,6 +32,12 @@
>  #include <linux/wait.h>
>=20
>  #ifdef CONFIG_NET
> +void rust_helper_eth_hw_addr_random(struct net_device *dev)
> +{
> +=09eth_hw_addr_random(dev);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_eth_hw_addr_random);
> +
>  void *rust_helper_netdev_priv(const struct net_device *dev)
>  {
>  =09return netdev_priv(dev);
> diff --git a/rust/kernel/net/dev.rs b/rust/kernel/net/dev.rs
> index 452944cf9fb8..4767f331973e 100644
> --- a/rust/kernel/net/dev.rs
> +++ b/rust/kernel/net/dev.rs
> @@ -12,10 +12,118 @@
>      bindings,
>      error::*,
>      prelude::vtable,
> +    str::CStr,
>      types::{ForeignOwnable, Opaque},
>  };
>  use {core::ffi::c_void, core::marker::PhantomData};
>=20
> +/// Flags associated with a [`Device`].
> +pub mod flags {
> +    /// Interface is up.
> +    pub const IFF_UP: u32 =3D bindings::net_device_flags_IFF_UP;
> +    /// Broadcast address valid.
> +    pub const IFF_BROADCAST: u32 =3D bindings::net_device_flags_IFF_BROA=
DCAST;
> +    /// Device on debugging.
> +    pub const IFF_DEBUG: u32 =3D bindings::net_device_flags_IFF_DEBUG;
> +    /// Loopback device.
> +    pub const IFF_LOOPBACK: u32 =3D bindings::net_device_flags_IFF_LOOPB=
ACK;
> +    /// Has p-p link.
> +    pub const IFF_POINTOPOINT: u32 =3D bindings::net_device_flags_IFF_PO=
INTOPOINT;
> +    /// Avoids use of trailers.
> +    pub const IFF_NOTRAILERS: u32 =3D bindings::net_device_flags_IFF_NOT=
RAILERS;
> +    /// Interface RFC2863 OPER_UP.
> +    pub const IFF_RUNNING: u32 =3D bindings::net_device_flags_IFF_RUNNIN=
G;
> +    /// No ARP protocol.
> +    pub const IFF_NOARP: u32 =3D bindings::net_device_flags_IFF_NOARP;
> +    /// Receives all packets.
> +    pub const IFF_PROMISC: u32 =3D bindings::net_device_flags_IFF_PROMIS=
C;
> +    /// Receive all multicast packets.
> +    pub const IFF_ALLMULTI: u32 =3D bindings::net_device_flags_IFF_ALLMU=
LTI;
> +    /// Master of a load balancer.
> +    pub const IFF_MASTER: u32 =3D bindings::net_device_flags_IFF_MASTER;
> +    /// Slave of a load balancer.
> +    pub const IFF_SLAVE: u32 =3D bindings::net_device_flags_IFF_SLAVE;
> +    /// Supports multicast.
> +    pub const IFF_MULTICAST: u32 =3D bindings::net_device_flags_IFF_MULT=
ICAST;
> +    /// Capable of setting media type.
> +    pub const IFF_PORTSEL: u32 =3D bindings::net_device_flags_IFF_PORTSE=
L;
> +    /// Auto media select active.
> +    pub const IFF_AUTOMEDIA: u32 =3D bindings::net_device_flags_IFF_AUTO=
MEDIA;
> +    /// Dialup device with changing addresses.
> +    pub const IFF_DYNAMIC: u32 =3D bindings::net_device_flags_IFF_DYNAMI=
C;
> +}
> +
> +/// Private flags associated with a [`Device`].
> +pub mod priv_flags {
> +    /// 802.1Q VLAN device.
> +    pub const IFF_802_1Q_VLAN: u64 =3D bindings::netdev_priv_flags_IFF_8=
02_1Q_VLAN;
> +    /// Ethernet bridging device.
> +    pub const IFF_EBRIDGE: u64 =3D bindings::netdev_priv_flags_IFF_EBRID=
GE;
> +    /// Bonding master or slave device.
> +    pub const IFF_BONDING: u64 =3D bindings::netdev_priv_flags_IFF_BONDI=
NG;
> +    /// ISATAP interface (RFC4214).
> +    pub const IFF_ISATAP: u64 =3D bindings::netdev_priv_flags_IFF_ISATAP=
;
> +    /// WAN HDLC device.
> +    pub const IFF_WAN_HDLC: u64 =3D bindings::netdev_priv_flags_IFF_WAN_=
HDLC;
> +    /// dev_hard_start_xmit() is allowed to release skb->dst.
> +    pub const IFF_XMIT_DST_RELEASE: u64 =3D bindings::netdev_priv_flags_=
IFF_XMIT_DST_RELEASE;
> +    /// Disallows bridging this ether device.
> +    pub const IFF_DONT_BRIDGE: u64 =3D bindings::netdev_priv_flags_IFF_D=
ONT_BRIDGE;
> +    /// Disables netpoll at run-time.
> +    pub const IFF_DISABLE_NETPOLL: u64 =3D bindings::netdev_priv_flags_I=
FF_DISABLE_NETPOLL;
> +    /// Device used as macvlan port.
> +    pub const IFF_MACVLAN_PORT: u64 =3D bindings::netdev_priv_flags_IFF_=
MACVLAN_PORT;
> +    /// Device used as bridge port.
> +    pub const IFF_BRIDGE_PORT: u64 =3D bindings::netdev_priv_flags_IFF_B=
RIDGE_PORT;
> +    /// Device used as Open vSwitch datapath port.
> +    pub const IFF_OVS_DATAPATH: u64 =3D bindings::netdev_priv_flags_IFF_=
OVS_DATAPATH;
> +    /// The interface supports sharing skbs on transmit.
> +    pub const IFF_TX_SKB_SHARING: u64 =3D bindings::netdev_priv_flags_IF=
F_TX_SKB_SHARING;
> +    /// Supports unicast filtering.
> +    pub const IFF_UNICAST_FLT: u64 =3D bindings::netdev_priv_flags_IFF_U=
NICAST_FLT;
> +    /// Device used as team port.
> +    pub const IFF_TEAM_PORT: u64 =3D bindings::netdev_priv_flags_IFF_TEA=
M_PORT;
> +    /// Device supports sending custom FCS.
> +    pub const IFF_SUPP_NOFCS: u64 =3D bindings::netdev_priv_flags_IFF_SU=
PP_NOFCS;
> +    /// Device supports hardware address change when it's running.
> +    pub const IFF_LIVE_ADDR_CHANGE: u64 =3D bindings::netdev_priv_flags_=
IFF_LIVE_ADDR_CHANGE;
> +    /// Macvlan device.
> +    pub const IFF_MACVLAN: u64 =3D bindings::netdev_priv_flags_IFF_MACVL=
AN;
> +    /// IFF_XMIT_DST_RELEASE not taking into account underlying stacked =
devices.
> +    pub const IFF_XMIT_DST_RELEASE_PERM: u64 =3D
> +        bindings::netdev_priv_flags_IFF_XMIT_DST_RELEASE_PERM;
> +    /// L3 master device.
> +    pub const IFF_L3MDEV_MASTER: u64 =3D bindings::netdev_priv_flags_IFF=
_L3MDEV_MASTER;
> +    /// Device can run without qdisc attached.
> +    pub const IFF_NO_QUEUE: u64 =3D bindings::netdev_priv_flags_IFF_NO_Q=
UEUE;
> +    /// Device is a Open vSwitch master.
> +    pub const IFF_OPENVSWITCH: u64 =3D bindings::netdev_priv_flags_IFF_O=
PENVSWITCH;
> +    /// Device is enslaved to an L3 master.
> +    pub const IFF_L3MDEV_SLAVE: u64 =3D bindings::netdev_priv_flags_IFF_=
L3MDEV_SLAVE;
> +    /// Team device.
> +    pub const IFF_TEAM: u64 =3D bindings::netdev_priv_flags_IFF_TEAM;
> +    /// Device has had Rx Flow indirection table configured.
> +    pub const IFF_RXFH_CONFIGURED: u64 =3D bindings::netdev_priv_flags_I=
FF_RXFH_CONFIGURED;
> +    /// The headroom value is controlled by an external entity.
> +    pub const IFF_PHONY_HEADROOM: u64 =3D bindings::netdev_priv_flags_IF=
F_PHONY_HEADROOM;
> +    /// MACsec device.
> +    pub const IFF_MACSEC: u64 =3D bindings::netdev_priv_flags_IFF_MACSEC=
;
> +    /// Device doesn't support the rx_handler hook.
> +    pub const IFF_NO_RX_HANDLER: u64 =3D bindings::netdev_priv_flags_IFF=
_NO_RX_HANDLER;
> +    /// Failover master device.
> +    pub const IFF_FAILOVER: u64 =3D bindings::netdev_priv_flags_IFF_FAIL=
OVER;
> +    /// Lower device of a failover master device.
> +    pub const IFF_FAILOVER_SLAVE: u64 =3D bindings::netdev_priv_flags_IF=
F_FAILOVER_SLAVE;
> +    /// Only invokes the rx handler of L3 master device.
> +    pub const IFF_L3MDEV_RX_HANDLER: u64 =3D bindings::netdev_priv_flags=
_IFF_L3MDEV_RX_HANDLER;
> +    /// Prevents ipv6 addrconf.
> +    pub const IFF_NO_ADDRCONF: u64 =3D bindings::netdev_priv_flags_IFF_N=
O_ADDRCONF;
> +    /// Capable of xmitting frames with skb_headlen(skb) =3D=3D 0.
> +    pub const IFF_TX_SKB_NO_LINEAR: u64 =3D bindings::netdev_priv_flags_=
IFF_TX_SKB_NO_LINEAR;
> +    /// Supports setting carrier via IFLA_PROTO_DOWN.
> +    pub const IFF_CHANGE_PROTO_DOWN: u64 =3D bindings::netdev_priv_flags=
_IFF_CHANGE_PROTO_DOWN;
> +}
> +
>  /// Corresponds to the kernel's `struct net_device`.
>  ///
>  /// # Invariants
> @@ -42,6 +150,81 @@ fn priv_data_ptr(&self) -> *const c_void {
>          // So it's safe to read an address from the returned address fro=
m `netdev_priv()`.
>          unsafe { core::ptr::read(bindings::netdev_priv(self.0) as *const=
 *const c_void) }
>      }
> +
> +    /// Sets the name of a device.
> +    pub fn set_name(&mut self, name: &CStr) -> Result {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.

Note that it is not the safety requirement that ensure this, but
rather the type invariant of `Self`. This also is the case further below.

> +        unsafe {
> +            if name.len() > (*self.0).name.len() {
> +                return Err(code::EINVAL);
> +            }
> +            for i in 0..name.len() {
> +                (*self.0).name[i] =3D name[i] as i8;

By using array access va an index `[]` you create a mutable reference to
the name of the struct, this is probably wrong. Instead of this loop,
you should use some direct copy function.

--
Cheers,
Benno

> +            }
> +        }
> +        Ok(())
> +    }
> +
> +    /// Sets carrier.
> +    pub fn netif_carrier_on(&mut self) {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe { bindings::netif_carrier_on(self.0) }
> +    }
> +
> +    /// Clears carrier.
> +    pub fn netif_carrier_off(&mut self) {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe { bindings::netif_carrier_off(self.0) }
> +    }
> +
> +    /// Sets the max mtu of the device.
> +    pub fn set_max_mtu(&mut self, max_mtu: u32) {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe {
> +            (*self.0).max_mtu =3D max_mtu;
> +        }
> +    }
> +
> +    /// Sets the minimum mtu of the device.
> +    pub fn set_min_mtu(&mut self, min_mtu: u32) {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe {
> +            (*self.0).min_mtu =3D min_mtu;
> +        }
> +    }
> +
> +    /// Returns the flags of the device.
> +    pub fn get_flags(&self) -> u32 {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe { (*self.0).flags }
> +    }
> +
> +    /// Sets the flags of the device.
> +    pub fn set_flags(&mut self, flags: u32) {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe {
> +            (*self.0).flags =3D flags;
> +        }
> +    }
> +
> +    /// Returns the priv_flags of the device.
> +    pub fn get_priv_flags(&self) -> u64 {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe { (*self.0).priv_flags }
> +    }
> +
> +    /// Sets the priv_flags of the device.
> +    pub fn set_priv_flags(&mut self, flags: u64) {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe { (*self.0).priv_flags =3D flags }
> +    }
> +
> +    /// Generate a random Ethernet address (MAC) to be used by a net dev=
ice
> +    /// and set addr_assign_type.
> +    pub fn set_random_eth_hw_addr(&mut self) {
> +        // SAFETY: The safety requirement ensures that the pointer is va=
lid.
> +        unsafe { bindings::eth_hw_addr_random(self.0) }
> +    }
>  }
>=20
>  // SAFETY: `Device` is just a wrapper for the kernel`s `struct net_devic=
e`, which can be used
> --
> 2.34.1
> 

