Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8020A50D5F3
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 01:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239875AbiDXXTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 19:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiDXXTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 19:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9545DA14;
        Sun, 24 Apr 2022 16:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A30F061403;
        Sun, 24 Apr 2022 23:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5D0C385A9;
        Sun, 24 Apr 2022 23:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650842204;
        bh=6T03LaLReh/sJQiUkLFFqaOo6i6Nc3czaMED5kSzdis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oo1NQDqPa9tuSnDmrEoK713ufmriHKL3PDGnGM87OPsOownItQTSWT7prWtXciVMJ
         W4gFw0ZAcjFH1aLKZlj/lxef1AdQOwhHk8ZWjyzUCYkfnIHDDKyP4DkSoVWO4k1lFv
         d+QvM6tltsONzKMEayOzGYwsmupOZENfrgY5JwpuYxJNo8W5T4HQpn/g0pkilZ6VSS
         G5MVxPZnzOPBnr7A3V7CSopraCyaZ/H07qeP39rdlLMYvrXOpUM7GfzQdd/cwiCiUP
         gH8EmfKUAw836si+MzXfzoTMIgjdjOWfKHDAM8Y17grmTuraYM0CgmlQwyqi2BMiPC
         IhXqwJxDV8m3Q==
Date:   Mon, 25 Apr 2022 01:16:38 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Nathan Rossi <nathan@nathanrossi.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: Fix port_hidden_wait to account
 for port_base_addr
Message-ID: <20220425011638.70065c7b@thinkpad>
In-Reply-To: <YmXQK7Wzb1GDxwRP@lunn.ch>
References: <20220424153143.323338-1-nathan@nathanrossi.com>
        <YmWkgkILCrBP5hRG@lunn.ch>
        <20220424213359.246cd5ab@thinkpad>
        <YmXQK7Wzb1GDxwRP@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022 00:33:15 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Sun, Apr 24, 2022 at 09:33:59PM +0200, Marek Beh=C3=BAn wrote:
> > On Sun, 24 Apr 2022 21:26:58 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> > > On Sun, Apr 24, 2022 at 03:31:43PM +0000, Nathan Rossi wrote: =20
> > > > The other port_hidden functions rely on the port_read/port_write
> > > > functions to access the hidden control port. These functions apply =
the
> > > > offset for port_base_addr where applicable. Update port_hidden_wait=
 to
> > > > use the port_wait_bit so that port_base_addr offsets are accounted =
for
> > > > when waiting for the busy bit to change.
> > > >=20
> > > > Without the offset the port_hidden_wait function would timeout on
> > > > devices that have a non-zero port_base_addr (e.g. MV88E6141), howev=
er
> > > > devices that have a zero port_base_addr would operate correctly (e.=
g.
> > > > MV88E6390).
> > > >=20
> > > > Fixes: ea89098ef9a5 ("net: dsa: mv88x6xxx: mv88e6390 errata")   =20
> > >=20
> > > That is further back than needed. And due to the code moving around
> > > and getting renamed, you are added extra burden on those doing the
> > > back port for no actual gain.
> > >=20
> > > Please verify what i suggested, 609070133aff1 is better and then
> > > repost. =20
> >=20
> > The bug was introduced by ea89098ef9a5. =20
>=20
> I have to disagree with that. ea89098ef9a5 adds:
>=20
> mv88e6390_hidden_wait()
>=20
> The mv88e6390_ means it should be used with the mv88e6390 family. And
> all members of that family have port offset 0. There is no bug here.
>=20
> 609070133aff1 renames it to mv88e6xxx_port_hidden_wait(). It now has
> the generic mv88e6xxx_ prefix, so we can expect it to work with any
> device. But it does not. This is where the bug has introduced.

You are right. My bad, sorry.

Marek
