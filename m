Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8AB6E777D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjDSKd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjDSKdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:33:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA02BBA9
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:33:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 261816223F
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EBEC433EF;
        Wed, 19 Apr 2023 10:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681900413;
        bh=k0BgLmQ64ZVKEtVkl7CXvnY/qjm1wjlJZEmgQcU/q68=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=icjp3Meb6YwMpPGxt+mOUz3X2hUnfPov2/bFPm7FV8XhRlA2uqosw1ehgzPRvyfRl
         lI+9ZxHn1psyMG6dWNswWiXzMJOikkzrhRGuxa5T14UlduuOGmm304FJVUG9L12VbR
         0URXJ14L2Cg1umczphM9TrIb2ITrhmXUBGalxfgcuvFDRdI6Utmv9aYlJwK70ypv2x
         qZl76S5pMyfPiC9Ghia7XvOXTNh5gqbxyD0AyHUj1YoaXUD8sl1DlyDAMl7SxYZo6U
         Cgts5/b/JCz176gf9a6iL7Lhi0GMO5dgI8rNTFEk7oMGktiBVJ69FspSEtHB5kyt83
         uQVmvkQzte7sw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 937BEAA8824; Wed, 19 Apr 2023 12:33:30 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Robert Landers <landers.robert@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Maybe a bug with adding default routes?
In-Reply-To: <CAPzBOBOaTJ8y+CEL6Mvy1qORWRWVVeKnATA=fxeG+=+gFMNC3w@mail.gmail.com>
References: <CAPzBOBNKPYFwm5Fq9hvEPPVk7RHjzPOO5gpnVXeT-2dgk_f69Q@mail.gmail.com>
 <878reourmq.fsf@toke.dk>
 <CAPzBOBOaTJ8y+CEL6Mvy1qORWRWVVeKnATA=fxeG+=+gFMNC3w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 19 Apr 2023 12:33:30 +0200
Message-ID: <874jpcupol.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Landers <landers.robert@gmail.com> writes:

> On Wed, Apr 19, 2023 at 11:51=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen=
 <toke@kernel.org> wrote:
>>
>> Robert Landers <landers.robert@gmail.com> writes:
>>
>> > Hello netdev,
>> >
>> > I believe I either found a bug, or I'm doing something wrong (probably
>> > the latter, or both!). I was experimenting with getting a "floating
>> > IP" for my home lab, and eventually, I got it to work, but it requires
>> > some voodoo, which intrigued me and I think I found some strange
>> > behavior that smells like a bug. I'm on Ubuntu 22.04 (and Pop OS! on
>> > my desktop), so it is also possible that this is fixed upstream (in
>> > which case, I'll email that list next).
>> >
>> > To reproduce is quite simple:
>> >
>> > echo "1234 test" >> /etc/iproute2/rt_tables
>> > ip route add default via 167.235.212.73 dev enp9s0 table test
>> >
>> > This will fail with the error:
>> >
>> > Error: Nexthop has invalid gateway.
>> >
>> > Now, I think this makes sense, however, the routing table shouldn't
>> > need to know about hops, Right? Maybe I'm wrong, but this voodoo
>> > results in a correct routing table:
>> >
>> > ip addr add 167.235.212.72/29 dev enp9s0
>> > ip route add default via 167.235.212.73 dev enp9s0 table test
>> > ip addr del 167.235.212.72/29 dev enp9s0
>> >
>> > I'm not sure if this is a bug or working as designed. It smells like a
>> > bug, but I could just as easily be doing something wrong. I grew up in
>> > "simpler" times and am not nearly as familiar with iproute2 as I was
>> > with the old stuff.
>>
>> Try the 'onlink' flag:
>>
>> ip route add default via 167.235.212.73 dev enp9s0 onlink table test
>>
>> -Toke
>
> Hello Toke,
>
> I tried onlink but it did not work; packets appeared to never leave the d=
evice.

Well, *is* the device on the link? When you tell the kernel that the
gateway device is 'onlink' on a device it means that the kernel will
send out neighbour advertisements to try to find it, so it has to be
answering those. You should be able to see ARP packets going out if you
run tcpdump on the interface...

-Toke
