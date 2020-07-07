Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A069216AF7
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 13:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgGGLCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 07:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgGGLCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 07:02:02 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C74C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 04:02:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k4so2446669pld.12
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 04:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=onylQPnJ7kvkeI3KTBBiKnzU8j0ODNRNeq1rJYIc8vU=;
        b=GSL5nbf0hLwD4OEpvGhyZBiBZI+2AGc2qPF2d/6d5H6JH846RqZz//H1P5Ldcv+AwR
         GGf/AtKu0cJP5YUsvwniMn11pGrB2a88uT2rZgSkBmlblOBy/xegdTutMXvRoOxgn26b
         YfMY7AujOJtSXtvWl3dUISBEAKo0L8rAFEsFmS/GgXzDO84vWGFEpXfBOcK0TZluduga
         t2BkvXKucweypCMoCW3q+DD4XI5vdNFQSSgLXDMpncL/L3wfxlSH1gkYGGmfAeVbfYL1
         LOAE04vbHc8RDSlpQvafUZ5C6yHrzUWcmjExpgImbOF8PYSLRaxV3fDvitsMNS2adem3
         zBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=onylQPnJ7kvkeI3KTBBiKnzU8j0ODNRNeq1rJYIc8vU=;
        b=tR3Oif7vdZ1jzO3CEwzolhdspexCZq1hpS74hAym4VPANFNmT2lYk2LvYneqBRW37O
         Kl6IqheWv2kPFMk/rAaAe2QnWEM+e04I2DSVIbnepIasmccCIFDtFZBgd8VIhPuBDGpD
         S98c7PhG1p6i5gzX+27cpdhlYZkwED5feAX0y0Fe59TvIFPQvFxYvIf5Qq2n8MiYwkC2
         TI6yAfOj448ANNgTOAOq+iDeVqEyE3ginkAx+yQRzRvDpFBxjvBEwSZgm832xsfKGWxI
         Znab4Tn85uBsZVXErekI0d3rZXoSoipUB6PRUHZlHibIBKcNgzoyTY5Sa0HjuEPkSiNl
         4eLA==
X-Gm-Message-State: AOAM533qxb4DpSITtodd9KhTMEBJRWcdSA2eSxGlu8HdNPrlcigocFDo
        HtZCndOib7NagstIUmIYxzU=
X-Google-Smtp-Source: ABdhPJwdKGtHliAlygqbbEXV4aGH4JlIlfy4+kAastq0+iyTmtDmbx7/cL7Y23i1pulXJf+aLlit8w==
X-Received: by 2002:a17:90a:ebc7:: with SMTP id cf7mr3737739pjb.207.1594119722143;
        Tue, 07 Jul 2020 04:02:02 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id v15sm695817pgo.15.2020.07.07.04.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 04:02:01 -0700 (PDT)
Subject: Re: [PATCH net] vlan: consolidate VLAN parsing code and limit max
 parsing depth
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200706122951.48142-1-toke@redhat.com>
 <234d54c2-5b34-7651-5e57-490bee9920ae@gmail.com> <87d057lhhw.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <0baaad68-843a-c929-38e8-6448ce2ca1a8@gmail.com>
Date:   Tue, 7 Jul 2020 20:01:49 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <87d057lhhw.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/07/07 19:57, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
> 
>> On 2020/07/06 21:29, Toke Høiland-Jørgensen wrote:
>>> Toshiaki pointed out that we now have two very similar functions to extract
>>> the L3 protocol number in the presence of VLAN tags. And Daniel pointed out
>>> that the unbounded parsing loop makes it possible for maliciously crafted
>>> packets to loop through potentially hundreds of tags.
>>>
>>> Fix both of these issues by consolidating the two parsing functions and
>>> limiting the VLAN tag parsing to an arbitrarily-chosen, but hopefully
>>> conservative, max depth of 32 tags. As part of this, switch over
>>> __vlan_get_protocol() to use skb_header_pointer() instead of
>>> pskb_may_pull(), to avoid the possible side effects of the latter and keep
>>> the skb pointer 'const' through all the parsing functions.
>>>
>>> Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>>> Reported-by: Daniel Borkmann <daniel@iogearbox.net>
>>> Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesses in the presence of VLANs")
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> ---
>> ...
>>> @@ -623,13 +597,12 @@ static inline __be16 __vlan_get_protocol(struct sk_buff *skb, __be16 type,
>>>    			vlan_depth = ETH_HLEN;
>>>    		}
>>>    		do {
>>> -			struct vlan_hdr *vh;
>>> +			struct vlan_hdr vhdr, *vh;
>>>    
>>> -			if (unlikely(!pskb_may_pull(skb,
>>> -						    vlan_depth + VLAN_HLEN)))
>>> +			vh = skb_header_pointer(skb, vlan_depth, sizeof(vhdr), &vhdr);
>>
>> Some drivers which use vlan_get_protocol to get IP protocol for checksum offload discards
>> packets when it cannot get the protocol.
>> I guess for such users this function should try to get protocol even if it is not in skb header?
>> I'm not sure such a case can happen, but since you care about this, you know real cases where
>> vlan tag can be in skb frags?
> 
> skb_header_pointer() will still succeed in reading the data, it'll just
> do so by copying it into the buffer on the stack (vhdr) instead of
> moving the SKB data itself around...

True, probably I need some more coffee...
Thanks.

Toshiaki Makita
