Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301454DA3B1
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351550AbiCOUHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351439AbiCOUHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:07:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEFB56234;
        Tue, 15 Mar 2022 13:05:56 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nUDQX-000536-Ey; Tue, 15 Mar 2022 21:05:53 +0100
Date:   Tue, 15 Mar 2022 21:05:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: Reject tables of
 unsupported family
Message-ID: <YjDxoXbCfnPVrxT2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20220315091513.66544-1-pablo@netfilter.org>
 <20220315091513.66544-3-pablo@netfilter.org>
 <20220315115644.66fab74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315115644.66fab74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Mar 15, 2022 at 11:56:44AM -0700, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 10:15:09 +0100 Pablo Neira Ayuso wrote:
> > +	return false
> > +#ifdef CONFIG_NF_TABLES_INET
> > +		|| family == NFPROTO_INET
> > +#endif
> > +#ifdef CONFIG_NF_TABLES_IPV4
> > +		|| family == NFPROTO_IPV4
> > +#endif
> > +#ifdef CONFIG_NF_TABLES_ARP
> > +		|| family == NFPROTO_ARP
> > +#endif
> > +#ifdef CONFIG_NF_TABLES_NETDEV
> > +		|| family == NFPROTO_NETDEV
> > +#endif
> > +#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
> 
> is there a reason this one is IS_ENABLED() and everything else is ifdef?

I based my patch on the existing ifdefs in nft_chain_filter.c where
these config symbols are checked exactly like above. Looking at git
history, the check was changed from a simple ifdef in commit
dfee0e99bcff7 ("netfilter: bridge: make NF_TABLES_BRIDGE tristate").

> > +		|| family == NFPROTO_BRIDGE
> > +#endif
> > +#ifdef CONFIG_NF_TABLES_IPV6
> > +		|| family == NFPROTO_IPV6
> > +#endif
> > +		;
> 
> 	return (IS_ENABLED(CONFIG_NF_TABLES_INET) && family == NFPROTO_INET)) ||
> 	       (IS_ENABLED(CONFIG_NF_TABLES_IPV4) && family == NFPROTO_IPV4)) ||
> 		...
> 
> would have also been an option, for future reference.

Yes, that is indeed much cleaner. I wasn't aware of this possibility
using IS_ENABLED. What do you think, worth a follow-up?

Thanks, Phil
