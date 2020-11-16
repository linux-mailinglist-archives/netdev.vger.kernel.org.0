Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12032B463C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgKPOqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:46:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730359AbgKPOqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:46:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605537999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VtyoBFwApfUeR+vDRDbS2v6ykTOzBNXw+8boxM7uvSQ=;
        b=JjtRJrSMA18vpUwCw4m/0m3OA2IH/1sQ2Qx7/NwSD+VueRNU+vgJQ7snXxXcXGqhG4XV4q
        akQ3E5Gs50qq6mWHOA/dxnKRutanFtlvBw03DK6IQmH2/AyBla+HmETTJyiv+0dJhXnrZc
        ZY5nEqBap4t1g8p2ERfbBs/pQJJ+m1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-qxYRypjgP5SuRh0zuqhYGA-1; Mon, 16 Nov 2020 09:46:35 -0500
X-MC-Unique: qxYRypjgP5SuRh0zuqhYGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 145661009E26;
        Mon, 16 Nov 2020 14:46:33 +0000 (UTC)
Received: from [10.40.194.169] (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E45D5B4C1;
        Mon, 16 Nov 2020 14:46:30 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Ilya Maximets" <i.maximets@ovn.org>
Cc:     dev@openvswitch.org, bindiyakurle@gmail.com,
        mcroce@linux.microsoft.com, "Pravin B Shelar" <pshelar@ovn.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] datapath: Add a new action dec_ttl
Date:   Mon, 16 Nov 2020 15:46:28 +0100
Message-ID: <ACAE49DC-5CAB-4B25-AB65-BA5E660A8833@redhat.com>
In-Reply-To: <c26e67ec-c57c-3f92-ad04-361cdf0d7bf8@ovn.org>
References: <160526187892.175404.2281455759948584518.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
 <1a3cb289-44c6-058a-e4a4-4c1833badac4@ovn.org>
 <AF0A2E2E-A794-4B20-9471-9019EAFAA0E2@redhat.com>
 <c26e67ec-c57c-3f92-ad04-361cdf0d7bf8@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13 Nov 2020, at 17:05, Ilya Maximets wrote:

> Cc: netdev
>
> On 11/13/20 3:28 PM, Eelco Chaudron wrote:
>>
>>
>> On 13 Nov 2020, at 13:06, Ilya Maximets wrote:
>>
>>> On 11/13/20 11:04 AM, Eelco Chaudron wrote:
>>>> Add support for the dec_ttl action. Instead of programming the =

>>>> datapath with
>>>> a flow that matches the packet TTL and an IP set, use a single =

>>>> dec_ttl action.
>>>>
>>>> The old behavior is kept if the new action is not supported by the =

>>>> datapath.
>>>>
>>>> =C2=A0 # ovs-ofctl dump-flows br0
>>>> =C2=A0=C2=A0 cookie=3D0x0, duration=3D12.538s, table=3D0, n_packets=3D=
4, =

>>>> n_bytes=3D392, ip actions=3Ddec_ttl,NORMAL
>>>> =C2=A0=C2=A0 cookie=3D0x0, duration=3D12.536s, table=3D0, n_packets=3D=
4, =

>>>> n_bytes=3D168, actions=3DNORMAL
>>>>
>>>> =C2=A0 # ping -c1 -t 20 192.168.0.2
>>>> =C2=A0 PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
>>>> =C2=A0 IP (tos 0x0, ttl 19, id 45336, offset 0, flags [DF], proto IC=
MP =

>>>> (1), length 84)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 192.168.0.1 > 192.168.0.2: ICMP echo =
request, id 8865, =

>>>> seq 1, length 64
>>>>
>>>> Linux netlink datapath support depends on upstream Linux commit:
>>>> =C2=A0 744676e77720 ("openvswitch: add TTL decrement action")
>>>>
>>>>
>>>> Note that in the Linux kernel tree the OVS_ACTION_ATTR_ADD_MPLS has =

>>>> been
>>>> defined, and to make sure the IDs are in sync, it had to be added =

>>>> to the
>>>> OVS source tree. This required some additional case statements, =

>>>> which
>>>> should be revisited once the OVS implementation is added.
>>>>
>>>>
>>>> Co-developed-by: Matteo Croce <mcroce@linux.microsoft.com>
>>>> Co-developed-by: Bindiya Kurle <bindiyakurle@gmail.com>
>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>>
>>>> ---
>>>> v2: - Used definition instead of numeric value in =

