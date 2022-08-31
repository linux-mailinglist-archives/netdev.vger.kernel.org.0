Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A55A7F6B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiHaN6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiHaN6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:58:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472D1D7585;
        Wed, 31 Aug 2022 06:57:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oTOE9-0003mP-7S; Wed, 31 Aug 2022 15:57:57 +0200
Date:   Wed, 31 Aug 2022 15:57:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <20220831135757.GC8153@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de>
 <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
 <87o7w04jjb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o7w04jjb.fsf@toke.dk>
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
> >> It seems a bit odd to include the file path in the kernel as well.
> >
> > Its needed to be able to re-load the ruleset.
> 
> How does that work, exactly? Is this so that the userspace binary can
> query the current ruleset, and feed it back to the kernel expecting it
> to stay the same?

Yes.

> Because in that case, if the pinned object goes away
> in the meantime (or changes to a different program), this could lead to
> some really hard to debug errors, where a reload subtly changes the
> behaviour because the BPF program is not in fact the same.

Correct, but thats kind of expected when the user changes programs
logic.

Same with a 'nft list ruleset > /etc/nft.txt', reboot,
'nft -f /etc/nft.txt' fails because user forgot to load/pin the program
first.

> Using IDs would avoid this ambiguity at least, so I think that's a
> better solution. We'd have to make sure the BPF program is not released
> completely until after the reload has finished, so that it doesn't
> suddenly disappear.

This should be covered, the destructor runs after the ruleset has been
detached from the data plan (and after a synchronize_rcu).

> > This way was the most simple solution.
> 
> My point here was more that if it's just a label for human consumption,
> the comment field should be fine, didn't realise it was needed for the
> tool operation (and see above re: that).

Yes, this is unfortunate.  I would like to avoid introducing an
asymmetry between input and output (as in "... add rule ebpf pinned
bla', but 'nft list ruleset' showing 'ebpf id 42') or similar, UNLESS we
can somehow use that alternate output to reconstruct that was originally
intended.  And so far I can only see that happening with storing some
label in the kernel for userspace to consume (elf filename, pinned name,
program name ... ).

To give an example:

With 'ebpf id 42', we might be able to let this get echoed back as if
user would have said 'ebpf progname myfilter' (I am making this up!),
just to have a more 'stable' identifier.

This would make it necessary to also support load-by-program-name, of
course.

> > Sure, I could change the grammar so it expects a tag or ID, e.g.
> > 'ebpf id 42'
> >
> > If thats preferred, I can change this, it avoids the need for storing
> > the name.
> 
> I think for echoing back, just relying on the ID is better as that is at
> least guaranteed to stay constant for the lifetime of the BPF program in
> the kernel.

Yes, I realize that, this is why the id and tag are included in the
netlink dump, but on the userspace side this information is currently
hidden and only shown with --debug output.

> >> Any plan to also teach the nft binary to load a BPF program from an ELF
> >> file (instead of relying on pinning)?
> >
> > I used pinning because that is what '-m bpf' uses.
> 
> I'm not against supporting pinning, per se (except for the issues noted
> above),

Okay, thanks for clarifying.  -m bpf is a bit older so I was not sure if
pinning has been deprecated or something like that.

> But we could do multiple things, including supporting loading
> the program from an object file. This is similar to how TC operates, for
> instance...

Right, there is no need to restrict this to one method.
