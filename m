Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E316364C449
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 08:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiLNHOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 02:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLNHOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 02:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663641D670;
        Tue, 13 Dec 2022 23:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CF8AB816A6;
        Wed, 14 Dec 2022 07:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD59C433EF;
        Wed, 14 Dec 2022 07:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671002076;
        bh=qbAihjpG0hqxnwg5/R/2utT9d69udoAMVXoe/KSOKQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oGZXL4b6UeK9ojKydvCv1Kv6v6M13Gy9/0AcckVUhV8OA37W4kRswwB17O8chCO1L
         6mdCzJTXSgiQxMlYzz5osJd2MtqPtxV4+8srqqz6gt+GUPO/CgDSVGMjRKRghjBcWd
         IInQNdzBY0zKwx7pkkbxRvzWMMydDy1hCX8UVTcVrAeo0dwwOEveIphAIkvnjpusOy
         XQqqmgl++J0GocBB/J222yJ7oX2fWUlYWr/dZPa5bK3DgeIFkF+gXsEevr6ANJElEW
         d5v1edCXpfXH07JvlUgeDwM3FQOlLctgYPab7QajcajVhs8m6RHRSuhzmIZk7VZb99
         fU7MgZKpBdCuw==
Date:   Wed, 14 Dec 2022 09:14:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     weiyongjun1@huawei.com, davem@davemloft.net, edumazet@google.com,
        f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net v2] r6040: Fix kmemleak in probe and remove
Message-ID: <Y5l312DJ4sSwBWUX@unreal>
References: <7f35ca55-cbed-98ac-4988-1b783db21dc5@huawei.com>
 <20221213125614.927754-1-lizetao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213125614.927754-1-lizetao1@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 08:56:14PM +0800, Li Zetao wrote:
> There is a memory leaks reported by kmemleak:
> 
>   unreferenced object 0xffff888116111000 (size 2048):
>     comm "modprobe", pid 817, jiffies 4294759745 (age 76.502s)
>     hex dump (first 32 bytes):
>       00 c4 0a 04 81 88 ff ff 08 10 11 16 81 88 ff ff  ................
>       08 10 11 16 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>     backtrace:
>       [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
>       [<ffffffff827e20ee>] phy_device_create+0x4e/0x90
>       [<ffffffff827e6072>] get_phy_device+0xd2/0x220
>       [<ffffffff827e7844>] mdiobus_scan+0xa4/0x2e0
>       [<ffffffff827e8be2>] __mdiobus_register+0x482/0x8b0
>       [<ffffffffa01f5d24>] r6040_init_one+0x714/0xd2c [r6040]
>       ...
> 
> The problem occurs in probe process as follows:
>   r6040_init_one:
>     mdiobus_register
>       mdiobus_scan    <- alloc and register phy_device,
>                          the reference count of phy_device is 3
>     r6040_mii_probe
>       phy_connect     <- connect to the first phy_device,
>                          so the reference count of the first
>                          phy_device is 4, others are 3
>     register_netdev   <- fault inject succeeded, goto error handling path
> 
>     // error handling path
>     err_out_mdio_unregister:
>       mdiobus_unregister(lp->mii_bus);
>     err_out_mdio:
>       mdiobus_free(lp->mii_bus);    <- the reference count of the first
>                                        phy_device is 1, it is not released
>                                        and other phy_devices are released
>   // similarly, the remove process also has the same problem
> 
> The root cause is traced to the phy_device is not disconnected when
> removes one r6040 device in r6040_remove_one() or on error handling path
> after r6040_mii probed successfully. In r6040_mii_probe(), a net ethernet
> device is connected to the first PHY device of mii_bus, in order to
> notify the connected driver when the link status changes, which is the
> default behavior of the PHY infrastructure to handle everything.
> Therefore the phy_device should be disconnected when removes one r6040
> device or on error handling path.
> 
> Fix it by adding phy_disconnect() when removes one r6040 device or on
> error handling path after r6040_mii probed successfully.
> 
> Fixes: 3831861b4ad8 ("r6040: implement phylib")
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
> v1 -> v2: change the subject prefix "PATCH" to "PATCH net" and change
> the goto label name "err_out_r6040_mii_remove" to "err_out_phy_disconnect"
> 
>  drivers/net/ethernet/rdc/r6040.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 

Please don't send new patches as reply-to.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
