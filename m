Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2350C5A807D
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 16:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiHaOnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 10:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiHaOnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 10:43:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36B6AE226;
        Wed, 31 Aug 2022 07:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F590B8211C;
        Wed, 31 Aug 2022 14:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD49EC433C1;
        Wed, 31 Aug 2022 14:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661957009;
        bh=aOtFQJyStRVSZNBA0rTokycqBcHuGcBpjynEPy1SwCs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=oyrpOsy9Rdv0sbxQnZ7GeO1K7hSAVEXywdr1CACLZsYv+Cjy6XuWoPzIw5+QWvmsB
         wbygHPabakn2jJHymW2V/d3t//yLBlhxzEXtNVfEpDTPptqTA8yWLRQAieAO2NvkbQ
         1mjKIP0ubRP5rbzVn5jhf3FlrKanFbqnjki3a2N/iBoUcmA4+PPJMncVAwmxe+30br
         L8956jawFndWNc0XWEONRj72UBwG1i9VZdDKoFYezG8gu6d328eY7+0T4Cirzp/8wL
         iF4U8CkgdKUCGLdy46+JaH7Y2QEsdm6EPIikJi+Ac6wGhYw2RbwR2ctKleQcI05r4X
         Woh4cjkIk3Vhg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 844E1588B1B; Wed, 31 Aug 2022 16:43:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
In-Reply-To: <20220831135757.GC8153@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 31 Aug 2022 16:43:26 +0200
Message-ID: <87ilm84goh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
>> >> It seems a bit odd to include the file path in the kernel as well.
>> >
>> > Its needed to be able to re-load the ruleset.
>>=20
>> How does that work, exactly? Is this so that the userspace binary can
>> query the current ruleset, and feed it back to the kernel expecting it
>> to stay the same?
>
> Yes.
>
>> Because in that case, if the pinned object goes away
>> in the meantime (or changes to a different program), this could lead to
>> some really hard to debug errors, where a reload subtly changes the
>> behaviour because the BPF program is not in fact the same.
>
> Correct, but thats kind of expected when the user changes programs
> logic.
>
> Same with a 'nft list ruleset > /etc/nft.txt', reboot,
> 'nft -f /etc/nft.txt' fails because user forgot to load/pin the program
> first.

Right, so under what conditions is the identifier expected to survive,
exactly? It's okay if it fails after a reboot, but it should keep
working while the system is up?

>> > This way was the most simple solution.
>>=20
>> My point here was more that if it's just a label for human consumption,
>> the comment field should be fine, didn't realise it was needed for the
>> tool operation (and see above re: that).
>
> Yes, this is unfortunate.  I would like to avoid introducing an
> asymmetry between input and output (as in "... add rule ebpf pinned
> bla', but 'nft list ruleset' showing 'ebpf id 42') or similar, UNLESS we
> can somehow use that alternate output to reconstruct that was originally
> intended.  And so far I can only see that happening with storing some
> label in the kernel for userspace to consume (elf filename, pinned name,
> program name ... ).
>
> To give an example:
>
> With 'ebpf id 42', we might be able to let this get echoed back as if
> user would have said 'ebpf progname myfilter' (I am making this up!),
> just to have a more 'stable' identifier.
>
> This would make it necessary to also support load-by-program-name, of
> course.

Seems like this kind of mapping can be done in userspace without
involving the kernel?

For example, the 'progname' thing could be implemented by defining an
nft-specific pinning location so that 'ebpf progname myfilter' is
equivalent to 'ebpf pinned /sys/bpf/nft/myfilter' and when nft receives
an ID from the kernel it goes looking in /sys/bpf/nft to see if it can
find the program with that ID and echoes it with the appropriate
progname if it does exist?

This could also be extended, so that if a user does '... add rule ebpf
file /usr/lib/bpf/myrule.o' the nft binary stashes the id -> .o file
mapping somewhere (in /run for instance) so that it can echo back where
it got it from later?

In either case I'm not really sure that there's much to be gained from
asking the kernel to store an additional label with the program rule?

-Toke
