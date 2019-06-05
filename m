Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3389A35F01
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfFEOSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 10:18:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33920 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfFEOSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 10:18:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id h2so9235678pgg.1;
        Wed, 05 Jun 2019 07:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xb0UsmQULI6WR7q0ULhRKcRjFI8C+kBnZk+wAyAkoSU=;
        b=b5kkb41y+uCLr78Jid7z5Ay1nv9gXJ9YNaZx+WCwRRFUIKusB1ZLiuAyAO9DVBfhpb
         MF75aEIFiq1o8VJqVBPtjsqnv64rH9sx293CkiD0pIpJ+V1RRaLhVCjeshyv/tBK6/DI
         QoMX1U/FFaTRohRCCVQLEp0EuxbpYpBoYlKJ0bfttJWCICtRrwuEIXhS05FucfPJXocs
         KReJkIFSbQlHfsU4/ZkxLRR/9sz0VjZmXQy1Z1UxnOdxB0hAQwtnXZ29AXEqK9BaxCzw
         yiD7Dq3PNR1effPFytKoTyCKkGF9o6MBt1khjXuWLyNN5LyC77pHCN2dEWcwVAPjvZ+M
         yl3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xb0UsmQULI6WR7q0ULhRKcRjFI8C+kBnZk+wAyAkoSU=;
        b=fcm0Op0N7f5blQSvDXhK+GdGdTmpocgQ6gRcyMuGurry26elxveexxrpSq1T3Np8K6
         aLdaw2aD9tugdBR7HhTzhxEXoGDVWU1CF1u5ryJikTquPLd/RkpfngJs3IMgKEBzU1uN
         CLzbg6xiETUoiloP8vty4zt2xo/cpSW2MK5zLlUBe2LvhVSfZ2LnbJA8+CMqnIXE/m9M
         RujgdayLQgrTRvt/3wIthjaj3s35Yk4ec8ijtsrg+Y2RCjT3qVUrtOFx3X34BeSr8+f4
         Hi0o0IutnfNkeLPmFTl0p5TS1y2hJDh+Hv46bPdd4MlPmRcpJQLGGUsBqTML9gR2QHPI
         6hMg==
X-Gm-Message-State: APjAAAXGjAbvNw8yVxUtLB02Zk7nA21wQAtJYuqqyVBly4gXA6nsn0WR
        bfx2uaovJla+6wUaUKnq94tPbQ7b
X-Google-Smtp-Source: APXvYqwukF7AohYHrynpV1p+zi9kA1aS4lMrqcG4KybxbmlPZgGhUw1VPXUo7FaTz950+x6DVkxy2Q==
X-Received: by 2002:a63:31d8:: with SMTP id x207mr4549255pgx.403.1559744327046;
        Wed, 05 Jun 2019 07:18:47 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id o20sm16232250pgj.70.2019.06.05.07.18.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 07:18:46 -0700 (PDT)
Subject: Re: [PATCH net] tcp: avoid creating multiple req socks with the same
 tuples
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Mao Wenan <maowenan@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190604145543.61624-1-maowenan@huawei.com>
 <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
 <40f32663-f100-169c-4d1b-79d64d68a5f9@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <91520bf3-42dd-a727-a706-0ff7711fe1d8@gmail.com>
Date:   Wed, 5 Jun 2019 07:18:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <40f32663-f100-169c-4d1b-79d64d68a5f9@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/19 1:52 AM, Zhiqiang Liu wrote:
> 
> 
> 在 2019/6/4 23:24, Eric Dumazet 写道:
>> On Tue, Jun 4, 2019 at 7:47 AM Mao Wenan <maowenan@huawei.com> wrote:
>>>
>>> There is one issue about bonding mode BOND_MODE_BROADCAST, and
>>> two slaves with diffierent affinity, so packets will be handled
>>> by different cpu. These are two pre-conditions in this case.
> 
>>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>>> --
>>
>> This issue has been discussed last year.
>>
>> I am afraid your patch does not solve all races.
>>
>> The lookup you add is lockless, so this is racy.
>>
>> Really the only way to solve this is to make sure that _when_ the
>> bucket lock is held,
>> we do not insert a request socket if the 4-tuple is already in the
>> chain (probably in inet_ehash_insert())
>>
>> This needs more tricky changes than your patch.
>>
> 
> This kind case is rarely used, and the condition of the issue is strict.
> If we add the "lookup" before or in inet_ehash_insert func for each reqsk,
> overall performance will be affected.
> 
> We may solve the small probability issue with a trick in the tcp_v4_rcv.
> If the ACK is invalid checked by tcp_check_req func, the req could be dropped,
> and then goto the lookup for searching another avaliable reqsk. In this way,
> the performance will not be affected in the normal process.
> 
> The patch is given as following:
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index a2896944aa37..9d0491587ed2 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1874,8 +1874,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
>                         goto discard_and_relse;
>                 }
>                 if (nsk == sk) {
> -                       reqsk_put(req);
> +                       inet_csk_reqsk_queue_drop_and_put(sk, req);
>                         tcp_v4_restore_cb(skb);
> +                       sock_put(sk);
> +                       goto lookup;
>                 } else if (tcp_child_process(sk, nsk, skb)) {
>                         tcp_v4_send_reset(nsk, skb);
>                         goto discard_and_relse;
> 

This is not solving the race.

Please read again my prior emails.

If you want to work on this issue, you have to fix it for good.

Thanks.
