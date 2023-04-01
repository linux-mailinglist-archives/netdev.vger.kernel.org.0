Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A76D2FC1
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 12:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjDAKy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 06:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDAKy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 06:54:26 -0400
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 01 Apr 2023 03:54:25 PDT
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F5DA5E8
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 03:54:24 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 8697 invoked from network); 1 Apr 2023 12:47:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1680346059; bh=iyZoPySXOOxOaO748N2MsJyH964xIOQPpVIusQutvT4=;
          h=From:To:Cc:Subject;
          b=OFI90b0aVTbz/MtTgf1vdbCWxoaJIG/4Rd4Dg9i0yAoW+7bbtcEjZ4k11uyBLFyZF
           HQHDxcD2V6XLJxEkfHcAVAv7Q1RaUrbdkxNZqUpddQO1hNpTLhTXNYQkoY5yqvl3g5
           d+dwkjSLOiwzF6kIBmoZrXsVOINJeuyw8cClonEY=
Received: from 89-64-1-145.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.1.145])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <W_Armin@gmx.de>; 1 Apr 2023 12:47:39 +0200
Date:   Sat, 1 Apr 2023 12:47:38 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     helmut.schaa@googlemail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rt2x00: Fix memory leak when handling surveys
Message-ID: <20230401104738.GA104104@wp.pl>
References: <20230330215637.4332-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330215637.4332-1-W_Armin@gmx.de>
X-WP-MailID: 3e9d8f7d9636ccf6fd6f75025492a895
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [0VMB]                               
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:56:37PM +0200, Armin Wolf wrote:
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
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
