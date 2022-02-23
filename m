Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A524C0FAE
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 10:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiBWJ5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 04:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiBWJ5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 04:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72AD63D1E2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645610207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qvbBcz8WzyBtHIIwaDvjG82Oq6eQux0KL9qi/epqKd8=;
        b=OV5u/sYN31axc7EgV60PIzrc+3e48DfNxxWrHlHn/sjVcpOH1Dpq//SUMgus/lH7ECTJEg
        rCGNZBttMr0C9W3Acff9laimfjgbDrDkjaFO2B8VCAZTpIneVKd4d+yBlmI8vFao5t+lwK
        pvy0ec+qfyXmPBeLK+F4zlDpPZeYkjo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-mDJQ7QWgOSy0ZCk7By7jSg-1; Wed, 23 Feb 2022 04:56:45 -0500
X-MC-Unique: mDJQ7QWgOSy0ZCk7By7jSg-1
Received: by mail-ed1-f69.google.com with SMTP id g5-20020a056402090500b0040f28e1da47so13376966edz.8
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:56:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qvbBcz8WzyBtHIIwaDvjG82Oq6eQux0KL9qi/epqKd8=;
        b=TVDH5XFsqBvDPca+OT3he8tvrtREbveDX8Q9F9MgmcL0F+cGst9XkTRwgn5QmgXC8o
         P/zIGnQWZYi/XQkr9SJGD/OaZLQugyapz8IXpA45IVhhrDLqv+KaqWe5hQx3Uu6GY0nW
         4Pd/Bd14Yruxn2eA8+r5dCYyf6zhK8EfhU2vhMNmMOE8jzH5JVxMH7me/tFDf6Doq+vE
         ighDdS0IQMsljG2MLFHuYWZldHM/Zjd8SLdyh1g6znwIGl/cSDxsiPe3PZfGKkpTDVkO
         YHJyddSfCwBnEmSXkiGFuRf0QRTxGlMb1U0DXjjWlCJMzSAuOZYLTfn+FXR2Vimuea2g
         PYeA==
X-Gm-Message-State: AOAM532wCsyF4txRn/NKt8NrgQ9x0MJIuGS+y/W9qOBmAvggNbLQwFT9
        v67pRV8mSG+xaV3ZQLX8j11kWjbwz66Vz4pNuxWEQdwlFjBEuzX/v5sF+nYuJCaFjSiymK5nOxC
        5cxHIGtZ7oXeij+J9
X-Received: by 2002:a05:6402:c81:b0:410:a329:e27a with SMTP id cm1-20020a0564020c8100b00410a329e27amr30584934edb.142.1645610204221;
        Wed, 23 Feb 2022 01:56:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSv/AgG1WZ4cGFgOtuAFez/HsvSF7TAdPxtCOv9N7M6qBXE8f1L4fkHE7GZ1Nsd0IHEcvMwQ==
X-Received: by 2002:a05:6402:c81:b0:410:a329:e27a with SMTP id cm1-20020a0564020c8100b00410a329e27amr30584918edb.142.1645610203978;
        Wed, 23 Feb 2022 01:56:43 -0800 (PST)
Received: from [10.39.192.180] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id a13sm8431992edn.25.2022.02.23.01.56.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Feb 2022 01:56:43 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Marcelo Leitner <mleitner@redhat.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>, dev@openvswitch.org,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        wenxu <wenxu@ucloud.cn>, netdev@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH v2 08/10] netdev-offload-tc: Check for none offloadable ct_state flag combination
Date:   Wed, 23 Feb 2022 10:56:42 +0100
X-Mailer: MailMate (1.14r5872)
Message-ID: <F1C39B81-E0F0-4565-9C49-8D659CF49CBC@redhat.com>
In-Reply-To: <CALnP8ZZ7qX_7EtXhVXaE_4pnsJHjmrzFfq7U+OQZkR_zV8_72g@mail.gmail.com>
References: <b17b6504-49be-72b5-8f09-d50e4db4881b@ovn.org>
 <DE808EB4-983E-47B1-8B72-2EDEEC86FBE6@redhat.com>
 <fd03a6b9-2ccb-f6d1-038b-c23b3a7827f1@ovn.org>
 <D7348910-0483-41A7-BD96-83CB364650D1@redhat.com>
 <7977b95b-aeb2-99ab-5b12-c65d811b765d@ovn.org>
 <CALnP8ZbdEYiecU9rm3jYg4jA=ca0Os7+==6Dn_UiDRtn9-pMRg@mail.gmail.com>
 <D5709C71-4CE5-47F2-AE3E-B8D91B57DAA3@redhat.com>
 <81CEDA74-119C-48E2-89B9-E0C1CC09E95B@redhat.com>
 <CALnP8ZZ251hppTzAYVmKzB7WeLTniLVQ-dXePJGekvyBcGLckg@mail.gmail.com>
 <C786EF01-87A3-4471-80E3-CB18B7A4E572@redhat.com>
 <CALnP8ZZ7qX_7EtXhVXaE_4pnsJHjmrzFfq7U+OQZkR_zV8_72g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Feb 2022, at 17:02, Marcelo Leitner wrote:

> On Tue, Feb 22, 2022 at 04:44:30PM +0100, Eelco Chaudron wrote:
>>
>>
>> On 22 Feb 2022, at 12:36, Marcelo Leitner wrote:
>>
>>> +Cc Wenxu, Paul and netdev
>>>
>>> On Tue, Feb 22, 2022 at 10:33:44AM +0100, Eelco Chaudron wrote:
>>>>
>>>>
>>>> On 21 Feb 2022, at 15:53, Eelco Chaudron wrote:
>>>>
>>>>> On 21 Feb 2022, at 14:33, Marcelo Leitner wrote:
>>>>
>>>> <SNIP>
>>>>
>>>>>>>> Don=E2=80=99t think this is true, it will only print if +trk and=
 any other flags are set.
