Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4453B5EEF9E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbiI2HsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbiI2HsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:48:05 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D210139420
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:48:03 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id hy2so1050581ejc.8
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=4eDDdFcESkhJvsytqd+Yc38so22tAdDSizQ5vMRnBI8=;
        b=W31fImQGHNBX/YFOA5QA2NJhCt4DC22Cg7MKewhqq77nz/g35tdgDcSeILAAtQUvoL
         yPhDW6IS7KU9NgKVu+0lzgz7ivdany+OWngYjBAYZFMIiQJo2tda0d8629VMcf6QGz5B
         Ixj1q9D3kwZ1bFg5cUZ2j9rTJpStDDXGtE5mXPgPW656BsguDGZMsTV/W1tJEWPbLpeP
         nB1L0X4H+1RTndaVA/4LxcJ9UG8MQprbIz3S8LzUo8eL7fTZqg/d57DOUIdsnysyjsSf
         ax+nI5i/HMssu/b0+OqlHj11fP25dPJ/9INgvh+WA40NOBlZ4xnyEKuyZXvD8bDA7wgX
         lt6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4eDDdFcESkhJvsytqd+Yc38so22tAdDSizQ5vMRnBI8=;
        b=wxfP+QzmhvIhwnc6ewQyiwOBo0GGAobCmLbePxTQgEdqJ82NtDdWrmlzT+K629Z7rh
         N+/Uw4SWnDqrcg0e4407C1KqmpCqUEnOTEZzZf57CErBVNKahqQAaKJd8ig9pZ7JVvaP
         Nx4JTheXvGzfTIN4+W+m//YKpb79zK8dGIv3a5JjBp2ald50EwFM4rpKuZr5jlUQwdW8
         e2geEya8vQgYJkzJQXRouURfSul0PyDhLTUTCp1owlQE3viUsk2/oq5bErNY7jk2eBjo
         vj5DV3TczEJB202Zua9l+soaQB8m9LxAZ902hW1eOwtqjYSaN4qqy7ELoolbJRhilqrj
         hBDA==
X-Gm-Message-State: ACrzQf1Z8Ft6SnGyZmLiir/mhOlFcT4GQRPlx2OBaHcKgOqPwQAQK7G3
        WZGLLcZ9Zgj/Zd/GOiFfbKI=
X-Google-Smtp-Source: AMsMyM4frXq7gdfvGu5Xy3hahOy0YhnX8jZQTb9TBo8Tf9IQ1ALNU1WMEr4cxVXLBhhYD3zAoO7Uaw==
X-Received: by 2002:a17:907:8a17:b0:782:6e72:7aba with SMTP id sc23-20020a1709078a1700b007826e727abamr1644137ejc.474.1664437682058;
        Thu, 29 Sep 2022 00:48:02 -0700 (PDT)
Received: from [172.17.234.34] (nata192.ugent.be. [157.193.240.192])
        by smtp.gmail.com with ESMTPSA id f24-20020a17090631d800b00783975025c8sm3533909ejf.121.2022.09.29.00.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 00:48:01 -0700 (PDT)
Message-ID: <36bb049a-2ca8-d3b3-1db4-2ea665e7ab80@gmail.com>
Date:   Thu, 29 Sep 2022 09:48:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net] eth: alx: take rtnl_lock on resume
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Zbynek Michl <zbynek.michl@gmail.com>, chris.snook@gmail.com,
        johannes@sipsolutions.net
References: <20220928181236.1053043-1-kuba@kernel.org>
Content-Language: en-US
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <20220928181236.1053043-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/22 20:12, Jakub Kicinski wrote:
> Zbynek reports that alx trips an rtnl assertion on resume:
> 
>  RTNL: assertion failed at net/core/dev.c (2891)
>  RIP: 0010:netif_set_real_num_tx_queues+0x1ac/0x1c0
>  Call Trace:
>   <TASK>
>   __alx_open+0x230/0x570 [alx]
>   alx_resume+0x54/0x80 [alx]
>   ? pci_legacy_resume+0x80/0x80
>   dpm_run_callback+0x4a/0x150
>   device_resume+0x8b/0x190
>   async_resume+0x19/0x30
>   async_run_entry_fn+0x30/0x130
>   process_one_work+0x1e5/0x3b0
> 
> indeed the driver does not hold rtnl_lock during its internal close
> and re-open functions during suspend/resume. Note that this is not
> a huge bug as the driver implements its own locking, and does not
> implement changing the number of queues, but we need to silence
> the splat.
> 
> Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
> Reported-and-tested-by: Zbynek Michl <zbynek.michl@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: chris.snook@gmail.com
> CC: dossche.niels@gmail.com
> CC: johannes@sipsolutions.net
> ---
>  drivers/net/ethernet/atheros/alx/main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
> index a89b93cb4e26..d5939586c82e 100644
> --- a/drivers/net/ethernet/atheros/alx/main.c
> +++ b/drivers/net/ethernet/atheros/alx/main.c
> @@ -1912,11 +1912,14 @@ static int alx_suspend(struct device *dev)
>  
>  	if (!netif_running(alx->dev))
>  		return 0;
> +
> +	rtnl_lock();
>  	netif_device_detach(alx->dev);
>  
>  	mutex_lock(&alx->mtx);
>  	__alx_stop(alx);
>  	mutex_unlock(&alx->mtx);
> +	rtnl_unlock();
>  
>  	return 0;
>  }
> @@ -1927,6 +1930,7 @@ static int alx_resume(struct device *dev)
>  	struct alx_hw *hw = &alx->hw;
>  	int err;
>  
> +	rtnl_lock();
>  	mutex_lock(&alx->mtx);
>  	alx_reset_phy(hw);
>  
> @@ -1943,6 +1947,7 @@ static int alx_resume(struct device *dev)
>  
>  unlock:
>  	mutex_unlock(&alx->mtx);
> +	rtnl_unlock();
>  	return err;
>  }
>  

Reviewed-by: Niels Dossche <dossche.niels@gmail.com>

