Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4193A5EAC89
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiIZQaw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Sep 2022 12:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiIZQaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:30:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C24FBE1C;
        Mon, 26 Sep 2022 08:19:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ocptT-0006F9-1V; Mon, 26 Sep 2022 17:19:39 +0200
Date:   Mon, 26 Sep 2022 17:19:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        tgraf@suug.ch, urezki@gmail.com, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Martin Zaharinov <micron10@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
Message-ID: <20220926151939.GG12777@breakpoint.cc>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFp4H/rbdov7iDg@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <YzFp4H/rbdov7iDg@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Hocko <mhocko@suse.com> wrote:
> On Mon 26-09-22 10:31:39, Florian Westphal wrote:
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
> > bucket_table_alloc uses kvzalloc(GPF_ATOMIC).  If kmalloc fails, this now
> > falls through to vmalloc and hits code paths that assume GFP_KERNEL.
> > 
> > I sent a patch to restore GFP_ATOMIC support in kvmalloc but mm
> > maintainers rejected it.
> > 
> > This patch is partial revert of
> > commit 93f976b5190d ("lib/rhashtable: simplify bucket_table_alloc()"),
> > to avoid kvmalloc for ATOMIC case.
> > 
> > As kvmalloc doesn't warn when used with ATOMIC, kernel will only crash
> > once vmalloc fallback occurs, so we may see more crashes in other areas
> > in the future.
> > 
> > Most other callers seem ok but kvm_mmu_topup_memory_cache looks like it
> > might be affected by the same breakage, so Cc kvm@.
> > 
> > Reported-by: Martin Zaharinov <micron10@gmail.com>
> > Fixes: a421ef303008 ("mm: allow !GFP_KERNEL allocations for kvmalloc")
> > Link: https://lore.kernel.org/linux-mm/Yy3MS2uhSgjF47dy@pc636/T/#t
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Please continue in the original email thread until we sort out the most
> reasonable solution for this.

I've submitted a v2 using Michals proposed fix for kvmalloc api, if
thats merged no fixes are required in the callers, so this rhashtable
patch can be discarded.
