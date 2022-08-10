Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85C158EA02
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiHJJqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiHJJqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:46:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA68D20BCD
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 02:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660124757; x=1691660757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cSZd9BJbm1lNmN1qaqPLVMyi3/Nu3SGj86nne8+8gzQ=;
  b=is3u8i/XUAfEu/HmBXXBcNZTEvca+i/7tClzqmfCMoBUq8qTFmBoXgag
   7K6ojXWhCRBCyumz4TVDcr9cJKv5eGskME2rARb9cdJ+qinQw5dlIUSJt
   1cH58QmbeBo+tKN3IKich0TDtZvEUN5MWBIdr9B9Oz/0SSoVkJhBI2tuz
   Ecr6b7KBP4hfbVBob5QCSheBHZou7WjsWaRaecR6ZZPsIqcGrT55ChLu8
   AgLRrp9VT6kIMoZXn2U+5CafK3cnP83Um9fpXE8+vEtR3eAeyk89501wE
   8V8m0hE0qCdiSdq1yV0fchomYAQZDv3yCQ11F/cecSPg4IfQ7fLvqVr3z
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="274096951"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="274096951"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 02:45:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="581171135"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 10 Aug 2022 02:45:54 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27A9jrX4010766;
        Wed, 10 Aug 2022 10:45:53 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 01/36] net: introduce operation helpers for netdev features
Date:   Wed, 10 Aug 2022 11:43:58 +0200
Message-Id: <20220810094358.1303843-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810030624.34711-2-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-2-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 11:05:49 +0800

> Introduce a set of bitmap operation helpers for netdev features,
> then we can use them to replace the logical operation with them.
> 
> The implementation of these helpers are based on the old prototype
> of netdev_features_t is still u64. These helpers will be rewritten
> on the last patch, when the prototype changes.
> 
> To avoid interdependencies between netdev_features_helper.h and
> netdevice.h, put the helpers for testing feature in the netdevice.h,
> and move advandced helpers like netdev_get_wanted_features() and
> netdev_intersect_features() to netdev_features_helper.h.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  include/linux/netdev_features.h        |  11 +
>  include/linux/netdev_features_helper.h | 707 +++++++++++++++++++++++++

'netdev_feature_helpers.h' fits more I guess, doesn't it? It
contains several helpers, not only one.
And BTW, do you think it's worth to create a new file rather than
put everything just in netdev_features.h?

>  include/linux/netdevice.h              |  45 +-
>  net/8021q/vlan_dev.c                   |   1 +
>  net/core/dev.c                         |   1 +
>  5 files changed, 747 insertions(+), 18 deletions(-)
>  create mode 100644 include/linux/netdev_features_helper.h
> 
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 7c2d77d75a88..9d434b4e6e6e 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -11,6 +11,17 @@
>  
>  typedef u64 netdev_features_t;
>  
> +struct netdev_feature_set {
> +	unsigned int cnt;
> +	unsigned short feature_bits[];
> +};
> +
> +#define DECLARE_NETDEV_FEATURE_SET(name, features...)			\
> +	const struct netdev_feature_set name = {			\
> +		.cnt = sizeof((unsigned short[]){ features }) / sizeof(unsigned short),	\
> +		.feature_bits = { features },				\
> +	}
> +
>  enum {
>  	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
>  	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
> diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
> new file mode 100644
> index 000000000000..5423927d139b
> --- /dev/null
> +++ b/include/linux/netdev_features_helper.h
> @@ -0,0 +1,707 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Network device features helpers.
> + */
> +#ifndef _LINUX_NETDEV_FEATURES_HELPER_H
> +#define _LINUX_NETDEV_FEATURES_HELPER_H
> +
> +#include <linux/netdevice.h>
> +
> +static inline void netdev_features_zero(netdev_features_t *dst)
> +{
> +	*dst = 0;
> +}
> +
> +/* active_feature prefer to netdev->features */
> +#define netdev_active_features_zero(ndev) \
> +		netdev_features_zero(&ndev->features)

netdev_features_t sometimes is being placed and used on the stack.
I think it's better to pass just `netdev_features_t *` to those
helpers, this way you wouldn't also need to create a new helper
for each net_device::*_features.

> +
> +#define netdev_hw_features_zero(ndev) \
> +		netdev_features_zero(&ndev->hw_features)
> +
> +#define netdev_wanted_features_zero(ndev) \

[...]

> +#define netdev_gso_partial_features_and(ndev, __features) \
> +		netdev_features_and(ndev->gso_partial_features, __features)
> +
> +/* helpers for netdev features '&=' operation */
> +static inline void
> +netdev_features_mask(netdev_features_t *dst,
> +			   const netdev_features_t features)
> +{
> +	*dst = netdev_features_and(*dst, features);

A small proposal: if you look at bitmap_and() for example, it
returns 1 if the resulting bitmap is non-empty and 0 if it is. What
about doing the same here? It would probably help to do reduce
boilerplating in the drivers where we only want to know if there's
anything left after masking.
Same for xor, toggle etc.

> +}
> +
> +static inline void
> +netdev_active_features_mask(struct net_device *ndev,
> +			    const netdev_features_t features)
> +{
> +	ndev->features = netdev_active_features_and(ndev, features);
> +}

[...]

> +/* helpers for netdev features 'set bit array' operation */
> +static inline void
> +netdev_features_set_array(const struct netdev_feature_set *set,
> +			  netdev_features_t *dst)
> +{
> +	int i;
> +
> +	for (i = 0; i < set->cnt; i++)

Nit: kernel is C11 now, you can do just `for (u32 i = 0; i ...`.
(and yeah, it's better to use unsigned types when you don't plan
to store negative values there).

> +		netdev_feature_add(set->feature_bits[i], dst);
> +}

[...]

> -- 
> 2.33.0

Thanks,
Olek
