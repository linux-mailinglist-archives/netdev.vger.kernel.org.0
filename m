Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BD5638E62
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 17:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiKYQmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 11:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiKYQmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 11:42:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85084D5EA;
        Fri, 25 Nov 2022 08:42:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62C776255D;
        Fri, 25 Nov 2022 16:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15AEC433D6;
        Fri, 25 Nov 2022 16:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669394532;
        bh=cXOYXyJuPrfJrkAyAmbhQbTTRuiswKOABS8Fpu+d/dY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QCcjC8BnlkJyJw7RmfhJ22ERbCIhItbs9MH4Tw9g7+JRZrVlQziDIc2/j+bEdS3Ag
         HPsEcedTuSjYr5wRi4MYs9bWBQPfTJPknLI9MrW1pj90TMev1Xf7ftA0yUZhV7V6+4
         ykev9c3tv5kr/MqiaPtNEI8B4dak6ZkUEHaKzIEz1IZsLyzYgp1lZEBXec8/9VqyPd
         cMISQwRDw/1Gtz6pFj0rafz/GwDXJPhFGmjX9fEoBqGtYfmpF1u5TV1KgmE86RI4bj
         Ls99kLwjSd6lXZc4PeqCQMbs7e7EbbU6RTazFypU7RLcMA+Zi3mUSauI80GYBLPIt0
         juqHOgkG8xrPw==
From:   Kalle Valo <kvalo@kernel.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <zhangxiaoxu5@huawei.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH wireless] wifi: wilc1000: Fix UAF in wilc_netdev_cleanup() when iterator the RCU list
References: <20221124151349.2386077-1-zhangxiaoxu5@huawei.com>
        <a6d8f548-bcf4-4a02-df25-3a06aa8f2b42@microchip.com>
Date:   Fri, 25 Nov 2022 18:42:05 +0200
In-Reply-To: <a6d8f548-bcf4-4a02-df25-3a06aa8f2b42@microchip.com> (Ajay
        Kathat's message of "Fri, 25 Nov 2022 16:17:16 +0000")
Message-ID: <877czj6l5u.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<Ajay.Kathat@microchip.com> writes:

> On 24/11/22 20:43, Zhang Xiaoxu wrote:
>
>  EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>  content is safe
>
> There is a UAF read when remove the wilc1000_spi module:
>
>  BUG: KASAN: use-after-free in wilc_netdev_cleanup.cold+0xc4/0xe0 [wilc1000]
>  Read of size 8 at addr ffff888116846900 by task rmmod/386
>
>  CPU: 2 PID: 386 Comm: rmmod Tainted: G                 N 6.1.0-rc6+ #8
>  Call Trace:
>   dump_stack_lvl+0x68/0x85
>   print_report+0x16c/0x4a3
>   kasan_report+0x95/0x190
>   wilc_netdev_cleanup.cold+0xc4/0xe0
>   wilc_bus_remove+0x52/0x60
>   spi_remove+0x46/0x60
>   device_remove+0x73/0xc0
>   device_release_driver_internal+0x12d/0x210
>   driver_detach+0x84/0x100
>   bus_remove_driver+0x90/0x120
>   driver_unregister+0x4f/0x80
>   __x64_sys_delete_module+0x2fc/0x440
>   do_syscall_64+0x38/0x90
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Since set 'needs_free_netdev=true' when initialize the net device, the
> net device will be freed when unregister, then use the freed 'vif' to
> find the next will UAF read.
>
> Did you test this behaviour on the real device. I am seeing a kernel
> crash when the module is unloaded after the connection with an AP. As
> I see, "vif_list" is used to maintain the interface list, so even when
> one interface is removed, another element is fetched from the
> "vif_list", not using the freed "vif"

Ajay, please don't use HTML as our lists drop those.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
