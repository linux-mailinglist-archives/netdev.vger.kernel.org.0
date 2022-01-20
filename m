Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768D4494B85
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 11:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359789AbiATKRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 05:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbiATKRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 05:17:51 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D28C061574;
        Thu, 20 Jan 2022 02:17:51 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z22so26358959edd.12;
        Thu, 20 Jan 2022 02:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XbODNS9XEhmUfohkhajirJdUYNQqugPduP6DonKUI5w=;
        b=EzcnhaVtltbVQPBaXs8ujGRh/zCo/6ET1mF8tDvNfG8GUyqihtsRZL9DFlESwnvA31
         kaV3BIUB+sTN/6t/bDDGSXp1nKmEEV10fPm+8kVMlBLLeJ8SvomzsEZe/1fL84n/w/ES
         iNudYzadcn8JmeDILZGdsEECazNPw+76QpvDaZo/NvsGLlu9lCdPZ++vrtFiSV3KTqfS
         u/t/kj81cO3kf5aaEFVskAAm+uXTj6jfUnKyKuE+2z+cRZSzYl4keaTAXufTutKIZKam
         WrChnoiwLTms4/sT+pZGhfawZJmIPuJNf+lg4TetPC4ZcfYh11CEXvYnT8338RZ1SskK
         KRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XbODNS9XEhmUfohkhajirJdUYNQqugPduP6DonKUI5w=;
        b=ZC/uUslMFQIkniu6sg8ocyj+kCNw3sPuFWQF9gdJ3rzfXb6A3ytjGutQId+0fEU4Fb
         M+rLzlTtWWVN+nSDFle0i4uGWj0GdwAtbUy8IsxrRMJNhBlmXxavaiTKoe6ve5qHiXkM
         YgxJksr4EcwtoLBIlofI6JQuD/1GJZxNVIpwgHLxDiQnuwCdQ6IkuLqYnm87ZPhWPlGy
         0lF3Ck8QrvF7mtvq9sTiV5CSE2GLvQKUUVQyUBxmU2PvJQDoC8zsnLv06reoJm1aULDg
         17ASy7dmpyv/7+i1MpGzbGkU2hOQC/Tf8E80EqTa+0OcLdpfZTasfdVLEiGTHxseCKJf
         FkCQ==
X-Gm-Message-State: AOAM532awdM9Io+zyS52N29CKEz0KYhw6oaFk7UYiAjHoz/GQlFoaT3h
        hJ/wQcShLFLo7Sx1DnvWWHlUzx2b9KlsF3NpZ9I=
X-Google-Smtp-Source: ABdhPJzWErHT8YD9est7t4xyOmagkSNGhr8dJfu/I4Onv6sPoskHczjD8X0NDCVE/6muCCalsMuIKiP/VBADkzkViMM=
X-Received: by 2002:a50:c388:: with SMTP id h8mr29341796edf.218.1642673869829;
 Thu, 20 Jan 2022 02:17:49 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st> <20220117142919.207370-6-marcan@marcan.st>
In-Reply-To: <20220117142919.207370-6-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 20 Jan 2022 12:17:13 +0200
Message-ID: <CAHp75Vf+xcn7SJX3RaeDJC2gK0xWVgwMQ33n_988PkDcTp4LpA@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev
 with memcpy_toio
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 4:31 PM Hector Martin <marcan@marcan.st> wrote:
>
> The alignment check was wrong (e.g. & 4 instead of & 3), and the logic
> was also inefficient if the length was not a multiple of 4, since it
> would needlessly fall back to copying the entire buffer bytewise.
>
> We already have a perfectly good memcpy_toio function, so just call that
> instead of rolling our own copy logic here. brcmf_pcie_init_ringbuffers
> was already using it anyway.

My gosh, what a nice fix!
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../broadcom/brcm80211/brcmfmac/pcie.c        | 48 ++-----------------
>  1 file changed, 4 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index b1ae6c41013f..c25f48db1f60 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -12,6 +12,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/bcma/bcma.h>
>  #include <linux/sched.h>
> +#include <linux/io.h>
>  #include <asm/unaligned.h>
>
>  #include <soc.h>
> @@ -454,47 +455,6 @@ brcmf_pcie_write_ram32(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
>  }
>
>
> -static void
> -brcmf_pcie_copy_mem_todev(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
> -                         void *srcaddr, u32 len)
> -{
> -       void __iomem *address = devinfo->tcm + mem_offset;
> -       __le32 *src32;
> -       __le16 *src16;
> -       u8 *src8;
> -
> -       if (((ulong)address & 4) || ((ulong)srcaddr & 4) || (len & 4)) {
> -               if (((ulong)address & 2) || ((ulong)srcaddr & 2) || (len & 2)) {
> -                       src8 = (u8 *)srcaddr;
> -                       while (len) {
> -                               iowrite8(*src8, address);
> -                               address++;
> -                               src8++;
> -                               len--;
> -                       }
> -               } else {
> -                       len = len / 2;
> -                       src16 = (__le16 *)srcaddr;
> -                       while (len) {
> -                               iowrite16(le16_to_cpu(*src16), address);
> -                               address += 2;
> -                               src16++;
> -                               len--;
> -                       }
> -               }
> -       } else {
> -               len = len / 4;
> -               src32 = (__le32 *)srcaddr;
> -               while (len) {
> -                       iowrite32(le32_to_cpu(*src32), address);
> -                       address += 4;
> -                       src32++;
> -                       len--;
> -               }
> -       }
> -}
> -
> -
>  static void
>  brcmf_pcie_copy_dev_tomem(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
>                           void *dstaddr, u32 len)
> @@ -1570,8 +1530,8 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
>                 return err;
>
>         brcmf_dbg(PCIE, "Download FW %s\n", devinfo->fw_name);
> -       brcmf_pcie_copy_mem_todev(devinfo, devinfo->ci->rambase,
> -                                 (void *)fw->data, fw->size);
> +       memcpy_toio(devinfo->tcm + devinfo->ci->rambase,
> +                   (void *)fw->data, fw->size);
>
>         resetintr = get_unaligned_le32(fw->data);
>         release_firmware(fw);
> @@ -1585,7 +1545,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
>                 brcmf_dbg(PCIE, "Download NVRAM %s\n", devinfo->nvram_name);
>                 address = devinfo->ci->rambase + devinfo->ci->ramsize -
>                           nvram_len;
> -               brcmf_pcie_copy_mem_todev(devinfo, address, nvram, nvram_len);
> +               memcpy_toio(devinfo->tcm + address, nvram, nvram_len);
>                 brcmf_fw_nvram_free(nvram);
>         } else {
>                 brcmf_dbg(PCIE, "No matching NVRAM file found %s\n",
> --
> 2.33.0
>


-- 
With Best Regards,
Andy Shevchenko
