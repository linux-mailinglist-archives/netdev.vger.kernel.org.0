Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F49217A713
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCEOCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:02:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:40752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgCEOCp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 09:02:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8B58AAB6D;
        Thu,  5 Mar 2020 14:02:42 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B009BE037F; Thu,  5 Mar 2020 15:02:41 +0100 (CET)
Date:   Thu, 5 Mar 2020 15:02:41 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Era Mayflower <mayflowerera@gmail.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] macsec: Netlink support of XPN cipher suites (IEEE
 802.1AEbw)
Message-ID: <20200305140241.GA28693@unicorn.suse.cz>
References: <20200305220108.18780-1-mayflowerera@gmail.com>
 <20200305220108.18780-2-mayflowerera@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305220108.18780-2-mayflowerera@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 10:01:08PM +0000, Era Mayflower wrote:
> Netlink support of extended packet number cipher suites,
> allows adding and updating XPN macsec interfaces.
> 
> Added support in:
>     * Creating interfaces with GCM-AES-XPN-128 and GCM-AES-XPN-256.
>     * Setting and getting packet numbers with 64bit of SAs.
>     * Settings and getting ssci of SCs.
>     * Settings and getting salt of SecYs.
> 
> Depends on: macsec: Support XPN frame handling - IEEE 802.1AEbw.
> 
> Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
> ---
[...]
> diff --git a/include/net/macsec.h b/include/net/macsec.h
> index a0b1d0b5c..3c7914ff1 100644
> --- a/include/net/macsec.h
> +++ b/include/net/macsec.h
> @@ -11,6 +11,9 @@
>  #include <uapi/linux/if_link.h>
>  #include <uapi/linux/if_macsec.h>
>  
> +#define MACSEC_DEFAULT_PN_LEN 4
> +#define MACSEC_XPN_PN_LEN 8
> +
>  #define MACSEC_SALT_LEN 12
>  
>  typedef u64 __bitwise sci_t;
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 024af2d1d..ee424d915 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -462,6 +462,8 @@ enum {
>  	IFLA_MACSEC_SCB,
>  	IFLA_MACSEC_REPLAY_PROTECT,
>  	IFLA_MACSEC_VALIDATION,
> +	IFLA_MACSEC_SSCI,
> +	IFLA_MACSEC_SALT,
>  	IFLA_MACSEC_PAD,
>  	__IFLA_MACSEC_MAX,
>  };

Doesn't this break backword compatibility? You change the value of
IFLA_MACSEC_PAD; even if it's only used as padding, if an old client
uses it, new kernel will interpret it as IFLA_MACSEC_SSCI (an the same
holds for new client with old kernel).

> diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
> index 1d63c43c3..c8fab9673 100644
> --- a/include/uapi/linux/if_macsec.h
> +++ b/include/uapi/linux/if_macsec.h
> @@ -25,6 +25,8 @@
>  /* cipher IDs as per IEEE802.1AEbn-2011 */
>  #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
>  #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
> +#define MACSEC_CIPHER_ID_GCM_AES_XPN_128 0x0080C20001000003ULL
> +#define MACSEC_CIPHER_ID_GCM_AES_XPN_256 0x0080C20001000004ULL
>  
>  /* deprecated cipher ID for GCM-AES-128 */
>  #define MACSEC_DEFAULT_CIPHER_ID     0x0080020001000001ULL
> @@ -66,6 +68,8 @@ enum macsec_secy_attrs {
>  	MACSEC_SECY_ATTR_INC_SCI,
>  	MACSEC_SECY_ATTR_ES,
>  	MACSEC_SECY_ATTR_SCB,
> +	MACSEC_SECY_ATTR_SSCI,
> +	MACSEC_SECY_ATTR_SALT,
>  	MACSEC_SECY_ATTR_PAD,
>  	__MACSEC_SECY_ATTR_END,
>  	NUM_MACSEC_SECY_ATTR = __MACSEC_SECY_ATTR_END,
> @@ -78,6 +82,7 @@ enum macsec_rxsc_attrs {
>  	MACSEC_RXSC_ATTR_ACTIVE,  /* config/dump, u8 0..1 */
>  	MACSEC_RXSC_ATTR_SA_LIST, /* dump, nested */
>  	MACSEC_RXSC_ATTR_STATS,   /* dump, nested, macsec_rxsc_stats_attr */
> +	MACSEC_RXSC_ATTR_SSCI,    /* config/dump, u32 */
>  	MACSEC_RXSC_ATTR_PAD,
>  	__MACSEC_RXSC_ATTR_END,
>  	NUM_MACSEC_RXSC_ATTR = __MACSEC_RXSC_ATTR_END,

The same problem with these two.

I'm also a bit unsure about the change of type and length of
MACSEC_SA_ATTR_PN but I would have to get more familiar with the code to
see if it is really a problem.

Michal
