Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EBD49FEC8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 18:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343522AbiA1RRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 12:17:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60638 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237031AbiA1RRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 12:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ThL5B3SxUa7qxAOrbzfcl7naTiKrbrgrI94+8lWwPms=; b=RBFksZ1/XbrW4de45UCM4rl41F
        hXWBlKHI3PMZ4oDkc8yRK1nCjlIyrQmKxYcQuT/LhBFvtIkeOKeDi1pjTXaRT2XA7jrq8JX2fq04M
        amBBaM8ptflnIEZ2QkPcgM+31R8Dm0P77UmHloNn7Y/ZJ5KU4P5HLMjle5uP8OsvF4dw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nDUsD-003CdP-Bm; Fri, 28 Jan 2022 18:17:21 +0100
Date:   Fri, 28 Jan 2022 18:17:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        David.Laight@aculab.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 1/2] net: dsa: mv88e6xxx: Improve performance
 of busy bit polling
Message-ID: <YfQlIamPBML0JaET@lunn.ch>
References: <20220128162650.2510062-1-tobias@waldekranz.com>
 <20220128162650.2510062-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128162650.2510062-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 05:26:49PM +0100, Tobias Waldekranz wrote:
> Avoid a long delay when a busy bit is still set and has to be polled
> again.
> 
> Measurements on a system with 2 Opals (6097F) and one Agate (6352)
> show that even with this much tighter loop, we have about a 50% chance
> of the bit being cleared on the first poll, all other accesses see the
> bit being cleared on the second poll.
> 
> On a standard MDIO bus running MDC at 2.5MHz, a single access with 32
> bits of preamble plus 32 bits of data takes 64*(1/2.5MHz) = 25.6us.
> 
> This means that mv88e6xxx_smi_direct_wait took 26us + CPU overhead in
> the fast scenario, but 26us + 1500us + 26us + CPU overhead in the slow
> case - bringing the average close to 1ms.
> 
> With this change in place, the slow case is closer to 2*26us + CPU
> overhead, with the average well below 100us - a 10x improvement.
> 
> This translates to real-world winnings. On a 3-chip 20-port system,
> the modprobe time drops by 88%:
> 
> Before:
> 
> root@coronet:~# time modprobe mv88e6xxx
> real    0m 15.99s
> user    0m 0.00s
> sys     0m 1.52s
> 
> After:
> 
> root@coronet:~# time modprobe mv88e6xxx
> real    0m 2.21s
> user    0m 0.00s
> sys     0m 1.54s
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