>>>>>>>> Guess this is where the miscommunication is.>
>>>>>>>>> The message also seems to be a bit aggressive, especially since=
 it will
>>>>>>>>> almost always be printed.
>>>>>>>
>>>>>>> Yeah.  I missed the fact that you're checking for zero and flower=
->key.ct_state
>>>>>>> will actually mark existence of other flags.  So, that is fine.
>>>>>>>
>>>>>>> However, I'm still not sure that the condition is fully correct.
>>>>>>>
>>>>>>> If we'll take a match on '+est' with all other flags wildcarded, =
that will
>>>>>>> trigger the condition, because 'flower->key.ct_state' will contai=
n the 'est' bit,
>>>>>>> but 'trk' bit will not be set.  The point is that even though -tr=
k+est is not
>>>>>>
>>>>>> Oh ow. tc flower will reject this combination today, btw. I don't =
know
>>>>>> about hw implications for changing that by now.
>>>>>>
>>>>>> https://elixir.bootlin.com/linux/latest/C/ident/fl_validate_ct_sta=
te
>>>>>> 'state' parameter in there is the value masked already.
>>>>>>
>>>>>> We directly mapped openflow restrictions to the datapath.
>>>>>>
>>>>>>> a valid combination and +trk+est is, OVS may in theory produce th=
e match with
>>>>>>> 'est' bit set and 'trk' bit wildcarded.  And that can be a correc=
t configuration.
>>>>>>
>>>>>> I guess that means that the only possible parameter validation on
>>>>>> ct_state at tc level is about its length. Thoughts?
>>>>>>
>>>>>
>>>>> Guess I get it now also :) I was missing the wildcard bit that OVS =
implies when not specifying any :)
>>>>>
>>>>> I think I can fix this by just adding +trk on the TC side when we g=
et the OVS wildcard for +trk. Guess this holds true as for TC there is no=
 -trk +flags.
>>>>>
>>>>> I=E2=80=99m trying to replicate patch 9 all afternoon, and due to t=
he fact I did not write down which test was causing the problem, and it t=
aking 20-30 runs, it has not happened yet :( But will do it later tomorro=
w, see if it works in all cases ;)
>>>>>
>>>>
>>>> So I=E2=80=99ve been doing some experiments (and running all system-=
traffic tests), and I think the following fix will solve the problem by j=
ust making sure the +trk flag is set in this case on the TC side.
>>>> This will not change the behavior compared to the kernel.
>>>>
>>>> diff --git a/lib/netdev-offload-tc.c b/lib/netdev-offload-tc.c
>>>> index 0105d883f..3d2c1d844 100644
>>>> --- a/lib/netdev-offload-tc.c
>>>> +++ b/lib/netdev-offload-tc.c
>>>> @@ -1541,6 +1541,12 @@ parse_match_ct_state_to_flower(struct tc_flow=
er *flower, struct match *match)
>>>>              flower->key.ct_state &=3D ~(TCA_FLOWER_KEY_CT_FLAGS_NEW=
);
>>>>              flower->mask.ct_state &=3D ~(TCA_FLOWER_KEY_CT_FLAGS_NE=
W);
>>>>          }
>>>> +
>>>> +        if (flower->key.ct_state &&
>>>> +            !(flower->key.ct_state & TCA_FLOWER_KEY_CT_FLAGS_TRACKE=
D)) {
>>>> +            flower->key.ct_state |=3D TCA_FLOWER_KEY_CT_FLAGS_TRACK=
ED;
>>>> +            flower->mask.ct_state |=3D TCA_FLOWER_KEY_CT_FLAGS_TRAC=
KED;
>>>> +        }
>>>
>>> I had meant to update the kernel instead. As Ilya was saying, as this=

>>> is dealing with masks, the validation that tc is doing is not right. =
I
>>> mean, for a connection to be in +est, it needs +trk, right, but for
>>> matching, one could have the following value/mask:
>>>  value=3Dest
>>>  mask=3Dest
>>> which means: match connections in Established AND also untracked ones=
=2E
>>
>> Maybe it was too late last night, but why also untracked ones?
>
> Nah, it was too early today here. :D
>
>> It should only match untracked ones with the est flag set, or do I mis=
s something?
>> Untracked ones can never have the est flag set, right?
>
> My bad. Please scratch that description. Right.. it can't match
> untracked ones because it's checking that est is set, and untracked
> ones can never have it.
>
> Yet, the point is, the mask, per say, is not wrong. All conntrack
> entries that have +est will also have +trk, okay, but a user filtering
> only for +est is not wrong and tc shouldn't reject it.
>
> I couldn't find a similar verification in ovs kernel. Maybe I missed
> it. But if vswitchd would need the tweak in here, seems ovs kernel
> doesn't need it, and then the two would potentially have different
> behaviours.

I do not know the exact details on the OVS Kernel conntrack part, but ass=
uming it=E2=80=99s based on the same Netfilter infrastructure, any bits w=
ill be set only if the connection is tracked.  So the behavior from an OV=
S perspective will be the same for both.

>>
>>> Apparently this is what the test is triggering here, and the patch
>>> above could lead to not match the 2nd part of the AND above.
>>>
>>> When fixing the parameter validation in flower, we went too far.
>>>
>>>   Marcelo
>>>
>>>>      }
>>>>
>>>> I will send out a v3 of this set soon with this change included.
>>>>
>>>> //Eelco
>>>>
>>>> <SNIP>
>>>>
>>

