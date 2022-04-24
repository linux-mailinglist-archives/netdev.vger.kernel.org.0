Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E6150D5CA
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 00:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239831AbiDXWgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 18:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbiDXWgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 18:36:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4563EDA6DE;
        Sun, 24 Apr 2022 15:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=y6q+ZtwYVVqgvINMu3c9e88XwwIPS7RjfI0Q8swWzzM=; b=dZ
        l1W9+kBuFfB6ll40w+LW8Rff2nU+7i4xxPkpTKq//VziqPVkJxEREPmX75m7DBS93ILe3ZUuHcjaQ
        0cRPfqkZg+9sGXIhoXd+yT4s8gN2lWrBkp1PivWBvsJpEf+dgn/NtEu7XrbTZHQ+QbtfEWEQiTuQU
        qlVWzBV47VeJwcE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nikn5-00HJbw-W5; Mon, 25 Apr 2022 00:33:15 +0200
Date:   Mon, 25 Apr 2022 00:33:15 +0200
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
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: Fix port_hidden_wait to account
 for port_base_addr
Message-ID: <YmXQK7Wzb1GDxwRP@lunn.ch>
References: <20220424153143.323338-1-nathan@nathanrossi.com>
 <YmWkgkILCrBP5hRG@lunn.ch>
 <20220424213359.246cd5ab@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220424213359.246cd5ab@thinkpad>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 09:33:59PM +0200, Marek Behún wrote:
> On Sun, 24 Apr 2022 21:26:58 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Sun, Apr 24, 2022 at 03:31:43PM +0000, Nathan Rossi wrote:
> > > The other port_hidden functions rely on the port_read/port_write
> > > functions to access the hidden control port. These functions apply the
> > > offset for port_base_addr where applicable. Update port_hidden_wait to
> > > use the port_wait_bit so that port_base_addr offsets are accounted for
> > > when waiting for the busy bit to change.
> > > 
> > > Without the offset the port_hidden_wait function would timeout on
> > > devices that have a non-zero port_base_addr (e.g. MV88E6141), however
> > > devices that have a zero port_base_addr would operate correctly (e.g.
> > > MV88E6390).
> > > 
> > > Fixes: ea89098ef9a5 ("net: dsa: mv88x6xxx: mv88e6390 errata")  
> > 
> > That is further back than needed. And due to the code moving around
> > and getting renamed, you are added extra burden on those doing the
> > back port for no actual gain.
> > 
> > Please verify what i suggested, 609070133aff1 is better and then
> > repost.
> 
> The bug was introduced by ea89098ef9a5.

I have to disagree with that. ea89098ef9a5 adds:

mv88e6390_hidden_wait()

The mv88e6390_ means it should be used with the mv88e6390 family. And
all members of that family have port offset 0. There is no bug here.

609070133aff1 renames it to mv88e6xxx_port_hidden_wait(). It now has
the generic mv88e6xxx_ prefix, so we can expect it to work with any
device. But it does not. This is where the bug has introduced.

But what i think is more important, is i doubt git cherry-pick is
clever enough to be able to follow 609070133aff1 and know where to
make the change in revisions before then. So it is going to need a
human to figure out the backport. And that effort is a waist of time,
because there is no bug before then.

	Andrew
