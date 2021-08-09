Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7621D3E4E02
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbhHIUjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhHIUjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:39:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B113C0613D3;
        Mon,  9 Aug 2021 13:39:22 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mDC3I-0002rF-E2; Mon, 09 Aug 2021 22:39:16 +0200
Date:   Mon, 9 Aug 2021 22:39:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
Message-ID: <20210809203916.GP607@breakpoint.cc>
References: <000000000000b720b705c8f8599f@google.com>
 <cdb5f0c9-1ad9-dd9d-b24d-e127928ada98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdb5f0c9-1ad9-dd9d-b24d-e127928ada98@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> wrote:
> I think, there a missing lock in this function:
> 
> 	for_each_possible_cpu(cpu) {
> 		ct = per_cpu(nft_ct_pcpu_template, cpu);
> 		if (!ct)
> 			break;
> 		nf_ct_put(ct);
> 		per_cpu(nft_ct_pcpu_template, cpu) = NULL;
> 		
> 	}
> 
> Syzbot hit a UAF in nft_ct_tmpl_put_pcpu() (*), but freed template should be
> NULL.
> 
> So I suspect following scenario:
> 
> 
> CPU0:			CPU1:
> = per_cpu()
> 			= per_cpu()
> 
> nf_ct_put
> per_cpu = NULL
> 			nf_ct_put()
> 			* UAF *

Yes and no.  The above is fine since pcpu will return different pointers
for cpu 0 and 1.

The race is between two different net namespaces that race when
changing nft_ct_pcpu_template_refcnt.
This happens since

commit f102d66b335a417d4848da9441f585695a838934
netfilter: nf_tables: use dedicated mutex to guard transactions

Before this, all transactions were serialized by a global mutex,
now we only serialize transactions in the same netns.

Its probably best to add
DEFINE_MUTEX(nft_ct_pcpu_mutex) and then acquire that when we need to
inc/dec the nft_ct_pcpu_template_refcnt so we can't have two distinct
cpus hitting a zero refcount.

Would you send a patch for this?

Thanks.
