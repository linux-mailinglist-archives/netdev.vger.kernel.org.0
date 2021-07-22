Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD503D2342
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhGVLiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 07:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhGVLiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 07:38:00 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59652C0613C1
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 05:18:32 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id k27so6517504edk.9
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 05:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=07cpZ8YXhgBRoS8i+yJRb4ht/zHLP6T8D2WCZ5P2C8w=;
        b=Ymgq6CwnPbOe24khedsPWCtBiZiih7YgXzefpp98rM13Yz5GGB1MiSKpLTxwA12ITF
         9du7IKiMPg+ZQsrDh6GfxqorPgbqC42ZkXKY7D3dh7GV295xy3yPKkyewPQ2Urp7QS5g
         Ig82gj/y2Bim0yXXR7bCcVu6SQESoMUbMuyW8fNgM1DJI4HGGsOwO9IumdX5N+dqCW/v
         7XOS222PbhSsi2Vs71Udp2y+nYK+QuSdAguNhpnpCmcqtdC/pi6ogBVvt2l4H0MZ+3wt
         kxRhFidcrCAzisjYhtK9sYdEfCl3EhBDMgDap/7e3OmEupF840A6acclV2RL6rIuoNnb
         JS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=07cpZ8YXhgBRoS8i+yJRb4ht/zHLP6T8D2WCZ5P2C8w=;
        b=DgnTFF/mvK/zJmXAXKr++aCJsc55mnH3c4LiB153uN/xFNWYbgwkZJxiIPfrIU5W9s
         Q9AqJ2WWh6Tb4FQOqp/AyaO3EmPVphjdjgoWPRo+dChCdK/IjB9ie5xVyDbHoIQAJuoL
         EXQfDA1AkDbyedYattWPkDYb0AqyWFTe+vxMBAeqWgr7v7Tj45VafjpuddA9dNH/NuBZ
         c9+zUMVXozv0rXygDRpmVXvcBMk4R9BQUAwHzdS15+9jBzGuAzulM2gfGHU+vtXeuWya
         iGLHyqB2CMcNeYIkP8wqSdlTmdYZUPgmuYGzbiCAhATHHzT364fkmoROqsDoUVjZVyAa
         h8CA==
X-Gm-Message-State: AOAM532D0X3C97AxO7ZCLttlyvTcHQNQyms3wTjnK46DMGicPiVOC/tW
        6jnnpl9jPIt3A0Kx6D5lW08=
X-Google-Smtp-Source: ABdhPJz0X1+vAR9/jhOxqLG8dGit74B4LTXootW0dP5dyUrRd7lr5d0LJACQh/fR7CLLJRjGAWsNYQ==
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr53622221edu.221.1626956311075;
        Thu, 22 Jul 2021 05:18:31 -0700 (PDT)
Received: from [132.68.43.152] ([132.68.43.152])
        by smtp.gmail.com with ESMTPSA id q26sm5184390ejs.115.2021.07.22.05.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 05:18:30 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 01/36] net: Introduce direct data placement
 tcp offload
To:     Eric Dumazet <edumazet@google.com>,
        Boris Pismenny <borisp@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210722110325.371-2-borisp@nvidia.com>
 <CANn89iLP4yXDK9nOq6Lxs9NrfAOZ6RuX5B5SV0Japx50KvnEyQ@mail.gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <7fdb948a-6411-fce5-370f-90567d2fe985@gmail.com>
Date:   Thu, 22 Jul 2021 15:18:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLP4yXDK9nOq6Lxs9NrfAOZ6RuX5B5SV0Japx50KvnEyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2021 14:26, Eric Dumazet wrote:
> On Thu, Jul 22, 2021 at 1:04 PM Boris Pismenny <borisp@nvidia.com> wrote:
>>
>> From: Boris Pismenny <borisp@mellanox.com>
>>
>>
> ...
> 
>>  };
>>
>>  const char
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index e6ca5a1f3b59..4a7160bba09b 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -5149,6 +5149,9 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
>>                 memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
>>  #ifdef CONFIG_TLS_DEVICE
>>                 nskb->decrypted = skb->decrypted;
>> +#endif
>> +#ifdef CONFIG_ULP_DDP
>> +               nskb->ddp_crc = skb->ddp_crc;
> 
> Probably you do not want to attempt any collapse if skb->ddp_crc is
> set right there.
> 

Right.

>>  #endif
>>                 TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
>>                 if (list)
>> @@ -5182,6 +5185,11 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
>>  #ifdef CONFIG_TLS_DEVICE
>>                                 if (skb->decrypted != nskb->decrypted)
>>                                         goto end;
>> +#endif
>> +#ifdef CONFIG_ULP_DDP
>> +
>> +                               if (skb->ddp_crc != nskb->ddp_crc)
> 
> This checks only the second, third, and remaining skbs.
> 

Right, as we handle the head skb above. Could you clarify?

>> +                                       goto end;
>>  #endif
>>                         }
>>                 }
> 
> 
> tcp_collapse() is copying data from small skbs to pack it to bigger
> skb (one page of payload), in case
> of memory emergency/pressure (socket queues are full)
> 
> If your changes are trying to avoid 'needless'  copies, maybe you
> should reconsider and let the emergency packing be done.
> 
> If the copy is not _possible_, you should rephrase your changelog to
> clearly state the kernel _cannot_ access this memory in any way.
> 

The issue is that skb_condense also gets called on many skbs in
tcp_add_backlog and it will identify skbs that went through DDP as ideal
for packing, even though they are not small and packing is
counter-productive as data already resides in its destination.

As mentioned above, it is possible to copy, but it is counter-productive
in this case. If there was a real need to access this memory, then it is
allowed.
