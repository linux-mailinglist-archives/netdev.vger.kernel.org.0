Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC016139051
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgAMLop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:44:45 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29723 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbgAMLoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 06:44:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578915883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xbmiE7SY+fBHFcH04ZWzxFBnS2F/540t7NKmUNMrr4Q=;
        b=TJxSmKIiKxsAebEHNplTc+rVE1/EOykyTMlTBr75eeEJdFAsetB4UgWmRUyyW2NxJr7QIb
        rTTKzmuuzZdiWt6MWelqLaHZ4aaePq5eh+lRPkuacyAwtHqfFESlTsoZIhCC6AFZ5YEtSX
        kcJxgVmiucXWJJSzUDtprjp8pSyy6M0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-mgVQeogDOtW0n37pREtFKQ-1; Mon, 13 Jan 2020 06:44:41 -0500
X-MC-Unique: mgVQeogDOtW0n37pREtFKQ-1
Received: by mail-lj1-f200.google.com with SMTP id j23so1877045lji.23
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 03:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xbmiE7SY+fBHFcH04ZWzxFBnS2F/540t7NKmUNMrr4Q=;
        b=jq+OyyQ4Do2IjfH2CAfC+SCVjH92AeUlZNqCSrFzd7Whvf7ojcKtojSObfKOK3cl4S
         bxN9RwBOvQI3gbtAZf1UolbPv9+yDqtDKTGfSv1KnYQFfqBEFTIDu/9mjtUxQ4672G7b
         igM766c4fyD/O5kp1vk0afXt1iU+k00FNsqF+jYV/Kx8bWWd7OfnOKVpGOpJyeRaiz3w
         +A7GLf84hTbZPg2pF0oyvLnX2x4IZsjW1CGo5fcXeQ7y83NorA2tqp++zqZUzzGaJ63a
         Ss7mrk3fAhVChS5itC2VbSLgdkHJJ8EV0dslNCrvjseGqS967hqP4Y4WN5bvaRJ7BnaT
         kk5A==
X-Gm-Message-State: APjAAAW9F7T5olrmoXGudDYo13GI8aSW/9z8BnjmxRyLmMBuRCEPTp8c
        F4pnE7zV34q+nkT+unJfEj3jLFT017INBOCPazzxFNFShGbk3uur3wLz3w4RhdYnmqi3TB2vwMB
        9aPGvA5J/LTK9O6oV
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr10408828ljm.68.1578915880476;
        Mon, 13 Jan 2020 03:44:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqzKtx+j98eK647oeBa3CCnjxTV9+G20YrkAgRnR4Cz/0nv59+gfcHS27SnJhToDYaHagAlIMw==
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr10408816ljm.68.1578915880298;
        Mon, 13 Jan 2020 03:44:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a15sm5627067lfi.60.2020.01.13.03.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 03:44:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CACEB1804D6; Mon, 13 Jan 2020 12:44:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, gautamramk@gmail.com
Cc:     netdev@vger.kernel.org,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: sched: add Flow Queue PIE packet scheduler
In-Reply-To: <20200112173624.5f7b754b@cakuba>
References: <20200110062657.7217-1-gautamramk@gmail.com> <20200110062657.7217-3-gautamramk@gmail.com> <20200112173624.5f7b754b@cakuba>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 13 Jan 2020 12:44:38 +0100
Message-ID: <87eew3wpg9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 10 Jan 2020 11:56:57 +0530, gautamramk@gmail.com wrote:
>> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
>> 
>> Principles:
>>   - Packets are classified on flows.
>>   - This is a Stochastic model (as we use a hash, several flows might
>>                                 be hashed on the same slot)
>>   - Each flow has a PIE managed queue.
>>   - Flows are linked onto two (Round Robin) lists,
>>     so that new flows have priority on old ones.
>>   - For a given flow, packets are not reordered.
>>   - Drops during enqueue only.
>>   - ECN capability is off by default.
>>   - ECN threshold is at 10% by default.
>>   - Uses timestamps to calculate queue delay by default.
>> 
>> Usage:
>> tc qdisc ... fq_pie [ limit PACKETS ] [ flows NUMBER ]
>>                     [ alpha NUMBER ] [ beta NUMBER ]
>>                     [ target TIME us ] [ tupdate TIME us ]
>>                     [ memory_limit BYTES ] [ quantum BYTES ]
>>                     [ ecnprob PERCENTAGE ] [ [no]ecn ]
>>                     [ [no]bytemode ] [ [no_]dq_rate_estimator ]
>> 
>> defaults:
>>   limit: 10240 packets, flows: 1024
>>   alpha: 1/8, beta : 5/4
>>   target: 15 ms, tupdate: 15 ms (in jiffies)
>>   memory_limit: 32 Mb, quantum: device MTU
>>   ecnprob: 10%, ecn: off
>>   bytemode: off, dq_rate_estimator: off
>
> Some reviews below, but hopefully someone who knows more about qdiscs
> will still review :)

I looked it over, and didn't find anything you hadn't already pointed
out below. It's pretty obvious that this started out as a copy of
sch_fq_codel. Which is good, because that's pretty solid. And bad,
because that means it introduces another almost-identical qdisc without
sharing any of the code...

I think it would be worthwhile to try to consolidate things at some
point. Either by just merging code from fq_{codel,pie}, but another
option would be to express fq_codel and fq_pie using the fq{,_impl}.h
includes. Maybe even sch_cake as well, but that may take a bit more
work. Not sure if we should require this before merging fq_pie, or just
leave it as a possible enhancement for later? WDYT?

-Toke

