Return-Path: <netdev+bounces-11125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA74D731986
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17B661C20E41
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C9015AE8;
	Thu, 15 Jun 2023 13:04:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E190D15AE7
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:04:08 +0000 (UTC)
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9502695
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:04:04 -0700 (PDT)
Date: Thu, 15 Jun 2023 13:03:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1686834239; x=1687093439;
	bh=hOXgu1XtrQRnZjQh65xPZFRsRVG6C9WfZtNMBQlyD3o=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=AX6WG3a3zybZIwJq1TxsZ/UHqqEm3okkzoqknfcBlm3xAEaRXqK3QxA+yKUEOOQwt
	 CBAx0PXbxgxquNgvH0HXz0lVs+QX0xzaPwg5jeAb1jHELQOtzOkY/T7c7uobc4FSmj
	 b6B7VAjzx38al2thFxn4UZ2FoRccknpjXEwM7+xdfxIWSZmuginqnLuL/XY7jKUNpw
	 oq0BUomueHBgtV7MU4PkRcZNRO9a6jjAos+ubuRpl7JG48TGmnY7wLSeoLtkfyf7wE
	 O1Ixbtp2Ll9PZ73GXPNHGfG3T3wh/WTsvOoQG0M7GZniMLrvXQgB8gKkuVEyYapP9r
	 6Rs5dQk7LXAog==
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, aliceryhl@google.com, andrew@lunn.ch, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 2/5] rust: add support for ethernet operations
Message-ID: <QOy6Y8ZgaRA5ibTXnKAqNpMqJhlV49Jc75QaG-cgmF-MN0brxDFgMbCTIPO8lgZNjxbr3QQZMjTC-Fdl7KMmb6ppcN4Gqs9wvULPHroXWL8=@proton.me>
In-Reply-To: <20230613045326.3938283-3-fujita.tomonori@gmail.com>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com> <20230613045326.3938283-3-fujita.tomonori@gmail.com>
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
> This improves abstractions for network device drivers to implement
> struct ethtool_ops, the majority of ethernet device drivers need to
> do.
>=20
> struct ethtool_ops also needs to access to device private data like
> struct net_devicve_ops.
>=20
> Currently, only get_ts_info operation is supported. The following
> patch adds the Rust version of the dummy network driver, which uses
> the operation.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/kernel/net/dev.rs          | 108 ++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+)
>=20
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_hel=
per.h
> index 468bf606f174..6446ff764980 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -8,6 +8,7 @@
>=20
>  #include <linux/errname.h>
>  #include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
>  #include <linux/netdevice.h>
>  #include <linux/slab.h>
>  #include <linux/refcount.h>
> diff --git a/rust/kernel/net/dev.rs b/rust/kernel/net/dev.rs
> index d072c81f99ce..d6012b2eea33 100644
> --- a/rust/kernel/net/dev.rs
> +++ b/rust/kernel/net/dev.rs
> @@ -141,6 +141,18 @@ pub fn register(&mut self) -> Result {
>          }
>      }
>=20
> +    /// Sets `ethtool_ops` of `net_device`.
> +    pub fn set_ether_operations<U>(&mut self) -> Result
> +    where
> +        U: EtherOperations<D>,
> +    {
> +        if self.is_registered {
> +            return Err(code::EINVAL);
> +        }
> +        EtherOperationsAdapter::<U, D>::new().set_ether_ops(&mut self.de=
v);
> +        Ok(())
> +    }

Is it really necessary for a device to be able to have multiple different
`EtherOperations`? Couldnt you also just make `T` implement=20
`EtherOperations<D>`?

> +
>      const DEVICE_OPS: bindings::net_device_ops =3D bindings::net_device_=
ops {
>          ndo_init: if <T>::HAS_INIT {
>              Some(Self::init_callback)
> @@ -342,3 +354,99 @@ fn drop(&mut self) {
>          }
>      }
>  }
> +
> +/// Builds the kernel's `struct ethtool_ops`.
> +struct EtherOperationsAdapter<D, T> {
> +    _p: PhantomData<(D, T)>,
> +}
> +
> +impl<D, T> EtherOperationsAdapter<T, D>

