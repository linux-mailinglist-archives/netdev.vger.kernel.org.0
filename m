Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2293A5B0D96
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiIGT6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIGT6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:58:43 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3642AA5992;
        Wed,  7 Sep 2022 12:58:41 -0700 (PDT)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 287JlHCp027774;
        Wed, 7 Sep 2022 14:47:17 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 287JlFIx027773;
        Wed, 7 Sep 2022 14:47:15 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 7 Sep 2022 14:47:15 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>, kuba@kernel.org,
        miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of kfree_skb_reason() by gcc
Message-ID: <20220907194715.GK25951@gate.crashing.org>
References: <CADxym3Yxq0k_W43kVjrofjNoUUag3qwmpRGLLAQL1Emot3irPQ@mail.gmail.com> <20220818165838.GM25951@gate.crashing.org> <CADxym3YEfSASDg9ppRKtZ16NLh_NhH253frd5LXZLGTObsVQ9g@mail.gmail.com> <20220819152157.GO25951@gate.crashing.org> <CADxym3Y-=6pRP=CunxRomfwXf58k0LyLm510WGtzsBnzjqdD4g@mail.gmail.com> <871qt86711.fsf@oldenburg.str.redhat.com> <CADxym3Z7WpPbX7VSZqVd+nVnbaO6HvxV7ak58TXBCqBqodU+Jg@mail.gmail.com> <87edwo65lw.fsf@oldenburg.str.redhat.com> <20220906153046.GD25951@gate.crashing.org> <87zgfbnh81.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgfbnh81.fsf@oldenburg.str.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 08:59:26PM +0200, Florian Weimer wrote:
> * Segher Boessenkool:
> 
> > On Tue, Sep 06, 2022 at 02:37:47PM +0200, Florian Weimer wrote:
> >> > On Mon, Aug 22, 2022 at 4:01 PM Florian Weimer <fweimer@redhat.com> wrote:
> >> > I did some research on the 'sibcalls' you mentioned above. Feel like
> >> > It's a little similar to 'inline', and makes the callee use the same stack
> >> > frame with the caller, which obviously will influence the result of
> >> > '__builtin_return_address'.
> >
> > Sibling calls are essentially calls that can be replaced by jumps (aka
> > "tail call"), without needing a separate entry point to the callee.
> >
> > Different targets can have a slightly different implementation and
> > definition of what exactly is a sibling call, but that's the gist.
> >
> >> > Hmm......but I'm not able to find any attribute to disable this optimization.
> >> > Do you have any ideas?
> >> 
> >> Unless something changed quite recently, GCC does not allow disabling
> >> the optimization with a simple attribute (which would have to apply to
> >> function pointers as well, not functions).
> >
> > It isn't specified what a sibling call exactly *is*, certainly not on C
> > level (only in the generated machine code), and the details differs per
> > target.
> 
> Sure, but GCC already disables this optimization in a generic fashion
> for noreturn calls.  It should be possible to do the same based another
> function attribute.

My point is that disabling sibling calls does not necessarily do what
you really want, certainly not on all targets.  Many targets have their
own frame optimisations and prologue/epilogue optimisations as well.

But you can just do
  void f(void) __attribute__((optimize("no-optimize-sibling-calls")));
(in my previous example), and that works: it disables the (generic)
sibling call optimisation.  This may or may not do what you actually
want though.


Segher
