Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339782B3068
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKNTyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgKNTyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 14:54:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D6C8222E9;
        Sat, 14 Nov 2020 19:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605383678;
        bh=3L3ZdjLNpMbrM9kh33h56mx9+Ki1Zw4agazyBg/3pcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sx2AXaeaySiB2zLUmMq86OFJklD3Fm6dTSh9KrnOQer24GofRVK0L4lf60yQ/2KM5
         4a940clfyJe4KdmAwUTfsL+HzvShGm6sg6mgQRlukTsoUAEu3FamN+/3XMweDEdNYQ
         9EHmzLlM2oZzCRdVkOCscToOyRILYOa7d8n109b8=
Date:   Sat, 14 Nov 2020 11:54:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-next@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: linux/skbuff.h: combine SKB_EXTENSIONS
 + KCOV handling
Message-ID: <20201114115437.55eed094@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201114174618.24471-1-rdunlap@infradead.org>
References: <20201114174618.24471-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 09:46:18 -0800 Randy Dunlap wrote:
> The previous Kconfig patch led to some other build errors as
> reported by the 0day bot and my own overnight build testing.
> 
> These are all in <linux/skbuff.h> when KCOV is enabled but
> SKB_EXTENSIONS is not enabled, so fix those by combining those conditions
> in the header file.
> 
> Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
> Fixes: 85ce50d337d1 ("net: kcov: don't select SKB_EXTENSIONS when there is no NET")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Aleksandr Nogikh <nogikh@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-next@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
> v2: (as suggested by Matthieu Baerts <matthieu.baerts@tessares.net>)
>   drop an extraneous space in a comment;
>   use CONFIG_SKB_EXTENSIONS instead of CONFIG_NET;

Thanks for the fix Randy!

> --- linux-next-20201113.orig/include/linux/skbuff.h
> +++ linux-next-20201113/include/linux/skbuff.h
> @@ -4151,7 +4151,7 @@ enum skb_ext_id {
>  #if IS_ENABLED(CONFIG_MPTCP)
>  	SKB_EXT_MPTCP,
>  #endif
> -#if IS_ENABLED(CONFIG_KCOV)
> +#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_SKB_EXTENSIONS)

I don't think this part is necessary, this is already under an ifdef:

#ifdef CONFIG_SKB_EXTENSIONS
enum skb_ext_id {

if I'm reading the code right.

That said I don't know why the enum is under CONFIG_SKB_EXTENSIONS in
the first place.

If extensions are not used doesn't matter if we define the enum and with
how many entries.

At the same time if we take the enum from under the ifdef and add stubs
for skb_ext_add() and skb_ext_find() we could actually remove the stubs
for kcov-related helpers. That seems cleaner and less ifdefy to me.

WDYT?

>  	SKB_EXT_KCOV_HANDLE,
>  #endif
>  	SKB_EXT_NUM, /* must be last */
> @@ -4608,7 +4608,7 @@ static inline void skb_reset_redirect(st
>  #endif
>  }
>  
> -#ifdef CONFIG_KCOV
> +#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_SKB_EXTENSIONS)
>  static inline void skb_set_kcov_handle(struct sk_buff *skb,
>  				       const u64 kcov_handle)
>  {
> @@ -4636,7 +4636,7 @@ static inline u64 skb_get_kcov_handle(st
>  static inline void skb_set_kcov_handle(struct sk_buff *skb,
>  				       const u64 kcov_handle) { }
>  static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
> -#endif /* CONFIG_KCOV */
> +#endif /* CONFIG_KCOV && CONFIG_SKB_EXTENSIONS */
>  
>  #endif	/* __KERNEL__ */
>  #endif	/* _LINUX_SKBUFF_H */

