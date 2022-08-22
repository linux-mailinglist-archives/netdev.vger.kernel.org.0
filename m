Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A38059C292
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbiHVPXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbiHVPV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:21:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86863E767;
        Mon, 22 Aug 2022 08:15:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9F132202FF;
        Mon, 22 Aug 2022 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661181308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ko/ZbbYlRZVDcCBDACh47r5MpCi7V/QJtzGfx/uTT4o=;
        b=AXWrARvl88HySuV2IvKZojEAAxu+6WFr21jizwVhd03l87uhLlzEhtWF1q5t+tYCKFoU1r
        zhU9Xf5P/O2u82zIGY3fhc2PPA5D+bx5XJNxv1WYALMnAhhLQVdq10YN3QdYT/wpkS5CBR
        HnhzLzMG9IccwSBFROGrZYIj9DWOx1g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F85F1332D;
        Mon, 22 Aug 2022 15:15:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id U/SfGHydA2PFEwAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 22 Aug 2022 15:15:08 +0000
Date:   Mon, 22 Aug 2022 17:15:07 +0200
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
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter
 fields
Message-ID: <YwOde3qFvne7Umld@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-3-shakeelb@google.com>
 <YwNZD4YlRkvQCWFi@dhcp22.suse.cz>
 <CALvZod5pw_7hnH44hdC3rDGQxQB2XATrViNNGosG3FnUoWo-4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod5pw_7hnH44hdC3rDGQxQB2XATrViNNGosG3FnUoWo-4A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 22-08-22 08:06:14, Shakeel Butt wrote:
[...]
> > >  struct page_counter {
> > > +     /*
> > > +      * Make sure 'usage' does not share cacheline with any other field. The
> > > +      * memcg->memory.usage is a hot member of struct mem_cgroup.
> > > +      */
> > > +     PC_PADDING(_pad1_);
> >
> > Why don't you simply require alignment for the structure?
> 
> I don't just want the alignment of the structure. I want different
> fields of this structure to not share the cache line. More
> specifically the 'high' and 'usage' fields. With this change the usage
> will be its own cache line, the read-most fields will be on separate
> cache line and the fields which sometimes get updated on charge path
> based on some condition will be a different cache line from the
> previous two.

I do not follow. If you make an explicit requirement for the structure
alignement then the first field in the structure will be guarantied to
have that alignement and you achieve the rest to be in the other cache
line by adding padding behind that.

-- 
Michal Hocko
SUSE Labs
