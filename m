Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CD74FE684
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243043AbiDLRHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiDLRHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:07:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5CED18B23
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649783092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSJfpAT0I7Ew3ElBkRbQ8naLrJFpSaVjZn9uQpmAQcg=;
        b=K8IVjt+z07OqVQ/yJ01luAtMqrbum67a2XRtgj74zdICTu7JLJWzbBaWJlWa/GHIkARLkw
        xBUEfEr4SIdQ66YQtrupo8lEu0/Xwwo9lu25t0EHrrcSgzGjINIk3c55A3eFlI9M50gDVc
        bu9TZQ8wHdUzTY4OhhWoRzJtITxfDM0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-M5FqcCC3MhCCoR5Q5dD-Zg-1; Tue, 12 Apr 2022 13:04:48 -0400
X-MC-Unique: M5FqcCC3MhCCoR5Q5dD-Zg-1
Received: by mail-qk1-f199.google.com with SMTP id bm39-20020a05620a19a700b0069c4b295971so832623qkb.8
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dSJfpAT0I7Ew3ElBkRbQ8naLrJFpSaVjZn9uQpmAQcg=;
        b=J4Fn6caRgaCuJvJ8UvLlHrbAh1Cgs6ghmjWW2L2LwJOHhH3xMkli77oiEck3x0ItS4
         KBeJOTAM9vPD40FF59rIsPXvcyKZYB4ihzhkyjLMwWKVNToda+pQ3PAlU/falMTHQioZ
         UzaBcW03dENWuChYNVEu9FuEkb/GiHpIYo7bSEDu1qIT4P0ih9rIJvYB+1PWX8DPZHL5
         Xe5AYrd/dNnTGnVR0WQMGPRLj2oycTbTuSUYfuWHsyQH0sETNCHwYOE2L/Ka6q92MEB3
         JIEyLhZrFS0Rbj4klGIJE5sH69VXjTNi1puDd4o58mV8Bwo29/xNShhovcdPO+vgHjou
         mcNw==
X-Gm-Message-State: AOAM532MZgwCVXPSccPEYtnKv5za33lmwtyiYct65cjayqPRdgi7mvcP
        oVerO75wqjIzXW+Pwr782yq1Eih7xCMWBPOwU6V+YzZbN9S0UfEHMHTMmZrxjjVp+ydzFPQGXI9
        BHqtEs1AGwgmCm1QJ
X-Received: by 2002:ac8:4b51:0:b0:2ed:d38:a07d with SMTP id e17-20020ac84b51000000b002ed0d38a07dmr4056870qts.249.1649783088218;
        Tue, 12 Apr 2022 10:04:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYVSA5QdjEfpEqJic/axqcavQh/bKJKTHFhW647B9FVXVIbBbKwDB3sfn6+7Mf320QpR9sHQ==
X-Received: by 2002:ac8:4b51:0:b0:2ed:d38:a07d with SMTP id e17-20020ac84b51000000b002ed0d38a07dmr4056835qts.249.1649783087862;
        Tue, 12 Apr 2022 10:04:47 -0700 (PDT)
Received: from [192.168.98.18] ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id 3-20020ac85903000000b002ee83037459sm4803418qty.42.2022.04.12.10.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 10:04:47 -0700 (PDT)
Message-ID: <7f230c69-dc15-ebaa-ff80-d4bde98488d3@redhat.com>
Date:   Tue, 12 Apr 2022 13:04:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com> <20134.1649778941@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20134.1649778941@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 11:55, Jay Vosburgh wrote:
>>>    diff --git a/include/net/bonding.h b/include/net/bonding.h
>>> index b14f4c0b4e9e..4ff093fb2289 100644
>>> --- a/include/net/bonding.h
>>> +++ b/include/net/bonding.h
>>> @@ -176,6 +176,7 @@ struct slave {
>>>    	u32    speed;
>>>    	u16    queue_id;
>>>    	u8     perm_hwaddr[MAX_ADDR_LEN];
>>> +	int    prio;
>> Do we want a struct slave_params here instead? That would allow us to
>> define defaults in a central place and set them once instead of setting
>> each parameter.
> 	Presuming that you mean creating a sub-struct here and moving
> some set of members of struct slave into it, I'm not sure I see the
> benefit, as it would only exist here and not really be an independent
> object.  Am I misunderstanding?

You are understanding correctly. The goal of this work is to eventually 
port the majority of the per-port parameters that exist in teaming to 
bonding, we have not determined the entire set that make sense. Thus 
there will be more than just port priority as a userspace configurable 
option. So I was attempting to ask if modeling the initial setting of 
these parameters like how `bonding_defaults` is used, made sense.

file: drivers/net/bonding/bond_main.c:
	void bond_setup(struct net_device *bond_dev)
	{
		struct bonding *bond = netdev_priv(bond_dev);

		spin_lock_init(&bond->mode_lock);
		bond->params = bonding_defaults;
	...


We can always refactor this area when there is another option that needs 
setting.

-Jon

