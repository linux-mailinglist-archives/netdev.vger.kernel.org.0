Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CA33D8758
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhG1FqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232796AbhG1FqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:46:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B91F460BD3;
        Wed, 28 Jul 2021 05:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627451161;
        bh=5TT6vhaZMFh6Ixag3Q3JIRBCGhLz9P43hbzx09FExmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F6DkcU1tItDCras3BrqzN0yT/k/efCY4jZ2AcBGGFZyCnArMJpoDY48G8teXgWArj
         OKxwCtiqpI560i3ebuU+kJI+rT9CPwa7B3UNyA1ll/SaFemqgmowNM0f+E1SaNF/Qw
         1NRg4+x5zFU1vDWXNXSDvARVwD9VpVh6Su5E+9ks=
Date:   Wed, 28 Jul 2021 07:45:59 +0200
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
Subject: Re: [PATCH 08/64] staging: rtl8192u: Use struct_group() for memcpy()
 region
Message-ID: <YQDvF2syaThTs7sx@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-9-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-9-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:57:59PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() around members addr1, addr2, and addr3 in struct
> rtl_80211_hdr_4addr, and members qui, qui_type, qui_subtype, version,
> and ac_info in struct ieee80211_qos_information_element, so they can be
> referenced together. This will allow memcpy() and sizeof() to more easily
> reason about sizes, improve readability, and avoid future warnings about
> writing beyond the end of addr1 and qui. Additionally replace zero sized
> arrays with flexible arrays in struct ieee_param.
> 
> "pahole" shows no size nor member offset changes to struct
> rtl_80211_hdr_4addr nor struct ieee80211_qos_information_element. "objdump
> -d" shows no meaningful object code changes (i.e. only source line number
> induced differences and optimizations).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
