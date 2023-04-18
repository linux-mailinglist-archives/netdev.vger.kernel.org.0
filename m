Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEFC6E6D17
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjDRTtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjDRTtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:49:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AA27DB9;
        Tue, 18 Apr 2023 12:48:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1porJo-0006QP-BD; Tue, 18 Apr 2023 21:48:48 +0200
Date:   Tue, 18 Apr 2023 21:48:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v3 1/6] bpf: add bpf_link support for
 BPF_NETFILTER programs
Message-ID: <20230418194848.GA21058@breakpoint.cc>
References: <20230418131038.18054-1-fw@strlen.de>
 <20230418131038.18054-2-fw@strlen.de>
 <20230418183504.cxa3wdfxs2yx4cqo@MacBook-Pro-6.local.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418183504.cxa3wdfxs2yx4cqo@MacBook-Pro-6.local.dhcp.thefacebook.com>
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
> > +int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > +{
> > +	struct net *net = current->nsproxy->net_ns;
> > +	struct bpf_link_primer link_primer;
> > +	struct bpf_nf_link *link;
> > +	int err;
> > +
> > +	if (attr->link_create.flags)
> > +		return -EINVAL;
> > +
> > +	if (attr->link_create.netfilter.reserved[0] | attr->link_create.netfilter.reserved[1])
> > +		return -EINVAL;
> 
> Why add 'reserved' name that we cannot change later?
> I think 'flags' is enough.

OK, I'll zap this.

> > +	link->hook_ops.pf = attr->link_create.netfilter.pf;
> > +	link->hook_ops.priority = attr->link_create.netfilter.prio;
> 
> let's use the same name in both cases ? Either prio or priority. Both sound fine.

OK, I'll go with "priority" then because thats what its named in
nf_hook_ops structure.
