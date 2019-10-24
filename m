Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161C6E2E28
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393217AbfJXKJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:09:00 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47034 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388287AbfJXKI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:08:59 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 1E9BB25B768;
        Thu, 24 Oct 2019 21:08:58 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 7CA1336C2; Thu, 24 Oct 2019 12:08:55 +0200 (CEST)
Date:   Thu, 24 Oct 2019 12:08:55 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH net] ipvs: move old_secure_tcp into struct netns_ipvs
Message-ID: <20191024100855.GA21854@verge.net.au>
References: <20191023165303.259361-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023165303.259361-1-edumazet@google.com>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 09:53:03AM -0700, Eric Dumazet wrote:
> syzbot reported the following issue :
> 
> BUG: KCSAN: data-race in update_defense_level / update_defense_level
> 
> read to 0xffffffff861a6260 of 4 bytes by task 3006 on cpu 1:
>  update_defense_level+0x621/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:177
>  defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
>  process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
>  worker_thread+0xa0/0x800 kernel/workqueue.c:2415
>  kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> 
> write to 0xffffffff861a6260 of 4 bytes by task 7333 on cpu 0:
>  update_defense_level+0xa62/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:205
>  defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
>  process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
>  worker_thread+0xa0/0x800 kernel/workqueue.c:2415
>  kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 7333 Comm: kworker/0:5 Not tainted 5.4.0-rc3+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events defense_work_handler
> 
> Indeed, old_secure_tcp is currently a static variable, while it
> needs to be a per netns variable.
> 
> Fixes: a0840e2e165a ("IPVS: netns, ip_vs_ctl local vars moved to ipvs struct.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Wensong Zhang <wensong@linux-vs.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Julian Anastasov <ja@ssi.bg>

Thanks Eric,

I will apply this to the ipvs tree which feeds into the nf tree.
