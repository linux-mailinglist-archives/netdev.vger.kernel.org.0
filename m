Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC125A7E18
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiHaM4b convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 31 Aug 2022 08:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiHaM4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:56:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB617C76A;
        Wed, 31 Aug 2022 05:56:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oTNGK-0003Ku-VU; Wed, 31 Aug 2022 14:56:09 +0200
Date:   Wed, 31 Aug 2022 14:56:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <20220831125608.GA8153@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de>
 <87v8q84nlq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87v8q84nlq.fsf@toke.dk>
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
> > Tag and program id are dumped to userspace on 'list' to allow to see which
> > program is in use in case the filename isn't available/present.
> 
> It seems a bit odd to include the file path in the kernel as well.

Its needed to be able to re-load the ruleset.

> For
> one thing, the same object can be pinned multiple times in different
> paths (even in different mount namespaces),

Sure.

> and there's also nothing
> preventing a different program to have been substituted by the pinned
> one by the time the value is echoed back.

Yes, but what would you expect it should do?

> Also, there's nothing checking that the path attribute actually contains
> a path, so it's really just an arbitrary label that the kernel promises
> to echo back

Yes exactly.

> But doesn't NFT already have a per-rule comment feature,
> so why add another specifically for BPF?

You can attach up to 256 bytes to a rule, yes.
Might not be enough for a longer path, and there could be multiple
expressions in the same rule.

This way was the most simple solution.

> Instead we could just teach the
> userspace utility to extract metadata from the BPF program (based on the
> ID) like bpftool does. This would include the program name, BTW, so it
> does have a semantic identifier.

Sure, I could change the grammar so it expects a tag or ID, e.g.
'ebpf id 42'

If thats preferred, I can change this, it avoids the need for storing
the name.

> > cbpf bytecode isn't supported.
> > add rule ... ebpf pinned "/sys/fs/bpf/myprog"
> 
> Any plan to also teach the nft binary to load a BPF program from an ELF
> file (instead of relying on pinning)?

I used pinning because that is what '-m bpf' uses.
