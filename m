Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47C1ABF3D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404355AbfIFSPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:15:33 -0400
Received: from correo.us.es ([193.147.175.20]:47946 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404365AbfIFSPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 14:15:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B9FC18FD84
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 20:15:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E29EDA8E8
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 20:15:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 50C43CA0F3; Fri,  6 Sep 2019 20:15:29 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A5F5A5B1;
        Fri,  6 Sep 2019 20:15:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Sep 2019 20:15:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (barqueta.lsi.us.es [150.214.188.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BC9B14265A5A;
        Fri,  6 Sep 2019 20:15:26 +0200 (CEST)
Date:   Fri, 6 Sep 2019 20:15:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, saeedm@mellanox.com, vishal@chelsio.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
Message-ID: <20190906181528.5rucn6dmnicvzmto@salvia>
References: <20190906000403.3701-1-pablo@netfilter.org>
 <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
 <20190906105638.hylw6quhk7t3wff2@salvia>
 <b8baf681-b808-4b83-d521-0353c3136516@solarflare.com>
 <20190906131457.7olkal45kkdtbevo@salvia>
 <35ac21be-ff2f-a9cd-dd71-28bc37e8a51b@solarflare.com>
 <20190906145019.2bggchaq43tcqdyc@salvia>
 <be6eee6b-9d58-f0f7-571b-7e473612e2b3@solarflare.com>
 <20190906155804.v4lviltxs72a45tq@salvia>
 <1637ec50-daae-65df-fcaa-bfd763dbb1d9@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1637ec50-daae-65df-fcaa-bfd763dbb1d9@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 05:49:07PM +0100, Edward Cree wrote:
> On 06/09/2019 16:58, Pablo Neira Ayuso wrote:
> > In tc pedit ex, those are _indeed_ two separated actions: 
>
>  I read the code again and I get it now, there's double iteration
>  already over tcf_exts_for_each_action and tcf_pedit_nkeys, and
>  it's only within the latter that you coalesce.

Exactly.

>  However, have you considered that iproute2 (i.e. tc tool) isn't
>  guaranteed to be the only userland consumer of the TC uAPI?
>  For all we know there could be another user out there producing things like
>  a single pedit action with two keys, same offset but different
>  masks, to mangle sport & dport separately, which your code now
>  _would_ coalesce into a single mangle. I don't know if that would
>  lead to any problems, but I want to be sure you've thought about it ;)

tc pedit only supports for the "extended mode". So the hardware
offloads only support for a subset of the tc pedit uAPI already.

Userland may decide not to use the "extended mode", however, it will
not work for hardware offloads.

> >> Proper thing to do is have helper functions available to drivers to test
> >> the pedit, and not just switch on the offset.  Why do I say that?
> >>
> >> Well, consider a pedit on UDP dport, with mask 0x00ff (network endian).
> >> Now as a u32 pedit that's 0x000000ff offset 0, so field-blind offset
> >> calculation (ffs in flow_action_mangle_entry()) will turn that into
> >> offset 3 mask 0xff.  Now driver does
> >>     switch(offset) { /* 3 */
> >>     case offsetof(struct udphdr, dest): /* 2 */
> >>         /* Whoops, we never get here! */
> >>     }
> >>
> >> Do you see the problem?
> >
> > This scenario you describe cannot _work_ right now, with the existing
> > code. Without my patchset, this scenario you describe does _not_ work,
> >
> > The drivers in the tree need a mask of 0xffff to infer that this is
> > UDP dport.
> >
> > The 'tc pedit ex' infrastructure does not allow for the scenario that
> > you describe above.
> >
> > No driver in the tree allow for what you describe already.
>
>  Looks to me like existing nfp_fl_set_tport() handles just fine any
>  arbitrary mask across the u32 that contains UDP sport & dport.
>  And the uAPI we have to maintain is the uAPI we expose, not the subset
>  that iproute2 uses. I could write a patched tc tool *today* that does
>  a pedit of 'UDP header, offset 0, mask 0xff0000ff' and the nfp driver
>  would accept that fine (no idea what the fw / chip would do with it,
>  but presumably it works or Netronome folks would have put checks in),
>  whereas with your patch it'll complain "invalid pedit L4 action"
>  because the mask isn't all-1s.

'UDP header, offset 0, mask 0xff0000ff': Mangle one byte of the UDP
sport, and only one mangle of the dport via uAPI.

I get your point: If you think that supporting for this is reasonable
usecase, I'll fix this patchset and send a v4 so the nfp still works
for this.

>  And if I made it produce my example from above, mask 0x000000ff, you'd
>  calculate an offset of 3 and hit the other error, "unsupported section
>  of L4 header", which again would have worked before.

'mask 0x000000ff' mangle only one byte of a UDP port.

I'm sorry for this, I assumed in this case that the reasonable (sane)
uAPI subset in this case to be supported for the hardware offloads is
what tc tool via pedit ex generates.

I'll restore the nfp driver so it works for these scenarios via uAPI
that you describe.
