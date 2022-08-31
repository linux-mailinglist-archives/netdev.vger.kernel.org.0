Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622EE5A812A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiHaP03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiHaP02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:26:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C609D7CF8;
        Wed, 31 Aug 2022 08:26:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oTPbk-0004Ff-Ay; Wed, 31 Aug 2022 17:26:24 +0200
Date:   Wed, 31 Aug 2022 17:26:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <20220831152624.GA15107@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de>
 <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
 <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc>
 <87ilm84goh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ilm84goh.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@kernel.org> wrote:
> > Same with a 'nft list ruleset > /etc/nft.txt', reboot,
> > 'nft -f /etc/nft.txt' fails because user forgot to load/pin the program
> > first.
> 
> Right, so under what conditions is the identifier expected to survive,
> exactly? It's okay if it fails after a reboot, but it should keep
> working while the system is up?

Right, thats the question.  I think it boils down to 'least surprise',
which to me would mean useable labels are:

1. pinned name
2. elf filename
3. filter name

3) has the advantage that afaiu I can extend nft to use the dumped
id + program tag to query the name from the kernel, whereas 1+2 would
need to store the label.

1 and 2 have the upside that its easy to handle a 'file not found'
error.

> >> My point here was more that if it's just a label for human consumption,
> >> the comment field should be fine, didn't realise it was needed for the
> >> tool operation (and see above re: that).
> >
> > Yes, this is unfortunate.  I would like to avoid introducing an
> > asymmetry between input and output (as in "... add rule ebpf pinned
> > bla', but 'nft list ruleset' showing 'ebpf id 42') or similar, UNLESS we
> > can somehow use that alternate output to reconstruct that was originally
> > intended.  And so far I can only see that happening with storing some
> > label in the kernel for userspace to consume (elf filename, pinned name,
> > program name ... ).
> >
> > To give an example:
> >
> > With 'ebpf id 42', we might be able to let this get echoed back as if
> > user would have said 'ebpf progname myfilter' (I am making this up!),
> > just to have a more 'stable' identifier.
> >
> > This would make it necessary to also support load-by-program-name, of
> > course.
> 
> Seems like this kind of mapping can be done in userspace without
> involving the kernel?
>
> For example, the 'progname' thing could be implemented by defining an
> nft-specific pinning location so that 'ebpf progname myfilter' is
> equivalent to 'ebpf pinned /sys/bpf/nft/myfilter' and when nft receives
> an ID from the kernel it goes looking in /sys/bpf/nft to see if it can
> find the program with that ID and echoes it with the appropriate
> progname if it does exist?

Thats an interesting proposal.

I had not considered an nft specific namespace, just the raw pinned
filename.

> This could also be extended, so that if a user does '... add rule ebpf
> file /usr/lib/bpf/myrule.o' the nft binary stashes the id -> .o file
> mapping somewhere (in /run for instance) so that it can echo back where
> it got it from later?

Oh, I would prefer to abuse the kernel as a "database" directly for
that rather than keeping text files that have to be managed externally.

But, all things considered, what about this:

I'll respin, with the FILENAME attribute removed, so user says
'ebpf pinned bla', and on listing nft walks /sys/bpf/nft/ to see if
it can find the name again.

If it can't find it, print the id instead.

This would mean nft would also have to understand
'ebpf id 12' on input, but I think thats fine. We can document that
this is not the preferred method due to the difficulty of determining
the correct id to use.

With this, no 'extra' userspace-sake info needs to be stored.
We can revisit what do with 'ebpf file /bla/foo.o' once/if that gets
added.

What do you think?
Will take a while because I'll need to extend the nft side first to cope
with lack of 'FILENAME' attribute.