I think it would be a good idea to add a comment here that explains why
this is needed, i.e. why `ETHER_OPS` cannot be implemented via a constant
in `set_ether_ops`.

> +where
> +    D: DriverData,
> +    T: EtherOperations<D>,
> +{
> +    /// Creates a new instance.
> +    fn new() -> Self {
> +        EtherOperationsAdapter { _p: PhantomData }
> +    }
> +
> +    unsafe extern "C" fn get_ts_info_callback(
> +        netdev: *mut bindings::net_device,
> +        info: *mut bindings::ethtool_ts_info,
> +    ) -> core::ffi::c_int {
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
> +            // SAFETY: The C API guarantees that `info` is valid while t=
his function is running.
> +            let mut info =3D unsafe { EthtoolTsInfo::from_ptr(info) };
> +            T::get_ts_info(&mut dev, data, &mut info)?;
> +            Ok(0)
> +        })
> +    }
> +
> +    const ETHER_OPS: bindings::ethtool_ops =3D bindings::ethtool_ops {
> +        get_ts_info: if <T>::HAS_GET_TS_INFO {
> +            Some(Self::get_ts_info_callback)
> +        } else {
> +            None
> +        },
> +        ..unsafe { core::mem::MaybeUninit::<bindings::ethtool_ops>::zero=
ed().assume_init() }
> +    };
> +
> +    const fn build_ether_ops() -> &'static bindings::ethtool_ops {
> +        &Self::ETHER_OPS
> +    }

Why is this a function?

> +
> +    fn set_ether_ops(&self, dev: &mut Device) {
> +        // SAFETY: The type invariants guarantee that `dev.0` is valid.
> +        unsafe {
> +            (*dev.0).ethtool_ops =3D Self::build_ether_ops();
> +        }
> +    }
> +}
> +
> +/// Corresponds to the kernel's `struct ethtool_ops`.
> +#[vtable]
> +pub trait EtherOperations<D: DriverData> {
> +    /// Corresponds to `get_ts_info` in `struct ethtool_ops`.
> +    fn get_ts_info(
> +        _dev: &mut Device,
> +        _data: <D::Data as ForeignOwnable>::Borrowed<'_>,
> +        _info: &mut EthtoolTsInfo,

`&mut EthtoolTsInfo` is again a double pointer.

> +    ) -> Result {
> +        Err(Error::from_errno(bindings::EOPNOTSUPP as i32))
> +    }
> +}
> +
> +/// Corresponds to the kernel's `struct ethtool_ts_info`.
> +///
> +/// # Invariants
> +///
> +/// The pointer is valid.
> +pub struct EthtoolTsInfo(*mut bindings::ethtool_ts_info);
> +
> +impl EthtoolTsInfo {
> +    /// Creates a new `EthtoolTsInfo' instance.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Callers must ensure that `ptr` must be valid.
> +    unsafe fn from_ptr(ptr: *mut bindings::ethtool_ts_info) -> Self {
> +        // INVARIANT: The safety requirements ensure the invariant.
> +        Self(ptr)
> +    }
> +}
> +
> +/// Sets up the info for software timestamping.
> +pub fn ethtool_op_get_ts_info(dev: &mut Device, info: &mut EthtoolTsInfo=
) -> Result {
> +    // SAFETY: The type invariants guarantee that `dev.0` and `info.0` a=
re valid.
> +    unsafe {
> +        bindings::ethtool_op_get_ts_info(dev.0, info.0);
> +    }
> +    Ok(())
> +}

Why isn't this an associated function on `EthtoolTsInfo`?

--
Cheers,
Benno

> --
> 2.34.1
> 

