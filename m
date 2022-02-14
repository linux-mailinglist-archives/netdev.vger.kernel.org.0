Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A7A4B5B93
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiBNUwv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Feb 2022 15:52:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiBNUws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:52:48 -0500
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:8d8e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDEB13DEF
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:52:29 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id 7791515360;
        Mon, 14 Feb 2022 19:17:33 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 69EB8219C0A; Mon, 14 Feb 2022 19:17:33 +0000 (GMT)
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
        <20220214174349.6t3y7mwhqxaem3e7@skbuf>
Date:   Mon, 14 Feb 2022 19:17:33 +0000
In-Reply-To: <20220214174349.6t3y7mwhqxaem3e7@skbuf> (Vladimir Oltean's
        message of "Mon, 14 Feb 2022 19:43:49 +0200")
Message-ID: <yw1xtud12r76.fsf@mansr.com>
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

> Hi Måns,
>
> On Mon, Feb 14, 2022 at 09:16:10AM -0800, Florian Fainelli wrote:
>> +others,
>>
>> netdev is a high volume list, you should probably copy directly the
>> people involved with the code you are working with.
>
> Thanks, Florian.
>
>> > Secondly, the cpsw driver strips VLAN tags from incoming frames, and
>> > this prevents the DSA parsing from working.  As a dirty workaround, I
>> > did this:
>> >
>> > diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
>> > index 424e644724e4..e15f42ece8bf 100644
>> > --- a/drivers/net/ethernet/ti/cpsw_priv.c
>> > +++ b/drivers/net/ethernet/ti/cpsw_priv.c
>> > @@ -235,6 +235,7 @@ void cpsw_rx_vlan_encap(struct sk_buff *skb)
>> >
>> >         /* Remove VLAN header encapsulation word */
>> >         skb_pull(skb, CPSW_RX_VLAN_ENCAP_HDR_SIZE);
>> > +       return;
>> >
>> >         pkt_type = (rx_vlan_encap_hdr >>
>> >                     CPSW_RX_VLAN_ENCAP_HDR_PKT_TYPE_SHIFT) &
>> >
>> > With these changes, everything seems to work as expected.
>> >
>> > Now I'd appreciate if someone could tell me how I should have done this.
>
> Assuming cpsw_rx_vlan_encap() doesn't just eat the VLAN, but puts it in
> the skb hwaccel area. The tag_lan9303.c tagger must deal with both
> variants of VLANs.
>
> For example, dsa_8021q_rcv() has:
>
> 	skb_push_rcsum(skb, ETH_HLEN);
> 	if (skb_vlan_tag_present(skb)) {
> 		tci = skb_vlan_tag_get(skb);
> 		__vlan_hwaccel_clear_tag(skb);
> 	} else {
> 		__skb_vlan_pop(skb, &tci);
> 	}
> 	skb_pull_rcsum(skb, ETH_HLEN);
>
> 	vid = tci & VLAN_VID_MASK;
>
> 	(process @vid here)
>
> which should give you a head start.

Thanks, that looks promising.

>> > Please don't make me send an actual patch.
>
> So what is your plan otherwise? :)

I meant I didn't want to send a patch I know to be broken only to
provoke a discussion.

-- 
Måns Rullgård
