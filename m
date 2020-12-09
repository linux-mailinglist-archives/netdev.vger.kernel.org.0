Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181E22D3D52
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 09:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgLII3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 03:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgLII3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 03:29:02 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC38C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 00:28:22 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id u19so618111edx.2
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 00:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e8QZINavBB+VN0BfW8HfHmWCOR61uj5ZPA6hU0CJ8os=;
        b=NA0LpKd/sD2TvFZBlYixgWzBT4oOGML6kPm8hfY8UtbZkBlseGfg4qAjhOtyq0QsPG
         yj/0F6ioKwt5FQrvewSrV5KEV1FEH2gvTLueO0cQLLNPyLng7ByxfyfbdehhDMQ8Bshe
         uxlGlnrkqPjSoprK/mMcVCXd+2ck1QNm4rQ7WbjSOrLcl01LQaqSr1ksatmKh+zs0pQH
         QYqCBva46mbIIVfkyLK6IVM2ZJc6DktG98c0tSecfCGWtpyBab1K3VbKBOxSlOnRQMWf
         V3Pud5xVZI4tIe+/OA/Yt15gS9BvmZdiDWY7KhMpgJ3L61tlheBq+jfDcJ1wGXfzZHrx
         RU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e8QZINavBB+VN0BfW8HfHmWCOR61uj5ZPA6hU0CJ8os=;
        b=YkG88GRGWrmDfjRs+uNEmM45tQcYf2/XNkZpCp6ep+CDKKGC7pYtGW6frr5W3Q661b
         sTs0KKNrEHKyu0dmW8wStvghRhd8XvxYlXoxReg/IvEsZ5nXnXxVPb9t98s3Pco1LprW
         1TkWhvytWksq/+/lGNYeidrsQ1b9Vb5PLrl+TGdBO4ZMeqRnG+9/MxqD1AtZk6odrB/7
         UW4oqvG9qdIZOjIzMIceW3AICqlO1VoQ0dn6b8z33EyCN/ybeLdjurfg2DOcXbfTo92g
         vh6QEwjlvjgcu1k80b3Vu6nK/8F4L8BEwUxyfRKcVZq3kWM+cI2JCBu1+qQVlfL2mm9g
         j5ww==
X-Gm-Message-State: AOAM533+cZfkE9W7Fa5osVMM9H/7k+iMvuJRcENvROYCV26qq2eX2Qq2
        RAODu6zLGTsopkN98gsZmVs=
X-Google-Smtp-Source: ABdhPJwMkh/XlynfS2KRt9tBI2gAsr2j9vIID5puVy50RBn5AyKRLomhINUagk9lcTkEbau2l0gIeQ==
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr933047edb.365.1607502501274;
        Wed, 09 Dec 2020 00:28:21 -0800 (PST)
Received: from [132.68.43.153] ([132.68.43.153])
        by smtp.gmail.com with ESMTPSA id ck27sm855428edb.13.2020.12.09.00.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 00:28:20 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
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
 <474d1275-9506-99d3-4f0d-86b482953eee@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <cda4323c-b7e7-05a5-e8d4-5a5b91aef784@gmail.com>
Date:   Wed, 9 Dec 2020 10:28:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <474d1275-9506-99d3-4f0d-86b482953eee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 09/12/2020 3:11, David Ahern wrote:
> On 12/8/20 5:57 PM, David Ahern wrote:
>>> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
>>> index 7338b3865a2a..a08b85b53aa8 100644
>>> --- a/include/net/inet_connection_sock.h
>>> +++ b/include/net/inet_connection_sock.h
>>> @@ -66,6 +66,8 @@ struct inet_connection_sock_af_ops {
>>>   * @icsk_ulp_ops	   Pluggable ULP control hook
>>>   * @icsk_ulp_data	   ULP private data
>>>   * @icsk_clean_acked	   Clean acked data hook
>>> + * @icsk_ulp_ddp_ops	   Pluggable ULP direct data placement control hook
>>> + * @icsk_ulp_ddp_data	   ULP direct data placement private data
>>
>> Neither of these socket layer intrusions are needed. All references but
>> 1 -- the skbuff check -- are in the mlx5 driver. Any skb check that is
>> needed can be handled with a different setting.
> 
> missed the nvme ops for the driver to callback to the socket owner.
> 

Hopefully it is clear that these are needed, and indeed we use them in
both driver and nvme-tcp layers.
