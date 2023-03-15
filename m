Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644BE6BAD81
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjCOKVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjCOKUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:20:41 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2D87EA0B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 03:20:15 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7408140017;
        Wed, 15 Mar 2023 10:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678875592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pfUP5Dsw58mYHpGWf4Gtvi1NpdpoNPNOE57hDijo7g4=;
        b=alqMqzEe1raNVQreh9JFbNzaU33JhPrXVGPhI6NB6jdRUlM1SQRNVQ9VIz6Mj0G/orxpbU
        BTVT2TfpcnvCGUvswbBQEPzm0hW5me9/qo0CyLx7uE0izuClzHxhJXEUgAq916ZkPyFpHB
        pI94RTVvgykBHjHfOVJqSU6D3OgDWZJDnA01qxTGMyU81rK6dDirBbq3VlKjKkPBoTknlT
        wT8ua8YaxnxbYDrLQBLrFFN2wXtKjG92Iwh3Hwefy6PbBVCkgBUW0pIy0WxNSf1MtnFah+
        D9zJihSa2yZLqWCPlboOT1OlESSOoTybepGATKtJHnpSVoBYKrd0mTv6JOaNFQ==
Date:   Wed, 15 Mar 2023 11:19:50 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH 1/3] net: mvpp2: classifier flow remove tagged
Message-ID: <20230315111950.04deda46@pc-7.home>
In-Reply-To: <20230315075330.zklzcdt3sukc5jy2@SvensMacbookPro.hq.voleatech.com>
References: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
        <20230315083148.7c05b980@pc-7.home>
        <20230315075330.zklzcdt3sukc5jy2@SvensMacbookPro.hq.voleatech.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_50_75,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 08:53:30 +0100
Sven Auhagen <sven.auhagen@voleatech.de> wrote:

> On Wed, Mar 15, 2023 at 08:31:48AM +0100, Maxime Chevallier wrote:
> > Hello Sven,  
> 
> Hello Maxime,
> 
> > 
> > On Sat, 11 Mar 2023 08:09:48 +0100
> > Sven Auhagen <Sven.Auhagen@voleatech.de> wrote:
> >   
> > > The classifier attribute MVPP22_CLS_HEK_TAGGED
> > > has no effect in the definition and is filtered out by default.  
> > 
> > It's been a while since I've worked in this, but it looks like the
> > non-tagged and tagged flows will start behaving the same way with
> > this patch, which isn't what we want. Offsets to extract the
> > various fields change based on the presence or not of a vlan tag,
> > hence why we have all these flow definitions.
> >   
> 
> In the sense of a match kind of.
> There is one classifier match for no VLAN and one for any number of
> VLANs. So no VLAN will match twice, correct.
> 
> This is the case right now anyway though since
> mvpp2_port_rss_hash_opts_set is filtering out MVPP22_CLS_HEK_TAGGED
> for all rss hash options that are set in the driver at the moment.
> 
> MVPP22_CLS_HEK_TAGGED is also not compatible with
> MVPP22_CLS_HEK_IP4_5T which is probably the reason it is filtered out.
> 
> The HEK can only have a match on up to 4 fields.
> MVPP22_CLS_HEK_IP4_5T already covers 4 fields.

That's not exactly how it works, the HEK comes in play after we have
identified each flow during the parsing step, see my example below.

> I disabled the hash_opts line which removes the HEK_TAGGED and the
> entire rule will fail out and is not added because of that.
> 
> So I am simply removing what is not working in the first place.
> 
> > Did you check that for example RSS still behaves correctly when
> > using tagged and untagged traffic on the same interface ?
> >   
> 
> Yes all RSS work fine, I tested no VLAN, VLAN, QinQ, PPPoE and VLAN +
> PPPoE.
> 
> > I didn't test the QinQ at the time, so it's indeed likely that it
> > doesn't behave as expected, but removing the MVPP22_CLS_HEK_TAGGED
> > will cause issues if you start hashing inbound traffic based on the
> > vlan tag.  
> 
> Please see my comment above.
> 
> > 
> > the MVPP22_CLS_HEK_TAGGED does have an effect, as it's defined a
> > (VLAN id | VLAN_PRI) hashing capability. Removing it will also break
> > the per-vlan-prio rxnfc steering.
> > 
> > Do you have more details on the use-case ? Do you wan to do RSS,
> > steering ?  
> 
> I want to have RSS steering for all cases I tested above.

Can you provide example commands you would use to configure that, so
that we are on the same page ?

> Do you have a different place that I do not know of where
> MVPP22_CLS_HEK_TAGGED is actually loaded?

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c#L1647

Here the MVPP22_CLS_HEK_OPT_VLAN is loaded, and by removing
MVPP22_CLS_HEK_TAGGED, this option will get filtered out.

In the flow definitions, the MVPP22_CLS_HEK_TAGGED field indicates the
possible HEK fields we can extract in this flow, not the ones that will
actually be extracted.

It is possible for example to use :
ethtool -N eth0 flow-type tcp4 vlan 0xa000 m 0x1fff action 3 loc 1

This makes any TCP over IPv4 traffic coming on VLAN with a priority of
6 to go in queue 3. In this case, we'll only have the vlan pri in the
HEK. This will therefore apply regardless of the src/dst IP and src/dst
port.

The various flows defined here come from the parser, so when we hit a
particular flow we know that we are dealing with "tagged TCP over IPv4"
traffic, it's then up to the user to decide what to do with it, with
the limitation of 4 HEK fields.

