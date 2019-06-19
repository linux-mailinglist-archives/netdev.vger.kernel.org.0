Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DDF4B14A
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 07:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfFSFVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 01:21:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:45088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfFSFVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 01:21:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 60E36AE04;
        Wed, 19 Jun 2019 05:21:34 +0000 (UTC)
Date:   Wed, 19 Jun 2019 07:21:33 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, vbabka@suse.cz,
        mgorman@techsingularity.net, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] mm: mempolicy: handle vma with unmovable pages mapped
 correctly in mbind
Message-ID: <20190619052133.GB2968@dhcp22.suse.cz>
References: <1560797290-42267-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190618130253.GH3318@dhcp22.suse.cz>
 <cf33b724-fdd5-58e3-c06a-1bc563525311@linux.alibaba.com>
 <20190618182848.GJ3318@dhcp22.suse.cz>
 <68c2592d-b747-e6eb-329f-7a428bff1f86@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68c2592d-b747-e6eb-329f-7a428bff1f86@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 18-06-19 14:13:16, Yang Shi wrote:
[...]
> > > > > Change migrate_page_add() to check if the page is movable or not, if it
> > > > > is unmovable, just return -EIO.  We don't have to check non-LRU movable
> > > > > pages since just zsmalloc and virtio-baloon support this.  And, they
> > > > > should be not able to reach here.
> > > > You are not checking whether the page is movable, right? You only rely
> > > > on PageLRU check which is not really an equivalent thing. There are
> > > > movable pages which are not LRU and also pages might be off LRU
> > > > temporarily for many reasons so this could lead to false positives.
> > > I'm supposed non-LRU movable pages could not reach here. Since most of them
> > > are not mmapable, i.e. virtio-balloon, zsmalloc. zram device is mmapable,
> > > but the page fault to that vma would end up allocating user space pages
> > > which are on LRU. If I miss something please let me know.
> > That might be true right now but it is a very subtle assumption that
> > might break easily in the future. The point is still that even LRU pages
> > might be isolated from the LRU list temporarily and you do not want this
> > to cause the failure easily.
> 
> I used to have !__PageMovable(page), but it was removed since the
> aforementioned reason. I could add it back.
> 
> For the temporary off LRU page, I did a quick search, it looks the most
> paths have to acquire mmap_sem, so it can't race with us here. Page
> reclaim/compaction looks like the only race. But, since the mapping should
> be preserved even though the page is off LRU temporarily unless the page is
> reclaimed, so we should be able to exclude temporary off LRU pages by
> calling page_mapping() and page_anon_vma().
> 
> So, the fix may look like:
> 
> if (!PageLRU(head) && !__PageMovable(page)) {
>     if (!(page_mapping(page) || page_anon_vma(page)))
>         return -EIO;

This is getting even more muddy TBH. Is there any reason that we have to
handle this problem during the isolation phase rather the migration?
-- 
Michal Hocko
SUSE Labs
