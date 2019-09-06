Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626EAABD19
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfIFP6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:58:10 -0400
Received: from correo.us.es ([193.147.175.20]:39236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394970AbfIFP6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 11:58:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5E0DED5C6
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 17:58:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7A25CA0F3
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 17:58:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B58BD2B1D; Fri,  6 Sep 2019 17:58:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FC6BDA8E8;
        Fri,  6 Sep 2019 17:58:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Sep 2019 17:58:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (barqueta.lsi.us.es [150.214.188.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0C45241E4801;
        Fri,  6 Sep 2019 17:58:03 +0200 (CEST)
Date:   Fri, 6 Sep 2019 17:58:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, saeedm@mellanox.com, vishal@chelsio.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
Message-ID: <20190906155804.v4lviltxs72a45tq@salvia>
References: <20190906000403.3701-1-pablo@netfilter.org>
 <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
 <20190906105638.hylw6quhk7t3wff2@salvia>
 <b8baf681-b808-4b83-d521-0353c3136516@solarflare.com>
 <20190906131457.7olkal45kkdtbevo@salvia>
 <35ac21be-ff2f-a9cd-dd71-28bc37e8a51b@solarflare.com>
 <20190906145019.2bggchaq43tcqdyc@salvia>
 <be6eee6b-9d58-f0f7-571b-7e473612e2b3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be6eee6b-9d58-f0f7-571b-7e473612e2b3@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Edward,

On Fri, Sep 06, 2019 at 04:13:17PM +0100, Edward Cree wrote:
> On 06/09/2019 15:50, Pablo Neira Ayuso wrote:
> > On Fri, Sep 06, 2019 at 02:37:16PM +0100, Edward Cree wrote:
[...]
> >> So an IPv6 address mangle only comes as a single action if it's from
> >>  netfilter, not if it's coming from TC pedit.
> > Driver gets one single action from tc/netfilter (and potentially
> > ethtool if it would support for this), it comes as a single action
> > from both subsystems:
> >
> >         front-end -----> flow_rule API -----> drivers
> >
> > Front-end need to translate their representation to this
> > FLOW_ACTION_MANGLE layout.
> >
> > By front-end, I refer to ethtool/netfilter/tc.
>
>  In your patch, flow_action_mangle() looks only at the offset and type
>  (add vs. set) of each pedit, coalesces them if compatible (so, unless
>  I'm misreading the code, it _will_ coalesce adjacent pedits to
>  contiguous fields like UDP sport & dport, unlike what you said),
>  because it doesn't know whether two contiguous pedits are part of the
>  same field or not (it doesn't have any knowledge of 'fields' at all).

In tc pedit ex, those are _indeed_ two separated actions:

* One to mangle UDP sport.
* One to mangle UDP dport.

They are _not_ one as you describe above.

The coalesce routine I made does _not_ coalesce fields in two
different actions.

>  And for you to change that, while still coalescing IPv6 pedits, you
>  would need flow_action_mangle() to know what fields each pedit is in.

In the particular case of IPv6 address, 'tc pedit ex' generates one
single action with 4 nkeys. So this is:

* One action to mangle four 32-bits words (the number of words in tc
  pedit is stored in the nkeys field).

The coalesce routine I made in this case merges the four 32-bits words
into one single action.

[...]
> >>  Yes, but we don't add code/features to the kernel based on what we
> >>  *could* use it for later
> > This is already useful: Look at the cxgb driver in particular, it's
> > way easier to read.
>
>  Have you tested it?  Again, I might be misreading, but it looks like
>  your flow_action_mangle() *will* coalesce sport & dport, which it
>  appears will break that cxgb code.

Because sport and dport are not place in the same action by tc pedit
ex, _that cannot happen_.

> > Other existing drivers do not need to do things like:
> >
> >         case round_down(offsetof(struct iphdr, tos), 4):
> >
> > and the play with masks to infer if the user wants to mangle the TOS
> > field, they can just do:
> >
> >         case offsetof(struct iphdr, tos):
> >
> > which is way more natural representation.
>
> Proper thing to do is have helper functions available to drivers to test
> the pedit, and not just switch on the offset.  Why do I say that?
>
> Well, consider a pedit on UDP dport, with mask 0x00ff (network endian).
> Now as a u32 pedit that's 0x000000ff offset 0, so field-blind offset
> calculation (ffs in flow_action_mangle_entry()) will turn that into
> offset 3 mask 0xff.  Now driver does
>     switch(offset) { /* 3 */
>     case offsetof(struct udphdr, dest): /* 2 */
>         /* Whoops, we never get here! */
>     }
>
> Do you see the problem?

This scenario you describe cannot _work_ right now, with the existing
code. Without my patchset, this scenario you describe does _not_ work,

The drivers in the tree need a mask of 0xffff to infer that this is
UDP dport.

The 'tc pedit ex' infrastructure does not allow for the scenario that
you describe above.

No driver in the tree allow for what you describe already.