> > 
> > I however do think that the missing frag flags are correct, and
> > should be sent in a separate patch.
> >   
> 
> Will do that in v2.
> 
> > Thanks,
> > 
> > Maxime
> >   
> > > Even if it is applied to the classifier, it would discard double
> > > or tripple tagged vlans.
> > > 
> > > Also add missing IP Fragmentation Flag.
> > > 
> > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > 
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> > > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c index
> > > 41d935d1aaf6..efdf8d30f438 100644 ---
> > > a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c +++
> > > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c @@ -44,17 +44,17
> > > @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { /* TCP over IPv4 flows, Not
> > > fragmented, with vlan tag */ MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > MVPP2_FL_IP4_TCP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_5T,
> > >  		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_5T,
> > >  		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_5T,
> > >  		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK),
> > >  
> > > @@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > MVPP2_FL_IP4_TCP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > MVPP2_PRS_RI_L3_IP4 |
> > > -		       MVPP2_PRS_RI_L4_TCP,
> > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > MVPP2_FL_IP4_TCP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > MVPP2_PRS_RI_L3_IP4_OPT |
> > > -		       MVPP2_PRS_RI_L4_TCP,
> > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > MVPP2_FL_IP4_TCP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > MVPP2_PRS_RI_L3_IP4_OTHER |
> > > -		       MVPP2_PRS_RI_L4_TCP,
> > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > >  
> > >  	/* TCP over IPv4 flows, fragmented, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > MVPP2_FL_IP4_TCP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > -		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > +		       MVPP2_PRS_RI_L3_IP4 |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > +			   MVPP2_PRS_RI_L4_TCP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > MVPP2_FL_IP4_TCP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > -		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > MVPP2_PRS_RI_L4_TCP,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > +		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > +			   MVPP2_PRS_RI_L4_TCP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > MVPP2_FL_IP4_TCP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > -		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > MVPP2_PRS_RI_L4_TCP,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > +		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > +			   MVPP2_PRS_RI_L4_TCP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
> > > @@ -114,17 +117,17 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > >  	/* UDP over IPv4 flows, Not fragmented, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_5T,
> > >  		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_5T,
> > >  		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_5T,
> > >  		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK),
> > >  
> > > @@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > MVPP2_FL_IP4_UDP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > MVPP2_PRS_RI_L3_IP4 |
> > > -		       MVPP2_PRS_RI_L4_UDP,
> > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > MVPP2_FL_IP4_UDP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > MVPP2_PRS_RI_L3_IP4_OPT |
> > > -		       MVPP2_PRS_RI_L4_UDP,
> > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > MVPP2_FL_IP4_UDP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > MVPP2_PRS_RI_L3_IP4_OTHER |
> > > -		       MVPP2_PRS_RI_L4_UDP,
> > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > >  
> > >  	/* UDP over IPv4 flows, fragmented, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > MVPP2_FL_IP4_UDP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > -		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > +		       MVPP2_PRS_RI_L3_IP4 |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > +			   MVPP2_PRS_RI_L4_UDP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > MVPP2_FL_IP4_UDP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > -		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > MVPP2_PRS_RI_L4_UDP,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > +		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > +			   MVPP2_PRS_RI_L4_UDP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > MVPP2_FL_IP4_UDP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > -		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > MVPP2_PRS_RI_L4_UDP,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > +		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > +			   MVPP2_PRS_RI_L4_UDP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	/* TCP over IPv6 flows, not fragmented, no vlan tag */
> > > @@ -178,12 +184,12 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > >  	/* TCP over IPv6 flows, not fragmented, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_5T,
> > >  		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_TCP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_5T,
> > >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK),
> > >  
> > > @@ -202,13 +208,13 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > >  	/* TCP over IPv6 flows, fragmented, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6,
> > > MVPP2_FL_IP6_TCP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_2T,
> > >  		       MVPP2_PRS_RI_L3_IP6 |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6,
> > > MVPP2_FL_IP6_TCP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_2T,
> > >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
> > >  		       MVPP2_PRS_IP_MASK),
> > > @@ -228,12 +234,12 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > >  	/* UDP over IPv6 flows, not fragmented, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_5T,
> > >  		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_UDP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_5T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_5T,
> > >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK),
> > >  
> > > @@ -252,13 +258,13 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > >  	/* UDP over IPv6 flows, fragmented, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6,
> > > MVPP2_FL_IP6_UDP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_2T,
> > >  		       MVPP2_PRS_RI_L3_IP6 |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
> > >  		       MVPP2_PRS_IP_MASK),
> > >  
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6,
> > > MVPP2_FL_IP6_UDP_FRAG_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_2T,
> > >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
> > >  		       MVPP2_PRS_IP_MASK),
> > > @@ -279,15 +285,15 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > >  	/* IPv4 flows, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_L3_IP4,
> > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_L3_IP4_OPT,
> > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP4_2T,
> > >  		       MVPP2_PRS_RI_L3_IP4_OTHER,
> > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > >  
> > > @@ -303,11 +309,11 @@ static const struct mvpp2_cls_flow
> > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > >  	/* IPv6 flows, with vlan tag */
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_2T,
> > >  		       MVPP2_PRS_RI_L3_IP6,
> > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
> > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > MVPP22_CLS_HEK_TAGGED,
> > > +		       MVPP22_CLS_HEK_IP6_2T,
> > >  		       MVPP2_PRS_RI_L3_IP6,
> > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > >    
> >   

