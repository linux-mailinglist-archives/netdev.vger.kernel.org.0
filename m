Return-Path: <netdev+bounces-9328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1596728749
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89EF52817E7
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2CE16424;
	Thu,  8 Jun 2023 18:34:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC985180A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 18:34:34 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8BA2136
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:34:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1q7KSt-0002fn-74; Thu, 08 Jun 2023 20:34:31 +0200
Date: Thu, 8 Jun 2023 20:34:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Davide Caratti <dcaratti@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net v2 2/3] net/sched: act_ipt: add sanity checks on skb
 before calling target
Message-ID: <20230608183431.GF27126@breakpoint.cc>
References: <20230608140246.15190-1-fw@strlen.de>
 <20230608140246.15190-3-fw@strlen.de>
 <CAKa-r6uyObXeAUTj28=f+V8BvrUQpXGP12JHRikct3SB=x48GA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKa-r6uyObXeAUTj28=f+V8BvrUQpXGP12JHRikct3SB=x48GA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Davide Caratti <dcaratti@redhat.com> wrote:
> hello Florian,
> 
> On Thu, Jun 8, 2023 at 4:04 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Netfilter targets make assumptions on the skb state, for example
> > iphdr is supposed to be in the linear area.
> >
> [...]
> 
> > @@ -244,9 +264,22 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb,
> >                 .pf     = NFPROTO_IPV4,
> >         };
> >
> > +       if (skb->protocol != htons(ETH_P_IP))
> > +               return TC_ACT_UNSPEC;
> > +
> 
> maybe this can be converted to skb_protocol(skb, ...)  so that it's
> clear how VLAN packets are treated ?

Not sure how to handle this.

act_ipt claims NFPROTO_IPV4; for iptables/nftables one has to use
the interface name ("-i vlan0") to match on the vlan interface.

I don't really want to add code that pulls/pops the vlan headers
in act_ipt...

