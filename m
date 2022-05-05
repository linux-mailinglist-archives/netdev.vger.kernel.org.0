Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7ED151C640
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245708AbiEERmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 13:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244971AbiEERma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:42:30 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F80A57B08
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:38:50 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 572FF24010D
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:38:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651772328; bh=KHnBAH4NavijbLBgpxqUDpbWR0IBU0dr4uSK4a3Nlk4=;
        h=From:To:Cc:Subject:Date:Autocrypt:OpenPGP:From;
        b=nxZea6oDnG8bIvjpguQzu/InPhhAzG4Hx9WGjP7rvkb+/Rk1zXDdn0t2aPfnPoGwu
         36OZk9uyICDRizYUkAPZjYlSji0svdTHEMkBqekT/r4M6xI8uCRLb/J4mVvrRih8L+
         wcLHoAqapR5osDKiTYIkmkgBT6fAorfef2lJbTNP4tguAPI+L1vjEEHjAOYaj2mKyI
         o2OAN9tkTE1/vk/xbJWZkbdm+emfGsbrjDKtUJLKmMmvReYdVjVvvEyusTiMuCGdsX
         A3TFM5WASxJAhDHbnK71n5UqntJXUYM/LoVFwza0B/fnooqlSgC2B2mOwtC/kQX1O+
         xyFh7UdXWz8Vg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4KvLXP6rDbz9rxV;
        Thu,  5 May 2022 19:38:45 +0200 (CEST)
From:   Manuel Ullmann <manuel.ullmann@posteo.de>
To:     Jordan Leppert <jordanleppert@protonmail.com>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        Manuel Ullmann <labre@posteo.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        Holger =?utf-8?Q?Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>, koo5 <kolman.jindrich@gmail.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>
Subject: Re: [EXT] [PATCH] net: atlantic: always deep reset on pm op, fixing
 null deref regression
References: <87czgt2bsb.fsf@posteo.de>
        <1f4b595a-1553-f015-c7a0-6d3075bdbcda@marvell.com>
        <99KGBavpdWUsYAzz1AIlqoFSVt9JXUAmj3Sbso-671ku1gnhokcfi3D9bbh_2xYS_wWYRQOhGxgUsZKsgqkyIivlelLor9zNvpOLC0I3nxA=@protonmail.com>
Date:   Thu, 05 May 2022 17:39:02 +0000
In-Reply-To: <99KGBavpdWUsYAzz1AIlqoFSVt9JXUAmj3Sbso-671ku1gnhokcfi3D9bbh_2xYS_wWYRQOhGxgUsZKsgqkyIivlelLor9zNvpOLC0I3nxA=@protonmail.com>
        (Jordan Leppert's message of "Thu, 05 May 2022 10:24:49 +0000")
Message-ID: <87ee17nakp.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Autocrypt: addr=manuel.ullmann@posteo.de; prefer-encrypt=mutual; keydata=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
OpenPGP: url=https://posteo.de/keys/manuel.ullmann@posteo.de.asc; preference=encrypt
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>
>>
>> > The impact of this regression is the same for resume that I saw on
>> > thaw: the kernel hangs and nothing except SysRq rebooting can be done.
>> >
>> > The null deref occurs at the same position as on thaw.
>> > BUG: kernel NULL pointer dereference
>> > RIP: aq_ring_rx_fill+0xcf/0x210 [atlantic]
>> >
>> > Fixes regression in cbe6c3a8f8f4 ("net: atlantic: invert deep par in
>> > pm functions, preventing null derefs"), where I disabled deep pm
>> > resets in suspend and resume, trying to make sense of the
>> > atl_resume_common deep parameter in the first place.
>> >
>> > It turns out, that atlantic always has to deep reset on pm operations
>> > and the parameter is useless. Even though I expected that and tested
>> > resume, I screwed up by kexec-rebooting into an unpatched kernel, thus
>> > missing the breakage.
>> >
>> > This fixup obsoletes the deep parameter of atl_resume_common, but I
>> > leave the cleanup for the maintainers to post to mainline.
>> >
>> > PS: I'm very sorry for this regression.
>>
>>
>> Hi Manuel,
>>
>> Unfortunately I've missed to review and comment on previous patch - it w=
as too quickly accepted.
>>
>> I'm still in doubt on your fixes, even after rereading the original prob=
lem.
>> Is it possible for you to test this with all the possible combinations?
>> suspend/resume with device up/down,
>> hibernate/restore with device up/down?

I confirm that suspend/resume/hibernation/thaw keeps working in all
cases. Thaw would work without the original patch, if the device is down
before hibernation. I also originally described this behaviour on
bugzilla at

https://bugzilla.kernel.org/show_bug.cgi?id=3D215798

See also Jordan=E2=80=99s confirmation below.

I think, the main reason, why this could break, is, that the deep
parameter had no real impact until the breaking commit. So it was
practically untested, when the allocation/free functions were split.

Another thing, that I tested, was guarding all null pointer references
with null checks, which failed at first, because GCC optimized them
out. I think I have the atlantic tree for this (bad) fix attempt
floating around. I can try to rebase and create a patch from this and
post it to the Github issue, if you are interested.
https://github.com/Aquantia/AQtion/issues/32

Don=E2=80=99t have time for this before the weekend though.

>> I'll try to do the same on our side, but we don't have much resources fo=
r that now unfortunately..
>>
>> > Fixes: cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
>>
>>
>> That tag format is incorrect I think..

Thanks for pointing that out. Also, are those stable Cc tags correct?
Because I figured, that the x in the documentation could be also the
branch name and not a placeholder. Should I resend the patch, fixing the
tags? Won=E2=80=99t get to it before tomorrow, though.

>> Igor

> With the proposed patch (deep parameter is always true), I've managed to =
test:
> 1. Hibernate/restore (with device down/up)
> 2. Suspend/resume (with device down/up)
>
> I put the device down with the command:
> sudo ip link set <connection> down
>
> I hope that's correct, if not please let me know correct command.

This should be the correct.

Manuel
