Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35315E7BF2
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiIWNfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiIWNfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:35:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A934997ECC;
        Fri, 23 Sep 2022 06:35:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1obipk-0005LV-7v; Fri, 23 Sep 2022 15:35:12 +0200
Date:   Fri, 23 Sep 2022 15:35:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Florian Westphal <fw@strlen.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <20220923133512.GE22541@breakpoint.cc>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yy20toVrIktiMSvH@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Hocko <mhocko@suse.com> wrote:
> On Fri 23-09-22 12:38:58, Florian Westphal wrote:
> > Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
> >  kernel BUG at mm/vmalloc.c:2437!
> >  invalid opcode: 0000 [#1] SMP
> >  CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
> >  [..]
> >  RIP: 0010:__get_vm_area_node+0x120/0x130
> >   __vmalloc_node_range+0x96/0x1e0
> >   kvmalloc_node+0x92/0xb0
> >   bucket_table_alloc.isra.0+0x47/0x140
> >   rhashtable_try_insert+0x3a4/0x440
> >   rhashtable_insert_slow+0x1b/0x30
> >  [..]
> > 
> > bucket_table_alloc uses kvzallocGPF_ATOMIC).  If kmalloc fails, this now
> > falls through to vmalloc and hits code paths that assume GFP_KERNEL.
> > 
> > Revert the problematic change and stay with slab allocator.
> 
> Why don't you simply fix the caller?

Uh, not following?

kvzalloc(GFP_ATOMIC) was perfectly fine, is this illegal again?

I can revert 93f976b5190df32793908d49165f78e67fcb66cf instead
but that change is from 2018.
