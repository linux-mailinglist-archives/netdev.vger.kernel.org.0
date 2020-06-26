Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573C720B30A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 16:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgFZOBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 10:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZOBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 10:01:17 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07605C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 07:01:17 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id i3so7462648qtq.13
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 07:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HO4p58ORst5W8qA42RbOpW92Il/GHyxKM6KGm+qxVWI=;
        b=1g1UdR6TTj7czu47PsNRELfN0CcOfzv2X+Q2JjOTZ+3yNF60ICYESX7PO6tr6YbeFR
         mkYHpgQh9rATEs1qfJFaTLuqdm12hSVDbqEzJ+rw4QvzOmHnTvELVA4Z6t07JwBxSWpL
         8y43xtyb6KGyM2QfZpmUS5P91tXTV7lgVt4zJ2rukVHgKeut0wHSfzQgDLHJQPikwK0/
         MZ7lU8KR9vD74XjCcNbFSB5yNro0Jwjx+XJ+mp2F0RJ8XeyBn7m3P/AyGtSXxh0Ew44p
         89EKT4tjXaQL7Dwi1KqJFLeFAFQqJp0uuAOAepl8DnBtDOiiJOzEv72llVAeZnSfOXB6
         kISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HO4p58ORst5W8qA42RbOpW92Il/GHyxKM6KGm+qxVWI=;
        b=Cvcy9evb827Nf35BwbRBmR/T+AyjjCYH5H0NvLRGVkYBcqm0LeZIdk5K/swIMubDNS
         mNBsmVI5lgmiIgSoDwyYG3v8nv38TBVz4qbhKzePid4ZL+vQaOH36/RVJ15jf8hpHhX3
         1Zh0VODflSF4efTUGzPdiEIUn9ZNI9PasCJeaCwJtISN/yPxHRntmDdDmsjF5oMsaDzO
         VMaYoohOEZc5jAwnU9mv9Yo8DdsqJXjbHLQ0kzO60EMmDF1J1DXb7MX3+mFW4qWCFIE2
         mdNfZOrGryqLUK49t3W2XwBihUdDwf04iQBLhiKhozgW2sV5YDY9lwSbowLRaOMaC7al
         AqpQ==
X-Gm-Message-State: AOAM530yCTmu+c5YiMGjpxAi17ZKHPqtR1n9rSqtkoZDMmYKmH3WT2xu
        9HWdFGCq2rUcdQACctWklvQgbA==
X-Google-Smtp-Source: ABdhPJxp7jaKNW24pIjwOE8fK+lnF3StntdFGKpsgjHQwQEZh/fUp5BPURYaQzv0OmPsQxQG95qqaw==
X-Received: by 2002:ac8:32cf:: with SMTP id a15mr2978542qtb.241.1593180075841;
        Fri, 26 Jun 2020 07:01:15 -0700 (PDT)
Received: from [192.168.1.117] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id u205sm8111628qka.81.2020.06.26.07.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 07:01:14 -0700 (PDT)
Subject: Re: [Cake] [PATCH net-next 1/5] sch_cake: fix IP protocol handling in
 the presence of VLAN tags
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@netronome.com>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
 <159308610390.190211.17831843954243284203.stgit@toke.dk>
 <20200625.122945.321093402617646704.davem@davemloft.net>
 <87k0zuj50u.fsf@toke.dk>
 <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com>
 <87h7uyhtuz.fsf@toke.dk>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <f5a648fc-7255-846e-6ecd-d21eeeb56b5d@mojatatu.com>
