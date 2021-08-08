Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB7A3E3B22
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhHHPhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:37:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhHHPhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 11:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/1P+yLDe0y4C43tXkY+8Rjab6dcLUIZBjOwkOO4f2/0=; b=yIq80tGVCjnthVIMLvU1QcSZzH
        3dOzJOyJ5O5PSQGbsEnohjkDISoKMjK7r+UZ6UesdPV8o34nJ5aCdkEA4YhLuNHbfRU49GtLKkYLO
        k1DU1RSdUlBr/vE1oHyO5hl+GgM2YKEt0JReAdBZ754STejZhub8VVzZwQeNPOx4KG/8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCkrI-00GaoD-1x; Sun, 08 Aug 2021 17:37:04 +0200
Date:   Sun, 8 Aug 2021 17:37:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: don't fast age standalone ports
Message-ID: <YQ/6IEA2F4BAuZOG@lunn.ch>
References: <20210808111637.3819465-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808111637.3819465-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 02:16:37PM +0300, Vladimir Oltean wrote:
> DSA drives the procedure to flush dynamic FDB entries from a port based
> on the change of STP state: whenever we go from a state where address
> learning is enabled (LEARNING, FORWARDING) to a state where it isn't
> (LISTENING, BLOCKING, DISABLED), we need to flush the existing dynamic
> entries.
> 
> However, there are cases when this is not needed. Internally, when a
> DSA switch interface is not under a bridge, DSA still keeps it in the
> "FORWARDING" STP state. And when that interface joins a bridge, the
> bridge will meticulously iterate that port through all STP states,
> starting with BLOCKING and ending with FORWARDING. Because there is a
> state transition from the standalone version of FORWARDING into the
> temporary BLOCKING bridge port state, DSA calls the fast age procedure.
> 
> Since commit 5e38c15856e9 ("net: dsa: configure better brport flags when
> ports leave the bridge"), DSA asks standalone ports to disable address
> learning. Therefore, there can be no dynamic FDB entries on a standalone
> port. Therefore, it does not make sense to flush dynamic FDB entries on
> one.

Hi Vladimir

Do all DSA drivers actually support disabling learning on a port?  If
there are any which cannot disable learning, we still need the flush
somehow.

	Andrew
