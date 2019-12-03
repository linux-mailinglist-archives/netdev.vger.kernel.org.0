Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC18D1101D8
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 17:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfLCQIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 11:08:11 -0500
Received: from foss.arm.com ([217.140.110.172]:44940 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfLCQIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 11:08:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2D1131B;
        Tue,  3 Dec 2019 08:08:10 -0800 (PST)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C3C23F52E;
        Tue,  3 Dec 2019 08:08:08 -0800 (PST)
Date:   Tue, 3 Dec 2019 16:08:06 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Noam Stolero <noams@mellanox.com>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, Qian Cai <cai@lca.pw>,
        Tal Gilboa <talgi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Amir Ancel <amira@mellanox.com>,
        Matan Nir <matann@mellanox.com>, Bar Tuaf <bartu@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] mm: kmemleak: Use a memory pool for kmemleak
 object allocations
Message-ID: <20191203160806.GB23522@arrakis.emea.arm.com>
References: <20190812160642.52134-1-catalin.marinas@arm.com>
 <08847a90-c37b-890f-8d0e-3ae1c3a1dd71@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08847a90-c37b-890f-8d0e-3ae1c3a1dd71@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 03:51:50PM +0000, Noam Stolero wrote:
> On 8/12/2019 7:06 PM, Catalin Marinas wrote:
> >     Following the discussions on v2 of this patch(set) [1], this series
> >     takes slightly different approach:
> > 
> >     - it implements its own simple memory pool that does not rely on the
> >       slab allocator
> > 
> >     - drops the early log buffer logic entirely since it can now allocate
> >       metadata from the memory pool directly before kmemleak is fully
> >       initialised
> > 
> >     - CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE option is renamed to
> >       CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE
> > 
> >     - moves the kmemleak_init() call earlier (mm_init())
> > 
> >     - to avoid a separate memory pool for struct scan_area, it makes the
> >       tool robust when such allocations fail as scan areas are rather an
> >       optimisation
> > 
> >     [1] http://lkml.kernel.org/r/20190727132334.9184-1-catalin.marinas@arm.com
> > 
> >     Catalin Marinas (3):
> >       mm: kmemleak: Make the tool tolerant to struct scan_area allocation
> >         failures
> >       mm: kmemleak: Simple memory allocation pool for kmemleak objects
> >       mm: kmemleak: Use the memory pool for early allocations
> > 
> >      init/main.c       |   2 +-
> >      lib/Kconfig.debug |  11 +-
> >      mm/kmemleak.c     | 325 ++++++++++++----------------------------------
> >      3 files changed, 91 insertions(+), 247 deletions(-)
> 
> We observe severe degradation in our network performance affecting all
> of our NICs. The degradation is directly linked to this patch.
> 
> What we run:
> Simple Iperf TCP loopback with 8 streams on ConnectX5-100GbE.
> Since it's a loopback test, traffic goes from the socket through the IP
> stack and back to the socket, without going through the NIC driver.

Something similar was reported before. Can you try commit 2abd839aa7e6
("kmemleak: Do not corrupt the object_list during clean-up") and see if
it fixes the problem for you? It was merged in 5.4-rc4.

-- 
Catalin
