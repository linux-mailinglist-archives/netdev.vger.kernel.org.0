Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C313B4EDCB5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbiCaPXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238170AbiCaPXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:23:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D6F220FD9;
        Thu, 31 Mar 2022 08:21:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nZwcP-000211-AT; Thu, 31 Mar 2022 17:21:49 +0200
Date:   Thu, 31 Mar 2022 17:21:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vincent Pelletier <plr.vincent@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 2/5] netfilter: conntrack: sanitize table size
 default settings
Message-ID: <20220331152149.GA5024@breakpoint.cc>
References: <20210903163020.13741-1-pablo@netfilter.org>
 <20210903163020.13741-3-pablo@netfilter.org>
 <20220331145909.085a0f30@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331145909.085a0f30@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vincent Pelletier <plr.vincent@gmail.com> wrote:
> On Fri,  3 Sep 2021 18:30:17 +0200, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > conntrack has two distinct table size settings:
> > nf_conntrack_max and nf_conntrack_buckets.
> > 
> > The former limits how many conntrack objects are allowed to exist
> > in each namespace.
> > 
> > The second sets the size of the hashtable.
> > 
> > As all entries are inserted twice (once for original direction, once for
> > reply), there should be at least twice as many buckets in the table than
> > the maximum number of conntrack objects that can exist at the same time.
> > 
> > Change the default multiplier to 1 and increase the chosen bucket sizes.
> > This results in the same nf_conntrack_max settings as before but reduces
> > the average bucket list length.
> [...]
> >  		nf_conntrack_htable_size
> >  			= (((nr_pages << PAGE_SHIFT) / 16384)
> >  			   / sizeof(struct hlist_head));
> > -		if (nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
> > -			nf_conntrack_htable_size = 65536;
> > +		if (BITS_PER_LONG >= 64 &&
> > +		    nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
> > +			nf_conntrack_htable_size = 262144;
> >  		else if (nr_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
> > -			nf_conntrack_htable_size = 16384;
> [...]
> > +			nf_conntrack_htable_size = 65536;
> 
> With this formula, there seems to be a discontinuity between the
> proportional and fixed regimes:
> 64bits: 4GB/16k/8 = 32k, which gets bumped to 256k
> 32bits: 1GB/16k/4 = 16k, which gets bumped to 64k
> 
> Is this intentional ?

There is no science here.  This tries to pick a sane default setting,
thats all. Its not possible to pick one that works for everyone and everything.

32bit kernel can't access more than 1GB so I did not want to
increase that too much.

These are default settings, users should be free to pick any value they
like/need.
