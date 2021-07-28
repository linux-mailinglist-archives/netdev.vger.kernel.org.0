Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7993D877B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhG1FwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhG1FwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:52:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6233F60F91;
        Wed, 28 Jul 2021 05:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627451534;
        bh=nUOThSwtZ87Jw+CXwl+FwlWvYkHPkssRucboLcrmd90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SIJyCaqr1xfetzHAZanMNRQYhPz2W7BVjUbvZ/cg0giNbNRbWYSfkr7AwWFywJ0T1
         FPB4wjxunN/l1gFycsM1PXt+P8alzvfFDCE+mDoOQ5F/lLCJFjnF702h+O9qgMgRfo
         bcuZJkkCSMXuNuDrW+PLFHrtVDTjjQzHP3kojxD8=
Date:   Wed, 28 Jul 2021 07:52:11 +0200
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
Subject: Re: [PATCH 10/64] lib80211: Use struct_group() for memcpy() region
Message-ID: <YQDwiz1SdrzFKOWw@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-11-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-11-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:58:01PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() around members addr1, addr2, and addr3 in struct
> ieee80211_hdr so they can be referenced together. This will allow memcpy()
> and sizeof() to more easily reason about sizes, improve readability,
> and avoid future warnings about writing beyond the end of addr1.
> 
> "pahole" shows no size nor member offset changes to struct ieee80211_hdr.
> "objdump -d" shows no meaningful object code changes (i.e. only source
> line number induced differences and optimizations).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/staging/rtl8723bs/core/rtw_security.c | 5 +++--
>  drivers/staging/rtl8723bs/core/rtw_xmit.c     | 5 +++--
>  include/linux/ieee80211.h                     | 8 +++++---
>  net/wireless/lib80211_crypt_ccmp.c            | 3 ++-
>  4 files changed, 13 insertions(+), 8 deletions(-)

For the staging portion:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
