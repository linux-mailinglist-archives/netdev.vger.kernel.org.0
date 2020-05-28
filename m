Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608451E64D6
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391392AbgE1OzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391243AbgE1OzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:55:12 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C954C08C5C6;
        Thu, 28 May 2020 07:55:11 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x12so237622qts.9;
        Thu, 28 May 2020 07:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8fDtT8fxoWMZKuCE4A3ueXu/4+g3beNQHT10KDX2tp4=;
        b=XwLfe/3ameHGyYmFJctvjYyZ/Hrqqdv/LhlnNE9jH36lB9bMhIDDazYPJys17C9F95
         mpws0ttpYW4c+5zkXfs9Eqd1izrUC0d2khJXFbRnuz7QkJ6bSCpGYIyGzDXQm31ohIEY
         ip50hxZattFBxScSoD2C86SrbNS+GqtJt0kiKaaVPI0l4KKLUT217Juam32wKJvdxHLS
         /uU+ARFwalWJnWeglc/lrNy6M6WCjV6w4VeUdNoFpyfByS38Agq6Y+0glXExDy7RCK0o
         zItr5c34ysJAhDgsi+QZD/xwIshd/8Fhs1HCEMjZMtg7tYMHpZBvB/GRXoHAkJhnmjpP
         5C8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8fDtT8fxoWMZKuCE4A3ueXu/4+g3beNQHT10KDX2tp4=;
        b=E/06O7YvpIKA3Q4Dh0x/WqF5NdfxebrFLw2jUTNixWIJalV+mXwnyuVkUf3RpzOh+a
         CU5nL8Hhbli6m0dsh2ZylJthlybZME74XhZSajQ8LRdYM+aaqgPIz1oHUw8ErhTEnlDI
         UwNX2SiyW6/thsTjkPo0lHxJ2yG0Iw5TnOZm9gi0WlFR/qEytthSOWkIz0kZOdoFHBuh
         Mw4z4khuj6KzNF5iAaUjw48OjBcER47+QATN+oc0B83nGGxT9Smyn7Rx6emSm5IJlKGt
         aq40wVUBgX8fEeZJIq23CLrd5XBhB9GNz9+uMzZbPS/Mmq3OzElTCs6jbFfCG7+REUw4
         wHGg==
X-Gm-Message-State: AOAM531jEup6HPxCoo909g2MKBFixfbw4UwsNGsxTSHugazKu0MTP/iA
        wlsjrVwknep6f/ipz9su0BhwNhRcOHY=
X-Google-Smtp-Source: ABdhPJzd+miIG7j3zJsRi4acaIMp0KEZ79MrrFoqs2EUvHOu+NFhJhZeq3D0AgiZcleoNKvhzDUz5Q==
X-Received: by 2002:ac8:754c:: with SMTP id b12mr3514774qtr.282.1590677710647;
        Thu, 28 May 2020 07:55:10 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id g47sm3253687qtk.53.2020.05.28.07.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 07:55:09 -0700 (PDT)
Subject: Re: [PATCH][net-next] nexthop: fix incorrect allocation failure on
 nhg->spare
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Colin King <colin.king@canonical.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200528145114.420100-1-colin.king@canonical.com>
 <8b73e872-c05e-e93f-1d2d-3466da4ddbcc@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c557d49d-b3ab-be82-d879-39f2e2098c47@gmail.com>
Date:   Thu, 28 May 2020 08:55:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <8b73e872-c05e-e93f-1d2d-3466da4ddbcc@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 8:53 AM, Nikolay Aleksandrov wrote:
> On 28/05/2020 17:51, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The allocation failure check for nhg->spare is currently checking
>> the pointer nhg rather than nhg->spare which is never false. Fix
>> this by checking nhg->spare instead.
>>
>> Addresses-Coverity: ("Logically dead code")
>> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  net/ipv4/nexthop.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>> index ebafa5ed91ac..97423d6f2de9 100644
>> --- a/net/ipv4/nexthop.c
>> +++ b/net/ipv4/nexthop.c
>> @@ -1185,7 +1185,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
>>  
>>  	/* spare group used for removals */
>>  	nhg->spare = nexthop_grp_alloc(num_nh);
>> -	if (!nhg) {
>> +	if (!nhg->spare) {
>>  		kfree(nhg);
>>  		kfree(nh);
>>  		return NULL;
>>
> 
> Good catch, embarrassing copy paste error :-/
> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> 

I missed that as well.

Reviewed-by: David Ahern <dsahern@gmail.com>

Patch needs to go to -net
