Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627926E2CB9
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 01:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjDNXLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 19:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjDNXLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 19:11:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A4E4221
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 16:11:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pnSZv-0004rB-Ux; Sat, 15 Apr 2023 01:11:39 +0200
Date:   Sat, 15 Apr 2023 01:11:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org
Subject: Re: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
Message-ID: <20230414231139.GD5927@breakpoint.cc>
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-6-kuba@kernel.org>
 <20230414210950.GC5927@breakpoint.cc>
 <20230414150758.4e6e9d81@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414150758.4e6e9d81@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 14 Apr 2023 23:09:50 +0200 Florian Westphal wrote:
> > > +#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
> > >  	__u8			nf_trace:1;  
> > 
> > As already pointed out nftables can be a module, other than that
> 
> I copied it from:
> 
> static inline void nf_reset_trace(struct sk_buff *skb)
> {
> #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
> 	skb->nf_trace = 0;
> #endif
> }
>
> I can't quite figure out why this would be intentional.
> Do the existing conditions need to be fixed?

Yes, this is not correct; needs to be "|| IS_ENABLED(CONFIG_NF_TABLES)".

Fixes: 478b360a47b7 ("netfilter: nf_tables: fix nf_trace always-on with XT_TRACE=n")

Let me know if you'd like to add the fix to v2 of your patchset
yourself, otherwise I'll send a fixup patch to netfilter-devel@ on
monday.
