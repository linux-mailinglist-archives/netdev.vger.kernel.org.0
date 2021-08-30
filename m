Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF0B3FB3C9
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 12:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhH3KVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 06:21:17 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:47878 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233248AbhH3KVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 06:21:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UmapFNZ_1630318819;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UmapFNZ_1630318819)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 30 Aug 2021 18:20:20 +0800
Subject: Re: [PATCH] net: fix NULL pointer reference in cipso_v4_doi_free
To:     Paul Moore <paul@paul-moore.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
 <CAHC9VhRJtU48Zt7dUEaTvKRoO+ODki75rS-hdJ0HPBrPRmCfxQ@mail.gmail.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <29171cda-0b6c-b6a9-0123-f356610d0ed4@linux.alibaba.com>
Date:   Mon, 30 Aug 2021 18:20:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRJtU48Zt7dUEaTvKRoO+ODki75rS-hdJ0HPBrPRmCfxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Paul

I'm sorry for missing this mail since my stupid filter rules...

Will send a new one soon as you suggested :-)

Regards,
Michael Wang

On 2021/8/27 上午8:09, Paul Moore wrote:
[snip]
>>
>> Reported-by: Abaci <abaci@linux.alibaba.com>
>> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
>> ---
>>
>>  net/ipv4/cipso_ipv4.c | 18 ++++++++++--------
>>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> Thanks for the problem report.  It's hard to say for certain due to
> the abbreviated backtrace without line number information, but it
> looks like the problem you are describing is happening when the
> allocation for doi_def->map.std fails near the top of
> netlbl_cipsov4_add_std() which causes the function to jump the
> add_std_failure target which ends up calling cipso_v4_doi_free().
> 
>   doi_def = kmalloc(sizeof(*doi_def), GFP_KERNEL);
>   if (doi_def == NULL)
>     return -ENOMEM;
>   doi_def->map.std = kzalloc(sizeof(*doi_def->map.std), GFP_KERNEL);
>   if (doi_def->map.std == NULL) {
>     ret_val = -ENOMEM;
>     goto add_std_failure;
>   }
>   ...
>   add_std_failure:
>     cipso_v4_doi_free(doi_def);
> 
> Since the doi_def allocation is not zero'd out, it is possible that
> the doi_def->type value could have a value of CIPSO_V4_MAP_TRANS when
> the doi_def->map.std allocation fails, causing the NULL pointer deref
> in cipso_v4_doi_free().  As this is the only case where we would see a
> problem like this, I suggest a better solution would be to change the
> if-block following the doi_def->map.std allocation to something like
> this:
> 
>   doi_def->map.std = kzalloc(sizeof(*doi_def->map.std), GFP_KERNEL);
>   if (doi_def->map.std == NULL) {
>     kfree(doi_def);
>     return -ENOMEM;
>   }
> 
>> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
>> index 099259f..7fbd0b5 100644
>> --- a/net/ipv4/cipso_ipv4.c
>> +++ b/net/ipv4/cipso_ipv4.c
>> @@ -465,14 +465,16 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
>>         if (!doi_def)
>>                 return;
>>
>> -       switch (doi_def->type) {
>> -       case CIPSO_V4_MAP_TRANS:
>> -               kfree(doi_def->map.std->lvl.cipso);
>> -               kfree(doi_def->map.std->lvl.local);
>> -               kfree(doi_def->map.std->cat.cipso);
>> -               kfree(doi_def->map.std->cat.local);
>> -               kfree(doi_def->map.std);
>> -               break;
>> +       if (doi_def->map.std) {
>> +               switch (doi_def->type) {
>> +               case CIPSO_V4_MAP_TRANS:
>> +                       kfree(doi_def->map.std->lvl.cipso);
>> +                       kfree(doi_def->map.std->lvl.local);
>> +                       kfree(doi_def->map.std->cat.cipso);
>> +                       kfree(doi_def->map.std->cat.local);
>> +                       kfree(doi_def->map.std);
>> +                       break;
>> +               }
>>         }
>>         kfree(doi_def);
>>  }
>> --
>> 1.8.3.1
>>
> 
> 
