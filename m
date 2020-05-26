Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B90B1E32C0
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391304AbgEZWhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389755AbgEZWhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:37:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E03CC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:37:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so16731315wrp.2
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eB0kpkMnN+/cz5BBg7GbBwYkQWCeVKvFfizYPKL5Hsc=;
        b=GvaizcJy2I0+CWTo+Cxh1qaTuNjT/vfy/hr1sLDEI130CoFxsnONjE2yWWxJgJVVvm
         jHEzbPMUaLqR9P/XvZiuJ3DiBIBbIlqp1DZaJdcxs8NPD+DkWvTMApcA/2/Kh+qQQqS5
         Ecj99jAd5i1sN3mP0I0ndi2dpwO6kKAWK/T7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eB0kpkMnN+/cz5BBg7GbBwYkQWCeVKvFfizYPKL5Hsc=;
        b=QoE8btJQWMB0TQH2HlBxdjzqlDHqFgAEzHTY77jAO2CAlzYOF/dqIQgnZiaQidL99d
         nNF7MQ2uVP1/9Iffk5gAFtLsHjn8PcofZw+TGzQuuKMVe3BcGJekCzYkxqX9mbH5xliV
         pjjVhk+9UoynhlIOwEjtry39ZFOFxZJMlHt/UV0JA1heikqbz1cEJKMnmEv+bWpqS71i
         FNAgW46FTvuOgBESivBsLjK+ucNjbZo3XB8+j/08kB0vdW6/EgZ6Ogl/GBTHU4ob0g+o
         dTE5aSO/H4Q4LhKpvt+24HP26FZ/9srzCy8t4+UWtc1pYlHvfe0G/ilA7a3dyR48aPVY
         LpJA==
X-Gm-Message-State: AOAM531BS7/555hdwVRRCw1Ve/xcSIGVzuJBe1SvDgfehOjiooMMODsV
        UScFyOpBHOpbfe3niTzzBwf9pg==
X-Google-Smtp-Source: ABdhPJyLx80iokvRKqG26VAtaN2MulyJr1EsxeifOD5trIU+9YcBFQTBuoexK7y7kYDzyOEjdaLbmw==
X-Received: by 2002:a5d:4b4d:: with SMTP id w13mr23358012wrs.178.1590532630826;
        Tue, 26 May 2020 15:37:10 -0700 (PDT)
Received: from [192.168.0.112] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id b185sm1512216wmd.3.2020.05.26.15.37.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 15:37:10 -0700 (PDT)
Subject: Re: [PATCH net 0/5] nexthops: Fix 2 fundamental flaws with nexthop
 groups
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     David Miller <davem@davemloft.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dahern@digitalocean.com
References: <20200526150114.41687-1-dsahern@kernel.org>
 <20200526.152800.1859140520396255826.davem@davemloft.net>
 <cb09aeab-9d34-6f83-5c59-d798cb6b2de7@cumulusnetworks.com>
Message-ID: <1b4441b5-70ba-3462-64af-293ec3955d6e@cumulusnetworks.com>
Date:   Wed, 27 May 2020 01:37:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cb09aeab-9d34-6f83-5c59-d798cb6b2de7@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 1:35 AM, Nikolay Aleksandrov wrote:
> On 5/27/20 1:28 AM, David Miller wrote:
>> From: David Ahern <dsahern@kernel.org>
>> Date: Tue, 26 May 2020 09:01:09 -0600
>>
>>> From: David Ahern <dahern@digitalocean.com>
>>>
>>> Nik's torture tests have exposed 2 fundamental mistakes with the initial
>>> nexthop code for groups. First, the nexthops entries and num_nh in the
>>> nh_grp struct should not be modified once the struct is set under rcu.
>>> Doing so has major affects on the datapath seeing valid nexthop entries.
>>>
>>> Second, the helpers in the header file were convenient for not repeating
>>> code, but they cause datapath walks to potentially see 2 different group
>>> structs after an rcu replace, disrupting a walk of the path objects.
>>> This second problem applies solely to IPv4 as I re-used too much of the
>>> existing code in walking legs of a multipath route.
>>>
>>> Patches 1 is refactoring change to simplify the overhead of reviewing and
>>> understanding the change in patch 2 which fixes the update of nexthop
>>> groups when a compnent leg is removed.
>>>
>>> Patches 3-5 address the second problem. Patch 3 inlines the multipath
>>> check such that the mpath lookup and subsequent calls all use the same
>>> nh_grp struct. Patches 4 and 5 fix datapath uses of fib_info_num_path
>>> with iterative calls to fib_info_nhc.
>>>
>>> fib_info_num_path can be used in control plane path in a 'for loop' with
>>> subsequent fib_info_nhc calls to get each leg since the nh_grp struct is
>>> only changed while holding the rtnl; the combination can not be used in
>>> the data plane with external nexthops as it involves repeated dereferences
>>> of nh_grp struct which can change between calls.
>>>
>>> Similarly, nexthop_is_multipath can be used for branching decisions in
>>> the datapath since the nexthop type can not be changed (a group can not
>>> be converted to standalone and vice versa).
>>>
>>> Patch set developed in coordination with Nikolay Aleksandrov. He did a
>>> lot of work creating a good reproducer, discussing options to fix it
>>> and testing iterations.
>>>
>>> I have adapted Nik's commands into additional tests in the nexthops
>>> selftest script which I will send against -next.
>>
>> Series applied and queued up for -stable, thanks David.
>>
> 
> Dave this was v1, there were some whitespace errors which were fixed
> in v2: http://patchwork.ozlabs.org/project/netdev/list/?series=179428
> 

We can send a simple incremental against this set to fix 'em up. If David
doesn't me beat to it, I'll send a fix tomorrow.

Cheers

