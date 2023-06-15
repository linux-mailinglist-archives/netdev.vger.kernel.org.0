Return-Path: <netdev+bounces-11123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BDB73197E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B76828182C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7AEB156DA;
	Thu, 15 Jun 2023 13:02:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FF912B6D
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:02:17 +0000 (UTC)
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16CE2729
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:02:08 -0700 (PDT)
Date: Thu, 15 Jun 2023 13:01:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=kkcsyormfbalrkd5ne6rrgratq.protonmail; t=1686834125; x=1687093325;
	bh=i1JEfQNu9/ZYmNqFINx1pJL+TXOnenXuA1N+5Om9zIE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=cYC/fvaZSjv0z0E7TFmbWsYyzh0WlyEkyv4+MAFlOVYVl65v3fPNgjdPFD+35xb7v
	 iuBoDhcE64TGcTIPvvO3ka6nlfTF9uSUD88+4nzYwZyWxmAtdLhKopBKISAputG+Zj
	 pZGdEPR7lOXYaMAyJouEFZ3zFcOCHP7n8P2tD1I7IcyUL4rC+uOt3+HELZFCcW18IZ
	 ugqg0/pQNqwiaihpkQnoHmhnvN21ZSMkeGfkzEQtcizx5c1K+i2J5Et12s9I2K6Ta2
	 +lpWO8PrWpvLSTowcC7QiYiwA5Vs0BzrveZuR+hOTE1TX2u0BiY9qeb1EdmxA1K27y
	 +3NOuHpzB4SQQ==
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, aliceryhl@google.com, andrew@lunn.ch, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 1/5] rust: core abstractions for network device drivers
Message-ID: <_kID50ojyLurmrpIpn_kNxCRqo5MAaqm9pE47mhFcLops8yDhSqmbkhJiUuHlAFSdgqX1dHdZGxUa95ZSHAPHesIKLci1J21cu6nmdQ3ZGg=@proton.me>
In-Reply-To: <20230613045326.3938283-2-fujita.tomonori@gmail.com>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com> <20230613045326.3938283-2-fujita.tomonori@gmail.com>
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
> This patch adds very basic abstractions to implement network device
> drivers, corresponds to the kernel's net_device and net_device_ops
> structs with support for register_netdev/unregister_netdev functions.
>=20
> allows the const_maybe_uninit_zeroed feature for
> core::mem::MaybeUinit::<T>::zeroed() in const function.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   2 +
>  rust/helpers.c                  |  16 ++
>  rust/kernel/lib.rs              |   3 +
>  rust/kernel/net.rs              |   5 +
>  rust/kernel/net/dev.rs          | 344 ++++++++++++++++++++++++++++++++
>  5 files changed, 370 insertions(+)
>  create mode 100644 rust/kernel/net.rs
>  create mode 100644 rust/kernel/net/dev.rs
>=20
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_hel=
per.h
> index 3e601ce2548d..468bf606f174 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -7,6 +7,8 @@
>   */
>=20
>  #include <linux/errname.h>
> +#include <linux/etherdevice.h>
> +#include <linux/netdevice.h>
>  #include <linux/slab.h>
>  #include <linux/refcount.h>
>  #include <linux/wait.h>
> diff --git a/rust/helpers.c b/rust/helpers.c
> index bb594da56137..70d50767ff4e 100644
> --- a/rust/helpers.c
> +++ b/rust/helpers.c
> @@ -24,10 +24,26 @@
>  #include <linux/errname.h>
>  #include <linux/refcount.h>
>  #include <linux/mutex.h>
> +#include <linux/netdevice.h>
> +#include <linux/skbuff.h>
>  #include <linux/spinlock.h>
>  #include <linux/sched/signal.h>
>  #include <linux/wait.h>
>=20
> +#ifdef CONFIG_NET
> +void *rust_helper_netdev_priv(const struct net_device *dev)
> +{
> +=09return netdev_priv(dev);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_netdev_priv);
> +
> +void rust_helper_skb_tx_timestamp(struct sk_buff *skb)
> +{
> +=09skb_tx_timestamp(skb);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_skb_tx_timestamp);
> +#endif
> +
>  __noreturn void rust_helper_BUG(void)
>  {
>  =09BUG();
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 85b261209977..fc7d048d359d 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -13,6 +13,7 @@
>=20
>  #![no_std]
>  #![feature(allocator_api)]
> +#![feature(const_maybe_uninit_zeroed)]
>  #![feature(coerce_unsized)]
>  #![feature(dispatch_from_dyn)]
>  #![feature(new_uninit)]
> @@ -34,6 +35,8 @@
>  pub mod error;
>  pub mod init;
>  pub mod ioctl;
> +#[cfg(CONFIG_NET)]
> +pub mod net;
>  pub mod prelude;
>  pub mod print;
>  mod static_assert;
> diff --git a/rust/kernel/net.rs b/rust/kernel/net.rs
> new file mode 100644
> index 000000000000..28fe8f398463
> --- /dev/null
> +++ b/rust/kernel/net.rs
> @@ -0,0 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Networking core.
> +
> +pub mod dev;
> diff --git a/rust/kernel/net/dev.rs b/rust/kernel/net/dev.rs
> new file mode 100644
> index 000000000000..d072c81f99ce
> --- /dev/null
> +++ b/rust/kernel/net/dev.rs
> @@ -0,0 +1,344 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Network device.
> +//!
> +//! C headers: [`include/linux/etherdevice.h`](../../../../include/linux=
/etherdevice.h),
> +//! [`include/linux/ethtool.h`](../../../../include/linux/ethtool.h),
> +//! [`include/linux/netdevice.h`](../../../../include/linux/netdevice.h)=
,
> +//! [`include/linux/skbuff.h`](../../../../include/linux/skbuff.h),
> +//! [`include/uapi/linux/if_link.h`](../../../../include/uapi/linux/if_l=
ink.h).
> +
> +use crate::{bindings, error::*, prelude::vtable, types::ForeignOwnable};
> +use {core::ffi::c_void, core::marker::PhantomData};
> +
> +/// Corresponds to the kernel's `struct net_device`.
> +///
> +/// # Invariants
> +///
> +/// The pointer is valid.
> +pub struct Device(*mut bindings::net_device);
> +
> +impl Device {
> +    /// Creates a new [`Device`] instance.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Callers must ensure that `ptr` must be valid.
> +    unsafe fn from_ptr(ptr: *mut bindings::net_device) -> Self {
> +        // INVARIANT: The safety requirements ensure the invariant.
> +        Self(ptr)
> +    }
> +
> +    /// Gets a pointer to network device private data.
> +    fn priv_data_ptr(&self) -> *const c_void {
> +        // SAFETY: The type invariants guarantee that `self.0` is valid.
> +        // During the initialization of `Registration` instance, the ker=
nel allocates
> +        // contiguous memory for `struct net_device` and a pointer to it=
s private data.
> +        // So it's safe to read an address from the returned address fro=
m `netdev_priv()`.
> +        unsafe { core::ptr::read(bindings::netdev_priv(self.0) as *const=
 *const c_void) }

Why are at least `size_of::<*const c_void>` bytes allocated? Why is it a
`*const c_void` pointer? This function does not give any guarantees about
this pointer, is it valid?

I know that you are allocating exactly this amount in `Registration`, but
`Device` does not know about that. Should this be a type invariant?
It might be a good idea to make `Driver` generic over `D`, the data that is
stored behind this pointer. You could then return `D::Borrowed` instead.

> +    }
> +}
> +
> +// SAFETY: `Device` is just a wrapper for the kernel`s `struct net_devic=
e`, which can be used
> +// from any thread. `struct net_device` stores a pointer to `DriverData:=
:Data`, which is `Sync`
> +// so it's safe to sharing its pointer.
> +unsafe impl Send for Device {}
> +// SAFETY: `Device` is just a wrapper for the kernel`s `struct net_devic=
e`, which can be used
> +// from any thread. `struct net_device` stores a pointer to `DriverData:=
:Data`, which is `Sync`,
> +// can be used from any thread too.
> +unsafe impl Sync for Device {}
> +
> +/// Trait for device driver specific information.
> +///
> +/// This data structure is passed to a driver with the operations for `s=
truct net_device`
> +/// like `struct net_device_ops`, `struct ethtool_ops`, `struct rtnl_lin=
k_ops`, etc.
> +pub trait DriverData {
> +    /// The object are stored in C object, `struct net_device`.
> +    type Data: ForeignOwnable + Send + Sync;

Why is this an associated type? Could you not use
`D: ForeignOwnable + Send + Sync` everywhere instead?
I think this should be possible, since `DriverData` does not define
anything else.

> +}
> +
> +/// Registration structure for a network device driver.
> +///
> +/// This allocates and owns a `struct net_device` object.
> +/// Once the `net_device` object is registered via `register_netdev` fun=
ction,
> +/// the kernel calls various functions such as `struct net_device_ops` o=
perations with
> +/// the `net_device` object.
> +///
> +/// A driver must implement `struct net_device_ops` so the trait for it =
is tied.
> +/// Other operations like `struct ethtool_ops` are optional.
> +pub struct Registration<T: DeviceOperations<D>, D: DriverData> {
> +    dev: Device,
> +    is_registered: bool,
> +    _p: PhantomData<(D, T)>,
> +}
> +
> +impl<D: DriverData, T: DeviceOperations<D>> Drop for Registration<T, D> =
{
> +    fn drop(&mut self) {
> +        // SAFETY: The type invariants guarantee that `self.dev.0` is va=
lid.
> +        unsafe {
> +            let _ =3D D::Data::from_foreign(self.dev.priv_data_ptr());

Why is `self.dev.priv_data_ptr()` a valid pointer?
This `unsafe` block should be split to better explain the different safety
requirements.

> +            if self.is_registered {
> +                bindings::unregister_netdev(self.dev.0);
> +            }
> +            bindings::free_netdev(self.dev.0);
> +        }
> +    }
> +}
> +
> +impl<D: DriverData, T: DeviceOperations<D>> Registration<T, D> {
> +    /// Creates a new [`Registration`] instance for ethernet device.
> +    ///
> +    /// A device driver can pass private data.
> +    pub fn try_new_ether(tx_queue_size: u32, rx_queue_size: u32, data: D=
::Data) -> Result<Self> {
> +        // SAFETY: FFI call.

If this FFI call has no safety requirements then say so.

> +        let ptr =3D from_err_ptr(unsafe {
> +            bindings::alloc_etherdev_mqs(
> +                core::mem::size_of::<*const c_void>() as i32,
> +                tx_queue_size,
> +                rx_queue_size,
> +            )
> +        })?;
> +
> +        // SAFETY: `ptr` is valid and non-null since `alloc_etherdev_mqs=
()`
> +        // returned a valid pointer which was null-checked.
> +        let dev =3D unsafe { Device::from_ptr(ptr) };
> +        // SAFETY: It's safe to write an address to the returned pointer
> +        // from `netdev_priv()` because `alloc_etherdev_mqs()` allocates
> +        // contiguous memory for `struct net_device` and a pointer.
> +        unsafe {
> +            let priv_ptr =3D bindings::netdev_priv(ptr) as *mut *const c=
_void;
> +            core::ptr::write(priv_ptr, data.into_foreign());
> +        }
> +        Ok(Registration {
> +            dev,
> +            is_registered: false,
> +            _p: PhantomData,
> +        })
> +    }
> +
> +    /// Returns a network device.
> +    ///
> +    /// A device driver normally configures the device before registrati=
on.
> +    pub fn dev_get(&mut self) -> &mut Device {
> +        &mut self.dev
> +    }
> +
> +    /// Registers a network device.
> +    pub fn register(&mut self) -> Result {
> +        if self.is_registered {
> +            return Err(code::EINVAL);
> +        }
> +        // SAFETY: The type invariants guarantee that `self.dev.0` is va=
lid.
> +        let ret =3D unsafe {
> +            (*self.dev.0).netdev_ops =3D Self::build_device_ops();
> +            bindings::register_netdev(self.dev.0)
> +        };
> +        if ret !=3D 0 {
> +            Err(Error::from_errno(ret))
> +        } else {
> +            self.is_registered =3D true;
> +            Ok(())
> +        }
> +    }
> +
> +    const DEVICE_OPS: bindings::net_device_ops =3D bindings::net_device_=
ops {
> +        ndo_init: if <T>::HAS_INIT {
> +            Some(Self::init_callback)
> +        } else {
> +            None
> +        },
> +        ndo_uninit: if <T>::HAS_UNINIT {
> +            Some(Self::uninit_callback)
> +        } else {
> +            None
> +        },
> +        ndo_open: if <T>::HAS_OPEN {
> +            Some(Self::open_callback)
> +        } else {
> +            None
> +        },
> +        ndo_stop: if <T>::HAS_STOP {
> +            Some(Self::stop_callback)
> +        } else {
> +            None
> +        },
> +        ndo_start_xmit: if <T>::HAS_START_XMIT {
> +            Some(Self::start_xmit_callback)
> +        } else {
> +            None
> +        },
> +        // SAFETY: The rest is zeroed out to initialize `struct net_devi=
ce_ops`,
> +        // set `Option<&F>` to be `None`.
> +        ..unsafe { core::mem::MaybeUninit::<bindings::net_device_ops>::z=
eroed().assume_init() }
> +    };
> +
> +    const fn build_device_ops() -> &'static bindings::net_device_ops {
> +        &Self::DEVICE_OPS
> +    }

Why does this function exist?

> +
> +    unsafe extern "C" fn init_callback(netdev: *mut bindings::net_device=
) -> core::ffi::c_int {
> +        from_result(|| {

Since you are the first user of `from_result`, you can remove the
`#[allow(dead_code)]` attribute.

