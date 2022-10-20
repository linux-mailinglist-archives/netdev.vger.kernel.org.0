Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA21605AAC
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJTJJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJTJJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:09:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAAA43632
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666256978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHu0qC5sRtM8JjGOnMBUHJXSljfPka+x5n6ab2sNzgk=;
        b=K5YWTclqvsCSW8WcIbnjHqQgbfPTFQi6YAzwkm+pUUzw7SM7ae/eAZutnmDAHusIZ/FGLq
        ojnNB0GXHvr8OD94l8FbZPNblV2Z2SRZzLYF6wprvdIxeSW004xbnW0KTukyZrSQdmiMks
        LBmLnyCLUQ4SFR4s8JYDD821WN9i3SM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-Bnu5dyVdNEqgG6r7Ywr_UQ-1; Thu, 20 Oct 2022 05:09:37 -0400
X-MC-Unique: Bnu5dyVdNEqgG6r7Ywr_UQ-1
Received: by mail-qk1-f199.google.com with SMTP id j13-20020a05620a288d00b006be7b2a758fso16627914qkp.1
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uHu0qC5sRtM8JjGOnMBUHJXSljfPka+x5n6ab2sNzgk=;
        b=inmpVBMGs7PRhN2B7+suqd7wP9/oz0ORuVHQtqSVowTVbJl2WdftBLnLF+spMgzWwv
         p6eAwyHNURsg8sxGcEtuXM7OUf+62XT5HqXzPZbzPA1mjazFiLPCWWZuG7SdfUOoHiQf
         mhnOA2ayrFWvZDGqyBgTtlRgdQeMLzciMen4SUyLO0fGUX8g7YENzHqjQGAqseX/KgSf
         HQpZsPl/QMri65NwbP46dKmeyoXB5OPqPnzIiAbrfxVdJDl9LaGzpt5PXFgT/xfYNKy9
         eeb2qLY4gnfjq74DjRCJmMPTC0em+ER3NoLnyy6vi2fQRTG87REROa52qFxuf9bTOctP
         oCOw==
X-Gm-Message-State: ACrzQf24siPG9SdSzB+8wpBHpd3R0qzP2ID9oHLGiRMDl5j31Tk/5Q6Q
        ft8WuEeJBMtLRoJlQGpwTdt6de5/rlgaDT4vXCFunB/1kNGif4IGobKSAdrA7qNQ9N+orgr1nCO
        JMHWT7Q2gJg1TjJhJ
X-Received: by 2002:ac8:58d0:0:b0:39c:f032:e3d9 with SMTP id u16-20020ac858d0000000b0039cf032e3d9mr10036630qta.355.1666256976022;
        Thu, 20 Oct 2022 02:09:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4FqxktITMoXXWuOnUhPQfDHyB1nUqhKaWXbgfF1n14dKm7rB4v6zBHarIOL1LTaKeEedfvwQ==
X-Received: by 2002:ac8:58d0:0:b0:39c:f032:e3d9 with SMTP id u16-20020ac858d0000000b0039cf032e3d9mr10036618qta.355.1666256975772;
        Thu, 20 Oct 2022 02:09:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id o6-20020a05620a2a0600b006ee9d734479sm7068437qkp.33.2022.10.20.02.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 02:09:35 -0700 (PDT)
Message-ID: <d9bac72cf3c7ee92ad399fff5dcaae85903adda5.camel@redhat.com>
Subject: Re: [PATCH v3] net: hinic: Set max_mtu/min_mtu directly to simplify
 the code.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Cai Huoqing <cai.huoqing@linux.dev>, kuba@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 20 Oct 2022 11:09:31 +0200
In-Reply-To: <20221018110701.3958-1-cai.huoqing@linux.dev>
References: <20221018110701.3958-1-cai.huoqing@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-18 at 19:06 +0800, Cai Huoqing wrote:
> Set max_mtu/min_mtu directly to avoid making the validity judgment
> when set mtu, because the judgment is made in net/core: dev_validate_mtu,
> so to simplify the code.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> ---
> v1->v2:
> 	1.Update changelog.
> 	2.Reverse MAX_MTU to max jumbo frame size.
> 
> v2->v3:
> 	1.Update signature
> 
> 	v1 link: https://lore.kernel.org/lkml/20221012082945.10353-1-cai.huoqing@linux.dev/
>         v2 link: https://lore.kernel.org/lkml/20220429033733.GA15753@chq-T47/
> 
> 
>  drivers/net/ethernet/huawei/hinic/hinic_dev.h  |  4 ++++
>  drivers/net/ethernet/huawei/hinic/hinic_main.c |  3 ++-
>  drivers/net/ethernet/huawei/hinic/hinic_port.c | 17 +----------------
>  3 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> index a4fbf44f944c..2bbc94c0a9c1 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> @@ -22,6 +22,10 @@
>  
>  #define LP_PKT_CNT		64
>  
> +#define HINIC_MAX_JUMBO_FRAME_SIZE 	15872
> +#define HINIC_MAX_MTU_SIZE 	(HINIC_MAX_JUMBO_FRAME_SIZE - ETH_HLEN - ETH_FCS_LEN)
> +#define HINIC_MIN_MTU_SIZE 	256

I'm sorry for the nit pick, but the above is whitespace-damaged: you
are mixing spaces and tabs.

Cheers,

Paolo