>>>> format_dec_ttl_action()
>>>> =C2=A0=C2=A0=C2=A0 - Changed format from "dec_ttl(ttl<=3D1(<actions>=
)) to
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "dec_ttl(le_1(<actions>))" to be more=
 in line with the =

>>>> check_pkt_len action.
>>>> =C2=A0=C2=A0=C2=A0 - Fixed parsing of "dec_ttl()" action for adding =
a dp flow.
>>>> =C2=A0=C2=A0=C2=A0 - Cleaned up format_dec_ttl_action()
>>>>
>>>> =C2=A0datapath/linux/compat/include/linux/openvswitch.h |=C2=A0=C2=A0=
=C2=A0 8 ++
>>>> =C2=A0lib/dpif-netdev.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0=C2=A0 4 +
>>>> =C2=A0lib/dpif.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0=C2=A0 4 +
>>>> =C2=A0lib/odp-execute.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =

>>>> |=C2=A0 102 ++++++++++++++++++++-
>>>> =C2=A0lib/odp-execute.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0=C2=A0 2
>>>> =C2=A0lib/odp-util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0 42 +++++++++
>>>> =C2=A0lib/packets.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0 13 ++-
>>>> =C2=A0ofproto/ofproto-dpif-ipfix.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0=C2=A0 2
>>>> =C2=A0ofproto/ofproto-dpif-sflow.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0=C2=A0 2
>>>> =C2=A0ofproto/ofproto-dpif-xlate.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0 54 +++++++++--
>>>> =C2=A0ofproto/ofproto-dpif.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0 37 ++++++++
>>>> =C2=A0ofproto/ofproto-dpif.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =

>>>> |=C2=A0=C2=A0=C2=A0 6 +
>>>> =C2=A012 files changed, 253 insertions(+), 23 deletions(-)
>>>>
>>>
>>> <snip>
>>>
>>>> +static void
>>>> +format_dec_ttl_action(struct ds *ds,const struct nlattr *attr,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct hm=
ap =

>>>> *portno_names)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 const struct nlattr *nla_acts =3D nl_attr_get(at=
tr);
>>>> +=C2=A0=C2=A0=C2=A0 int len =3D nl_attr_get_size(attr);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 ds_put_cstr(ds,"dec_ttl(le_1(");
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 if (len > 4 && nla_acts->nla_type =3D=3D =

>>>> OVS_DEC_TTL_ATTR_ACTION) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Linux kernel add an a=
dditional envelope we =

>>>> should strip. */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len -=3D nl_attr_len_pad=
(nla_acts, len);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nla_acts =3D nl_attr_nex=
t(nla_acts);
>>>
>>> CC: Pravin
>>>
>>> I looked at the kernel and I agree that there is a clear bug in =

>>> kernel's
>>> implementaion of this action.=C2=A0 It receives messages on format:
>>> =C2=A0 OVS_ACTION_ATTR_DEC_TTL(<list of actions>),
>>> but reports back in format:
>>> =C2=A0 OVS_ACTION_ATTR_DEC_TTL(OVS_DEC_TTL_ATTR_ACTION(<list of =

>>> actions>)).
>>>
>>> Since 'OVS_DEC_TTL_ATTR_ACTION' exists, it's clear that original =

>>> design
>>> was to have it, i.e. the correct format should be the form that
>>> kernel reports back to userspace.=C2=A0 I'd guess that there was a pl=
an =

>>> to
>>> add more features to OVS_ACTION_ATTR_DEC_TTL in the future, e.g. set
>>> actions execution threshold to something different than 1, so it =

>>> make
>>> some sense.
>>>
>>> Anyway, the bug is in the kernel part of parsing the netlink message =

>>> and
>>> it should be fixed.
>>
>> It is already in the mainline kernel, so changing it now would break =

>> the UAPI.
>> Don't think this is allowed from the kernel side.
>
> Well, UAPI is what specified in include/uapi/linux/openvswitch.h.  And =

> it says:
>
>         OVS_ACTION_ATTR_DEC_TTL,      /* Nested OVS_DEC_TTL_ATTR_*. */
>
> So, the action must have nested OVS_DEC_TTL_ATTR_ACTION, otherwise =

> it's malformed.
> This means that UAPI is broken now in terms that kernel doesn't =

> respect it's
> own UAPI.  And that's a bug that should be fixed.

Ack, will cook up a patch, and sent it to net.

//Eelco

