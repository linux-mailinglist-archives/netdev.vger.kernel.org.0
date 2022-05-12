Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCC0524A22
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 12:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352554AbiELKTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 06:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352534AbiELKT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 06:19:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C32221B150
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 03:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652350767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xz4SgEjso1Kq52nFkHQtcRAidYtGUrNRqLkLtyngq0g=;
        b=HdwjD3YzVqExUMzz2/jD25iaA+C1+QJPl5gWysiPl4hlGgIkdFVL5S/txxy9JQPasHD028
        +H+WKzORS35ZlYJ7VhnfGIsB8tWAElDv9TqWsob3SzSCDGd3PnK66+Svs+mcplxcE69OIc
        tGSBYnMTziwKxZwq5Gl17+A+TiHHd60=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-o7hZb2J0Mcq0IrlZcgaNZQ-1; Thu, 12 May 2022 06:19:25 -0400
X-MC-Unique: o7hZb2J0Mcq0IrlZcgaNZQ-1
Received: by mail-ej1-f72.google.com with SMTP id go17-20020a1709070d9100b006f46e53a2a9so2619832ejc.10
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 03:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xz4SgEjso1Kq52nFkHQtcRAidYtGUrNRqLkLtyngq0g=;
        b=kdFhTq5/93CLCoXh3dY5rEhTkaWLvoatpReeC9ZeCAhnik0ZrAcRrz0Xr0gAQEUE/I
         ND5jhgFVZHZU59hEnADL4aSEquzreKrTRPLb4EnZsO5xBITW1xDzcSon8fUH2MLNwAVn
         8fRhrXI9Uj0R/0uAY0/R3EqB5vbiykTh/8cArX8HDb1p2MiKD2OXBHRpgSI5Uw0Ybe03
         cJbPaBMlYhJRFa0goYlK4VeUDBAv9ESGK+7pJsf+2aGdDQ5beNMBDs9QBgKRPhQjpHfi
         lcv9uZzlIEG40qWPwnfr9g0UAbZxO9HoE410xP8Z4CteN5reVzaxbeWxkB8HShnGFOFp
         z4jw==
X-Gm-Message-State: AOAM532EmDQM/k8QYCAxCC8WD+Weq5SWjBTwsFuqAGOLJ7/Xv6u6AxD3
        KyVusj8O5tfVohvZ2E7CSIOu+UPqWeWepQBC0Z9I5CM5CaFVZjFj37XDXqLsYU5or+owcf6WwTv
        +2we3nDFySi6wIepQ
X-Received: by 2002:a17:907:3e99:b0:6f3:d1e1:23ae with SMTP id hs25-20020a1709073e9900b006f3d1e123aemr30057423ejc.470.1652350764651;
        Thu, 12 May 2022 03:19:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5BxyHLT5CTpxHkv7nSU7rzrtYPlbBEBEzYkfmPxU4mLme8lsKgp4inHiVLxrYa6WGjfG+lQ==
X-Received: by 2002:a17:907:3e99:b0:6f3:d1e1:23ae with SMTP id hs25-20020a1709073e9900b006f3d1e123aemr30057402ejc.470.1652350764387;
        Thu, 12 May 2022 03:19:24 -0700 (PDT)
Received: from [10.39.193.10] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id d17-20020a170906641100b006f3ef214da1sm1987961ejm.7.2022.05.12.03.19.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 03:19:23 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Vlad Buslov <vladbu@nvidia.com>,
        Toms Atteka <cpp.code.lv@gmail.com>
Cc:     Roi Dayan <roid@nvidia.com>, Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility
 with existing user space
Date:   Thu, 12 May 2022 12:19:23 +0200
X-Mailer: MailMate (1.14r5895)
Message-ID: <4778B505-DBF5-4F57-90AF-87F12C1E0311@redhat.com>
In-Reply-To: <9cc34fbc-3fd6-b529-7a05-554224510452@ovn.org>
References: <20220309222033.3018976-1-i.maximets@ovn.org>
 <f7ty21hir5v.fsf@redhat.com>
 <44eeb550-3310-d579-91cc-ec18b59966d2@nvidia.com>
 <1a185332-3693-2750-fef2-f6938bbc8500@ovn.org> <87k0c171ml.fsf@nvidia.com>
 <9cc34fbc-3fd6-b529-7a05-554224510452@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7 Apr 2022, at 12:22, Ilya Maximets wrote:

> On 4/7/22 10:02, Vlad Buslov wrote:
>> On Mon 14 Mar 2022 at 20:40, Ilya Maximets <i.maximets@ovn.org> wrote:=

>>> On 3/14/22 19:33, Roi Dayan wrote:
>>>>
>>>>
>>>> On 2022-03-10 8:44 PM, Aaron Conole wrote:
>>>>> Ilya Maximets <i.maximets@ovn.org> writes:
>>>>>
>>>>>> Few years ago OVS user space made a strange choice in the commit [=
1]
>>>>>> to define types only valid for the user space inside the copy of a=

