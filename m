Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CBE499274
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 21:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356803AbiAXUU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 15:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380392AbiAXUQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 15:16:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00A5C01D7E6
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 11:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EE8A61539
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 19:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E14C340E7;
        Mon, 24 Jan 2022 19:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643053094;
        bh=MYr6mu5wHgq1Wga2Gb1pnQGBNm13OUVOV1h3zNmZBxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y4u1vGODus3Tj9vFBb6EV3Xg3H7tLvmOePomxh19ziEMusO1EqOXbPoR6nJFks/kv
         vZc94PSyN+GI3GntiQySCywTb3eMEL5bS06G6CbFcOG3CPSOH0xoEks9IfCQDnydy1
         pR5uglh5SbByODMgwAeW3nzfo7h+RNqHAFmtEqehxo3KZNi4Ss+HoTvbxmJCOsmGzo
         kdEwClfvVpnjMSpFlrWzj2kxKGvroqnUCQHinMrz6ddXUy6wHOTHA6wEN4XVZUaRss
         rCqblvx1rMmQtlWmzBd4z42nu7pEIYCfd355REZTYLNGIPrKqyz4zdjlgdHf42JKhU
         Eq+7n+m9zgVzQ==
Date:   Mon, 24 Jan 2022 11:38:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb:
 multiple cpu ports, non cpu extint
Message-ID: <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124190845.md3m2wzu7jx4xtpr@skbuf>
References: <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
        <20220121224949.xb3ra3qohlvoldol@skbuf>
        <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
        <20220124153147.agpxxune53crfawy@skbuf>
        <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124165535.tksp4aayeaww7mbf@skbuf>
        <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
        <20220124172158.tkbfstpwg2zp5kaq@skbuf>
        <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124190845.md3m2wzu7jx4xtpr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 21:08:45 +0200 Vladimir Oltean wrote:
> On Mon, Jan 24, 2022 at 10:20:51AM -0800, Jakub Kicinski wrote:
> > On Mon, 24 Jan 2022 09:35:56 -0800 Jakub Kicinski wrote:  
> > > Sorry I used "geometry" loosely.
> > >
> > > What I meant is simply that if the driver uses NETIF_F_IP*_CSUM
> > > it should parse the packet before it hands it off to the HW.
> > >
> > > There is infinity of protocols users can come up with, while the device
> > > parser is very much finite, so it's only practical to check compliance
> > > with the HW parser in the driver. The reverse approach of adding
> > > per-protocol caps is a dead end IMO. And we should not bloat the stack
> > > when NETIF_F_HW_CSUM exists and the memo that parsing packets on Tx is
> > > bad b/c of protocol ossification went out a decade ago.  
> >  
> > > It's not about DSA. The driver should not check
> > >
> > > if (dsa())
> > > 	blah;
> > >
> > > it should check
> > >
> > > if (!(eth [-> vlan] -> ip -> tcp/udp))
> > > 	csum_help();  
> >
> > Admittedly on a quick look thru the drivers which already do this
> > I only see L3, L4 and GRE/UDP encap checks. Nothing validates L2.  
> 
> So before we declare that any given Ethernet driver is buggy for declaring
> NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM and not checking that skb->csum_start
> points where it expects it to (taking into consideration potential VLAN
> headers, IPv6 extension headers), 

Extension headers are explicitly not supported by NETIF_F_IPV6_CSUM.

IIRC Tom's hope was to delete NETIF_F_IP*_CSUM completely once all
drivers are converted to parsing and therefore can use NETIF_F_HW_CSUM.

> is there any driver that _does_ perform these checks correctly, that
> could be used as an example?

I don't think so. Let me put it this way - my understanding is that up
until now we had been using the vlan_features, mpls_features etc to
perform L2/L2.5/below-IP feature stripping. This scales poorly to DSA
tags, as discussed in this thread.

I'm suggesting we extend the kind of checking we already do to work
around inevitable deficiencies of device parsers for tunnels to DSA
tags.

We can come up with various schemes of expressing capabilities
between underlying driver and tag driver. I'm not aware of similar
out-of-band schemes existing today so it'd be "DSA doing it's own
thing", which does not seem great.
