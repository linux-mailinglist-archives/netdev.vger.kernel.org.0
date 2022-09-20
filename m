Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7CA5BEE42
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiITULE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiITULC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:11:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A295A719BE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FD4C62215
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0A1C433D7;
        Tue, 20 Sep 2022 20:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663704660;
        bh=MFypnIWH7SZob6OWKTjjnaQ6tlx+88aXA+kcl7kZzFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GOqH6oaN6+SpJhTPysVaA//CFZ5BI6z6XC468+8atBFcM/duO/BMktZyGhNXMwoN5
         Hr87CoJJVIFWE2/HuHnMcj5kmtpTpdgrWy5x1FPjHNtTGFP8zJlMTcnjflZhtj7JdR
         DBHms+M8ArPi2pkDVUKz8PTZN7nNvPSu+6DrB/9N9nJgkwYSEaje5ilGKknP1SGdJT
         5Am+3qH+9p9GpB0TZZhN+lzG2c9s4dl32O9lYFQRgSlQONaG1gdRr3tUQfOZjvsEq+
         7Qrm5NsZejQsmE1Tf81GTaxvU+ggmmxncPq5y+0gbsppzBpSEqZjaFAXgr5O87KC7w
         4IXDxU4J2/ZdQ==
Date:   Tue, 20 Sep 2022 13:10:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [RFCv8 PATCH net-next 01/55] net: introduce operation helpers
 for netdev features
Message-ID: <20220920131059.7626a665@kernel.org>
In-Reply-To: <20220918094336.28958-2-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
        <20220918094336.28958-2-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Sep 2022 09:42:42 +0000 Jian Shen wrote:
> Introduce a set of bitmap operation helpers for netdev features,
> then we can use them to replace the logical operation with them.
> 
> The implementation of these helpers are based on the old prototype
> of netdev_features_t is still u64. These helpers will be rewritten
> on the last patch, follow the prototype changes. For the new type
> netdev_features_t maybe large than 8 bytes, use netdev_features_t
> pointer as parameter.
> 
> To avoid interdependencies between netdev_features_helper.h and
> netdevice.h, put the helpers for testing feature in the netdevice.h,
> and move advandced helpers like netdev_get_wanted_features() and
> netdev_intersect_features() to netdev_features_helper.h.

> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> index 8b77582bdfa0..8023a3f0d43b 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> @@ -4,6 +4,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/io-64-nonatomic-hi-lo.h>
>  #include <linux/lockdep.h>
> +#include <linux/netdev_feature_helpers.h>
>  #include <net/dst_metadata.h>
>  
>  #include "nfpcore/nfp_cpp.h"

We need to start breaking upstreamable chunks out of this mega-series
otherwise we won't make any progress..

Please make a patch which will move netdev_intersect_features() and
netdev_get_wanted_features() to the new linux/netdev_feature_helpers.h
header, and add the missing includes. Post it separately as soon as
possible.

> diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
> new file mode 100644
> index 000000000000..4bb5de61e4e9
> --- /dev/null
> +++ b/include/linux/netdev_feature_helpers.h
> @@ -0,0 +1,607 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Network device features helpers.
> + */
> +#ifndef _LINUX_NETDEV_FEATURES_HELPER_H
> +#define _LINUX_NETDEV_FEATURES_HELPER_H
> +
> +#include <linux/netdevice.h>
> +
> +static inline void __netdev_features_zero(netdev_features_t *dst)
> +{
> +	*dst = 0;
> +}
> +
> +#define netdev_features_zero(features) __netdev_features_zero(&(features))
> +
> +/* active_feature prefer to netdev->features */
> +#define netdev_active_features_zero(ndev) \
> +		netdev_features_zero((ndev)->features)
> +

No need for empty lines between the defines of the same category, IMHO.

> +#define netdev_hw_features_zero(ndev) \
> +		netdev_features_zero((ndev)->hw_features)

