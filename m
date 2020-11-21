Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BA72BC0BB
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 17:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgKUQwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 11:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgKUQwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 11:52:36 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2D6C0613CF;
        Sat, 21 Nov 2020 08:52:35 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kgW7f-0006hd-5O; Sat, 21 Nov 2020 17:52:27 +0100
Date:   Sat, 21 Nov 2020 17:52:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net,
        edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
Message-ID: <20201121165227.GT15137@breakpoint.cc>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
 <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
 <20201121160941.GA485907@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121160941.GA485907@shredder.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> wrote:
> On Thu, Oct 29, 2020 at 05:36:19PM +0000, Aleksandr Nogikh wrote:
> > From: Aleksandr Nogikh <nogikh@google.com>
> > 
> > Remote KCOV coverage collection enables coverage-guided fuzzing of the
> > code that is not reachable during normal system call execution. It is
> > especially helpful for fuzzing networking subsystems, where it is
> > common to perform packet handling in separate work queues even for the
> > packets that originated directly from the user space.
> > 
> > Enable coverage-guided frame injection by adding kcov remote handle to
> > skb extensions. Default initialization in __alloc_skb and
> > __build_skb_around ensures that no socket buffer that was generated
> > during a system call will be missed.
> > 
> > Code that is of interest and that performs packet processing should be
> > annotated with kcov_remote_start()/kcov_remote_stop().
> > 
> > An alternative approach is to determine kcov_handle solely on the
> > basis of the device/interface that received the specific socket
> > buffer. However, in this case it would be impossible to distinguish
> > between packets that originated during normal background network
> > processes or were intentionally injected from the user space.
> > 
> > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > Acked-by: Willem de Bruijn <willemb@google.com>
> 
> [...]
> 
> > @@ -249,6 +249,9 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> >  
> >  		fclones->skb2.fclone = SKB_FCLONE_CLONE;
> >  	}
> > +
> > +	skb_set_kcov_handle(skb, kcov_common_handle());
> 
> Hi,
> 
> This causes skb extensions to be allocated for the allocated skb, but
> there are instances that blindly overwrite 'skb->extensions' by invoking
> skb_copy_header() after __alloc_skb(). For example, skb_copy(),
> __pskb_copy_fclone() and skb_copy_expand(). This results in the skb
> extensions being leaked [1].

[..]
> Other suggestions?

Aleksandr, why was this made into an skb extension in the first place?

AFAIU this feature is usually always disabled at build time.
For debug builds (test farm /debug kernel etc) its always needed.

If thats the case this u64 should be an sk_buff member, not an
extension.
