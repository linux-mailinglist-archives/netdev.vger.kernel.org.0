Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8186D3B8190
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhF3MDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbhF3MDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:03:08 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67F8C061766
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:00:39 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id e20so914648ual.9
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OL62kdeYlXXEkJ1aGiG1sjEtSE7mW2mdMPPQqqcuIxw=;
        b=GtN/V1W+K3av9LYjLhNVlep99YK92iS+jO2WMN8irtiCujY9UbyESKBImCEyFTSvc2
         N/9kKpJ5Z+idVw51QclrK/S5v1hCC+YMWrdzDB+c/lgknEujK3RXZBuGL2K6Em+2sqkx
         hxjQviWx+yPjVjCVldw1zZJoVV+d5AkCzmz2RTozHwBeCsaULN3297BL+DYks+cQfrh2
         9HZnbbVSRylm+ZHYs7oRA6vupGOXGooPD6JOXo+6QCA61Ba3OPW5fUbdZauH3tDOguww
         o6Pw9oJ1e1lLB2Na4xHqvXCTbrM4ytKW/XS3fMvB9rQPreyl+INmjhFLLFQeCLHv6fRc
         21Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OL62kdeYlXXEkJ1aGiG1sjEtSE7mW2mdMPPQqqcuIxw=;
        b=slcbCOYjwyal0EusxmJBbi7DlTlIFnPHBqRgvPdhb0HtZxbfDu/mR6CH+yZLIn3+g6
         Od1DHDGpO7CP3k5b26cZKrUrRU1ltZQ+x1jpC08wG/1LLLBnYaVjWJUMeIuZD2cMxz1S
         WL2idWZwnqUT9PUHM9PQ6NBoIxBlU/jXw+WeR3j2XgmZXZ+9cKH5ZRzNFVlauj++ktBv
         II1V16C7Zv9LHEDRzUi53K0It7xnTys4Ze2gA1VrprzzAjXzbrT+RhpBoDmMVA2NZA1d
         SpIbxUMrAYLgnGNqUP2uK4eUEo1arTxVWzmSygvJPAtlbFEG+IG1Gbt3aHImg2DgXdkP
         CBJQ==
X-Gm-Message-State: AOAM53161I9FbQRyDgFJ0HibX4L65BhNvET/XQ4gFGMfzW8efHUbV5RC
        eEA/mKlGlT6p/eCxv4xiUpCQ3DEm6zTlcWV2Sl+/iA==
X-Google-Smtp-Source: ABdhPJwPGDieMZ+5r43/zWQZ3F64qB/ndaTGdMjbvOXP3BoBFkByykdSNBN4/vPRb1ScCDMM5gnwhSzc1EUNmu10tcw=
X-Received: by 2002:ab0:484b:: with SMTP id c11mr32650086uad.100.1625054439072;
 Wed, 30 Jun 2021 05:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210622202345.795578-1-jernej.skrabec@gmail.com>
 <CAPDyKFo6AVGq5Q9bRKPjypRMxisLf0nZWLtSeARGO-3kO7=+zQ@mail.gmail.com> <2049952.mNMznikF6L@jernej-laptop>
