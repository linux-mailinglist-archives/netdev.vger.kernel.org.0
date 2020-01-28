Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82DA14B4E5
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 14:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgA1N3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 08:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgA1N3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 08:29:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CDFF22522;
        Tue, 28 Jan 2020 13:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580218190;
        bh=6ZWtuJeJGD/vSdabZ+Y8n3PzjfZ41WaLfTxUqO7NTS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LTtQjKO6EYlnnorbv7eYnezhDMhehRtItnN54RZ1s43CGNB4vbPgOIzeXdQ8tEvmr
         XOzUXi1iLehhViF7oiXMNQSHuPwzbzqEIvSC7/f3H85S3WeLaqf0R2Cngz10NvL8gv
         bHg154WREvL5LqrTjfXxWY4NAWI9GfFvbzZi9Mhs=
Date:   Tue, 28 Jan 2020 14:29:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@unikie.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, syzkaller@googlegroups.com
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
Message-ID: <20200128132941.GA2956977@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
 <20191128073623.GE3317872@kroah.com>
 <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com>
 <20191129085800.GF3584430@kroah.com>
 <87sgk8szhc.fsf@unikie.com>
 <87zhe727uo.fsf@unikie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zhe727uo.fsf@unikie.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 12:28:15PM +0200, Jouni Högander wrote:
> Hello Greg,
> 
> jouni.hogander@unikie.com (Jouni Högander) writes:
> 
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >>> > Now queued up, I'll push out -rc2 versions with this fix.
> >>> >
> >>> > greg k-h
> >>> 
> >>> We have also been informed about another regression these two commits
> >>> are causing:
> >>> 
> >>> https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp/
> >>> 
> >>> I suggest to drop these two patches from this queue, and give us a
> >>> week to shake out the regressions of the change, and once ready, we
> >>> can include the complete set of fixes to stable (probably in a week or
> >>> two).
> >>
> >> Ok, thanks for the information, I've now dropped them from all of the
> >> queues that had them in them.
> >>
> >> greg k-h
> >
> > I have now run more extensive Syzkaller testing on following patches:
> >
> > cb626bf566eb net-sysfs: Fix reference count leak
> > ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
> > e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
> > 48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
> > b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> >
> > These patches are fixing couple of memory leaks including this one found
> > by Syzbot: https://syzkaller.appspot.com/bug?extid=ad8ca40ecd77896d51e2
> >
> > I can reproduce these memory leaks in following stable branches: 4.14,
> > 4.19, and 5.4.
> >
> > These are all now merged into net/master tree and based on my testing
> > they are ready to be taken into stable branches as well.
> >
> > Best Regards,
> >
> > Jouni Högander
> 
> These four patches are still missing from 4.14 and 4.19 branches:
> 
> ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
> e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
> 48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
> b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> 
> Could you please consider taking them in or let me know if you want some
> further activities from my side?

Thanks for the list, I have now queued these all up.

greg k-h
