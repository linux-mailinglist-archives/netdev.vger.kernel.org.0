Return-Path: <netdev+bounces-2859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAF57044E4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B6E12814F4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61451D2A4;
	Tue, 16 May 2023 05:52:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBE107B2
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A649C433EF;
	Tue, 16 May 2023 05:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684216341;
	bh=UnnfSoH2Sog9IytTw4FHR+TpDmR01YMPhEE6qSYNrPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qRgroj2v2j30UkZE/IdvIx7y4qOvg4zGQutz4YlyomWWWtOTD+9jg5OLkKW4gBsdz
	 8CRaQByqbQQTsxSioc5ywuaDeXO+biQAPqJRokKoz3Lb44gykAM0l6f2N+ktTCpGB/
	 u1314ylalzvx9n1XCWv/pTrS9n81y0t/77U9nCIdo1t6zW1RJNP4UVe1S2sX+4U5Sb
	 JhrNTsreJV+HSjMwX2wG0++uPNyteN9Qqd+JL76R8EzSD4ko4DPyJbC70qgdFT5Y+R
	 hfgcxoERDQ5C5w1mbqD7jzGl+2POjJh4nB+f2lJaMbNk8+SKD+nzL5jw0FhWlJFzdB
	 qn2WrrvkGakxg==
Date: Mon, 15 May 2023 22:52:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: FUJITA Tomonori <tomo@exabit.dev>
Cc: rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: Re: [PATCH 1/2] rust: add synchronous message digest support
Message-ID: <20230516055219.GC2704@sol.localdomain>
References: <20230515043353.2324288-1-tomo@exabit.dev>
 <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>

Hi Fujita,

On Mon, May 15, 2023 at 04:34:27AM +0000, FUJITA Tomonori wrote:
> diff --git a/rust/helpers.c b/rust/helpers.c
> index 81e80261d597..03c131b1ca38 100644
> --- a/rust/helpers.c
> +++ b/rust/helpers.c
> @@ -18,6 +18,7 @@
>   * accidentally exposed.
>   */
>  
> +#include <crypto/hash.h>
>  #include <linux/bug.h>
>  #include <linux/build_bug.h>
>  #include <linux/err.h>
> @@ -27,6 +28,29 @@
>  #include <linux/sched/signal.h>
>  #include <linux/wait.h>
>  
> +void rust_helper_crypto_free_shash(struct crypto_shash *tfm)
> +{
> +	crypto_free_shash(tfm);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_crypto_free_shash);

Shouldn't this code be compiled only when the crypto API is available?

> +impl<'a> ShashDesc<'a> {
> +    /// Creates a [`ShashDesc`] object for a request data structure for message digest.
> +    pub fn new(tfm: &'a Shash) -> Result<Self> {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        let size = core::mem::size_of::<bindings::shash_desc>()
> +            + unsafe { bindings::crypto_shash_descsize(tfm.0) } as usize;
> +        let layout = Layout::from_size_align(size, 2)?;
> +        let ptr = unsafe { alloc(layout) } as *mut bindings::shash_desc;
> +        let mut desc = ShashDesc { ptr, tfm, size };
> +        // SAFETY: The `desc.tfm` is non-null and valid for the lifetime of this object.
> +        unsafe { (*desc.ptr).tfm = desc.tfm.0 };
> +        Ok(desc)
> +    }
> +
> +    /// (Re)initializes message digest.
> +    pub fn init(&mut self) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe { bindings::crypto_shash_init(self.ptr) })
> +    }
> +
> +    /// Adds data to message digest for processing.
> +    pub fn update(&mut self, data: &[u8]) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe {
> +            bindings::crypto_shash_update(self.ptr, data.as_ptr(), data.len() as u32)
> +        })
> +    }
> +
> +    /// Calculates message digest.
> +    pub fn finalize(&mut self, output: &mut [u8]) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe { bindings::crypto_shash_final(self.ptr, output.as_mut_ptr()) })
> +    }

This doesn't enforce that init() is called before update() or finalize().  I
think that needs to be checked in the Rust code, since the C code doesn't have
defined behavior in that case.

- Eric

