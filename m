Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EE33D8A32
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbhG1JCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:02:11 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42376 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbhG1JCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:02:09 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2DF0A22262;
        Wed, 28 Jul 2021 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627462927;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sp2fXaO4+VkU0ewmSUxyDBIfoqxWZ/YmzoRuKp72TwU=;
        b=QJtqaRDeD/r+6BS2RpMLHsBckRf2sr1w3iN33pezOooEqpnn8T7DqSapcRxyMPIZfjRSjm
        7J+1lee9yCSAoX/yXx5qOnlJlNQlP5/7ZOeqDMcdtfzJJyxwr5G3M0hN/eM3VNhe4zl7mM
        ShgAu0K7CLyKCgHUkgVaDq862Mit+3M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627462927;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sp2fXaO4+VkU0ewmSUxyDBIfoqxWZ/YmzoRuKp72TwU=;
        b=pmBfIB2QkmA3xf4kSvM/Kul+M1rkY2xpWB6cH5WhgISANis+5+m+8zDuM/QuNvL/ktFiFp
        tiOqD9YAirWKVzAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 15362A3B8B;
        Wed, 28 Jul 2021 09:02:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4CA03DA8A7; Wed, 28 Jul 2021 10:59:22 +0200 (CEST)
Date:   Wed, 28 Jul 2021 10:59:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <20210728085921.GV5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-2-keescook@chromium.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
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

Should this be { 0 } ?

We've seen patches trying to switch from { 0 } to {  } but the answer
was that { 0 } is supposed to be used,
http://www.ex-parrot.com/~chris/random/initialise.html

(from https://lore.kernel.org/lkml/fbddb15a-6e46-3f21-23ba-b18f66e3448a@suse.com/)
