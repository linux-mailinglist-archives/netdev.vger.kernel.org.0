Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F592DA747
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 05:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgLOE6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 23:58:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgLOE6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 23:58:22 -0500
Date:   Mon, 14 Dec 2020 20:57:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608008261;
        bh=NxyC689WVM/1e+7LYdvV6gJmHHc8qT3li4Ht/LdnQRE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GnhQPhwyyAG7KzdbKefRV4zw6Al9ASss7ogOQlpY+t70geCEDMBXpi0nBEofw3GtV
         Av8XLObLQSVqcdNe1hJkbYSxk64sZf53PXMp4Lrxjl3GMNdx304+Li66y/t75N8/YL
         XIhlgyX6nfyQKtDNEVE+e6DcEoAuv/v+2TvUPINhqkxPnJYAh/i4JsVUoniZu/miUq
         8v2qwCi99nidmJ3uTOrBcerkD7KurDQCUvwfSqRulK7hHk9jiX0of5uBp9Bg/xQOne
         6cEcGgHXoNi0Kw7dR4WlvB1m1sRURQnGVLIkyLP8nFsWt+sj8Zy22CM4lgXe3aTUub
         ER/D+/DyYK3Ew==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <david.lebrun@uclouvain.be>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [PATCH net-next] seg6: fix the max number of supported SRv6
 behavior attributes
Message-ID: <20201214205740.7e7a3945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212010005.7338-1-andrea.mayer@uniroma2.it>
References: <20201212010005.7338-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Dec 2020 02:00:05 +0100 Andrea Mayer wrote:
> The set of required attributes for a given SRv6 behavior is identified
> using a bitmap stored in an unsigned long, since the initial design of
> SRv6 networking in Linux. Recently the same approach has been used for
> identifying the optional attributes.
> 
> We realized that choosing an unsigned long to store a bitmap is not a
> proper design choice considering that new attributes can be defined in the
> future. The problem is that the size of an unsigned long can be 32 or 64
> bits depending on the architecture. Therefore the maximum number of
> attributes that can be defined currently is 32 or 64 depending on the
> architecture. This issue has not caused any harm so far, because new
> attributes are defined statically in the kernel code, and currently only 10
> attributes have been defined.
> 
> With this patch, we set the maximum number of attributes that can be
> supported by the SRv6 networking in Linux to be 64 regardless of the
> architecture.
> 
> We changed the unsigned long type of the bitmaps to the u64 type and
> adapted the code accordingly. In particular:
> 
>  - We replaced all patterns (1 << i) with the macro SEG6_F_ATTR(i) in order
>    to address overflow issues caused by 32-bit signed arithmetic.
> 
>    Many thanks to Colin Ian King for catching the overflow problem and
>    inspiring this patch;
> 
>  - At compile time we verify that the total number of attributes does not
>    exceed the fixed value of 64. Otherwise, kernel build fails forcing
>    developers to reconsider adding a new attribute or extending the
>    total number of supported attributes by the SRv6 networking.

Over all seems like a good thing too catch but the patch seems to go
further than necessary. And on 32bit systems using u64 is when we only
need 10 attrs is kinda wasteful.

> Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
> Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
> Fixes: 891ef8dd2a8d ("ipv6: sr: implement additional seg6local actions")
> Fixes: 004d4b274e2a ("ipv6: sr: Add seg6local action End.BPF")
> Fixes: 964adce526a4 ("seg6: improve management of behavior attributes")
> Fixes: 0a3021f1d4e5 ("seg6: add support for optional attributes in SRv6 behaviors")
> Fixes: 664d6f86868b ("seg6: add support for the SRv6 End.DT4 behavior")
> Fixes: 20a081b7984c ("seg6: add VRF support for SRv6 End.DT6 behavior")

We use fixes tags for bugs only, nothing seems broken here. It's more
of a fool-proofing for the future.

> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h | 10 ++++
>  net/ipv6/seg6_local.c           | 89 ++++++++++++++++++---------------
>  2 files changed, 60 insertions(+), 39 deletions(-)
> 
> diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
> index 3b39ef1dbb46..81b3ac430670 100644
> --- a/include/uapi/linux/seg6_local.h
> +++ b/include/uapi/linux/seg6_local.h
> @@ -27,9 +27,19 @@ enum {
>  	SEG6_LOCAL_OIF,
>  	SEG6_LOCAL_BPF,
>  	SEG6_LOCAL_VRFTABLE,
> +	/* new attributes go here */
>  	__SEG6_LOCAL_MAX,
> +
> +	/* Support up to 64 different types of attributes.
> +	 *
> +	 * If you need to add a new attribute, please make sure that it DOES
> +	 * NOT violate the constraint of having a maximum of 64 possible
> +	 * attributes.
> +	 */
> +	__SEG6_LOCAL_MAX_SUPP = 64,

Let's not define this, especially in a uAPI header. No need to make
promises on max attr id to user space.


> +#define SEG6_F_ATTR(i) (((u64)1) << (i))

This wrapper looks useful, worth keeping.
> @@ -1692,6 +1694,15 @@ static const struct lwtunnel_encap_ops seg6_local_ops = {
>  
>  int __init seg6_local_init(void)
>  {
> +	/* If the max total number of defined attributes is reached, then your
> +	 * kernel build stops here.
> +	 *
> +	 * This check is required to avoid arithmetic overflows when processing
> +	 * behavior attributes and the maximum number of defined attributes
> +	 * exceeds the allowed value.
> +	 */
> +	BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > SEG6_LOCAL_MAX_SUPP);

BUILD_BUG_ON(SEG6_LOCAL_MAX > 31)

>  	return lwtunnel_encap_add_ops(&seg6_local_ops,
>  				      LWTUNNEL_ENCAP_SEG6_LOCAL);
>  }

