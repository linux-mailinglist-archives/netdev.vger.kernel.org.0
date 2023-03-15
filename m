Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F4B6BA969
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjCOHfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjCOHfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:35:20 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568346BDE3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:32:00 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B2F321C0004;
        Wed, 15 Mar 2023 07:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678865517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6xSimSDZKA5sFuGgb5U0wRoEp7WvES/auOMxFfZQgo=;
        b=L0TOIOpigkvjrqIgHb74HTn8OQYgeaaFVrQArkGcBRBaY4nu/FujPo3ARvDrzSWzSAv6F1
        7KnXOaj3UlEadwQQWCULy/8hqEsdCqc58dcmeSxtcgttlO0OPEO2hl4m2jl7wFVJL3nAQ/
        pC8D43CiJmMPRrtq5IgRaO/EzEYAeubRR2BU1de9s9vmcrYpy6YaqlwoOJY2bcS35/+XCF
        lG/4kBxnMefvboPje98NPbGXVMTOCOTOf5dUC3JooPZfkobscDUg5xwY8ZGw3lA4rq47Cq
        1Grh8xTSoGoUew7iMcvjzD39mRTlOosIRSz64ZKd7nM16DD2NjxRlm+Vz+VUqg==
Date:   Wed, 15 Mar 2023 08:31:48 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH 1/3] net: mvpp2: classifier flow remove tagged
Message-ID: <20230315083148.7c05b980@pc-7.home>
In-Reply-To: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
References: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sven,

On Sat, 11 Mar 2023 08:09:48 +0100
Sven Auhagen <Sven.Auhagen@voleatech.de> wrote:

> The classifier attribute MVPP22_CLS_HEK_TAGGED
> has no effect in the definition and is filtered out by default.

It's been a while since I've worked in this, but it looks like the
non-tagged and tagged flows will start behaving the same way with this
patch, which isn't what we want. Offsets to extract the various fields
change based on the presence or not of a vlan tag, hence why we have
all these flow definitions.

Did you check that for example RSS still behaves correctly when using
tagged and untagged traffic on the same interface ?

I didn't test the QinQ at the time, so it's indeed likely that it
doesn't behave as expected, but removing the MVPP22_CLS_HEK_TAGGED
will cause issues if you start hashing inbound traffic based on the
vlan tag.

the MVPP22_CLS_HEK_TAGGED does have an effect, as it's defined a
(VLAN id | VLAN_PRI) hashing capability. Removing it will also break
the per-vlan-prio rxnfc steering.

Do you have more details on the use-case ? Do you wan to do RSS,
steering ?

I however do think that the missing frag flags are correct, and should
be sent in a separate patch.

Thanks,

Maxime

