Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC6235C900
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242643AbhDLOjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242733AbhDLOje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:39:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113F2610CA;
        Mon, 12 Apr 2021 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618238356;
        bh=4iaq/hWN+JZ86ndvjDUD0IpAoN+dU38yNS/GbzTSJc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YIqq0P9GIDgEU8pUsU2Q12JNtQY9k2Q+G9Aa918gwwQDeyFNlrvKCKisuvaHOrc5O
         f6EBLC67gkuto5UGw4sngfEv6TfZmCSAtoL9UpQa3uKsV9oMoUMZXCmObGTDujXTV2
         u0MhR82joS9uk3kQb2FPToAGanWFZt8j09BB+XxkrNZW4Qg61dOfUbnJlLopq/Wy50
         2zYxAK1dsaw+xXu9ByR+PNSDJXuvgqpAq4aioL3uHCQ0KAWEXQMSAbEzNxc0aVME9U
         21lZobBP5FneQkCJ5KSl8ne17U2VrXkhndfkNBis6w2OQYCOg9mrkAaSSJBFHafrkJ
         8pmcjcCmrtXbw==
Received: by pali.im (Postfix)
        id B17BF687; Mon, 12 Apr 2021 16:39:13 +0200 (CEST)
Date:   Mon, 12 Apr 2021 16:39:13 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <20210412143913.qhlge7koggjswyjg@pali>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
 <20210412133447.fyqkavrs5r5wbino@pali>
 <YHRZa9R22UyIRSd9@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHRZa9R22UyIRSd9@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 12 April 2021 16:30:03 Andrew Lunn wrote:
> > > > +/* This table contains representative model for every family */
> > > > +static const enum mv88e6xxx_model family_model_table[] = {
> > > > +	[MV88E6XXX_FAMILY_6095] = MV88E6095,
> > > > +	[MV88E6XXX_FAMILY_6097] = MV88E6097,
> > > > +	[MV88E6XXX_FAMILY_6185] = MV88E6185,
> > > > +	[MV88E6XXX_FAMILY_6250] = MV88E6250,
> > > > +	[MV88E6XXX_FAMILY_6320] = MV88E6320,
> > > > +	[MV88E6XXX_FAMILY_6341] = MV88E6341,
> > > > +	[MV88E6XXX_FAMILY_6351] = MV88E6351,
> > > > +	[MV88E6XXX_FAMILY_6352] = MV88E6352,
> > > > +	[MV88E6XXX_FAMILY_6390] = MV88E6390,
> > > > +};
> > > 
> > > This table is wrong. MV88E6390 does not equal
> > > MV88E6XXX_PORT_SWITCH_ID_PROD_6390. MV88E6XXX_PORT_SWITCH_ID_PROD_6390
> > > was chosen because it is already an MDIO device ID, in register 2 and
> > > 3. It probably will never clash with a real Marvell PHY ID. MV88E6390
> > > is just a small integer, and there is a danger it will clash with a
> > > real PHY.
> > 
> > So... how to solve this issue? What should be in the mapping table?
> 
> You need to use MV88E6XXX_PORT_SWITCH_ID_PROD_6095,
> MV88E6XXX_PORT_SWITCH_ID_PROD_6097,
> ...
> MV88E6XXX_PORT_SWITCH_ID_PROD_6390,

But I'm using it.

First chip->info->family (enum mv88e6xxx_family; MV88E6XXX_FAMILY_6341)
is mapped to enum mv88e6xxx_model (MV88E6341) via family_model_table[]
and then enum mv88e6xxx_model (MV88E6341) is mapped to prod_num
(MV88E6XXX_PORT_SWITCH_ID_PROD_6341) via mv88e6xxx_table[].

All this is done in mv88e6xxx_physid_for_family() function.

So at the end, this function converts MV88E6XXX_FAMILY_6341 to
MV88E6XXX_PORT_SWITCH_ID_PROD_6341.

And therefore I do not see anything wrong in family_model_table[] table.

I defined family_model_table[] table to just maps enum mv88e6xxx_family
to enum mv88e6xxx_model as mv88e6xxx_table[] table already contains
mapping from enum mv88e6xxx_model to phys_id, to simplify
implementation.
