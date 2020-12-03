Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9F2CDB05
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436707AbgLCQTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:19:49 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38135 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436640AbgLCQTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 11:19:49 -0500
Received: by mail-ed1-f66.google.com with SMTP id cw27so2705570edb.5;
        Thu, 03 Dec 2020 08:19:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ODKylo1ARO1Guvyudvma49X5O/saBDRUYXjRotR9i2w=;
        b=X2XUucHKqYOxi60reNaj65uKVcUrEGR6RmOhxzIZ5mhZt7/WVVsdE2vAINUmSMr7Ju
         SmZIuLy/fnXZf1ArJxrYaMje5nSRop65mS7Kh4RO+/pRdML8RsQhGFRWHjVQuuZNsy5t
         nCr2rw9wsANz/MiUR6mUuEU//n5T+7v0cnk3iQr5Ft7Fwsv8S1seWr3lIvxndf3JrbQ2
         cmcBkEXLVYfECzVpmAkjTuilgVBQWEPzYaXTU4eRpZndUfS6zIbBc63UWS5/bmQWk0HC
         NMtc4302NsMEsONssJ12cqv55Gz8HJmwM6tSTyTPAAozlMRCWKfko4Wl2rOn8CAnwMan
         t8mw==
X-Gm-Message-State: AOAM530mFjINRGEaBVgGGCk/K9bKy0wmLOgMrHIPJ6zRzAnZZJQL3fVS
        xRQgwqFiixyU7NUZHVbk+UcNufXZwWY=
X-Google-Smtp-Source: ABdhPJyL9nlMz2v7x3aE+3ruRh8dZzYEMhD1TpwcFCO9mxL5SdTnNGRAR6YqDbwp6RR8z4MEXKEApg==
X-Received: by 2002:a50:c19a:: with SMTP id m26mr3518773edf.302.1607012347188;
        Thu, 03 Dec 2020 08:19:07 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id ga11sm1116662ejb.34.2020.12.03.08.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:19:05 -0800 (PST)
Date:   Thu, 3 Dec 2020 18:19:04 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: skip the NFC bootloader mode
Message-ID: <20201203161904.GA16186@kozik-lap>
References: <20201203153950.13772-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203153950.13772-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 12:39:50AM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> If there isn't proper NFC firmware image,
> Bootloader mode will be skipped.

Wrap your commit msg as described in submitting patches (so at 75
character).

> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/core.c     | 44 ++++++++++++++++++++++++----------
>  drivers/nfc/s3fwrn5/firmware.c | 11 +--------
>  drivers/nfc/s3fwrn5/firmware.h |  1 +
>  3 files changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
> index f8e5d78d9078..df89bc5d7338 100644
> --- a/drivers/nfc/s3fwrn5/core.c
> +++ b/drivers/nfc/s3fwrn5/core.c
> @@ -20,13 +20,26 @@
>  				NFC_PROTO_ISO14443_B_MASK | \
>  				NFC_PROTO_ISO15693_MASK)
>  
> +static int s3fwrn5_firmware_init(struct s3fwrn5_info *info)
> +{
> +	struct s3fwrn5_fw_info *fw_info = &info->fw_info;
> +	int ret;
> +
> +	s3fwrn5_fw_init(fw_info, "sec_s3fwrn5_firmware.bin");
> +
> +	/* Get firmware data */
> +	ret = s3fwrn5_fw_request_firmware(fw_info);
> +	if (ret < 0)
> +		dev_err(&fw_info->ndev->nfc_dev->dev,
> +			"Failed to get fw file, ret=%02x\n", ret);
> +	return ret;
> +}
> +
>  static int s3fwrn5_firmware_update(struct s3fwrn5_info *info)
>  {
>  	bool need_update;
>  	int ret;
>  
> -	s3fwrn5_fw_init(&info->fw_info, "sec_s3fwrn5_firmware.bin");
> -
>  	/* Update firmware */
>  
>  	s3fwrn5_set_wake(info, false);
> @@ -109,21 +122,26 @@ static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
>  	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
>  	int ret;
>  
> -	ret = s3fwrn5_firmware_update(info);
> -	if (ret < 0)
> -		goto out;
> +	if (s3fwrn5_firmware_init(info) == 0) {

if (s3fwrn5_firmware_init(info)) {
	// skip bootloader mode
	ret = 0;
	goto out;
}

so entire next block won't have to be indented.  This follows usual
pattern of error handling.

Best regards,
Krzysztof


> +		ret = s3fwrn5_firmware_update(info);
> +		if (ret < 0)
> +			goto out;
>  
> -	/* NCI core reset */
> -
> -	s3fwrn5_set_mode(info, S3FWRN5_MODE_NCI);
> -	s3fwrn5_set_wake(info, true);
> +		/* NCI core reset */
>  
> -	ret = nci_core_reset(info->ndev);
> -	if (ret < 0)
> -		goto out;
> +		s3fwrn5_set_mode(info, S3FWRN5_MODE_NCI);
> +		s3fwrn5_set_wake(info, true);
>  
> -	ret = nci_core_init(info->ndev);
> +		ret = nci_core_reset(info->ndev);
> +		if (ret < 0)
> +			goto out;
>  
> +		ret = nci_core_init(info->ndev);
> +	} else {
> +		dev_info(&info->ndev->nfc_dev->dev,
> +			 "skip bootloader mode\n");
> +		ret = 0;
> +	}
>  out:
>  	return ret;
>  }