@Reviewers/Maintainers: Or would we prefer to make that change ourselves?

> +            // SAFETY: The C API guarantees that `netdev` is valid while=
 this function is running.
> +            let mut dev =3D unsafe { Device::from_ptr(netdev) };
> +            // SAFETY: The returned pointer was initialized by `D::Data:=
:into_foreign` when
> +            // `Registration` object was created.
> +            // `D::Data::from_foreign` is only called by the object was =
released.
> +            // So we know `data` is valid while this function is running=
.

This should be a type invariant of `Registration`.

> +            let data =3D unsafe { D::Data::borrow(dev.priv_data_ptr()) }=
;
> +            T::init(&mut dev, data)?;
> +            Ok(0)
> +        })
> +    }
> +
> +    unsafe extern "C" fn uninit_callback(netdev: *mut bindings::net_devi=
ce) {
> +        // SAFETY: The C API guarantees that `netdev` is valid while thi=
s function is running.
> +        let mut dev =3D unsafe { Device::from_ptr(netdev) };
> +        // SAFETY: The returned pointer was initialized by `D::Data::int=
o_foreign` when
> +        // `Registration` object was created.
> +        // `D::Data::from_foreign` is only called by the object was rele=
ased.
> +        // So we know `data` is valid while this function is running.
> +        let data =3D unsafe { D::Data::borrow(dev.priv_data_ptr()) };
> +        T::uninit(&mut dev, data);
> +    }
> +
> +    unsafe extern "C" fn open_callback(netdev: *mut bindings::net_device=
) -> core::ffi::c_int {
> +        from_result(|| {
> +            // SAFETY: The C API guarantees that `netdev` is valid while=
 this function is running.
> +            let mut dev =3D unsafe { Device::from_ptr(netdev) };
> +            // SAFETY: The returned pointer was initialized by `D::Data:=
:into_foreign` when
> +            // `Registration` object was created.
> +            // `D::Data::from_foreign` is only called by the object was =
released.
> +            // So we know `data` is valid while this function is running=
.
> +            let data =3D unsafe { D::Data::borrow(dev.priv_data_ptr()) }=
;
> +            T::open(&mut dev, data)?;
> +            Ok(0)
> +        })
> +    }
> +
> +    unsafe extern "C" fn stop_callback(netdev: *mut bindings::net_device=
) -> core::ffi::c_int {
> +        from_result(|| {
> +            // SAFETY: The C API guarantees that `netdev` is valid while=
 this function is running.
> +            let mut dev =3D unsafe { Device::from_ptr(netdev) };
> +            // SAFETY: The returned pointer was initialized by `D::Data:=
:into_foreign` when
> +            // `Registration` object was created.
> +            // `D::Data::from_foreign` is only called by the object was =
released.
> +            // So we know `data` is valid while this function is running=
.
> +            let data =3D unsafe { D::Data::borrow(dev.priv_data_ptr()) }=
;
> +            T::stop(&mut dev, data)?;
> +            Ok(0)
> +        })
> +    }
> +
> +    unsafe extern "C" fn start_xmit_callback(
> +        skb: *mut bindings::sk_buff,
> +        netdev: *mut bindings::net_device,
> +    ) -> bindings::netdev_tx_t {
> +        // SAFETY: The C API guarantees that `netdev` is valid while thi=
s function is running.
> +        let mut dev =3D unsafe { Device::from_ptr(netdev) };
> +        // SAFETY: The returned pointer was initialized by `D::Data::int=
o_foreign` when
> +        // `Registration` object was created.
> +        // `D::Data::from_foreign` is only called by the object was rele=
ased.
> +        // So we know `data` is valid while this function is running.
> +        let data =3D unsafe { D::Data::borrow(dev.priv_data_ptr()) };
> +        // SAFETY: The C API guarantees that `skb` is valid while this f=
unction is running.
> +        let skb =3D unsafe { SkBuff::from_ptr(skb) };
> +        T::start_xmit(&mut dev, data, skb) as bindings::netdev_tx_t
> +    }
> +}
> +
> +// SAFETY: `Registration` exposes only `Device` object which can be used=
 from
> +// any thread.
> +unsafe impl<D: DriverData, T: DeviceOperations<D>> Send for Registration=
<T, D> {}
> +// SAFETY: `Registration` exposes only `Device` object which can be used=
 from
> +// any thread.
> +unsafe impl<D: DriverData, T: DeviceOperations<D>> Sync for Registration=
<T, D> {}
> +
> +/// Corresponds to the kernel's `enum netdev_tx`.
> +#[repr(i32)]
> +pub enum TxCode {
> +    /// Driver took care of packet.
> +    Ok =3D bindings::netdev_tx_NETDEV_TX_OK,
> +    /// Driver tx path was busy.
> +    Busy =3D bindings::netdev_tx_NETDEV_TX_BUSY,
> +}
> +
> +/// Corresponds to the kernel's `struct net_device_ops`.
> +///
> +/// A device driver must implement this. Only very basic operations are =
supported for now.
> +#[vtable]
> +pub trait DeviceOperations<D: DriverData> {

Why is this trait generic over `D`? Why is this not `Self` or an associated
type?

> +    /// Corresponds to `ndo_init` in `struct net_device_ops`.
> +    fn init(_dev: &mut Device, _data: <D::Data as ForeignOwnable>::Borro=
wed<'_>) -> Result {

Why do all of these functions take a `&mut Device`? `Device` already is a
pointer, so why the double indirection?

> +        Ok(())
> +    }
> +
> +    /// Corresponds to `ndo_uninit` in `struct net_device_ops`.
> +    fn uninit(_dev: &mut Device, _data: <D::Data as ForeignOwnable>::Bor=
rowed<'_>) {}
> +
> +    /// Corresponds to `ndo_open` in `struct net_device_ops`.
> +    fn open(_dev: &mut Device, _data: <D::Data as ForeignOwnable>::Borro=
wed<'_>) -> Result {
> +        Ok(())
> +    }
> +
> +    /// Corresponds to `ndo_stop` in `struct net_device_ops`.
> +    fn stop(_dev: &mut Device, _data: <D::Data as ForeignOwnable>::Borro=
wed<'_>) -> Result {
> +        Ok(())
> +    }
> +
> +    /// Corresponds to `ndo_start_xmit` in `struct net_device_ops`.
> +    fn start_xmit(
> +        _dev: &mut Device,
> +        _data: <D::Data as ForeignOwnable>::Borrowed<'_>,
> +        _skb: SkBuff,
> +    ) -> TxCode {
> +        TxCode::Busy
> +    }
> +}
> +
> +/// Corresponds to the kernel's `struct sk_buff`.
> +///
> +/// A driver manages `struct sk_buff` in two ways. In both ways, the own=
ership is transferred
> +/// between C and Rust. The allocation and release are done asymmetrical=
ly.
> +///
> +/// On the tx side (`ndo_start_xmit` operation in `struct net_device_ops=
`), the kernel allocates
> +/// a `sk_buff' object and passes it to the driver. The driver is respon=
sible for the release
> +/// after transmission.
> +/// On the rx side, the driver allocates a `sk_buff` object then passes =
it to the kernel
> +/// after receiving data.
> +///
> +/// # Invariants
> +///
> +/// The pointer is valid.
> +pub struct SkBuff(*mut bindings::sk_buff);
> +
> +impl SkBuff {
> +    /// Creates a new [`SkBuff`] instance.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Callers must ensure that `ptr` must be valid.
> +    unsafe fn from_ptr(ptr: *mut bindings::sk_buff) -> Self {
> +        // INVARIANT: The safety requirements ensure the invariant.
> +        Self(ptr)
> +    }
> +
> +    /// Provides a time stamp.
> +    pub fn tx_timestamp(&mut self) {
> +        // SAFETY: The type invariants guarantee that `self.0` is valid.
> +        unsafe {
> +            bindings::skb_tx_timestamp(self.0);
> +        }
> +    }
> +}
> +
> +impl Drop for SkBuff {
> +    fn drop(&mut self) {
> +        // SAFETY: The type invariants guarantee that `self.0` is valid.
> +        unsafe {
> +            bindings::kfree_skb_reason(
> +                self.0,
> +                bindings::skb_drop_reason_SKB_DROP_REASON_NOT_SPECIFIED,
> +            )

AFAICT this function frees the `struct sk_buff`, why is this safe? This
function also has as a requirement that all other pointers to this struct
are never used again. How do you guarantee this?
You mentioned above that there are two us cases for an SkBuff, in one case
the kernel frees it and in another the driver. How do we know that we can
free it here?

--
Cheers,
Benno

> +        }
> +    }
> +}
> --
> 2.34.1
> 

