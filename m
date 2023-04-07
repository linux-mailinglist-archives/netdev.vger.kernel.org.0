Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA3B6DAD62
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240702AbjDGNQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240694AbjDGNQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526063C21
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 06:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680873343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+805T1P5BMIH072MzaqMZBoBVUUDfrH7JxP+UHnP/BM=;
        b=QfJg04g5Lx0kc5gkXEjtqwIK3KGOEThMfP84sbepthmuHwfMddo79hrGxBH2434SK2B0Sc
        Vz9IbIzCmLEDUIlLbzki87rOY+LU6kGzOS/EGBXuYUfKLtpNgEBeFnXa9tyEfu//JPF+3g
        Kkifpi6Q/n0Pzc84GO0lWqQuw+O7Vx4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-JYvusUNaN2GlNq_nUAHBcA-1; Fri, 07 Apr 2023 09:15:42 -0400
X-MC-Unique: JYvusUNaN2GlNq_nUAHBcA-1
Received: by mail-ej1-f69.google.com with SMTP id vg10-20020a170907d30a00b0094807746cebso1527677ejc.6
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 06:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680873341; x=1683465341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+805T1P5BMIH072MzaqMZBoBVUUDfrH7JxP+UHnP/BM=;
        b=QKUNAU+m4j1MgKCfCVceusmy+eieWgaBLf+7WxmWXJhIy49KzG0JePJw5IHX86ZGRc
         WrXWQz/gSgK1XDhouMSyHJHUQwPMd0pEXxyMjj51ifWMjLvCc+1GIMbd0SBRWnJWXFlC
         lP8MDieOkr8bX2hOd09NBxT2JrTcEfhnI08MZ5l0wcB910r8LGunQjDD5WI0RrPQH1yp
         K/CyhkPtkS8/b2b8wsyVtKbC8Xjt5SZL+4i46TTCBPgcz3BEvk5O6lgfe4u1jEy/Dx4m
         LXprCT1onaO6dVRARM7bMk3AvkdzA1/x0zS/dmHD2nmhsh8EDz7G05pT0OkfL1Mnf4qH
         HRyw==
X-Gm-Message-State: AAQBX9eDMAPDivFdkW3iKBuzR8gPptcHgSqJn6zQ06Y+/DnhuSt/0AGG
        LPowWQVwWShb1TDfcvCADTNKQJAQxdadclwka3Sj8J6jdGakxt8u5DTZQVIVjImeNXojQxyZrNY
        x7Lu7ovMk6MVW4R6jPAXkaH34
X-Received: by 2002:a17:906:7397:b0:93f:50c7:2f5f with SMTP id f23-20020a170906739700b0093f50c72f5fmr2395038ejl.63.1680873341120;
        Fri, 07 Apr 2023 06:15:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350biu2Io3Qi9fG2dyv4L+VPfvLmCaZLNoZgiCS1qJ4mCSK5lTpJDrxSPnOP0SqjSnsz+SVY1Ww==
X-Received: by 2002:a17:906:7397:b0:93f:50c7:2f5f with SMTP id f23-20020a170906739700b0093f50c72f5fmr2395009ejl.63.1680873340869;
        Fri, 07 Apr 2023 06:15:40 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id jx17-20020a170907761100b009332bb8b1f7sm2047300ejc.66.2023.04.07.06.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 06:15:39 -0700 (PDT)
Message-ID: <845521b4-0451-f0c0-7606-0144475e98f7@redhat.com>
Date:   Fri, 7 Apr 2023 15:15:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] wifi: brcmfmac: add Cypress 43439 SDIO ids
To:     Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230407013118.466441-1-marex@denx.de>
Content-Language: en-US, nl
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230407013118.466441-1-marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4/7/23 03:31, Marek Vasut wrote:
> Add SDIO ids for use with the muRata 1YN (Cypress CYW43439).
> The odd thing about this is that the previous 1YN populated
> on M.2 card for evaluation purposes had BRCM SDIO vendor ID,
> while the chip populated on real hardware has a Cypress one.
> The device ID also differs between the two devices. But they
> are both 43439 otherwise, so add the IDs for both.
> 
> ```
> /sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
> 0x04b4
> 0xbd3d
> ```
> 
> Fixes: be376df724aa3 ("wifi: brcmfmac: add 43439 SDIO ids and initialization")
> Signed-off-by: Marek Vasut <marex@denx.de>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans




> ---
> NOTE: Please drop the Fixes tag if this is considered unjustified
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Arend van Spriel <aspriel@gmail.com>
> Cc: Danny van Heumen <danny@dannyvanheumen.nl>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Paul Cercueil <paul@crapouillou.net>
> Cc: SHA-cyfmac-dev-list@infineon.com
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c    | 9 ++++++++-
>  include/linux/mmc/sdio_ids.h                             | 5 ++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 65d4799a56584..ff710b0b5071a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -965,6 +965,12 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
>  		.driver_data = BRCMF_FWVENDOR_ ## fw_vend \
>  	}
>  
> +#define CYW_SDIO_DEVICE(dev_id, fw_vend) \
> +	{ \
> +		SDIO_DEVICE(SDIO_VENDOR_ID_CYPRESS, dev_id), \
> +		.driver_data = BRCMF_FWVENDOR_ ## fw_vend \
> +	}
> +
>  /* devices we support, null terminated */
>  static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43143, WCC),
> @@ -979,6 +985,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339, WCC),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4339, WCC),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430, WCC),
> +	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43439, WCC),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345, WCC),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455, WCC),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354, WCC),
> @@ -986,9 +993,9 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359, WCC),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373, CYW),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43012, CYW),
> -	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439, CYW),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752, CYW),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_89359, CYW),
> +	CYW_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439, CYW),
>  	{ /* end: all zeroes */ }
>  };
>  MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 0e4ef9c5127ad..bf3c95d8eb8af 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -74,10 +74,13 @@
>  #define SDIO_DEVICE_ID_BROADCOM_43362		0xa962
>  #define SDIO_DEVICE_ID_BROADCOM_43364		0xa9a4
>  #define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
> -#define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439	0xa9af
> +#define SDIO_DEVICE_ID_BROADCOM_43439		0xa9af
>  #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
>  #define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752	0xaae8
>  
> +#define SDIO_VENDOR_ID_CYPRESS			0x04b4
> +#define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439	0xbd3d
> +
>  #define SDIO_VENDOR_ID_MARVELL			0x02df
>  #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
>  #define SDIO_DEVICE_ID_MARVELL_8688_WLAN	0x9104

