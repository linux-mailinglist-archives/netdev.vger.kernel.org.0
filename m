Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D475D353608
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 02:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbhDDAqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 20:46:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33090 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236526AbhDDAqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 20:46:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lSqu0-00EhXI-4U; Sun, 04 Apr 2021 02:46:08 +0200
Date:   Sun, 4 Apr 2021 02:46:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 5/9] net: dsa: qca: ar9331: add forwarding
 database support
Message-ID: <YGkMUPtDYygvVg4B@lunn.ch>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-6-o.rempel@pengutronix.de>
 <YGiI3JtqU7Ezlbxb@lunn.ch>
 <20210403234847.jceg4ubljdq3g7n5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403234847.jceg4ubljdq3g7n5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Plus, i'm not actually sure we should be issuing warnings here. What
> > does the bridge code do in this case? Is it silent and just does it,
> > or does it issue a warning?
> 
> :D
> 
> What Oleksij doesn't know, I bet, is that he's using the bridge bypass
> commands:
> 
> bridge fdb add dev lan0 00:01:02:03:04:05
> 
> That is the deprecated way of managing FDB entries, and has several
> disadvantages such as:
> - the bridge software FDB never gets updated with this entry, so other
>   drivers which might be subscribed to DSA's FDB (imagine a non-DSA
>   driver having the same logic as our ds->assisted_learning_on_cpu_port)
>   will never see these FDB entries
> - you have to manage duplicates yourself

I was actually meaning a pure software bridge, with unaccelerated
interfaces. It has a dynamic MAC address in its tables, and the user
adds a static. Ideally, we want the same behaviour.

And i think the answer is:

static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
                  const unsigned char *addr, u16 vid)
{
        struct net_bridge_fdb_entry *fdb;

        if (!is_valid_ether_addr(addr))
                return -EINVAL;

        fdb = br_fdb_find(br, addr, vid);
        if (fdb) {
                /* it is okay to have multiple ports with same
                 * address, just use the first one.
                 */
                if (test_bit(BR_FDB_LOCAL, &fdb->flags))
                        return 0;
                br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
                       source ? source->dev->name : br->dev->name, addr, vid);
                fdb_delete(br, fdb, true);
        }

        fdb = fdb_create(br, source, addr, vid,
                         BIT(BR_FDB_LOCAL) | BIT(BR_FDB_STATIC));
        if (!fdb)
                return -ENOMEM;

        fdb_add_hw_addr(br, addr);
        fdb_notify(br, fdb, RTM_NEWNEIGH, true);
        return 0;
}

So it looks like it warns and then replaces the dynamic entry.

So having the DSA driver also warn is maybe O.K. Having said that, i
don't think any other DSA driver does.

   Andrew