> Even if it is applied to the classifier, it would discard double
> or tripple tagged vlans.
> 
> Also add missing IP Fragmentation Flag.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c index
> 41d935d1aaf6..efdf8d30f438 100644 ---
> a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c +++
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c @@ -44,17 +44,17 @@
> static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = { 
>  	/* TCP over IPv4 flows, Not fragmented, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_5T,
>  		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_5T,
>  		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_5T,
>  		       MVPP2_PRS_RI_L3_IP4_OTHER |
> MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK),
>  
> @@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> MVPP2_FL_IP4_TCP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
> -		       MVPP2_PRS_RI_L4_TCP,
> +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
>  		       MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_VLAN_NONE |
> MVPP2_PRS_RI_L3_IP4_OPT |
> -		       MVPP2_PRS_RI_L4_TCP,
> +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
>  		       MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_VLAN_NONE |
> MVPP2_PRS_RI_L3_IP4_OTHER |
> -		       MVPP2_PRS_RI_L4_TCP,
> +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>  
>  	/* TCP over IPv4 flows, fragmented, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
> +		       MVPP22_CLS_HEK_IP4_2T,
> +		       MVPP2_PRS_RI_L3_IP4 |
> MVPP2_PRS_RI_IP_FRAG_TRUE |
> +			   MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
> +		       MVPP22_CLS_HEK_IP4_2T,
> +		       MVPP2_PRS_RI_L3_IP4_OPT |
> MVPP2_PRS_RI_IP_FRAG_TRUE |
> +			   MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -		       MVPP2_PRS_RI_L3_IP4_OTHER |
> MVPP2_PRS_RI_L4_TCP,
> +		       MVPP22_CLS_HEK_IP4_2T,
> +		       MVPP2_PRS_RI_L3_IP4_OTHER |
> MVPP2_PRS_RI_IP_FRAG_TRUE |
> +			   MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
> @@ -114,17 +117,17 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { 
>  	/* UDP over IPv4 flows, Not fragmented, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_5T,
>  		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_5T,
>  		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_5T,
>  		       MVPP2_PRS_RI_L3_IP4_OTHER |
> MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK),
>  
> @@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> MVPP2_FL_IP4_UDP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
> -		       MVPP2_PRS_RI_L4_UDP,
> +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
>  		       MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_VLAN_NONE |
> MVPP2_PRS_RI_L3_IP4_OPT |
> -		       MVPP2_PRS_RI_L4_UDP,
> +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
>  		       MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_VLAN_NONE |
> MVPP2_PRS_RI_L3_IP4_OTHER |
> -		       MVPP2_PRS_RI_L4_UDP,
> +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>  
>  	/* UDP over IPv4 flows, fragmented, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
> +		       MVPP22_CLS_HEK_IP4_2T,
> +		       MVPP2_PRS_RI_L3_IP4 |
> MVPP2_PRS_RI_IP_FRAG_TRUE |
> +			   MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
> +		       MVPP22_CLS_HEK_IP4_2T,
> +		       MVPP2_PRS_RI_L3_IP4_OPT |
> MVPP2_PRS_RI_IP_FRAG_TRUE |
> +			   MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -		       MVPP2_PRS_RI_L3_IP4_OTHER |
> MVPP2_PRS_RI_L4_UDP,
> +		       MVPP22_CLS_HEK_IP4_2T,
> +		       MVPP2_PRS_RI_L3_IP4_OTHER |
> MVPP2_PRS_RI_IP_FRAG_TRUE |
> +			   MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	/* TCP over IPv6 flows, not fragmented, no vlan tag */
> @@ -178,12 +184,12 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { 
>  	/* TCP over IPv6 flows, not fragmented, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_5T,
>  		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_5T,
>  		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
>  
> @@ -202,13 +208,13 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { 
>  	/* TCP over IPv6 flows, fragmented, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_2T,
>  		       MVPP2_PRS_RI_L3_IP6 |
> MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_2T,
>  		       MVPP2_PRS_RI_L3_IP6_EXT |
> MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
>  		       MVPP2_PRS_IP_MASK),
> @@ -228,12 +234,12 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { 
>  	/* UDP over IPv6 flows, not fragmented, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_5T,
>  		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
> -		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_5T,
>  		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
>  
> @@ -252,13 +258,13 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { 
>  	/* UDP over IPv6 flows, fragmented, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_2T,
>  		       MVPP2_PRS_RI_L3_IP6 |
> MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
>  
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
> -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_2T,
>  		       MVPP2_PRS_RI_L3_IP6_EXT |
> MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
>  		       MVPP2_PRS_IP_MASK),
> @@ -279,15 +285,15 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { 
>  	/* IPv4 flows, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_L3_IP4,
>  		       MVPP2_PRS_RI_L3_PROTO_MASK),
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_L3_IP4_OPT,
>  		       MVPP2_PRS_RI_L3_PROTO_MASK),
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP4_2T,
>  		       MVPP2_PRS_RI_L3_IP4_OTHER,
>  		       MVPP2_PRS_RI_L3_PROTO_MASK),
>  
> @@ -303,11 +309,11 @@ static const struct mvpp2_cls_flow
> cls_flows[MVPP2_N_PRS_FLOWS] = { 
>  	/* IPv6 flows, with vlan tag */
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
> -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_2T,
>  		       MVPP2_PRS_RI_L3_IP6,
>  		       MVPP2_PRS_RI_L3_PROTO_MASK),
>  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
> -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> +		       MVPP22_CLS_HEK_IP6_2T,
>  		       MVPP2_PRS_RI_L3_IP6,
>  		       MVPP2_PRS_RI_L3_PROTO_MASK),
>  

