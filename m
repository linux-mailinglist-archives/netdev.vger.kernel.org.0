Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB60404656
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 09:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352706AbhIIHjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 03:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352673AbhIIHjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 03:39:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7704610C8;
        Thu,  9 Sep 2021 07:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631173083;
        bh=G8dIbrfxtwN7bHv9jJEy5cNrYx5bTUZCOlKCvFnU1zU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Aty7Gz7qNcla63No/ematLo+Yyy3hYH6yUYy6c15xnbwhwnHTuA+9AixivrLDnP/i
         UTItRdKrMbq1GMTDgAPZNjEmCARjOhoQhMb2mhHKYvn9zxpEE5z1oHicI97i61gmmA
         3TLZnAhVBdJfVKqzw2DVtLfPBIA+fTSJKENMpTnw=
Date:   Thu, 9 Sep 2021 08:20:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        syzbot <syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        stable@vger.kernel.org, elbrus@debian.org
Subject: Re: [syzbot] general protection fault in nft_set_elem_expr_alloc
Message-ID: <YTmnpquHt3+02t9k@kroah.com>
References: <000000000000ef07b205c3cb1234@google.com>
 <20210602170317.GA18869@salvia>
 <YTkj4xH2Ol075+Ge@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTkj4xH2Ol075+Ge@eldamar.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 10:58:11PM +0200, Salvatore Bonaccorso wrote:
> Hi Pablo,
> 
> On Wed, Jun 02, 2021 at 07:03:17PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jun 02, 2021 at 09:37:26AM -0700, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    6850ec97 Merge branch 'mptcp-fixes-for-5-13'
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1355504dd00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=ce96ca2b1d0b37c6422d
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1502d517d00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bbbe13d00000
> > > 
> > > The issue was bisected to:
> > > 
> > > commit 05abe4456fa376040f6cc3cc6830d2e328723478
> > > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Date:   Wed May 20 13:44:37 2020 +0000
> > > 
> > >     netfilter: nf_tables: allow to register flowtable with no devices
> > > 
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fa1387d00000
> > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fa1387d00000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14fa1387d00000
> > > 
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com
> > > Fixes: 05abe4456fa3 ("netfilter: nf_tables: allow to register flowtable with no devices")
> > > 
> > > general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
> > > KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
> > > CPU: 1 PID: 8438 Comm: syz-executor343 Not tainted 5.13.0-rc3-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > RIP: 0010:nft_set_elem_expr_alloc+0x17e/0x280 net/netfilter/nf_tables_api.c:5321
> > > Code: 48 c1 ea 03 80 3c 02 00 0f 85 09 01 00 00 49 8b 9d c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d9 00 00 00 48 8b 5b 70 48 85 db 74 21 e8 9a bd
> > 
> > It's a real bug. Bisect is not correct though.
> > 
> > I'll post a patch to fix it. Thanks.
> 
> So if I see it correctly the fix landed in ad9f151e560b ("netfilter:
> nf_tables: initialize set before expression setup") in 5.13-rc7 and
> landed as well in 5.12.13. The issue is though still present in the
> 5.10.y series.
> 
> Would it be possible to backport the fix as well to 5.10.y? It is
> needed there as well.

I would need a working backport, as it does not apply cleanly to 5.10.y
:(

thanks,

greg k-h