In-Reply-To: <2049952.mNMznikF6L@jernej-laptop>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 30 Jun 2021 14:00:02 +0200
Message-ID: <CAPDyKFrr3eUAXgdkWVF1nYBL8A73TkzUyqhLUZOSyGe0ebDKuw@mail.gmail.com>
Subject: Re: [RFC PATCH] cw1200: use kmalloc() allocation instead of stack
To:     =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     pizza@shaftnet.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Jun 2021 at 12:09, Jernej =C5=A0krabec <jernej.skrabec@gmail.com=
> wrote:
>
> Hi Ulf!
>
> Dne sreda, 30. junij 2021 ob 12:03:13 CEST je Ulf Hansson napisal(a):
> > On Tue, 22 Jun 2021 at 22:23, Jernej Skrabec <jernej.skrabec@gmail.com>
> wrote:
> > > It turns out that if CONFIG_VMAP_STACK is enabled and src or dst is
> > > memory allocated on stack, SDIO operations fail due to invalid memory
> > > address conversion:
> > >
> > > cw1200_wlan_sdio: Probe called
> > > sunxi-mmc 4021000.mmc: DMA addr 0x0000800051eab954+4 overflow (mask
> > > ffffffff, bus limit 0). WARNING: CPU: 2 PID: 152 at
> > > kernel/dma/direct.h:97 dma_direct_map_sg+0x26c/0x28c CPU: 2 PID: 152
> > > Comm: kworker/2:2 Not tainted 5.13.0-rc1-00026-g84114ef026b9-dirty #8=
5
> > > Hardware name: X96 Mate (DT)
> > > Workqueue: events_freezable mmc_rescan
> > > pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
> > > pc : dma_direct_map_sg+0x26c/0x28c
> > > lr : dma_direct_map_sg+0x26c/0x28c
> > > sp : ffff800011eab540
> > > x29: ffff800011eab540 x28: ffff800011eab738 x27: 0000000000000000
> > > x26: ffff000001daf010 x25: 0000000000000000 x24: 0000000000000000
> > > x23: 0000000000000002 x22: fffffc0000000000 x21: ffff8000113b0ab0
> > > x20: ffff80001181abb0 x19: 0000000000000001 x18: ffffffffffffffff
> > > x17: 00000000fa97f83f x16: 00000000d2e01bf8 x15: ffff8000117ffb1d
> > > x14: ffffffffffffffff x13: ffff8000117ffb18 x12: fffffffffffc593f
> > > x11: ffff800011676ad0 x10: fffffffffffe0000 x9 : ffff800011eab540
> > > x8 : 206b73616d282077 x7 : 000000000000000f x6 : 000000000000000c
> > > x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
> > > x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00000283b800
> > >
> > > Call trace:
> > >  dma_direct_map_sg+0x26c/0x28c
> > >  dma_map_sg_attrs+0x2c/0x60
> > >  sunxi_mmc_request+0x70/0x420
> > >  __mmc_start_request+0x68/0x134
> > >  mmc_start_request+0x84/0xac
> > >  mmc_wait_for_req+0x70/0x100
> > >  mmc_io_rw_extended+0x1cc/0x2c0
> > >  sdio_io_rw_ext_helper+0x194/0x240
> > >  sdio_memcpy_fromio+0x20/0x2c
> > >  cw1200_sdio_memcpy_fromio+0x20/0x2c
> > >  __cw1200_reg_read+0x34/0x60
> > >  cw1200_reg_read+0x48/0x70
> > >  cw1200_load_firmware+0x38/0x5d0
> > >  cw1200_core_probe+0x794/0x970
> > >  cw1200_sdio_probe+0x124/0x22c
> > >  sdio_bus_probe+0xe8/0x1d0
> > >  really_probe+0xe4/0x504
> > >  driver_probe_device+0x64/0xcc
> > >  __device_attach_driver+0xd0/0x14c
> > >  bus_for_each_drv+0x78/0xd0
> > >  __device_attach+0xdc/0x184
> > >  device_initial_probe+0x14/0x20
> > >  bus_probe_device+0x9c/0xa4
> > >  device_add+0x350/0x83c
> > >  sdio_add_func+0x6c/0x90
> > >  mmc_attach_sdio+0x1b0/0x430
> > >  mmc_rescan+0x254/0x2e0
> > >  process_one_work+0x1d0/0x34c
> > >  worker_thread+0x13c/0x470
> > >  kthread+0x154/0x160
> > >  ret_from_fork+0x10/0x34
> > >
> > > sunxi-mmc 4021000.mmc: dma_map_sg failed
> > > sunxi-mmc 4021000.mmc: map DMA failed
> > > Can't read config register.
> > >
> > > Fix that by using kmalloc() allocated memory for read/write 16/32
> > > funtions.
> > >
> > > Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> >
> > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> Thanks! But I found few more places which need this kind of fix:
> https://github.com/jernejsk/linux-1/commit/
> 1cba9a7764c7d5bbdeb4ddeaa91ff20a0339f6ff

I couldn't find it.

>
> I guess I can keep R-b tag?

Well, just send a new version and I will respond to it again, no
worries. Or send an additional one on top.

[...]

Kind regards
Uffe
