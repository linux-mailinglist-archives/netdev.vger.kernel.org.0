Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B66F645986
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLGL5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiLGL41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:56:27 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D23431ED2
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:55:50 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id x22so13344840ejs.11
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 03:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h6WWykpRMQ08oH10k+rNonxniUiSXTcIouS51JxmPrI=;
        b=peuuBganjvykUkVBRllB90W0SXhfb+aR1kMNgffUhCHyFSTdW9mwcG5RwsUHWfSst+
         pxryXMV6ZF/ZuPOtkBTYUAr+KhN7/ipvQZMNYW92Boa4FRZ/QnPIhBpyH0qUd8ciaWQI
         +Jj14YTvSeilCKzNldbEMyfHoK1kAVutuZyYQMl/NyU4XpLTNpNyS/RD/HW0vqlXKjIS
         Xynpcz+kACFy7wT+zvYrSb4PdbWrXql8MfYbrue1JRvdN3UlExbVIta0zHcsq11g8IEV
         ibZF6CAa+O3f8YEnSCO3JURdcA3lr10Tcm5iPEoQfceanwMECbAxHJ9LbgXWulDacPwu
         T7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6WWykpRMQ08oH10k+rNonxniUiSXTcIouS51JxmPrI=;
        b=VvasuXMi54armCTznJKRbbTY4lMr7Xh1jxv3x/vyFVPTJd9qK7z4peSST6gq++FZnY
         FteewfTy8vdLORgzlA5wD4PtTEZCtXZ5mNlVCDXNR6HtQP3+IEMYTPeGotiA0LJU9LTJ
         kQrEXA8kpYSC6BrKXwvuG2L8WJeqtMjSvc5zRwIAhLeN7629+zu9AU6eeuCUs5QcmoZn
         DB1lt5HDDG9neCWRb9YQB4gCI7m5Q0cadhg/XMc35YnAMWX+AmZKkMSjAeqDEIwE2Rju
         DZuQaw1DL5Ae+tjGvH/mkqnhMp1XA1brLlh5aZhXZEcctQa+U3rysm5ZmHuFWMqsgNMl
         AXtg==
X-Gm-Message-State: ANoB5plyNmaNv1dUf0/3+lTOYuXS5MQhLzjMGmP5bvIjbunNZPlva9HO
        fvHA/2HtFexnj8M+5ipwUao=
X-Google-Smtp-Source: AA0mqf7RWI32jBGmUWfVlXnyf87o+i8oUJuGk2zIwTg4EoX2hs1AwkGLUmXAbrWS6gniwgXqtmBBlg==
X-Received: by 2002:a17:906:e2d4:b0:7c1:532:f420 with SMTP id gr20-20020a170906e2d400b007c10532f420mr7477323ejb.679.1670414148369;
        Wed, 07 Dec 2022 03:55:48 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id k24-20020a1709065fd800b0078d76ee7543sm8448037ejv.222.2022.12.07.03.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 03:55:48 -0800 (PST)
Date:   Wed, 7 Dec 2022 13:55:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa2-switch: Fix memory leak in
 dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()
Message-ID: <20221207115537.zf2ikns77bxyt74m@skbuf>
References: <20221205061515.115012-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205061515.115012-1-yuancan@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yuan,

On Mon, Dec 05, 2022 at 06:15:15AM +0000, Yuan Can wrote:
> The cmd_buff needs to be freed when error happened in
> dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove().
> 
> Fixes: 1110318d83e8 ("dpaa2-switch: add tc flower hardware offload on ingress traffic")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> index cacd454ac696..c39b866e2582 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> @@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
>  						 DMA_TO_DEVICE);
>  	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
>  		dev_err(dev, "DMA mapping failed\n");
> +		kfree(cmd_buff);
>  		return -EFAULT;
>  	}
>  
> @@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
>  			 DMA_TO_DEVICE);
>  	if (err) {
>  		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
> +		kfree(cmd_buff);

To reduce the number of kfree() calls, this last one can be put right
before checking for error, and we could remove the kfree(cmd_buff) call at
the very end. I mean that was already the intention, if you look at the
dma_unmap_single() call compared to the error checking. Like this:

	err = dpsw_acl_add_entry(...);

	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
			 DMA_TO_DEVICE);
	kfree(cmd_buff);

	if (err) {
		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
		return err;
	}

	return 0;
}

>  		return err;
>  	}
>  
> @@ -172,6 +174,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
>  						 DMA_TO_DEVICE);
>  	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
>  		dev_err(dev, "DMA mapping failed\n");
> +		kfree(cmd_buff);
>  		return -EFAULT;
>  	}
>  
> @@ -182,6 +185,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
>  			 DMA_TO_DEVICE);
>  	if (err) {
>  		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
> +		kfree(cmd_buff);

Similar here:

	err = dpsw_acl_remove_entry(ethsw->mc_io, 0, ethsw->dpsw_handle,
				    block->acl_id, acl_entry_cfg);

	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
			 DMA_TO_DEVICE);
	kfree(cmd_buff);

	if (err) {
		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
		return err;
	}

	return 0;
}

>  		return err;
>  	}
>  
> -- 
> 2.17.1
> 
