Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B912F3E00A5
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhHDL6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhHDL6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 07:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29C0160F35;
        Wed,  4 Aug 2021 11:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628078320;
        bh=LJBJCrhl39KpTuoLDAyWbjwe4EwfyvbbF1TeIgxZ8bU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VbBKYcDCjjjboTl/NBxyofb9sEFrooBRAE9zAYX1fK4WD0+5L+umjnuzS2GVVCk/E
         I9c6tjUZG1FHO3JVY2NpcUveb+W97wCPgZZFK+iludT1HBzx5orTWj1BUTt7JQUOG9
         PTyfTIolo5c2XHjBizdhuMqD8Jr3ROyekyWqHLtMeLXhlr89Leh/UtXUpDRofVZAJH
         IU4yvTZOhplwrcFKKehg+Di9HdlpGR7dsQkMmlv+zpIE0HX5rU583Po/X1unvcjPD1
         xypHjRcNpR6YNxDQvQzblVhQYndPStR/cw2EKfeXbsYGx4LHFKXKveyRbgQs9KO4DF
         Yt3XEUBXYIVqg==
Date:   Wed, 4 Aug 2021 04:58:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     petkan@nucleusys.com, davem@davemloft.net,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: pegasus: fix uninit-value in
 get_interrupt_interval
Message-ID: <20210804045839.101fe0f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9576d0cc-1f3e-4acc-4009-79fb2dbeda34@gmail.com>
References: <20210730214411.1973-1-paskripkin@gmail.com>
        <9576d0cc-1f3e-4acc-4009-79fb2dbeda34@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021 13:44:05 +0300 Pavel Skripkin wrote:
> On 7/31/21 12:44 AM, Pavel Skripkin wrote:
> > Syzbot reported uninit value pegasus_probe(). The problem was in missing
> > error handling.
> > 
> > get_interrupt_interval() internally calls read_eprom_word() which can
> > fail in some cases. For example: failed to receive usb control message.
> > These cases should be handled to prevent uninit value bug, since
> > read_eprom_word() will not initialize passed stack variable in case of
> > internal failure.
> > 
> > Fail log:
> > 
> > BUG: KMSAN: uninit-value in get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
> > BUG: KMSAN: uninit-value in pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
> > CPU: 1 PID: 825 Comm: kworker/1:1 Not tainted 5.12.0-rc6-syzkaller #0
> > ...
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:79 [inline]
> >   dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
> >   kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
> >   __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
> >   get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
> >   pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
> > ....
> > 
> > Local variable ----data.i@pegasus_probe created at:
> >   get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
> >   pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152
> >   get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
> >   pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152
> > 
> > Reported-and-tested-by: syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> Hi, David and Jakub!
> 
> Should I rebase this patch on top of Petko's clean-up patches? :
> 
> 1. https://git.kernel.org/netdev/net/c/8a160e2e9aeb
> 2. https://git.kernel.org/netdev/net/c/bc65bacf239d

Yes, rebase on top of net, the patches are there. Please mark the new
submission as [PATCH net v2].
