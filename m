Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0485A7F59
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiHaNy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiHaNyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:54:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9A6B1D1;
        Wed, 31 Aug 2022 06:44:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oTO1S-0003hJ-CP; Wed, 31 Aug 2022 15:44:50 +0200
Date:   Wed, 31 Aug 2022 15:44:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <20220831134450.GB8153@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de>
 <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220831125608.GA8153@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Toke Høiland-Jørgensen <toke@kernel.org> wrote:
> > > Tag and program id are dumped to userspace on 'list' to allow to see which
> > > program is in use in case the filename isn't available/present.
> > 
> > It seems a bit odd to include the file path in the kernel as well.
> 
> Its needed to be able to re-load the ruleset.

In particular, I can't find any better alternative.

load by id -> works, easy to echo back to userspace, but not stable
identifier across reboots or add/del operations of the program.

load by tag -> similar, except that this time the tag needs to be
adjusted whenever the program changes, so not ideal either.

load via ELF name -> same problems as the proposed 'pinned' mode, but perhaps a bit
easier to use?

It has the slight advantage that users don't need to load/pin the program first,
lifetime of the program would be tied to the nftables rule.

The downside is that nft needs to deal with possible rejection of the program
instead of 'outsourcing' this problem to bpftool (or another program).
