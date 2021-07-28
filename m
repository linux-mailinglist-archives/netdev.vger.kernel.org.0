Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B2A3D84E5
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 02:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhG1AxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 20:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232883AbhG1AxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 20:53:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 871DE60F9D;
        Wed, 28 Jul 2021 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627433597;
        bh=V7BMF/FvyWPzFRxxOCJEliV/8jG21FrrgDKLm323gMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E95F9MNM8J/ruiWgqyL/OWAja7QE9lwWMH1hn56E1drKRJHzRI71JR4r7Q1k8mdzZ
         THWkufcNZzoKNvRSMagzkbUm27LRKFtlehEUMH4pc70s3QrW6G3K+Za3ex2enBCoxi
         RxhJ9V6QnTgQHZb3fPI3lSYsKzdqo6n8/Tgv0EC3YiuNFdbETPAJSI9xdS+/M7M93Z
         TIznOV5w1BAv74+8tyDs6nkDSQPXknW0EwQBtxRDhtH80R5NW6BJOxUkiqCx19Jyg4
         CTZaFhhXp8bu5AnQZCfWe6BVJR4do/lHoLrJuxUaJIaQms4USCSRZmPotcjAMpAHYG
         buZPMn28624/A==
Date:   Tue, 27 Jul 2021 19:55:46 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <20210728005546.GA35706@embeddedor>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-2-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:57:52PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.  Wrap the target region
> in a common named structure. This additionally fixes a theoretical
> misalignment of the copy (since the size of "buf" changes between 64-bit
> and 32-bit, but this is likely never built for 64-bit).
> 
> FWIW, I think this code is totally broken on 64-bit (which appears to
> not be a "real" build configuration): it would either always fail (with
> an uninitialized data->buf_size) or would cause corruption in userspace
> due to the copy_to_user() in the call path against an uninitialized
> data->buf value:
> 
> omap3isp_stat_request_statistics_time32(...)
>     struct omap3isp_stat_data data64;
>     ...
>     omap3isp_stat_request_statistics(stat, &data64);
> 
> int omap3isp_stat_request_statistics(struct ispstat *stat,
>                                      struct omap3isp_stat_data *data)
>     ...
>     buf = isp_stat_buf_get(stat, data);
> 
> static struct ispstat_buffer *isp_stat_buf_get(struct ispstat *stat,
>                                                struct omap3isp_stat_data *data)
> ...
>     if (buf->buf_size > data->buf_size) {
>             ...
>             return ERR_PTR(-EINVAL);
>     }
>     ...
>     rval = copy_to_user(data->buf,
>                         buf->virt_addr,
>                         buf->buf_size);
> 
> Regardless, additionally initialize data64 to be zero-filled to avoid
> undefined behavior.
> 
> Fixes: 378e3f81cb56 ("media: omap3isp: support 64-bit version of omap3isp_stat_data")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/media/platform/omap3isp/ispstat.c |  5 +--
>  include/uapi/linux/omap3isp.h             | 44 +++++++++++++++++------
>  2 files changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> index 5b9b57f4d9bf..ea8222fed38e 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
>  int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
>  					struct omap3isp_stat_data_time32 *data)
>  {
> -	struct omap3isp_stat_data data64;
> +	struct omap3isp_stat_data data64 = { };
>  	int ret;
>  
>  	ret = omap3isp_stat_request_statistics(stat, &data64);
> @@ -521,7 +521,8 @@ int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
>  
>  	data->ts.tv_sec = data64.ts.tv_sec;
>  	data->ts.tv_usec = data64.ts.tv_usec;
> -	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
> +	data->buf = (uintptr_t)data64.buf;
> +	memcpy(&data->frame, &data64.buf, sizeof(data->frame));

I think this should be:

	memcpy(..., &data64.frame, ...);

instead.

--
Gustavo

>  
>  	return 0;
>  }
> diff --git a/include/uapi/linux/omap3isp.h b/include/uapi/linux/omap3isp.h
> index 87b55755f4ff..0a16af91621f 100644
> --- a/include/uapi/linux/omap3isp.h
> +++ b/include/uapi/linux/omap3isp.h
> @@ -159,13 +159,25 @@ struct omap3isp_h3a_aewb_config {
>  };
>  
>  /**
> - * struct omap3isp_stat_data - Statistic data sent to or received from user
> - * @ts: Timestamp of returned framestats.
> - * @buf: Pointer to pass to user.
> + * struct omap3isp_stat_frame - Statistic data without timestamp nor pointer.
> + * @buf_size: Size of buffer.
>   * @frame_number: Frame number of requested stats.
>   * @cur_frame: Current frame number being processed.
>   * @config_counter: Number of the configuration associated with the data.
>   */
> +struct omap3isp_stat_frame {
> +	__u32 buf_size;
> +	__u16 frame_number;
> +	__u16 cur_frame;
> +	__u16 config_counter;
> +};
> +
> +/**
> + * struct omap3isp_stat_data - Statistic data sent to or received from user
> + * @ts: Timestamp of returned framestats.
> + * @buf: Pointer to pass to user.
> + * @frame: Statistic data for frame.
> + */
>  struct omap3isp_stat_data {
>  #ifdef __KERNEL__
>  	struct {
> @@ -176,10 +188,15 @@ struct omap3isp_stat_data {
>  	struct timeval ts;
>  #endif
>  	void __user *buf;
> -	__u32 buf_size;
> -	__u16 frame_number;
> -	__u16 cur_frame;
> -	__u16 config_counter;
> +	union {
> +		struct {
> +			__u32 buf_size;
> +			__u16 frame_number;
> +			__u16 cur_frame;
> +			__u16 config_counter;
> +		};
> +		struct omap3isp_stat_frame frame;
> +	};
>  };
>  
>  #ifdef __KERNEL__
> @@ -189,10 +206,15 @@ struct omap3isp_stat_data_time32 {
>  		__s32	tv_usec;
>  	} ts;
>  	__u32 buf;
> -	__u32 buf_size;
> -	__u16 frame_number;
> -	__u16 cur_frame;
> -	__u16 config_counter;
> +	union {
> +		struct {
> +			__u32 buf_size;
> +			__u16 frame_number;
> +			__u16 cur_frame;
> +			__u16 config_counter;
> +		};
> +		struct omap3isp_stat_frame frame;
> +	};
>  };
>  #endif
>  
> -- 
> 2.30.2
> 
