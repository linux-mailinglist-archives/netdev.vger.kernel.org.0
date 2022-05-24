Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF53532CF8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbiEXPJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiEXPJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:09:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBCF48B094
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653404951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XEo1NssAVGQZOfwlIMOHsifxPwTmlidTFKTUs0/1OgM=;
        b=ObGSmU7XUFSm8l1xVGe4pKlpAnQJVGFCX+i/cHmYdFcji/3RRnyLS3iUYOrAngu4hdCwxo
        4FL5Fu3D6/I8zXoHbVEdIz7DlEz/mH/5W70QaA8v/XR7RNTiw2uercD2VnMq22mFZSiuUl
        km5lRYzOv7sQIcybpXfNA7q3S7qrYW0=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-mO1oKUVfMeeCnI8Gk32YtA-1; Tue, 24 May 2022 11:09:10 -0400
X-MC-Unique: mO1oKUVfMeeCnI8Gk32YtA-1
Received: by mail-ot1-f71.google.com with SMTP id d7-20020a9d2907000000b0060b11e95a93so1961667otb.23
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XEo1NssAVGQZOfwlIMOHsifxPwTmlidTFKTUs0/1OgM=;
        b=aCEB8c44u0UGPKUeLcDHYTXg0u7xTb7kj2fhqFXqHJKtDeFEWp//yvbmq4fhEd8qm0
         w0lOWCvZD8Cx4JgaLlbEcCcPEahQSJg1ZQ1couSylKqKynOmVEYpe9RjQhE+RmhHEb/X
         aRse1MD0dFY/Vh9aOPdfdUuoe947DR0w/2nIbL95iDW1kN1wBdyggh/xFdCGIk5ci9mr
         X1A+Jo283FkIPYfFG/42tmDWloX5tE45lSFJyZzEiV0nNvQg0VPZKKG8c+Zh+atuotvV
         ofaW0og0hD6TXQPV4o8PBkLsrsg8roVpsIwSpNPZrV6ke2Ew7orz+bOiBYJCXmo8AQQo
         lHAg==
X-Gm-Message-State: AOAM531iaW54Dv3LFP77zoLrqfU2157cWFOWTUDFHzUcHAwOMYywPH0v
        /mj2jkJwyL5mQC2LLz67RCKd7wqLqq34OstqlIoEErqboJx5EYBN83d8nxIqBVyXtU+9SdU29Kz
        cKm01DCbd/T/GHb3e
X-Received: by 2002:a9d:811:0:b0:60a:b6f2:ab85 with SMTP id 17-20020a9d0811000000b0060ab6f2ab85mr6516323oty.9.1653404948234;
        Tue, 24 May 2022 08:09:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2Rrz8fDExW7WCjRqyXrFYjg5Q3G0iEtos25IWByh96ynkYINF5ql63GdcjlrT4RcCKJU4fg==
X-Received: by 2002:a9d:811:0:b0:60a:b6f2:ab85 with SMTP id 17-20020a9d0811000000b0060ab6f2ab85mr6516299oty.9.1653404947414;
        Tue, 24 May 2022 08:09:07 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id k17-20020a9d1991000000b0060b0b638583sm3021001otk.13.2022.05.24.08.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 08:09:07 -0700 (PDT)
Subject: Re: [PATCH] ath6kl: Use cc-disable-warning to disable
 -Wdangling-pointer
To:     Nathan Chancellor <nathan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        "kernelci.org bot" <bot@kernelci.org>
References: <20220524145655.869822-1-nathan@kernel.org>
From:   Tom Rix <trix@redhat.com>
Message-ID: <c7a804ed-e00c-8a32-db21-c689312e0073@redhat.com>
Date:   Tue, 24 May 2022 08:09:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220524145655.869822-1-nathan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/24/22 7:56 AM, Nathan Chancellor wrote:
> Clang does not support this option so the build fails:
>
>    error: unknown warning option '-Wno-dangling-pointer' [-Werror,-Wunknown-warning-option]
>
> Use cc-disable-warning so that the option is only added when it is
> supported.
>
> Fixes: bd1d129daa3e ("wifi: ath6k: silence false positive -Wno-dangling-pointer warning on GCC 12")
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Tom Rix <trix@redhat.com>

Thanks

Tom

> ---
>   drivers/net/wireless/ath/ath6kl/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
> index 01cc0d50fee6..a75bfa9fd1cf 100644
> --- a/drivers/net/wireless/ath/ath6kl/Makefile
> +++ b/drivers/net/wireless/ath/ath6kl/Makefile
> @@ -38,7 +38,7 @@ ath6kl_core-y += recovery.o
>   
>   # FIXME: temporarily silence -Wdangling-pointer on non W=1+ builds
>   ifndef KBUILD_EXTRA_WARN
> -CFLAGS_htc_mbox.o += -Wno-dangling-pointer
> +CFLAGS_htc_mbox.o += $(call cc-disable-warning, dangling-pointer)
>   endif
>   
>   ath6kl_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
>
> base-commit: 677fb7525331375ba2f90f4bc94a80b9b6e697a3

