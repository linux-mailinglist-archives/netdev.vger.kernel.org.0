Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7534451BD1B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbiEEK2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354653AbiEEK2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:28:38 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E6951308
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:24:59 -0700 (PDT)
Date:   Thu, 05 May 2022 10:24:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail2; t=1651746295;
        bh=7RMfSj95e4pJ8ss9Rx/xXv2TRJDKB1JaewUmNggExWc=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=IrA1bVuDjD4T8Oj7QRbuT4MDPja3TX1B4XrO/UDQKYBy7W9EJaTph/8p3kZvpRf3O
         hHpwnHfyGqk7dt7PIH60BUY/jx+hNr1On98YOd1ylNGIQPOgW1yPXxzRZs8RIEn+SN
         l9PvX4oTuR1wd9xRuoD2anSvkPn2PCCfeGHIwM+pXAgkr9FFFD/yDzT+vA5AiRPtZw
         ehszACGUKvt+97ebgPZ3BB3KuBqdyMJ3yWKVO3j55QtkZu5iZTBiBX35JXImljJoDW
         N1RjRM9QXbB8caEbgTY7nx7nKyqo55ZL8HiK/KYTsqAszEkhdIZWzpE4/CCeZHDPm9
         cXFrhWuUXsc6w==
To:     Igor Russkikh <irusskikh@marvell.com>
From:   Jordan Leppert <jordanleppert@protonmail.com>
Cc:     Manuel Ullmann <labre@posteo.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        =?utf-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
        koo5 <kolman.jindrich@gmail.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>
Reply-To: Jordan Leppert <jordanleppert@protonmail.com>
Subject: Re: [EXT] [PATCH] net: atlantic: always deep reset on pm op, fixing null deref regression
Message-ID: <99KGBavpdWUsYAzz1AIlqoFSVt9JXUAmj3Sbso-671ku1gnhokcfi3D9bbh_2xYS_wWYRQOhGxgUsZKsgqkyIivlelLor9zNvpOLC0I3nxA=@protonmail.com>
In-Reply-To: <1f4b595a-1553-f015-c7a0-6d3075bdbcda@marvell.com>
References: <87czgt2bsb.fsf@posteo.de> <1f4b595a-1553-f015-c7a0-6d3075bdbcda@marvell.com>
Feedback-ID: 43610911:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the proposed patch (deep parameter is always true), I've managed to te=
st:
1. Hibernate/restore (with device down/up)
2. Suspend/resume (with device down/up)

I put the device down with the command:
sudo ip link set <connection> down

I hope that's correct, if not please let me know correct command.

Regards,
Jordan


------- Original Message -------
On Thursday, May 5th, 2022 at 08:04, Igor Russkikh <irusskikh@marvell.com> =
wrote:


>
>
> > The impact of this regression is the same for resume that I saw on
> > thaw: the kernel hangs and nothing except SysRq rebooting can be done.
> >
> > The null deref occurs at the same position as on thaw.
> > BUG: kernel NULL pointer dereference
> > RIP: aq_ring_rx_fill+0xcf/0x210 [atlantic]
> >
> > Fixes regression in cbe6c3a8f8f4 ("net: atlantic: invert deep par in
> > pm functions, preventing null derefs"), where I disabled deep pm
> > resets in suspend and resume, trying to make sense of the
> > atl_resume_common deep parameter in the first place.
> >
> > It turns out, that atlantic always has to deep reset on pm operations
> > and the parameter is useless. Even though I expected that and tested
> > resume, I screwed up by kexec-rebooting into an unpatched kernel, thus
> > missing the breakage.
> >
> > This fixup obsoletes the deep parameter of atl_resume_common, but I
> > leave the cleanup for the maintainers to post to mainline.
> >
> > PS: I'm very sorry for this regression.
>
>
> Hi Manuel,
>
> Unfortunately I've missed to review and comment on previous patch - it wa=
s too quickly accepted.
>
> I'm still in doubt on your fixes, even after rereading the original probl=
em.
> Is it possible for you to test this with all the possible combinations?
> suspend/resume with device up/down,
> hibernate/restore with device up/down?
>
> I'll try to do the same on our side, but we don't have much resources for=
 that now unfortunately..
>
> > Fixes: cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
>
>
> That tag format is incorrect I think..
>
> Igor
