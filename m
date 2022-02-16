Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2834B8F9F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiBPRrs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Feb 2022 12:47:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbiBPRrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:47:48 -0500
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:8d8e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F3DDCE11
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:47:34 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id A082215360;
        Wed, 16 Feb 2022 17:47:32 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 91D3D219C0A; Wed, 16 Feb 2022 17:47:32 +0000 (GMT)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Andrew Lunn <andrew@lunn.ch>,
        Juergen Borleis <jbe@pengutronix.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        lorenzo@kernel.org
Subject: Re: DSA using cpsw and lan9303
References: <yw1x8rud4cux.fsf@mansr.com>
        <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
        <20220215205418.a25ro255qbv5hpjk@skbuf> <yw1xa6er2bno.fsf@mansr.com>
        <20220216141543.dnrnuvei4zck6xts@skbuf> <yw1x5ype3n6r.fsf@mansr.com>
        <20220216142634.uyhcq7ptjamao6rl@skbuf>
        <20220216170027.yrkj5r4zberrx3qb@skbuf>
Date:   Wed, 16 Feb 2022 17:47:32 +0000
In-Reply-To: <20220216170027.yrkj5r4zberrx3qb@skbuf> (Vladimir Oltean's
        message of "Wed, 16 Feb 2022 19:00:27 +0200")
Message-ID: <yw1xy22a1z63.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Wed, Feb 16, 2022 at 04:26:34PM +0200, Vladimir Oltean wrote:
>> On Wed, Feb 16, 2022 at 02:23:24PM +0000, Måns Rullgård wrote:
>> > Vladimir Oltean <olteanv@gmail.com> writes:
>> > 
>> > > On Wed, Feb 16, 2022 at 01:17:47PM +0000, Måns Rullgård wrote:
>> > >> > Some complaints about accessing the CPU port as dsa_to_port(chip->ds, 0),
>> > >> > but it's not the first place in this driver where that is done.
>> > >> 
>> > >> What would be the proper way to do it?
>> > >
>> > > Generally speaking:
>> > >
>> > > 	struct dsa_port *cpu_dp;
>> > >
>> > > 	dsa_switch_for_each_cpu_port(cpu_dp, ds)
>> > > 		break;
>> > >
>> > > 	// use cpu_dp
>> > >
>> > > If your code runs after dsa_tree_setup_default_cpu(), which contains the
>> > > "DSA: tree %d has no CPU port\n" check, you don't even need to check
>> > > whether cpu_dp was found or not - it surely was. Everything that runs
>> > > after dsa_register_switch() has completed successfully - for example the
>> > > DSA ->setup() method - qualifies here.
>> > 
>> > In this particular driver, the setup function contains this:
>> > 
>> > 	/* Make sure that port 0 is the cpu port */
>> > 	if (!dsa_is_cpu_port(ds, 0)) {
>> > 		dev_err(chip->dev, "port 0 is not the CPU port\n");
>> > 		return -EINVAL;
>> > 	}
>> > 
>> > I take this to mean that port 0 is guaranteed to be the cpu port.  Of
>> > course, it can't hurt to be thorough just in case that check is ever
>> > removed.
>> 
>> Yes, I saw that, and I said that there are other places in the driver
>> that assume port 0 is the CPU port. Although I don't know why that is,
>> if the switch can only operate like that, etc. I just pointed out how it
>> would be preferable to get a hold of the CPU port in a regular DSA
>> driver without any special constraints.
>
> Ah, silly me, I should have paid more attention on where you're actually
> inserting the code. You could have done:
>
> static int lan9303_port_enable(struct dsa_switch *ds, int port,
> 			       struct phy_device *phy)
> {
> 	struct dsa_port *dp = dsa_to_port(ds, port);
> 	struct lan9303 *chip = ds->priv;
>
> 	if (!dsa_port_is_user(dp))
> 		return 0;
>
> 	vlan_vid_add(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
>
> 	return lan9303_enable_processing_port(chip, port);
> }
>
> the advantage being that if this driver ever supports the remapping of
> the CPU port, or multiple CPU ports, this logic wouldn't need to be
> changed, as it also conveys the user-to-CPU port affinity.

The LAN9303 has (R)MII for port 0 and internal PHYs for ports 1/2, so
there's really only one sensible way to connect it, even though the
switch core has identical functionality for all ports.

-- 
Måns Rullgård
