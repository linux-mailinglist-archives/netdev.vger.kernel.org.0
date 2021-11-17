Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2692454853
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbhKQOSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238297AbhKQOSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:18:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1C8B61B54;
        Wed, 17 Nov 2021 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637158549;
        bh=9PsiYQMqsw7CpKzJ298/9FVkI9sfmobRsVzf6iXIO2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HkGVWv9M01OXN2Z7KtoX5m+PYNlBReYR/oWJ2sNLdh9UytJJD3/lBayuavnVhPR6f
         osM7F/pa4yN+r9qolCJ1St3IzLwEcu+ZPnbXzFYMaNqAN42p1/o9NnfcuqZLgIYyoT
         zzgLZmgnGqLLX4JMdAANpuoq+fuMCWhrfTKMZSdxkNB1Lsv4Et5uWL2ndgucAAKnE6
         d0q6S/m2VaIJxYgvBko2DQKSWL2wdRkulGQ1iUA8ze/dKFw6SwGyuI6eRsYD9HmLSX
         wG+XySRhjWEcx3EVfQWLutXFBJZK1uFgN7pfL51tCuuEGDTR0jiIUzdIA2VTXCqEKB
         o5Pe6vaywVjPw==
Date:   Wed, 17 Nov 2021 06:15:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     syzbot <syzbot+6f8ddb9f2ff4adf065cb@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: refcount bug in __linkwatch_run_queue
Message-ID: <20211117061548.63c25223@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211117081907.GA6276@1wt.eu>
References: <000000000000e4810705d0e479d5@google.com>
        <20211117081907.GA6276@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 09:19:07 +0100 Willy Tarreau wrote:
> Thanks for the report. I'm seeing that linkwatch_do_dev() is also
> called in linkwatch_forget_dev(), and am wondering if we're not
> seeing a sequence like this one:
> 
>   linkwatch_forget_dev()
>     list_del_init()
>     linkwatch_do_dev()
>       netdev_state_change()
>         ... one of the notifiers
>            ... linkwatch_add_event() => adds to watch list
>       dev_put()
>   ...
>   
>   __linkwatch_run_queue()
>     linkwatch_do_dev()
>       dev_put()
>         => bang!  
> 
> Well, in theory, no, since linkwatch_add_event() will call dev_hold()
> when adding to the list, so we ought to leave the first call with a
> refcount still covering the list's presence, and I don't see how it
> can reach zero before reaching dev_put() in linkwatch_do_dev() as this
> function is only called when the event was picked from the list.
> 
> The only difference I'm seeing is that before the patch, a call to
> linkwatch_forget_dev() on a non-present device would call dev_put()
> without going through dev_activate(), dev_deactivate(), nor
> netdev_state_change(), but I'm not seeing how that could make a
> difference. linkwatch_forget_dev() is called from netdev_wait_allrefs()
> which will wait for the refcnt to be exactly 1, thus even if we queue
> an extra event we cant leave that function until the event has been
> processed.

The ref leak could come from anywhere, tho. Like:

https://lore.kernel.org/all/87a6i3t2zg.fsf@nvidia.com/
