Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA49D644839
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiLFPnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiLFPnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:43:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744C864D3
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670341361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xqv9uRFg/HKdZhDUKeLP7zieO3tFQjhNIhtl1kY75aI=;
        b=YSVXHLm/tJmBg2oEkrsfU9fpcmJO+0O35aI8JPJLfO2hCvVwFAPz51FxRtlXXGg/IZdPe/
        lsNLbuWer4yVjzrN6uB38f7haGhAbsAxWs4GbOCBNvs3Z986n21JEBtu10JoG2fsx6sWtr
        39gjbpaDuj0vTkAHQi0flWY+LwKsZpU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-ODrEk-zeM5aHk-TBp3nHDA-1; Tue, 06 Dec 2022 10:42:40 -0500
X-MC-Unique: ODrEk-zeM5aHk-TBp3nHDA-1
Received: by mail-qk1-f197.google.com with SMTP id bq13-20020a05620a468d00b006fa5a75759aso21477102qkb.13
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 07:42:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xqv9uRFg/HKdZhDUKeLP7zieO3tFQjhNIhtl1kY75aI=;
        b=TyrgJB3kYv5MAA6F00HohUNvBBdKJFoxu0KiiGYBV1DnU46Pb0aGpvkHEUSR0D6c1a
         VIgSSa6eIPY14ntlWsn4RYen/KKkdB5f2YsDvilPDZuCVteBUCfbc8/giyPINv2yTql8
         eK4TUA49C00OR8fbOGL3JyOtFe6HQyXIRo+qFNNOguDabZLCvKyht85IH1FLKXL2Nri/
         FAkm8XSa7gIdlNlgDkxOu0H57czSMekLmoSXPH2NdMUGGvmYBUuY22BlurOj4fSaW9h8
         LyG7+jYcGT4n8uLRjhoAhefbmCGCaOIc2okm74BvfA3MCXBEz42vGnsj4NIfkD6YedTA
         8lOw==
X-Gm-Message-State: ANoB5pmL+ZzMrRVHLXX6enwcWKJ+qjM0anmu1tgOZz/4xsIYWldq/u1Z
        yVFHgAQFwEdnnPC6efZi/uaBqiX7IQ7dUs+Rmsosn4nsQOw8NarY4/IRchO3HD65XNOa1bJuDMZ
        fZfSePpOTaTfR0FbW
X-Received: by 2002:a0c:f947:0:b0:4c7:8c20:9ec1 with SMTP id i7-20020a0cf947000000b004c78c209ec1mr752002qvo.91.1670341357014;
        Tue, 06 Dec 2022 07:42:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6CMH8+4e/Hnp4WmzMYrwwE36t3yir4U9wv6FziCmGo/cZjMxBzHs/xLTxG5Sgino5R5tHYtA==
X-Received: by 2002:a0c:f947:0:b0:4c7:8c20:9ec1 with SMTP id i7-20020a0cf947000000b004c78c209ec1mr751985qvo.91.1670341356786;
        Tue, 06 Dec 2022 07:42:36 -0800 (PST)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id j1-20020a05620a410100b006fec1c0754csm5113836qko.87.2022.12.06.07.42.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 07:42:36 -0800 (PST)
Message-ID: <c7be4ae2-f55e-0277-3c1c-cecad5cc9262@redhat.com>
Date:   Tue, 6 Dec 2022 10:42:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net] bonding: get correct NA dest address
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20221206032055.7517-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20221206032055.7517-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 22:20, Hangbin Liu wrote:
> In commit 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving
> IPv6 messages"), there is a copy/paste issue for NA daddr. I found that
> in my testing and fixed it in my local branch. But I forgot to re-format
> the patch and sent the wrong mail.
> 
> Fix it by reading the correct dest address.
> 
> Fixes: 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving IPv6 messages")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

> ---
>   drivers/net/bonding/bond_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index f298b9b3eb77..b9a882f182d2 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3247,7 +3247,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
>   		goto out;
>   
>   	saddr = &combined->ip6.saddr;
> -	daddr = &combined->ip6.saddr;
> +	daddr = &combined->ip6.daddr;
>   
>   	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6c tip %pI6c\n",
>   		  __func__, slave->dev->name, bond_slave_state(slave),

