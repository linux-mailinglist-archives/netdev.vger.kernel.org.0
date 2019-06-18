Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17A5497ED
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 06:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfFREIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 00:08:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40846 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFREIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 00:08:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so5123420pla.7
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 21:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dKrKCxF0RsiNuMGHoaZXRrGrN0Ri+A/IA8N+vAw2+tc=;
        b=ea/eMCIYDGb6BtTOlmIfG5Do8Bag9htcUvq6qF3Lko5zo8xStHMTzo1+WTNxKm5UWN
         RlnOOotKaYqH/Ffw3W36RbNsD5ZaT8H/fGO7g9ylXid065vj3QNg833ISgq61dPFLurq
         H0JlXCaRvY+nxkcu47I1MYANoFNSvDj7Mp1lDVzBS7EQMZGA6nvMiNzD1o1rfjNou82u
         qfnJ280KAhFvOgO2L0ru9f6YZCiHqySKckTu7fmKjKP4iE0FpJ3bVGxgD7iWh8z13d55
         Zro5Eyk4q72KVstgM1TVywNk+w2J/yTwqVQxxbIjFbRk/6cXZJmZC4svUDSbcIWW3FQz
         B4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKrKCxF0RsiNuMGHoaZXRrGrN0Ri+A/IA8N+vAw2+tc=;
        b=YK1yN/9oEwXApDMQfeWRLfS8fBMMzXbhWJOKU7JDeb6JDK8ybFJXnbJK7xAcIdbunX
         vxexAZrHqHRyve7wNiunRq21oz8PoPHB45LtT5uUZ6O1HDlahhGtaqUIZWFp3k+ZthWz
         VJLDmxN0Fn1Oc4eLZEZ40c4Nj3KqyW3HLZPD+EzAnDDJqRTMmujFvkSej4iisrZZyhBn
         L9pOOY7C6bjn4ySTx58JlMJTa5Ozzi1ChhaStj7tqLXdy8CqcAmmzZVl/FqOKDM3qAyY
         YgLGgtAVwAtubwcms1Jx9OcWYCw/TdiUaycCEK0neGxZqDHrrzT5WkwfEr9YW7h+zPdB
         E/Yw==
X-Gm-Message-State: APjAAAW1JLgV6GvLmFVqwAYSXBKuvhlI9b8pyVau6nWd6gw6YjDYLhxa
        5nHwDke96N+GtwPM8Xp1E+k=
X-Google-Smtp-Source: APXvYqzitUN3M0Ji0VB2KtNQ6sCQLI8KdUZYegMJY5I9jUllyOwBc20mfHK3RAIyT8gwI2CSNSeEBg==
X-Received: by 2002:a17:902:8ec7:: with SMTP id x7mr35459279plo.224.1560830920762;
        Mon, 17 Jun 2019 21:08:40 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id u5sm12389299pgp.19.2019.06.17.21.08.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 21:08:38 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <aa0af451-5e7c-7d83-ef25-095a67cd23a1@gmail.com>
 <CALMXkpYs8KN0DmXV+37grbS0Y4Q-DAM-_GVZy+qWi2dtV+cDPA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e072881f-a676-f98b-19fd-4eb3315ad0f3@gmail.com>
Date:   Mon, 17 Jun 2019 21:08:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpYs8KN0DmXV+37grbS0Y4Q-DAM-_GVZy+qWi2dtV+cDPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/19 8:53 PM, Christoph Paasch wrote:
> On Mon, Jun 17, 2019 at 8:44 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 6/17/19 8:19 PM, Christoph Paasch wrote:
>>>
>>> Yes, this does the trick for my packetdrill-test.
>>>
>>> I wonder, is there a way we could end up in a situation where we can't
>>> retransmit anymore?
>>> For example, sk_wmem_queued has grown so much that the new test fails.
>>> Then, if we legitimately need to fragment in __tcp_retransmit_skb() we
>>> won't be able to do so. So we will never retransmit. And if no ACK
>>> comes back in to make some room we are stuck, no?
>>
>> Well, RTO will eventually fire.
> 
> But even the RTO would have to go through __tcp_retransmit_skb(), and
> let's say the MTU of the interface changed and thus we need to
> fragment. tcp_fragment() would keep on failing then, no? Sure,
> eventually we will ETIMEOUT but that's a long way to go.

Also I want to point that normal skb split for not-yet transmitted skbs
does not use tcp_fragment(), with one exception (the one you hit)

Only the first skb in write queue can possibly have payload in skb->head
and might go through tcp_fragment()

Other splits will use tso_fragment() which does not enforce sk_wmem_queued limits (yet)

So things like TLP should work.
