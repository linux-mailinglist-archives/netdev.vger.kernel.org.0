Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48859214F37
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgGEUSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgGEUSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:18:47 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74239C08C5DE
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:18:47 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id e22so32908546edq.8
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uRhTWDkA5o7/NySYW2wL1hIHkuOz93fuM88SRvT6oPE=;
        b=VhN89pSLxTo5PCNoa5b0ZAYAN3W1VGnbgQFtp1/0Qub7yTB/xDgxOX4EHwgSu4DEjR
         3oDNyOo+7FQtZ2sNWL0hYu89xk0VX6MrTNhdx3pETU0uat88BijXNfrm/ZEzRlTfdG3+
         0TL23lZlx2ivaGM67hvR8wLnkK8pNxQaiHDvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uRhTWDkA5o7/NySYW2wL1hIHkuOz93fuM88SRvT6oPE=;
        b=hGU6Apc0WVRwp3R/CjaXTzmnwRbHGEbnAeCEeXn0ZpfZhJ3TSAnoDe2uv7oIvH+GEv
         c8fwgGqwAG6/+huDM3aPgGubUBjQaiMPQ8IOX6AUuhTaSj0FCouZyC1uhzvAbu7NtJtZ
         FqOFzAiyewxqGFCKLEdBBlL/HP798taYxf9afHES/17/YMFPQ86dYRjHapEAVl6+lyS4
         dcdRaeg8G+sOCUBlP464VdRSsWp5ZrmIoTe1Hqtr4P/jVoiyUYsjSaleILF+hT8vPf0W
         Qxu9Zvfvu5qqGg+Ynf23MO5uKu/V7R2tLwRS/nJk2L5AkWbTN4Hvd//i78hlxcctfu8Q
         /uqw==
X-Gm-Message-State: AOAM5333Rdat76fMrB5COAHp0EbOvRoFwVNQj9sFtrnZFKUZp9r6KI9r
        WT4HMrs2p1LBO10fjiIN0KRJtg==
X-Google-Smtp-Source: ABdhPJy8DgylOl1exybBBxo2XdzG9lLnPmUNUH/UsdVCQ0knh9qf825HM839DJdLtEChAsa0TIImzw==
X-Received: by 2002:a50:f418:: with SMTP id r24mr46470686edm.382.1593980325425;
        Sun, 05 Jul 2020 13:18:45 -0700 (PDT)
Received: from [192.168.0.112] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id s14sm20764103edq.36.2020.07.05.13.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:18:44 -0700 (PDT)
Subject: Re: [PATCH net] bridge: mcast: Fix MLD2 Report IPv6 payload length
 check
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        Martin Weinelt <martin@linuxlounge.net>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20200705182234.10257-1-linus.luessing@c0d3.blue>
 <093beb97-87e8-e112-78ad-b3e4fe230cdb@cumulusnetworks.com>
 <20200705190851.GC2648@otheros>
 <4728ef5e-0036-7de6-8b6f-f29885d76473@cumulusnetworks.com>
 <20200705194915.GD2648@otheros>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <15375380-b7ad-985c-6ad3-c86ece996cd0@cumulusnetworks.com>
Date:   Sun, 5 Jul 2020 23:18:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200705194915.GD2648@otheros>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/20 10:49 PM, Linus Lüssing wrote:
> On Sun, Jul 05, 2020 at 10:11:39PM +0300, Nikolay Aleksandrov wrote:
>> On 7/5/20 10:08 PM, Linus Lüssing wrote:
>>> On Sun, Jul 05, 2020 at 09:33:13PM +0300, Nikolay Aleksandrov wrote:
>>>> On 05/07/2020 21:22, Linus Lüssing wrote:
>>>>> Commit e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in
>>>>> igmp3/mld2 report handling") introduced a small bug which would potentially
>>>>> lead to accepting an MLD2 Report with a broken IPv6 header payload length
>>>>> field.
>>>>>
>>>>> The check needs to take into account the 2 bytes for the "Number of
>>>>> Sources" field in the "Multicast Address Record" before reading it.
>>>>> And not the size of a pointer to this field.
>>>>>
>>>>> Fixes: e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling")
>>>>> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
>>>>> ---
>>>>>    net/bridge/br_multicast.c | 2 +-
>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>
>>>> I'd rather be more concerned with it rejecting a valid report due to wrong size. The ptr
>>>> size would always be bigger. :)
>>>>
>>>> Thanks!
>>>> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>>
>>> Aiy, you're right, it's the other way round. I'll update the
>>> commit message and send a v2 in a minute, with your Acked-by
>>> included.
>>>
>>
>> By the way, I can't verify at the moment, but I think we can drop that whole
>> hunk altogether since skb_header_pointer() is used and it will simply return
>> an error if there isn't enough data for nsrcs.
>>
> 
> Hm, while unlikely, the IPv6 packet / header payload length might be
> shorter than the frame / skb size.
> 
> And even though it wouldn't crash reading over the IPv6 packet
> length, especially as skb_header_pointer() is used, I think we should
> still avoid reading over the size indicated by the IPv6 header payload
> length field, to stay protocol compliant.
> 
> Does that make sense?
> 

Sure, I just thought the ipv6_mc_may_pull() call after that includes those 2 bytes as well, so
we're covered. That is, it seems to be doing the same check with the full grec size included.

