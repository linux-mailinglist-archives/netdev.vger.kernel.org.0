Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003FE1E64DE
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403777AbgE1O4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391323AbgE1Oz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:55:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3B2C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:55:58 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s8so28185491wrt.9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EneWOSiakfCEBaGnxTPG1pDLBtx0joXUVr4u5ehgW3o=;
        b=E48ktRuxhpbVEBsogPQwIhCX+QdVASFipvgGxF9Jh2+6mBhSWXz+xMMaAOTNP6CyPe
         9ztFbUVfCr/1IU06ipTsV+cU/HKxibCQAiBxazot2AGMjqj/UtJjY5b/6cyFlG0FktES
         CjEqaPrDQ3Zwh3yN54NVP7gE5yXe1oyl6Wgz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EneWOSiakfCEBaGnxTPG1pDLBtx0joXUVr4u5ehgW3o=;
        b=hddBHWG1i7pj2G9dUHZFcMxzwpfIJ5XtxBe5iJaVuuRwLHXVCMP/8tTvtYZ44/nq/e
         5KhVyrWYxumMoDZkxAxfjA3ogmdgRU/5yvYQs0MRlN6qcAaf37bDDwMwiO8MqApm69Dh
         lUTZU8aYWCf/3K9V9Y4Peh8krccN4bwyOSXqp34Qq1ncd08QJ46wg8kCrgNcx0MD9UvI
         g+SsY5VHMxgDEOn+nDJSNjGtAUYoaQf2qlKYbtcg5gkt2St+VOXmqJoDbI6SdpgETJSC
         yIv5R6AYPqZ3979Lo/i5zm2OqSRi136EJygUW00i+MNKuk0NJk+SRjP6XrOqfr8zm1RE
         6NEw==
X-Gm-Message-State: AOAM5323y3936H3CjNJCsZ/fMDCwlqpmApoN06KstJ+eJlDcHR3CbpZ2
        gg25dKTzPxG/Sx8n4zWsoy2brg==
X-Google-Smtp-Source: ABdhPJzQUq72JztGH2vQBnYxdj0ih8RSMgb5VMRbG33nWrvt2fkhWG9C9dpWueI/PvK7ArgQjpCE8Q==
X-Received: by 2002:a05:6000:1192:: with SMTP id g18mr4141547wrx.326.1590677757388;
        Thu, 28 May 2020 07:55:57 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id y37sm7276009wrd.55.2020.05.28.07.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 07:55:56 -0700 (PDT)
Subject: Re: [PATCH][net-next] nexthop: fix incorrect allocation failure on
 nhg->spare
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Colin King <colin.king@canonical.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200528145114.420100-1-colin.king@canonical.com>
 <8b73e872-c05e-e93f-1d2d-3466da4ddbcc@cumulusnetworks.com>
Message-ID: <b0852a83-c3a5-a1be-6554-dc035e5b3d6e@cumulusnetworks.com>
Date:   Thu, 28 May 2020 17:55:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8b73e872-c05e-e93f-1d2d-3466da4ddbcc@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/05/2020 17:53, Nikolay Aleksandrov wrote:
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

Wait - that should be targeted at -net, that's where the fixes went.
And the fixes tag is wrong, nhg->spare was very recently added by:
commit 90f33bffa382
Author: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date:   Tue May 26 12:56:15 2020 -0600

    nexthops: don't modify published nexthop groups

