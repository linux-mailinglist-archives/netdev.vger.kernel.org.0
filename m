Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5178B29E680
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgJ2IhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbgJ2IhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:37:20 -0400
X-Greylist: delayed 1562 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Oct 2020 01:37:20 PDT
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84443C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 01:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4xEBL/eLgI1eX1a8X0tDPsmGn+yvT2SCmblG0ADx2DM=; b=FN85A+aQBSrnRUwHzn8s3/Pw60
        uA5FW5+YF2AvaARU/lbYawo1PXcfFI4L6hDXzwmzAsg+1yPR/Lj5VWUOkrVlq1qReT9lo0ceQVNRH
        3XXMuTlp05X1Z9BK6lgI65YfhZc4S7Ej1FhMgx42c9pWfLnezODIeAMvAJ7Hx9m+hkNwBp9xzV++P
        +LGP02oXOdoBvEBWh/T7S1M48FwlsYI/6PF/cJ7zvk04o14jEFTAlewrEuBffOnrHq5xMoLd5tbiU
        oE4OkhTM4R/ZqJbdayrYQYZaug0gDfwAs4+/pUcVhNySUGSL9CWn2k4FswIeQ01Xup7F4DINaVz3e
        6TsnVYLg==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1kY31Y-0004IO-KS; Thu, 29 Oct 2020 08:11:08 +0000
Date:   Thu, 29 Oct 2020 08:11:08 +0000
From:   Jonathan McDowell <noodles@earth.li>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH] net: dsa: mt7530: support setting MTU
Message-ID: <20201029081108.GB32650@earth.li>
References: <20201028181221.30419-1-dqfext@gmail.com>
 <20201028183131.d4mxlqwl5v2hy2tb@skbuf>
 <CALW65jYa9rTRaE2jn67iWG3=w=CFYvR0VWDNqtj5Vc3L=s6Jpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jYa9rTRaE2jn67iWG3=w=CFYvR0VWDNqtj5Vc3L=s6Jpg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 11:32:36AM +0800, DENG Qingfang wrote:
> On Thu, Oct 29, 2020 at 2:31 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Thu, Oct 29, 2020 at 02:12:21AM +0800, DENG Qingfang wrote:
...
> > > +static int
> > > +mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > > +{
> > > +     struct mt7530_priv *priv = ds->priv;
> > > +     int length;
> > > +
> > > +     /* When a new MTU is set, DSA always set the CPU port's MTU to the largest MTU
> > > +      * of the slave ports. Because the switch only has a global RX length register,
> > > +      * only allowing CPU port here is enough.
> > > +      */
> >
> > Good point, please tell that to Linus (cc) - I'm talking about
> > e0b2e0d8e669 ("net: dsa: rtl8366rb: Roof MTU for switch"),
> 
> And 6ae5834b983a ("net: dsa: b53: add MTU configuration support"),
> 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU"),
> f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> 
> CC'd them as well.

qca8k tracks and use the maximum provided mtu; perhaps that could be
optimised by only allow the CPU port to be set but it feels a bit more
future proof (e.g. if/when we support multiple CPU ports).

> Also, the commit e0b2e0d8e669 states that the new_mtu parameter is L2
> frame length instead of L2 payload. But according to my tests, it is
> L2 payload (i.e. the same as the MTU shown in `ip link` or `ifconfig`.
> Is that right?

Certainly that's what I saw; qca8k sets the MTU to the provided MTU +
ETH_HLEN + ETH_FCS_LEN.

J.

-- 
Pretty please, with sugar on top, clean the f**king car.
This .sig brought to you by the letter J and the number 13
Product of the Republic of HuggieTag
