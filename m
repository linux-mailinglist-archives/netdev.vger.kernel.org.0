Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2B5698A41
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBPBvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBPBvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:51:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1A541B69;
        Wed, 15 Feb 2023 17:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38956B824F6;
        Thu, 16 Feb 2023 01:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE1AC433EF;
        Thu, 16 Feb 2023 01:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676512302;
        bh=FsPudPD7p8wz8B47HKZ2HfWVKYk9eBwcdFfU90R9wOk=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=jxaoairHkwJLxv+ppQtfTMZ+fLUhsgDRaX9BBh60bo1aRnXPX7D+2xv47l4hkpYlf
         vJTE8U20FP6mzJNiNzoccgP+C9b8zv0MX7mmpS4hYcNa9POAvCXE1/waaW9TMI5REw
         1jZng6AdBDTVGEZikKfMUgK1rdMjwA7g7rE56ufXY4E2ZGibIwlHZr6ufucJstMRox
         SRwOIc29sPv1qwZRWz0VTDT3ZJB9Oqp4HaCCObqw8Pqfnl7V4Qy6tYJrKUV/RxKkVz
         0D67f/pFteltUY9j7gbZH+yCKH7jSyQd+XHc3uPWBdToi300QnYdTaPAS+OC+/I9W8
         cXsXVFL0WPjFA==
Date:   Wed, 15 Feb 2023 17:51:39 -0800
From:   Kees Cook <kees@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>,
        Bruno Goncalves <bgoncalv@redhat.com>
CC:     Networking <netdev@vger.kernel.org>, alan.maguire@oracle.com,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [6.2.0-rc7] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
User-Agent: K-9 Mail for Android
In-Reply-To: <Y+15ZIVyiOWNnTZ8@yury-laptop>
References: <CA+QYu4qkVzZaB2OTaTLniZB9OCbTYUr2qvvvCmAnMkaq43OOLA@mail.gmail.com> <Y+ubkJtpmc6l0gOt@yury-laptop> <CA+QYu4rBbstxtewRVF2hSaVK1i3-CzifPnchfSaxe_EALhR1rA@mail.gmail.com> <Y+15ZIVyiOWNnTZ8@yury-laptop>
Message-ID: <1CAE4AF4-D557-4A18-891D-BAC1B2156B66@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On February 15, 2023 4:31:32 PM PST, Yury Norov <yury=2Enorov@gmail=2Ecom> =
wrote:
>+ Kees Cook <keescook@chromium=2Eorg>
>+ Miguel Ojeda <ojeda@kernel=2Eorg>
>+ Nick Desaulniers <ndesaulniers@google=2Ecom>
>
>On Wed, Feb 15, 2023 at 09:24:52AM +0100, Bruno Goncalves wrote:
>> On Tue, 14 Feb 2023 at 15:32, Yury Norov <yury=2Enorov@gmail=2Ecom> wro=
te:
>> >
>> > On Tue, Feb 14, 2023 at 02:23:06PM +0100, Bruno Goncalves wrote:
>> > > Hello,
>> > >
>> > > recently when testing kernel with debug options set from net-next [=
1]
>> > > and bpf-next [2] the following call trace happens:
>> > >
>> > Hi Bruno,
>> >
>> > Thanks for report=2E
>> >
>> > This looks weird, because the hop_cmp() spent for 3 month in -next ti=
ll
>> > now=2E Anyways, can you please share your NUMA configuration so I'll =
try
>> > to reproduce the bug locally? What 'numactl -H' outputs?
>> >
>>=20
>> Here is the output:
>>=20
>> numactl -H
>> available: 4 nodes (0-3)
>> node 0 cpus: 0 1 2 3 4 5 6 7 32 33 34 35 36 37 38 39
>> node 0 size: 32063 MB
>> node 0 free: 31610 MB
>> node 1 cpus: 8 9 10 11 12 13 14 15 40 41 42 43 44 45 46 47
>> node 1 size: 32248 MB
>> node 1 free: 31909 MB
>> node 2 cpus: 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55
>> node 2 size: 32248 MB
>> node 2 free: 31551 MB
>> node 3 cpus: 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63
>> node 3 size: 32239 MB
>> node 3 free: 31468 MB
>> node distances:
>> node   0   1   2   3
>>   0:  10  21  31  21
>>   1:  21  10  21  31
>>   2:  31  21  10  21
>>   3:  21  31  21  10
>>=20
>> Bruno
>
>So, I was able to reproduce it, and it seems like a compiler issue=2E
>
>The problem is that hop_cmp() calculates pointer to a previous hop
>object unconditionally at the beginning of the function:
>
>       struct cpumask **prev_hop =3D *((struct cpumask ***)b - 1);
>=20
>Obviously, for the first hop, there's no such thing like a previous
>one, and later in the code 'prev_hop' is used conditionally on that:
>
>       k->w =3D (b =3D=3D k->masks) ? 0 : cpumask_weight_and(k->cpus, pre=
v_hop[k->node]);
>
>To me the code above looks like it instructs the compiler to dereference
>'b - 1' only if b !=3D k->masks, i=2Ee=2E when b is not the first hop=2E =
But GCC
>does that unconditionally, which looks wrong=2E
>
>If I defer dereferencing manually like in the snippet below, the kasan
>warning goes away=2E
>
>diff --git a/kernel/sched/topology=2Ec b/kernel/sched/topology=2Ec
>index 48838a05c008=2E=2E5f297f81c574 100644
>--- a/kernel/sched/topology=2Ec
>+++ b/kernel/sched/topology=2Ec
>@@ -2081,14 +2081,14 @@ struct __cmp_key {
>
> static int hop_cmp(const void *a, const void *b)
> {
>-       struct cpumask **prev_hop =3D *((struct cpumask ***)b - 1);
>        struct cpumask **cur_hop =3D *(struct cpumask ***)b;
>        struct __cmp_key *k =3D (struct __cmp_key *)a;
>
>        if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <=3D k->cpu)
>                return 1;
>
>-       k->w =3D (b =3D=3D k->masks) ? 0 : cpumask_weight_and(k->cpus, pr=
ev_hop[k->node]);
>+       k->w =3D (b =3D=3D k->masks) ? 0 :
>+               cpumask_weight_and(k->cpus, (*((struct cpumask ***)b - 1)=
)[k->node]);
>        if (k->w <=3D k->cpu)
>                return 0;
>
>I don't understand why GCC doesn't optimize out unneeded dereferencing=2E
>It does that even if I replace ternary operator with if-else construction=
=2E
>To me it looks like a compiler bug=2E
>
>However, I acknowledge that I'm not a great expert in C standard, so
>it's quite possible that there may be some rule that prevents from
>doing such optimizations, even for non-volatile variables=2E
>
>Adding compiler people=2E Guys, could you please clarify on that?
>If it's my fault, I'll submit fix shortly=2E

My understanding is that without getting inlined, the compiler cannot eval=
uate "b =3D=3D k->masks" at compile time (if it can at all)=2E So since the=
 dereference is part of variable initialization, it's not executed later: i=
t's executed at function entry=2E

Regardless, this whole function looks kind of hard to read=2E Why not full=
y expand it with the if/else logic and put any needed variables into the re=
spective clauses? Then humans can read it and the compiler will optimize it=
 down just as efficiently=2E

-Kees



--=20
Kees Cook