>>>>>> kernel uAPI header.=C2=A0 '#ifndef __KERNEL__' and another attribu=
te was
>>>>>> added later.
>>>>>>
>>>>>> This leads to the inevitable clash between user space and kernel t=
ypes
>>>>>> when the kernel uAPI is extended.=C2=A0 The issue was unveiled wit=
h the
>>>>>> addition of a new type for IPv6 extension header in kernel uAPI.
>>>>>>
>>>>>> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to th=
e
>>>>>> older user space application, application tries to parse it as
>>>>>> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as=

>>>>>> malformed.=C2=A0 Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along=
 with
>>>>>> every IPv6 packet that goes to the user space, IPv6 support is ful=
ly
>>>>>> broken.
>>>>>>
>>>>>> Fixing that by bringing these user space attributes to the kernel
>>>>>> uAPI to avoid the clash.=C2=A0 Strictly speaking this is not the p=
roblem
>>>>>> of the kernel uAPI, but changing it is the only way to avoid break=
age
>>>>>> of the older user space applications at this point.
>>>>>>
>>>>>> These 2 types are explicitly rejected now since they should not be=

>>>>>> passed to the kernel.=C2=A0 Additionally, OVS_KEY_ATTR_TUNNEL_INFO=
 moved
>>>>>> out from the '#ifdef __KERNEL__' as there is no good reason to hid=
e
>>>>>> it from the userspace.=C2=A0 And it's also explicitly rejected now=
, because
>>>>>> it's for in-kernel use only.
>>>>>>
>>>>>> Comments with warnings were added to avoid the problem coming back=
=2E
>>>>>>
>>>>>> (1 << type) converted to (1ULL << type) to avoid integer overflow =
on
>>>>>> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
>>>>>>
>>>>>> =C2=A0 [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2=
 pipeline")
>>>>>>
>>>>>> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension h=
eader support")
>>>>>> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0=
cad8a5f@nvidia.com
>>>>>> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6=
521b0068b4cd12f6de507c
>>>>>> Reported-by: Roi Dayan <roid@nvidia.com>
>>>>>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>>>>>> ---
>>>>>
>>>>> Acked-by: Aaron Conole <aconole@redhat.com>
>>>>>
>>>>
>>>>
>>>>
>>>> I got to check traffic with the fix and I do get some traffic
>>>> but something is broken. I didn't investigate much but the quick
>>>> test shows me rules are not offloaded and dumping ovs rules gives
>>>> error like this
>>>>
>>>> recirc_id(0),in_port(enp8s0f0_1),ct_state(-trk),eth(),eth_type(0x86d=
d),ipv6(frag=3Dno)(bad
>>>> key length 2, expected -1)(00 00/(bad mask length 2, expected -1)(00=
 00),
>>>> packets:2453, bytes:211594, used:0.004s, flags:S., actions:ct,recirc=
(0x2)
>>>
>>> Such a dump is expected, because kernel parses fields that current
>>> userspace doesn't understand, and at the same time OVS by design is
>>> using kernel provided key/mask while installing datapath rules, IIRC.=

>>> It should be possible to make these dumps a bit more friendly though.=

>>>
>>> For the offloading not working, see my comment in the v2 patch email
>>> I sent (top email of this thread).  In short, it's a problem in user
>>> space and it can not be fixed from the kernel side, unless we revert
>>> IPv6 extension header support and never add any new types, which is
>>> unreasonable.  I didn't test any actual offloading, but I had a
>>> successful run of 'make check-offloads' with my quick'n'dirty fix fro=
m
>>> the top email.
>>
>> Hi Ilya,
>>
>> I can confirm that with latest OvS master IPv6 rules offload still fai=
ls
>> without your pastebin code applied.
>>
>>>
>>> Since we're here:
>>>
>>> Toms, do you plan to submit user space patches for this feature?
>>
>> I see there is a patch from you that is supposed to fix compatibility
>> issues caused by this change in OvS d96d14b14733 ("openvswitch.h: Alig=
n
>> uAPI definition with the kernel."), but it doesn't fix offload for me
>> without pastebin patch.
>
> Yes.  OVS commit d96d14b14733 is intended to only fix the uAPI.
> Issue with offload is an OVS bug that should be fixed separately.
> The fix will also need to be backported to OVS stable branches.
>
>> Do you plan to merge that code into OvS or you
>> require some help from our side?
>
> I could do that, but I don't really have enough time.  So, if you
> can work on that fix, it would be great.  Note that comments inside
> the OVS's lib/odp-util.c:parse_key_and_mask_to_match() was blindly
> copied from the userspace datapath and are incorrect for the general
> case, so has to be fixed alongside the logic of that function.

Tom or Vlad, are you working on this? Asking, as the release of a kernel =
with Tom=E2=80=99s =E2=80=9Cnet: openvswitch: IPv6: Add IPv6 extension he=
ader support=E2=80=9D patch will break OVS.

//Eelco


