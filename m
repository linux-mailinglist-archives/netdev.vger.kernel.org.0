Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A431A4B894C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiBPNSw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Feb 2022 08:18:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiBPNSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:18:43 -0500
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:8d8e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E7029C106
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:17:48 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id 5A29815361;
        Wed, 16 Feb 2022 13:17:47 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 4D149219C0A; Wed, 16 Feb 2022 13:17:47 +0000 (GMT)
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
        <20220215205418.a25ro255qbv5hpjk@skbuf>
Date:   Wed, 16 Feb 2022 13:17:47 +0000
In-Reply-To: <20220215205418.a25ro255qbv5hpjk@skbuf> (Vladimir Oltean's
        message of "Tue, 15 Feb 2022 22:54:18 +0200")
Message-ID: <yw1xa6er2bno.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> Hi Måns,
>
> On Mon, Feb 14, 2022 at 09:16:10AM -0800, Florian Fainelli wrote:
>> +others,
>> 
>> netdev is a high volume list, you should probably copy directly the
>> people involved with the code you are working with.
>> 
>> On 2/14/22 8:44 AM, Måns Rullgård wrote:
>> > The hardware I'm working on has a LAN9303 switch connected to the
>> > Ethernet port of an AM335x (ZCE package).  In trying to make DSA work
>> > with this combination, I have encountered two problems.
>> > 
>> > Firstly, the cpsw driver configures the hardware to filter out frames
>> > with unknown VLAN tags.  To make it accept the tagged frames coming from
>> > the LAN9303, I had to modify the latter driver like this:
>> > 
>> > diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
>> > index 2de67708bbd2..460c998c0c33 100644
>> > --- a/drivers/net/dsa/lan9303-core.c
>> > +++ b/drivers/net/dsa/lan9303-core.c
>> > @@ -1078,20 +1079,28 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
>> >                                struct phy_device *phy)
>> >  {
>> >         struct lan9303 *chip = ds->priv;
>> > +       struct net_device *master;
>> >  
>> >         if (!dsa_is_user_port(ds, port))
>> >                 return 0;
>> >  
>> > +       master = dsa_to_port(chip->ds, 0)->master;
>> > +       vlan_vid_add(master, htons(ETH_P_8021Q), port);
>> 
>> That looks about right given that net/dsa/tag_lan9303.c appears to be a
>> quasi DSA_TAG_PROTO_8021Q implementation AFAICT.
>
> In case it was not clear, I agree with Florian that this looks "about right",
> I just thought that mentioning it wouldn't bring much to the table.
> But I noticed you submitted a patch for the other issue and not for this.
>
> Some complaints about accessing the CPU port as dsa_to_port(chip->ds, 0),
> but it's not the first place in this driver where that is done.

What would be the proper way to do it?

> dsa_tag_8021q_port_setup() also has:
>
> 	/* Add @rx_vid to the master's RX filter. */
> 	vlan_vid_add(master, ctx->proto, rx_vid);
>
> which is an indication that other switches with VLAN-based tagging
> protocols should handle this somehow, somewhere.
>
> Note, though, that vlan_vid_add() allocates memory, so it would be good
> to have a vlan_vid_del() too at some point.

Yes, I just didn't include that bit in the initial query.

-- 
Måns Rullgård
