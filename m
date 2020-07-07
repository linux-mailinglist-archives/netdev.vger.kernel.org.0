Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A153216AC1
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgGGKte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgGGKte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 06:49:34 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C23EC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 03:49:34 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ch3so3168961pjb.5
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 03:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1nlpBrQdimOv9euyk7fsu1kody/DGWqimCvsJCErFxQ=;
        b=VKkSMsVlZjtdO1f1DBoGKkkEAHsxNH1lb3bII3lGdO7lz8v4+3BLz/bxJAaMqaIyx6
         ugE4ah+wDWBRUBMXzM+tY4Fxe+ji1jv7/zpM9+MhFOqt8OFMHMjohiNGAKnSiveQu3W6
         P/z3aDxf7mQt1lsuaq8ReQ5GFtzZdHXRss3QCa3eYCFuc/7KK1F9+eOv4wY+HHqBSrmc
         UIWFvEoww+t+x1NZN1Zv6HHuR3TWWgLbkjsg7KMvf/ZT9x7tnMFH5YFxjNIi24RPguln
         m5miUTvy1tgTTQXF0T0G8Hknz/0Wj1cRR3/EjtRj5IYiSNIQOLPdPFQTasfKyYIHPHBO
         qefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1nlpBrQdimOv9euyk7fsu1kody/DGWqimCvsJCErFxQ=;
        b=kp7koYPibiWHtZM0vNQpgtHBjCJY0DFx15AEnkNQYrh0EgTSThAyd6Iv1zsFb+pfwm
         JFXsD5wzgfsIXVT/rO54ZuzBTH/jySa6/EG/UBfOLAs6xIhEDUdPePzgbbSNxysHTV2T
         TFlcDrfn4ZQLM0d5kPwPc7uEo40fW81r1+so+mE4eZYHbS+YPl4ZZtqlobz/t5dAoP1m
         Gsa/dkPGTGhqNe0SIlJAlMERod/3KatepiPS2yniYZsphf4jNnO2XaxG2WIb3WPQuAiK
         jl9ePGHhTnP4CDgxjSr3oGgaF//Xd8V8RHXwE2ZVVSOXSpfKBLQdkaDvKaxuBspkMnrm
         eQqw==
X-Gm-Message-State: AOAM530XKGDLeaVzBMhdgLBm3Y0nHgqRP6+ZyKqGVSOyMN4VGKep2gj/
        ftbHT/Hek+n5tVWHWmxyx9BF9R9f
X-Google-Smtp-Source: ABdhPJw47EVZWmQYocIFxL6vJhSs+rY2R3X/xfAAOX6hn1GU3eC4CM5RXJNnBz3jBU4BmCVCO3y52A==
X-Received: by 2002:a17:902:b714:: with SMTP id d20mr33104696pls.318.1594118973768;
        Tue, 07 Jul 2020 03:49:33 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id n12sm563256pgr.88.2020.07.07.03.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 03:49:33 -0700 (PDT)
Subject: Re: [PATCH net] vlan: consolidate VLAN parsing code and limit max
 parsing depth
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20200706122951.48142-1-toke@redhat.com>
 <4f7b2b71-8b2a-3aea-637d-52b148af1802@iogearbox.net> <87lfjwl0w7.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <934a694b-ae3f-8247-c979-3d062b9804e4@gmail.com>
Date:   Tue, 7 Jul 2020 19:49:23 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <87lfjwl0w7.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/07/07 7:44, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 7/6/20 2:29 PM, Toke Høiland-Jørgensen wrote:
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
>>>    include/linux/if_vlan.h | 57 ++++++++++++++++-------------------------
>>>    1 file changed, 22 insertions(+), 35 deletions(-)
>>>
>>> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
>>> index 427a5b8597c2..855d16192e6a 100644
>>> --- a/include/linux/if_vlan.h
>>> +++ b/include/linux/if_vlan.h
>>> @@ -25,6 +25,8 @@
>>>    #define VLAN_ETH_DATA_LEN	1500	/* Max. octets in payload	 */
>>>    #define VLAN_ETH_FRAME_LEN	1518	/* Max. octets in frame sans FCS */
>>>    
>>> +#define VLAN_MAX_DEPTH	32		/* Max. number of nested VLAN tags parsed */
>>> +
>>
>> Any insight on limits of nesting wrt QinQ, maybe from spec side?
> 
> Don't think so. Wikipedia says this:
> 
>   802.1ad is upward compatible with 802.1Q. Although 802.1ad is limited
>   to two tags, there is no ceiling on the standard limiting a single
>   frame to more than two tags, allowing for growth in the protocol. In
>   practice Service Provider topologies often anticipate and utilize
>   frames having more than two tags.
> 
>> Why not 8 as max, for example (I'd probably even consider a depth like
>> this as utterly broken setup ..)?
> 
> I originally went with 8, but chickened out after seeing how many places
> call the parsing function. While I do agree that eight tags is... somewhat
> excessive... I was trying to make absolutely sure no one would hit this
> limit in normal use. See also https://xkcd.com/1172/ :)

Considering that XMIT_RECURSION_LIMIT is 8, I also think 8 is sufficient.

Toshiaki Makita
