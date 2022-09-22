Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021C85E6209
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiIVMNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiIVMM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:12:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2D6E21E0;
        Thu, 22 Sep 2022 05:12:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1obL4Y-0005jv-3m; Thu, 22 Sep 2022 14:12:54 +0200
Date:   Thu, 22 Sep 2022 14:12:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>, pablo@netfilter.org,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        linux-mm@kvack.org, mhocko@suse.com
Subject: Re: Bug Report Flowtable NFT with kernel 5.19.9
Message-ID: <20220922121254.GA19803@breakpoint.cc>
References: <09BE0B8A-3ADF-458E-B75E-931B74996355@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09BE0B8A-3ADF-458E-B75E-931B74996355@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> This is bug report for flowtable and kernel 5.19.9
> 
> simple config nat + flowtable 

CC mm experts.  I'm not sure that this is a bug in netfilter/rhashtable,
looks like mm problem perhaps?

I am a bit confused wrt. kvzalloc+GFP_ATOMIC.  This looks like following is happening:

5.19.9 kernel BUGs with:

> Sep 22 07:43:49  [460691.305266][   C28] kernel BUG at mm/vmalloc.c:2437!

[ BUG_ON(in_interrupt ]

> Sep 22 07:43:50  [460692.031617][   C28] Call Trace:
> Sep 22 07:43:50  [460692.064498][   C28]  <IRQ>
> Sep 22 07:43:50  [460692.096177][   C28]  __vmalloc_node_range+0x96/0x1e0
> Sep 22 07:43:50  [460692.128014][   C28]  ? bucket_table_alloc.isra.0+0x47/0x140
> Sep 22 07:43:50  [460692.160134][   C28]  kvmalloc_node+0x92/0xb0
> Sep 22 07:43:50  [460692.191885][   C28]  ? bucket_table_alloc.isra.0+0x47/0x140
> Sep 22 07:43:50  [460692.224234][   C28]  bucket_table_alloc.isra.0+0x47/0x140
> Sep 22 07:43:50  [460692.256840][   C28]  rhashtable_try_insert+0x3a4/0x440

[ rest irrelevant ]

AFAICS this is caused by kvzalloc(GFP_ATOMIC) which somehow ends up in
GFP_KERNEL-only territory?  Looking at recent history I see

commit a421ef303008b0ceee2cfc625c3246fa7654b0ca
Author: Michal Hocko <mhocko@suse.com>
Date:   Fri Jan 14 14:07:07 2022 -0800

    mm: allow !GFP_KERNEL allocations for kvmalloc

before this, GFP_ATOMIC made sure we stay with plain kmalloc, but
now it appears that we can end up in places where GFP_ATOMIC isn't
allowed?

Original bug report is here:
https://lore.kernel.org/netdev/09BE0B8A-3ADF-458E-B75E-931B74996355@gmail.com/T/#u
