Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1922D4DB7EB
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244855AbiCPSbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiCPSbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F0C5F27D
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1182B81A71
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335F3C340E9;
        Wed, 16 Mar 2022 18:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647455385;
        bh=ZVH/M+sljZqGJEFmI270+tW+0Dka+Y5KE07Sy6ceOOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IUyCrav9t61p76G5dXp7yv4hUsYfIwf93F20gqSt6SMG5fRVavIokV8JgsC4QXyZB
         m8lHTcAIfT0HEFFGtFBOh3kGFJSOegLB3Ti2IRB7xQS/wlUy+bOCkAnodlnpBG1t1t
         zmgX/mr2hhfaJg3wuDGKBMCv0KjfwiS31sdnULbibR+B7Vk+1BPNBygz0ylxRQR9lP
         mfLFsQFAGzn1HRY0ls+C1MMx6pTVprg8sfayygKNSs5+RcQL63hPg7Stcj6QFiwLOF
         7X/QOypLC2gbSlkT2inW93ZdQ2VCU8NOQ+TEYR/NCKn2EOi8jWXv1OK+xwJyL9rYZx
         8r/wkgEqyJNZg==
Date:   Wed, 16 Mar 2022 11:29:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Message-ID: <20220316112943.266df1d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
        <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 08:35:58 +0100 Oliver Hartkopp wrote:
> On 16.03.22 02:51, Jakub Kicinski wrote:
> > On Tue, 15 Mar 2022 21:37:48 +0100 Oliver Hartkopp wrote: =20
> >> Syzbot created an environment that lead to a state machine status that
> >> can not be reached with a compliant CAN ID address configuration.
> >> The provided address information consisted of CAN ID 0x6000001 and 0xC=
28001
> >> which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.
> >>
> >> Sanitize the SFF/EFF CAN ID values before performing the address check=
s.
> >>
> >> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> >> Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
> >> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net> =20
> >=20
> > CC Marc, please make sure you CC maintainers. =20
>=20
> Oh, that would have been better! I'm maintaining the CAN network layer=20
> stuff together with Marc and there was no relevant stuff in can-next to=20
> be pulled in the next days. So I sent it directly to hit the merge=20
> window and had all of us in the reply to the syzbot report.
>=20
> Will CC Marc next time when posting to netdev only!
>=20
> Maybe I treated this patch more urgent than it needed to be handled=20
> =C2=AF\_(=E3=83=84)_/=C2=AF

Heh, I did think to myself "why is Oliver sending this directly"=20
but wasn't confident enough to conclude that it's intentional :)
Feel free to add any random info / context under the --- marker
in a patch.
