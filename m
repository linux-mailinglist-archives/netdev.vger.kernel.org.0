Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E9757EC91
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 09:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiGWHuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 03:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiGWHuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 03:50:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 975321580F;
        Sat, 23 Jul 2022 00:50:53 -0700 (PDT)
Date:   Sat, 23 Jul 2022 09:50:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 07/13] net: netfilter: Add kfuncs to allocate
 and insert CT
Message-ID: <YtuoWpOJmfcb/3Yu@salvia>
References: <20220721134245.2450-1-memxor@gmail.com>
 <20220721134245.2450-8-memxor@gmail.com>
 <YtpnmI1oPOQRv3j3@salvia>
 <CAP01T75r6OQffvq8u3e4Srj6c1vsN_NP0PohWikYPUbdp1nDXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAP01T75r6OQffvq8u3e4Srj6c1vsN_NP0PohWikYPUbdp1nDXQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 11:39:49AM +0200, Kumar Kartikeya Dwivedi wrote:
> On Fri, 22 Jul 2022 at 11:02, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi,
> >
> > On Thu, Jul 21, 2022 at 03:42:39PM +0200, Kumar Kartikeya Dwivedi wrote:
> > > diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> > > index 37866c8386e2..83a60c684e6c 100644
> > > --- a/include/net/netfilter/nf_conntrack_core.h
> > > +++ b/include/net/netfilter/nf_conntrack_core.h
> > > @@ -84,4 +84,19 @@ void nf_conntrack_lock(spinlock_t *lock);
> > >
> > >  extern spinlock_t nf_conntrack_expect_lock;
> > >
> > > +/* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
> > > +
> > > +#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> > > +    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
> > > +    IS_ENABLED(CONFIG_NF_CT_NETLINK))
> >
> > There must be a better way to do this without ifdef pollution?
> >
> > Could you fix this?
> 
> I can just remove the ifdefs completely. The first part of the ifdef
> is the correct way to detect BPF support for nf_conntrack, the second
> is for ct netlink. These are the only two users. But it's not a lot of
> code, so until it grows too much we can compile it unconditionally.

I would suggest to compile in these small functions unconditionally.

> Or do you have anything else in mind (like defining a macro for the
> bpf one and making the ifdef look less ugly)?

it's the ifdef pollution that it would be good to avoid IMO.
