Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9246EAE53
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjDUPwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjDUPwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:52:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F54A93F4;
        Fri, 21 Apr 2023 08:52:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ppt42-0003hv-Aq; Fri, 21 Apr 2023 17:52:46 +0200
Date:   Fri, 21 Apr 2023 17:52:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v4 7/7] selftests/bpf: add missing netfilter
 return value and ctx access tests
Message-ID: <20230421155246.GD12121@breakpoint.cc>
References: <20230420124455.31099-1-fw@strlen.de>
 <20230420124455.31099-8-fw@strlen.de>
 <20230420201655.77kkgi3dh7fesoll@MacBook-Pro-6.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420201655.77kkgi3dh7fesoll@MacBook-Pro-6.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> On Thu, Apr 20, 2023 at 02:44:55PM +0200, Florian Westphal wrote:
> > +
> > +SEC("netfilter")
> > +__description("netfilter valid context access")
> > +__success __failure_unpriv
> > +__retval(1)
> > +__naked void with_invalid_ctx_access_test5(void)
> > +{
> > +	asm volatile ("					\
> > +	r2 = *(u64*)(r1 + %[__bpf_nf_ctx_state]);	\
> > +	r1 = *(u64*)(r1 + %[__bpf_nf_ctx_skb]);		\
> > +	r0 = 1;						\
> > +	exit;						\
> > +"	:
> > +	: __imm_const(__bpf_nf_ctx_state, offsetof(struct bpf_nf_ctx, state)),
> > +	  __imm_const(__bpf_nf_ctx_skb, offsetof(struct bpf_nf_ctx, skb))
> > +	: __clobber_all);
> 
> Could you write this one in C instead?
>
> Also check that skb and state are dereferenceable after that.

My bad. Added this and that:

SEC("netfilter")
__description("netfilter valid context read and invalid write")
__failure __msg("only read is supported")
int with_invalid_ctx_access_test5(struct bpf_nf_ctx *ctx)
{
  struct nf_hook_state *state = (void *)ctx->state;

  state->sk = NULL;
  return 1;
}

SEC("netfilter")
__description("netfilter test prog with skb and state read access")
__success __failure_unpriv
__retval(0)
int with_valid_ctx_access_test6(struct bpf_nf_ctx *ctx)
{
  const struct nf_hook_state *state = ctx->state;
  struct sk_buff *skb = ctx->skb;
  const struct iphdr *iph;
  const struct tcphdr *th;
  u8 buffer_iph[20] = {};
  u8 buffer_th[40] = {};
  struct bpf_dynptr ptr;
  uint8_t ihl;

  if (skb->len <= 20 || bpf_dynptr_from_skb(skb, 0, &ptr))
        return 1;

  iph = bpf_dynptr_slice(&ptr, 0, buffer_iph, sizeof(buffer_iph));
  if (!iph)
    return 1;

   if (state->pf != 2)
     return 1;

   ihl = iph->ihl << 2;
   th = bpf_dynptr_slice(&ptr, ihl, buffer_th, sizeof(buffer_th));
   if (!th)
	return 1;

     return th->dest == bpf_htons(22) ? 1 : 0;
}

"Worksforme".  Is there anything else thats missing?
If not I'll send v5 on Monday.

> Since they should be seen as trusted ptr_to_btf_id skb->len and state->sk should work.
> You cannot craft this test case in asm, since it needs CO-RE.
> 
> Also see that BPF CI is not happy:
> https://github.com/kernel-patches/bpf/actions/runs/4757642030/jobs/8455500277
> Error: #112 libbpf_probe_prog_types
> Error: #112/32 libbpf_probe_prog_types/BPF_PROG_TYPE_NETFILTER
> Error: #113 libbpf_str
> Error: #113/4 libbpf_str/bpf_prog_type_str

prog_type_name[] lacks "netfilter" entry, and a missing 'case
PROG_NETFILTER', v5 should pass this now.