Date:   Fri, 26 Jun 2020 10:01:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87h7uyhtuz.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-26 8:52 a.m., Toke Høiland-Jørgensen wrote:
> Davide Caratti <dcaratti@redhat.com> writes:
> 
>> hello,
>>
>> my 2 cents:
>>
>> On Thu, 2020-06-25 at 21:53 +0200, Toke Høiland-Jørgensen wrote:
>>> I think it depends a little on the use case; some callers actually care
>>> about the VLAN tags themselves and handle that specially (e.g.,
>>> act_csum).
>>
>> I remember taht something similar was discussed about 1 year ago [1].
> 
> Ah, thank you for the pointer!
> 
>>> Whereas others (e.g., sch_dsmark) probably will have the same
>>> issue.
>>
>> I'd say that the issue "propagates" to all qdiscs that mangle the ECN-CE
>> bit (i.e., calling INET_ECN_set_ce() [2]), most notably all the RED
>> variants and "codel/fq_codel".
> 
> Yeah, I think we should fix INET_ECN_set_ce() instead of re-implementing
> it in CAKE. See below, though.
> 
>>>   I guess I can trying going through them all and figuring out if
>>> there's a more generic solution.
>>
>> For sch_cake, I think that the qdisc shouldn't look at the IP header when
>> it schedules packets having a VLAN tag.
>>
>> Probably, when tc_skb_protocol() returns ETH_P_8021Q or ETH_P_8021AD, we
>> should look at the VLAN priority (PCP) bits (and that's something that
>> cake doesn't do currently - but I have a small patch in my stash that
>> implements this: please let me know if you are interested in seeing it :)
>> ).
>>
>> Then, to ensure that the IP precedence is respected, even with different
>> VLAN tags, users should explicitly configure TC filters that "map" the
>> DSCP value to a PCP value. This would ensure that configured priority is
>> respected by the scheduler, and would also be flexible enough to allow
>> different "mappings".
> 
> I think you have this the wrong way around :)
> 
> I.e., classifying based on VLAN priority is even more esoteric than
> using diffserv markings, so that should not be the default. Making it
> the default would also make the behaviour change for the same traffic if
> there's a VLAN tag present, which is bound to confuse people. I suppose
> it could be an option, but not really sure that's needed, since as you
> say you could just implement it with your own TC filters...
> 
>> Sure, my proposal does not cover the problem of mangling the CE bit
>> inside VLAN-tagged packets, i.e. if we should understand if qdiscs
>> should allow it or not.
> 
> Hmm, yeah, that's the rub, isn't it? I think this is related to this
> commit, which first introduced tc_skb_protocol():
> 
> d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
> 

I didnt quiet follow the discussion - but the patch you are referencing
was to fix an earlier commit which had broken things (we didnt
have the "fixes" tag back then).

> That commit at least made the behaviour consistent across
> accelerated/non-accelerated VLANs. However, the patch description
> asserts that 'tc code .. expects vlan protocol type [in skb->protocol]'.
> Looking at the various callers, I'm not actually sure that's true, in
> the sense that most of the callers don't handle VLAN ethertypes at all,
> but expects to find an IP header. This is the case for at least:
> 
> - act_ctinfo
> - act_skbedit
> - cls_flow
> - em_ipset
> - em_ipt
> - sch_cake
> - sch_dsmark
> 
> In fact the only caller that explicitly handles a VLAN ethertype seems
> to be act_csum; and that handles it in a way that also just skips the
> VLAN headers, albeit by skb_pull()'ing the header.
> 

The earlier change broke a few things unfortunately. There was a more
recent discussion with Simon Horman that i cant find now on breakage
with some classifiers in presence of double vlans.
+cc Simon maybe he can find the discussion.

> cls_api, em_meta and sch_teql don't explicitly handle it; but returning
> the VLAN ethertypes to those does seem to make sense, since they just
> pass the value somewhere else.
> 
> So my suggestion would be to add a new helper that skips the VLAN tags
> and finds the L3 ethertype (i.e., basically cake_skb_proto() as
> introduced in this patch), then switch all the callers listed above, as
> well as the INET_ECN_set_ce() over to using that. Maybe something like
> 'skb_l3_protocol()' which could go into skbuff.h itself, so the ECN code
> can also find it?
> 
> Any objections to this? It's not actually clear to me how the discussion
> you quoted above landed; but this will at least make things consistent
> across all the different actions/etc.
> 

I didnt follow the original discussion - will try to read in order
to form an opinion.

cheers,
jamal
