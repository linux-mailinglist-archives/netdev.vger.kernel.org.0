Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A4529CC11
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506482AbgJ0Wgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:36:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506363AbgJ0Wgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 18:36:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXXZs-003skn-EY; Tue, 27 Oct 2020 23:36:28 +0100
Date:   Tue, 27 Oct 2020 23:36:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027223628.GG904240@lunn.ch>
References: <20201027105117.23052-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias

> All LAG configuration is cached in `struct dsa_lag`s. I realize that
> the standard M.O. of DSA is to read back information from hardware
> when required. With LAGs this becomes very tricky though. For example,
> the change of a link state on one switch will require re-balancing of
> LAG hash buckets on another one, which in turn depends on the total
> number of active links in the LAG. Do you agree that this is
> motivated?

As you say, DSA tries to be stateless and not allocate any
memory. That keeps things simple. If you cannot allocate the needed
memory, you need to ensure you leave the system untouched. And that
needs to happen all the way up the stack when you have nested devices
etc. That is why many APIs have a prepare phase and then a commit
phase. The prepare phase allocates all the needed memory, can fail,
but does not otherwise touch the running system. The commit phase
cannot fail, since it has everything it needs.

If you are dynamically allocating dsa_lag structures, at run time, you
need to think about this. But the number of LAGs is limited by the
number of ports. So i would consider just allocating the worst case
number at probe, and KISS for runtime.

> At least on mv88e6xxx, the exact source port is not available when
> packets are received on the CPU. The way I see it, there are two ways
> around that problem:

Does that break team/bonding? Do any of the algorithms send packets on
specific ports to make sure they are alive? I've not studied how
team/bonding works, but it must have a way to determine if a link has
failed and it needs to fallover.

> (mv88e6xxx) The cross-chip PVT changes required to allow a LAG to
> communicate with the other ports do not feel quite right, but I'm
> unsure about what the proper way of doing it would be. Any ideas?

Vivien implemented all that. I hope he can help you, i've no real idea
how that all works.

> (mv88e6xxx) Marvell has historically used the idiosyncratic term
> "trunk" to refer to link aggregates. Somewhere around the Peridot they
> have switched and are now referring to the same registers/tables using
> the term "LAG". In this series I've stuck to using LAG for all generic
> stuff, and only used trunk for driver-internal functions. Do we want
> to rename everything to use the LAG nomenclature?

Where possible, i would keep to the datasheet terminology. So any 6352
specific function should use 6352 terminology. Any 6390 specific
function should use 6390 terminology. For code which supports a range
of generations, we have used the terminology from the first device
which had the feature. In practice, this probably means trunk is going
to be used most of the time, and LAG in just 6390 code. Often, the
glue code in chip.c uses linux stack terminology.

   Andrew
