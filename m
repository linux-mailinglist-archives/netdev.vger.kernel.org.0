Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E6E6544CF
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiLVQHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiLVQGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659712EF9C;
        Thu, 22 Dec 2022 08:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F380B61C64;
        Thu, 22 Dec 2022 16:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF55C433D2;
        Thu, 22 Dec 2022 16:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671725196;
        bh=0USea89QOgP5P0vWOkZBXMBCUlUL4MSuUYBcVLH6R+s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WuGr36sEexaxrPCLWiw1BaUmcD9OhpGd0EeD0FuTjUbMRDRSRVcuJb7j+jHLvGLDf
         xytuAWeydJWUvArVwmGwOHhdQy/4R8Igjt42r4s6blk/OOX8I9icH9fWlsSZRhhvMw
         VE1O4Ej3aDdh756qGUWm53zEubF1w7hlct5baV8DtrdwcpkPyHNZwiS+JjXUFBRgQP
         j9vyPoS9hE8YricLS5BGXJL503Zk+CGIG36s2+gL2155bhlBC6weJ/TBeHRHYijr/O
         rLToWkOoD1jbWutl8L16u+XIwMCRlvoOLl4AXVnUjlEKx0YwwpnyFOE8l0WvNblXSQ
         AnaJ7OLzzXFCw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [wireless] wifi: wilc1000: add missing unregister_netdev() in
 wilc_netdev_ifc_init()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1669289902-23639-1-git-send-email-wangyufen@huawei.com>
References: <1669289902-23639-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     <ajay.kathat@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <davidm@egauge.net>, <wangyufen@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167172519205.8231.13844478076238489383.kvalo@kernel.org>
Date:   Thu, 22 Dec 2022 16:06:33 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen <wangyufen@huawei.com> wrote:

> Fault injection test reports this issue:
> 
> kernel BUG at net/core/dev.c:10731!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> Call Trace:
>   <TASK>
>   wilc_netdev_ifc_init+0x19f/0x220 [wilc1000 884bf126e9e98af6a708f266a8dffd53f99e4bf5]
>   wilc_cfg80211_init+0x30c/0x380 [wilc1000 884bf126e9e98af6a708f266a8dffd53f99e4bf5]
>   wilc_bus_probe+0xad/0x2b0 [wilc1000_spi 1520a7539b6589cc6cde2ae826a523a33f8bacff]
>   spi_probe+0xe4/0x140
>   really_probe+0x17e/0x3f0
>   __driver_probe_device+0xe3/0x170
>   driver_probe_device+0x49/0x120
> 
> The root case here is alloc_ordered_workqueue() fails, but
> cfg80211_unregister_netdevice() or unregister_netdev() not be called in
> error handling path. To fix add unregister_netdev goto lable to add the
> unregister operation in error handling path.
> 
> Fixes: 09ed8bfc5215 ("wilc1000: Rename workqueue from "WILC_wq" to "NETDEV-wq"")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>

Patch applied to wireless-next.git, thanks.

2b88974ecb35 wifi: wilc1000: add missing unregister_netdev() in wilc_netdev_ifc_init()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1669289902-23639-1-git-send-email-wangyufen@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

