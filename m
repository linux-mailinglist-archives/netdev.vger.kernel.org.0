Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC191DF05F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 22:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbgEVUKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 16:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730893AbgEVUKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 16:10:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59919C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 13:10:06 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id n18so5664511pfa.2
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 13:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=peqwpvf86V3kIG8hI3JQaBVwjt4FuDHv5ohcoNwCSQI=;
        b=oYGxNM2whfOIyNPku+HyGK12RZl9fNz7pwCle50hmAh5wiTnU67IvBSPzziI+s98Nz
         7CDEfRJ8qbO8Lfkz5k4mR/tqp08MPH/rfcbKYWJaD+a2RjDpiZYrBofw6+P06Q4eevEz
         N8A2RWMNkrb6brqx6WlXoajHqEuJmncutmVMdWCQoBj/dw5Bw8mRoA5uudNxIIsnLv3/
         gKv10ZSrE6FVJALIm7F77UCljyOkYYSvTpjwsncIoeUPP2D0kidFXTR2ShsdlVtvfs8A
         fP3dFVBnUWkOynfpx96i0aGfEPYrURNM7/bx73edG028pulHEOjysK/JzqlK8GA/qphn
         zIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=peqwpvf86V3kIG8hI3JQaBVwjt4FuDHv5ohcoNwCSQI=;
        b=sQ/HQ7L2JqVIDh8Gac16MsmVHWboib/gHbPWDS451wbfwQHBmOVfYS3mcFD9+ZddL0
         VY0P0nfaMhI/6DH7F0ve9In6P+h6D+Vr9770ajS8ra83Ge4lNVOj1efX42t5CtVHKnDc
         dlSNot7bb5FKynOeWpcaSx58zntNLhqgoWKjhsAUc5YQf043p0AxJzVtL2gKEK3Vx7Bd
         lCK46KgeqDTuyNTo8VF+OUsncmjD/kH4mq5lLQDMayrdV55t9cENnwNORJq3xv4jF/fn
         06My8kUu3gCyU24HwdA8Ldx7wPwqfCcAAEzIAGjieVudQOCoL+NmV5g1xEuNr8ZzaLwn
         BPxw==
X-Gm-Message-State: AOAM533UJbvPg2vVvHCOAU/FhJtFBhHTwV9OMq5Z+KA4L1RXXNHVJv7l
        yewQcLuxchBab/vJRNRMEvQ=
X-Google-Smtp-Source: ABdhPJxJYI4JfvjyoZ62w1zio3Af1VKWsSymONsBYJWkthI3PPEMa3ky5MAFoK025rMPD/cRWNfWzg==
X-Received: by 2002:a63:5a07:: with SMTP id o7mr15390121pgb.450.1590178205942;
        Fri, 22 May 2020 13:10:05 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id gt10sm7402255pjb.30.2020.05.22.13.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 13:10:05 -0700 (PDT)
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Jon Maloy <jmaloy@redhat.com>, Xin Long <lucien.xin@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net
References: <20200521182958.163436-1-edumazet@google.com>
 <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
 <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com>
 <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
 <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
 <76d02a44-91dd-ded6-c3dc-f86685ae1436@redhat.com>
 <217375c0-d49d-63b1-0628-9aaf7e4e42d0@gmail.com>
 <bebc5293-d5be-39b5-8ee4-871dd3aa7240@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2084be57-be94-6630-5623-2bd7bd7b7da2@gmail.com>
Date:   Fri, 22 May 2020 13:10:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bebc5293-d5be-39b5-8ee4-871dd3aa7240@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/20 12:47 PM, Jon Maloy wrote:
> 
> 
> On 5/22/20 11:57 AM, Eric Dumazet wrote:
>>
>> On 5/22/20 8:01 AM, Jon Maloy wrote:
>>>
>>> On 5/22/20 2:18 AM, Xin Long wrote:
>>>> On Fri, May 22, 2020 at 1:55 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>> Resend to the list in non HTML form
>>>>>
>>>>>
>>>>> On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>
>>>>>> On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>>>>> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>>> dst_cache_get() documents it must be used with BH disabled.
>>>>>>> Interesting, I thought under rcu_read_lock() is enough, which calls
>>>>>>> preempt_disable().
>>>>>> rcu_read_lock() does not disable BH, never.
>>>>>>
>>>>>> And rcu_read_lock() does not necessarily disable preemption.
>>>> Then I need to think again if it's really worth using dst_cache here.
>>>>
>>>> Also add tipc-discussion and Jon to CC list.
>>> The suggested solution will affect all bearers, not only UDP, so it is not a good.
>>> Is there anything preventing us from disabling preemtion inside the scope of the rcu lock?
>>>
>>> ///jon
>>>
>> BH is disabled any way few nano seconds later, disabling it a bit earlier wont make any difference.
> The point is that if we only disable inside tipc_udp_xmit() (the function pointer call) the change will only affect the UDP bearer, where dst_cache is used.
> The corresponding calls for the Ethernet and Infiniband bearers don't use dst_cache, and don't need this disabling. So it does makes a difference.
>

I honestly do not understand your concern, this makes no sense to me.

I have disabled BH _right_ before the dst_cache_get(cache) call, so has no effect if the dst_cache is not used, this should be obvious.

If some other paths do not use dst)cache, how can my patch have any effect on them ?

What alternative are you suggesting ?
