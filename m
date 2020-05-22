Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0381DEC79
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbgEVPwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgEVPwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:52:41 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35B2C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:52:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so5106818pjh.2
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iYzhD6uZPlMEc3WIgQqT7GWOopGSEfVEV6GBHXrL0VM=;
        b=Lc1NJ7jEL5HiVHDMcmw5CUoxzZmKCMm8s2LcMIaA20qERQn4Z5AKrWmaSyRtggfzIn
         hidv1OCRCmBJrNTSVW19XmhpETpzvsIAnlO1+sXb5q0dohm7scXdp9RTG5JZqOn8OW2b
         OTTRHhzhB5IqJn6dsS5U44voGcGscRH2oin7a74+jC2IC0PWQ+XinA/JQV8vQMj13OA6
         XBhddF43jjuZKbLh1dqPgAZUz6vBoKJozyOj3pT6IGELe7dEqID284TOei1p+OMtKFDQ
         Q8iHRLWqiwiINjvMBX77rKdMPAgE9SG1LS1wJ57IO7in069+bm5Tbqg7DppEQ6A3Dks1
         aXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iYzhD6uZPlMEc3WIgQqT7GWOopGSEfVEV6GBHXrL0VM=;
        b=sE1GiOI6lp9d43PcY2qj1FVUum+guT1/3lfEDAABqlvroCpfJT/Pi3c52jtNZf6TCW
         1ozX06NwW0eKF3cEkQ/YjSPeeMFT+YTqcjLjY5lmr96vETWAxcQD5K7KNQk1kjw1LxKW
         X17qZeFKLCTXPX3j5F9JUfmeANeRhEkG2Ng7fW9aF0D4lz43loQoXUfg7i5PLIl0OxKg
         qTSs8isNYdwjGr9RWbh8q1Ga+JI1XlSLpcNlJU6SavPxDxZ1bnkseAyzfeDZ+8G5Kiid
         TQduehvvybOxsxLf+6G+BZyfqrzuoz3nne8duOflMzDIz+NeRhyk3AF6Scut89Xav6bj
         JDHA==
X-Gm-Message-State: AOAM531RcJzoSrq9BUuWmZTrO3Zud1zRaoe8riK6O0e5Jj5rIHrIM1WC
        LN8mvS9NGsvUgDZygz8tFzg=
X-Google-Smtp-Source: ABdhPJymAG3RVIRCNQJQ9ArnTOGTbeoOgZDuU3KwY3O9zWY2TT7j0Pl0dAr58t85b8VLD2k6Vl3I/Q==
X-Received: by 2002:a17:90b:1942:: with SMTP id nk2mr5511411pjb.54.1590162759701;
        Fri, 22 May 2020 08:52:39 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j2sm7446177pfb.73.2020.05.22.08.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 08:52:38 -0700 (PDT)
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Xin Long <lucien.xin@gmail.com>, Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com
References: <20200521182958.163436-1-edumazet@google.com>
 <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
 <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com>
 <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
 <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <806eda1a-de5a-22f3-b5bf-3189878b8b55@gmail.com>
Date:   Fri, 22 May 2020 08:52:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/20 11:18 PM, Xin Long wrote:
> On Fri, May 22, 2020 at 1:55 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> Resend to the list in non HTML form
>>
>>
>> On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
>>>
>>>
>>>
>>> On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>>
>>>> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
>>>>>
>>>>> dst_cache_get() documents it must be used with BH disabled.
>>>> Interesting, I thought under rcu_read_lock() is enough, which calls
>>>> preempt_disable().
>>>
>>>
>>> rcu_read_lock() does not disable BH, never.
>>>
>>> And rcu_read_lock() does not necessarily disable preemption.
> Then I need to think again if it's really worth using dst_cache here.
> 
> Also add tipc-discussion and Jon to CC list.
> 
> Thanks.

What improvements you got with your patch ?

Disabling BH a bit earlier wont make any difference.

