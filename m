Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCDD2A8669
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgKESta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKESta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:49:30 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D334C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:49:30 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id w11so1211721pll.8
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=q+w3k5jN2di578aSMChh/mQCKhd+n6ATh+J9SnSJ33Y=;
        b=Ut1pxuPe+sQAhoYiNa5jpiaplom4pf7VOF5vD9APVZlbxixk+oJSgG8GJV6GWm8rsI
         zwRSvif7pkLID1Qym3w8neNjhjo4StMwUF9cj/rWTheozisWhFqA71O8fEucycy5xh+K
         aDvnWJEirk21FOYYUxQIDO7mY3MvXQM7DzCuFpu8YEOu3uNzPNjOTvKT1eZR98CTewUu
         iOsNmZug4US29MeyF3BBfXiZDARRo60DuOPv/KNIH39cVFfRpWwYWVH4h5oXZF9WThuZ
         LI9RzUwzNJlihHPdz9bThgfuLgJAOyvlM6DM4RCzMDb9pKjo92nZRic45aY6vt7WE5aO
         xv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=q+w3k5jN2di578aSMChh/mQCKhd+n6ATh+J9SnSJ33Y=;
        b=HN4iIvqVeHApdHAGhBQkcYm2oy5sva1MgtjZfdyUkFgYwf9T4t8vIdo5VdUJaEj3Q8
         NVi8LBpW+K0tWSlL67/moTadxABjjxwSLWe+zfQQEQdBOWC5uAuGVn9/q+mSYbi80Zn0
         bKOwW5p2DczLdbbVkgQvB3BIiICdExMkIi5if0xBrWMmH6J9dOereUW3sa3gUj4XWmZ/
         Rn0882SrP+Mc+coM7iPKBlxbWEpwCAL48M064ghheU5nbeBudIZi0rY7nyR/thmoWyNW
         UrLnYIxUmHAhDP1Z0AmLgXtTjSBLHFGWTKfgC1IpetqGEr9T+VS0Ao1CvHreehkVHWuw
         h4xA==
X-Gm-Message-State: AOAM533qpjnbhF+zARj9q7ZwK9fudhIOoZKeztpHqiT8mhteoshTKMka
        /TmLiANPQDp6X/26E9kifEdRJg==
X-Google-Smtp-Source: ABdhPJw7u7FC/B46AtGmVwbQe6lb4xIsA46Utab6O1WTzi+KB/sUYmk/8TuyXYAAebtc/cEpGou6yQ==
X-Received: by 2002:a17:90a:bc4c:: with SMTP id t12mr3614158pjv.163.1604602170043;
        Thu, 05 Nov 2020 10:49:30 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id e14sm3051897pgv.64.2020.11.05.10.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 10:49:29 -0800 (PST)
Subject: Re: [PATCH net-next 4/6] ionic: batch rx buffer refilling
To:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
References: <20201104223354.63856-1-snelson@pensando.io>
 <20201104223354.63856-5-snelson@pensando.io>
 <f0e95c596be3ebcaf862486af4977a1fb00e8896.camel@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <712741a2-e51c-cd6d-34fa-d9163e776cfe@pensando.io>
Date:   Thu, 5 Nov 2020 10:49:28 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <f0e95c596be3ebcaf862486af4977a1fb00e8896.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 5:08 PM, Saeed Mahameed wrote:
> On Wed, 2020-11-04 at 14:33 -0800, Shannon Nelson wrote:
>> We don't need to refill the rx descriptors on every napi
>> if only a few were handled.  Waiting until we can batch up
>> a few together will save us a few Rx cycles.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_dev.h    |  4 +++-
>>   .../net/ethernet/pensando/ionic/ionic_txrx.c   | 18 ++++++++++----
>> ----
>>   2 files changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> index 6c243b17312c..9064222a087a 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> @@ -12,8 +12,10 @@
>>   
>>   #define IONIC_MAX_TX_DESC		8192
>>   #define IONIC_MAX_RX_DESC		16384
>> -#define IONIC_MIN_TXRX_DESC		16
>> +#define IONIC_MIN_TXRX_DESC		64
>>   #define IONIC_DEF_TXRX_DESC		4096
>> +#define IONIC_RX_FILL_THRESHOLD		64
> isn't 64 a bit high ? 64 is the default napi budget
>
> Many drivers do this with bulks of 8/16 but I couldn't find any with
> higher numbers.
>
> also, just for a reference, GRO and XDP they bulk up to 8. but not
> more.
>
> IMHO i think you need to relax the re-fill threshold a bit.

Yeah, the work being done internally on tuning has been a bit 
aggressive, I can dial this back a bit.
sln

>
>> +#define IONIC_RX_FILL_DIV		8
>>
> ...
>
>> -	if (work_done)
>> +	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
>> +				  cq->num_descs / IONIC_RX_FILL_DIV);
>> +	if (work_done && ionic_q_space_avail(cq->bound_q) >=
>> rx_fill_threshold)
>>   		ionic_rx_fill(cq->bound_q);
>>   
>

