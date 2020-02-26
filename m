Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECC31708C2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 20:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgBZTO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 14:14:29 -0500
Received: from correo.us.es ([193.147.175.20]:33608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbgBZTO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 14:14:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ACCACFFB62
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 20:14:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9EA4BDA3A3
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 20:14:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94477DA38F; Wed, 26 Feb 2020 20:14:19 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAA81DA72F;
        Wed, 26 Feb 2020 20:14:17 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 20:14:17 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9A6BD42EF42A;
        Wed, 26 Feb 2020 20:14:17 +0100 (CET)
Date:   Wed, 26 Feb 2020 20:14:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com>
Subject: Re: [Patch nf] netfilter: xt_hashlimit: unregister proc file before
 releasing mutex
Message-ID: <20200226191425.3h2i3rn4xdanzfde@salvia>
References: <20200213065352.6310-1-xiyou.wangcong@gmail.com>
 <20200218213524.5yuccwnl2eie6p6x@salvia>
 <CAM_iQpWfb7xgd2LuRmaXhRSJskJPsupFk0A7=dRXtMEjZJjr3w@mail.gmail.com>
 <20200218220507.cqlhd4kj4ukyjhuu@salvia>
 <CAM_iQpUYGVpUCatMHVKSx4jM9c6kbYxcWBV0--1mrQi6NbPhhg@mail.gmail.com>
 <20200226181106.ekb2mpmtgbxrpepz@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226181106.ekb2mpmtgbxrpepz@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 07:11:06PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Feb 19, 2020 at 07:32:13PM -0800, Cong Wang wrote:
> > On Tue, Feb 18, 2020 at 2:05 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Tue, Feb 18, 2020 at 01:40:26PM -0800, Cong Wang wrote:
> > > > On Tue, Feb 18, 2020 at 1:35 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > >
> > > > > On Wed, Feb 12, 2020 at 10:53:52PM -0800, Cong Wang wrote:
> > > > > > Before releasing the global mutex, we only unlink the hashtable
> > > > > > from the hash list, its proc file is still not unregistered at
> > > > > > this point. So syzbot could trigger a race condition where a
> > > > > > parallel htable_create() could register the same file immediately
> > > > > > after the mutex is released.
> > > > > >
> > > > > > Move htable_remove_proc_entry() back to mutex protection to
> > > > > > fix this. And, fold htable_destroy() into htable_put() to make
> > > > > > the code slightly easier to understand.
> > > > >
> > > > > Probably revert previous one?
> > > >
> > > > The hung task could appear again if we move the cleanup
> > > > back under mutex.
> > >
> > > How could the hung task appear again by reverting
> > > c4a3922d2d20c710f827? Please elaborate.
> > 
> > Because the cfg.max could be as large as 8*HASHLIMIT_MAX_SIZE:
> > 
> >  311         if (hinfo->cfg.max == 0)
> >  312                 hinfo->cfg.max = 8 * hinfo->cfg.size;
> >  313         else if (hinfo->cfg.max < hinfo->cfg.size)
> >  314                 hinfo->cfg.max = hinfo->cfg.size;
> > 
> > Not sure whether we can finish cleaning up 8*HASHLIMIT_MAX_SIZE
> > entries within the time a hung task tolerates. This largely depends on
> > how much contention the spinlock has, at least I don't want to bet
> > on it.
> 
> Please, resend. Thanks.

Sorry, I meant, applied, thanks.
