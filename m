Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8DD1E32BB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404455AbgEZWfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404443AbgEZWfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:35:31 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D2BC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:35:30 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u12so1197367wmd.3
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yfz2Tr4KtrpyVKx4kb4q5OXuR9ZQK/ojaTpFq5fPWX4=;
        b=UJtriJFmNaLWhX0Ekk8tWQv9pNGXv4l2gwHiRPn/DkQ3RFqcyJgmIzxOFQazK82gs1
         XHJfATOEhi/bsL7Cyqwvbb8GPGMcJUFrvIfGzRJ+67KFPxrVFPYPmyTSsP2OKBvSaptB
         ZI0Keu4wPYRZzAQyz2ctd5Or4B6tEZpnHk0Fw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yfz2Tr4KtrpyVKx4kb4q5OXuR9ZQK/ojaTpFq5fPWX4=;
        b=qqETPIpumgBs4qxctn/QclrtCqtFzqZdhZzWdrVDcsw+K6xSK5Xcei5OfQI16r2p8f
         RzxYW7Usrh4E1USr3nlSNJoO4OERd2geOVkXHi9bSh5DU+xmyUofEX3MYSzgOXx0jl30
         Ja+ZzO0BI7T4Z8SziSbYjX4ZUMt7aQoE6wbLC0OLX+tGoc/YqBKVVLpZljUlqQIW7WuP
         ZRV4fBSyPzwUALX1GvDv+JCm0AqFTJaCj2h/OrRBHmIIdnROuluQyqA8nMcxsQPfCzkp
         4ZRb12v+BQcaIFrgVGzdDp4DuKomIpNzrV+4s7kasLjHEIdWVkvFHkPeQP7ixrtCQF1g
         xHlw==
X-Gm-Message-State: AOAM532F9lPltos6MfIikZtwtGnMkzHHyAjbhP8+xcTxjU0g3zI2sUqZ
        vGfhg10VHKSECUyHZxeCfb5ELre5GCTAqQ==
X-Google-Smtp-Source: ABdhPJwYYP+8s55srz9qx0R+3XEaL8Ex3+8gL1iVOjSv5TORUoG9SBL1ENmstz2HysPsQ/U4yRvM5g==
X-Received: by 2002:a1c:790a:: with SMTP id l10mr1190126wme.80.1590532529127;
        Tue, 26 May 2020 15:35:29 -0700 (PDT)
Received: from [192.168.0.112] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id z9sm1052363wrp.66.2020.05.26.15.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 15:35:28 -0700 (PDT)
Subject: Re: [PATCH net 0/5] nexthops: Fix 2 fundamental flaws with nexthop
 groups
To:     David Miller <davem@davemloft.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dahern@digitalocean.com
References: <20200526150114.41687-1-dsahern@kernel.org>
 <20200526.152800.1859140520396255826.davem@davemloft.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <cb09aeab-9d34-6f83-5c59-d798cb6b2de7@cumulusnetworks.com>
Date:   Wed, 27 May 2020 01:35:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526.152800.1859140520396255826.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 1:28 AM, David Miller wrote:
> From: David Ahern <dsahern@kernel.org>
> Date: Tue, 26 May 2020 09:01:09 -0600
> 
>> From: David Ahern <dahern@digitalocean.com>
>>
>> Nik's torture tests have exposed 2 fundamental mistakes with the initial
>> nexthop code for groups. First, the nexthops entries and num_nh in the
>> nh_grp struct should not be modified once the struct is set under rcu.
>> Doing so has major affects on the datapath seeing valid nexthop entries.
>>
>> Second, the helpers in the header file were convenient for not repeating
>> code, but they cause datapath walks to potentially see 2 different group
>> structs after an rcu replace, disrupting a walk of the path objects.
>> This second problem applies solely to IPv4 as I re-used too much of the
>> existing code in walking legs of a multipath route.
>>
>> Patches 1 is refactoring change to simplify the overhead of reviewing and
>> understanding the change in patch 2 which fixes the update of nexthop
>> groups when a compnent leg is removed.
>>
>> Patches 3-5 address the second problem. Patch 3 inlines the multipath
>> check such that the mpath lookup and subsequent calls all use the same
>> nh_grp struct. Patches 4 and 5 fix datapath uses of fib_info_num_path
>> with iterative calls to fib_info_nhc.
>>
>> fib_info_num_path can be used in control plane path in a 'for loop' with
>> subsequent fib_info_nhc calls to get each leg since the nh_grp struct is
>> only changed while holding the rtnl; the combination can not be used in
>> the data plane with external nexthops as it involves repeated dereferences
>> of nh_grp struct which can change between calls.
>>
>> Similarly, nexthop_is_multipath can be used for branching decisions in
>> the datapath since the nexthop type can not be changed (a group can not
>> be converted to standalone and vice versa).
>>
>> Patch set developed in coordination with Nikolay Aleksandrov. He did a
>> lot of work creating a good reproducer, discussing options to fix it
>> and testing iterations.
>>
>> I have adapted Nik's commands into additional tests in the nexthops
>> selftest script which I will send against -next.
> 
> Series applied and queued up for -stable, thanks David.
> 

Dave this was v1, there were some whitespace errors which were fixed
in v2: http://patchwork.ozlabs.org/project/netdev/list/?series=179428


