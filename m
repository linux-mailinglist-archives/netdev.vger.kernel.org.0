Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF37589561
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 02:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbiHDAjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 20:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237351AbiHDAjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 20:39:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5DED5018F;
        Wed,  3 Aug 2022 17:39:19 -0700 (PDT)
Date:   Thu, 4 Aug 2022 02:39:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Vlad Buslov <vladbu@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Networking for 6.0
Message-ID: <YusVM6B8bT6IOKdZ@salvia>
References: <20220803101438.24327-1-pabeni@redhat.com>
 <CAHk-=widn7iZozvVZ37cDPK26BdOegGAX_JxR+v62sCv-5=eZg@mail.gmail.com>
 <YusOpd6IuLB29LHs@salvia>
 <CAHk-=wj59jR+pxYHmtf+OJvThEpYLNYLb9P5YkgCcBWDWzhdPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wj59jR+pxYHmtf+OJvThEpYLNYLb9P5YkgCcBWDWzhdPQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 05:27:07PM -0700, Linus Torvalds wrote:
> On Wed, Aug 3, 2022 at 5:11 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > For these two questions, this new Kconfig toggle was copied from:
> >
> >  config NF_CONNTRACK_PROCFS
> >         bool "Supply CT list in procfs (OBSOLETE)"
> >         default y
> >         depends on PROC_FS
> >
> > which is under:
> >
> >  if NF_CONNTRACK
> >
> > but the copy and paste was missing this.
> 
> Note that there's two problems with that
> 
>  (1) the NF_CONNTRACK_PROCFS thing is 'default y' because it *USED* to
> be unconditional, and was split up as a config option back in 2011.
> 
> See commit 54b07dca6855 ("netfilter: provide config option to disable
> ancient procfs parts").
> 
> IOW, that NF_CONNTRACK_PROCFS exists and defaults to on, not because
> people added new code and wanted to make it default, but because the
> code used to always be enabled if NF_CONNTRACK was enabled, and people
> wanted the option to *disable* it.
> 
> That's when you do 'default y' - you take existing code that didn't
> originally have a question at all, and you make it optional. Then you
> use 'default y' so that people who used it don't get screwed in the
> process.
> 
>  (2) it didn't do the proper conditional on the feature it depended on.
> 
> So let's not do copy-and-paste programming. The old Kconfig snippet
> had completely different rules, had completely different history, and
> completely different default values as a result.
> 
> I realize that it's very easy to think of Kconfig as some
> not-very-important detail to just hook things up. But because it's
> front-facing to users, I do want people to think about it more than
> perhaps people otherwise would.

Agreed, it was a bad a idea to copy and paste it from
NF_CONNTRACK_PROCFS, this new toggle has nothing to do with it.

I'll take a closer look at any new Kconfig toggle coming in the
future to avoid issues like this.

Thanks for reviewing.
