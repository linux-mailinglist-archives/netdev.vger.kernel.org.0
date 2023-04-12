Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576D56DFAC9
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDLQEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLQEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:04:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ACECCF;
        Wed, 12 Apr 2023 09:04:31 -0700 (PDT)
Date:   Wed, 12 Apr 2023 18:04:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, mathew.j.martineau@linux.intel.com,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add
 IPPROTO_UAPI_MAX
Message-ID: <ZDbWi4dgysRbf+vb@calendula>
References: <20230406092558.459491-1-pablo@netfilter.org>
 <ca12e402-96f1-b1d2-70ad-30e532f9026c@tessares.net>
 <20230412072104.61910016@kernel.org>
 <405a8fa2-4a71-71c8-7715-10d3d2301dac@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <405a8fa2-4a71-71c8-7715-10d3d2301dac@tessares.net>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 05:22:36PM +0200, Matthieu Baerts wrote:
> Hi Jakub,
> 
> On 12/04/2023 16:21, Jakub Kicinski wrote:
> > On Thu, 6 Apr 2023 12:45:25 +0200 Matthieu Baerts wrote:
> >> The modification in the kernel looks good to me. But I don't know how to
> >> make sure this will not have any impact on MPTCP on the userspace side,
> >> e.g. somewhere before calling the socket syscall, a check could be done
> >> to restrict the protocol number to IPPROTO_MAX and then breaking MPTCP
> >> support.
> > 
> > Then again any code which stores the ipproto in an unsigned char will 
> > be broken. A perfect solution is unlikely to exist.

Yes, this is tricky.

> I wonder if the root cause is not the fact we mix the usage of the
> protocol parameter from the socket syscall (int/s32) and the protocol
> field from the IP header (u8).
> 
> To me, the enum is linked to the socket syscall, not the IP header. In
> this case, it would make sense to have a dedicated "MAX" macro for the
> IP header, no?
> 
> >> Is it not safer to expose something new to userspace, something
> >> dedicated to what can be visible on the wire?
> >>
> >> Or recommend userspace programs to limit to lower than IPPROTO_RAW
> >> because this number is marked as "reserved" by the IANA anyway [1]?
> >>
> >> Or define something new linked to UINT8_MAX because the layer 4 protocol
> >> field in IP headers is limited to 8 bits?
> >> This limit is not supposed to be directly linked to the one of the enum
> >> you modified. I think we could even say it works "by accident" because
> >> "IPPROTO_RAW" is 255. But OK "IPPROTO_RAW" is there from the "beginning"
> >> [2] :)
> > 
> > I'm not an expert but Pablo's patch seems reasonable to me TBH.
> > Maybe I'm missing some extra MPTCP specific context?
> 
> I was imagining userspace programs doing something like:
> 
>     if (protocol < 0 || protocol >= IPPROTO_MAX)
>         die();
> 
>     syscall(...);

Is this theoretical, or you think any library might be doing this
already? I lack of sufficient knowledge of the MPTCP ecosystem to
evaluate myself.

> With Pablo's modification and such userspace code, this will break MPTCP
> support.
> 
> I'm maybe/probably worry for nothing, I don't know any specific lib
> doing that and to be honest, I don't know what is usually done in libc
> and libs implemented on top of that. On the other hand, it is hard to
> guess how it is used everywhere.
> 
> So yes, maybe it is fine?

It has been 3 years since the update, I think this is the existing
scenario looks like this:

1) Some userspace programs that rely on IPPROTO_MAX broke in some way
   and people fixed it by using IPPROTO_RAW (as you mentioned Matthieu)

2) Some userspace programs rely on the IPPROTO_MAX value in some way and
   they are broken (yet they need to be fixed).

If IPPROTO_MAX is restore, both two type of software described in the
scenarios above will be fine.

If Matthieu consider that likeliness that MPTCP breaks is low, then I
would go for applying the patch.

Yet another reason: Probably it is also good to restore it to
IPPROTO_MAX so Linux gets aligned again with other unix-like systems
which provide this definition? Some folks might care of portability in
userspace.
