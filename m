Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D1E2C2402
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 12:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbgKXLU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 06:20:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732536AbgKXLU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 06:20:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606216856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GH+H2YnDA3HWNvV6KTs7I4rQ/ojbTweHhS7d+924qN4=;
        b=jWTg2gmh2ijtFrj03e3hmWm1Cyo8Gwyp4cRCQfYbnY9SH8gb2I5+e1HofgraaNeLReFKZZ
        6/TO8qe5c2lZ7g8XcAX/tnNnzJ1gFFf9hpXb5Fr8kbirpoE3zB3PvWXhWZsIiNNPfbfvyk
        QrFbF2QqOR8/XK63PClfyh+nnu6vJlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-d7qi9-rhPnyLghcNrS2XiA-1; Tue, 24 Nov 2020 06:20:54 -0500
X-MC-Unique: d7qi9-rhPnyLghcNrS2XiA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2903E5223;
        Tue, 24 Nov 2020 11:20:53 +0000 (UTC)
Received: from [10.36.113.14] (ovpn-113-14.ams2.redhat.com [10.36.113.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF7D71001E73;
        Tue, 24 Nov 2020 11:20:51 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "Matteo Croce" <mcroce@linux.microsoft.com>,
        netdev@vger.kernel.org, "David Miller" <davem@davemloft.net>,
        dev@openvswitch.org, "Pravin B Shelar" <pshelar@ovn.org>,
        bindiyakurle@gmail.com, "Ilya Maximets" <i.maximets@ovn.org>
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement action netlink
 message format
Date:   Tue, 24 Nov 2020 12:20:49 +0100
Message-ID: <5A0D68D9-AEB5-49BB-8FEA-465E1B32FC1A@redhat.com>
In-Reply-To: <20201123175739.13a27aed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
 <20201120131228.489c3b52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFnufp1RRtwDLwrWayvyZVPmDjab_dTx50u7xWeNwK7J6azqWw@mail.gmail.com>
 <20201123175739.13a27aed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24 Nov 2020, at 2:57, Jakub Kicinski wrote:

> On Mon, 23 Nov 2020 20:36:39 +0100 Matteo Croce wrote:
>> On Fri, Nov 20, 2020 at 10:12 PM Jakub Kicinski <kuba@kernel.org> 
>> wrote:
>>> On Thu, 19 Nov 2020 04:04:04 -0500 Eelco Chaudron wrote:
>>>> Currently, the openvswitch module is not accepting the correctly 
>>>> formated
>>>> netlink message for the TTL decrement action. For both setting and 
>>>> getting
>>>> the dec_ttl action, the actions should be nested in the
>>>> OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h 
>>>> uapi.
>>>
>>> IOW this change will not break any known user space, correct?
>>>
>>> But existing OvS user space already expects it to work like you
>>> make it work now?
>>>
>>> What's the harm in leaving it as is?
>>>
>>>> Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>
>>> Can we get a review from OvS folks? Matteo looks good to you (as the
>>> original author)?
>>
>> I think that the userspace still has to implement the dec_ttl action;
>> by now dec_ttl is implemented with set_ttl().
>> So there is no breakage yet.
>>
>> Eelco, with this fix we will encode the netlink attribute in the same
>> way for the kernel and netdev datapath?
>
> We don't allow breaking uAPI. Sounds like the user space never
> implemented this and perhaps the nesting is just inconvenient
> but not necessarily broken? If it is broken and unusable that
> has to be clearly explained in the commit message. I'm dropping
> v1 from patchwork.

Thanks, I will add some explaining comments to the V2, and sent it out.

