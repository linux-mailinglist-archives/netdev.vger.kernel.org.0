Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44355E6F5
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfGCOkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:40:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38128 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCOkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:40:09 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1higQS-0005D2-Mk; Wed, 03 Jul 2019 14:40:00 +0000
Date:   Wed, 3 Jul 2019 15:40:00 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+d88a977731a9888db7ba@syzkaller.appspotmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel panic: corrupted stack end in dput
Message-ID: <20190703144000.GH17978@ZenIV.linux.org.uk>
References: <20190703064307.13740-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703064307.13740-1-hdanton@sina.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 02:43:07PM +0800, Hillf Danton wrote:

> > This is very much *NOT* fine.
> > 	1) trylock can fail from any number of reasons, starting
> > with "somebody is going through the hash chain doing a lookup on
> > something completely unrelated"
> 
> They are also a red light that we need to bail out of spiraling up
> the directory hierarchy imho.

Translation: "let's leak the reference to parent, shall we?"

> > 	2) whoever had been holding the lock and whatever they'd
> > been doing might be over right after we get the return value from
> > spin_trylock().
> 
> Or after we send a mail using git. I don't know.
> 
> > 	3) even had that been really somebody adding children in
> > the same parent *AND* even if they really kept doing that, rather
> > than unlocking and buggering off, would you care to explain why
> > dentry_unlist() called by __dentry_kill() and removing the victim
> > from the list of children would be safe to do in parallel with that?
> >
> My bad. I have to walk around that unsafety.

WHAT unsafety?  Can you explain what are you seeing and how to
reproduce it, whatever it is?
