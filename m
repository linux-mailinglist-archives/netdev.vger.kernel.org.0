Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2963B1DF159
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgEVVhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:37:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41443 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731033AbgEVVhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590183450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E24ZouQ9jJceKrygtK/GICuJNARqV+f7CtZWQ0XgxeM=;
        b=CesJ/mNNvh0arJ5VALWT8RVu0TJ3b1ABvXQZok4ZtVy8RUct09X7xa0DnP+ly4QRMT+tKJ
        DJRRs+G/e8Hjpsei6Zg+ohFmrSRRgfDku0iYaN10SurwvozGbZz4LIPeGW7d3yRBNfeBYY
        mKF0C2LMfSAv144aq1FnTmtC8IbjiRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-ErxWQ-xvMlOlu9AQnPxYPg-1; Fri, 22 May 2020 17:37:26 -0400
X-MC-Unique: ErxWQ-xvMlOlu9AQnPxYPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32EAF19067E3;
        Fri, 22 May 2020 21:37:25 +0000 (UTC)
Received: from [10.10.117.121] (ovpn-117-121.rdu2.redhat.com [10.10.117.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DA3B6EA3C;
        Fri, 22 May 2020 21:37:24 +0000 (UTC)
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
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
 <2084be57-be94-6630-5623-2bd7bd7b7da2@gmail.com>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <400644e2-7dac-103c-a07a-88287b1905d5@redhat.com>
Date:   Fri, 22 May 2020 17:37:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2084be57-be94-6630-5623-2bd7bd7b7da2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/20 4:10 PM, Eric Dumazet wrote:
>
> On 5/22/20 12:47 PM, Jon Maloy wrote:
>>
>> On 5/22/20 11:57 AM, Eric Dumazet wrote:
>>> On 5/22/20 8:01 AM, Jon Maloy wrote:
>>>> On 5/22/20 2:18 AM, Xin Long wrote:
>>>>> On Fri, May 22, 2020 at 1:55 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>> Resend to the list in non HTML form
>>>>>>
>>>>>>
>>>>>> On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>> On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>>>>>> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>>>> dst_cache_get() documents it must be used with BH disabled.
>>>>>>>> Interesting, I thought under rcu_read_lock() is enough, which calls
>>>>>>>> preempt_disable().
>>>>>>> rcu_read_lock() does not disable BH, never.
>>>>>>>
>>>>>>> And rcu_read_lock() does not necessarily disable preemption.
>>>>> Then I need to think again if it's really worth using dst_cache here.
>>>>>
>>>>> Also add tipc-discussion and Jon to CC list.
>>>> The suggested solution will affect all bearers, not only UDP, so it is not a good.
>>>> Is there anything preventing us from disabling preemtion inside the scope of the rcu lock?
>>>>
>>>> ///jon
>>>>
>>> BH is disabled any way few nano seconds later, disabling it a bit earlier wont make any difference.
>> The point is that if we only disable inside tipc_udp_xmit() (the function pointer call) the change will only affect the UDP bearer, where dst_cache is used.
>> The corresponding calls for the Ethernet and Infiniband bearers don't use dst_cache, and don't need this disabling. So it does makes a difference.
>>
> I honestly do not understand your concern, this makes no sense to me.
>
> I have disabled BH _right_ before the dst_cache_get(cache) call, so has no effect if the dst_cache is not used, this should be obvious.
Forget my comment. I thought we were discussing to Tetsuo Handa's 
original patch, and missed that you had posted your own.
I have no problems with this one.

///jon

>
> If some other paths do not use dst)cache, how can my patch have any effect on them ?
>
> What alternative are you suggesting ?
>

