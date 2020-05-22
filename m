Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA541DF027
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgEVTrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:47:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41067 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbgEVTrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590176842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YdS6AOeSWK0jUYamTi9EOv+S8oDpX9oHz8NpRLwzlnY=;
        b=R760oobLu3k/+/nyswzlZNI3In4W8//cIe1tFSTbFhFLDidJXsDP4I/Wifj0lIKRVoeCDT
        AVKxjRbGjGSaNlMXyWAQABbG3MU2ndB19mXdyfUmYhPVPT6LgtZoQNjyhAXPU/Mo+7lWwn
        DtxhUXYDRJeyvMHUBa0arXA/nshjmuY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-ZIOObcwIP0SER6T9XB6ipQ-1; Fri, 22 May 2020 15:47:18 -0400
X-MC-Unique: ZIOObcwIP0SER6T9XB6ipQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F9C6107ACCA;
        Fri, 22 May 2020 19:47:17 +0000 (UTC)
Received: from [10.10.117.121] (ovpn-117-121.rdu2.redhat.com [10.10.117.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CA3160E1C;
        Fri, 22 May 2020 19:47:16 +0000 (UTC)
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
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <bebc5293-d5be-39b5-8ee4-871dd3aa7240@redhat.com>
Date:   Fri, 22 May 2020 15:47:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <217375c0-d49d-63b1-0628-9aaf7e4e42d0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/20 11:57 AM, Eric Dumazet wrote:
>
> On 5/22/20 8:01 AM, Jon Maloy wrote:
>>
>> On 5/22/20 2:18 AM, Xin Long wrote:
>>> On Fri, May 22, 2020 at 1:55 PM Eric Dumazet <edumazet@google.com> wrote:
>>>> Resend to the list in non HTML form
>>>>
>>>>
>>>> On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>
>>>>> On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>>>> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>> dst_cache_get() documents it must be used with BH disabled.
>>>>>> Interesting, I thought under rcu_read_lock() is enough, which calls
>>>>>> preempt_disable().
>>>>> rcu_read_lock() does not disable BH, never.
>>>>>
>>>>> And rcu_read_lock() does not necessarily disable preemption.
>>> Then I need to think again if it's really worth using dst_cache here.
>>>
>>> Also add tipc-discussion and Jon to CC list.
>> The suggested solution will affect all bearers, not only UDP, so it is not a good.
>> Is there anything preventing us from disabling preemtion inside the scope of the rcu lock?
>>
>> ///jon
>>
> BH is disabled any way few nano seconds later, disabling it a bit earlier wont make any difference.
The point is that if we only disable inside tipc_udp_xmit() (the 
function pointer call) the change will only affect the UDP bearer, where 
dst_cache is used.
The corresponding calls for the Ethernet and Infiniband bearers don't 
use dst_cache, and don't need this disabling. So it does makes a 
difference.
///jon

>
> Also, if you intend to make dst_cache BH reentrant, you will have to make that for net-next, not net tree.
>
> Please carefully read include/net/dst_cache.h
>
> It is very clear about BH requirements.
>
>

