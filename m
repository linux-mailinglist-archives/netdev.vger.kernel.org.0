Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3145C50D4CA
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 21:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbiDXTV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 15:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiDXTV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 15:21:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197DD33EA8;
        Sun, 24 Apr 2022 12:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=qEUBBBtfizPnF2ZREwqHESf7fpz3AdIcPRP7AfUvFIk=; b=oY
        SNA3Qq2+dalvye9liAWtt3da+i+RgRuHJDngrkgCF2RwEmlDcv+JFM9131LIVuo227BrgAN3AMJfd
        1zqaSoRqCCxvh+mOmLeFRH0alC8I02bKfmn7csP1jHljsOhaQGqBqPpR0snUnzN3tEdcnGri579Q0
        1YRgUoYo8jgRdxU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nihkT-00HIb7-M3; Sun, 24 Apr 2022 21:18:21 +0200
Date:   Sun, 24 Apr 2022 21:18:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Nathan Rossi <nathan@nathanrossi.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Fix port_hidden_wait to account for
 port_base_addr
Message-ID: <YmWifeWNSlpNrJkl@lunn.ch>
References: <20220424141759.315303-1-nathan@nathanrossi.com>
 <20220424165228.4030aea6@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220424165228.4030aea6@thinkpad>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 04:52:28PM +0200, Marek Behún wrote:
> On Sun, 24 Apr 2022 14:17:59 +0000
> Nathan Rossi <nathan@nathanrossi.com> wrote:
> 
> > The other port_hidden functions rely on the port_read/port_write
> > functions to access the hidden control port. These functions apply the
> > offset for port_base_addr where applicable. Update port_hidden_wait to
> > use the port_wait_bit so that port_base_addr offsets are accounted for
> > when waiting for the busy bit to change.
> > 
> > Without the offset the port_hidden_wait function would timeout on
> > devices that have a non-zero port_base_addr (e.g. MV88E6141), however
> > devices that have a zero port_base_addr would operate correctly (e.g.
> > MV88E6390).
> 
> So basically the code is accessing the wrong register for devices with
> non-zero port_base_addr. This means that the patch should have a Fixes
> tag with the commit that introduced this bug, so that it gets
> backported to relevant stable versions.
> 
> Could you resend with Fixes tag?

I think that would be:

Fixes: 609070133aff ("net: dsa: mv88e6xxx: update code operating on hidden registers")

That patch moved the code out of chip.c into port_hidden. At the same
time, the functions got renamed from mv88e6390_hidden_read() to
mv886xxx_hidden_read(). 6390 does have zero-based ports, so was
correct before the rename. But the more generic name suggest it should
take into account devices which do not have zero based ports.

With the fixes tag added and based on met:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
