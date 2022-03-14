Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E914D8943
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbiCNQfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiCNQft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84DE62EF
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C823B80E8A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 16:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7F9C340F5;
        Mon, 14 Mar 2022 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647275677;
        bh=fDpnTzwpY+cMfwe6eJ2RSFibw4ziAwpEyait/Iv3Y9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n2xibf38qcNb4OjxajjmesBIz2NS75M09X+oHx+6RW9LJF9Ap8L0Omb6OiYJIm3Mi
         mN/4wxEmQuIKJ1Bp5I8+YLVyzLtXhwP+yXZq8rIF/lARutIIZwDp/yKr48cPk2H4W/
         OfwxFJ1lZTerLVoi4GIhnA7RLfNtViHc58MUNoXf8Ug2IRPQpv95HwFlLL3XBmUTDf
         bRmuTjH627btWENZkclrcAlYcsWJYt8HjcY2TUlhWuni8YofgHxp5YSrzcjKQ4DuzD
         zV2L4CDcrWARLtQgGD8qQ8+J/qzpOxiA9CTqyo32LY2GUwdcO9Gb0W7a57Z7l5Jt/Q
         ktHJhbqiTRc0w==
Date:   Mon, 14 Mar 2022 17:34:33 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jan =?UTF-8?B?QsSbdMOtaw==?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Message-ID: <20220314173433.793d25e8@dellmb>
In-Reply-To: <20220314161706.mo3ph3aadzdqwdag@skbuf>
References: <20220314153410.31744-1-kabel@kernel.org>
        <87tuc0lelc.fsf@waldekranz.com>
        <20220314170529.2b71978d@dellmb>
        <20220314161706.mo3ph3aadzdqwdag@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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

On Mon, 14 Mar 2022 16:17:06 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Mon, Mar 14, 2022 at 05:05:29PM +0100, Marek Beh=C3=BAn wrote:
> > On Mon, 14 Mar 2022 16:48:47 +0100
> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
> >  =20
> > > On Mon, Mar 14, 2022 at 16:34, Marek Beh=C3=BAn <kabel@kernel.org> wr=
ote: =20
> > > > Fix a data structure breaking / NULL-pointer dereference in
> > > > dsa_switch_bridge_leave().
> > > >
> > > > When a DSA port leaves a bridge, dsa_switch_bridge_leave() is calle=
d by
> > > > notifier for every DSA switch that contains ports that are in the
> > > > bridge.
> > > >
> > > > But the part of the code that unsets vlan_filtering expects that th=
e ds
> > > > argument refers to the same switch that contains the leaving port.
> > > >
> > > > This leads to various problems, including a NULL pointer dereferenc=
e,
> > > > which was observed on Turris MOX with 2 switches (one with 8 user p=
orts
> > > > and another with 4 user ports).
> > > >
> > > > Thus we need to move the vlan_filtering change code to the non-cros=
schip
> > > > branch.
> > > >
> > > > Fixes: d371b7c92d190 ("net: dsa: Unset vlan_filtering when ports le=
ave the bridge")
> > > > Reported-by: Jan B=C4=9Bt=C3=ADk <hagrid@svine.us>
> > > > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > > > ---   =20
> > >=20
> > > Hi Marek,
> > >=20
> > > I ran into the same issue a while back and fixed it (or at least thou=
ght
> > > I did) in 108dc8741c20. Has that been applied to your tree? Maybe I
> > > missed some tag that caused it to not be back-ported? =20
> >=20
> > It wasn't applied because I was working with net, not net-next.
> >=20
> > Very well. We will need to get this backported to stable, though.
> >=20
> > Marek =20
>=20
> Who can send Tobias's 2 patches to linux-stable branches for 5.4 and high=
er?

I can, but I thought it should only be done after it gets merged to
Linus' master.

Marek
