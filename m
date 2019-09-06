Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE23CAB907
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393089AbfIFNPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:15:02 -0400
Received: from correo.us.es ([193.147.175.20]:55522 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388106AbfIFNPC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 09:15:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93A23303D09
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 15:14:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84045B7FF2
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 15:14:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 82E3EFB362; Fri,  6 Sep 2019 15:14:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51EBDDA4D0;
        Fri,  6 Sep 2019 15:14:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Sep 2019 15:14:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2762841E4800;
        Fri,  6 Sep 2019 15:14:56 +0200 (CEST)
Date:   Fri, 6 Sep 2019 15:14:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, saeedm@mellanox.com, vishal@chelsio.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
Message-ID: <20190906131457.7olkal45kkdtbevo@salvia>
References: <20190906000403.3701-1-pablo@netfilter.org>
 <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
 <20190906105638.hylw6quhk7t3wff2@salvia>
 <b8baf681-b808-4b83-d521-0353c3136516@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8baf681-b808-4b83-d521-0353c3136516@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 01:55:29PM +0100, Edward Cree wrote:
> On 06/09/2019 11:56, Pablo Neira Ayuso wrote:
> > On Fri, Sep 06, 2019 at 11:02:18AM +0100, Edward Cree wrote:
> >> Still NAK for the same reasons as three versions ago (when it was called
> >>  "netfilter: payload mangling offload support"), you've never managed to
> >>  explain why this extra API complexity is useful.  (Reducing LOC does not
> >>  mean you've reduced complexity.)
> > Oh well...
> >
> > Patch 1) Mask is inverted for no reason, just because tc pedit needs
> > this in this way. All drivers reverse this mask.
> >
> > Patch 2) All drivers mask out meaningless fields in the value field.
>
> To be clear: I have no issue with these two patches; they look fine to me.
> (Though I'd like to see some comments on struct flow_action_entry specifying
>  the semantics of these fields, especially if they're going to differ from
>  the corresponding fields in struct tc_pedit_key.)

OK, I can document this semantics, I need just _time_ to write that
documentation. I was expecting this patch description is enough by now
until I can get to finish that documentation.

> > Patch 3) Without this patchset, offsets are on the 32-bit boundary.
> > Drivers need to play with the 32-bit mask to infer what field they are
> > supposed to mangle... eg. with 32-bit offset alignment, checking if
> > the use want to alter the ttl/hop_limit need for helper structures to
> > check the 32-bit mask. Mangling a IPv6 address comes with one single
> > action...
>
> Drivers are still going to need to handle multiple pedit actions, in
>  case the original rule wanted to mangle two non-consecutive fields.
> And you can't just coalesce all consecutive mangles, because if you
>  mangle two consecutive fields (e.g. UDP sport and dport) the driver
>  still needs to disentangle that if it works on a 'fields' (rather
>  than 'u32s') level.

This infrastructure is _not_ coalescing two consecutive field, e.g.
UDP sport and dport is _not_ coalesced. The coalesce routine does
_not_ handle multiple tc pedit ex actions.

I'll clarify this in the cover letter in the next patchset round.

>  So either have the core convert things into named protocol fields
>  (i.e. "set src IPv6 to 1234::5 and add 1 to UDP sport"), or leave
>  the current sequence-of-u32-mangles as it is. This in-between "we'll
>  coalesce things together despite not knowing what fields they are" is
>  neither fish nor fowl.

The model you propose would still need this code for tc pedit to
adjust offset/length and coalesce u32 fields.
