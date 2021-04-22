Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F24367D8C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbhDVJR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:17:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230270AbhDVJR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:17:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619083044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dfnqIZI1/k9srXG+L4iVerhO0OUgVIkJwi9JJDahJWc=;
        b=HV8IXlwQzE9b9JsKwioCw5QhgE/OzuitRO1qBWSh5C4S2Mh25wYtRZHbbxYJ/SJgZj3eRH
        YjYeRTjP6KEPpsYYxJ7AcB2PHHx95cByhC5niPKF7qAXm+m5mOGboEZlNxMP11LtXmd1IG
        Dw856TMaCmjx6JVfm7Yae3SdaNhe7hQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-V2H2OZd8NKmA7JFs8TCUaw-1; Thu, 22 Apr 2021 05:17:16 -0400
X-MC-Unique: V2H2OZd8NKmA7JFs8TCUaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA074107ACE6;
        Thu, 22 Apr 2021 09:17:14 +0000 (UTC)
Received: from [10.36.113.72] (ovpn-113-72.ams2.redhat.com [10.36.113.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B3CD59474;
        Thu, 22 Apr 2021 09:17:13 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Davide Caratti" <dcaratti@redhat.com>
Cc:     "Pravin B Shelar" <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Sabrina Dubroca" <sd@queasysnail.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] openvswitch: fix stack OOB read while fragmenting
 IPv4 packets
Date:   Thu, 22 Apr 2021 11:17:10 +0200
Message-ID: <4E05D4E9-556B-4CDF-A7AE-232B0A2A52B8@redhat.com>
In-Reply-To: <36693a9a56f1054f55b42b1a25a4c70d3dbb1728.camel@redhat.com>
References: <cover.1618844973.git.dcaratti@redhat.com>
 <94839fa9e7995afa6139b4f65c12ac15c1a8dc2f.1618844973.git.dcaratti@redhat.com>
 <1097839A-30AD-4AE9-859A-4B7C6A3EFA40@redhat.com>
 <36693a9a56f1054f55b42b1a25a4c70d3dbb1728.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21 Apr 2021, at 17:05, Davide Caratti wrote:

> hello Eelco, thanks for looking at this!
>
> On Wed, 2021-04-21 at 11:27 +0200, Eelco Chaudron wrote:
>>
>> On 19 Apr 2021, at 17:23, Davide Caratti wrote:
>>
>>> running openvswitch on kernels built with KASAN, it's possible to 
>>> see
>>> the
>>> following splat while testing fragmentation of IPv4 packets:
>>
>> <SNIP>
>>
>>> for IPv4 packets, ovs_fragment() uses a temporary struct dst_entry.
>>> Then,
>>> in the following call graph:
>>>
>>>   ip_do_fragment()
>>>     ip_skb_dst_mtu()
>>>       ip_dst_mtu_maybe_forward()
>>>         ip_mtu_locked()
>>>
>>> the pointer to struct dst_entry is used as pointer to struct rtable:
>>> this
>>> turns the access to struct members like rt_mtu_locked into an OOB 
>>> read
>>> in
>>> the stack. Fix this changing the temporary variable used for IPv4
>>> packets
>>> in ovs_fragment(), similarly to what is done for IPv6 few lines 
>>> below.
>>>
>>> Fixes: d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received PMTU <
>>> net.ipv4.route.min_pmt")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>>
>> The fix looks good to me, however isn’t the real root cause
>> ip_mtu_locked() who casts struct dst_entry to struct rtable (not even
>> using container_of())?
>
> good point, that's my understanding (and the reason for that 'Fixes:'
> tag). Probably openvswitch was doing this on purpose, and it was "just
> working" until commit d52e5a7e7ca4.
>
> But at the current state, I see much easier to just fix the IPv4 part 
> to
> have the same behavior as other "users" of ip_do_fragment(), like it
> happens for ovs_fragment() when the packet is IPv6 (or br_netfilter
> core, see [1]).
>
> By the way, apparently ip_do_fragment() already assumes that a struct
> rtable is available for the skb [2]. So, the fix in ovs_fragment() 
> looks
> safer to me. WDYT?

It looks like the assumption that a dst_entry is always embedded in 
rtable seems deeply embedded already, looking at skb_rtable(), so I 
agree this patch is the best solution.

So again, Acked-by: Eelco Chaudron <echaudro@redhat.com>

