Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB5A2B1F82
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgKMQFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:05:40 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46447 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgKMQFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:05:39 -0500
X-Originating-IP: 78.45.89.65
Received: from [192.168.1.23] (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6518460009;
        Fri, 13 Nov 2020 16:05:35 +0000 (UTC)
Subject: Re: [PATCH v2] datapath: Add a new action dec_ttl
To:     Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     dev@openvswitch.org, bindiyakurle@gmail.com,
        mcroce@linux.microsoft.com, Pravin B Shelar <pshelar@ovn.org>,
        netdev@vger.kernel.org
References: <160526187892.175404.2281455759948584518.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
 <1a3cb289-44c6-058a-e4a4-4c1833badac4@ovn.org>
 <AF0A2E2E-A794-4B20-9471-9019EAFAA0E2@redhat.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <c26e67ec-c57c-3f92-ad04-361cdf0d7bf8@ovn.org>
Date:   Fri, 13 Nov 2020 17:05:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <AF0A2E2E-A794-4B20-9471-9019EAFAA0E2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: netdev

On 11/13/20 3:28 PM, Eelco Chaudron wrote:
> 
> 
> On 13 Nov 2020, at 13:06, Ilya Maximets wrote:
> 
>> On 11/13/20 11:04 AM, Eelco Chaudron wrote:
>>> Add support for the dec_ttl action. Instead of programming the datapath with
>>> a flow that matches the packet TTL and an IP set, use a single dec_ttl action.
>>>
>>> The old behavior is kept if the new action is not supported by the datapath.
>>>
>>>   # ovs-ofctl dump-flows br0
>>>    cookie=0x0, duration=12.538s, table=0, n_packets=4, n_bytes=392, ip actions=dec_ttl,NORMAL
>>>    cookie=0x0, duration=12.536s, table=0, n_packets=4, n_bytes=168, actions=NORMAL
>>>
>>>   # ping -c1 -t 20 192.168.0.2
>>>   PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
>>>   IP (tos 0x0, ttl 19, id 45336, offset 0, flags [DF], proto ICMP (1), length 84)
>>>       192.168.0.1 > 192.168.0.2: ICMP echo request, id 8865, seq 1, length 64
>>>
>>> Linux netlink datapath support depends on upstream Linux commit:
>>>   744676e77720 ("openvswitch: add TTL decrement action")
>>>
>>>
>>> Note that in the Linux kernel tree the OVS_ACTION_ATTR_ADD_MPLS has been
>>> defined, and to make sure the IDs are in sync, it had to be added to the
>>> OVS source tree. This required some additional case statements, which
>>> should be revisited once the OVS implementation is added.
>>>
>>>
>>> Co-developed-by: Matteo Croce <mcroce@linux.microsoft.com>
>>> Co-developed-by: Bindiya Kurle <bindiyakurle@gmail.com>
>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>
>>> ---
>>> v2: - Used definition instead of numeric value in format_dec_ttl_action()
>>>     - Changed format from "dec_ttl(ttl<=1(<actions>)) to
>>>       "dec_ttl(le_1(<actions>))" to be more in line with the check_pkt_len action.
>>>     - Fixed parsing of "dec_ttl()" action for adding a dp flow.
>>>     - Cleaned up format_dec_ttl_action()
>>>
>>>  datapath/linux/compat/include/linux/openvswitch.h |    8 ++
>>>  lib/dpif-netdev.c                                 |    4 +
>>>  lib/dpif.c                                        |    4 +
>>>  lib/odp-execute.c                                 |  102 ++++++++++++++++++++-
>>>  lib/odp-execute.h                                 |    2
>>>  lib/odp-util.c                                    |   42 +++++++++
>>>  lib/packets.h                                     |   13 ++-
>>>  ofproto/ofproto-dpif-ipfix.c                      |    2
>>>  ofproto/ofproto-dpif-sflow.c                      |    2
>>>  ofproto/ofproto-dpif-xlate.c                      |   54 +++++++++--
>>>  ofproto/ofproto-dpif.c                            |   37 ++++++++
>>>  ofproto/ofproto-dpif.h                            |    6 +
>>>  12 files changed, 253 insertions(+), 23 deletions(-)
>>>
>>
>> <snip>
>>
>>> +static void
>>> +format_dec_ttl_action(struct ds *ds,const struct nlattr *attr,
>>> +                      const struct hmap *portno_names)
>>> +{
>>> +    const struct nlattr *nla_acts = nl_attr_get(attr);
>>> +    int len = nl_attr_get_size(attr);
>>> +
>>> +    ds_put_cstr(ds,"dec_ttl(le_1(");
>>> +
>>> +    if (len > 4 && nla_acts->nla_type == OVS_DEC_TTL_ATTR_ACTION) {
>>> +        /* Linux kernel add an additional envelope we should strip. */
>>> +        len -= nl_attr_len_pad(nla_acts, len);
>>> +        nla_acts = nl_attr_next(nla_acts);
>>
>> CC: Pravin
>>
>> I looked at the kernel and I agree that there is a clear bug in kernel's
>> implementaion of this action.  It receives messages on format:
>>   OVS_ACTION_ATTR_DEC_TTL(<list of actions>),
>> but reports back in format:
>>   OVS_ACTION_ATTR_DEC_TTL(OVS_DEC_TTL_ATTR_ACTION(<list of actions>)).
>>
>> Since 'OVS_DEC_TTL_ATTR_ACTION' exists, it's clear that original design
>> was to have it, i.e. the correct format should be the form that
>> kernel reports back to userspace.  I'd guess that there was a plan to
>> add more features to OVS_ACTION_ATTR_DEC_TTL in the future, e.g. set
>> actions execution threshold to something different than 1, so it make
>> some sense.
>>
>> Anyway, the bug is in the kernel part of parsing the netlink message and
>> it should be fixed.
> 
> It is already in the mainline kernel, so changing it now would break the UAPI.
> Don't think this is allowed from the kernel side.

Well, UAPI is what specified in include/uapi/linux/openvswitch.h.  And it says:

        OVS_ACTION_ATTR_DEC_TTL,      /* Nested OVS_DEC_TTL_ATTR_*. */ 

So, the action must have nested OVS_DEC_TTL_ATTR_ACTION, otherwise it's malformed.
This means that UAPI is broken now in terms that kernel doesn't respect it's
own UAPI.  And that's a bug that should be fixed.

> 
>> What I'm suggesting is to send a bugfix to kernel
>> to accept only format with nested OVS_DEC_TTL_ATTR_ACTION.  Since this
>> feature was never implemented in userspace OVS, this change will not
>> break anything.  On the OVS side we should always format netlink messages
>> in a correct way.  We have a code that checks feature existence in kernel
>> and it should fail if kernel is broken (as it is right now).  In this case
>> OVS will continue to use old implementation with setting the ttl field.
>>
>> Since the patch for a kernel is a bug fix, it should be likely backported
>> to stable versions, and distributions will pick it up too.
> 
> If the kernel UAPI breakage is not a problem, I think this would work.
> 
>> Thoughts?
>>
>> Best regards, Ilya Maximets.
> 

