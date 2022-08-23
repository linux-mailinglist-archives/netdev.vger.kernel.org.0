Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E336159D03D
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 06:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbiHWEtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 00:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbiHWEtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 00:49:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31D542AF1;
        Mon, 22 Aug 2022 21:49:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4ED8320C08;
        Tue, 23 Aug 2022 04:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661230180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6PhQCQsVbk7n5tc8kIa2TGPQzQV7xBjFKyKTp3F/kUQ=;
        b=GHdIKuo9daTXmA1UtzVKXzG3TkVRWU/Hmqj+RbiMv3OJ4dTblT04XZHLZp0aD5LS5cC30D
        3LyVtaJ66+nfDToneuanA/XfjkqmCEmv+bcfxqmGjVPUhTTIduFHwku/BIQVPxPYqAn9vZ
        a1w9xWSCxG8vZkzqtnDB7CJ18m5DIb8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2F49E13AB7;
        Tue, 23 Aug 2022 04:49:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PzY0CWRcBGPBCgAAMHmgww
        (envelope-from <mhocko@suse.com>); Tue, 23 Aug 2022 04:49:40 +0000
Date:   Tue, 23 Aug 2022 06:49:39 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Message-ID: <YwRcY6oSnlYOD9n5@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
 <YwPM6o1+pZ2kRyy3@P9FQF9L96D>
 <YwPZ1lpJ98pZSLmw@dhcp22.suse.cz>
 <YwQ54pvNwy0/5u3C@P9FQF9L96D>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwQ54pvNwy0/5u3C@P9FQF9L96D>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 22-08-22 19:22:26, Roman Gushchin wrote:
> On Mon, Aug 22, 2022 at 09:34:59PM +0200, Michal Hocko wrote:
> > On Mon 22-08-22 11:37:30, Roman Gushchin wrote:
> > [...]
> > > I wonder only if we want to make it configurable (Idk a sysctl or maybe
> > > a config option) and close the topic.
> > 
> > I do not think this is a good idea. We have other examples where we have
> > outsourced internal tunning to the userspace and it has mostly proven
> > impractical and long term more problematic than useful (e.g.
> > lowmem_reserve_ratio, percpu_pagelist_high_fraction, swappiness just to
> > name some that come to my mind). I have seen more often these to be used
> > incorrectly than useful.
> 
> A agree, not a strong opinion here. But I wonder if somebody will
> complain on Shakeel's change because of the reduced accuracy.
> I know some users are using memory cgroups to track the size of various
> workloads (including relatively small) and 32->64 pages per cpu change
> can be noticeable for them. But we can wait for an actual bug report :)

Yes, that would be my approach. I have seen reports like that already
but that was mostly because of heavy caching on the SLUB side on older
kernels. So there surely are workloads with small limits configured
(e.g. 20MB). On the other hand those users were receptive to adapt their
limits as they were kinda arbitrary anyway.
 
> > In this case, I guess we should consider either moving to per memcg
> > charge batching and see whether the pcp overhead x memcg_count is worth
> > that or some automagic tuning of the batch size depending on how
> > effectively the batch is used. Certainly a lot of room for
> > experimenting.
> 
> I'm not a big believer into the automagic tuning here because it's a fundamental
> trade-off of accuracy vs performance and various users might make a different
> choice depending on their needs, not on the cpu count or something else.

Yes, this not an easy thing to get right. I was mostly thinking some
auto scaling based on the limit size or growing the stock if cache hits
are common and decrease when stocks get flushed often because multiple
memcgs compete over the same pcp stock. But to me it seems like a per
memcg approach might lead better results without too many heuristics
(albeit more memory hungry).

> Per-memcg batching sounds interesting though. For example, we can likely
> batch updates on leaf cgroups and have a single atomic update instead of
> multiple most of the times. Or do you mean something different?

No, that was exactly my thinking as well.

-- 
Michal Hocko
SUSE Labs
