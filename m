Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825D022AC45
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 12:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgGWKQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 06:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgGWKQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 06:16:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E36C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 03:16:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jyYGa-000719-Uo; Thu, 23 Jul 2020 12:15:57 +0200
Date:   Thu, 23 Jul 2020 12:15:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next 2/2] net: openvswitch: make masks cache size
 configurable
Message-ID: <20200723101556.GE23458@breakpoint.cc>
References: <159540642765.619787.5484526399990292188.stgit@ebuild>
 <159540647223.619787.13052866492035799125.stgit@ebuild>
 <20200722192252.GC23458@breakpoint.cc>
 <F147B9A7-3CD7-4F62-9BF4-389FD0FC36BC@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F147B9A7-3CD7-4F62-9BF4-389FD0FC36BC@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron <echaudro@redhat.com> wrote:
> On 22 Jul 2020, at 21:22, Florian Westphal wrote:
> > I see a 0 cache size is legal (turns it off) and that the allocation
> > path has a few sanity checks as well.
> > 
> > Would it make sense to add min/max policy to datapath_policy[] for this
> > as well?
> 
> Yes I could add the following:
> 
> @@ -1906,7 +1906,8 @@ static const struct nla_policy
> datapath_policy[OVS_DP_ATTR_MAX + 1] = {
>         [OVS_DP_ATTR_NAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ - 1
> },
>         [OVS_DP_ATTR_UPCALL_PID] = { .type = NLA_U32 },
>         [OVS_DP_ATTR_USER_FEATURES] = { .type = NLA_U32 },
> +       [OVS_DP_ATTR_MASKS_CACHE_SIZE] =  NLA_POLICY_RANGE(NLA_U32, 0,
> +               PCPU_MIN_UNIT_SIZE / sizeof(struct mask_cache_entry)),
>  };
> Let me know your thoughts

I think its a good idea.  When 'max' becomes too restricted one could
rework internal kernel logic to support larger size and userspace
can detect it by probing with a larger size first.
