Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72273B200E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 20:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFWSNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 14:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWSNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 14:13:54 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F32FC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 11:11:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v20-20020a05600c2154b02901dcefb16af0so1941338wml.5
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 11:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XBlv8NiP6/DwcyhYKfK/uYFycyRVLzO7JXgHfeuzcoY=;
        b=kMYWAF13F/Sfc4vWxsQm0Dh7SX5iJ0h08gyc0PDPOGFGSIuSReqLoQx9bVEjQ2MPkl
         RQBHha8F0CrSh/BVcne6ZN6N5+xk8gqkDgzPp9a172yaw5GX1nDkISjVwFIW/ck/x4Qg
         /xG6m8DRggqTFtHoxvz3il6AP8mkIRm3MbzPSeJdtYLA/CgvbP331NVmbcOLUfciN/sD
         a63+KLilp1Ki7n4A/5ZAR9IQAIVkwdmuOlBemKoa3DWdrjiBEpeuVvhQdRHk8874IZLE
         W6wBsTUG5EzgArad0fqWDlqKX8uqjLZWMWetOkicN8dGBk/ZsNyU4Fq7tZs33TTd7zwg
         PTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XBlv8NiP6/DwcyhYKfK/uYFycyRVLzO7JXgHfeuzcoY=;
        b=ZYuhLsjdjAKHz+FyqFdl1DC230sxJZD7nQACZkrlE6nScLbsq5TL+3sxMA5wc+OJgr
         kBBOjVlbZQSwFu1GZdJ6l0dh9dW5g1RkMuQ8ek/NrLEadwbActeeiRG9Fx/SqmYREmYB
         Yl9+4m6IYVo6li29ZjuSRos7PCbTSdzux1/N4EA9W8KFzeokNmXEHvuC/R7frj5PCHwL
         Sn1sgBrhSUA+EpqEZ8T9HDDA/CFueffbObZm4qDdtIAR8bO/LZUTFa+fnkRDgaVV+NJi
         8RNV3qaNixULO062Zcf7m1eFtqI6M6kBUddMSPO+Z5EgGJwXymsTXTSymTgHS7UXZzvj
         Htxw==
X-Gm-Message-State: AOAM531ymU5YVxU8FAY50JUq5ttv7tWhghiq/AH+ORbfpPDovocQiJwz
        tdCDBMk6kuAaoV0miBa5w7g=
X-Google-Smtp-Source: ABdhPJzKD/nc0KS3S9jOBgCHoQyORnXpS0hpj/Pg3TFNsY2MhJdk0TxIQmGSt8O0OWaIVKoc7/f38g==
X-Received: by 2002:a7b:c187:: with SMTP id y7mr12011765wmi.13.1624471895782;
        Wed, 23 Jun 2021 11:11:35 -0700 (PDT)
Received: from [192.168.98.98] (8.249.23.93.rev.sfr.net. [93.23.249.8])
        by smtp.gmail.com with ESMTPSA id x10sm761944wru.58.2021.06.23.11.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 11:11:35 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net: ip: avoid OOM kills with large UDP sends
 over loopback
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
References: <20210623162328.2197645-1-kuba@kernel.org>
 <d4de9fa3-3170-af6e-719a-4c809dca81b4@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <46125ca5-3d88-788e-d347-438818e08a0a@gmail.com>
Date:   Wed, 23 Jun 2021 20:11:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <d4de9fa3-3170-af6e-719a-4c809dca81b4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 8:05 PM, Eric Dumazet wrote:
> 
> 
> On 6/23/21 6:23 PM, Jakub Kicinski wrote:
>> Dave observed number of machines hitting OOM on the UDP send
>> path. The workload seems to be sending large UDP packets over
>> loopback. Since loopback has MTU of 64k kernel will try to
>> allocate an skb with up to 64k of head space. This has a good
>> chance of failing under memory pressure. What's worse if
>> the message length is <32k the allocation may trigger an
>> OOM killer.
>>
>> This is entirely avoidable, we can use an skb with page frags.
>>
>> af_unix solves a similar problem by limiting the head
>> length to SKB_MAX_ALLOC. This seems like a good and simple
>> approach. It means that UDP messages > 16kB will now
>> use fragments if underlying device supports SG, if extra
>> allocator pressure causes regressions in real workloads
>> we can switch to trying the large allocation first and
>> falling back.
>>
>> Reported-by: Dave Jones <dsj@fb.com>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> Thanks !
> 

I am taking this back.

IPv6 side also needs to account for sizeof(struct frag_hdr) ?
