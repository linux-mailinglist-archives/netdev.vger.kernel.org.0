Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EBA3F5920
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbhHXHi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:38:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:32305 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234616AbhHXHiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 03:38:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="217283964"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="217283964"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:38:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="515317618"
Received: from um.fi.intel.com (HELO um) ([10.237.72.62])
  by fmsmga004.fm.intel.com with ESMTP; 24 Aug 2021 00:38:07 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org, alexander.shishkin@linux.intel.com
Subject: Re: [PATCH v2 47/63] intel_th: msu: Use memset_startat() for
 clearing hw header
In-Reply-To: <20210818060533.3569517-48-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-48-keescook@chromium.org>
Date:   Tue, 24 Aug 2021 10:38:06 +0300
Message-ID: <87sfyzi97l.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
>
> Use memset_startat() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct.
>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>

> ---
>  drivers/hwtracing/intel_th/msu.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
> index 432ade0842f6..70a07b4e9967 100644
> --- a/drivers/hwtracing/intel_th/msu.c
> +++ b/drivers/hwtracing/intel_th/msu.c
> @@ -658,13 +658,11 @@ static void msc_buffer_clear_hw_header(struct msc *msc)
>  
>  	list_for_each_entry(win, &msc->win_list, entry) {
>  		unsigned int blk;
> -		size_t hw_sz = sizeof(struct msc_block_desc) -
> -			offsetof(struct msc_block_desc, hw_tag);
>  
>  		for_each_sg(win->sgt->sgl, sg, win->nr_segs, blk) {
>  			struct msc_block_desc *bdesc = sg_virt(sg);
>  
> -			memset(&bdesc->hw_tag, 0, hw_sz);
> +			memset_startat(bdesc, 0, hw_tag);
>  		}
>  	}
>  }
> -- 
> 2.30.2
