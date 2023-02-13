Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AB1694D2B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBMQpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjBMQpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:45:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AA21043E
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676306692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UiVeaxLirFDaFY10rNqkG8tSY2t/6xI0UAG3XTfGb3c=;
        b=UdB0bfo0eB9gqsvVamBol24qMJOYcJw3O19aee8bz5P/GbxMwUSb3GhJhNBOUxK/e51Sp6
        LCokAgaSU+HsEo6T53DfFfaPlpmb6iCVjNqJlhSpZT0ayV5SIm8EOj8BpEwCp5mzqQeAYX
        mIzazcJ5dOQibGV5RxOF2mWVR+J8OPU=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-D34OS55INcKYAy3VWnNyrA-1; Mon, 13 Feb 2023 11:44:50 -0500
X-MC-Unique: D34OS55INcKYAy3VWnNyrA-1
Received: by mail-vs1-f69.google.com with SMTP id y19-20020a0561020c5300b003fe36c5c1d7so2708167vss.18
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676306690;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UiVeaxLirFDaFY10rNqkG8tSY2t/6xI0UAG3XTfGb3c=;
        b=NSw9WEtkLS9HmgnHw1xhd9hQXf2/qkAFIGENcyxeq0Y4y+NJXQ57DimjFJeKMJH4N3
         jntjqdQUYfBm3PZfYYCVEsDGNs+cxsiPCR4YveAghptsEEwFskkxdMO6bKxkZGyqZyp8
         xhT849LzxtxV5KoSRz3N9N3/HShm1oGOXDljQ0Y7a7kfodO5WRJCKybzLjhqmRTqk01E
         1GFiJZUJYVIJ2VF+LcLG2mLxFyHfShMi9rhUswNZmC928E3svaLFWkuDr1ICxZ4p5wiQ
         6VrqW2/BZ6taMEKWm9TVhSlFxP2IJ6xhrAj6Xlo9jRml2si8Ma/WS1vZg41d1hfINzL3
         7Xmw==
X-Gm-Message-State: AO0yUKX2pN6rUfOAiIRDnZGAm5lcG6lPlg87DynglEBb1Niw01Tdnqsu
        rXsT11l4yi0FyrcFuLwH8jt0hdQwITU0+mIGElHU+UYsGx7Rrk2MLRiaQ8UYMMVl6jiHT90kBmv
        i14jb35TMYJjEAnncLFWqZdhnobaNRVev
X-Received: by 2002:a1f:25c5:0:b0:3ea:1a72:aad6 with SMTP id l188-20020a1f25c5000000b003ea1a72aad6mr4103231vkl.15.1676306690098;
        Mon, 13 Feb 2023 08:44:50 -0800 (PST)
X-Google-Smtp-Source: AK7set/4GRMKn1CaCe56OzUt9wS+c1AKpIyjFKqfb/QsXBhHQvaRBqw5jCAn8TR4Z814dEoB9KIkVWYMlsPu2zhs/b0=
X-Received: by 2002:a1f:25c5:0:b0:3ea:1a72:aad6 with SMTP id
 l188-20020a1f25c5000000b003ea1a72aad6mr4103218vkl.15.1676306689880; Mon, 13
 Feb 2023 08:44:49 -0800 (PST)
MIME-Version: 1.0
References: <20230212063813.27622-1-marcan@marcan.st> <20230212063813.27622-4-marcan@marcan.st>
In-Reply-To: <20230212063813.27622-4-marcan@marcan.st>
From:   Eric Curtin <ecurtin@redhat.com>
Date:   Mon, 13 Feb 2023 16:44:34 +0000
Message-ID: <CAOgh=Fzb-45xY+Fmkaz1pxgC7Onj-9GktcYtD32RAw+LbeVk0w@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] brcmfmac: pcie: Add IDs/properties for BCM4377
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Feb 2023 at 06:45, Hector Martin <marcan@marcan.st> wrote:
>
> This chip is present on at least these Apple T2 Macs:
>
> * tahiti:  MacBook Pro 13" (2020, 2 TB3)
> * formosa: MacBook Pro 13" (Touch/2019)
> * fiji:    MacBook Air 13" (Scissor, 2020)
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Eric Curtin <ecurtin@redhat.com>

