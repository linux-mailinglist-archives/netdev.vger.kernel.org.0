Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55733382F11
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 16:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbhEQONA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 10:13:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40508 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238596AbhEQOLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 10:11:22 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9134B64147;
        Mon, 17 May 2021 16:09:10 +0200 (CEST)
Date:   Mon, 17 May 2021 16:10:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] WARNING in __nf_unregister_net_hook (4)
Message-ID: <20210517141001.GA23573@salvia>
References: <0000000000008ce91e05bf9f62bc@google.com>
 <CACT4Y+a6L_x22XNJVX+VYY-XKmLQ0GaYndCVYnaFmoxk58GPgw@mail.gmail.com>
 <20210508144657.GC4038@breakpoint.cc>
 <20210513005608.GA23780@salvia>
 <CACT4Y+YhQQtHBErLYRDqHyw16Bxu9FCMQymviMBR-ywiKf3VQw@mail.gmail.com>
 <20210517105745.GA19031@salvia>
 <CACT4Y+Y1M7ewJmipTB=B4fbYR2DMn_kX69Vks93yo=g2g-iXKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y1M7ewJmipTB=B4fbYR2DMn_kX69Vks93yo=g2g-iXKw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 02:42:41PM +0200, Dmitry Vyukov wrote:
> On Mon, May 17, 2021 at 12:57 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Sat, May 08, 2021 at 04:46:57PM +0200, Florian Westphal wrote:
> > > > > Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > > > Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
> > > > > >
> > > > > > Is this also fixed by "netfilter: arptables: use pernet ops struct
> > > > > > during unregister"?
> > > > > > The warning is the same, but the stack is different...
> > > > >
> > > > > No, this is a different bug.
> > > > >
> > > > > In both cases the caller attempts to unregister a hook that the core
> > > > > can't find, but in this case the caller is nftables, not arptables.
> > > >
> > > > I see no reproducer for this bug. Maybe I broke the dormant flag handling?
> > > >
> > > > Or maybe syzbot got here after the arptables bug has been hitted?
> > >
> > > syzbot always stops after the first bug to give you perfect "Not
> > > tainted" oopses.
> >
> > Looking at the log file:
> >
> > https://syzkaller.appspot.com/text?tag=CrashLog&x=110a3096d00000
> >
> > This is mixing calls to nftables:
> >
> > 14:43:16 executing program 0:
> > r0 = socket$nl_netfilter(0x10, 0x3, 0xc)
> > sendmsg$NFT_BATCH(r0, &(0x7f000000c2c0)={0x0, 0x0, &(0x7f0000000000)={&(0x7f00000001c0)={{0x9}, [@NFT_MSG_NEWTABLE={0x28, 0x0, 0xa, 0x3, 0x0, 0x0, {0x2}, [@NFTA_TABLE_NAME={0x9, 0x1, 'syz0\x00'}, @NFTA_TABLE_FLAGS={0x8}]}], {0x14}}, 0x50}}, 0x0)
> >
> > with arptables:
> >
> > 14:43:16 executing program 1:
> > r0 = socket$inet_udp(0x2, 0x2, 0x0)
> > setsockopt$ARPT_SO_SET_REPLACE(r0, 0x0, 0x60, &(0x7f0000000000)={'filter\x00', 0x4, 0x4, 0x3f8, 0x310, 0x200, 0x200, 0x310, 0x310, 0x310, 0x4, 0x0, {[{{@arp={@broadcast, @rand_addr, 0x87010000, 0x0, 0x0, 0x0, {@mac=@link_local}, {@mac}, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 'bridge0\x00', 'erspan0\x00'}, 0xc0, 0x100}, @unspec=@RATEEST={0x40, 'RATEEST\x00', 0x0, {'syz1\x00', 0x0, 0x4}}}, {{@arp={@initdev={0xac, 0x1e, 0x0, 0x0}, @local, 0x0, 0x0, 0x0, 0x0, {@mac=@remote}, {}, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 'veth0_to_bridge\x00', 'geneve1\x00'}, 0xc0, 0x100}, @unspec=@RATEEST={0x40, 'RATEEST\x00', 0x0, {'syz0\x00', 0x0, 0x2}}}, {{@arp={@local, @multicast1, 0x0, 0x0, 0x0, 0x0, {}, {@mac=@broadcast}, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 'veth0_to_batadv\x00', 'veth0_to_hsr\x00'}, 0xc0, 0x110}, @mangle={0x50, 'mangle\x00', 0x0, {@mac=@remote, @mac=@local, @multicast2, @initdev={0xac, 0x1e, 0x0, 0x0}}}}], {{[], 0xc0, 0xe8}, {0x28}}}}, 0x448)
> >
> > arptables was buggy at the time this bug has been reported.
> >
> > Am I understanding correctly the syzbot log?
> >
> > I wonder if the (buggy) arptables removed the incorrect hook from
> > nftables, then nftables crashed on the same location when removing the
> > hook. I don't see a clear sequence for this to happen though.
> >
> > Would it be possible to make syzbot exercise the NFT_MSG_NEWTABLE
> > codepath (with NFTA_TABLE_FLAGS) to check if the problem still
> > persists?
> 
> 
> This happened only once so far 40 days ago. So if you consider it
> possible that it actually happened due to the arptables issue, I would
> mark it as invalid (with "#syz invalid") and move on. If it ever
> happens again, syzbot will notify, but then we know it happened with
> the aprtables issue fixed.
> 
> This bug does not have a reproducer, so it's not possible to test this
> exact scenario. It's possible to replay the whole log, but somehow
> syzkaller wasn't able to retrigger it by replaying the log. I don't
> think it's worth our time at this point.

Thanks.

I found the root cause, I was getting confused by the arptables
report. I'll post a patch.
