Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EE93D8786
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhG1Fz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhG1Fz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:55:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9539F60F91;
        Wed, 28 Jul 2021 05:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627451755;
        bh=dUBkfSuy+pimGAygKvH/n56Fu+Rjei7swUaiM8a6UqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLN7/AfFyKyqqZDZ9FDSMX6paOr2wueWSWObcEAr/Zi1oyjzjstRV/VEwxN7kqrMN
         LrM8kTmwyBi22OUBnN5t74TunCqP0FyLqfYR4+puz8/QuIzbcLYEnwsV86MkZ/qY9S
         abW/DHoDjfQ4zF+SRbQj6vg+F6J88I07elfvWVsc=
Date:   Wed, 28 Jul 2021 07:55:53 +0200
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
Subject: Re: [PATCH 19/64] ip: Use struct_group() for memcpy() regions
Message-ID: <YQDxaYrHu0PeBIuX@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-20-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-20-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:58:10PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() in struct flowi4, struct ipv4hdr, and struct ipv6hdr
> around members saddr and daddr, so they can be referenced together. This
> will allow memcpy() and sizeof() to more easily reason about sizes,
> improve readability, and avoid future warnings about writing beyond the
> end of saddr.
> 
> "pahole" shows no size nor member offset changes to struct flowi4.
> "objdump -d" shows no meaningful object code changes (i.e. only source
> line number induced differences.)
> 
> Note that since this is a UAPI header, struct_group() has been open
> coded.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/net/flow.h            |  6 ++++--
>  include/uapi/linux/if_ether.h | 12 ++++++++++--
>  include/uapi/linux/ip.h       | 12 ++++++++++--
>  include/uapi/linux/ipv6.h     | 12 ++++++++++--
>  net/core/flow_dissector.c     | 10 ++++++----
>  net/ipv4/ip_output.c          |  6 ++----
>  6 files changed, 42 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/flow.h b/include/net/flow.h
> index 6f5e70240071..f1a3b6c8eae2 100644
> --- a/include/net/flow.h
> +++ b/include/net/flow.h
> @@ -81,8 +81,10 @@ struct flowi4 {
>  #define flowi4_multipath_hash	__fl_common.flowic_multipath_hash
>  
>  	/* (saddr,daddr) must be grouped, same order as in IP header */
> -	__be32			saddr;
> -	__be32			daddr;
> +	struct_group(addrs,
> +		__be32			saddr;
> +		__be32			daddr;
> +	);
>  
>  	union flowi_uli		uli;
>  #define fl4_sport		uli.ports.sport
> diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
> index a0b637911d3c..8f5667b2ea92 100644
> --- a/include/uapi/linux/if_ether.h
> +++ b/include/uapi/linux/if_ether.h
> @@ -163,8 +163,16 @@
>  
>  #if __UAPI_DEF_ETHHDR
>  struct ethhdr {
> -	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
> -	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
> +	union {
> +		struct {
> +			unsigned char h_dest[ETH_ALEN];	  /* destination eth addr */
> +			unsigned char h_source[ETH_ALEN]; /* source ether addr	  */
> +		};
> +		struct {
> +			unsigned char h_dest[ETH_ALEN];	  /* destination eth addr */
> +			unsigned char h_source[ETH_ALEN]; /* source ether addr	  */
> +		} addrs;

A union of the same fields in the same structure in the same way?

Ah, because struct_group() can not be used here?  Still feels odd to see
in a userspace-visible header.

> +	};
>  	__be16		h_proto;		/* packet type ID field	*/
>  } __attribute__((packed));
>  #endif
> diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
> index e42d13b55cf3..33647a37e56b 100644
> --- a/include/uapi/linux/ip.h
> +++ b/include/uapi/linux/ip.h
> @@ -100,8 +100,16 @@ struct iphdr {
>  	__u8	ttl;
>  	__u8	protocol;
>  	__sum16	check;
> -	__be32	saddr;
> -	__be32	daddr;
> +	union {
> +		struct {
> +			__be32	saddr;
> +			__be32	daddr;
> +		} addrs;
> +		struct {
> +			__be32	saddr;
> +			__be32	daddr;
> +		};

Same here (except you named the first struct addrs, not the second,
unlike above).


> +	};
>  	/*The options start here. */
>  };
>  
> diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
> index b243a53fa985..1c26d32e733b 100644
> --- a/include/uapi/linux/ipv6.h
> +++ b/include/uapi/linux/ipv6.h
> @@ -130,8 +130,16 @@ struct ipv6hdr {
>  	__u8			nexthdr;
>  	__u8			hop_limit;
>  
> -	struct	in6_addr	saddr;
> -	struct	in6_addr	daddr;
> +	union {
> +		struct {
> +			struct	in6_addr	saddr;
> +			struct	in6_addr	daddr;
> +		} addrs;
> +		struct {
> +			struct	in6_addr	saddr;
> +			struct	in6_addr	daddr;
> +		};

addrs first?  Consistancy is key :)

thanks,

greg k-h
