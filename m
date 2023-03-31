Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FD56D1872
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCaHUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjCaHUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:20:50 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6668199B;
        Fri, 31 Mar 2023 00:20:37 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 329B310000B;
        Fri, 31 Mar 2023 07:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680247236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvzFWPZoJbLjpy//fTibrFofFCEXYcZpmebSixK3cBs=;
        b=O3ZkNbvUJXhH5fmvvWcwQEU9rY3Ql+KX8lGFpCYP2IsDYH0oKTMzhpweSO6ojDYChu2iXD
        ooy5LClYRAN0tOCa3Fkq9sMU1GbykBwVU60bQ0F78vEHr5S4IsLMGpKvsYxAw0xuZfv2+/
        GHBIKViSGkMhiQGpRcY+XhMPoueYo9r3Edj4fO6pKxTDMvqOTg81rQVNJ94V57mwWYCA29
        MxD9PN1ImCvGdUimG+2enxy1XmUxzvmgSxTq9dHwCWi0E7qtajVtr2Ga9SI6YDTp3nUcfg
        PJKU0PR1ZPw2kmY6UQz6q62KA9j73NIATKCkXqiRtcd+L5xSnkzJn9K52r0q7Q==
Date:   Fri, 31 Mar 2023 09:21:12 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Alexis =?UTF-8?B?TG90aG9yw6k=?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rzn1-a5psw: enable DPBU for CPU
 port and fix STP states
Message-ID: <20230331092112.3de13883@fixe.home>
In-Reply-To: <20230330165123.4n2bmvuaixfz34tb@skbuf>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
        <20230330083408.63136-1-clement.leger@bootlin.com>
        <20230330083408.63136-2-clement.leger@bootlin.com>
        <20230330083408.63136-2-clement.leger@bootlin.com>
        <20230330151653.atzd5ptacral6syx@skbuf>
        <20230330174427.0310276a@fixe.home>
        <20230330165123.4n2bmvuaixfz34tb@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 30 Mar 2023 19:51:23 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Thu, Mar 30, 2023 at 05:44:27PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Le Thu, 30 Mar 2023 18:16:53 +0300,
> > Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :
> >  =20
> > > Have you considered adding some Fixes: tags and sending to the "net" =
tree? =20
> >=20
> > I wasn't sure if due to the refactoring that should go directly to the
> > net tree but I'll do that. But since they are fixes, that's the way to
> > go. =20
>=20
> My common sense says that code quality comes first, and so, the code
> looks however it needs to look, keeping in mind that it still needs to
> be a punctual fix for the problem. This doesn't change the fact that
> it's a fix for an an observable bug, and so, it's a candidate for 'net'.

Agreed.

>=20
> That's just my opinion though, others may disagree.
>=20
> > > To be absolutely clear, when talking about BPDUs, is it applicable
> > > effectively only to STP protocol frames, or to any management traffic
> > > sent by tag_rzn1_a5psw.c which has A5PSW_CTRL_DATA_FORCE_FORWARD set?=
 =20
> >=20
> > The documentation uses BPDUs but this is to be understood as in a
> > broader sense for "management frames" since it matches all the MAC with
> > "01-80-c2-00-00-XX".  =20
>=20
> And even so, is it just for frames sent to "01-80-c2-00-00-XX", or for
> all frames sent with A5PSW_CTRL_DATA_FORCE_FORWARD? Other switch
> families can inject whatever they want into ports that are in the
> BLOCKING STP state.

Forced forwarded to disabled ports will only apply to management
frames. At least this is what the documentation says for forced
forwarding (section 4.5.5.4, Table 4.234):

Normal frames will be filtered always (i.e. can never be transmitted to
disabled ports).

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
