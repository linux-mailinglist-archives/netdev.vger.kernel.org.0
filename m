Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D846DF0D4
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 11:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjDLJqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 05:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjDLJqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 05:46:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F298B93F9;
        Wed, 12 Apr 2023 02:45:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pmX34-0008Dq-No; Wed, 12 Apr 2023 11:45:54 +0200
Date:   Wed, 12 Apr 2023 11:45:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Quentin Deslandes <qde@naccy.de>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, bpf@vger.kernel.org, dxu@dxuuu.xyz
Subject: Re: [PATCH bpf-next 0/6] bpf: add netfilter program type
Message-ID: <20230412094554.GD6670@breakpoint.cc>
References: <20230405161116.13565-1-fw@strlen.de>
 <7d97222a-36c1-ee77-4ad6-d8d2c6056d4c@naccy.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d97222a-36c1-ee77-4ad6-d8d2c6056d4c@naccy.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Deslandes <qde@naccy.de> wrote:
> On 05/04/2023 18:11, Florian Westphal wrote:
> > Add minimal support to hook bpf programs to netfilter hooks, e.g.
> > PREROUTING or FORWARD.
> > 
> > For this the most relevant parts for registering a netfilter
> > hook via the in-kernel api are exposed to userspace via bpf_link.
> > 
> > The new program type is 'tracing style', i.e. there is no context
> > access rewrite done by verifier, the function argument (struct bpf_nf_ctx)
> > isn't stable.
> > There is no support for direct packet access, dynptr api should be used
> > instead.
> 
> Does this mean the verifier will reject any program accessing ctx->skb
> (e.g. ctx->skb + X)?

Do you mean access to ctx->skb->data + X?  If so, yes, that won't work.

Otherwise, then no, it just means that programs might have to be recompiled
if they lack needed relocation information, but only if bpf_nf_ctx structure is
changed.

Initial version used "__sk_buff *skb", like e.g. clsact.  I was told
to not do that and expose the real kernel-side structure instead and to
not bother with direct packet access (skb->data access) support.

> >  #include "vmlinux.h"
> > extern int bpf_dynptr_from_skb(struct __sk_buff *skb, __u64 flags,
> >                                struct bpf_dynptr *ptr__uninit) __ksym;
> > extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, uint32_t offset,
> >                                    void *buffer, uint32_t buffer__sz) __ksym;
> > SEC("netfilter")
> > int nf_test(struct bpf_nf_ctx *ctx)
> > {
> > 	struct nf_hook_state *state = ctx->state;
> > 	struct sk_buff *skb = ctx->skb;

ctx->skb is dereferenced...

> > 	if (bpf_dynptr_from_skb(skb, 0, &ptr))
> > 		return NF_DROP;

... dynptr is created ...

> > 	iph = bpf_dynptr_slice(&ptr, 0, &_iph, sizeof(_iph));
> > 	if (!iph)
> > 		return NF_DROP;
> > 	th = bpf_dynptr_slice(&ptr, iph->ihl << 2, &_th, sizeof(_th));

ip header access.
