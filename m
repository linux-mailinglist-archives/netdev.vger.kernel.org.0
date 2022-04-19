Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655805070E5
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbiDSOrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353629AbiDSOrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:47:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C623A5C7
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650379458; x=1681915458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V1y39dchULVYyeKFeiaIXNKnbicJEjGT3wOOfMDkWeE=;
  b=W/4N+yYzC7W7tuJnuo64zgc/YaBWkioHzEBpOyqCrJbj4hFdad7eTnT9
   En8Lw3srOhwDmeIeEkXqmwUwYcziX45hsJHDuzUEL5VaGEL2KdBUnC0s0
   aRsZOzLcq/piyKRMKGJzqccIeGLGJwBYvwESYrSvQVMp2/zn15+5xYMnC
   75rY7xZxanXNI7IXMAlZxraYt/+LfuPvKd33VN2Zssyr9eLJDNkGwqXWO
   Wur3oGjfU3LWbwCukM8qGst4W0jAPo+6wrgtGzMjiLmJkW18hzXs2xJ6u
   MnDvSIaDO2kKAVS0M/QChCchsAC5sC/6s3CPV+KiKFuYOE7ZV9pv89Vjx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="263540740"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="263540740"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:44:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="861280448"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 19 Apr 2022 07:44:15 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23JEiDmu032074;
        Tue, 19 Apr 2022 15:44:13 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org,
        lipeng321@huawei.com
Subject: Re: [RFCv6 PATCH net-next 01/19] net: introduce operation helpers for netdev features
Date:   Tue, 19 Apr 2022 16:40:45 +0200
Message-Id: <20220419144045.1664765-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419022206.36381-2-shenjian15@huawei.com>
References: <20220419022206.36381-1-shenjian15@huawei.com> <20220419022206.36381-2-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Tue, 19 Apr 2022 10:21:48 +0800

> Introduce a set of bitmap operation helpers for netdev features,
> then we can use them to replace the logical operation with them.
> As the nic driversare not supposed to modify netdev_features
> directly, it also introduces wrappers helpers to this.
> 
> The implementation of these helpers are based on the old prototype
> of netdev_features_t is still u64. I will rewrite them on the last
> patch, when the prototype changes.
> 
> To avoid interdependencies between netdev_features_helper.h and
> netdevice.h, put the helpers for testing feature is set in the
> netdevice.h, and move advandced helpers like
> netdev_get_wanted_features() and netdev_intersect_features() to
> netdev_features_helper.h.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  .../net/ethernet/netronome/nfp/nfp_net_repr.c |   1 +
>  include/linux/netdev_features.h               |  12 +
>  include/linux/netdev_features_helper.h        | 604 ++++++++++++++++++
>  include/linux/netdevice.h                     |  45 +-
>  net/8021q/vlan_dev.c                          |   1 +
>  net/core/dev.c                                |   1 +
>  6 files changed, 646 insertions(+), 18 deletions(-)
>  create mode 100644 include/linux/netdev_features_helper.h
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> index ba3fa7eac98d..08f2c54e0a11 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> @@ -4,6 +4,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/io-64-nonatomic-hi-lo.h>
>  #include <linux/lockdep.h>
> +#include <linux/netdev_features_helper.h>
>  #include <net/dst_metadata.h>
>  
>  #include "nfpcore/nfp_cpp.h"
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 2c6b9e416225..e2b66fa3d7d6 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -11,6 +11,18 @@
>  
>  typedef u64 netdev_features_t;
>  
> +struct netdev_feature_set {
> +	unsigned int cnt;
> +	unsigned short feature_bits[];
> +};
> +
> +#define DECLARE_NETDEV_FEATURE_SET(name, features...)		\
> +	static unsigned short __##name##_s[] = {features};	\
> +	struct netdev_feature_set name = {			\

I suggest using `const` here. Those sets are needed only to
initialize bitmaps, that's it. They are not supposed to be
modified. This would be one more hardening here to avoid some weird
usages of sets, and also would place them in .rodata instead of just
.data.

Function                                     old     new   delta
main                                          35      33      -2
Total: Before=78, After=76, chg -2.56%
add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-14 (-14)
Data                                         old     new   delta
arr1                                           6       -      -6
arr2                                           8       -      -8
Total: Before=15, After=1, chg -93.33%
add/remove: 2/0 grow/shrink: 0/0 up/down: 14/0 (14)
RO Data                                      old     new   delta
arr1                                           -       8      +8
arr2                                           -       6      +6
Total: Before=36, After=50, chg +38.89%

As you can see, there's a 2-byte code optimization. And that was
just a simpliest oneliner. The gains will be much bigger from the
real usages.

> +		.cnt = ARRAY_SIZE(__##name##_s),		\
> +		.feature_bits = {features},			\
> +	}

The problem with the current macro is that it doesn't allow to
declare feature sets as static. Because the temporary array for
counting the number of bits goes first, and doing

static DECLARE_NETDEV_FEATURE_SET();

wouldn't change anything.
But we want to have most feature sets static as they will be needed
only inside one file. Making every of them global would hurt
optimization.

At the end, I came to

#define DECLARE_NETDEV_FEATURE_SET(name, features...)			\
	const struct netdev_feature_set name = {			\
		.feature_bits = { features },				\
		.cnt = sizeof((u16 []){ features }) / sizeof(u16),	\
	}

because ARRAY_SIZE() can be taken only from a variable, not from
a compound literal.
But this one is actually OK. We don't need ARRAY_SIZE() in here
since we define an unnamed array of an explicit type that we know
for sure inline. So there's no chance to do it wrong as long as
the @features argument is correct.

The ability to make it static is important. For example, when I
marked them both static, I got

add/remove: 0/0 grow/shrink: 0/0 up/down: 0/0 (0)
Function                                     old     new   delta
Total: Before=76, After=76, chg +0.00%
add/remove: 0/0 grow/shrink: 0/0 up/down: 0/0 (0)
Data                                         old     new   delta
Total: Before=1, After=1, chg +0.00%
add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-14 (-14)
RO Data                                      old     new   delta
arr1                                           6       -      -6
arr2                                           8       -      -8
Total: Before=50, After=36, chg -28.00%

i.e. both of the sets were removed, because my main() was:

	printf("cnt1: %u, cnt2: %u\n", arr1.cnt, arr2.cnt);

The compiler saw that I don't use them, except for printing values
which are actually compile-time constants, and wiped them.
Previously, they were global so it didn't have a clue if they're
used anywhere else.
This was a simple stupid example, but it will bring a lot more value
in real use cases. So please consider my variant :D

> +
>  enum {
>  	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
>  	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */

--- 8< ---

> -- 
> 2.33.0

Thanks,
Al
