Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915D33D8794
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhG1F4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhG1F4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D5B060F91;
        Wed, 28 Jul 2021 05:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627451802;
        bh=SkTFCJePd+lcNKc8+koD7IK+G34mocgYj4IvJM4fn44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q9ANBjbNMZPywJN2UYq05SCuBOhTh8QHCmVyEEeZ4lj9G9Lo7DqXT0AQWx0CTwhuo
         npUVqfPC2/cHcWa7oOmYq7zfHqbYNwvw0P7jiRdASWbUGTLmzBLjVQyTH4VOO1Dawq
         EJzJmvcOAynf4CFmcVLm9WnYMB1CSUQJDDwEt8Fk=
Date:   Wed, 28 Jul 2021 07:56:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 25/64] drm/mga/mga_ioc32: Use struct_group() for memcpy()
 region
Message-ID: <YQDxmEYfppJ4wAmD@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-26-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-26-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:58:16PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() in struct drm32_mga_init around members chipset, sgram,
> maccess, fb_cpp, front_offset, front_pitch, back_offset, back_pitch,
> depth_cpp, depth_offset, depth_pitch, texture_offset, and texture_size,
> so they can be referenced together. This will allow memcpy() and sizeof()
> to more easily reason about sizes, improve readability, and avoid future
> warnings about writing beyond the end of chipset.
> 
> "pahole" shows no size nor member offset changes to struct drm32_mga_init.
> "objdump -d" shows no meaningful object code changes (i.e. only source
> line number induced differences and optimizations).
> 
> Note that since this includes a UAPI header, struct_group() has been
> explicitly redefined local to the header.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/gpu/drm/mga/mga_ioc32.c | 30 ++++++++++++++------------
>  include/uapi/drm/mga_drm.h      | 37 ++++++++++++++++++++++++---------
>  2 files changed, 44 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/gpu/drm/mga/mga_ioc32.c b/drivers/gpu/drm/mga/mga_ioc32.c
> index 4fd4de16cd32..fbd0329dbd4f 100644
> --- a/drivers/gpu/drm/mga/mga_ioc32.c
> +++ b/drivers/gpu/drm/mga/mga_ioc32.c
> @@ -38,16 +38,21 @@
>  typedef struct drm32_mga_init {
>  	int func;
>  	u32 sarea_priv_offset;
> -	int chipset;
> -	int sgram;
> -	unsigned int maccess;
> -	unsigned int fb_cpp;
> -	unsigned int front_offset, front_pitch;
> -	unsigned int back_offset, back_pitch;
> -	unsigned int depth_cpp;
> -	unsigned int depth_offset, depth_pitch;
> -	unsigned int texture_offset[MGA_NR_TEX_HEAPS];
> -	unsigned int texture_size[MGA_NR_TEX_HEAPS];
> +	struct_group(always32bit,
> +		int chipset;
> +		int sgram;
> +		unsigned int maccess;
> +		unsigned int fb_cpp;
> +		unsigned int front_offset;
> +		unsigned int front_pitch;
> +		unsigned int back_offset;
> +		unsigned int back_pitch;
> +		unsigned int depth_cpp;
> +		unsigned int depth_offset;
> +		unsigned int depth_pitch;
> +		unsigned int texture_offset[MGA_NR_TEX_HEAPS];
> +		unsigned int texture_size[MGA_NR_TEX_HEAPS];
> +	);
>  	u32 fb_offset;
>  	u32 mmio_offset;
>  	u32 status_offset;
> @@ -67,9 +72,8 @@ static int compat_mga_init(struct file *file, unsigned int cmd,
>  
>  	init.func = init32.func;
>  	init.sarea_priv_offset = init32.sarea_priv_offset;
> -	memcpy(&init.chipset, &init32.chipset,
> -		offsetof(drm_mga_init_t, fb_offset) -
> -		offsetof(drm_mga_init_t, chipset));
> +	memcpy(&init.always32bit, &init32.always32bit,
> +	       sizeof(init32.always32bit));
>  	init.fb_offset = init32.fb_offset;
>  	init.mmio_offset = init32.mmio_offset;
>  	init.status_offset = init32.status_offset;
> diff --git a/include/uapi/drm/mga_drm.h b/include/uapi/drm/mga_drm.h
> index 8c4337548ab5..61612e5ecab2 100644
> --- a/include/uapi/drm/mga_drm.h
> +++ b/include/uapi/drm/mga_drm.h
> @@ -265,6 +265,16 @@ typedef struct _drm_mga_sarea {
>  #define DRM_IOCTL_MGA_WAIT_FENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_WAIT_FENCE, __u32)
>  #define DRM_IOCTL_MGA_DMA_BOOTSTRAP DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_DMA_BOOTSTRAP, drm_mga_dma_bootstrap_t)
>  
> +#define __struct_group(name, fields) \
> +	union { \
> +		struct { \
> +			fields \
> +		}; \
> +		struct { \
> +			fields \
> +		} name; \
> +	}
> +
>  typedef struct _drm_mga_warp_index {
>  	int installed;
>  	unsigned long phys_addr;
> @@ -279,20 +289,25 @@ typedef struct drm_mga_init {
>  
>  	unsigned long sarea_priv_offset;
>  
> -	int chipset;
> -	int sgram;
> +	__struct_group(always32bit,
> +		int chipset;
> +		int sgram;
>  
> -	unsigned int maccess;
> +		unsigned int maccess;
>  
> -	unsigned int fb_cpp;
> -	unsigned int front_offset, front_pitch;
> -	unsigned int back_offset, back_pitch;
> +		unsigned int fb_cpp;
> +		unsigned int front_offset;
> +		unsigned int front_pitch;
> +		unsigned int back_offset;
> +		unsigned int back_pitch;
>  
> -	unsigned int depth_cpp;
> -	unsigned int depth_offset, depth_pitch;
> +		unsigned int depth_cpp;
> +		unsigned int depth_offset;
> +		unsigned int depth_pitch;
>  
> -	unsigned int texture_offset[MGA_NR_TEX_HEAPS];
> -	unsigned int texture_size[MGA_NR_TEX_HEAPS];
> +		unsigned int texture_offset[MGA_NR_TEX_HEAPS];
> +		unsigned int texture_size[MGA_NR_TEX_HEAPS];
> +	);
>  
>  	unsigned long fb_offset;
>  	unsigned long mmio_offset;
> @@ -302,6 +317,8 @@ typedef struct drm_mga_init {
>  	unsigned long buffers_offset;
>  } drm_mga_init_t;
>  
> +#undef __struct_group
> +

Why can you use __struct_group in this uapi header, but not the
networking one?

thanks,

greg k-h
