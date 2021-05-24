Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D892038F3C2
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 21:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhEXTgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 15:36:15 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:60321 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbhEXTgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 15:36:15 -0400
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 93055C87F2
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:32:21 +0000 (UTC)
Received: (Authenticated sender: i.maximets@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 72CA7C0002;
        Mon, 24 May 2021 19:31:58 +0000 (UTC)
Subject: Re: [PATCH net-next v2] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Cpp Code <cpp.code.lv@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, "pshelar@ovn.org" <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>,
        Jakub Kicinski <kuba@kernel.org>, Ben Pfaff <blp@ovn.org>
References: <20210517152051.35233-1-cpp.code.lv@gmail.com>
 <614d9840-cd9d-d8b1-0d88-ce07e409068d@ovn.org>
 <CAASuNyWEUgdJU-_zcKbpkQa91KHffoTaR4T8csea=AtP30DSsg@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <3b10f4e0-c660-a7ed-bcd5-64cc1a23f19a@ovn.org>
Date:   Mon, 24 May 2021 21:31:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAASuNyWEUgdJU-_zcKbpkQa91KHffoTaR4T8csea=AtP30DSsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/21 8:57 PM, Cpp Code wrote:
> Yes, these changes only works together with changes in userspace. I
> believe in any solution there should be corresponding changes in
> userspace. If we would be able to easily run old version of userspace
> with these changes in kernel without userspace complaining about
> struct size, we could get in to a situation with hard to find bugs.

You can't modify existing binaries and we can't expect that everyone
will get new version of OVS along with the kernel update.  Existing
binaries should work fine with any version of underlying kernel.
With this change applied, kernel will not be able to parse
OVS_KEY_ATTR_IPV6 sent from userspace by the older OVS and this OVS
will not be able to correctly parse netlink messages sent by the
kernel.

> 
> I don't agree with the solution of a new struct key as semantically
> ipv6 extension headers are integral part of every ipv6 packet thus
> expected to be in the struct along with label, for example. Correct if
> I am missing something.

Even though ipv6 extensions are part of ipv6, they never was part of
the user interface here.  I agree that original design of this structure
was not perfect, but breaking of the user interface, i.e. breaking all
the existing OVS binaries, is just not acceptable.

> 
> On Wed, May 19, 2021 at 2:52 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>>
>> On 5/17/21 5:20 PM, Toms Atteka wrote:
>>> IPv6 extension headers carry optional internet layer information
>>> and are placed between the fixed header and the upper-layer
>>> protocol header.
>>>
>>> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
>>> packets can be filtered using ipv6_ext flag.
>>>
>>> Tested-at: https://github.com/TomCodeLV/ovs/actions/runs/504185214
>>> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
>>> ---
>>>  include/uapi/linux/openvswitch.h |   1 +
>>>  net/openvswitch/flow.c           | 141 +++++++++++++++++++++++++++++++
>>>  net/openvswitch/flow.h           |  14 +++
>>>  net/openvswitch/flow_netlink.c   |   5 +-
>>>  4 files changed, 160 insertions(+), 1 deletion(-)
>>>
>>>
>>> base-commit: 5d869070569a23aa909c6e7e9d010fc438a492ef
>>>
>>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
>>> index 8d16744edc31..a19812b6631a 100644
>>> --- a/include/uapi/linux/openvswitch.h
>>> +++ b/include/uapi/linux/openvswitch.h
>>> @@ -420,6 +420,7 @@ struct ovs_key_ipv6 {
>>>       __u8   ipv6_tclass;
>>>       __u8   ipv6_hlimit;
>>>       __u8   ipv6_frag;       /* One of OVS_FRAG_TYPE_*. */
>>> +     __u16  ipv6_exthdr;
>>>  };
>>
>> Wouldn't this break existing userspace?  Curent OVS expects netlink
>> message with attribute size equal to the old version of 'struct ovs_key_ipv6'
>> and it will discard OVS_KEY_ATTR_IPV6 as malformed.
>>
>> This should likely be a completely new structure and a completely new
>> OVS_KEY_ATTR.
>>
>> Best regards, Ilya Maximets.

