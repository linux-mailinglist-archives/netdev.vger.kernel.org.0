Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE763F3654
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 00:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhHTWV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 18:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231334AbhHTWV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 18:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F0160FBF;
        Fri, 20 Aug 2021 22:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629498078;
        bh=/mPrx5HSawvrMzpeHVhapxF2G89uzszKWakMrW4wzdE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xt6rhIWgwhMr43PiCxMhVcdaevTSu1UcmhrRaTxeXFgEAEoOrw3lxjMbIcfsZxbWy
         9Im+hKABqnV9F2nEAtDWkb8bHqlyyw2MnFoOYpvgkJb/vcXYeIwkcha5bMwIC4fuCI
         wGMsVR+Z7ffHkHkP2v5ES0OyJxoBTRFhIvLmLMeWuWZxDr48704uWCbv7HkPH/SM9F
         uro6349EMvH8zJ0pDcQHNNf+1okjnErONWSL2uwPy2DLxJlWwg4HDSplopFS2/h4hl
         fX58bfIXs0a35ZZmlqgrBzPKQNOfzGoIeABoRJaUSXMgqxEvncKr8HkOWRdItJBCu8
         e7YZo4Trvf0yQ==
Date:   Fri, 20 Aug 2021 15:21:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Yufeng Mo <moyufeng@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <salil.mehta@huawei.com>,
        <linuxarm@huawei.com>, <linuxarm@openeuler.org>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jacob.e.keller@intel.com>, <ioana.ciornei@nxp.com>,
        <vladimir.oltean@nxp.com>, <sgoutham@marvell.com>,
        <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <merez@codeaurora.org>,
        <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3 net-next 2/4] ethtool: extend coalesce setting uAPI
 with CQE mode
Message-ID: <20210820152116.0741369a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <32fd0b32-e748-42d9-6468-b5b1393511e9@ti.com>
References: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
        <1629444920-25437-3-git-send-email-moyufeng@huawei.com>
        <32fd0b32-e748-42d9-6468-b5b1393511e9@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021 21:27:13 +0300 Grygorii Strashko wrote:
> This is very big change which is not only mix two separate changes, but also looks
> half-done. From one side you're adding HW feature supported by limited number of HW,
> from another - changing most of net drivers to support it by generating mix of legacy
> and new kernel_ethtool_coalesce parameters.
> 
> There is also an issue - you do not account get/set_per_queue_coalesce() in any way.

ethtool's netlink interface does not support per queue coalescing.
I don't think it's fair to require it as part of this series.

> Would it be possible to consider following, please?
> 
> - move extack change out of this series

Why? To have to change all the drivers twice?

> - option (a)
>    add new callbacks in ethtool_ops as set_coalesce_cqe/get_coalesce_cqe for CQE support.
>    Only required drivers will need to be changed.

All the params are changed as one operation from user space's
perspective. Having two ops would make it problematic for drivers 
to fail the entire op without modifying half of the parameters in 
a previous callback.

> - option (b)
>    add struct ethtool_coalesce as first field of kernel_ethtool_coalesce

This ends up being more painful than passing an extra parameter 
in my experience.

> struct kernel_ethtool_coalesce {
> 	/* legacy */
> 	struct ethtool_coalesce coal;
> 
> 	/* new */
> 	u8 use_cqe_mode_tx;
> 	u8 use_cqe_mode_rx;
> };
> 
> --  then b.1
>    drivers can be updated as
>     static int set_coalesce(struct net_device *dev,
>     			    struct kernel_ethtool_coalesce *kernel_coal)
>     {
> 	struct ethtool_coalesce *coal = &kernel_coal->coal;
>     
>     (which will clearly indicate migration to the new interface )
> 
> -- then b.2
>      add new callbacks in ethtool_ops as set_coalesce_ext/get_coalesce_ext (extended)
>      which will accept struct kernel_ethtool_coalesce as parameter an allow drivers to migrate when needed
>      (or as separate patch which will do only migration).
> 
> Personally, I like "b.2".

These options were considered. None of the options is great to 
be honest. Let's try the new params, I say. 
