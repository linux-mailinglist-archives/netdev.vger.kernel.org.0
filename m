Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09FA627A6B
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiKNK0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiKNK0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:26:14 -0500
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBB71BEAC
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:26:13 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9c:2c00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 2AEAPcJY1111505
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 10:25:39 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9c:2c02:34cc:c78d:869d:3d9d])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 2AEAPW0r2754597
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 11:25:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1668421533; bh=b6H00eAFMGc8+8B5fthEuJXkqWQgXFuoE5TlT1Io1b8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=CE/FbFOJE3YRtTNIY2MMIwRm41eZ7Xrsb9zovAbStoODq4lMe3VjKm+zLqNKV2LRZ
         KZr9Nl7O8GaJ15JH/aH5eQPyjOQpmrKf7sdzHKAJKodaHHBplzrP6ouDJcl3O9/x6z
         5QxZRmnAwuoUp3UhhwIiaA0+EFWOe3moKmIKILDQ=
Received: (nullmailer pid 384795 invoked by uid 1000);
        Mon, 14 Nov 2022 10:25:32 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
Organization: m
References: <20221109180249.4721-1-dnlplm@gmail.com>
        <20221109180249.4721-3-dnlplm@gmail.com>
        <20221111091440.51f9c09e@kernel.org>
        <CAGRyCJEtXx4scuFYbpjpe+-UB=XWQX26uhC+yPJPKCoYCWMM2g@mail.gmail.com>
Date:   Mon, 14 Nov 2022 11:25:32 +0100
In-Reply-To: <CAGRyCJEtXx4scuFYbpjpe+-UB=XWQX26uhC+yPJPKCoYCWMM2g@mail.gmail.com>
        (Daniele Palmas's message of "Mon, 14 Nov 2022 10:13:10 +0100")
Message-ID: <87tu31hlyb.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:
> Il giorno ven 11 nov 2022 alle ore 18:14 Jakub Kicinski
> <kuba@kernel.org> ha scritto:
>>
>> On Wed,  9 Nov 2022 19:02:48 +0100 Daniele Palmas wrote:
>> > +bool rmnet_map_tx_agg_skip(struct sk_buff *skb)
>> > +{
>> > +     bool is_icmp =3D 0;
>> > +
>> > +     if (skb->protocol =3D=3D htons(ETH_P_IP)) {
>> > +             struct iphdr *ip4h =3D ip_hdr(skb);
>> > +
>> > +             if (ip4h->protocol =3D=3D IPPROTO_ICMP)
>> > +                     is_icmp =3D true;
>> > +     } else if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
>> > +             unsigned int icmp_offset =3D 0;
>> > +
>> > +             if (ipv6_find_hdr(skb, &icmp_offset, IPPROTO_ICMPV6, NUL=
L, NULL) =3D=3D IPPROTO_ICMPV6)
>> > +                     is_icmp =3D true;
>> > +     }
>> > +
>> > +     return is_icmp;
>> > +}
>>
>> Why this? I don't see it mention in the commit message or any code
>> comment.
>
> This is something I've found in downstream code: with my test setup
> and scenario it does not make any difference on the icmp packets
> timing (both with or without throughput tests ongoing), but I don't
> have access to all the systems for which rmnet is used.
>
> So, I'm not sure if it solves a real issue in other situations.
>
> I can move that out and me or someone else will add it again in case
> there will be a real issue to be solved.

It looks like an attempt to "cheat" latency measurements.  I don't think
we should do that.  Aggregation may be necessary to achieve maximum
throughput in a radio network, but has its obvious bufferbloat downside.
Let's not hide that fact.  Users deserve to know, and tune their systems
accordingly.  Things like this will only make that more difficult


Bj=C3=B8rn
