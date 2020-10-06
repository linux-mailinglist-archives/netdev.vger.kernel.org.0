Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D632848DB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJFI4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:56:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:45466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFI4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 04:56:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 491D6AD08;
        Tue,  6 Oct 2020 08:56:46 +0000 (UTC)
Message-ID: <0b0de451147224657e5ac42d755c05447ee530b0.camel@suse.de>
Subject: Re: INFO: task hung in hub_port_init
From:   Oliver Neukum <oneukum@suse.de>
To:     syzbot <syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, gustavoars@kernel.org,
        ingrassia@epigenesys.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        niklas.soderlund+renesas@ragnatech.se, pablo@netfilter.org,
        sergei.shtylyov@cogentembedded.com, syzkaller-bugs@googlegroups.com
Date:   Tue, 06 Oct 2020 10:56:40 +0200
In-Reply-To: <0000000000004831d405b0fc41d2@google.com>
References: <0000000000004831d405b0fc41d2@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, den 06.10.2020, 01:19 -0700 schrieb syzbot:

Hi,

> HEAD commit:    d3d45f82 Merge tag 'pinctrl-v5.9-2' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14c3b3db900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
> dashboard link: https://syzkaller.appspot.com/bug?extid=74d6ef051d3d2eacf428
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153bf5bd900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124c92af900000
> 
> The issue was bisected to:
> 
> commit 6dcf45e514974a1ff10755015b5e06746a033e5f
> Author: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Date:   Mon Jan 9 15:34:04 2017 +0000
> 
>     sh_eth: use correct name for ECMR_MPDE bit

I am afraid this has bisected a race condition into neverland.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152bb760500000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=172bb760500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=132bb760500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com
> Fixes: 6dcf45e51497 ("sh_eth: use correct name for ECMR_MPDE bit")
> 
> INFO: task kworker/0:0:5 blocked for more than 143 seconds.
>       Not tainted 5.9.0-rc7-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/0:0     state:D stack:27664 pid:    5 ppid:     2 flags:0x00004000
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  context_switch kernel/sched/core.c:3778 [inline]
>  __schedule+0xec9/0x2280 kernel/sched/core.c:4527
>  schedule+0xd0/0x2a0 kernel/sched/core.c:4602

By this time urb_dequeue() has been killed and has returned.

>  usb_kill_urb.part.0+0x197/0x220 drivers/usb/core/urb.c:696
>  usb_kill_urb+0x7c/0x90 drivers/usb/core/urb.c:691
>  usb_start_wait_urb+0x24a/0x2b0 drivers/usb/core/message.c:64
>  usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
>  usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
>  hub_port_init+0x11ae/0x2d80 drivers/usb/core/hub.c:4689
>  hub_port_connect drivers/usb/core/hub.c:5140 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
>  port_event drivers/usb/core/hub.c:5494 [inline]
> 

This looks like it should.

Which HC driver are you using for these tests? It looks like
the HCD is not acting on urb_dequeue(), rather than a locking
issue.

	Regards
		Oliver


