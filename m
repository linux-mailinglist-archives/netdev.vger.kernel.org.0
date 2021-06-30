Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98573B8089
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 12:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhF3KGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 06:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbhF3KGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 06:06:20 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABB1C061766
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 03:03:51 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id l68so1316086vsc.13
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 03:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQ8w6GsN05322Cp5xiff2OqrAS1Uq1JUpp0VzCYRiqQ=;
        b=v/st+ruvXovNFjiOUybQSZEwm8aliOS8F10G093+IRFjuDAadgNjroQHZutTjgg9Z6
         NZrtAoT4vcgk8WT1t89hiwnMeyZGEutFmyWiJd7/DB6ouFAt+zUR7vvbkdYyV9bsH/Nn
         sXypgcJFFTN0T1LlKNwWFVS0PBuu49nzHp7juQPd5BzJUiZ+QjlO8EdD4nwCAuN4XqNy
         REMiMlbd8CUSzKcgXt5xiqZFfFnUc0YXCTSgKGD2ty11RXtMPMxwtlUb29QImjZJpGTe
         GoeIdUDSC9mCz0bWtck+xnxS+YVu4aQ5SF/rVVAjiCsL4GT1za9M4y+etXF7Uhsufa32
         cwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQ8w6GsN05322Cp5xiff2OqrAS1Uq1JUpp0VzCYRiqQ=;
        b=Venpps5t3n0jvZ0N646mVm/zrklMoNewTCQgaYKh+WFBwWXlp9Tevb6tdkPfyMASXN
         gSieK9lyAGwxqiimGeluXQKw/z+7da3MGat0E9OIHh0Htvz1dlib2wKEaF0T7gLGdWGI
         SS4NelFfcdkordujKV34ALeIAqCQn/OD7LbjZyILcnQTmFhEMnBdU3HdJMJOfmNvGiiJ
         11vlI47MIs3gou0zFjYa++Bmpl3hLZ9F7yPkzXpnXod10c+dZD0WMgysqHPOyjblqbPP
         E/JPdz11avTsNhwVjQIPXuz3bdZ+whAOBc2FOPP4TCL2BUAspBibLYd18Z949GkCqPpd
         OqQA==
X-Gm-Message-State: AOAM532VT8cYzgHvFtC0n1AMzjXy480m85fwYzn84YB5Sco0bUbtQ2sI
        ulhjhJz++v6cCViT8aRwLgatmkWTv1DjndmwIvEa5Q==
X-Google-Smtp-Source: ABdhPJy8/Kr8/BB05B2jOlxNSoq/iS7lQFd+tjs21sJnNBIgdlGOfg/KO+6ZjjYYAptdivo6nHgkcxxpshu5i2mCA1E=
X-Received: by 2002:a05:6102:3a70:: with SMTP id bf16mr30808168vsb.48.1625047430169;
 Wed, 30 Jun 2021 03:03:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210622202345.795578-1-jernej.skrabec@gmail.com>
