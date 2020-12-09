Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936B32D3820
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgLIBMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgLIBML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 20:12:11 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00E4C0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 17:11:31 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id o11so665632ote.4
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 17:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RJM1hdnxjXSlZDOWiasy+1r+za6X2vmIYFCfgCITCcY=;
        b=KFKDzFb6UL8vzCHrBPpewb+rC3w3yPSNqdyzUkkp/s5yP41YSU491kKvmkq3Pl0JVG
         kWFELD9ui0QYcaGsielM7PsSc/TbnpGP8zxZyebZgjE5RbNvxY3ib8OKkyQn9nD1U1qf
         9zOClrKtPzFOtaH3/JDWELt0pjxeqHC/CHWNIwQjwq/PjsWu21Yt5j0k2Sg4eNp7DAjU
         lyO5g2Y/cqMzAbxzGMhmdfzIUsrvWz/2LSQBiJawpEktetT/yU4ji38TAD9dPhHStRUB
         ItUBP0th5dJZwytQmiaa7HHvPkSI+6+pNmMBnmL2hhmfU49nWt3eHxWRISkl37TZW0q4
         2fFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RJM1hdnxjXSlZDOWiasy+1r+za6X2vmIYFCfgCITCcY=;
        b=m+3UJ/iC2YEiHZr2TjUV8XXCxw9Q8ooIRl2iREDqynfQgUE2oWPzj2aw4MpuTwmPM/
         qgVBYtvozle8t6bNILCbTCL1naY6FX18QQTTrGOUc2rUm6Fd7thxGfgvZu3E2uB406C6
         ljAezUtiRerd4cWpFOLZL0SXR5s1/VJXMZV6jD7JJOAYHm4lwJeFwJLl9ljQfUnLIZx4
         73iTX5txeM38nWe5OZGvCO3tTT4wPCbMAzlF3BWgxVh9ayJcWIDdZ8ZdzoSwDuMlZPfR
         TR/pupzn3bh5r7lXcrrg3qlqLLOIrorBgJ9J3oUcZPiiyNLFDaRMgYv6Vhqb0x6TWA0W
         tf3w==
X-Gm-Message-State: AOAM530qFqBIH+DycFk/rwViuj98S6WfJXjA3RvZgBgrlJEDtGhEv1Vz
        FA9AmR/ZJaNH1yx8/FHLhZRMaBwexlfJ0w==
X-Google-Smtp-Source: ABdhPJx8+Ccu8F1QT25GeEV+/cGXSTSWiLiDa65Dr23mGkdZFYosmMbyXGLSutWFJM5Uq5QDZWFiwA==
X-Received: by 2002:a05:6830:314b:: with SMTP id c11mr674204ots.151.1607476291183;
        Tue, 08 Dec 2020 17:11:31 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:64fc:adeb:84f9:fa62])
        by smtp.googlemail.com with ESMTPSA id k20sm5889oig.35.2020.12.08.17.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 17:11:30 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
From:   David Ahern <dsahern@gmail.com>
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-3-borisp@mellanox.com>
 <824e3bea-60d2-5a4d-e8ce-770d70f0ba37@gmail.com>
Message-ID: <474d1275-9506-99d3-4f0d-86b482953eee@gmail.com>
Date:   Tue, 8 Dec 2020 18:11:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <824e3bea-60d2-5a4d-e8ce-770d70f0ba37@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/20 5:57 PM, David Ahern wrote:
>> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
>> index 7338b3865a2a..a08b85b53aa8 100644
>> --- a/include/net/inet_connection_sock.h
>> +++ b/include/net/inet_connection_sock.h
>> @@ -66,6 +66,8 @@ struct inet_connection_sock_af_ops {
>>   * @icsk_ulp_ops	   Pluggable ULP control hook
>>   * @icsk_ulp_data	   ULP private data
>>   * @icsk_clean_acked	   Clean acked data hook
>> + * @icsk_ulp_ddp_ops	   Pluggable ULP direct data placement control hook
>> + * @icsk_ulp_ddp_data	   ULP direct data placement private data
> 
> Neither of these socket layer intrusions are needed. All references but
> 1 -- the skbuff check -- are in the mlx5 driver. Any skb check that is
> needed can be handled with a different setting.

missed the nvme ops for the driver to callback to the socket owner.

