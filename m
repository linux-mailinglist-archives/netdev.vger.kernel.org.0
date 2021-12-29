Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B108848113F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 10:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbhL2JXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 04:23:10 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:53942 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbhL2JXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 04:23:09 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 05FDF210F5;
        Wed, 29 Dec 2021 09:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640769788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gjX2JYCUdKwjWkhra23pQM3tjKutHM/bK/bDmjsIPDU=;
        b=tqrBwF3RX9GUX92t/0vZapYED2/vSBw2fZn1Zn9vIlF1qh0L8XXqQswGcI46ShHO0z876G
        1UXw3I2gAszRlQJTgvi8/tzhXvg8nWv52piIs0oANEkwUmKPyeIM1Tq7Hcr8MWX+GUrjCc
        rbQtyiQgxKzSNTG5O/qeQUQwCXRFQ9U=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B984CA3B83;
        Wed, 29 Dec 2021 09:23:07 +0000 (UTC)
Date:   Wed, 29 Dec 2021 10:23:07 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     syzbot <syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com, mptcp@lists.linux.dev,
        netdev@vger.kernel.org
Subject: Re: [syzbot] WARNING in page_counter_cancel (3)
Message-ID: <Ycwo+++dToWQ1RMR@dhcp22.suse.cz>
References: <00000000000021bb9b05d14bf0c7@google.com>
 <000000000000f1504c05d36c21ea@google.com>
 <20211221155736.90bbc5928bcd779e76ca8f95@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221155736.90bbc5928bcd779e76ca8f95@linux-foundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 21-12-21 15:57:36, Andrew Morton wrote:
> On Sat, 18 Dec 2021 06:04:22 -0800 syzbot <syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com> wrote:
> 
> > syzbot has found a reproducer for the following issue on:
> > 
> > HEAD commit:    fbf252e09678 Add linux-next specific files for 20211216
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1797de99b00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7fcbb9aa19a433c8
> > dashboard link: https://syzkaller.appspot.com/bug?extid=bc9e2d2dbcb347dd215a
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135d179db00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113edb6db00000
> 
> Useful to have that, thanks.
> 
> I'm suspecting that mptcp is doing something strange.

Yes.

> Could I as the
> developers to please take a look?
> 
> 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com
> > 
> > R13: 00007ffdeb858640 R14: 00007ffdeb858680 R15: 0000000000000004
> >  </TASK>
> > ------------[ cut here ]------------
> > page_counter underflow: -4294966651 nr_pages=4294967295

__mptcp_mem_reclaim_partial is trying to uncharge (via
__sk_mem_reduce_allocated) negative amount. nr_pages has overflown when
converted from int to unsigned int (-1). I would say that
__mptcp_mem_reclaim_partial has evaluated
	reclaimable = mptcp_sk(sk)->rmem_fwd_alloc - sk_unused_reserved_mem(sk)
to 0 and __mptcp_rmem_reclaim(sk, reclaimable - 1) made it -1.
-- 
Michal Hocko
SUSE Labs
