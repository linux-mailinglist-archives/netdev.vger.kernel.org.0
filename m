Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51066D460C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjDCNon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjDCNon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:44:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0F91BE7;
        Mon,  3 Apr 2023 06:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33F62CE126C;
        Mon,  3 Apr 2023 13:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64182C4339B;
        Mon,  3 Apr 2023 13:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680529478;
        bh=TYSbpfoV3DmyAwlCsqDkGwFJ1tcoegJxpVI39cE6UOA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KiTqZQJjUdXfxAbYmdkmMHFsfhrpFcTRTnJun3EbozjZ4jv1N7fSqZfNKH35KGtP8
         Q+q2dsaSgBh3VhzLxqdYoG8QLwf0ZlGBN6w1FqImfMPw4K1O0hw3k0rM5ciksqWyzN
         bvidVEN77hK08lNcnocLDhrtj8a68DK0WNetsaU34NYuct59LaTCIJyP8J7GLfgWCn
         lmIN//P/SM8XIk0MZLVKESSag0+7MoQS5Ez3yNMRRpGDbUjhWDNOVgTCdzN+pzBj/P
         A/Efrcz8o6dHK4UqOkkLDHCdCabGC+h8U5NvGLby7zghgb6VjycaMmjIAgJBVOvzTB
         /q0tDhJ4zAc8w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rt2x00: Fix memory leak when handling surveys
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230330215637.4332-1-W_Armin@gmx.de>
References: <20230330215637.4332-1-W_Armin@gmx.de>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     stf_xl@wp.pl, helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168052947454.11825.87565460565328943.kvalo@kernel.org>
Date:   Mon,  3 Apr 2023 13:44:36 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Armin Wolf <W_Armin@gmx.de> wrote:

> When removing a rt2x00 device, its associated channel surveys
> are not freed, causing a memory leak observable with kmemleak:
> 
> unreferenced object 0xffff9620f0881a00 (size 512):
>   comm "systemd-udevd", pid 2290, jiffies 4294906974 (age 33.768s)
>   hex dump (first 32 bytes):
>     70 44 12 00 00 00 00 00 92 8a 00 00 00 00 00 00  pD..............
>     00 00 00 00 00 00 00 00 ab 87 01 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffffb0ed858b>] __kmalloc+0x4b/0x130
>     [<ffffffffc1b0f29b>] rt2800_probe_hw+0xc2b/0x1380 [rt2800lib]
>     [<ffffffffc1a9496e>] rt2800usb_probe_hw+0xe/0x60 [rt2800usb]
>     [<ffffffffc1ae491a>] rt2x00lib_probe_dev+0x21a/0x7d0 [rt2x00lib]
>     [<ffffffffc1b3b83e>] rt2x00usb_probe+0x1be/0x980 [rt2x00usb]
>     [<ffffffffc05981e2>] usb_probe_interface+0xe2/0x310 [usbcore]
>     [<ffffffffb13be2d5>] really_probe+0x1a5/0x410
>     [<ffffffffb13be5c8>] __driver_probe_device+0x78/0x180
>     [<ffffffffb13be6fe>] driver_probe_device+0x1e/0x90
>     [<ffffffffb13be972>] __driver_attach+0xd2/0x1c0
>     [<ffffffffb13bbc57>] bus_for_each_dev+0x77/0xd0
>     [<ffffffffb13bd2a2>] bus_add_driver+0x112/0x210
>     [<ffffffffb13bfc6c>] driver_register+0x5c/0x120
>     [<ffffffffc0596ae8>] usb_register_driver+0x88/0x150 [usbcore]
>     [<ffffffffb0c011c4>] do_one_initcall+0x44/0x220
>     [<ffffffffb0d6134c>] do_init_module+0x4c/0x220
> 
> Fix this by freeing the channel surveys on device removal.
> 
> Tested with a RT3070 based USB wireless adapter.
> 
> Fixes: 5447626910f5 ("rt2x00: save survey for every channel visited")
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-next.git, thanks.

cbef9a83c51d wifi: rt2x00: Fix memory leak when handling surveys

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230330215637.4332-1-W_Armin@gmx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

