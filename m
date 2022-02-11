Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32D4B2981
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245214AbiBKP7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 10:59:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239711AbiBKP7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 10:59:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2681A8
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 07:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/inIU+OBl5g3igHeXnTHt353fLCGXA3tZoTddUXYog4=; b=iAtROM9QRlRqDZqZT6B2s2rz3h
        eszdGQb7DHQqHGSMdDbPTyltac3r3C4p7c+x4a0UMQPZr3mfj7z6ef2F2UL8wXPkxGZAFAjTAMitv
        i6IsyXjA0+7rf5Slq3QRSFGP4Ye7GtxxlkCsNABNlS0O5JI5xlu2863drfsDKEr3fAv8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIYKI-005ULc-J6; Fri, 11 Feb 2022 16:59:14 +0100
Date:   Fri, 11 Feb 2022 16:59:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Message-ID: <YgaH0jjOcQMlZxxY@lunn.ch>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com>
 <X/+FKCRgkqOtoWbo@lunn.ch>
 <20210114001759.atz5vehkdrire6p7@skbuf>
 <X/+YQlEkeNYXditV@lunn.ch>
 <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 08:53:21PM +0200, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Thu, 14 Jan 2021 at 03:03, Andrew Lunn <andrew@lunn.ch> wrote:
> > On Thu, Jan 14, 2021 at 02:17:59AM +0200, Vladimir Oltean wrote:
> > > On Thu, Jan 14, 2021 at 12:41:28AM +0100, Andrew Lunn wrote:
> > > > On Wed, Jan 13, 2021 at 05:41:38PM +0200, Vladimir Oltean wrote:
> > > > > + int     (*port_priority_set)(struct dsa_switch *ds, int port,
> > > > > +                              struct dsa_mall_skbedit_tc_entry *skbedit);
> > > >
> > > > The fact we can turn this on/off suggests there should be a way to
> > > > disable this in the hardware, when the matchall is removed. I don't
> > > > see any such remove support in this patch.
> > >
> > > I don't understand this comment, sorry. When the matchall filter
> > > containing the skbedit action gets removed, DSA calls the driver's
> > > .port_priority_set callback again, this time with a priority of 0.
> > > There's nothing to "remove" about a port priority. I made an assumption
> > > (which I still consider perfectly reasonable) that no port-based
> > > prioritization means that all traffic gets classified to traffic class 0.
> >
> > That does not work for mv88e6xxx. Its default setup, if i remember
> > correctly, is it looks at the TOS bits to determine priority
> > classes. So in its default state, it is using all the available
> > traffic classes.  It can also be configured to look at the VLAN
> > priority, or the TCAM can set the priority class, or there is a per
> > port default priority, which is what you are describing here. There
> > are bits to select which of these happen on ingress, on a per port
> > basis.
> >
> > So setting the port priority to 0 means setting the priority of
> > zero. It does not mean go back to the default prioritisation scheme.
> >
> > I guess any switch which has a range of options for prioritisation
> > selection will have a similar problem. It defaults to something,
> > probably something a bit smarter than everything goes to traffic class
> > 0.
> >
> >       Andrew
> 
> I was going through my old patches, and re-reading this conversation,
> it appears one of us is misunderstanding something.
> 
> I looked at some Marvell datasheet and it has a similar QoS
> classification pipeline to Vitesse switches. There is a port-based
> default priority which can be overridden by IP DSCP, VLAN PCP, or
> advanced QoS classification (TCAM).
> 
> The proposal I had was to configure the default port priority using tc
> matchall skbedit priority. Advanced QoS classification would then be
> expressed as tc-flower filters with a higher precedence than the
> matchall (basically the "catchall"). PCP and DSCP, I don't know if
> that can be expressed cleanly using tc. I think there's something in
> the dcb ops, but I haven't studied that too deeply.
> 
> Anyway, I don't exactly understand your point, that an add/del is in
> any way better than a "set". Even for Marvell, what I'm proposing here
> would translate in a "set to 0" on "del" anyway. That's why this patch
> set is RFC. I don't know if there's a better way to express a
> port-based default priority than a matchall rule having the lowest
> precedence.

I think we have a generic problem in that the switch does not start up
in a state where all QoS features are turned off. But a traditional
netdev does have all QoS features off by default. You need to
explicitly turn on a QoS feature on a netdev by using tc, or some
other configuration mechanism.

To make the linux view of QoS features actually match what the
hardware is doing, we need to preload tc with a number of rules.  Your
proposed 'tc matchall skbedit priority' rule might need to be already
in tc because the switch might already be doing that by default, etc.

I also wonder if we need tc rules you cannot actually remove, because
you cannot turn the feature off in hardware? 'tc matchall skbedit
priority' is setting the default priority. If you remove the rule, the
hardware is still going to apply a default priority, it is just
ambiguous from tc what value it is using. It would be better if the
rule was present from boot, and all you can do is change the priority,
not remove the rule.

We need to consider the generic problem that the hardware comes with a
preconfigured QoS profile, which we currently don't reflect in Linux.
We have deployed devices which rely on that QoS profile. How do we
transition to describing that preconfigured QoS profile, and allowing
it to be changed?

   Andrew
