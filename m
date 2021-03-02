Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC3732A2DC
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837729AbhCBIdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241869AbhCBCKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:10:25 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80C0C061224
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 18:05:13 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id n14so20082994iog.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 18:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aHPldpe0SiR7sw8hK4soQ68kZblrZ1w3Ylxgm2V+BwM=;
        b=a6zRHktzbocHLE4UViU75DEfqkz5Q/iVvw3onXzt7SEfsaeXciR2lZ+a6vYp0nEe63
         L4GLeBVICjWRT81J2ktA731yPNVxKZrqqkOis2JQtBijydOK3LiAwfZXJqbyTsrLSPVf
         jZayJOS5pvPH6fFfQYTUSXH50DWKjzUL5EE1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aHPldpe0SiR7sw8hK4soQ68kZblrZ1w3Ylxgm2V+BwM=;
        b=dBhw/trD8ZBHyNghzcQC673p9NGOIwXgf+wta2GW8eoCx5P8BOFk4F5vYvN3Iyqd6f
         QTOFDvctGdZXsjuc9usrGFNh/eDSK0tUwSTtMBmo0DM01Ak8+NkYhMgSFVH02qkZAWWQ
         QoYQaKEhTH57jDmcHNuAQGN8EhX6EbPwty1Gf/MYiAzFUr5tCRHAQX8Z/HIHlEPEfS54
         7Q3bVyu+dtOLR+6yTWfMl00e23OiUJqg5PJ4e+m2BtzwgdkeoLXYPYhOr0h5f3gFfB8p
         7PWIkRyS+x4G1+h4p0oBmZtfpZsDcW34dw2CmWPsxVm+0lyED2D7Evvq1v7uyFewXJFN
         8GIg==
X-Gm-Message-State: AOAM530WQ1fx7yUnt7rD+aG5iNZfW0GEUeaI9l0xE6NDUVxWKjmDWmoX
        I2AtFn8Bwu3Jhjv4oZ7KqTKyOA==
X-Google-Smtp-Source: ABdhPJz5jUsHdnTFltQAarSJGMmnUhGxk7+zQ4ux/wKqpg5BGM/AjQx8Z418NkxEkBdNRuVxjyoFOA==
X-Received: by 2002:a5d:8149:: with SMTP id f9mr16624787ioo.191.1614650713273;
        Mon, 01 Mar 2021 18:05:13 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id y3sm1213633iot.15.2021.03.01.18.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 18:05:12 -0800 (PST)
Subject: Re: [PATCH v1 3/7] net: ipa: gsi: Avoid some writes during irq setup
 for older IPA
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-4-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <6f2ab23f-e4ab-2de8-1991-6a0435cfba65@ieee.org>
Date:   Mon, 1 Mar 2021 20:05:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-4-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> On some IPA versions (v3.1 and older), writing to registers
> GSI_INTER_EE_SRC_CH_IRQ_OFFSET and GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET
> will generate a fault and the SoC will lockup.
> 
> Avoid clearing CH and EV_CH interrupts on GSI probe to fix this bad
> behavior: we are anyway not going to get spurious interrupts.

I think the reason for this might be that these registers
are located at a different offset for IPA v3.1.

I'd rather get it right and actively disable these
interrupts rather than assume they won't fire.

Also...  you included an extra blank line; avoid that.

					-Alex

> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> ---
>  drivers/net/ipa/gsi.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 6315336b3ca8..b5460cbb085c 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -207,11 +207,14 @@ static void gsi_irq_setup(struct gsi *gsi)
>  	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
>  
>  	/* Reverse the offset adjustment for inter-EE register offsets */
> -	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
> -	iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
> -	iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
> +	if (gsi->version > IPA_VERSION_3_1) {
> +		adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
> +		iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
> +		iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
> +	}
>  
>  	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
> +
>  }
>  
>  /* Turn off all GSI interrupts when we're all done */
> 

