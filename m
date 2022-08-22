Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE0959BD78
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 12:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiHVKSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 06:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiHVKSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 06:18:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA4113D74;
        Mon, 22 Aug 2022 03:18:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E1AFF1F895;
        Mon, 22 Aug 2022 10:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661163514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ddo0jfrwDZ3L4Qe1pkeccO8zwyE5ZTiXSLFicdPBbV0=;
        b=l2HPQA8oiqSWOjr5YISW/KuLciitz9j6RqjXevMJrWGhcaWGKvyX6Zj+/OnVQo4rTK1KnI
        OEM0wcHb3br+QDpCFv3MIB8+FHsWw8B8C938xBwl4d8luxSbGRBkEpdKWb7go6H0Gz2zqd
        gmhm8TA66oR/B1Py5yILH6sDLusq8c8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA55D1332D;
        Mon, 22 Aug 2022 10:18:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gluMKvpXA2POCgAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 22 Aug 2022 10:18:34 +0000
Date:   Mon, 22 Aug 2022 12:18:34 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for
 low/min
Message-ID: <YwNX+vq9svMynVgW@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-2-shakeelb@google.com>
 <YwNSlZFPMgclrSCz@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwNSlZFPMgclrSCz@dhcp22.suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 22-08-22 11:55:33, Michal Hocko wrote:
> On Mon 22-08-22 00:17:35, Shakeel Butt wrote:
[...]
> > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > index eb156ff5d603..47711aa28161 100644
> > --- a/mm/page_counter.c
> > +++ b/mm/page_counter.c
> > @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
> >  				      unsigned long usage)
> >  {
> >  	unsigned long protected, old_protected;
> > -	unsigned long low, min;
> >  	long delta;
> >  
> >  	if (!c->parent)
> >  		return;
> >  
> > -	min = READ_ONCE(c->min);
> > -	if (min || atomic_long_read(&c->min_usage)) {
> > -		protected = min(usage, min);
> > +	protected = min(usage, READ_ONCE(c->min));
> > +	old_protected = atomic_long_read(&c->min_usage);
> > +	if (protected != old_protected) {
> 
> I have to cache that code back into brain. It is really subtle thing and
> it is not really obvious why this is still correct. I will think about
> that some more but the changelog could help with that a lot.

OK, so the this patch will be most useful when the min > 0 && min <
usage because then the protection doesn't really change since the last
call. In other words when the usage grows above the protection and your
workload benefits from this change because that happens a lot as only a
part of the workload is protected. Correct?

Unless I have missed anything this shouldn't break the correctness but I
still have to think about the proportional distribution of the
protection because that adds to the complexity here.
-- 
Michal Hocko
SUSE Labs
