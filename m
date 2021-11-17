Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056DB454894
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbhKQOYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:24:34 -0500
Received: from 163-172-96-212.rev.poneytelecom.eu ([163.172.96.212]:46548 "EHLO
        1wt.eu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S238556AbhKQOXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:23:19 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 1AHEKCvr008703;
        Wed, 17 Nov 2021 15:20:12 +0100
Date:   Wed, 17 Nov 2021 15:20:12 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+6f8ddb9f2ff4adf065cb@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: refcount bug in __linkwatch_run_queue
Message-ID: <20211117142012.GB6276@1wt.eu>
References: <000000000000e4810705d0e479d5@google.com>
 <20211117081907.GA6276@1wt.eu>
 <20211117061548.63c25223@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117061548.63c25223@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 06:15:48AM -0800, Jakub Kicinski wrote:
> On Wed, 17 Nov 2021 09:19:07 +0100 Willy Tarreau wrote:
> > Thanks for the report. I'm seeing that linkwatch_do_dev() is also
> > called in linkwatch_forget_dev(), and am wondering if we're not
> > seeing a sequence like this one:
> > 
> >   linkwatch_forget_dev()
> >     list_del_init()
> >     linkwatch_do_dev()
> >       netdev_state_change()
> >         ... one of the notifiers
> >            ... linkwatch_add_event() => adds to watch list
> >       dev_put()
> >   ...
> >   
> >   __linkwatch_run_queue()
> >     linkwatch_do_dev()
> >       dev_put()
> >         => bang!  
> > 
> > Well, in theory, no, since linkwatch_add_event() will call dev_hold()
> > when adding to the list, so we ought to leave the first call with a
> > refcount still covering the list's presence, and I don't see how it
> > can reach zero before reaching dev_put() in linkwatch_do_dev() as this
> > function is only called when the event was picked from the list.
> > 
> > The only difference I'm seeing is that before the patch, a call to
> > linkwatch_forget_dev() on a non-present device would call dev_put()
> > without going through dev_activate(), dev_deactivate(), nor
> > netdev_state_change(), but I'm not seeing how that could make a
> > difference. linkwatch_forget_dev() is called from netdev_wait_allrefs()
> > which will wait for the refcnt to be exactly 1, thus even if we queue
> > an extra event we cant leave that function until the event has been
> > processed.
> 
> The ref leak could come from anywhere, tho. Like:
> 
> https://lore.kernel.org/all/87a6i3t2zg.fsf@nvidia.com/

OK thanks for the link, so better wait for this part to clarify itself
and see if the issue magically disappears ?

Willy
