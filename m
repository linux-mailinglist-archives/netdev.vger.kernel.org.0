Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC3CABB5D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394630AbfIFOu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:50:26 -0400
Received: from correo.us.es ([193.147.175.20]:49772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbfIFOuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:50:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6FD384FFE00
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 16:50:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62881DA72F
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 16:50:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4FE26D2B1F; Fri,  6 Sep 2019 16:50:21 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 223FCDA72F;
        Fri,  6 Sep 2019 16:50:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Sep 2019 16:50:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.194.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E8A8641E4801;
        Fri,  6 Sep 2019 16:50:18 +0200 (CEST)
Date:   Fri, 6 Sep 2019 16:50:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, saeedm@mellanox.com, vishal@chelsio.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
Message-ID: <20190906145019.2bggchaq43tcqdyc@salvia>
References: <20190906000403.3701-1-pablo@netfilter.org>
 <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
 <20190906105638.hylw6quhk7t3wff2@salvia>
 <b8baf681-b808-4b83-d521-0353c3136516@solarflare.com>
 <20190906131457.7olkal45kkdtbevo@salvia>
 <35ac21be-ff2f-a9cd-dd71-28bc37e8a51b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35ac21be-ff2f-a9cd-dd71-28bc37e8a51b@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 02:37:16PM +0100, Edward Cree wrote:
> On 06/09/2019 14:14, Pablo Neira Ayuso wrote:
> > OK, I can document this semantics, I need just _time_ to write that
> > documentation. I was expecting this patch description is enough by now
> > until I can get to finish that documentation.
>
> I think for two structs with apparently the same contents but different
>  semantics (one has the mask bitwise complemented) it's best to hold up
>  the code change until the comment is ready to come with it, because
>  until then it's a dangerously confusing situation.

The idea is that flow rule API != tc front-end anymore. So the flow
rule API can evolve regardless the front-end requirements. Before this
update there was no other choice than using the tc pedit layout since
it was exposed to the drivers, this is not the case anymore.

> >> And you can't just coalesce all consecutive mangles, because if you
> >>  mangle two consecutive fields (e.g. UDP sport and dport) the driver
> >>  still needs to disentangle that if it works on a 'fields' (rather
> >>  than 'u32s') level.
> >
> > This infrastructure is _not_ coalescing two consecutive field, e.g.
> > UDP sport and dport is _not_ coalesced. The coalesce routine does
> > _not_ handle multiple tc pedit ex actions.
>
> So an IPv6 address mangle only comes as a single action if it's from
>  netfilter, not if it's coming from TC pedit.

Driver gets one single action from tc/netfilter (and potentially
ethtool if it would support for this), it comes as a single action
from both subsystems:

        front-end -----> flow_rule API -----> drivers

Front-end need to translate their representation to this
FLOW_ACTION_MANGLE layout.

By front-end, I refer to ethtool/netfilter/tc.

>  Therefore drivers still  need to handle an IPv6 or MAC address
>  mangle coming in multiple  actions, therefore your driver
>  simplifications are invalid.  No?

No. IPv6 and MAC come as a single action. All subsystems use the same
flow_rule API, they use the same layout.

> > The model you propose would still need this code for tc pedit to
> > adjust offset/length and coalesce u32 fields.
>
>  Yes, but we don't add code/features to the kernel based on what we
>  *could* use it for later

This is already useful: Look at the cxgb driver in particular, it's
way easier to read.

Other existing drivers do not need to do things like:

        case round_down(offsetof(struct iphdr, tos), 4):

and the play with masks to infer if the user wants to mangle the TOS
field, they can just do:

        case offsetof(struct iphdr, tos):

which is way more natural representation.
