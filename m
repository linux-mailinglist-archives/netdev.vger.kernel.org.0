Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF3C63C272
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiK2O1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbiK2O1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:27:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6B95C0DA
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669731988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4AEq8/e4uJ/4ykggQax+wHLvQuwMyqFr7ojK3DGvdTA=;
        b=AkcSdyiaj4HVwm2jNfYaP1CTrD61NjisetmpWT6cg0WyfXdkcmNppn1SdB0DjkpB0Zteli
        J2etCNOJH5fu+3rVClaOT1nkl5wSwZRxIsElzIBRE6BtoRA1pg4MQp2s8Jqsl+wM4hco5B
        HRlYPbniql5tsEYXuLgCw1taoUtl4E0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-4u3ekesANO6myoqiLy0qIg-1; Tue, 29 Nov 2022 09:26:25 -0500
X-MC-Unique: 4u3ekesANO6myoqiLy0qIg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB340185A7AA;
        Tue, 29 Nov 2022 14:26:24 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.34.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A3D8492B07;
        Tue, 29 Nov 2022 14:26:24 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Adrian Moreno <amorenoz@redhat.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kselftest@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [RFC net-next 1/6] openvswitch: exclude kernel flow
 key from upcalls
References: <20221122140307.705112-1-aconole@redhat.com>
        <20221122140307.705112-2-aconole@redhat.com>
        <c04242ee-f125-6d95-e263-65470222d3cf@ovn.org>
        <83a0b3e4-1327-c1c4-4eb4-9a25ff533d1d@redhat.com>
        <bf975714-7edc-efdd-de84-56194aa6eb60@ovn.org>
        <753d995d-d4f4-bf2e-994d-435a36414127@redhat.com>
Date:   Tue, 29 Nov 2022 09:26:22 -0500
In-Reply-To: <753d995d-d4f4-bf2e-994d-435a36414127@redhat.com> (Adrian
        Moreno's message of "Mon, 28 Nov 2022 10:12:21 +0100")
Message-ID: <f7tedtlsupd.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adrian Moreno <amorenoz@redhat.com> writes:

> On 11/25/22 16:51, Ilya Maximets wrote:
>> On 11/25/22 16:29, Adrian Moreno wrote:
>>>
>>>
>>> On 11/23/22 22:22, Ilya Maximets wrote:
>>>> On 11/22/22 15:03, Aaron Conole wrote:
>>>>> When processing upcall commands, two groups of data are available to
>>>>> userspace for processing: the actual packet data and the kernel
>>>>> sw flow key data.=C2=A0 The inclusion of the flow key allows the user=
space
>>>>> avoid running through the dissection again.
>>>>>
>>>>> However, the userspace can choose to ignore the flow key data, as is
>>>>> the case in some ovs-vswitchd upcall processing.=C2=A0 For these mess=
ages,
>>>>> having the flow key data merely adds additional data to the upcall
>>>>> pipeline without any actual gain.=C2=A0 Userspace simply throws the d=
ata
>>>>> away anyway.
>>>>
>>>> Hi, Aaron.=C2=A0 While it's true that OVS in userpsace is re-parsing t=
he
>>>> packet from scratch and using the newly parsed key for the OpenFlow
>>>> translation, the kernel-porvided key is still used in a few important
>>>> places.=C2=A0 Mainly for the compatibility checking.=C2=A0 The use is =
described
>>>> here in more details:
>>>>  =C2=A0=C2=A0 https://docs.kernel.org/networking/openvswitch.html#flow=
-key-compatibility
>>>>
>>>> We need to compare the key generated in userspace with the key
>>>> generated by the kernel to know if it's safe to install the new flow
>>>> to the kernel, i.e. if the kernel and OVS userpsace are parsing the
>>>> packet in the same way.
>>>>
>>>
>>> Hi Ilya,
>>>
>>> Do we need to do that for every packet?
>>> Could we send a bitmask of supported fields to userspace at feature
>>> negotiation and let OVS slowpath flows that it knows the kernel won't
>>> be able to handle properly?
>> It's not that simple, because supported fields in a packet depend
>> on previous fields in that same packet.  For example, parsing TCP
>> header is generally supported, but it won't be parsed for IPv6
>> fragments (even the first one), number of vlan headers will affect
>> the parsing as we do not parse deeper than 2 vlan headers, etc.
>> So, I'm afraid we have to have a per-packet information, unless we
>> can somehow probe all the possible valid combinations of packet
>> headers.
>>=20
>
> Surely. I understand that we'd need more than just a bit per
> field. Things like L4 on IPv6 frags would need another bit and the
> number of VLAN headers would need some more. But, are these a handful
> of exceptions or do we really need all the possible combinations of
> headers? If it's a matter of naming a handful of corner cases I think
> we could consider expressing them at initialization time and safe some
> buffer space plus computation time both in kernel and userspace.

I will take a bit more of a look here - there must surely be a way to
express this when pulling information via DP_GET command so that we
don't need to wait for a packet to come in to figure out whether we can
parse it.

