Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4044122C
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 03:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhKACcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 22:32:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40626 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhKACcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 22:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7XPXEQCQ6leie1HGblPIuhdU07mkYja0dNEYlWTJYME=; b=XNCbVJEB+wpTFPYkNvMPzYQMDh
        5VM/wUW3zKIAaYBlXIowzsKYdCvMkkw82/hIJlcRqPi4LanfpWzgmPkYDpFb63Po3UmFvJrlZeE0V
        c7WxGa87FgmvMNmDOukuxGKmrjfQYkeUkL1Tf6jYl/ktqB0D64YmCQ2Jiv0ix05NOSsE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mhN4k-00CGdD-3f; Mon, 01 Nov 2021 03:29:30 +0100
Date:   Mon, 1 Nov 2021 03:29:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ecree.xilinx@gmail.com,
        hkallweit1@gmail.com, alexandr.lobakin@intel.com, saeed@kernel.org,
        netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv3 PATCH net-next] net: extend netdev_features_t
Message-ID: <YX9RCqTOAHtiGD3n@lunn.ch>
References: <20211101010535.32575-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101010535.32575-1-shenjian15@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define HNS3_DEFAULT_ACTIVE_FEATURES   \
> +	(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |  \
> +	NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_RXCSUM | NETIF_F_SG |  \
> +	NETIF_F_GSO | NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | \
> +	NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM | NETIF_F_SCTP_CRC \
> +	NETIF_F_GSO_UDP_TUNNEL | NETIF_F_FRAGLIST)

This is a problem, it only works for the existing 64 bit values, but
not for the values added afterwards. I would suggest you change this
into an array of u8 bit values. That scales to 256 feature flags. And
when that overflows, we can change from an array of u8 to u16, without
any major API changes.

>  static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 16f778887e14..9b3ab11e19c8 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -101,12 +101,12 @@ enum {
>  
>  typedef struct {
>  	DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
> -} netdev_features_t; 
> +} netdev_features_t;

That hunk looks odd.

>  
>  #define NETDEV_FEATURE_DWORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 64)
>  
>  /* copy'n'paste compression ;) */
> -#define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
> +#define __NETIF_F_BIT(bit)	((u64)1 << (bit))

You need to get away from this representation. It does not scale.

At the end of this conversion, either all NETIF_F_* macros need to be
gone, or they need to be aliases for NETIF_F_*_BIT. 

> -static inline void netdev_feature_zero(netdev_features_t *dst)
> +static inline void netdev_features_zero(netdev_features_t *dst)
>  {
>  	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
>  }
>  
> -static inline void netdev_feature_fill(netdev_features_t *dst)
> +static inline void netdev_features_fill(netdev_features_t *dst)
>  {
>  	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
>  }

I'm wondering that the value here is? What do we gain by added the s.
These changes cause a lot of churn in the users of these functions.

>  
> -static inline void netdev_feature_and(netdev_features_t *dst,
> -				      const netdev_features_t a,
> -				      const netdev_features_t b)
> +static inline netdev_features_t netdev_features_and(netdev_features_t a,
> +						    netdev_features_t b)
>  {
> -	bitmap_and(dst->bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
> +	netdev_features_t dst;
> +
> +	bitmap_and(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
> +	return dst;
>  }

The implementation needs to change, but do we need to change the
function signature? Why remove dst as a parameter?

It can be good to deliberately break the API so the compiler tells us
when we fail to update something. But do we actually need that here?
The API is nicely abstract, so i don't think a breaking change is
required.

> +/* only be used for the first 64 bits features */
> +static inline void netdev_features_set_bits(u64 bits, netdev_features_t *src)

Do we really want this special feature which only works for some
values? Does it clearly explode at compile time when used for bits
above 64?

>  {
> -	return (addr & __NETIF_F_BIT(nr)) > 0;
> +	netdev_features_t tmp;
> +
> +	bitmap_from_u64(tmp.bits, bits);
> +	*src = netdev_features_or(*src, tmp);
>  }

> +static inline void netdev_set_active_features(struct net_device *netdev,
> +					      netdev_features_t src)
> +{
> +	netdev->features = src;
> +}

_active_ is new here? 

> +static inline void netdev_set_hw_features(struct net_device *netdev,
> +					  netdev_features_t src)
> +{
> +	netdev->hw_features = src;
> +}

Here _hw_ makes sense. But i think we need some sort of
consistency. Either drop the _active_ from the function name, or
rename the netdev field active_features. 

       Andrew