In-Reply-To: <20210622202345.795578-1-jernej.skrabec@gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 30 Jun 2021 12:03:13 +0200
Message-ID: <CAPDyKFo6AVGq5Q9bRKPjypRMxisLf0nZWLtSeARGO-3kO7=+zQ@mail.gmail.com>
Subject: Re: [RFC PATCH] cw1200: use kmalloc() allocation instead of stack
To:     Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     pizza@shaftnet.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 at 22:23, Jernej Skrabec <jernej.skrabec@gmail.com> wrote:
>
> It turns out that if CONFIG_VMAP_STACK is enabled and src or dst is
> memory allocated on stack, SDIO operations fail due to invalid memory
> address conversion:
>
> cw1200_wlan_sdio: Probe called
> sunxi-mmc 4021000.mmc: DMA addr 0x0000800051eab954+4 overflow (mask ffffffff, bus limit 0).
> WARNING: CPU: 2 PID: 152 at kernel/dma/direct.h:97 dma_direct_map_sg+0x26c/0x28c
> CPU: 2 PID: 152 Comm: kworker/2:2 Not tainted 5.13.0-rc1-00026-g84114ef026b9-dirty #85
> Hardware name: X96 Mate (DT)
> Workqueue: events_freezable mmc_rescan
> pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> pc : dma_direct_map_sg+0x26c/0x28c
> lr : dma_direct_map_sg+0x26c/0x28c
> sp : ffff800011eab540
> x29: ffff800011eab540 x28: ffff800011eab738 x27: 0000000000000000
> x26: ffff000001daf010 x25: 0000000000000000 x24: 0000000000000000
> x23: 0000000000000002 x22: fffffc0000000000 x21: ffff8000113b0ab0
> x20: ffff80001181abb0 x19: 0000000000000001 x18: ffffffffffffffff
> x17: 00000000fa97f83f x16: 00000000d2e01bf8 x15: ffff8000117ffb1d
> x14: ffffffffffffffff x13: ffff8000117ffb18 x12: fffffffffffc593f
> x11: ffff800011676ad0 x10: fffffffffffe0000 x9 : ffff800011eab540
> x8 : 206b73616d282077 x7 : 000000000000000f x6 : 000000000000000c
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00000283b800
> Call trace:
>  dma_direct_map_sg+0x26c/0x28c
>  dma_map_sg_attrs+0x2c/0x60
>  sunxi_mmc_request+0x70/0x420
>  __mmc_start_request+0x68/0x134
>  mmc_start_request+0x84/0xac
>  mmc_wait_for_req+0x70/0x100
>  mmc_io_rw_extended+0x1cc/0x2c0
>  sdio_io_rw_ext_helper+0x194/0x240
>  sdio_memcpy_fromio+0x20/0x2c
>  cw1200_sdio_memcpy_fromio+0x20/0x2c
>  __cw1200_reg_read+0x34/0x60
>  cw1200_reg_read+0x48/0x70
>  cw1200_load_firmware+0x38/0x5d0
>  cw1200_core_probe+0x794/0x970
>  cw1200_sdio_probe+0x124/0x22c
>  sdio_bus_probe+0xe8/0x1d0
>  really_probe+0xe4/0x504
>  driver_probe_device+0x64/0xcc
>  __device_attach_driver+0xd0/0x14c
>  bus_for_each_drv+0x78/0xd0
>  __device_attach+0xdc/0x184
>  device_initial_probe+0x14/0x20
>  bus_probe_device+0x9c/0xa4
>  device_add+0x350/0x83c
>  sdio_add_func+0x6c/0x90
>  mmc_attach_sdio+0x1b0/0x430
>  mmc_rescan+0x254/0x2e0
>  process_one_work+0x1d0/0x34c
>  worker_thread+0x13c/0x470
>  kthread+0x154/0x160
>  ret_from_fork+0x10/0x34
> sunxi-mmc 4021000.mmc: dma_map_sg failed
> sunxi-mmc 4021000.mmc: map DMA failed
> Can't read config register.
>
> Fix that by using kmalloc() allocated memory for read/write 16/32
> funtions.
>
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  drivers/net/wireless/st/cw1200/hwio.c | 52 +++++++++++++++++++++------
>  drivers/net/wireless/st/cw1200/hwio.h | 51 ++++++++++++++++++++------
>  2 files changed, 83 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/wireless/st/cw1200/hwio.c b/drivers/net/wireless/st/cw1200/hwio.c
> index 3ba462de8e91..5521cb7f2233 100644
> --- a/drivers/net/wireless/st/cw1200/hwio.c
> +++ b/drivers/net/wireless/st/cw1200/hwio.c
> @@ -66,33 +66,65 @@ static int __cw1200_reg_write(struct cw1200_common *priv, u16 addr,
>  static inline int __cw1200_reg_read_32(struct cw1200_common *priv,
>                                         u16 addr, u32 *val)
>  {
> -       __le32 tmp;
> -       int i = __cw1200_reg_read(priv, addr, &tmp, sizeof(tmp), 0);
> -       *val = le32_to_cpu(tmp);
> +       __le32 *tmp;
> +       int i;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       i = __cw1200_reg_read(priv, addr, tmp, sizeof(*tmp), 0);
> +       *val = le32_to_cpu(*tmp);
> +       kfree(tmp);
>         return i;
>  }
>
>  static inline int __cw1200_reg_write_32(struct cw1200_common *priv,
>                                         u16 addr, u32 val)
>  {
> -       __le32 tmp = cpu_to_le32(val);
> -       return __cw1200_reg_write(priv, addr, &tmp, sizeof(tmp), 0);
> +       __le32 *tmp;
> +       int i;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       *tmp = cpu_to_le32(val);
> +       i = __cw1200_reg_write(priv, addr, tmp, sizeof(*tmp), 0);
> +       kfree(tmp);
> +       return i;
>  }
>
>  static inline int __cw1200_reg_read_16(struct cw1200_common *priv,
>                                         u16 addr, u16 *val)
>  {
> -       __le16 tmp;
> -       int i = __cw1200_reg_read(priv, addr, &tmp, sizeof(tmp), 0);
> -       *val = le16_to_cpu(tmp);
> +       __le16 *tmp;
> +       int i;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       i = __cw1200_reg_read(priv, addr, tmp, sizeof(*tmp), 0);
> +       *val = le16_to_cpu(*tmp);
> +       kfree(tmp);
>         return i;
>  }
>
>  static inline int __cw1200_reg_write_16(struct cw1200_common *priv,
>                                         u16 addr, u16 val)
>  {
> -       __le16 tmp = cpu_to_le16(val);
> -       return __cw1200_reg_write(priv, addr, &tmp, sizeof(tmp), 0);
> +       __le16 *tmp;
> +       int i;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       *tmp = cpu_to_le16(val);
> +       i = __cw1200_reg_write(priv, addr, tmp, sizeof(*tmp), 0);
> +       kfree(tmp);
> +       return i;
>  }
>
>  int cw1200_reg_read(struct cw1200_common *priv, u16 addr, void *buf,
> diff --git a/drivers/net/wireless/st/cw1200/hwio.h b/drivers/net/wireless/st/cw1200/hwio.h
> index d1e629a566c2..088d2a1bacc0 100644
> --- a/drivers/net/wireless/st/cw1200/hwio.h
> +++ b/drivers/net/wireless/st/cw1200/hwio.h
> @@ -166,34 +166,65 @@ int cw1200_reg_write(struct cw1200_common *priv, u16 addr,
>  static inline int cw1200_reg_read_16(struct cw1200_common *priv,
>                                      u16 addr, u16 *val)
>  {
> -       __le32 tmp;
> +       __le32 *tmp;
>         int i;
> -       i = cw1200_reg_read(priv, addr, &tmp, sizeof(tmp));
> -       *val = le32_to_cpu(tmp) & 0xfffff;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       i = cw1200_reg_read(priv, addr, tmp, sizeof(*tmp));
> +       *val = le32_to_cpu(*tmp) & 0xfffff;
> +       kfree(tmp);
>         return i;
>  }
>
>  static inline int cw1200_reg_write_16(struct cw1200_common *priv,
>                                       u16 addr, u16 val)
>  {
> -       __le32 tmp = cpu_to_le32((u32)val);
> -       return cw1200_reg_write(priv, addr, &tmp, sizeof(tmp));
> +       __le32 *tmp;
> +       int i;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       *tmp = cpu_to_le32((u32)val);
> +       i = cw1200_reg_write(priv, addr, tmp, sizeof(*tmp));
> +       kfree(tmp);
> +       return i;
>  }
>
>  static inline int cw1200_reg_read_32(struct cw1200_common *priv,
>                                      u16 addr, u32 *val)
>  {
> -       __le32 tmp;
> -       int i = cw1200_reg_read(priv, addr, &tmp, sizeof(tmp));
> -       *val = le32_to_cpu(tmp);
> +       __le32 *tmp;
> +       int i;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       i = cw1200_reg_read(priv, addr, tmp, sizeof(*tmp));
> +       *val = le32_to_cpu(*tmp);
> +       kfree(tmp);
>         return i;
>  }
>
>  static inline int cw1200_reg_write_32(struct cw1200_common *priv,
>                                       u16 addr, u32 val)
>  {
> -       __le32 tmp = cpu_to_le32(val);
> -       return cw1200_reg_write(priv, addr, &tmp, sizeof(val));
> +       __le32 *tmp;
> +       int i;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       *tmp = cpu_to_le32(val);
> +       i = cw1200_reg_write(priv, addr, tmp, sizeof(val));
> +       kfree(tmp);
> +       return i;
>  }
>
>  int cw1200_indirect_read(struct cw1200_common *priv, u32 addr, void *buf,
> --
> 2.32.0
>
