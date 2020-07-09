Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C853421A8D9
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGIUWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:22:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgGIUWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:22:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtd3z-004NLP-BI; Thu, 09 Jul 2020 22:22:35 +0200
Date:   Thu, 9 Jul 2020 22:22:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     linux-mediatek@lists.infradead.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <landen.chao@mediatek.com>
Subject: Re: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix mtu warning
Message-ID: <20200709202235.GB1037260@lunn.ch>
References: <20200709055742.3425-1-frank-w@public-files.de>
 <20200709134115.GK928075@lunn.ch>
 <trinity-487c0605-faeb-462e-a373-bc393ce3dbfa-1594324081639@3c-app-gmx-bap65>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-487c0605-faeb-462e-a373-bc393ce3dbfa-1594324081639@3c-app-gmx-bap65>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 09:48:01PM +0200, Frank Wunderlich wrote:
> > Gesendet: Donnerstag, 09. Juli 2020 um 15:41 Uhr
> > Von: "Andrew Lunn" <andrew@lunn.ch>
> 
> > > +	eth->netdev[id]->max_mtu = 1536;
> >
> > I assume this is enough to make the DSA warning go away, but it is the
> > true max? I have a similar patch for the FEC driver which i should
> > post sometime. Reviewing the FEC code and after some testing, i found
> > the real max was 2K - 64.
> 
> i tried setting only the max_mtu, but the dsa-error is still present
> 
> mt7530 mdio-bus:00: nonfatal error -95 setting MTU on port 0
> 
> but i got it too, if i revert the change...mhm, strange that these were absent last time...
> 
> the other 2 are fixed with only max_mtu.
> @andrew where did you got the 2k-64 (=1984) information? sounds like orwell ;)

drivers/net/ethernet/freescale/fec_main.c:

/* The FEC stores dest/src/type/vlan, data, and checksum for receive packets.
 *
 * 2048 byte skbufs are allocated. However, alignment requirements
 * varies between FEC variants. Worst case is 64, so round down by 64.
 */
#define PKT_MAXBUF_SIZE         (round_down(2048 - 64, 64))

So i set the max MTU to this.

> 1405 static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
> ...
> 1420     if (!ds->ops->port_change_mtu)
> 1421         return -EOPNOTSUPP;

Yes, i also needed to change the mv88e6xxx driver to implement this
function. These switches do support jumbo frames, so i had some real
code in there, not a dummy function.

The marketing brief for the mt7530 says it supports 1518, 1536, 1552
and 9K jumbo frames. It would be good if you can figure out how to
support that, rather than add a dummy function.

	Andrew
