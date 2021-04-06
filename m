Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A600354DDE
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 09:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhDFHbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 03:31:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:43328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233476AbhDFHbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 03:31:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 584DAAE6D;
        Tue,  6 Apr 2021 07:31:16 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id AC7EE60441; Tue,  6 Apr 2021 09:31:15 +0200 (CEST)
Date:   Tue, 6 Apr 2021 09:31:15 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Hillf Danton <hdanton@sina.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Jike Song <albcamus@gmail.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
Message-ID: <20210406073115.3h6zehyteagav3f7@lion.mk-sys.cz>
References: <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com>
 <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
 <CAM_iQpU+YD9AcX_77kqmQkqKMuOtnRh5xoGcz9dRRJTe1OnpBQ@mail.gmail.com>
 <2b99fce1-c235-6083-bd39-cece1f4a0343@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b99fce1-c235-6083-bd39-cece1f4a0343@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 10:46:29AM +0800, Yunsheng Lin wrote:
> On 2021/4/6 9:49, Cong Wang wrote:
> > On Sat, Apr 3, 2021 at 5:23 AM Jiri Kosina <jikos@kernel.org> wrote:
> >>
> >> I am still planning to have Yunsheng Lin's (CCing) fix [1] tested in the
> >> coming days. If it works, then we can consider proceeding with it,
> >> otherwise I am all for reverting the whole NOLOCK stuff.
> >>
> >> [1] https://lore.kernel.org/linux-can/1616641991-14847-1-git-send-email-linyunsheng@huawei.com/T/#u
> > 
> > I personally prefer to just revert that bit, as it brings more troubles
> > than gains. Even with Yunsheng's patch, there are still some issues.
> > Essentially, I think the core qdisc scheduling code is not ready for
> > lockless, just look at those NOLOCK checks in sch_generic.c. :-/
> 
> I am also awared of the NOLOCK checks too:), and I am willing to
> take care of it if that is possible.
> 
> As the number of cores in a system is increasing, it is the trend
> to become lockless, right? Even there is only one cpu involved, the
> spinlock taking and releasing takes about 30ns on our arm64 system
> when CONFIG_PREEMPT_VOLUNTARY is enable(ip forwarding testing).

I agree with the benefits but currently the situation is that we have
a race condition affecting the default qdisc which is being hit in
production and can cause serious trouble which is made worse by commit
1f3279ae0c13 ("tcp: avoid retransmits of TCP packets hanging in host
queues") preventing the retransmits of the stuck packet being sent.

Perhaps rather than patching over current implementation which requires
more and more complicated hacks to work around the fact that we cannot
make the "queue is empty" check and leaving the critical section atomic,
it would make sense to reimplement it in a way which would allow us
making it atomic.

Michal

