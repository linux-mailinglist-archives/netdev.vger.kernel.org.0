Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634B852AC33
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbiEQTsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiEQTsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:48:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5663137BDC;
        Tue, 17 May 2022 12:47:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nr3Ad-0003Z8-52; Tue, 17 May 2022 21:47:51 +0200
Date:   Tue, 17 May 2022 21:47:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com>
Cc:     ali.abdallah@suse.com, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        ozsh@nvidia.com, pabeni@redhat.com, pablo@netfilter.org,
        paulb@nvidia.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in nf_confirm
Message-ID: <20220517194751.GA4316@breakpoint.cc>
References: <000000000000fb4af305df391431@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fb4af305df391431@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SORTED_RECIPS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d887ae3247e0 octeontx2-pf: Remove unnecessary synchronize_..
> git tree:       net-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=17f2b659f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b1aab282dc5dd920
> dashboard link: https://syzkaller.appspot.com/bug?extid=793a590957d9c1b96620
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1313dce6f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=169eb59ef00000
> 
> The issue was bisected to:
> 
> commit 1397af5bfd7d32b0cf2adb70a78c9a9e8f11d912
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon Apr 11 11:01:18 2022 +0000
> 
>     netfilter: conntrack: remove the percpu dying list

AFAICS this bug exists since
Fixes: 71d8c47fc653 ("netfilter: conntrack: introduce clash resolution on insertion race")

nf_confirm needs to re-fetch 'ct' from skb->_nfct.  Will send a patch.
