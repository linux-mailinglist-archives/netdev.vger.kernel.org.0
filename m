Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3FE4F6A89
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiDFTyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236335AbiDFTxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:53:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DAB2652
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 10:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D03E061934
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 17:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66E3C385A3;
        Wed,  6 Apr 2022 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649266272;
        bh=TW8+JplZUdW0SOaVDpxePPZ7klA8MZbflXlS1vvA5IA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KdFC/UIN9DVI4V8MfKehOCgWaxdhVxI0AZKwmzxCx9mJRDKaDE0PBNU4NUw+EuZZG
         wLyNy8TaU0iEBtxRTMYcHmQH5gFiDYroJnD6LihUv0q0l7lbJpH6blqMpRYJspumcK
         iFaCCbKhXQYFLknFSMWUpV228hhqGfoPYTS+3eQH50lvOc0YWkD3zI6nD9NSHn3q4L
         NPEvM2lYMK+ErBcFjveH+ZT7oPolFBlV8hL4EWjhiprwI6DFmnNuoEL3iZokE8ca7v
         Bj658OSRAM1iG9/zRHZHsseTu2a/OxbdbRrN3cbx/3t+73dhvbZX1YI8SFar+8/aPM
         VcWCUHqY6/YRw==
Date:   Wed, 6 Apr 2022 10:31:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next 0/2] net: tc: dsa: Implement offload of
 matchall for bridged DSA ports
Message-ID: <20220406103110.05481cb5@kernel.org>
In-Reply-To: <84412805-f095-3e39-9747-e800c862095d@gmail.com>
References: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
        <20220405180949.3dd204a1@kernel.org>
        <84412805-f095-3e39-9747-e800c862095d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Apr 2022 11:24:46 +0200 Mattias Forsblad wrote:
> On 2022-04-06 03:09, Jakub Kicinski wrote:
> > On Mon,  4 Apr 2022 12:48:24 +0200 Mattias Forsblad wrote:  
> >> Limitations
> >> If there is tc rules on a bridge and all the ports leave the bridge
> >> and then joins the bridge again, the indirect framwork doesn't seem
> >> to reoffload them at join. The tc rules need to be torn down and
> >> re-added.  
> > 
> > You should unregister your callback when last DSA port leaves and
> > re-register when first joins. That way you'll get replay.
> >   
> 
> So I've tried that and it partially works. I get the FLOW_BLOCK_BIND
> callback but tcf_action_reoffload_cb() bails out here (tc_act_bind() == 1):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/sched/act_api.c?h=v5.18-rc1#n1819
> 
> B.c. that flag is set here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/sched/cls_api.c?h=v5.18-rc1#n3088
> 
> I cannot say I fully understand this logic. Can you perhaps advise?

tcf_action_reoffload_cb() is for action-as-first-class-citizen offload.
I think you should get the reply thru tcf_block_playback_offloads().
But I haven't really kept up with the TC offloads, non-zero chance
they got broken :/

> > Also the code needs to check the matchall is highest prio.  
> 
> Isn't sufficient with this check?
> 
> 	else if (flow_offload_has_one_action(&cls->rule->action) &&
> 		 cls->rule->action.entries[0].id == FLOW_ACTION_DROP)
> 		err = dsa_slave_add_cls_matchall_drop(dev, cls, ingress);
> 
> If it only has one action is must be the highest priority or am I 
> missing something?

That just checks there is a single action on the rule.
There could be multiple rules, adding something like:

	if (flow->common.prio != 1)
		goto bail;

is what I had in mind.
