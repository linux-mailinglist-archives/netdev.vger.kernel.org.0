Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A449656B66
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 14:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiL0NpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 08:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiL0NpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 08:45:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE22DFD;
        Tue, 27 Dec 2022 05:45:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6562B8103C;
        Tue, 27 Dec 2022 13:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD26C433F0;
        Tue, 27 Dec 2022 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672148713;
        bh=KiCA2W+XpN64cUp/hRLYPjjOV94LCqlswnrr+5HjFa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fnn4FmXduKhYf8KFQWIJra/llhpOgiLJJr5CnY9WBHT0D0Ikm5Z37P2iIAWJwcy8Y
         kuT3aJPzHvDWJcqZAO8fjlyXK/rckBzRTmogJV9MePBLMD+Zvf/LDoBmTaxmIcmR16
         sztfDc/jGeh7dmCAUukUA5DH9xrmT/U5cRLb8zzs5xv6SeC3z8vLYdTULxLjVMgIk9
         voYVXR3WiYZF/1WdZNzTvJ44asVfyHeZ1dTpUL8a6q1gw/Lo8rPZyZCjxfLxuJ5mw8
         h2/PasBLzhcUPQzePXBQdllJx4ToR+7yY8Rg7Yf7SScFy25D0AO3Zz1bP0aFhEZEkq
         6jsP9TW7SG5xA==
Date:   Tue, 27 Dec 2022 15:45:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paul Gazzillo <paul@pgazz.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zheng Bin <zhengbin13@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Suman Ghosh <sumang@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2_pf: Select NET_DEVLINK when enabling
 OCTEONTX2_PF
Message-ID: <Y6r25RChRDBmk8YX@unreal>
References: <20221219171149.833822-1-paul@pgazz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219171149.833822-1-paul@pgazz.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 12:11:28PM -0500, Paul Gazzillo wrote:
> When using COMPILE_TEST, the driver controlled by OCTEONTX2_PF does
> not select NET_DEVLINK while the related OCTEONTX2_AF driver does.
> This means that when OCTEONTX2_PF is enabled from a default
> configuration, linker errors will occur due to undefined references to
> code controlled by NET_DEVLINK.
> 
> 1. make.cross ARCH=x86_64 defconfig
> 2. make.cross ARCH=x86_64 menuconfig
> 3. Enable COMPILE_TEST
>    General setup  --->
>      Compile also drivers which will not load
> 4. Enable OCTEONTX2_PF
>    Device Drivers  --->
>      Network device support  --->
>        Ethernet driver support  --->
>          Marvell OcteonTX2 NIC Physical Function driver
> 5. Exit and save configuration.  NET_DEVLINK will still be disabled.
> 6. make.cross ARCH=x86_64 several linker errors, for example,
>    ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o:
>      in function `otx2_register_dl':
>    otx2_devlink.c:(.text+0x142): undefined reference to `devlink_alloc_ns'
> 
> This fix adds "select NET_DEVLINK" link to OCTEONTX2_PF's Kconfig
> specification to match OCTEONTX2_AF.
> 
> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
> Signed-off-by: Paul Gazzillo <paul@pgazz.com>
> ---
> v1 -> v2: Added the fixes tag
> 
>  drivers/net/ethernet/marvell/octeontx2/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