Is mise le meas/Regards,

Eric Curtin

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c      | 1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c      | 5 +++++
>  .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h    | 2 ++
>  3 files changed, 8 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index 3e42c2bd0d9a..8073f31be27d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -733,6 +733,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
>         case CY_CC_4373_CHIP_ID:
>                 return 0x160000;
>         case CY_CC_43752_CHIP_ID:
> +       case BRCM_CC_4377_CHIP_ID:
>                 return 0x170000;
>         case BRCM_CC_4378_CHIP_ID:
>                 return 0x352000;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 7135f889907a..d54394885af7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -63,6 +63,7 @@ BRCMF_FW_DEF(4365C, "brcmfmac4365c-pcie");
>  BRCMF_FW_DEF(4366B, "brcmfmac4366b-pcie");
>  BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
>  BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
> +BRCMF_FW_CLM_DEF(4377B3, "brcmfmac4377b3-pcie");
>  BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
>
>  /* firmware config files */
> @@ -95,6 +96,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>         BRCMF_FW_ENTRY(BRCM_CC_43664_CHIP_ID, 0xFFFFFFF0, 4366C),
>         BRCMF_FW_ENTRY(BRCM_CC_43666_CHIP_ID, 0xFFFFFFF0, 4366C),
>         BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
> +       BRCMF_FW_ENTRY(BRCM_CC_4377_CHIP_ID, 0xFFFFFFFF, 4377B3), /* revision ID 4 */
>         BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* revision ID 3 */
>  };
>
> @@ -2001,6 +2003,7 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
>                 base = 0x8c0;
>                 words = 0xb2;
>                 break;
> +       case BRCM_CC_4377_CHIP_ID:
>         case BRCM_CC_4378_CHIP_ID:
>                 coreid = BCMA_CORE_GCI;
>                 base = 0x1120;
> @@ -2618,7 +2621,9 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
>         BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_5G_DEVICE_ID, BCA),
>         BRCMF_PCIE_DEVICE(BRCM_PCIE_4371_DEVICE_ID, WCC),
>         BRCMF_PCIE_DEVICE(BRCM_PCIE_43596_DEVICE_ID, CYW),
> +       BRCMF_PCIE_DEVICE(BRCM_PCIE_4377_DEVICE_ID, WCC),
>         BRCMF_PCIE_DEVICE(BRCM_PCIE_4378_DEVICE_ID, WCC),
> +
>         { /* end: all zeroes */ }
>  };
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> index 6e27e3966655..896615f57952 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> @@ -52,6 +52,7 @@
>  #define BRCM_CC_43664_CHIP_ID          43664
>  #define BRCM_CC_43666_CHIP_ID          43666
>  #define BRCM_CC_4371_CHIP_ID           0x4371
> +#define BRCM_CC_4377_CHIP_ID           0x4377
>  #define BRCM_CC_4378_CHIP_ID           0x4378
>  #define CY_CC_4373_CHIP_ID             0x4373
>  #define CY_CC_43012_CHIP_ID            43012
> @@ -92,6 +93,7 @@
>  #define BRCM_PCIE_4366_5G_DEVICE_ID    0x43c5
>  #define BRCM_PCIE_4371_DEVICE_ID       0x440d
>  #define BRCM_PCIE_43596_DEVICE_ID      0x4415
> +#define BRCM_PCIE_4377_DEVICE_ID       0x4488
>  #define BRCM_PCIE_4378_DEVICE_ID       0x4425
>
>  /* brcmsmac IDs */
> --
> 2.35.1
>
>

