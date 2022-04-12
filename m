Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2544FE1A5
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355160AbiDLNFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355978AbiDLNDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:03:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F008694AE;
        Tue, 12 Apr 2022 05:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lfItqZaGSX0QThCc5e9sA+/hDp4Ggp82nkkyTViikdo=; b=dRTOHcDgUBrhr87pfCqONLmjY/
        8PP4CAAUcDetHx+NyK9DyKNeUSZWIfiRrje7egcYTjebN8Z03S6yQELEaX7a0ebidNYLXMl9hHr7u
        NxnYDv5UlREdLx/kOJ/wPqYzNnwaPxIimlfv9c7TlKysEPlplgxXVmn6pXcpkpHFhOvY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1neFrO-00FRrw-UX; Tue, 12 Apr 2022 14:43:06 +0200
Date:   Tue, 12 Apr 2022 14:43:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Message-ID: <YlVz2gqXbgtFZUhA@lunn.ch>
References: <20220411210406.21404-1-luizluca@gmail.com>
 <YlTFRqY3pq84Fw1i@lunn.ch>
 <CAJq09z7CDbaFdjkmqiZsPM1He4o+szMEJANDiaZTCo_oi+ZCSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z7CDbaFdjkmqiZsPM1He4o+szMEJANDiaZTCo_oi+ZCSQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 01:12:51AM -0300, Luiz Angelo Daros de Luca wrote:
> > On Mon, Apr 11, 2022 at 06:04:07PM -0300, Luiz Angelo Daros de Luca wrote:
> > > RTL8367RB-VB was not mentioned in the compatible table, nor in the
> > > Kconfig help text.
> > >
> > > The driver still detects the variant by itself and ignores which
> > > compatible string was used to select it. So, any compatible string will
> > > work for any compatible model.
> >
> > Meaning the compatible string is pointless, and cannot be trusted. So
> > yes, you can add it, but don't actually try to use it for anything,
> > like quirks.
> 
> 
> Thanks, Andrew. Those compatible strings are indeed useless for now.
> The driver probes the chip variant. Maybe in the future, if required,
> we could provide a way to either force a model or let it autodetect as
> it does today.

The problem is, you have to assume some percentage of shipped DT blobs
have the wrong compatible string, but work because it is not actually
used in a meaningful way. This is why the couple of dozen Marvell
switches have just 3 compatible strings, which is enough to find the
ID registers to identify the actual switch. The three compatibles are
the name of the lowest chip in the family which introduced to location
of the ID register.

> There is no "family name" for those devices. The best we had was
> rtl8367c (with "c" probably meaning 3rd family). I suggested renaming
> the driver to rtl8367c but, in the end, we kept it as the first
> supported device name. My plan is, at least, to allow the user to
> specify the correct model without knowing which model it is equivalent
> to.

In order words, you are quite happy to allow the DT author to get is
wrong, and do not care it is wrong. So the percentage of DT blobs with
the wrong compatible will go up, making it even more useless.

It is also something you cannot retrospectively make useful, because
of all those broken DT blobs.

    Andrew
