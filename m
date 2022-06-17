Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A752D54EE59
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 02:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379091AbiFQAQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 20:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiFQAQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 20:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D20D17A9D
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 17:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA3CA618CF
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 00:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC61C34114;
        Fri, 17 Jun 2022 00:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655424974;
        bh=xT4O+qJMPr8aTmMsGWhlP651BE5VQl8C1eHSMvCHQqk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n+9z7bSkEV9GR/ayOqZbHAtCKXeQ0Y3d/xxzDHylFWpERW53yZhc0higyf7Md6bpL
         64DsOjzE9RNKTwR2zpzTbcd9hKZWs9AxUvzGlpl4hnr9ZpFUglj6oF+JIhEABtumYo
         qCAeQ3O3TBoH2HVsyuooL1cadCVlRbvbBbqEbJfrZd4S8uoKdhfliX1LmH36RVRoDx
         MPzPj4vdRDz605pBHnPzX3URh2FLumHFcoFcL56vJs6rOBRANxAKWt+SoSgY+jYy42
         gtlfCCFBRnrKYAU0J+nr1gkgWuAEFmnYQtzLeoW5xDpjcCsg7UbTeKKoJiSeFHePw2
         CBfbG5lqRnr/w==
Date:   Thu, 16 Jun 2022 17:16:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ismael Luceno <iluceno@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220616171612.66638e54@kernel.org>
In-Reply-To: <20220616171016.56d4ec9c@pirotess>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 17:10:16 +0200 Ismael Luceno wrote:
> On Wed, 15 Jun 2022 09:00:44 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 15 Jun 2022 17:11:13 +0200 Ismael Luceno wrote:  
> > > It seems a RTM_GETADDR request with AF_UNSPEC has a corner case
> > > where the NLM_F_DUMP_INTR flag is lost.
> > > 
> > > After a change in an address table, if a packet has been fully
> > > filled just previous, and if the end of the table is found at the
> > > same time, then the next packet should be flagged, which works fine
> > > when it's NLMSG_DONE, but gets clobbered when another table is to
> > > be dumped next.  
> > 
> > Could you describe how it gets clobbered? You mean that prev_seq gets
> > updated somewhere without setting the flag or something overwrites
> > nlmsg_flags? Or we set _INTR on an empty skb which never ends up
> > getting sent? Or..  
> 
> It seems to me that in most functions, but specifically in the case of
> net/ipv4/devinet.c:in_dev_dump_addr or inet_netconf_dump_devconf,
> nl_dump_check_consistent is called after each address/attribute is
> dumped, meaning a hash table generation change happening just after it
> adds an entry, if it also causes it to find the end of the table,
> wouldn't be flagged.
> 
> Adding an extra call at the end of all these functions should fix that,
> and spill the flag into the next packet, but would that be correct?

The whole _DUMP_INTR scheme does indeed seem to lack robustness.
The update side changes the atomic after the update, and the read
side validates it before. So there's plenty time for a race to happen.
But I'm not sure if that's what you mean or you see more issues.

> It seems this condition is flagged correctly when NLM_DONE is produced,
> I couldn't see why, but I'm guessing another call to
> nl_dump_check_consistent...
> 
> Also, I noticed that in net/core/rtnetlink.c:rtnl_dump_all: 
> 
> 	if (idx > s_idx) {
> 		memset(&cb->args[0], 0, sizeof(cb->args));
> 		cb->prev_seq = 0;
> 		cb->seq = 0;
> 	}
> 	ret = dumpit(skb, cb);
> 
> This also prevents it to be detect the condition when dumping the next
> table, but that seems desirable...

That's iterating over protocols, AFAICT, we don't guarantee consistency
across protocols.

> Am I grasping it correctly?
> 
> Some functions like net/core/rtnetlink.c:rtnl_dump_ifinfo do call
> nl_dump_check_consistent when finishing, but I'm seeing most others
> don't do that, instead doing it only when adding an entry to the packet
> (another example is: rtnl_stats_dump).
> 
> Again, while adding the check at the end of each function would solve
> these inconsistencies, it isn't so clear to me that spilling this flag
> into the next packet when it's going to be from another table is a good
> idea.
> 
> It might make more sense to emit a new packet type just for the flag,
> that way, in the sequence of packets, the client can reliably tell the
> dump of which tables was interrupted, and make some decision based on
> that, vs having to deem all tables affected...
> 

