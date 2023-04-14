Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1FC6E280E
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDNQIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjDNQIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:08:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8955D1996
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681488442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p1mAl6e5hoQopatc/O1ikH49csdUZPPdKAjgD6nyc+o=;
        b=Id9RI0gjC6cEw4D7Q26IvsPFMK7ijIupxhAdAJezE2lVjzBBYr/xFMfuU4iaw3bDOZIpQW
        6ssjKtXY2m2XUms+h0AKOrXMpDwV6gQswTXkX33UKwaI9LgRowGHb1wXX81pn1KBPg+LL3
        OmhIX2U93ZNZ4D2FktXJRNcrkZspiIY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-wkd8GYrsOB645Pjx0tN6kQ-1; Fri, 14 Apr 2023 12:07:21 -0400
X-MC-Unique: wkd8GYrsOB645Pjx0tN6kQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-504899366acso3180420a12.0
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681488440; x=1684080440;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1mAl6e5hoQopatc/O1ikH49csdUZPPdKAjgD6nyc+o=;
        b=I8ibiK/K8iptGVLIjNVn7Bl6WQbidpUg+yLz9Y64tFxXnjYb3N+390miGl64vwS4pY
         yq6gkTYCwFzVjeAS6asMmTGkpXXI71ZyQ7mi/dR3gChUYBuFHex4gZ2whLuZIXBjDYd+
         vvzgFCD6AM5/zFePKZ1n+GtqPjVu5m5NAQ+ZVw6jbiRKX5o/vhR/3akBID+j4nxi7Gf6
         msDo06iMdrDl0mkfJohYehyiNXGMc1lRCTeyTRln8r04nqcj35jj+0D4y2g36eEWo54j
         1gPVcbEACwDo76xtlPH+BFmV7rxpTqzOZQYLYlVd4H9aMnvPd7bPmSvdF15lulazDS6F
         MSLQ==
X-Gm-Message-State: AAQBX9fSPz8iugyLEMaG89T/DfOaFK6R5OKURglZ4V0rbPddD/5a10VA
        Q5fHGtiVllpzATMSKNswv1F3J8ovK7HDgW5gekIClVlRJbCP0UDjuuZsRJ1Cn3av9Kw69LuATcq
        iMx5IkMdTE7yQuGBj
X-Received: by 2002:aa7:c394:0:b0:501:c3de:dc5c with SMTP id k20-20020aa7c394000000b00501c3dedc5cmr5964011edq.18.1681488440096;
        Fri, 14 Apr 2023 09:07:20 -0700 (PDT)
X-Google-Smtp-Source: AKy350aCK59KGROLZcr6w3Fmk0qE2HO+Efpgd6XBYcbjmDGXgoYyKVQNcWusVEj4z2LGimTx1PZM7g==
X-Received: by 2002:aa7:c394:0:b0:501:c3de:dc5c with SMTP id k20-20020aa7c394000000b00501c3dedc5cmr5963948edq.18.1681488439083;
        Fri, 14 Apr 2023 09:07:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q6-20020a056402040600b004f9e6495f94sm2236783edv.50.2023.04.14.09.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:07:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E0B3EAA7D80; Fri, 14 Apr 2023 18:07:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Yafang Shao <laoar.shao@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev
Subject: Re: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
In-Reply-To: <ee52c2e4-4199-da40-8e86-57ef4085c968@iogearbox.net>
References: <20230413025350.79809-1-laoar.shao@gmail.com>
 <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net>
 <874jpj2682.fsf@toke.dk>
 <ee52c2e4-4199-da40-8e86-57ef4085c968@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 14 Apr 2023 18:07:17 +0200
Message-ID: <875y9yzbuy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 4/13/23 4:43 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>=20
>>>> 2). We can't redirect ingress packet to ifb with bpf
>>>> By trying to analyze if it is possible to redirect the ingress packet =
to
>>>> ifb with a bpf program, we find that the ifb device is not supported by
>>>> bpf redirect yet.
>>>
>>> You actually can: Just let BPF program return TC_ACT_UNSPEC for this
>>> case and then add a matchall with higher prio (so it runs after bpf)
>>> that contains an action with mirred egress redirect that pushes to ifb
>>> dev - there is no change needed.
>>=20
>> I wasn't aware that BPF couldn't redirect directly to an IFB; any reason
>> why we shouldn't merge this patch in any case?
>>=20
>>>> This patch tries to resolve it by supporting redirecting to ifb with b=
pf
>>>> program.
>>>>
>>>> Ingress bandwidth limit is useful in some scenarios, for example, for =
the
>>>> TCP-based service, there may be lots of clients connecting it, so it is
>>>> not wise to limit the clients' egress. After limiting the server-side's
>>>> ingress, it will lower the send rate of the client by lowering the TCP
>>>> cwnd if the ingress bandwidth limit is reached. If we don't limit it,
>>>> the clients will continue sending requests at a high rate.
>>>
>>> Adding artificial queueing for the inbound traffic, aren't you worried
>>> about DoS'ing your node?
>>=20
>> Just as an aside, the ingress filter -> ifb -> qdisc on the ifb
>> interface does work surprisingly well, and we've been using that over in
>> OpenWrt land for years[0]. It does have some overhead associated with it,
>> but I wouldn't expect it to be a source of self-DoS in itself (assuming
>> well-behaved TCP traffic).
>
> Out of curiosity, wrt OpenWrt case, can you elaborate on the use case to =
why
> choosing to do this on ingress via ifb rather than on the egress side? I
> presume in this case it's regular router, so pkts would be forwarded anyw=
ay,
> and in your case traversing qdisc layer / queuing twice (ingress phys dev=
 ->
> ifb, egress phys dev), right? What is the rationale that would justify su=
ch
> setup aka why it cannot be solved differently?

Because there's not always a single egress on the other side. These are
mainly home routers, which tend to have one or more WiFi devices bridged
to one or more ethernet ports on the LAN side, and a single upstream WAN
port. And the objective is to control the total amount of traffic going
over the WAN link (in both directions), to deal with bufferbloat in the
ISP network (which is sadly still all too prevalent).

In this setup, the traffic can be split arbitrarily between the links on
the LAN side, and the only "single bottleneck" is the WAN link. So we
install both egress and ingress shapers on this, configured to something
like 95-98% of the true link bandwidth, thus moving the queues into the
qdisc layer in the router. It's usually necessary to set the ingress
bandwidth shaper a bit lower than the egress due to being "downstream"
of the bottleneck link, but it does work surprisingly well.

We usually use something like a matchall filter to put all ingress
traffic on the ifb, so doing the redirect from BPF has not been an
immediate requirement thus far. However, it does seem a bit odd that
this is not possible, and we do have a BPF-based filter that layers on
top of this kind of setup, which currently uses u32 as the ingress
filter and so it could presumably be improved to use BPF instead if that
was available:
https://git.openwrt.org/?p=3Dproject/qosify.git;a=3Dblob;f=3DREADME

-Toke

