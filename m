Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1A71C6348
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgEEVn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:43:26 -0400
Received: from correo.us.es ([193.147.175.20]:46532 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbgEEVnZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 17:43:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9ED2118457
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 23:43:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAA26115410
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 23:43:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AFD7A4E737; Tue,  5 May 2020 23:43:23 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FB2D1158E9;
        Tue,  5 May 2020 23:43:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 23:43:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7E1B642EE38F;
        Tue,  5 May 2020 23:43:21 +0200 (CEST)
Date:   Tue, 5 May 2020 23:43:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, ecree@solarflare.com
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505214321.GA13591@salvia>
References: <20200505174736.29414-1-pablo@netfilter.org>
 <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200505193145.GA9789@salvia>
 <20200505124343.27897ad6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505124343.27897ad6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 12:43:43PM -0700, Jakub Kicinski wrote:
> On Tue, 5 May 2020 21:31:45 +0200 Pablo Neira Ayuso wrote:
> > On Tue, May 05, 2020 at 11:40:10AM -0700, Jakub Kicinski wrote:
> > > On Tue,  5 May 2020 19:47:36 +0200 Pablo Neira Ayuso wrote:  
> > > > This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> > > > that the frontend does not need counters, this hw stats type request
> > > > never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
> > > > the driver to disable the stats, however, if the driver cannot disable
> > > > counters, it bails out.
> > > > 
> > > > TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
> > > > except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
> > > > (this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
> > > > TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
> > > > 
> > > > Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > > v2: define FLOW_ACTION_HW_STATS_DISABLED at the end of the enumeration
> > > >     as Jiri suggested. Keep the 1:1 mapping between TCA_ACT_HW_STATS_*
> > > >     and FLOW_ACTION_HW_STATS_* except by the disabled case.
> > > > 
> > > >  include/net/flow_offload.h |  9 ++++++++-
> > > >  net/sched/cls_api.c        | 14 ++++++++++++--
> > > >  2 files changed, 20 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > > > index 3619c6acf60f..efc8350b42fb 100644
> > > > --- a/include/net/flow_offload.h
> > > > +++ b/include/net/flow_offload.h
> > > > @@ -166,15 +166,18 @@ enum flow_action_mangle_base {
> > > >  enum flow_action_hw_stats_bit {
> > > >  	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
> > > >  	FLOW_ACTION_HW_STATS_DELAYED_BIT,
> > > > +	FLOW_ACTION_HW_STATS_DISABLED_BIT,
> > > >  };
> > > >  
> > > >  enum flow_action_hw_stats {
> > > > -	FLOW_ACTION_HW_STATS_DISABLED = 0,
> > > > +	FLOW_ACTION_HW_STATS_DONT_CARE = 0,  
> > > 
> > > Why not ~0? Or ANY | DISABLED? 
> > > Otherwise you may confuse drivers which check bit by bit.  
> > 
> > I'm confused, you agreed with this behaviour:
> 
> I was expecting the 0 to be exposed at UAPI level, and then kernel
> would translate that to a full mask internally.
>
> From the other reply:
> 
> > I can send a v3 to handle the _DONT_CARE type from the mlxsw.
> 
> Seems a little unnecessary for all drivers to cater to the special
> case, when we made the argument be a bitfield specifically so that 
> the drivers can function as long as they match on any of the bits.

Let's summarize semantics:

- FLOW_ACTION_HW_STATS_DISABLED means disable counters, bail out if
  driver cannot disable them.

- FLOW_ACTION_HW_STATS_IMMEDIATE means enable inmediate counters,
  bail out if driver cannot enable inmediate counters.

- FLOW_ACTION_HW_STATS_DELAY means enable delayed counters, bail out
  if driver cannot enable delay counters.

- FLOW_ACTION_HW_STATS_ANY means enable counters, either inmmediate or
  delayed, if driver cannot enable any of them, bail out.

- FLOW_ACTION_HW_STATS_DONT_CARE (0) means counters are not needed, never
  bail out.

How can you combine DISABLED and ANY? Look at the semantics above and
combine them: this is asking for any counter otherwise bail out and
DISABLED is asking for no counters at all, otherwise bail out.

This sounds like asking for things that are opposed.

So bit A means X, bit B means Y, but if you combine A and B, it means
something complete different, say Z?

In your proposal, drivers drivers will have to check for ANY | DISABLED
for don't care?

And what is the semantic for 0 (no bit set) in the kernel in your
proposal?

Jiri mentioned there will be more bits coming soon. How will you
extend this model (all bit set on for DONT_CARE) if new bits with
specific semantics are showing up?

Combining ANY | DISABLED is non-sense, it should be rejected.
