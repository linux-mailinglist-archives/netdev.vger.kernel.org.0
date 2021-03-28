Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252E734BF8A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 00:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhC1WFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 18:05:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhC1WEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 18:04:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQdWR-00DWCD-8A; Mon, 29 Mar 2021 00:04:39 +0200
Date:   Mon, 29 Mar 2021 00:04:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: Allow default tag protocol to be
 overridden from DT
Message-ID: <YGD9d/zeJtAXxC8K@lunn.ch>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-3-tobias@waldekranz.com>
 <YGCmS2rcypegGmYa@lunn.ch>
 <20210328215309.sgsenja2kmjx45t2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210328215309.sgsenja2kmjx45t2@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 12:53:09AM +0300, Vladimir Oltean wrote:
> On Sun, Mar 28, 2021 at 05:52:43PM +0200, Andrew Lunn wrote:
> > > +static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
> > > +{
> > > +	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
> > > +	struct dsa_switch_tree *dst = ds->dst;
> > > +	int port, err;
> > > +
> > > +	if (tag_ops->proto == dst->default_proto)
> > > +		return 0;
> > > +
> > > +	if (!ds->ops->change_tag_protocol) {
> > > +		dev_err(ds->dev, "Tag protocol cannot be modified\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	for (port = 0; port < ds->num_ports; port++) {
> > > +		if (!(dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port)))
> > > +			continue;
> > 
> > dsa_is_dsa_port() is interesting. Do we care about the tagging
> > protocol on DSA ports? We never see that traffic?
> 
> I believe this comes from me (see dsa_switch_tag_proto_match). I did not
> take into consideration at that time the fact that Marvell switches can
> translate between DSA and EDSA. So I assumed that every switch in the
> tree needs a notification about the tagging protocol, not just the
> top-most one.

Hi Vladimir

static int mv88e6xxx_setup_port_mode(struct mv88e6xxx_chip *chip, int port)
{
        if (dsa_is_dsa_port(chip->ds, port))
                return mv88e6xxx_set_port_mode_dsa(chip, port);

So DSA ports, the ports connecting two switches together, are hard
coded to use DSA.

        if (dsa_is_user_port(chip->ds, port))
                return mv88e6xxx_set_port_mode_normal(chip, port);

        /* Setup CPU port mode depending on its supported tag format */
        if (chip->info->tag_protocol == DSA_TAG_PROTO_DSA)
                return mv88e6xxx_set_port_mode_dsa(chip, port);

        if (chip->info->tag_protocol == DSA_TAG_PROTO_EDSA)
                return mv88e6xxx_set_port_mode_edsa(chip, port);

CPU ports can be configured to DSA or EDSA.

The switches seem happy to translate between DSA and EDSA as needed.

    Andrew
