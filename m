Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942193D874A
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhG1Fpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232891AbhG1Fpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:45:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EAC060F93;
        Wed, 28 Jul 2021 05:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627451139;
        bh=iRPIkA9wCneiiPcbFTtaQRP1uYFSznhLeZtrCj67jCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cSi5Yn73Q7vWLdkilrflKgNOm7mNY5dQqgNjN+qepVVuYUWrI0aHzBMp1F6Q0epj9
         ZMRABIZgA+udyB+hnoMPHnAJxchAq9ks+jQbdEnkCRvARKi62oxT1yu+FxUgwo1NKi
         BkptoOs2eYMnU4S84hmk6GAERU1CRR9+P4HQ4kPY=
Date:   Wed, 28 Jul 2021 07:45:36 +0200
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
Subject: Re: [PATCH 07/64] staging: rtl8192e: Use struct_group() for memcpy()
 region
Message-ID: <YQDvABSKqzGxrycR@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-8-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-8-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:57:58PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() around members addr1, addr2, and addr3 in struct
> rtllib_hdr_4addr, and members qui, qui_type, qui_subtype, version,
> and ac_info in struct rtllib_qos_information_element, so they can be
> referenced together. This will allow memcpy() and sizeof() to more easily
> reason about sizes, improve readability, and avoid future warnings about
> writing beyond the end of addr1 and qui.
> 
> "pahole" shows no size nor member offset changes to struct
> rtllib_hdr_4addr nor struct rtllib_qos_information_element. "objdump -d"
> shows no meaningful object code changes (i.e. only source line number
> induced differences and optimizations).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/staging/rtl8192e/rtllib.h            | 20 ++++++++++++--------
>  drivers/staging/rtl8192e/rtllib_crypt_ccmp.c |  3 ++-
>  drivers/staging/rtl8192e/rtllib_rx.c         |  8 ++++----
>  3 files changed, 18 insertions(+), 13 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
