Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27D4C9439
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 00:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfJBWV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 18:21:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35775 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJBWVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 18:21:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id 205so409699pfw.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 15:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cOP3b02NaXtSwyjyzUPLAZuhEYqEJoCTiGkKoJPVbdI=;
        b=hQlxsdBwHtMpuWdtHhRwc1SF7dUWA6fviSZKHGNu81vBAAJgEoSCihWBtq3SoR9f+c
         0Ap9H3N9/Fe9vAY9gPhFa4A0FYAjOAtfugGwz39YtXAOE4MET0WP47i2xAs+tWS7uynl
         wygVnH9iD9Yf7pCsB8IHlkxCxXeAg8XEfM+SSpFVMxgoMHPbtkstm3Ju8PgI3epJVztw
         GF3X2BydG5OXAaflK2Q3tUi+HdoHK79bzoru40Q6JvQM3ipYyLX/uG82y9yzY0se5Sf9
         CRPa/tlYge8exM77+t7ICLG6pqYzT9cR6VDMyMDVeO43EEPo6ZHafk2CD0Rrt46mVuaQ
         j6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cOP3b02NaXtSwyjyzUPLAZuhEYqEJoCTiGkKoJPVbdI=;
        b=cPeTZPN5OflRbjiW7ckvTf1d6On2tpMtut41pj1ZvGORXMmwNDf0WMfRx5DjUC6nfW
         FNKEyrvaBx0PWOte0G9IQRusjeuaF3JA57DTlYqWiKx35zlcH99jaHkbZsTNYwHmPB5h
         qDDBtt567cRHSOPEkrtqQpe+rC9Kbu3mMWPsuLT+1RUIagA0njnIwEtuL6leccrTOfMU
         qjO7X+bb5MIV6h5cU1jU5irQqDhaXpjr0XKJviU7XlsXmwHDxKMOC45x2uyvTftf574x
         i+ggy/tmnm8X0uvZNEZVI6L3HkgITHCGo9lLCXshf5igxQ/xz+EPobClzRsh51zSW0E4
         E7KQ==
X-Gm-Message-State: APjAAAU9SncK238wtmzN+2zgkAGkSfupku1mF+xOLIuPxLsySE1rOLgm
        3ZUgc03HkaJofZ0RleJBKpc=
X-Google-Smtp-Source: APXvYqxSOnvH0Yi9/mDv5GPynab9prbVz1mokk/xdUn35hwJO3aMwwJYym0FERf6OQpyjGfGSEpGRA==
X-Received: by 2002:a63:c7:: with SMTP id 190mr5900634pga.186.1570054915020;
        Wed, 02 Oct 2019 15:21:55 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id c11sm470808pfj.114.2019.10.02.15.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 15:21:53 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
Date:   Wed, 2 Oct 2019 15:21:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/19 3:13 PM, David Ahern wrote:
> On 10/2/19 3:23 PM, Eric Dumazet wrote:
>>
>>
>> On 10/2/19 2:08 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 10/1/19 11:18 AM, Eric Dumazet wrote:
>>>>
>>>>
>>>> On 9/30/19 8:28 PM, David Ahern wrote:
>>>>> From: David Ahern <dsahern@gmail.com>
>>>>>
>>>>> Rajendra reported a kernel panic when a link was taken down:
>>>>>
>>>>> [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
>>>>> [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
>>>>>
>>>>> <snip>
>>>>>
>>>>
>>>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>>>>
>>>> Thanks !
>>>>
>>>
>>> Apparently this patch causes problems. I yet have to make an analysis.
> 
> Ugh. I presume syzbot? can you forward the stack trace?

No syzbot this time, but complete lack of connectivity on some of my test hosts.

Incoming IPv6 packets go to ip6_forward() (!!!) and are dropped there.

There seems to be something missing.

ifp->state stays at INET6_IFADDR_STATE_PREDAD instead of INET6_IFADDR_STATE_DAD

